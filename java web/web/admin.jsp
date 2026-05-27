<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>系统管理</title>
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
        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            color: #fff;
        }
        .stat-card .num { font-size: 32px; font-weight: bold; }
        .stat-card .label { font-size: 13px; margin-top: 4px; opacity: 0.9; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
        }
        th, td {
            padding: 10px 14px;
            border: 1px solid #eee;
            text-align: center;
            font-size: 14px;
        }
        th {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: #fff;
            font-weight: bold;
        }
        tr:nth-child(even) { background: #f9f9f9; }
        .locked { color: #f5576c; font-weight: bold; }
        .active { color: #43e97b; font-weight: bold; }
        .btn-unlock {
            padding: 4px 12px; background: #43e97b; color: #333;
            border: none; border-radius: 4px; font-size: 12px;
            cursor: pointer; text-decoration: none;
        }
        .back-link {
            display: inline-block;
            padding: 10px 30px;
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }
        .btn-wrap { text-align: center; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
        Model model = new Model();
        if (!model.hasPermission(loginUser.getRoleId(), "system", "admin")) {
            response.sendRedirect("index.jsp");
            return;
        }
        List<User> users = model.showAll();
        int totalUsers = users.size();
        int lockedUsers = 0;
        int adminCount = 0;
        for (User u : users) {
            if (u.isLocked()) lockedUsers++;
            if ("admin".equals(u.getRoleName())) adminCount++;
        }
    %>
    <div class="container">
        <h2>系统管理面板</h2>
        <div class="stats">
            <div class="stat-card">
                <div class="num"><%= totalUsers %></div>
                <div class="label">总用户数</div>
            </div>
            <div class="stat-card">
                <div class="num"><%= lockedUsers %></div>
                <div class="label">锁定用户</div>
            </div>
            <div class="stat-card">
                <div class="num"><%= adminCount %></div>
                <div class="label">管理员数</div>
            </div>
        </div>

        <table>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>邮箱</th>
                <th>角色</th>
                <th>登录失败次数</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            <% for (User u : users) { %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRoleName() %></td>
                <td><%= u.getLoginAttempts() %></td>
                <td class="<%= u.isLocked() ? "locked" : "active" %>">
                    <%= u.isLocked() ? "已锁定" : "正常" %>
                </td>
                <td>
                    <% if (u.isLocked()) { %>
                    <a href="UnlockServlet?id=<%= u.getId() %>" class="btn-unlock">解锁</a>
                    <% } else { %>
                    -
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>

        <div class="btn-wrap">
            <a href="index.jsp" class="back-link">返回主页</a>
        </div>
    </div>
</body>
</html>
