<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Sign In</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="topbar">
        <div class="brand"><span class="logo-box">S</span> Savora</div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/login" class="topbar-btn">Sign In</a>
            <a href="${pageContext.request.contextPath}/register" class="topbar-btn filled">Register</a>
        </div>
    </div>

    <div class="auth-card-container">
        <div class="auth-card">
            <h2>Welcome Back</h2>
            <p class="subtitle">Sign in to continue your dining journey.</p>

            <c:if test="${param.registered == 'true'}">
                <div class="alert alert-success">Account created successfully. Please sign in.</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="text" class="form-control" id="email" name="email"
                           placeholder="you@example.com" value="${email}" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Sign In <i class="fa-solid fa-arrow-right"></i></button>
            </form>

            <div class="auth-footer-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one</a>
            </div>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/" class="back-home-link" style="text-align:center;">&larr; Back to Home</a>
    <div style="height:30px;"></div>
</div>
</body>
</html>