package servlet;

import model.Model;
import entity.User;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("msg", "两次密码输入不一致！");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Model model = new Model();
        User existUser = model.searchByUsername(username);
        if (existUser != null) {
            request.setAttribute("msg", "用户名已存在！");
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRoleId(2);

        boolean result = model.insert(user);
        if (result) {
            request.setAttribute("msg", "注册成功，请登录！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("msg", "注册失败，请重试！");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
