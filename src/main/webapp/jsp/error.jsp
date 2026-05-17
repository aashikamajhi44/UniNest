<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Error - UniNest</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card text-center">
    <div style="font-size:4rem;margin-bottom:1rem"></div>
    <h2 style="color:var(--danger);margin-bottom:.5rem">
      <c:choose>
        <c:when test="${param.code == '403'}">403 - Access Denied</c:when>
        <c:when test="${param.code == '404'}">404 - Page Not Found</c:when>
        <c:otherwise>Something Went Wrong</c:otherwise>
      </c:choose>
    </h2>
    <p style="color:var(--gray-500);margin-bottom:1.5rem">
      <c:choose>
        <c:when test="${not empty errorMessage}">${errorMessage}</c:when>
        <c:when test="${not empty requestScope['jakarta.servlet.error.message']}">${requestScope['jakarta.servlet.error.message']}</c:when>
        <c:when test="${param.code == '403'}">You don't have permission to view this page.</c:when>
        <c:when test="${param.code == '404'}">The page you're looking for doesn't exist.</c:when>
        <c:otherwise>An unexpected error occurred. Please try again.</c:otherwise>
      </c:choose>
    </p>
    <div class="flex gap-2" style="justify-content:center">
      <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Go Home</a>
      <a href="javascript:history.back()" class="btn btn-gray">Go Back</a>
    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>



