package servlet;

import util.CaptchaUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.imageio.ImageIO;
import java.io.IOException;
import java.io.OutputStream;

public class CaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("image/jpeg");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        String code = CaptchaUtil.generateCode();
        HttpSession session = request.getSession();
        session.setAttribute("captchaCode", code);

        OutputStream os = response.getOutputStream();
        CaptchaUtil.generateImage(code, os);
        os.flush();
        os.close();
    }
}
