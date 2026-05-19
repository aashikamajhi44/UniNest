<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="model.User, java.util.List, model.Property, model.Booking" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }
    // Pre-load landlord data if needed
    String role = loggedUser.getRole();
    if ("landlord".equals(role) && request.getAttribute("listings") == null) {
        dao.PropertyDAO dao = new dao.PropertyDAO();
        dao.BookingDAO bDao = new dao.BookingDAO();
        request.setAttribute("listings", dao.getByLandlord(loggedUser.getId()));
        request.setAttribute("bookings", bDao.getByLandlord(loggedUser.getId()));
    }
    if ("student".equals(role) && request.getAttribute("bookings") == null) {
        dao.BookingDAO bDao = new dao.BookingDAO();
        request.setAttribute("bookings", bDao.getByStudent(loggedUser.getId()));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard — UniNest</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span>Nest</span></a>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-link active">Dashboard</a>
    <c:if test="${sessionScope.userRole == 'student'}">
      <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="nav-link">Search</a>
      <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="nav-link">My Bookings</a>
      <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="nav-link">Roommates</a>
    </c:if>
    <c:if test="${sessionScope.userRole == 'landlord'}">
      <a href="${pageContext.request.contextPath}/BookingServlet?action=landlordBookings" class="nav-link">Bookings</a>
    </c:if>
    <span style="font-size:.85rem;color:var(--gray-500);margin:0 .5rem">Hi, ${sessionScope.userName}</span>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
  </div>
</nav>

<div class="container page-wrap">

  <%-- Flash messages --%>
  <c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success">${sessionScope.flashSuccess}</div>
    <% session.removeAttribute("flashSuccess"); %>
  </c:if>
  <c:if test="${not empty sessionScope.flashError}">
    <div class="alert alert-danger">${sessionScope.flashError}</div>
    <% session.removeAttribute("flashError"); %>
  </c:if>

  <div class="page-header flex-between">
    <div>
      <h1 class="page-title">Welcome, ${sessionScope.userName}</h1>
      <p class="page-sub">${sessionScope.userRole == 'landlord' ? 'Manage your properties and bookings' : 'Find your perfect student home'}</p>
    </div>
    <c:if test="${sessionScope.userRole == 'landlord'}">
      <button class="btn btn-primary" onclick="document.getElementById('addModal').style.display='flex'">+ Add Property</button>
    </c:if>
    <c:if test="${sessionScope.userRole == 'student'}">
      <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn btn-primary">Search Properties</a>
    </c:if>
  </div>

  <%-- LANDLORD DASHBOARD --%>
  <c:if test="${sessionScope.userRole == 'landlord'}">
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-val">${listings.size()}</div><div class="stat-label">My Listings</div></div>
      <div class="stat-card"><div class="stat-val">${bookings.size()}</div><div class="stat-label">Booking Requests</div></div>
    </div>

    <div class="card mb-3">
      <div class="card-header">My Properties</div>
      <c:choose>
        <c:when test="${empty listings}">
          <div class="empty-state"><div class="icon">🏠</div><p>No listings yet. Add your first property above.</p></div>
        </c:when>
        <c:otherwise>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Title</th><th>Location</th><th>Price</th><th>Type</th><th>Status</th><th>Actions</th></tr></thead>
              <tbody>
                <c:forEach var="p" items="${listings}">
                  <tr>
                    <td><strong>${p.title}</strong></td>
                    <td>${p.location}</td>
                    <td>₹${p.price}/mo</td>
                    <td><span class="badge badge-info">${p.roomType}</span></td>
                    <td>
                      <c:choose>
                        <c:when test="${p.status=='approved'}"><span class="badge badge-success">Approved</span></c:when>
                        <c:when test="${p.status=='rejected'}"><span class="badge badge-danger">Rejected</span></c:when>
                        <c:otherwise><span class="badge badge-warning">Pending</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td class="flex gap-1">
                      <button class="btn btn-outline btn-sm"
                        onclick="openEditModal(${p.id},'${p.title}','${p.description}','${p.location}',${p.price},'${p.roomType}','${p.amenities}','${p.imageUrl}')">Edit</button>
                      <form method="post" action="${pageContext.request.contextPath}/PropertyServlet" style="display:inline"
                            onsubmit="return confirm('Delete this property?')">
                        <input type="hidden" name="action"     value="delete">
                        <input type="hidden" name="propertyId" value="${p.id}">
                        <button class="btn btn-danger btn-sm">Delete</button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="card">
      <div class="card-header">Incoming Booking Requests</div>
      <c:choose>
        <c:when test="${empty bookings}">
          <div class="card-body text-muted text-center">No booking requests yet.</div>
        </c:when>
        <c:otherwise>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Student</th><th>Property</th><th>Message</th><th>Status</th><th>Actions</th></tr></thead>
              <tbody>
                <c:forEach var="b" items="${bookings}">
                  <tr>
                    <td>${b.studentName}</td>
                    <td>${b.propertyTitle}</td>
                    <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${b.message}</td>
                    <td>
                      <c:choose>
                        <c:when test="${b.status=='accepted'}"><span class="badge badge-success">Accepted</span></c:when>
                        <c:when test="${b.status=='rejected'}"><span class="badge badge-danger">Rejected</span></c:when>
                        <c:otherwise><span class="badge badge-warning">Pending</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:if test="${b.status=='pending'}">
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
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </c:if>

  <%-- STUDENT DASHBOARD --%>
  <c:if test="${sessionScope.userRole == 'student'}">
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-val">${bookings.size()}</div><div class="stat-label">My Bookings</div></div>
    </div>
    <div class="card">
      <div class="card-header flex-between">
        <span>My Booking Requests</span>
        <a href="${pageContext.request.contextPath}/BookingServlet?action=myBookings" class="btn btn-gray btn-sm">View All</a>
      </div>
      <c:choose>
        <c:when test="${empty bookings}">
          <div class="empty-state"><div class="icon">📋</div>
          <p>No bookings yet. <a href="${pageContext.request.contextPath}/PropertyServlet?action=list">Search for properties</a></p></div>
        </c:when>
        <c:otherwise>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Property</th><th>Location</th><th>Status</th><th>Date</th></tr></thead>
              <tbody>
                <c:forEach var="b" items="${bookings}" varStatus="s">
                  <c:if test="${s.index < 5}">
                    <tr>
                      <td><strong>${b.propertyTitle}</strong></td>
                      <td>${b.propertyLocation}</td>
                      <td><c:choose>
                        <c:when test="${b.status=='accepted'}"><span class="badge badge-success">Accepted</span></c:when>
                        <c:when test="${b.status=='rejected'}"><span class="badge badge-danger">Rejected</span></c:when>
                        <c:otherwise><span class="badge badge-warning">Pending</span></c:otherwise>
                      </c:choose></td>
                      <td style="font-size:.82rem;color:var(--gray-400)">${b.createdAt}</td>
                    </tr>
                  </c:if>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </c:if>
</div>

<!-- ADD PROPERTY MODAL -->
<div id="addModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:200;align-items:center;justify-content:center">
  <div style="background:#fff;border-radius:16px;padding:2rem;width:100%;max-width:560px;max-height:90vh;overflow-y:auto;position:relative">
    <button onclick="document.getElementById('addModal').style.display='none'"
      style="position:absolute;top:1rem;right:1rem;background:none;border:none;font-size:1.4rem;cursor:pointer;color:var(--gray-500)">×</button>
    <h2 style="font-size:1.2rem;font-weight:600;margin-bottom:1.25rem">Add New Property</h2>
    <form method="post" action="${pageContext.request.contextPath}/PropertyServlet">
      <input type="hidden" name="action" value="add">
      <div class="form-group"><label class="form-label">Title *</label>
        <input type="text" name="title" class="form-control" required placeholder="e.g. Cozy Studio Near Campus"></div>
      <div class="form-group"><label class="form-label">Description</label>
        <textarea name="description" class="form-control" placeholder="Describe the property..."></textarea></div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Location *</label>
          <input type="text" name="location" class="form-control" required placeholder="Area, City"></div>
        <div class="form-group"><label class="form-label">Price (₹/mo) *</label>
          <input type="number" name="price" class="form-control" required min="0" step="0.01"></div>
      </div>
      <div class="form-group"><label class="form-label">Room Type *</label>
        <select name="roomType" class="form-control form-select" required>
          <option value="single">Single</option>
          <option value="shared">Shared</option>
          <option value="studio">Studio</option>
          <option value="apartment">Apartment</option>
        </select></div>
      <div class="form-group"><label class="form-label">Amenities</label>
        <input type="text" name="amenities" class="form-control" placeholder="WiFi, AC, Parking..."></div>
      <div class="form-group"><label class="form-label">Image URL</label>
        <input type="text" name="imageUrl" class="form-control" placeholder="https://..."></div>
      <div class="flex gap-1 mt-2">
        <button type="submit" class="btn btn-primary">Submit for Approval</button>
        <button type="button" onclick="document.getElementById('addModal').style.display='none'" class="btn btn-gray">Cancel</button>
      </div>
    </form>
  </div>
</div>

<!-- EDIT PROPERTY MODAL -->
<div id="editModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:200;align-items:center;justify-content:center">
  <div style="background:#fff;border-radius:16px;padding:2rem;width:100%;max-width:560px;max-height:90vh;overflow-y:auto;position:relative">
    <button onclick="document.getElementById('editModal').style.display='none'"
      style="position:absolute;top:1rem;right:1rem;background:none;border:none;font-size:1.4rem;cursor:pointer;color:var(--gray-500)">×</button>
    <h2 style="font-size:1.2rem;font-weight:600;margin-bottom:1.25rem">Edit Property</h2>
    <form method="post" action="${pageContext.request.contextPath}/PropertyServlet">
      <input type="hidden" name="action"     value="edit">
      <input type="hidden" name="propertyId" id="editId">
      <div class="form-group"><label class="form-label">Title *</label>
        <input type="text" id="editTitle" name="title" class="form-control" required></div>
      <div class="form-group"><label class="form-label">Description</label>
        <textarea id="editDesc" name="description" class="form-control"></textarea></div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Location *</label>
          <input type="text" id="editLoc" name="location" class="form-control" required></div>
        <div class="form-group"><label class="form-label">Price (₹/mo) *</label>
          <input type="number" id="editPrice" name="price" class="form-control" required></div>
      </div>
      <div class="form-group"><label class="form-label">Room Type</label>
        <select id="editType" name="roomType" class="form-control form-select">
          <option value="single">Single</option>
          <option value="shared">Shared</option>
          <option value="studio">Studio</option>
          <option value="apartment">Apartment</option>
        </select></div>
      <div class="form-group"><label class="form-label">Amenities</label>
        <input type="text" id="editAmen" name="amenities" class="form-control"></div>
      <div class="form-group"><label class="form-label">Image URL</label>
        <input type="text" id="editImg" name="imageUrl" class="form-control"></div>
      <div class="flex gap-1 mt-2">
        <button type="submit" class="btn btn-primary">Save Changes</button>
        <button type="button" onclick="document.getElementById('editModal').style.display='none'" class="btn btn-gray">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script>
function openEditModal(id,title,desc,loc,price,type,amen,img){
  document.getElementById('editId').value    = id;
  document.getElementById('editTitle').value = title;
  document.getElementById('editDesc').value  = desc;
  document.getElementById('editLoc').value   = loc;
  document.getElementById('editPrice').value = price;
  document.getElementById('editType').value  = type;
  document.getElementById('editAmen').value  = amen;
  document.getElementById('editImg').value   = img;
  document.getElementById('editModal').style.display = 'flex';
}
</script>

</body>
</html>
