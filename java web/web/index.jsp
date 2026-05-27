<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Permission" %>
<html>
<head>
    <title>用户综合管理系统</title>
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
            min-width: 500px;
        }
        h1 { color: #333; margin-bottom: 6px; font-size: 26px; text-align: center; }
        .subtitle { color: #888; margin-bottom: 24px; font-size: 14px; text-align: center; }
        .user-info {
            background: #f8f9ff;
            border-radius: 10px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user-info .left { display: flex; align-items: center; gap: 12px; }
        .user-info .avatar {
            width: 44px; height: 44px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex; justify-content: center; align-items: center;
            color: #fff; font-size: 20px; font-weight: bold;
        }
        .user-info .name { font-size: 16px; font-weight: bold; color: #333; }
        .user-info .role {
            font-size: 12px; color: #fff; background: #667eea;
            padding: 2px 10px; border-radius: 10px; margin-left: 8px;
        }
        .user-info .email { font-size: 12px; color: #888; }
        .btn-logout {
            padding: 8px 20px; background: #f5576c; color: #fff;
            border: none; border-radius: 6px; font-size: 13px;
            cursor: pointer; text-decoration: none;
        }
        .btn-logout:hover { opacity: 0.9; }
        .menu { display: flex; flex-direction: column; gap: 12px; }
        .menu a {
            display: block; padding: 13px 0; border-radius: 8px;
            text-decoration: none; font-size: 15px; font-weight: bold;
            color: #fff; transition: transform 0.2s, box-shadow 0.2s;
            text-align: center;
        }
        .menu a:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        }
        .menu a.disabled {
            opacity: 0.4; pointer-events: none;
        }
        .btn-insert  { background: linear-gradient(135deg, #43e97b, #38f9d7); color: #333; }
        .btn-update  { background: linear-gradient(135deg, #fa709a, #fee140); color: #333; }
        .btn-delete  { background: linear-gradient(135deg, #f5576c, #ff6a88); }
        .btn-search  { background: linear-gradient(135deg, #4facfe, #00f2fe); color: #333; }
        .btn-showall { background: linear-gradient(135deg, #667eea, #764ba2); }
        .btn-admin   { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .btn-role    { background: linear-gradient(135deg, #4facfe, #00f2fe); color: #333; }
        .section-title {
            font-size: 13px; color: #999; margin: 12px 0 8px;
            border-top: 1px solid #eee; padding-top: 12px;
        }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        Model model = new Model();
        boolean isAdmin = model.hasPermission(loginUser.getRoleId(), "system", "admin");
        boolean canDelete = model.hasPermission(loginUser.getRoleId(), "user", "delete");
        boolean canManageRole = model.hasPermission(loginUser.getRoleId(), "role", "manage");
    %>
    <div class="container">
        <h1>用户综合管理系统</h1>
        <p class="subtitle">User Management System</p>

        <div class="user-info">
            <div class="left">
                <div class="avatar"><%= loginUser.getUsername().substring(0,1).toUpperCase() %></div>
                <div>
                    <div>
                        <span class="name"><%= loginUser.getUsername() %></span>
                        <span class="role"><%= loginUser.getRoleName() %></span>
                    </div>
                    <div class="email"><%= loginUser.getEmail() %></div>
                </div>
            </div>
            <a href="LogoutServlet" class="btn-logout">退出登录</a>
        </div>

        <div class="menu">
            <div class="section-title">基本功能</div>
            <a href="insert.jsp" class="btn-insert">新增用户</a>
            <a href="update.jsp" class="btn-update">修改用户</a>
            <a href="dele.jsp" class="btn-delete <%= canDelete ? "" : "disabled" %>">删除用户<%= canDelete ? "" : "（无权限）" %></a>
            <a href="search.jsp" class="btn-search">查询用户</a>
            <a href="allShow.jsp" class="btn-showall">显示全部用户</a>

            <% if (isAdmin || canManageRole) { %>
            <div class="section-title">管理功能</div>
            <% if (isAdmin) { %>
            <a href="admin.jsp" class="btn-admin">系统管理</a>
            <% } %>
            <% if (canManageRole) { %>
            <a href="roleManage.jsp" class="btn-role">角色权限管理</a>
            <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>
