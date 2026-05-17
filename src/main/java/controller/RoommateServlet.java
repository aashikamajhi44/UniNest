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

                case "sendRequest":
                    int receiverId = Integer.parseInt(req.getParameter("receiverId"));
                    int propId     = Integer.parseInt(req.getParameter("propertyId"));
                    if (!roommateDAO.requestExists(user.getId(), receiverId, propId)) {
                        roommateDAO.sendRequest(user.getId(), receiverId, propId);
                        req.getSession().setAttribute("flashSuccess", "Connection request sent!");
                    } else {
                        req.getSession().setAttribute("flashError", "You already sent a request to this person.");
                    }
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=browse&propertyId=" + propId);
                    break;

                case "respond":
                    int requestId = Integer.parseInt(req.getParameter("requestId"));
                    roommateDAO.updateStatus(requestId, req.getParameter("status"));
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=myConnections");
                    break;

                default:
                    res.sendRedirect(req.getContextPath() + "/RoommateServlet?action=myConnections");
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, res);
        }
    }

    private User getUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (User) s.getAttribute("loggedUser") : null;
    }
}
