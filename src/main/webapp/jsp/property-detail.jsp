<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${property.title} - UniNest</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="nav-link active">Search</a>
    <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="nav-link">My Bookings</a>
    <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="nav-link">Roommates</a>
    <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-user">Hi, ${sessionScope.userName}</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">

  <div class="page-header flex-between">
    <div>
      <h1 class="page-title">${property.title}</h1>
      <p class="page-sub">Listed by ${property.landlordName}</p>
    </div>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn btn-gray">Back to Search</a>
  </div>

  <c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success">${sessionScope.flashSuccess}</div>
    <% session.removeAttribute("flashSuccess"); %>
  </c:if>

  <div style="display:grid;grid-template-columns:2fr 1fr;gap:1.5rem;align-items:start">

    <!-- Left: Property Info -->
    <div>
      <div class="card mb-3">
        <div class="property-detail-photo">
          <c:if test="${not empty property.imageUrl}"><img src="${property.imageUrl}" alt="${property.title}"></c:if>
          <c:if test="${empty property.imageUrl}">Home</c:if>
        </div>
        <div class="card-body">
          <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-bottom:1rem">
            <span class="badge badge-info">${property.roomType}</span>
            <span class="badge badge-success">Available</span>
          </div>
          <h3 style="font-size:1.05rem;font-weight:600;margin-bottom:.75rem">About this property</h3>
          <p style="color:var(--gray-600);line-height:1.75">
            ${not empty property.description ? property.description : 'No description provided.'}
          </p>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:.75rem;margin-top:1.25rem">
            <div style="background:var(--gray-50);border-radius:8px;padding:.85rem">
              <div style="font-size:.72rem;color:var(--gray-400);text-transform:uppercase;letter-spacing:.06em">Location</div>
              <div style="font-weight:500;color:var(--gray-700);margin-top:.3rem">${property.location}</div>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:.85rem">
              <div style="font-size:.72rem;color:var(--gray-400);text-transform:uppercase;letter-spacing:.06em">Monthly Rent</div>
              <div style="font-weight:700;color:var(--primary);font-size:1.15rem;margin-top:.3rem">Rs. ${property.price}</div>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:.85rem;grid-column:1/-1">
              <div style="font-size:.72rem;color:var(--gray-400);text-transform:uppercase;letter-spacing:.06em">Amenities</div>
              <div style="font-weight:500;color:var(--gray-700);margin-top:.3rem">
                ${not empty property.amenities ? property.amenities : 'Not specified'}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right: Actions -->
    <div style="display:flex;flex-direction:column;gap:1rem">

      <!-- Booking Form -->
      <div class="card">
        <div class="card-header">Request to Book</div>
        <div class="card-body">
          <c:choose>
            <c:when test="${alreadyBooked}">
              <div class="alert alert-info" style="margin-bottom:0">
                 You already have a booking request for this property.
              </div>
            </c:when>
            <c:when test="${sessionScope.userRole == 'student'}">
              <form method="post" action="${pageContext.request.contextPath}/BookingServlet">
                <input type="hidden" name="action"     value="send">
                <input type="hidden" name="propertyId" value="${property.id}">
                <div class="form-group">
                  <label class="form-label">Message to Landlord</label>
                  <textarea name="message" class="form-control"
                    placeholder="Introduce yourself and explain why you're interested..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Send Booking Request</button>
              </form>
            </c:when>
            <c:otherwise>
              <p class="text-muted" style="font-size:.875rem">Only students can send booking requests.</p>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- View Roommates -->
      <c:if test="${sessionScope.userRole == 'student'}">
        <div class="card">
          <div class="card-body text-center">
            <a href="${pageContext.request.contextPath}/RoommateServlet?action=browse&propertyId=${property.id}"
               class="btn btn-outline btn-block">View Tenants / Roommates</a>
          </div>
        </div>
      </c:if>

    </div>
  </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>




