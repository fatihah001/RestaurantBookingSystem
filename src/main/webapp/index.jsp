<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savora - Fine Dining Experience</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .hero {
            min-height: 100vh;
            background: linear-gradient(rgba(40,20,10,0.55), rgba(40,20,10,0.65)),
                        url('https://images.unsplash.com/photo-1559339352-11d035aa65de?w=1600') center/cover;
            display: flex;
            flex-direction: column;
            color: white;
        }
        .hero-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
        }
        .hero-nav .brand {
            font-family: Georgia, serif;
            font-size: 1.4rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .hero-nav .logo-box {
            background: white;
            color: var(--savora-brown-dark);
            width: 30px; height: 30px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
        }
        .hero-center {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .hero-card {
            background: rgba(40, 20, 10, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.35);
            border-radius: 16px;
            backdrop-filter: blur(6px);
            max-width: 600px;
            width: 100%;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .hero-card h1 {
            font-family: Georgia, serif;
            font-size: 3.2rem;
            margin-bottom: 6px;
        }
        .hero-card p {
            max-width: 480px;
            opacity: 0.9;
            margin-bottom: 26px;
        }
        .hero-actions { display: flex; gap: 14px; }
        .hero-info-row {
            display: flex;
            gap: 30px;
            margin-top: 36px;
            padding-top: 26px;
            border-top: 1px solid rgba(255, 255, 255, 0.25);
            font-size: 0.85rem;
            flex-wrap: wrap;
            justify-content: center;
            width: 100%;
        }
        .hero-info-row .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .hero-info-row .info-item i {
            color: var(--savora-accent);
        }
    </style>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<div class="hero">
    <div class="hero-nav">
        <div class="brand"><span class="logo-box">S</span> Savora</div>
    </div>
    <div class="hero-center">
        <div class="hero-card">
            <h1>Savora</h1>
            <p>An intimate fine-dining experience crafted from the finest seasonal ingredients, served on an unforgettable evening.</p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-accent">Create Account &rarr;</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline" style="border-color:white;color:white;">
                    <i class="fa-solid fa-user"></i> Sign In
                </a>
            </div>
            <div class="hero-info-row">
                <div class="info-item"><i class="fa-regular fa-clock"></i> Open Daily 11AM - 11PM</div>
                <div class="info-item"><i class="fa-solid fa-location-dot"></i> 123 Gourmet Street</div>
                <div class="info-item"><i class="fa-solid fa-phone"></i> 017-3855926</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
