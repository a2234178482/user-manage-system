<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户登录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: "Microsoft YaHei", Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: #fff;
            border-radius: 16px;
            padding: 40px 50px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            min-width: 420px;
        }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block; margin-bottom: 6px; color: #555; font-size: 14px;
        }
        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%; padding: 10px 14px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 14px; outline: none;
        }
        .form-group input:focus { border-color: #667eea; }
        .captcha-row {
            display: flex; gap: 10px; align-items: center;
        }
        .captcha-row input {
            flex: 1; padding: 10px 14px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 14px; outline: none;
        }
        .captcha-row input:focus { border-color: #667eea; }
        .captcha-img {
            height: 40px; border-radius: 6px; cursor: pointer;
            border: 1px solid #ddd;
        }
        .btn-submit {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none; border-radius: 6px; font-size: 16px;
            font-weight: bold; color: #fff; cursor: pointer; margin-top: 10px;
        }
        .btn-submit:hover { opacity: 0.9; }
        .msg {
            text-align: center; color: #f5576c; font-size: 14px;
            margin-bottom: 16px; padding: 8px; background: #fff0f0;
            border-radius: 6px;
        }
        .links {
            text-align: center; margin-top: 20px;
        }
        .links a {
            color: #667eea; text-decoration: none; font-size: 14px;
        }
        .links a:hover { text-decoration: underline; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>用户登录</h2>
        <% String msg = (String) request.getAttribute("msg"); %>
        <% if (msg != null && !msg.isEmpty()) { %>
        <div class="msg"><%= msg %></div>
        <% } %>
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" name="username" required placeholder="请输入用户名"
                    value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" name="password" required placeholder="请输入密码">
            </div>
            <div class="form-group">
                <label>验证码</label>
                <div class="captcha-row">
                    <input type="text" name="captcha" required placeholder="请输入验证码">
                    <img src="CaptchaServlet" class="captcha-img" onclick="this.src='CaptchaServlet?t='+new Date().getTime()" title="点击刷新">
                </div>
            </div>
            <input type="submit" value="登 录" class="btn-submit">
        </form>
        <div class="links">
            <a href="register.jsp">还没有账号？立即注册</a>
        </div>
    </div>
</body>
</html>
