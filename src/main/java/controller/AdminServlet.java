package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AdminServlet handles admin-only POST actions:
 *  POST ?action=verifyLandlord  → verify or revoke a landlord
 *  POST ?action=deleteUser      → delete any user
 */
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Role guard
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/jsp/error.jsp?code=403");
            return;
        }

        String action = req.getParameter("action");
        try {
            switch (action == null ? "" : action) {

                case "verifyLandlord":
                    int uid    = Integer.parseInt(req.getParameter("userId"));
                    boolean st = "1".equals(req.getParameter("status"));
                    userDAO.setVerified(uid, st);
                    session.setAttribute("flashSuccess", st ? "Landlord verified." : "Verification revoked.");
                    res.sendRedirect(req.getContextPath() + "/jsp/admin-dashboard.jsp?tab=landlords");
                    break;

                case "deleteUser":
                    int delId = Integer.parseInt(req.getParameter("userId"));
                    userDAO.delete(delId);
                    session.setAttribute("flashSuccess", "User deleted successfully.");
                    String from = req.getParameter("from");
                    String tab  = "landlord".equals(from) ? "landlords" : "students";
                    res.sendRedirect(req.getContextPath() + "/jsp/admin-dashboard.jsp?tab=" + tab);
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/jsp/admin-dashboard.jsp");
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }
}
