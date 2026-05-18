package controller;

import dao.BookingDAO;
import dao.PropertyDAO;
import model.Property;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;

/**
 * PropertyServlet handles:
 *  GET  ?action=list        → search/list approved properties (student)
 *  GET  ?action=detail&id=X → property detail page
 *  GET  ?action=myListings  → landlord's own listings
 *  GET  ?action=addForm     → show add-property form
 *  GET  ?action=editForm&id=X → show edit form
 *  GET  ?action=adminList   → admin view all properties
 *  POST ?action=add         → landlord adds property
 *  POST ?action=edit        → landlord edits property
 *  POST ?action=delete      → landlord deletes property
 *  POST ?action=approve     → admin approves/rejects property
 *  GET  ?action=logout      → destroy session
 */
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 8 * 1024 * 1024)
public class PropertyServlet extends HttpServlet {

    private final PropertyDAO propertyDAO = new PropertyDAO();
    private final BookingDAO  bookingDAO  = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";
        User user = getUser(req);

        try {
            switch (action) {

                case "list":
                    req.setAttribute("properties", propertyDAO.search(
                        req.getParameter("location"),
                        req.getParameter("roomType"),
                        req.getParameter("maxPrice")
                    ));
                    req.setAttribute("location", req.getParameter("location"));
                    req.setAttribute("roomType", req.getParameter("roomType"));
                    req.setAttribute("maxPrice", req.getParameter("maxPrice"));
                    req.getRequestDispatcher("/jsp/search.jsp").forward(req, res);
                    break;

                case "detail":
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("property", propertyDAO.findById(id));
                    req.setAttribute("alreadyBooked", user != null && bookingDAO.alreadyBooked(user.getId(), id));
                    req.getRequestDispatcher("/jsp/property-detail.jsp").forward(req, res);
                    break;

                case "myListings":
                    requireRole(req, res, "landlord");
                    req.setAttribute("listings", propertyDAO.getByLandlord(user.getId()));
                    req.getRequestDispatcher("/jsp/home.jsp").forward(req, res);
                    break;

                case "addForm":
                    requireRole(req, res, "landlord");
                    req.getRequestDispatcher("/jsp/home.jsp").forward(req, res);
                    break;

                case "editForm":
                    requireRole(req, res, "landlord");
                    req.setAttribute("editProperty", propertyDAO.findById(Integer.parseInt(req.getParameter("id"))));
                    req.setAttribute("listings", propertyDAO.getByLandlord(user.getId()));
                    req.getRequestDispatcher("/jsp/home.jsp").forward(req, res);
                    break;

                case "adminList":
                    requireRole(req, res, "admin");
                    req.setAttribute("properties", propertyDAO.getAll());
                    req.getRequestDispatcher("/jsp/admin-dashboard.jsp").forward(req, res);
                    break;

                case "logout":
                    HttpSession session = req.getSession(false);
                    if (session != null) {
                        session.invalidate();
                    }
                    res.sendRedirect(req.getContextPath() + "/index.jsp");
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/jsp/home.jsp");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid property ID.");
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        User   user   = getUser(req);

        try {
            switch (action == null ? "" : action) {

                case "add":
                    requireRole(req, res, "landlord");
                    Property np = buildFromRequest(req);
                    np.setLandlordId(user.getId());
                    propertyDAO.insert(np);
                    req.getSession().setAttribute("flashSuccess", "Property submitted for admin approval.");
                    res.sendRedirect(req.getContextPath() + "/PropertyServlet?action=myListings");
                    break;

                case "edit":
                    requireRole(req, res, "landlord");
                    Property ep = buildFromRequest(req);
                    ep.setId(Integer.parseInt(req.getParameter("propertyId")));
                    ep.setLandlordId(user.getId());
                    propertyDAO.update(ep);
                    req.getSession().setAttribute("flashSuccess", "Property updated successfully.");
                    res.sendRedirect(req.getContextPath() + "/PropertyServlet?action=myListings");
                    break;

                case "delete":
                    requireRole(req, res, "landlord");
                    propertyDAO.delete(Integer.parseInt(req.getParameter("propertyId")), user.getId());
                    req.getSession().setAttribute("flashSuccess", "Property deleted.");
                    res.sendRedirect(req.getContextPath() + "/PropertyServlet?action=myListings");
                    break;

                case "approve":
                    requireRole(req, res, "admin");
                    propertyDAO.updateStatus(
                        Integer.parseInt(req.getParameter("propertyId")),
                        req.getParameter("status")
                    );
                    res.sendRedirect(req.getContextPath() + "/PropertyServlet?action=adminList");
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/jsp/home.jsp");
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }

    // ---- Helpers ----

    private Property buildFromRequest(HttpServletRequest req) throws IOException, ServletException {
        Property p = new Property();
        p.setTitle(req.getParameter("title"));
        p.setDescription(req.getParameter("description"));
        p.setLocation(req.getParameter("location"));
        p.setPrice(new BigDecimal(req.getParameter("price")));
        p.setRoomType(req.getParameter("roomType"));
        p.setAmenities(req.getParameter("amenities"));
        String uploadedImage = saveUploadedImage(req);
        String existingImage = req.getParameter("existingImageUrl");
        p.setImageUrl(uploadedImage != null ? uploadedImage : existingImage);
        return p;
    }

    private String saveUploadedImage(HttpServletRequest req) throws IOException, ServletException {
        Part part = req.getPart("imageFile");
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String lowerName = submittedName.toLowerCase(Locale.ROOT);
        if (!(lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")
                || lowerName.endsWith(".png") || lowerName.endsWith(".gif")
                || lowerName.endsWith(".webp"))) {
            throw new ServletException("Please upload a JPG, PNG, GIF, or WebP image.");
        }

        String extension = lowerName.substring(lowerName.lastIndexOf('.'));
        String fileName = "property-" + System.currentTimeMillis() + extension;
        Path uploadDir = UploadServlet.getUploadDirectory();
        Files.createDirectories(uploadDir);
        Path target = uploadDir.resolve(fileName);
        try (java.io.InputStream input = part.getInputStream()) {
            Files.copy(input, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return req.getContextPath() + "/uploads/" + fileName;
    }

    private User getUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (User) s.getAttribute("loggedUser") : null;
    }

    private void requireRole(HttpServletRequest req, HttpServletResponse res, String role)
            throws IOException, ServletException {
        User user = getUser(req);
        if (user == null || !role.equals(user.getRole())) {
            req.setAttribute("errorMessage", "Access denied.");
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
            throw new ServletException("Access denied for role: " + role);
        }
    }
}
