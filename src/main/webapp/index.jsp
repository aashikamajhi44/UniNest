<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="model.User, model.Property, java.util.List" %>
<%
    // Featured properties (approved) - pulled live from DB
    List<Property> featured = java.util.Collections.emptyList();
    try {
        List<Property> all = new dao.PropertyDAO().search(null, null, null);
        featured = all.size() > 3 ? all.subList(0, 3) : all;
    } catch (Throwable ignore) {}
    request.setAttribute("featured", featured);
    User loggedUser = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>UniNest - Find Your Perfect Nest Near Campus</title>`n<!-- aashika commit 1: landing page update -->
<meta name="description" content="UniNest helps university students find safe, verified housing and connect with compatible roommates.">
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Uni<span style="color:var(--coral)">Nest</span></a>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link active">Home</a>
    <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="nav-link">Properties</a>
    <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="nav-link">Roommates</a>
    <c:if test="${not empty sessionScope.loggedUser and sessionScope.userRole == 'student'}">
      <a href="${pageContext.request.contextPath}/WishlistServlet" class="nav-link">Wishlist</a>
    </c:if>
    <c:choose>
      <c:when test="${empty sessionScope.loggedUser}">
        <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-outline btn-sm" style="margin-left:.5rem">Login</a>
        <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn-coral" style="padding:.4rem 1rem;font-size:.85rem">Sign Up</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="nav-user">Hi, ${sessionScope.userName}</a>
        <a href="${pageContext.request.contextPath}/PropertyServlet?action=logout" class="btn btn-gray btn-sm">Logout</a>
      </c:otherwise>
    </c:choose>
  </div>
</nav>

<!-- HERO -->
<section class="lv-hero">
  <div class="lv-hero-inner">
    <h1>Find Your Perfect <span class="accent">Nest</span> Near Campus</h1>
    <p class="lead">UniNest helps university students discover safe, affordable housing and connect with ideal roommates - all verified by our admin team and trusted landlords.</p>
    <div class="cta-row">
      <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn-coral">Browse Properties</a>
      <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="btn-ghost-light">Find Roommates</a>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="lv-stats">
  <div class="lv-stats-grid">
    <div class="lv-stat">
      <div class="ico" aria-hidden="true">
        <svg class="stat-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 21h18"/>
          <path d="M5 21V9l7-5 7 5v12"/>
          <path d="M9 21v-6h6v6"/>
          <path d="M9 10h.01"/>
          <path d="M15 10h.01"/>
        </svg>
      </div>
      <div class="num">500+</div><div class="lbl">Properties Listed</div>
    </div>
    <div class="lv-stat">
      <div class="ico" aria-hidden="true">
        <svg class="stat-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
          <path d="m12 3 2.5 5.1 5.6.8-4 3.9.9 5.5-5-2.7-5 2.7.9-5.5-4-3.9 5.6-.8L12 3z"/>
        </svg>
      </div>
      <div class="num">2,000+</div><div class="lbl">Happy Students</div>
    </div>
    <div class="lv-stat">
      <div class="ico" aria-hidden="true">
        <svg class="stat-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
          <path d="m9 12 2 2 4-5"/>
        </svg>
      </div>
      <div class="num">350+</div><div class="lbl">Verified Listings</div>
    </div>
    <div class="lv-stat">
      <div class="ico" aria-hidden="true">
        <svg class="stat-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
          <path d="M16 21v-2a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v2"/>
          <circle cx="9.5" cy="7" r="4"/>
          <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
          <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
      </div>
      <div class="num">800+</div><div class="lbl">Roommates Matched</div>
    </div>
  </div>
</section>

<!-- WHY -->
<section class="lv-section">
  <div class="inner">
    <div class="lv-section-head">
      <h2>Why Choose UniNest?</h2>
      <p>Built by students, for students</p>
    </div>
    <div class="lv-features">
      <div class="lv-feature">
        <div class="ico-wrap" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="7"/>
            <path d="m20 20-3.5-3.5"/>
            <path d="M8.5 11h5"/>
            <path d="M11 8.5v5"/>
          </svg>
        </div>
        <h3>Smart Search</h3>
        <p>Filter by location, price, room type and more to find your perfect place.</p>
      </div>
      <div class="lv-feature">
        <div class="ico-wrap" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            <path d="m9 12 2 2 4-5"/>
          </svg>
        </div>
        <h3>Verified &amp; Safe</h3>
        <p>All listings are admin-verified to ensure student safety and transparency.</p>
      </div>
      <div class="lv-feature">
        <div class="ico-wrap" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
            <path d="M16 21v-2a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v2"/>
            <circle cx="9.5" cy="7" r="4"/>
            <path d="M18 8v6"/>
            <path d="M21 11h-6"/>
          </svg>
        </div>
        <h3>Roommate Matching</h3>
        <p>Connect with compatible roommates based on habits, budget and preferences.</p>
      </div>
    </div>
  </div>
</section>

<!-- FEATURED PROPERTIES -->
<section class="lv-section lv-bg-muted">
  <div class="inner">
    <div class="lv-section-row">
      <div>
        <h2>Featured Properties</h2>
        <p>Hand-picked verified listings for students</p>
      </div>
      <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn btn-outline">View All</a>
    </div>

    <c:choose>
      <c:when test="${empty featured}">
        <div class="empty-state"><div class="icon">Home</div><p>No approved properties yet - check back soon.</p></div>
      </c:when>
      <c:otherwise>
        <div class="prop-grid">
          <c:forEach var="p" items="${featured}">
            <div class="prop-card">
              <div class="prop-card-img" style="position:relative">
                <c:if test="${not empty p.imageUrl}"><img src="${p.imageUrl}" alt="${p.title}"></c:if>
                <c:if test="${empty p.imageUrl}">Home</c:if>
                <c:if test="${not empty sessionScope.loggedUser and sessionScope.userRole == 'student'}">
                  <form method="post" action="${pageContext.request.contextPath}/WishlistServlet"
                        style="position:absolute;top:.6rem;right:.6rem;margin:0">
                    <input type="hidden" name="action" value="toggle">
                    <input type="hidden" name="propertyId" value="${p.id}">
                    <input type="hidden" name="back" value="${pageContext.request.contextPath}/index.jsp">
                    <button type="submit" class="heart-btn" title="Save to wishlist">
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
                    </button>
                  </form>
                </c:if>
              </div>
              <div class="prop-card-body">
                <div class="prop-card-title">${p.title}</div>
                <div class="prop-card-loc">${p.location}</div>
                <div class="prop-card-price">Rs. ${p.price}<span style="font-size:.8rem;color:var(--gray-500);font-weight:500">/mo</span></div>
              </div>
              <div class="prop-card-foot">
                <span class="badge badge-success">Verified</span>
                <a href="${pageContext.request.contextPath}/PropertyServlet?action=detail&id=${p.id}" class="btn-coral" style="padding:.4rem .9rem;font-size:.82rem">View</a>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<!-- ROOMMATE TEASER -->
<section class="lv-section">
  <div class="inner">
    <div class="lv-section-row">
      <div>
        <h2>Find a Roommate</h2>
        <p>Connect with students near your campus</p>
      </div>
      <a href="${pageContext.request.contextPath}/RoommateServlet?action=myConnections" class="btn btn-outline">View All</a>
    </div>
    <div class="lv-roommate-grid">
      <div class="lv-roommate-card">
        <div class="lv-roommate-avatar">SC</div>
        <div>
          <h4>Sarah Chen</h4>
          <div class="meta">Computer Science - 2nd year</div>
          <p>"Looking for a quiet roommate near campus. Non-smoker, early riser, loves coffee mornings."</p>
        </div>
      </div>
      <div class="lv-roommate-card">
        <div class="lv-roommate-avatar">JM</div>
        <div>
          <h4>James Miller</h4>
          <div class="meta">Biology - 3rd year</div>
          <p>"Easygoing student looking for a shared apartment. Budget around Rs. 15k, vegetarian friendly."</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="lv-cta">
  <h2>Ready to Find Your UniNest?</h2>
  <p>Join thousands of students who found their perfect home through our verified platform.</p>
  <c:choose>
    <c:when test="${empty sessionScope.loggedUser}">
      <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn-coral" style="font-size:1rem;padding:.9rem 1.8rem">Get Started Free</a>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/PropertyServlet?action=list" class="btn-coral" style="font-size:1rem;padding:.9rem 1.8rem">Browse Properties</a>
    </c:otherwise>
  </c:choose>
</section>

<%@ include file="jsp/footer.jsp" %>
</body>
</html>


