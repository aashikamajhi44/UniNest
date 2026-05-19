<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Profile - UniNest</title>
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <c:choose>
      <c:when test="${sessionScope.userRole == 'admin'}">
        <a href="${pageContext.request.contextPath}/jsp/admin-dashboard.jsp" class="nav-link">Dashboard</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-link">Dashboard</a>
      </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-user active">Hi, ${sessionScope.userRole == 'admin' ? 'Super Admin' : sessionScope.userName}</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">
  <div class="page-header">
    <h1 class="page-title">My Profile</h1>
    <p class="page-sub">View your UniNest account information and access level</p>
  </div>

  <div class="profile-layout">
    <aside class="profile-summary">
      <div class="profile-cover"></div>
      <div class="profile-avatar">UN</div>
      <h2>${profileUser.name}</h2>
      <p>${profileUser.email}</p>
      <div class="profile-badges">
        <span class="badge badge-info">${profileUser.role}</span>
        <c:choose>
          <c:when test="${profileUser.role == 'admin'}">
            <span class="badge badge-success">Active</span>
          </c:when>
          <c:when test="${profileUser.role == 'landlord' && profileUser.verified}">
            <span class="badge badge-success">Verified</span>
          </c:when>
          <c:when test="${profileUser.role == 'landlord'}">
            <span class="badge badge-warning">Pending</span>
          </c:when>
          <c:otherwise>
            <span class="badge badge-success">Active</span>
          </c:otherwise>
        </c:choose>
      </div>
    </aside>

    <section class="profile-panel">
      <div class="profile-panel-head">
        <div>
          <h2>Account Details</h2>
          <p>These details are used across your UniNest dashboard.</p>
        </div>
        <c:choose>
          <c:when test="${profileUser.role == 'admin'}">
            <a href="${pageContext.request.contextPath}/jsp/admin-dashboard.jsp" class="btn btn-primary btn-sm">Open Dashboard</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="btn btn-primary btn-sm">Open Dashboard</a>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="profile-info-grid">
        <div class="profile-info-item">
          <span>Full Name</span>
          <strong>${profileUser.name}</strong>
        </div>
        <div class="profile-info-item">
          <span>Email Address</span>
          <strong>${profileUser.email}</strong>
        </div>
        <div class="profile-info-item">
          <span>Phone Number</span>
          <strong><c:out value="${empty profileUser.phone ? 'Not added' : profileUser.phone}" /></strong>
        </div>
        <div class="profile-info-item">
          <span>Joined On</span>
          <strong>${profileUser.createdAt}</strong>
        </div>
      </div>

      <div class="profile-status-box">
        <div class="profile-status-icon">
          <c:choose>
            <c:when test="${profileUser.role == 'admin'}">A</c:when>
            <c:when test="${profileUser.role == 'landlord'}">L</c:when>
            <c:otherwise>S</c:otherwise>
          </c:choose>
        </div>
        <div>
          <h3>
            <c:choose>
              <c:when test="${profileUser.role == 'admin'}">Super Admin Access</c:when>
              <c:when test="${profileUser.role == 'landlord' && profileUser.verified}">Verified Landlord Account</c:when>
              <c:when test="${profileUser.role == 'landlord'}">Landlord Verification Pending</c:when>
              <c:otherwise>Student Account</c:otherwise>
            </c:choose>
          </h3>
          <p>
            <c:choose>
              <c:when test="${profileUser.role == 'admin'}">You can manage users, landlord verification, property approvals, and platform records.</c:when>
              <c:when test="${profileUser.role == 'landlord' && profileUser.verified}">Your account can manage property listings and respond to student booking requests.</c:when>
              <c:when test="${profileUser.role == 'landlord'}">An admin must verify your account before you can manage listings and bookings.</c:when>
              <c:otherwise>You can search approved housing, send booking requests, review accepted bookings, and connect with roommates.</c:otherwise>
            </c:choose>
          </p>
        </div>
      </div>
    </section>
  </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>



