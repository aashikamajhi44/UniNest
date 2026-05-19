<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Wishlist - UniNest</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="nav-link">Properties</a>
    <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="nav-link">Roommates</a>
    <a href="${pageContext.request.contextPath}/WishlistServlet" class="nav-link active">Wishlist</a>
    <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-user">Hi, ${sessionScope.userName}</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">
  <c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success">${sessionScope.flashSuccess}</div>
    <% session.removeAttribute("flashSuccess"); %>
  </c:if>

  <div class="page-header">
    <h1 class="page-title">My Wishlist</h1>
    <p class="page-sub">Properties you've saved for later</p>
  </div>

  <c:choose>
    <c:when test="${empty wishlist}">
      <div class="empty-state">
        <p>Your wishlist is empty.</p>
        <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn btn-primary">Browse Properties</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="prop-grid">
        <c:forEach var="w" items="${wishlist}">
          <div class="prop-card">
            <div class="prop-card-img">
              <c:if test="${not empty w.propertyImageUrl}"><img src="${w.propertyImageUrl}" alt="${w.propertyTitle}"></c:if>
              <c:if test="${empty w.propertyImageUrl}">Home</c:if>
            </div>
            <div class="prop-card-body">
              <div class="prop-card-title">${w.propertyTitle}</div>
              <div class="prop-card-loc">${w.propertyLocation}</div>
              <div class="prop-card-price">Rs. ${w.propertyPrice}<span style="font-size:.8rem;color:var(--gray-500);font-weight:500">/mo</span></div>
            </div>
            <div class="prop-card-foot">
              <a href="${pageContext.request.contextPath}/PropertyServlet?action=detail&id=${w.propertyId}" class="btn btn-outline btn-sm">View</a>
              <form method="post" action="${pageContext.request.contextPath}/WishlistServlet" style="margin:0">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="propertyId" value="${w.propertyId}">
                <input type="hidden" name="back" value="${pageContext.request.contextPath}/WishlistServlet">
                <button class="btn btn-danger btn-sm">Remove</button>
              </form>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>



