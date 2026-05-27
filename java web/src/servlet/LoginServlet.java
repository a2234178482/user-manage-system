package servlet;

import model.Model;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String captchaInput = request.getParameter("captcha");

        HttpSession session = request.getSession();
        String captchaCode = (String) session.getAttribute("captchaCode");

        if (captchaCode == null || !captchaCode.equalsIgnoreCase(captchaInput)) {
            request.setAttribute("msg", "验证码错误！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        session.removeAttribute("captchaCode");

        Model model = new Model();
        User user = model.login(username, password);

        if (user == null) {
            User existUser = model.searchByUsername(username);
            if (existUser != null && existUser.isLocked()) {
                request.setAttribute("msg", "账户已被锁定，请" + 30 + "分钟后再试！");
            } else {
                request.setAttribute("msg", "用户名或密码错误！");
            }
            request.setAttribute("username", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        session.setAttribute("loginUser", user);
        session.setMaxInactiveInterval(30 * 60);
        response.sendRedirect("index.jsp");
    }
}
