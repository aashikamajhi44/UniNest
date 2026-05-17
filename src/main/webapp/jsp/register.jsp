<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - UniNest</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-panel auth-panel-register">
  <div class="auth-visual">
    <img src="${pageContext.request.contextPath}/images/auth-study.png" alt="Student studying at a desk">
  </div>
  <div class="auth-card">

    <div class="auth-logo">
      <h1>UniNest</h1>
      <p>Create your account</p>
    </div>

    <%
      Object error = request.getAttribute("error");
      if (error != null && !error.toString().isBlank()) {
    %>
      <div class="alert alert-danger"><%= error %></div>
    <%
      }
    %>

    <form method="post" action="${pageContext.request.contextPath}/RegisterServlet" novalidate>

      <div class="form-group">
        <label class="form-label" for="name">Full Name *</label>
        <input id="name" type="text" name="name" class="form-control"
               placeholder="Your full name" required value="${param.name}">
      </div>

      <div class="form-group">
        <label class="form-label" for="email">Email Address *</label>
        <input id="email" type="email" name="email" class="form-control"
               placeholder="you@email.com" required value="${param.email}">
      </div>

      <div class="form-group">
        <label class="form-label" for="phone">Phone Number</label>
        <input id="phone" type="text" name="phone" class="form-control"
               placeholder="10-digit number" value="${param.phone}">
      </div>

      <div class="form-row">
        <div class="form-group">
          <label class="form-label" for="password">Password *</label>
          <input id="password" type="password" name="password" class="form-control"
                 placeholder="Min 6 characters" required minlength="6">
        </div>
        <div class="form-group">
          <label class="form-label" for="confirmPassword">Confirm Password *</label>
          <input id="confirmPassword" type="password" name="confirmPassword" class="form-control"
                 placeholder="Repeat password" required>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label" for="role">Register As *</label>
        <select id="role" name="role" class="form-control form-select" required>
          <option value="">- Select role -</option>
          <option value="student">Student</option>
          <option value="landlord">Landlord</option>
        </select>
        <p class="form-hint">Landlord accounts require admin verification before login.</p>
      </div>

      <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Create Account</button>
    </form>

    <div class="auth-divider">or</div>

    <div class="text-center">
      <span style="font-size:.9rem;color:var(--gray-500)">Already have an account?</span>
      <a href="${pageContext.request.contextPath}/LoginServlet" class="btn btn-outline btn-sm" style="margin-left:.5rem">Sign In</a>
    </div>

  </div>
  </div>
</div>
</body>
</html>



