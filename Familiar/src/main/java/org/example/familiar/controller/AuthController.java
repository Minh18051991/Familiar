//package org.example.familiar.controller;
//
////import com.example.demojwt.config.JwtUtils;
////import org.springframework.beans.factory.annotation.Autowired;
////import org.springframework.stereotype.Controller;
////import org.springframework.ui.Model;
////import org.springframework.web.bind.annotation.GetMapping;
////import org.springframework.web.bind.annotation.PostMapping;
////import org.springframework.web.bind.annotation.RequestParam;
////
////@Controller
////public class AuthController {
////    @Autowired
////    private JwtUtils jwtUtils;
////
////
////    @GetMapping("/login")
////    public String showLoginPage() {
////        return "login";
////    }
////
////    @PostMapping("/login")
////    public String login(@RequestParam String username, @RequestParam String password, Model model) {
////        // Kiểm tra username & password (Demo: hardcode "admin" & "123456")
////        if ("admin".equals(username) && "123456".equals(password)) {
////            String token = jwtUtils.generateToken(username);
////            model.addAttribute("token", token);
////            model.addAttribute("username", username);
////            return "dashboard";
////        } else {
////            model.addAttribute("error", "Invalid credentials");
////            return "login";
////        }
////    }
////}
//
//
//import org.example.familiar.config.JwtUtils;
//import org.example.familiar.model.Account;
//import org.example.familiar.model.User;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.web.bind.annotation.CrossOrigin;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//@CrossOrigin("*")
//public class AuthController {
//
//    @Autowired
//    private JwtUtils jwtUtil;
//
//    @Autowired
//    private PasswordEncoder passwordEncoder;
//    @GetMapping("/login")
//    public ResponseEntity<?>authenticate(@RequestBody Account user) throws Exception {
//        // Demo chỉ kiểm tra username là "admin", password là "123"
//        if ("admin".equals(user.getUsername()) && "123".equals(user.getPasswordHash())) {
//            String token = jwtUtil.generateToken(user.getUsername());
//            return new ResponseEntity<>(token, HttpStatus.OK);
//        } else {
//            return new ResponseEntity<>("token", HttpStatus.BAD_REQUEST);
//        }
//
//    }
//
//
//    @GetMapping("/profile")
//    public ResponseEntity<String> getUserProfile() {
//        // Lấy thông tin Authentication từ SecurityContext
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//
//        // Lấy username từ Authentication (đã được bộ lọc JwtAuthFilter xử lý)
//        String username = authentication.getName();
//
//        return new ResponseEntity<>(username, HttpStatus.OK);
//    }
//
//
//}