<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>权限不足</title>
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
            padding: 50px 60px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            min-width: 400px;
        }
        .icon { font-size: 64px; margin-bottom: 20px; }
        h2 { color: #f5576c; margin-bottom: 16px; }
        .msg { color: #666; font-size: 16px; margin-bottom: 30px; }
        .back-link {
            display: inline-block;
            padding: 10px 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="icon">&#128274;</div>
        <h2>访问受限</h2>
        <p class="msg"><%= request.getAttribute("errorMsg") != null ? request.getAttribute("errorMsg") : "您没有权限访问该页面！" %></p>
        <a href="index.jsp" class="back-link">返回主页</a>
    </div>
</body>
</html>
