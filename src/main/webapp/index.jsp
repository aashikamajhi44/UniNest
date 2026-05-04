<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    } else if ("admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/jsp/admin-dashboard.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
    }
%>
