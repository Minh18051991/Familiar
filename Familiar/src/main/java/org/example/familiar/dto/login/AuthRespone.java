package org.example.familiar.dto.login;

import org.example.familiar.model.User;

import java.util.List;

public class AuthRespone {
    private String token;
    private String username;
    private List<String> role;
    private String profilePictureUrl;
    private Integer userId;
    private String gender;

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getProfilePictureUrl() {
        return profilePictureUrl;
    }

    public void setProfilePictureUrl(String profilePictureUrl) {
        this.profilePictureUrl = profilePictureUrl;
    }

    public void setRole(List<String> role) {
        this.role = role;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public AuthRespone(String username, String token) {
        this.token = token;
        this.username = username;
    }

    public AuthRespone(String token, String username, List<String> role,String profilePictureUrl, Integer userId,String gender) {
        this.token = token;
        this.username = username;
        this.role = role;
        this.profilePictureUrl = profilePictureUrl;
        this.userId = userId;
        this.gender = gender;
    }

    public String getToken() {
        return token;
    }

    public String getUsername() {
        return username;
    }

    public List<String> getRole() {
        return role;
    }


}
