<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Model" %>
<%@ page import="entity.User" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>全部用户</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: "Microsoft YaHei", Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        .container {
            background: #fff;
            border-radius: 16px;
            padding: 40px 50px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            min-width: 700px;
        }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
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
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            font-weight: bold;
        }
        tr:nth-child(even) { background: #f9f9f9; }
        tr:hover { background: #f0f0ff; }
        .no-data { color: #f5576c; font-size: 18px; text-align: center; margin-bottom: 30px; }
        .back-link {
            display: inline-block;
            padding: 10px 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }
        .back-link:hover { opacity: 0.9; }
        .btn-wrap { text-align: center; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        request.setCharacterEncoding("UTF-8");
        Model model = new Model();
        List<User> list = model.showAll();
    %>
    <div class="container">
        <h2>全部用户列表</h2>
        <% if (list != null && list.size() > 0) { %>
        <table>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>邮箱</th>
                <th>角色</th>
                <th>状态</th>
            </tr>
            <% for (User u : list) { %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRoleName() %></td>
                <td style="color:<%= u.isLocked() ? "#f5576c" : "#43e97b" %>"><%= u.isLocked() ? "已锁定" : "正常" %></td>
            </tr>
            <% } %>
        </table>
        <% } else { %>
        <p class="no-data">暂无用户数据！</p>
        <% } %>
        <div class="btn-wrap">
            <a href="index.jsp" class="back-link">返回主页</a>
        </div>
    </div>
</body>
</html>
