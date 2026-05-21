<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login\ -\ UniNest</title>`n<!--\ aashika\ commit\ 3:\ auth\ login\ page\ note\ -->
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-panel">
  <div class="auth-visual">
    <img src="${pageContext.request.contextPath}/images/Daily Mindset Boost.jpeg" alt="Student studying at a desk">
  </div>
  <div class="auth-card">

    <div class="auth-logo">
      <h1>UniNest</h1>
      <p>Student Housing Platform</p>
    </div>

    <%-- Flash messages from session --%>
    <%
      Object flashError = session.getAttribute("flashError");
      if (flashError != null && !flashError.toString().isBlank()) {
    %>
      <div class="alert alert-danger"><%= flashError %></div>
    <%
        session.removeAttribute("flashError");
      }

      Object flashSuccess = session.getAttribute("flashSuccess");
      if (flashSuccess != null && !flashSuccess.toString().isBlank()) {
    %>
      <div class="alert alert-success"><%= flashSuccess %></div>
    <%
        session.removeAttribute("flashSuccess");
      }
    %>

    <%-- Request-scoped messages --%>
    <%
      Object error = request.getAttribute("error");
      if (error != null && !error.toString().isBlank()) {
    %>
      <div class="alert alert-danger"><%= error %></div>
    <%
      }

      Object success = request.getAttribute("success");
      if (success != null && !success.toString().isBlank()) {
    %>
      <div class="alert alert-success"><%= success %></div>
    <%
      }
    %>

    <form method="post" action="${pageContext.request.contextPath}/LoginServlet" novalidate>
      <div class="form-group">
        <label class="form-label" for="email">Email Address</label>
        <input id="email" type="email" name="email" class="form-control"
               placeholder="you@email.com" required autofocus>
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input id="password" type="password" name="password" class="form-control"
               placeholder="" required>
      </div>
      <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Sign In</button>
    </form>

    <div class="auth-divider">or</div>

    <div class="text-center">
      <span style="font-size:.9rem;color:var(--gray-500)">Don't have an account?</span>
      <a href="${pageContext.request.contextPath}/RegisterServlet" class="btn btn-outline btn-sm" style="margin-left:.5rem">Register</a>
    </div>

    <div class="text-center mt-3">
      <a href="${pageContext.request.contextPath}/index.jsp" style="font-size:.85rem;color:var(--gray-500)">Back to home</a>
    </div>

  </div>
  </div>
</div>
</body>
</html>




