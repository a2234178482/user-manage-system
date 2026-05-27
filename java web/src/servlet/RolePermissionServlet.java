package servlet;

import model.Model;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class RolePermissionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        int permissionId = Integer.parseInt(request.getParameter("permissionId"));

        Model model = new Model();
        boolean result = false;
        if ("grant".equals(action)) {
            result = model.updateRolePermission(roleId, permissionId, true);
        } else if ("revoke".equals(action)) {
            result = model.updateRolePermission(roleId, permissionId, false);
        }

        PrintWriter out = response.getWriter();
        out.print(result ? "success" : "fail");
        out.flush();
    }
}
