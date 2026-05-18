<%--
    Login Page for UniNest Student Housing Platform

    This JSP page provides the user login interface.
    It displays login form fields, flash messages,
    request-scoped alerts, and navigation links.

    Features:
    - User login authentication form
    - Session flash message handling
    - Request error/success message display
    - Navigation to registration and home page

    Author: YourName
    Version: 1.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="UTF-8"> <!-- Defines UTF-8 character encoding -->

  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Makes page responsive on different devices -->

  <title>Login - UniNest</title> <!-- Browser tab title -->

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <!-- Links external CSS stylesheet -->

</head>

<body>

<div class="auth-wrap"> <!-- Main authentication wrapper -->

  <div class="auth-panel"> <!-- Authentication panel -->

    <div class="auth-visual"> <!-- Left-side image section -->

      <img src="${pageContext.request.contextPath}/images/Daily Mindset Boost.jpeg"
           alt="Student studying at a desk">
      <!-- Displays login page image -->

    </div>

    <div class="auth-card"> <!-- Login card section -->

      <div class="auth-logo"> <!-- Application logo/title -->

        <h1>UniNest</h1>

        <p>Student Housing Platform</p>

      </div>

      <%-- Flash messages from session --%>

      <%
        // Retrieve flash error message from session
        Object flashError = session.getAttribute("flashError");

        // Check if error message exists
        if (flashError != null && !flashError.toString().isBlank()) {
      %>

      <div class="alert alert-danger"><%= flashError %></div>
      <!-- Displays error alert -->

      <%
          // Remove error after displaying once
          session.removeAttribute("flashError");
        }

        // Retrieve flash success message
        Object flashSuccess = session.getAttribute("flashSuccess");

        // Check if success message exists
        if (flashSuccess != null && !flashSuccess.toString().isBlank()) {
      %>

      <div class="alert alert-success"><%= flashSuccess %></div>
      <!-- Displays success alert -->

      <%
          // Remove success message after displaying once
          session.removeAttribute("flashSuccess");
        }
      %>

      <%-- Request-scoped messages --%>

      <%
        // Retrieve request error message
        Object error = request.getAttribute("error");

        // Check if request error exists
        if (error != null && !error.toString().isBlank()) {
      %>

      <div class="alert alert-danger"><%= error %></div>
      <!-- Displays request error -->

      <%
        }

        // Retrieve request success message
        Object success = request.getAttribute("success");

        // Check if request success exists
        if (success != null && !success.toString().isBlank()) {
      %>

      <div class="alert alert-success"><%= success %></div>
      <!-- Displays request success -->

      <%
        }
      %>

      <!-- Login form starts -->
      <form method="post"
            action="${pageContext.request.contextPath}/LoginServlet"
            novalidate>

        <div class="form-group">

          <label class="form-label" for="email">Email Address</label>

          <input id="email"
                 type="email"
                 name="email"
                 class="form-control"
                 placeholder="you@email.com"
                 required
                 autofocus>
          <!-- Email input field -->

        </div>

        <div class="form-group">

          <label class="form-label" for="password">Password</label>

          <input id="password"
                 type="password"
                 name="password"
                 class="form-control"
                 placeholder=""
                 required>
          <!-- Password input field -->

        </div>

        <button type="submit"
                class="btn btn-primary btn-block btn-lg mt-2">
          Sign In
        </button>
        <!-- Login submit button -->

      </form>

      <div class="auth-divider">or</div>
      <!-- Divider between login and registration -->

      <div class="text-center">

      <span style="font-size:.9rem;color:var(--gray-500)">
        Don't have an account?
      </span>

        <a href="${pageContext.request.contextPath}/RegisterServlet"
           class="btn btn-outline btn-sm"
           style="margin-left:.5rem">
          Register
        </a>
        <!-- Redirects user to registration page -->

      </div>

      <div class="text-center mt-3">

        <a href="${pageContext.request.contextPath}/index.jsp"
           style="font-size:.85rem;color:var(--gray-500)">
          Back to home
        </a>
        <!-- Redirects user back to homepage -->

      </div>

    </div> <!-- End auth-card -->

  </div> <!-- End auth-panel -->

</div> <!-- End auth-wrap -->

</body>
</html>