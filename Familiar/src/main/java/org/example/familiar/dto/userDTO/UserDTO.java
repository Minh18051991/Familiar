package org.example.familiar.dto.userDTO;

import java.time.LocalDate;
import java.util.Date;

public interface UserDTO {
    Integer getUserId();
    String getUserFirstName();
    String getUserLastName();
    String getUserEmail();
    String getUserAddress();
    String getUserProfilePictureUrl();
    String getUserGender();
    String getUserOccupation();
    LocalDate getUserDateOfBirth();
}
