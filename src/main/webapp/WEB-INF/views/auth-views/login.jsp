<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Staff Login — Ocean View Resort</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }

    .container {
        background: #fff;
        padding: 40px;
        border-radius: 8px;
        max-width: 400px;
        width: 100%;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
    }

    .logo {
        text-align: center;
        margin-bottom: 24px;
    }

    .logo h1 {
        font-size: 22px;
        color: #1B4F8A;
    }

    .logo p {
        font-size: 13px;
        color: #888;
        margin-top: 4px;
    }

    h2 {
        text-align: center;
        margin-bottom: 24px;
        color: #333;
        font-size: 20px;
    }

    .form-group {
        margin-bottom: 16px;
    }

    label {
        display: block;
        margin-bottom: 6px;
        font-weight: bold;
        font-size: 14px;
        color: #444;
    }

    input[type="text"],
    input[type="password"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
    }

    input[type="text"]:focus,
    input[type="password"]:focus {
        border-color: #007bff;
        outline: none;
    }

    button {
        background-color: #1B4F8A;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 4px;
        cursor: pointer;
        width: 100%;
        font-size: 16px;
        margin-top: 8px;
    }

    button:hover { background-color: #163d6e; }

    .message {
        padding: 10px;
        border-radius: 4px;
        margin-bottom: 16px;
        font-size: 14px;
        text-align: center;
    }

    .error   { background-color: #fdecea; color: #c0392b; border: 1px solid #e74c3c; }
    .success { background-color: #eafaf1; color: #1e8449; border: 1px solid #27ae60; }

    .register-link {
        text-align: center;
        margin-top: 20px;
        font-size: 14px;
        color: #666;
    }

    .register-link a {
        color: #007bff;
        text-decoration: none;
    }

    .register-link a:hover { text-decoration: underline; }
</style>
</head>
<body>

<div class="container">

    <!-- Hotel branding -->
    <div class="logo">
        <h1>🏨 Ocean View Resort</h1>
        <p>Staff Management Portal</p>
    </div>

    <h2>Sign In</h2>

    <!-- Error: wrong username or password -->
    <c:if test="${param.status == 'error'}">
        <div class="message error">
            Invalid username or password. Please try again.
        </div>
    </c:if>

    <!-- Success: just registered -->
    <c:if test="${param.status == 'registered'}">
        <div class="message success">
            Registration successful! You can now log in.
        </div>
    </c:if>

    <!-- Success: just logged out -->
    <c:if test="${param.status == 'loggedout'}">
        <div class="message success">
            You have been logged out successfully.
        </div>
    </c:if>

    <!-- Error: session expired -->
    <c:if test="${param.status == 'sessionExpired'}">
        <div class="message error">
            Your session has expired. Please log in again.
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">

        <div class="form-group">
              <label for="usernameOrEmail">Username or Email</label>
				<input type="text" id="usernameOrEmail" name="usernameOrEmail"
         			placeholder="Enter username or email" required autofocus>

        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Enter your password" required>
        </div>

        <button type="submit">Login</button>

    </form>

    <div class="register-link">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register">Register here</a>
    </div>

</div>

</body>
</html>