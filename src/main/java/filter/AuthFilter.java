package filter;

import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter — protects all pages that require a logged-in session.
 * Mapped in web.xml to JSP pages and Servlets that need authentication.
 * Also enforces role-based access (admin-only pages, student-only actions).
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse res  = (HttpServletResponse) response;
        HttpSession         session = req.getSession(false);

        String requestURI = req.getRequestURI();
        User   user       = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        // ---- Not logged in ----
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // ---- Admin-only area ----
        if (requestURI.contains("admin-dashboard") && !"admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/jsp/error.jsp?code=403");
            return;
        }

        // ---- Unverified landlord ----
        if ("landlord".equals(user.getRole()) && !user.isVerified()) {
            session.setAttribute("flashError", "Your account is awaiting admin verification.");
            res.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
