<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.Role" %>
<%@ page import="entity.Permission" %>
<%@ page import="model.Model" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>角色权限管理</title>
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
            min-width: 800px;
        }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .role-section {
            margin-bottom: 24px;
            border: 1px solid #eee;
            border-radius: 10px;
            overflow: hidden;
        }
        .role-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            padding: 12px 20px;
            font-weight: bold;
            font-size: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .role-header .desc { font-size: 12px; opacity: 0.8; }
        .role-header .parent { font-size: 11px; background: rgba(255,255,255,0.2); padding: 2px 8px; border-radius: 4px; }
        .perm-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            padding: 16px 20px;
        }
        .perm-item {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
            transition: all 0.2s;
        }
        .perm-item.granted {
            background: #e8f8f0;
            border-color: #43e97b;
        }
        .perm-item.denied {
            background: #f9f9f9;
            border-color: #eee;
            color: #aaa;
        }
        .perm-item input[type="checkbox"] {
            cursor: pointer;
        }
        .perm-item label {
            cursor: pointer;
        }
        .perm-action {
            font-size: 11px;
            color: #888;
            margin-left: 4px;
        }
        .btn-save {
            padding: 6px 16px;
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            border: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
        }
        .btn-save:hover { opacity: 0.9; }
        .back-link {
            display: inline-block;
            padding: 10px 30px;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: #333;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }
        .btn-wrap { text-align: center; margin-top: 10px; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
        Model model = new Model();
        if (!model.hasPermission(loginUser.getRoleId(), "role", "manage")) {
            response.sendRedirect("index.jsp");
            return;
        }
        List<Role> roles = model.showAllRoles();
        List<Permission> allPerms = model.getAllPermissions();
    %>
    <div class="container">
        <h2>角色权限管理（RBAC）</h2>

        <% for (Role role : roles) { %>
        <%
            List<Permission> rolePerms = model.getPermissionsByRoleId(role.getId());
        %>
        <div class="role-section">
            <div class="role-header">
                <div>
                    <%= role.getRoleName() %>
                    <span class="desc"><%= role.getDescription() %></span>
                </div>
                <% if (role.getParentId() > 0) { %>
                <span class="parent">继承自父角色</span>
                <% } %>
            </div>
            <div class="perm-grid">
                <form action="RolePermUpdateServlet" method="post" style="display:contents;">
                    <input type="hidden" name="roleId" value="<%= role.getId() %>">
                    <% for (Permission perm : allPerms) { %>
                    <%
                        boolean hasPerm = false;
                        for (Permission rp : rolePerms) {
                            if (rp.getId() == perm.getId()) { hasPerm = true; break; }
                        }
                    %>
                    <div class="perm-item <%= hasPerm ? "granted" : "denied" %>">
                        <input type="checkbox" name="perm_<%= perm.getId() %>" id="perm_<%= role.getId() %>_<%= perm.getId() %>" <%= hasPerm ? "checked" : "" %>>
                        <label for="perm_<%= role.getId() %>_<%= perm.getId() %>"><%= perm.getPermissionName() %></label>
                        <span class="perm-action"><%= perm.getResource() %>:<%= perm.getAction() %></span>
                    </div>
                    <% } %>
                    <button type="submit" class="btn-save">保存</button>
                </form>
            </div>
        </div>
        <% } %>

        <div class="btn-wrap">
            <a href="index.jsp" class="back-link">返回主页</a>
        </div>
    </div>
</body>
</html>
