<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Model" %>
<%@ page import="entity.User" %>
<html>
<head>
    <title>查询结果</title>
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
            min-width: 400px;
        }
        h2 { color: #333; margin-bottom: 20px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        th, td {
            padding: 12px 16px;
            border: 1px solid #eee;
            text-align: center;
        }
        th {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: #333;
            font-weight: bold;
        }
        tr:nth-child(even) { background: #f9f9f9; }
        .no-data { color: #f5576c; font-size: 18px; margin-bottom: 30px; }
        .back-link {
            display: inline-block;
            padding: 10px 30px;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
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
        int id = Integer.parseInt(request.getParameter("id"));

        Model model = new Model();
        User user = model.search(id);
    %>
    <div class="container">
        <h2>查询结果</h2>
        <% if (user != null) { %>
        <table>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>邮箱</th>
                <th>角色</th>
                <th>状态</th>
            </tr>
            <tr>
                <td><%= user.getId() %></td>
                <td><%= user.getUsername() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getRoleName() %></td>
                <td style="color:<%= user.isLocked() ? "#f5576c" : "#43e97b" %>"><%= user.isLocked() ? "已锁定" : "正常" %></td>
            </tr>
        </table>
        <% } else { %>
        <p class="no-data">未找到该用户！</p>
        <% } %>
        <a href="index.jsp" class="back-link">返回主页</a>
    </div>
</body>
</html>
