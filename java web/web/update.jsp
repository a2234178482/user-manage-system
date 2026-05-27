<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Role" %>
<%@ page import="model.Model" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>修改用户</title>
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
            min-width: 400px;
        }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s;
        }
        .form-group input:focus {
            border-color: #fa709a;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #fa709a, #fee140);
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit:hover { opacity: 0.9; }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #666;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover { color: #fa709a; }
    </style>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>修改用户</h2>
        <form action="updateShow.jsp" method="post">
            <div class="form-group">
                <label>用户ID</label>
                <input type="number" name="id" required placeholder="请输入要修改的用户ID">
            </div>
            <div class="form-group">
                <label>新用户名</label>
                <input type="text" name="username" required placeholder="请输入新用户名">
            </div>
            <div class="form-group">
                <label>新密码（留空则不修改）</label>
                <input type="password" name="password" placeholder="留空则不修改密码">
            </div>
            <div class="form-group">
                <label>新邮箱</label>
                <input type="text" name="email" required placeholder="请输入新邮箱">
            </div>
            <div class="form-group">
                <label>角色</label>
                <select name="roleId" style="width:100%;padding:10px 14px;border:1px solid #ddd;border-radius:6px;font-size:14px;outline:none;">
                    <%
                        Model roleModel = new Model();
                        List<Role> roles = roleModel.showAllRoles();
                        for (Role r : roles) {
                    %>
                    <option value="<%= r.getId() %>"><%= r.getRoleName() %> - <%= r.getDescription() %></option>
                    <% } %>
                </select>
            </div>
            <input type="submit" value="提交修改" class="btn-submit">
        </form>
        <a href="index.jsp" class="back-link">返回主页</a>
    </div>
</body>
</html>
