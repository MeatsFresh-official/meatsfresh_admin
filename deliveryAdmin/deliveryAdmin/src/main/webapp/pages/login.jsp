<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background:
                linear-gradient(135deg, #1e3a8a, #2563eb) right / 50% 100% no-repeat,
                #ffffff left / 50% 100% no-repeat;
            background-color: #ffffff; /* fallback */
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        .container-box {
            display: flex;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            width: 1000px;
            max-width: 90%;
            transform: translateY(0);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .container-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
        }
        .left-panel {
            background: linear-gradient(135deg, #1e3a8a, #2563eb);
            color: #fff;
            padding: 48px;
            width: 50%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .left-panel::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1), transparent);
            transform: rotate(45deg);
        }
        .left-panel h1 {
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 16px;
            position: relative;
            z-index: 1;
            animation: fadeIn 1s ease-out;
        }
        .left-panel p {
            font-size: 16px;
            line-height: 1.6;
            position: relative;
            z-index: 1;
        }
        .right-panel {
            padding: 48px;
            width: 50%;
            background: #fff;
        }
        .right-panel h3 {
            font-size: 24px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 24px;
        }
        .form-label {
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #d1d5db;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .btn-login {
            background: #2563eb;
            border: none;
            padding: 12px;
            font-weight: 600;
            color: #fff;
            width: 100%;
            border-radius: 8px;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        .btn-login:hover {
            background: #1e40af;
            transform: translateY(-2px);
        }
        .alert {
            margin-bottom: 20px;
            border-radius: 8px;
            padding: 12px;
            font-size: 14px;
        }
        .google-btn {
            margin-top: 16px;
            width: 100%;
            border: 1px solid #d1d5db;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s ease;
        }
        .google-btn:hover {
            background: #f9fafb;
        }
        .google-btn img {
            height: 24px;
            margin-right: 8px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 768px) {
            .container-box {
                flex-direction: column;
                width: 90%;
            }
            .left-panel, .right-panel {
                width: 100%;
                padding: 24px;
            }
            .left-panel h1 {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>
    <div class="container-box">
        <!-- Left Panel -->
        <div class="left-panel">
            <h1>Hello<br>Admin! 👋</h1>
            <p>Access your dashboard and manage your platform with ease.</p>
        </div>
        <!-- Right Panel -->
        <div class="right-panel">
            <h3 class="mb-4">Welcome Back!</h3>
            <c:if test="${not empty error}">
                <div class="alert bg-red-100 text-red-700">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert bg-green-100 text-green-700">${message}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="mb-4">
                    <label for="username" class="form-label">Email</label>
                    <input type="email" class="form-control" id="username" name="username" required>
                </div>
                <div class="mb-4">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn-login">Login Now</button>
            </form>
        </div>
    </div>
</body>
</html>