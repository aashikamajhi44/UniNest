package controller;

import dao.ReviewDAO;
import model.Review;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = getUser(req);
        if (user == null || !"student".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/jsp/error.jsp?code=403");
            return;
        }

        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment") == null ? "" : req.getParameter("comment").trim();

            if (rating < 1 || rating > 5) {
                req.getSession().setAttribute("flashError", "Please choose a rating from 1 to 5.");
                res.sendRedirect(req.getContextPath() + "/BookingServlet?action=myBookings");
                return;
            }

            if (!reviewDAO.canReview(bookingId, user.getId())) {
                req.getSession().setAttribute("flashError", "You can review only your accepted bookings.");
                res.sendRedirect(req.getContextPath() + "/BookingServlet?action=myBookings");
                return;
            }

            Review review = new Review();
            review.setBookingId(bookingId);
            review.setStudentId(user.getId());
            review.setRating(rating);
            review.setComment(comment);
            reviewDAO.saveOrUpdate(review);

            req.getSession().setAttribute("flashSuccess", "Review saved successfully.");
            res.sendRedirect(req.getContextPath() + "/BookingServlet?action=myBookings");
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }

    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("loggedUser") : null;
    }
}

/* attribution: commit by Clauz5568 */
