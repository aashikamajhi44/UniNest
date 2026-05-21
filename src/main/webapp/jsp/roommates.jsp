<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Roommates - UniNest</title>
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="nav-link">Search</a>
    <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="nav-link">My Bookings</a>
    <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="nav-link active">Roommates</a>
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

  <!-- BROWSE MODE: tenants at a specific property -->
  <c:if test="${not empty tenants}">
    <div class="page-header flex-between">
      <div>
        <h1 class="page-title">Property Tenants</h1>
        <p class="page-sub">Students living at this property - send a connection request</p>
      </div>
      <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="btn btn-gray">Back to Bookings</a>
    </div>
    <c:choose>
      <c:when test="${empty tenants}">
        <div class="empty-state"><p>No other tenants at this property yet.</p></div>
      </c:when>
      <c:otherwise>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:1.25rem">
          <c:forEach var="t" items="${tenants}">
            <div class="card">
              <div class="card-body text-center">
                <div style="width:64px;height:64px;background:var(--primary-light);border-radius:50%;
                            display:flex;align-items:center;justify-content:center;
                            font-size:1.75rem;margin:0 auto .75rem"></div>
                <div style="font-weight:600;font-size:1rem;color:var(--gray-900)">${t.name}</div>
                <div style="font-size:.82rem;color:var(--gray-400);margin:.2rem 0 1rem">${t.email}</div>
                <form method="post" action="${pageContext.request.contextPath}/RoommateServlet">
                  <input type="hidden" name="action"     value="sendRequest">
                  <input type="hidden" name="receiverId" value="${t.id}">
                  <input type="hidden" name="propertyId" value="${propertyId}">
                  <button class="btn btn-primary btn-block btn-sm">Send Connection Request</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </c:if>

  <!-- BROWSE MODE: no tenants message -->
  <c:if test="${empty tenants && not empty propertyId && viewMode == null}">
    <div class="page-header flex-between">
      <h1 class="page-title">Property Tenants</h1>
      <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="btn btn-gray">Back</a>
    </div>
    <div class="empty-state"><p>No other tenants at this property yet.</p></div>
  </c:if>

  <!-- CONNECTIONS MODE -->
  <c:if test="${viewMode == 'connections'}">
    <div class="page-header">
      <h1 class="page-title">Roommate Connections</h1>
      <p class="page-sub">Manage incoming requests and accepted connections</p>
    </div>

    <!-- Incoming requests -->
    <h2 style="font-size:1.05rem;font-weight:600;color:var(--gray-800);margin-bottom:.75rem">
      Incoming Requests
      <c:if test="${not empty incoming}">
        <span class="badge badge-warning" style="margin-left:.5rem">${incoming.size()}</span>
      </c:if>
    </h2>

    <c:choose>
      <c:when test="${empty incoming}">
        <div class="card mb-3">
          <div class="card-body text-center text-muted" style="padding:1.5rem">No incoming requests.</div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="card mb-3">
          <div class="table-wrap">
            <table>
              <thead><tr><th>From</th><th>Property</th><th>Date</th><th>Actions</th></tr></thead>
              <tbody>
                <c:forEach var="r" items="${incoming}">
                  <tr>
                    <td>
                      <strong>${r.senderName}</strong><br>
                      <span style="font-size:.82rem;color:var(--gray-400)">${r.senderEmail}</span>
                    </td>
                    <td>${r.propertyTitle}</td>
                    <td style="font-size:.82rem;color:var(--gray-400)">${r.createdAt}</td>
                    <td>
                      <div class="flex gap-1">
                        <form method="post" action="${pageContext.request.contextPath}/RoommateServlet" style="display:inline">
                          <input type="hidden" name="action"    value="respond">
                          <input type="hidden" name="requestId" value="${r.id}">
                          <input type="hidden" name="status"    value="accepted">
                          <button class="btn btn-success btn-sm">Accept</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/RoommateServlet" style="display:inline">
                          <input type="hidden" name="action"    value="respond">
                          <input type="hidden" name="requestId" value="${r.id}">
                          <input type="hidden" name="status"    value="rejected">
                          <button class="btn btn-danger btn-sm">Decline</button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </c:otherwise>
    </c:choose>

    <!-- Accepted connections -->
    <h2 style="font-size:1.05rem;font-weight:600;color:var(--gray-800);margin-bottom:.75rem">My Roommates</h2>
    <c:choose>
      <c:when test="${empty connections}">
        <div class="card">
          <div class="card-body text-center text-muted" style="padding:2rem">
            No accepted connections yet. Browse tenants of your approved properties and send a request!
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:1rem">
          <c:forEach var="r" items="${connections}">
            <div class="card">
              <div class="card-body text-center">
                <div style="width:56px;height:56px;background:var(--success-bg);border-radius:50%;
                            display:flex;align-items:center;justify-content:center;
                            font-size:1.5rem;margin:0 auto .75rem"></div>
                <c:choose>
                  <c:when test="${r.senderId == sessionScope.userId}">
                    <div style="font-weight:600">${r.receiverName}</div>
                    <div style="font-size:.8rem;color:var(--gray-400)">${r.receiverEmail}</div>
                  </c:when>
                  <c:otherwise>
                    <div style="font-weight:600">${r.senderName}</div>
                    <div style="font-size:.8rem;color:var(--gray-400)">${r.senderEmail}</div>
                  </c:otherwise>
                </c:choose>
                <div style="font-size:.8rem;color:var(--gray-400);margin:.25rem 0 .5rem">${r.propertyTitle}</div>
                <span class="badge badge-success">Connected</span>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </c:if>

</div>
<%@ include file="footer.jsp" %>
</body>
</html>




<%-- attribution: commit by Clauz5568 --%>
