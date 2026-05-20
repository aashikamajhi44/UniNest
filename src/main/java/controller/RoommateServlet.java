package controller;

import dao.RoommateDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * RoommateServlet handles:
 *  GET  ?action=browse&propertyId=X → view other tenants at a property
 *  GET  ?action=myConnections        → student's accepted connections + incoming requests
 *  POST ?action=sendRequest          → student sends connection request
 *  POST ?action=respond              → student accepts/rejects request
 */
public class RoommateServlet extends HttpServlet {

    private final RoommateDAO roommateDAO = new RoommateDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User   user   = getUser(req);
        String action = req.getParameter("action");
        if (action == null) action = "myConnections";

        try {
            requireStudent(req, res, user);
            switch (action) {

                case "browse":
                    int propId = Integer.parseInt(req.getParameter("propertyId"));
                    req.setAttribute("tenants",    roommateDAO.getTenantsForProperty(propId, user.getId()));
                    req.setAttribute("propertyId", propId);
                    req.getRequestDispatcher("/jsp/roommates.jsp").forward(req, res);
                    break;

                case "myConnections":
                    req.setAttribute("incoming",     roommateDAO.getIncoming(user.getId()));
                    req.setAttribute("connections",  roommateDAO.getAccepted(user.getId()));
                    req.setAttribute("viewMode",     "connections");
                    req.getRequestDispatcher("/jsp/roommates.jsp").forward(req, res);
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=myConnections");
            }
        } catch (Exception e) {
            if (res.isCommitted()) {
                return;
            }
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User   user   = getUser(req);
        String action = req.getParameter("action");

        try {
            requireStudent(req, res, user);
            switch (action == null ? "" : action) {

                case "sendRequest":
                    int receiverId = Integer.parseInt(req.getParameter("receiverId"));
                    int propId     = Integer.parseInt(req.getParameter("propertyId"));
                    if (receiverId == user.getId()) {
                        req.getSession().setAttribute("flashError", "You cannot send a roommate request to yourself.");
                    } else if (!roommateDAO.requestExists(user.getId(), receiverId, propId)) {
                        int requestId = roommateDAO.sendRequest(user.getId(), receiverId, propId);
                        if (requestId > 0) {
                            req.getSession().setAttribute("flashSuccess", "Connection request sent!");
                        } else {
                            req.getSession().setAttribute("flashError",
                                    "Both students must have accepted bookings for the same property.");
                        }
                    } else {
                        req.getSession().setAttribute("flashError", "A roommate request already exists for this property.");
                    }
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=browse&propertyId=" + propId);
                    break;

                case "respond":
                    int requestId = Integer.parseInt(req.getParameter("requestId"));
                    String status = normalizedStatus(req.getParameter("status"), "accepted", "rejected");
                    if (status == null) {
                        req.getSession().setAttribute("flashError", "Invalid roommate request status.");
                        res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=myConnections");
                        return;
                    }
                    boolean updated = roommateDAO.updateStatus(requestId, user.getId(), status);
                    req.getSession().setAttribute(updated ? "flashSuccess" : "flashError",
                            updated ? "Roommate request updated." : "That roommate request is not assigned to you.");
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=myConnections");
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=myConnections");
            }
        } catch (Exception e) {
            if (res.isCommitted()) {
                return;
            }
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }

    private User getUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (User) s.getAttribute("loggedUser") : null;
    }

    private void requireStudent(HttpServletRequest req, HttpServletResponse res, User user)
            throws IOException, ServletException {
        if (user == null || !"student".equals(user.getRole())) {
            req.setAttribute("errorMessage", "Only students can use the roommate feature.");
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
            throw new ServletException("Student access required.");
        }
    }

    private String normalizedStatus(String rawStatus, String... allowedStatuses) {
        if (rawStatus == null) {
            return null;
        }

        String candidate = rawStatus.trim().toLowerCase();
        for (String allowedStatus : allowedStatuses) {
            if (allowedStatus.equals(candidate)) {
                return candidate;
            }
        }
        return null;
    }
}

/* attribution: commit by Clauz5568 */
