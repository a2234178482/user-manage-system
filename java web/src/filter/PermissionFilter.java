package filter;

import entity.User;
import model.Model;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class PermissionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        if (uri.equals(contextPath + "/admin.jsp") || uri.equals(contextPath + "/roleManage.jsp")) {
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("loginUser");
                if (user != null) {
                    Model model = new Model();
                    if (uri.equals(contextPath + "/admin.jsp")) {
                        if (!model.hasPermission(user.getRoleId(), "system", "admin")) {
                            httpRequest.setAttribute("errorMsg", "您没有访问该页面的权限！");
                            httpRequest.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                    } else if (uri.equals(contextPath + "/roleManage.jsp")) {
                        if (!model.hasPermission(user.getRoleId(), "role", "manage")) {
                            httpRequest.setAttribute("errorMsg", "您没有角色管理的权限！");
                            httpRequest.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                    }
                }
            }
        }

        if (uri.equals(contextPath + "/dele.jsp") || uri.equals(contextPath + "/deleShow.jsp")) {
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("loginUser");
                if (user != null) {
                    Model model = new Model();
                    if (!model.hasPermission(user.getRoleId(), "user", "delete")) {
                        httpRequest.setAttribute("errorMsg", "您没有删除用户的权限！");
                        httpRequest.getRequestDispatcher("error.jsp").forward(request, response);
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
