package org.example.familiar.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

   @Override
public void addCorsMappings(org.springframework.web.servlet.config.annotation.CorsRegistry registry) {
    registry.addMapping("/**")
           .allowedOrigins("http://localhost:3000") // Thay đổi này thành URL chính xác của frontend
           .allowedMethods("GET", "POST", "PUT", "DELETE")
           .allowedHeaders("*")
           .exposedHeaders("Authorization","Content-Type")
           .allowCredentials(true);
}
}