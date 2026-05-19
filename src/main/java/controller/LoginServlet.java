package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /** GET → show login page */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // If already logged in, redirect to home
        HttpSession session = req.getSession(false);
        Object loggedUser = session == null ? null : session.getAttribute("loggedUser");
        if (loggedUser instanceof User) {
            redirectByRole(res, req, (User) loggedUser);
            return;
        }

        if (loggedUser != null) {
            session.invalidate();
        }

        req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
    }

    /** POST → process login form */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email    = req.getParameter("email")    == null ? "" : req.getParameter("email").trim();
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");

        if (email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
            return;
        }

        try {
            User user = userDAO.login(email, password);

            if (user == null) {
                req.setAttribute("error", "Incorrect email or password.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
                return;
            }

            if ("landlord".equals(user.getRole()) && !user.isVerified()) {
                req.setAttribute("error", "Your account is pending admin verification. Please wait.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
                return;
            }

            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId",   user.getId());
            session.setAttribute("userName", "admin".equals(user.getRole()) ? "Super Admin" : user.getName());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 min

            redirectByRole(res, req, user);

        } catch (Throwable e) {
            req.setAttribute("error", "A system error occurred: " + e.getMessage());
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
        }
    }

    private void redirectByRole(HttpServletResponse res, HttpServletRequest req, User user)
            throws IOException {
        String ctx = req.getContextPath();
        switch (user.getRole()) {
            case "admin":    res.sendRedirect(ctx + "/jsp/admin-dashboard.jsp"); break;
            case "landlord": res.sendRedirect(ctx + "/jsp/home.jsp");            break;
            default:         res.sendRedirect(ctx + "/jsp/home.jsp");
        }
    }
}
