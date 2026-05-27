<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户注册</title>
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
        .form-group input {
            width: 100%; padding: 10px 14px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 14px; outline: none;
        }
        .form-group input:focus { border-color: #43e97b; }
        .btn-submit {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            border: none; border-radius: 6px; font-size: 16px;
            font-weight: bold; color: #333; cursor: pointer; margin-top: 10px;
        }
        .btn-submit:hover { opacity: 0.9; }
        .msg {
            text-align: center; color: #f5576c; font-size: 14px;
            margin-bottom: 16px; padding: 8px; background: #fff0f0;
            border-radius: 6px;
        }
        .links { text-align: center; margin-top: 20px; }
        .links a { color: #43e97b; text-decoration: none; font-size: 14px; }
        .links a:hover { text-decoration: underline; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>用户注册</h2>
        <% String msg = (String) request.getAttribute("msg"); %>
        <% if (msg != null && !msg.isEmpty()) { %>
        <div class="msg"><%= msg %></div>
        <% } %>
        <form action="RegisterServlet" method="post">
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
                <label>确认密码</label>
                <input type="password" name="confirmPassword" required placeholder="请再次输入密码">
            </div>
            <div class="form-group">
                <label>邮箱</label>
                <input type="text" name="email" required placeholder="请输入邮箱"
                    value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
            </div>
            <input type="submit" value="注 册" class="btn-submit">
        </form>
        <div class="links">
            <a href="login.jsp">已有账号？去登录</a>
        </div>
    </div>
</body>
</html>
