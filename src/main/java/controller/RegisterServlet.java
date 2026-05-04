package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name     = param(req, "name");
        String email    = param(req, "email");
        String password = param(req, "password");
        String confirm  = param(req, "confirmPassword");
        String phone    = param(req, "phone");
        String role     = param(req, "role");

        // ---- Validation ----
        if (name.isEmpty() || email.isEmpty() || password.isEmpty() || role.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
            return;
        }
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
            return;
        }
        if (!role.equals("student") && !role.equals("landlord")) {
            req.setAttribute("error", "Invalid role selected.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "This email is already registered. Please login.");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);   // hashed inside UserDAO
            user.setPhone(phone);
            user.setRole(role);

            int newId = userDAO.register(user);

            if (newId > 0) {
                String msg = "landlord".equals(role)
                    ? "Registered successfully! Please wait for admin verification before logging in."
                    : "Registered successfully! You can now log in.";
                req.setAttribute("success", msg);
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
            }
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);

        } catch (Exception e) {
            req.setAttribute("error", "A system error occurred: " + e.getMessage());
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
        }
    }

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return (v == null) ? "" : v.trim();
    }
}
