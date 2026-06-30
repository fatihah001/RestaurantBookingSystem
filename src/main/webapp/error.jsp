<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Savora - Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card-container">
            <div class="auth-card">
                <i class="fa-solid fa-triangle-exclamation" style="font-size:2.4rem;color:#c17a4a;margin-bottom:10px;"></i>
                <h2>Something went wrong</h2>
                <p class="subtitle">We couldn't process your request. Please try again, or head back to the homepage.</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-block">Back to Home</a>

                <%
                    // DEV-ONLY: shows the real exception so it's easy to diagnose during coursework.
                    // Remove or guard this block before any real/public deployment.
                    Throwable t = exception;
                    if (t == null) {
                        t = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
                    }
                    if (t != null) {
                        StringWriter sw = new StringWriter();
                        t.printStackTrace(new PrintWriter(sw));
                %>
                <details style="margin-top:20px; text-align:left;">
                    <summary style="cursor:pointer; color:#c17a4a;">Show technical details (dev mode)</summary>
                    <pre style="white-space:pre-wrap; font-size:0.75rem; background:#f5f0eb; padding:12px; border-radius:6px; max-height:300px; overflow:auto;"><%= sw.toString() %></pre>
                </details>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
