package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (loggedUser == null) {
            res.sendRedirect(req.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            User profileUser = userDAO.findById(loggedUser.getId());
            if (profileUser == null) {
                profileUser = loggedUser;
            }
            if ("admin".equals(profileUser.getRole())) {
                profileUser.setName("Super Admin");
            }
            req.setAttribute("profileUser", profileUser);
            req.getRequestDispatcher("/jsp/profile.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }
}
