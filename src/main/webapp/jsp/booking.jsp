<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bookings - UniNest</title>
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-link">Dashboard</a>
    <c:if test="${sessionScope.userRole == 'student'}">
      <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="nav-link">Search</a>
      <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="nav-link active">My Bookings</a>
      <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="nav-link">Roommates</a>
    </c:if>
    <c:if test="${sessionScope.userRole == 'landlord'}">
      <a href="${pageContext.request.contextPath}/BookingServlet?action=landlordBookings" class="nav-link active">Booking Requests</a>
    </c:if>
    <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-user">Hi, ${sessionScope.userName}</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">

  <c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success">${sessionScope.flashSuccess}</div>
    <% session.removeAttribute("flashSuccess"); %>
  </c:if>
  <c:if test="${not empty sessionScope.flashError}">
    <div class="alert alert-danger">${sessionScope.flashError}</div>
    <% session.removeAttribute("flashError"); %>
  </c:if>

  <div class="page-header">
    <h1 class="page-title">
      <c:choose>
        <c:when test="${sessionScope.userRole == 'landlord'}">Booking Requests</c:when>
        <c:otherwise>My Bookings</c:otherwise>
      </c:choose>
    </h1>
    <p class="page-sub">Track all housing requests</p>
  </div>

  <c:choose>
    <c:when test="${empty bookings}">
      <div class="empty-state">
        <p>
          <c:choose>
            <c:when test="${sessionScope.userRole == 'student'}">
              No bookings yet. <a href="${pageContext.request.contextPath}/PropertyServlet?action=list">Search for properties</a> to get started.
            </c:when>
            <c:otherwise>No booking requests received yet.</c:otherwise>
          </c:choose>
        </p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="card">
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Property</th>
                <th>Location</th>
                <c:if test="${sessionScope.userRole == 'landlord'}"><th>Student</th></c:if>
                <th>Message</th>
                <th>Status</th>
                <th>Date</th>
                <c:if test="${sessionScope.userRole == 'landlord'}"><th>Student Review</th></c:if>
                <th>${sessionScope.userRole == 'student' ? 'My Review' : 'Actions'}</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="b" items="${bookings}">
                <tr>
                  <td><strong>${b.propertyTitle}</strong></td>
                  <td style="font-size:.85rem;color:var(--gray-500)">${b.propertyLocation}</td>
                  <c:if test="${sessionScope.userRole == 'landlord'}">
                    <td>${b.studentName}</td>
                  </c:if>
                  <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;
                              font-size:.85rem;color:var(--gray-500)">${b.message}</td>
                  <td>
                    <c:choose>
                      <c:when test="${b.status=='accepted'}"><span class="badge badge-success">Accepted</span></c:when>
                      <c:when test="${b.status=='rejected'}"><span class="badge badge-danger">Rejected</span></c:when>
                      <c:otherwise><span class="badge badge-warning">Pending</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-size:.82rem;color:var(--gray-400)">${b.createdAt}</td>
                  <c:if test="${sessionScope.userRole == 'landlord'}">
                    <td>
                      <c:choose>
                        <c:when test="${b.reviewed}">
                          <div class="review-mini">
                            <strong>${b.reviewRating}/5</strong>
                            <span>${empty b.reviewComment ? 'No written comment.' : b.reviewComment}</span>
                          </div>
                        </c:when>
                        <c:otherwise><span class="text-muted">No review yet</span></c:otherwise>
                      </c:choose>
                    </td>
                  </c:if>
                  <td>
                    <!-- Landlord: accept/reject -->
                    <c:if test="${sessionScope.userRole == 'landlord' && b.status == 'pending'}">
                      <div class="flex gap-1">
                        <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline">
                          <input type="hidden" name="action"    value="updateStatus">
                          <input type="hidden" name="bookingId" value="${b.id}">
                          <input type="hidden" name="status"    value="accepted">
                          <button class="btn btn-success btn-sm">Accept</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/BookingServlet" style="display:inline">
                          <input type="hidden" name="action"    value="updateStatus">
                          <input type="hidden" name="bookingId" value="${b.id}">
                          <input type="hidden" name="status"    value="rejected">
                          <button class="btn btn-danger btn-sm">Reject</button>
                        </form>
                      </div>
                    </c:if>
                    <c:if test="${sessionScope.userRole == 'student' && b.status == 'accepted'}">
                      <form method="post" action="${pageContext.request.contextPath}/ReviewServlet" class="review-form">
                        <input type="hidden" name="bookingId" value="${b.id}">
                        <select name="rating" class="form-control form-select" required>
                          <option value="5" ${b.reviewRating == 5 ? 'selected' : ''}>5</option>
                          <option value="4" ${b.reviewRating == 4 ? 'selected' : ''}>4</option>
                          <option value="3" ${b.reviewRating == 3 ? 'selected' : ''}>3</option>
                          <option value="2" ${b.reviewRating == 2 ? 'selected' : ''}>2</option>
                          <option value="1" ${b.reviewRating == 1 ? 'selected' : ''}>1</option>
                        </select>
                        <input type="text" name="comment" class="form-control" placeholder="Write review" value="${fn:escapeXml(b.reviewComment)}">
                        <button class="btn btn-outline btn-sm">${b.reviewed ? 'Update' : 'Save'}</button>
                      </form>
                      <a href="${pageContext.request.contextPath}/RoommateServlet?action=browse&propertyId=${b.propertyId}"
                         class="btn btn-gray btn-sm mt-1">View Roommates</a>
                    </c:if>
                    <c:if test="${sessionScope.userRole == 'student' && b.status != 'accepted'}">
                      <span class="text-muted">Available after acceptance</span>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </c:otherwise>
  </c:choose>

</div>
<%@ include file="footer.jsp" %>
</body>
</html>



