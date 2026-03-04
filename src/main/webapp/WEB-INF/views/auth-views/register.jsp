<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Staff Registration</title>
<style>
    body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; }
    .container { background: #fff; padding: 20px; border-radius: 8px; max-width: 400px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    .form-group { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; }
    input[type="text"], input[type="password"], input[type="email"], select {
        width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
    }
    button {
        background-color: #007bff; color: white; border: none; padding: 10px 15px;
        border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px;
    }
    button:hover { background-color: #0056b3; }
    .error   { color: red;   margin-bottom: 10px; }
    .success { color: green; margin-bottom: 10px; }
</style>
</head>
<body>
<div class="container">
    <h2>Staff Registration</h2>

    <!-- Show messages -->
    <c:if test="${param.status == 'error'}">
        <p class="error">Username already exists. Please try another.</p>
    </c:if>
    <c:if test="${param.status == 'invalid'}">
        <p class="error">Password must be at least 8 characters.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">

        <div class="form-group">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" required>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
        </div>

        <div class="form-group">
            <label for="userName">Username</label>
            <input type="text" id="userName" name="userName" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" minlength="8" required>
        </div>

        <div class="form-group">
            <label for="role">Role</label>
            <select id="role" name="role" required>
                <option value="">-- Select Role --</option>
                <option value="Admin">Admin</option>
                <option value="FrontDesk">Front Desk</option>
                <option value="Housekeeping">Housekeeping</option>
                <option value="Manager">Manager</option>
            </select>
        </div>

        <button type="submit">Register</button>
    </form>
</div>
</body>
</html>