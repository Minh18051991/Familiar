package org.example.familiar.dto.userDTO;

import java.time.LocalDate;

public class UserDTOImpl implements UserDTO {
    private Integer userId;
    private String userFirstName;
    private String userLastName;
    private String userEmail;
    private String userAddress;
    private String userProfilePictureUrl;
    private String userGender;
    private String userOccupation;
    private LocalDate userDateOfBirth;

    public UserDTOImpl() {
    }

    public UserDTOImpl(Integer userId, String userFirstName, String userLastName, String userEmail, String userAddress, String userProfilePictureUrl, String userGender, String userOccupation, LocalDate userDateOfBirth) {
        this.userId = userId;
        this.userFirstName = userFirstName;
        this.userLastName = userLastName;
        this.userEmail = userEmail;
        this.userAddress = userAddress;
        this.userProfilePictureUrl = userProfilePictureUrl;
        this.userGender = userGender;
        this.userOccupation = userOccupation;
        this.userDateOfBirth = userDateOfBirth;
    }

    @Override
    public Integer getUserId() {
        return userId;
    }

    @Override
    public String getUserFirstName() {
        return userFirstName;
    }

    @Override
    public String getUserLastName() {
        return userLastName;
    }

    @Override
    public String getUserEmail() {
        return userEmail;
    }

    @Override
    public String getUserAddress() {
        return userAddress;
    }

    @Override
    public String getUserProfilePictureUrl() {
        return userProfilePictureUrl;
    }

    @Override
    public String getUserGender() {
        return userGender;
    }

    @Override
    public String getUserOccupation() {
        return userOccupation;
    }

    @Override
    public LocalDate getUserDateOfBirth() {
        return userDateOfBirth;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setUserFirstName(String userFirstName) {
        this.userFirstName = userFirstName;
    }

    public void setUserLastName(String userLastName) {
        this.userLastName = userLastName;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }

    public void setUserProfilePictureUrl(String userProfilePictureUrl) {
        this.userProfilePictureUrl = userProfilePictureUrl;
    }

    public void setUserGender(String userGender) {
        this.userGender = userGender;
    }

    public void setUserOccupation(String userOccupation) {
        this.userOccupation = userOccupation;
    }

    public void setUserDateOfBirth(LocalDate userDateOfBirth) {
        this.userDateOfBirth = userDateOfBirth;
    }
}
