package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * BookingServlet handles:
 *  GET  ?action=myBookings        → student's booking history
 *  GET  ?action=landlordBookings  → landlord's incoming requests
 *  POST ?action=send              → student sends booking request
 *  POST ?action=updateStatus      → landlord accepts/rejects
 */
public class BookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User   user   = getUser(req);
        String action = req.getParameter("action");
        if (action == null) action = "myBookings";

        try {
            switch (action) {

                case "myBookings":
                    requireRole(req, res, user, "student");
                    req.setAttribute("bookings", bookingDAO.getByStudent(user.getId()));
                    req.getRequestDispatcher("/jsp/booking.jsp").forward(req, res);
                    break;

                case "landlordBookings":
                    requireRole(req, res, user, "landlord");
                    req.setAttribute("bookings", bookingDAO.getByLandlord(user.getId()));
                    req.getRequestDispatcher("/jsp/booking.jsp").forward(req, res);
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/jsp/booking.jsp");
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
            switch (action == null ? "" : action) {

                case "send":
                    requireRole(req, res, user, "student");
                    int propId = Integer.parseInt(req.getParameter("propertyId"));
                    if (!bookingDAO.alreadyBooked(user.getId(), propId)) {
                        Booking b = new Booking();
                        b.setStudentId(user.getId());
                        b.setPropertyId(propId);
                        b.setMessage(req.getParameter("message"));
                        int bookingId = bookingDAO.insert(b);
                        if (bookingId > 0) {
                            req.getSession().setAttribute("flashSuccess", "Booking request sent successfully!");
                        } else {
                            req.getSession().setAttribute("flashError",
                                    "This property is not available for booking right now.");
                        }
                    } else {
                        req.getSession().setAttribute("flashError", "You already have a booking request for this property.");
                    }
                    res.sendRedirect(req.getContextPath() + "/BookingServlet?action=myBookings");
                    break;

                case "updateStatus":
                    requireRole(req, res, user, "landlord");
                    String bookingStatus = normalizedStatus(req.getParameter("status"), "accepted", "rejected");
                    if (bookingStatus == null) {
                        req.getSession().setAttribute("flashError", "Invalid booking status.");
                        res.sendRedirect(req.getContextPath() + "/BookingServlet?action=landlordBookings");
                        return;
                    }
                    boolean updated = bookingDAO.updateStatus(
                        Integer.parseInt(req.getParameter("bookingId")),
                        bookingStatus,
                        user.getId()
                    );
                    req.getSession().setAttribute(updated ? "flashSuccess" : "flashError",
                            updated ? "Booking status updated." : "That booking does not belong to your property.");
                    res.sendRedirect(req.getContextPath() + "/BookingServlet?action=landlordBookings");
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/jsp/booking.jsp");
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

    private void requireRole(HttpServletRequest req, HttpServletResponse res, User user, String role)
            throws IOException, ServletException {
        if (user == null || !role.equals(user.getRole())) {
            req.setAttribute("errorMessage", "Access denied.");
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
            throw new ServletException("Access denied.");
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
