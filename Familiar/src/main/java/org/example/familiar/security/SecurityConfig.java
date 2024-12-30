package org.example.familiar.security;

import org.example.familiar.config.JwtAuthFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http
//                .csrf(csrf -> csrf.disable()) // JWT không yêu cầu CSRF
//                .sessionManagement(session -> session
//                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS) // Không sử dụng session
//                )
//                .authorizeHttpRequests(auth -> auth
//                        .requestMatchers("/login", "/dashboard").permitAll() // Các endpoint công khai
////                        .requestMatchers("/blog/create").hasRole("USER") // Yêu cầu quyền truy cập
////                        .anyRequest().authenticated() // Các yêu cầu còn lại cần xác thực
//                );
////                .addFilter(new JwtAuthenticationFilter()) // Bộ lọc xác thực JWT
////                .addFilter(new JwtAuthorizationFilter()); // Bộ lọc phân quyền dựa trên JWT
//
//        return http.build();
//    }



    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/login", "/dashboard").permitAll()
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/dashboard",true)
                )
                .csrf(csrf -> csrf.disable())
                .addFilterBefore(jwtAuthFilter(), UsernamePasswordAuthenticationFilter.class); // Thêm dòng này

        return http.build();
    }

    @Bean
    public JwtAuthFilter jwtAuthFilter() {
        return new JwtAuthFilter();
    }


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http
//                .csrf().disable()
//                .authorizeHttpRequests(auth -> auth
//                        .requestMatchers("/login", "/register", "/").permitAll()
//                        .anyRequest().authenticated()
//                )
//                .formLogin().loginPage("/login").defaultSuccessUrl("/dashboard", true).permitAll()
//                .and()
//                .logout().logoutSuccessUrl("/login").permitAll();
//
//        return http.build();
//    }
//
//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }
}
