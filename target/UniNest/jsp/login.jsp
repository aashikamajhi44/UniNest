<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login — UniNest</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card">

    <div class="auth-logo">
      <h1>UniNest</h1>
      <p>Student Housing Platform</p>
    </div>

    <%-- Flash messages from session --%>
    <c:if test="${not empty sessionScope.flashError}">
      <div class="alert alert-danger">${sessionScope.flashError}</div>
      <% session.removeAttribute("flashError"); %>
    </c:if>
    <c:if test="${not empty sessionScope.flashSuccess}">
      <div class="alert alert-success">${sessionScope.flashSuccess}</div>
      <% session.removeAttribute("flashSuccess"); %>
    </c:if>

    <%-- Request-scoped messages --%>
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success">${success}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/LoginServlet" novalidate>
      <div class="form-group">
        <label class="form-label" for="email">Email Address</label>
        <input id="email" type="email" name="email" class="form-control"
               placeholder="you@email.com" required autofocus>
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input id="password" type="password" name="password" class="form-control"
               placeholder="••••••••" required>
      </div>
      <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Sign In</button>
    </form>

    <div class="auth-divider">or</div>

    <div class="text-center">
      <span style="font-size:.9rem;color:var(--gray-500)">Don't have an account?</span>
      <a href="${pageContext.request.contextPath}/RegisterServlet" class="btn btn-outline btn-sm" style="margin-left:.5rem">Register</a>
    </div>

    <div class="demo-box">
      <strong>Demo accounts:</strong><br>
      Admin &nbsp;&nbsp;&nbsp;: admin@uninest.com &nbsp;/ admin123<br>
      Landlord : john@landlord.com &nbsp;/ pass123<br>
      Student &nbsp;: alice@student.com / pass123
    </div>

  </div>
</div>
</body>
</html>
