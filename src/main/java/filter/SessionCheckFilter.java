package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class SessionCheckFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String uri = req.getRequestURI();
        
        // Public pages - no login required
        boolean isPublicPage = uri.endsWith("/login") || 
                              uri.endsWith("/register") ||
                              uri.endsWith("/logout");
        
        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if logged in
        if (session == null || session.getAttribute("loggedInStaff") == null) {
            res.sendRedirect(req.getContextPath() + "/login?status=sessionExpired");
            return;
        }
        
        // Continue to requested page
        chain.doFilter(request, response);
    }
}