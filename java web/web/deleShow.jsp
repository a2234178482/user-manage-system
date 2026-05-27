<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Model" %>
<html>
<head>
    <title>删除结果</title>
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
            background: linear-gradient(135deg, #f5576c, #ff6a88);
            color: #fff;
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
        int id = Integer.parseInt(request.getParameter("id"));

        Model model = new Model();
        boolean result = model.delete(id);
    %>
    <div class="container">
        <h2>删除用户结果</h2>
        <p class="msg <%= result ? "success" : "fail" %>">
            <%= result ? "删除成功！" : "删除失败！请检查用户ID是否存在" %>
        </p>
        <a href="index.jsp" class="back-link">返回主页</a>
    </div>
</body>
</html>
