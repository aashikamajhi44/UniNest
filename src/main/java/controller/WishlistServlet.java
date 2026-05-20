package controller;

import dao.WishlistDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.User;
import model.Wishlist;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class WishlistServlet extends HttpServlet {

    private final WishlistDAO dao = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User u = currentStudent(req, res);
        if (u == null) return;

        try {
            List<Wishlist> items = dao.getByStudent(u.getId());
            req.setAttribute("wishlist", items);
            req.getRequestDispatcher("/jsp/wishlist.jsp").forward(req, res);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User u = currentStudent(req, res);
        if (u == null) return;

        String action = req.getParameter("action");
        int propertyId;
        try { propertyId = Integer.parseInt(req.getParameter("propertyId")); }
        catch (Exception e) { res.sendRedirect(req.getContextPath() + "/WishlistServlet"); return; }

        HttpSession session = req.getSession();
        try {
            if ("remove".equals(action)) {
                dao.remove(u.getId(), propertyId);
                setFlash(session, "Removed from your wishlist.");
            } else { // toggle (default) or add
                boolean nowWishlisted = dao.toggle(u.getId(), propertyId);
                setFlash(session,
                    nowWishlisted ? "Saved to your wishlist." : "Removed from your wishlist.");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // Redirect back to the page the user came from when possible
        String back = req.getParameter("back");
        if (back == null || back.isBlank()) back = req.getContextPath() + "/WishlistServlet";
        res.sendRedirect(back);
    }

    private User currentStudent(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute("loggedUser");
        if (u == null || !"student".equals(u.getRole())) {
            res.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return null;
        }
        return u;
    }

    private void setFlash(HttpSession session, String message) {
        session.setAttribute("flashSuccess", message);
    }
}
