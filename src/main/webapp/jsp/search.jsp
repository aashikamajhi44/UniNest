<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Search Properties - UniNest</title>
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
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
    <a href="${pageContext.request.contextPath}/WishlistServlet" class="nav-link">Wishlist</a>
    <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-user">Hi, ${sessionScope.userName}</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">

  <div class="page-header">
    <h1 class="page-title">Search Properties</h1>
    <p class="page-sub">Find safe, affordable housing near your university</p>
  </div>

  <!-- Search Filter Bar -->
  <form method="get" action="${pageContext.request.contextPath}/PropertyServlet" class="search-bar">
    <input type="hidden" name="action" value="list">
    <div class="form-group">
      <label class="form-label">Location</label>
      <input type="text" name="location" class="form-control" placeholder="City or area..." value="${location}">
    </div>
    <div class="form-group">
      <label class="form-label">Room Type</label>
      <select name="roomType" class="form-control form-select">
        <option value="">All Types</option>
        <option value="single"    ${roomType=='single'    ? 'selected':''}>Single</option>
        <option value="shared"    ${roomType=='shared'    ? 'selected':''}>Shared</option>
        <option value="studio"    ${roomType=='studio'    ? 'selected':''}>Studio</option>
        <option value="apartment" ${roomType=='apartment' ? 'selected':''}>Apartment</option>
      </select>
    </div>
    <div class="form-group">
      <label class="form-label">Max Price (Rs./mo)</label>
      <input type="number" name="maxPrice" class="form-control" placeholder="e.g. 10000" value="${maxPrice}">
    </div>
    <button type="submit" class="btn btn-primary" style="align-self:flex-end">Search</button>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn btn-gray" style="align-self:flex-end">Clear</a>
  </form>

  <!-- Results -->
  <c:choose>
    <c:when test="${empty properties}">
      <div class="empty-state">
        <p>No properties found. Try different filters or check back later.</p>
      </div>
    </c:when>
    <c:otherwise>
      <p style="color:var(--gray-500);font-size:.9rem;margin-bottom:1.25rem">
        <strong>${properties.size()}</strong> properties found
      </p>
      <div class="prop-grid">
        <c:forEach var="p" items="${properties}">
          <div class="prop-card">
            <div class="prop-card-img" style="position:relative">
              <c:if test="${not empty p.imageUrl}"><img src="${p.imageUrl}" alt="${p.title}"></c:if>
              <c:if test="${empty p.imageUrl}">Home</c:if>
              <c:if test="${sessionScope.userRole == 'student'}">
                <form method="post" action="${pageContext.request.contextPath}/WishlistServlet"
                      style="position:absolute;top:.5rem;right:.5rem;margin:0">
                  <input type="hidden" name="action" value="toggle">
                  <input type="hidden" name="propertyId" value="${p.id}">
                  <input type="hidden" name="back" value="${pageContext.request.contextPath}/PropertyServlet?action=list">
                  <button type="submit"
                          class="heart-btn ${wishlistedPropertyIds != null && wishlistedPropertyIds.contains(p.id) ? 'active' : ''}"
                          title="Save to wishlist">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
                  </button>
                </form>
              </c:if>
            </div>
            <div class="prop-card-body">
              <div class="prop-card-title">${p.title}</div>
              <div class="prop-card-loc">${p.location}</div>
              <div style="font-size:.82rem;color:var(--gray-400);margin-bottom:.6rem">by ${p.landlordName}</div>
              <div class="flex-between">
                <span class="prop-card-price">Rs. ${p.price}/mo</span>
                <span class="badge badge-info">${p.roomType}</span>
              </div>
            </div>
            <div class="prop-card-foot">
              <a href="${pageContext.request.contextPath}/PropertyServlet?action=detail&id=${p.id}"
                 class="btn btn-primary btn-sm">View Details</a>
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




