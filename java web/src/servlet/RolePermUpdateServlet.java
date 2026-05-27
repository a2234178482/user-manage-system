package servlet;

import model.Model;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;

public class RolePermUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        Model model = new Model();

        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String paramName = params.nextElement();
            if (paramName.startsWith("perm_")) {
                int permId = Integer.parseInt(paramName.substring(5));
                model.updateRolePermission(roleId, permId, true);
            }
        }

        java.util.List<entity.Permission> allPerms = model.getAllPermissions();
        for (entity.Permission perm : allPerms) {
            String paramName = "perm_" + perm.getId();
            if (request.getParameter(paramName) == null) {
                model.updateRolePermission(roleId, perm.getId(), false);
            }
        }

        response.sendRedirect("roleManage.jsp");
    }
}
