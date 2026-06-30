<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Create Account</title>
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
            <h2>Create Account</h2>
            <p class="subtitle">Join Savora and start your culinary journey.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName"
                           placeholder="John Doe" value="${fullName}" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="you@example.com" value="${email}" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="At least 6 characters" minlength="6" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                           placeholder="Re-enter password" minlength="6" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Create Account <i class="fa-solid fa-user-plus"></i></button>
            </form>

            <div class="auth-footer-link">
                Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
            </div>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/" class="back-home-link" style="text-align:center;">&larr; Back to Home</a>
    <div style="height:30px;"></div>
</div>
</body>
</html>
