<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Model" %>
<%@ page import="entity.User" %>
<html>
<head>
    <title>新增结果</title>
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
            text-align: center;
            min-width: 360px;
        }
        h2 { color: #333; margin-bottom: 20px; }
        .msg { font-size: 18px; margin-bottom: 30px; }
        .success { color: #43e97b; }
        .fail { color: #f5576c; }
        .back-link {
            display: inline-block;
            padding: 10px 30px;
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: #333;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }
        .back-link:hover { opacity: 0.9; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRoleId(roleId);

        Model model = new Model();
        boolean result = model.insert(user);
    %>
    <div class="container">
        <h2>新增用户结果</h2>
        <p class="msg <%= result ? "success" : "fail" %>">
            <%= result ? "新增成功！" : "新增失败！" %>
        </p>
        <a href="index.jsp" class="back-link">返回主页</a>
    </div>
</body>
</html>
