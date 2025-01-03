package org.example.familiar.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

public class JwtAuthFilter extends OncePerRequestFilter {

    private String secretKey = "myVeryLongAndSecureKey12345678901111111111111111111111111";  // Khóa bí mật dùng để giải mã JWT

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // Lấy token từ header
        String token = request.getHeader("Authorization");

        // Nếu token không có, cho phép yêu cầu tiếp tục mà không xác thực
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // Loại bỏ tiền tố "Bearer "

            try {
                // Giải mã token và lấy thông tin claims (nội dung payload)
                Claims claims = Jwts.parser()
                        .setSigningKey(secretKey)
                        .parseClaimsJws(token)
                        .getBody();

                // Lấy thông tin người dùng từ claims (ví dụ: username)
                String username = claims.getSubject();

                // Tạo đối tượng Authentication (UsernamePasswordAuthenticationToken) cho Spring Security
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(username, null, null);

                // Đặt Authentication vào SecurityContext
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } catch (Exception e) {
                // Nếu token không hợp lệ, sẽ ném lỗi và yêu cầu sẽ không được tiếp tục
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token không hợp lệ");
                return;
            }
        }
        // Tiếp tục chuỗi bộ lọc
        filterChain.doFilter(request, response);
    }
}