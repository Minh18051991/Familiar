package org.example.familiar.repository.friendship;

import org.example.familiar.dto.FriendShipDTO;
import org.example.familiar.model.Friendship;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface IFriendRepository extends JpaRepository<Friendship, Integer> {

    @Query(value = "SELECT u.id AS userId, u.first_name as userFirstName, u.last_name as userLastName, u.email as userEmail, u.address as userAddress, u.profile_picture_url as userProfilePictureUrl\n" +
            "FROM friendships f \n" +
            "JOIN users u ON (f.user_id1 = u.id OR f.user_id2 = u.id)\n" +
            "WHERE (f.user_id1 = :userId OR f.user_id2 = :userId) AND f.is_accepted = TRUE AND u.id != :userId;", nativeQuery = true)
    List<FriendShipDTO> listFriendShips(@Param("userId") Integer userId);
}
