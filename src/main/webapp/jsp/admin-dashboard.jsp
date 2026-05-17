<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="dao.UserDAO, dao.PropertyDAO, dao.BookingDAO, java.util.List, model.User, model.Property" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return;
    }

    UserDAO     userDAO     = new UserDAO();
    PropertyDAO propertyDAO = new PropertyDAO();
    BookingDAO  bookingDAO  = new BookingDAO();
    String tab = request.getParameter("tab");
    if (tab == null) tab = "overview";

    request.setAttribute("tab",          tab);
    request.setAttribute("totalUsers",   userDAO.countAll());
    request.setAttribute("totalProps",   propertyDAO.countAll());
    request.setAttribute("pendingProps", propertyDAO.countPending());
    request.setAttribute("totalBookings",bookingDAO.countAll());

    if ("landlords".equals(tab)) request.setAttribute("landlords", userDAO.getAllByRole("landlord"));
    if ("students".equals(tab))  request.setAttribute("students",  userDAO.getAllByRole("student"));
    if ("listings".equals(tab))  request.setAttribute("allProps",  propertyDAO.getAll());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard - UniNest</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <a href="?tab=overview"  class="nav-link ${tab=='overview' ?'active':''}">Overview</a>
    <a href="?tab=landlords" class="nav-link ${tab=='landlords'?'active':''}">Landlords</a>
    <a href="?tab=listings"  class="nav-link ${tab=='listings' ?'active':''}">Listings</a>
    <a href="?tab=students"  class="nav-link ${tab=='students' ?'active':''}">Students</a>
    <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-user">Hi, Super Admin</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">

  <c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success">${sessionScope.flashSuccess}</div>
    <% session.removeAttribute("flashSuccess"); %>
  </c:if>

  <!-- OVERVIEW TAB -->
  <c:if test="${tab == 'overview'}">
    <div class="page-header">
      <h1 class="page-title">Admin Dashboard</h1>
      <p class="page-sub">System overview and management controls</p>
    </div>
    <div class="admin-visual-strip" aria-label="Platform activity">
      <img src="${pageContext.request.contextPath}/images/prop1.jpg" alt="Verified room">
      <img src="${pageContext.request.contextPath}/images/prop2.jpg" alt="Student apartment">
      <img src="${pageContext.request.contextPath}/images/prop3.jpg" alt="Campus housing">
    </div>
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-val">${totalUsers}</div><div class="stat-label">Total Users</div></div>
      <div class="stat-card"><div class="stat-val">${totalProps}</div><div class="stat-label">Total Properties</div></div>
      <div class="stat-card" style="border-left:4px solid var(--warning)">
        <div class="stat-val" style="color:var(--warning)">${pendingProps}</div>
        <div class="stat-label">Pending Approval</div>
      </div>
      <div class="stat-card"><div class="stat-val">${totalBookings}</div><div class="stat-label">Total Bookings</div></div>
    </div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem">
      <div class="card">
        <div class="card-header">Quick Actions</div>
        <div class="card-body" style="display:flex;flex-direction:column;gap:.75rem">
          <a href="?tab=landlords" class="btn btn-outline">Verify Landlords</a>
          <a href="?tab=listings"  class="btn btn-outline">Approve Listings</a>
          <a href="?tab=students"  class="btn btn-outline">Manage Students</a>
        </div>
      </div>
      <div class="card">
        <div class="card-header">System Info</div>
        <div class="card-body">
          <p style="font-size:.9rem;color:var(--gray-600)">UniNest is running normally.</p>
          <p style="font-size:.82rem;color:var(--gray-400);margin-top:.75rem">
            Stack: Java JSP/Servlets - Maven - MySQL - MVC
          </p>
          <p style="font-size:.82rem;color:var(--gray-400);margin-top:.35rem">
            Security: BCrypt hashing - AuthFilter - Session-based auth
          </p>
        </div>
      </div>
    </div>
  </c:if>

  <!-- LANDLORDS TAB -->
  <c:if test="${tab == 'landlords'}">
    <div class="page-header">
      <h1 class="page-title">Landlord Verification</h1>
      <p class="page-sub">Verify or revoke landlord accounts</p>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>Name</th><th>Email</th><th>Phone</th><th>Joined</th><th>Status</th><th>Actions</th></tr></thead>
          <tbody>
            <c:forEach var="u" items="${landlords}">
              <tr>
                <td><strong>${u.name}</strong></td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td style="font-size:.82rem;color:var(--gray-400)">${u.createdAt}</td>
                <td>
                  <c:choose>
                    <c:when test="${u.verified}"><span class="badge badge-success">Verified</span></c:when>
                    <c:otherwise><span class="badge badge-warning">Pending</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:if test="${!u.verified}">
                    <form method="post" action="${pageContext.request.contextPath}/AdminServlet" style="display:inline">
                      <input type="hidden" name="action" value="verifyLandlord">
                      <input type="hidden" name="userId" value="${u.id}">
                      <input type="hidden" name="status" value="1">
                      <button class="btn btn-success btn-sm">Verify</button>
                    </form>
                  </c:if>
                  <c:if test="${u.verified}">
                    <form method="post" action="${pageContext.request.contextPath}/AdminServlet" style="display:inline">
                      <input type="hidden" name="action" value="verifyLandlord">
                      <input type="hidden" name="userId" value="${u.id}">
                      <input type="hidden" name="status" value="0">
                      <button class="btn btn-danger btn-sm">Revoke</button>
                    </form>
                  </c:if>
                  <form method="post" action="${pageContext.request.contextPath}/AdminServlet" style="display:inline"
                        onsubmit="return confirm('Delete this user?')">
                    <input type="hidden" name="action" value="deleteUser">
                    <input type="hidden" name="userId" value="${u.id}">
                    <input type="hidden" name="from" value="landlord">
                    <button class="btn btn-gray btn-sm">Delete</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty landlords}">
              <tr><td colspan="6" class="text-center text-muted" style="padding:2rem">No landlords registered yet.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>

  <!-- LISTINGS TAB -->
  <c:if test="${tab == 'listings'}">
    <div class="page-header">
      <h1 class="page-title">Property Listings</h1>
      <p class="page-sub">Approve or reject property submissions</p>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>Title</th><th>Landlord</th><th>Location</th><th>Price</th><th>Type</th><th>Status</th><th>Actions</th></tr></thead>
          <tbody>
            <c:forEach var="p" items="${allProps}">
              <tr>
                <td><strong>${p.title}</strong></td>
                <td>${p.landlordName}</td>
                <td>${p.location}</td>
                <td>Rs. ${p.price}</td>
                <td><span class="badge badge-info">${p.roomType}</span></td>
                <td>
                  <c:choose>
                    <c:when test="${p.status=='approved'}"><span class="badge badge-success">Approved</span></c:when>
                    <c:when test="${p.status=='rejected'}"><span class="badge badge-danger">Rejected</span></c:when>
                    <c:otherwise><span class="badge badge-warning">Pending</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div class="flex gap-1" style="flex-wrap:wrap">
                    <c:if test="${p.status != 'approved'}">
                      <form method="post" action="${pageContext.request.contextPath}/PropertyServlet" style="display:inline">
                        <input type="hidden" name="action"     value="approve">
                        <input type="hidden" name="propertyId" value="${p.id}">
                        <input type="hidden" name="status"     value="approved">
                        <button class="btn btn-success btn-sm">Approve</button>
                      </form>
                    </c:if>
                    <c:if test="${p.status != 'rejected'}">
                      <form method="post" action="${pageContext.request.contextPath}/PropertyServlet" style="display:inline">
                        <input type="hidden" name="action"     value="approve">
                        <input type="hidden" name="propertyId" value="${p.id}">
                        <input type="hidden" name="status"     value="rejected">
                        <button class="btn btn-danger btn-sm">Reject</button>
                      </form>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty allProps}">
              <tr><td colspan="7" class="text-center text-muted" style="padding:2rem">No properties submitted yet.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>

  <!-- STUDENTS TAB -->
  <c:if test="${tab == 'students'}">
    <div class="page-header">
      <h1 class="page-title">Registered Students</h1>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>Name</th><th>Email</th><th>Phone</th><th>Joined</th><th>Action</th></tr></thead>
          <tbody>
            <c:forEach var="u" items="${students}">
              <tr>
                <td><strong>${u.name}</strong></td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td style="font-size:.82rem;color:var(--gray-400)">${u.createdAt}</td>
                <td>
                  <form method="post" action="${pageContext.request.contextPath}/AdminServlet"
                        onsubmit="return confirm('Delete this student?')">
                    <input type="hidden" name="action" value="deleteUser">
                    <input type="hidden" name="userId" value="${u.id}">
                    <input type="hidden" name="from" value="student">
                    <button class="btn btn-danger btn-sm">Delete</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty students}">
              <tr><td colspan="5" class="text-center text-muted" style="padding:2rem">No students registered yet.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>

</div>
<%@ include file="footer.jsp" %>
</body>
</html>



