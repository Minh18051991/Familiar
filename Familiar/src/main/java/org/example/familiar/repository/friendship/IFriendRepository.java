package org.example.familiar.repository.friendship;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.model.Friendship;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface IFriendRepository extends JpaRepository<Friendship, Integer> {

    @Query(value = "SELECT u.id AS userId, u.first_name as userFirstName, u.last_name as userLastName, u.email as userEmail, " +
            "u.address as userAddress, u.profile_picture_url as userProfilePictureUrl, u.date_of_birth as userDateOfBirth \n" +
            "FROM friendships f \n" +
            "JOIN users u ON (f.user_id1 = u.id OR f.user_id2 = u.id)\n" +
            "WHERE (f.user_id1 = :userId OR f.user_id2 = :userId) AND f.is_accepted = TRUE AND f.is_deleted = FALSE AND u.id != :userId;", nativeQuery = true)
    List<UserDTO> listFriendShips(@Param("userId") Integer userId);

    @Query(value = "SELECT u.id AS userId, u.first_name as userFirstName, u.last_name as userLastName, u.email as userEmail,\n" +
            "u.address as userAddress, u.profile_picture_url as userProfilePictureUrl, u.gender as userGender, \n" +
            "u.occupation as userOccupation, u.date_of_birth as userDateOfBirth\n" +
            "FROM friendships f\n" +
            "JOIN users u ON (f.user_id1 = u.id OR f.user_id2 = u.id)\n" +
            "WHERE (f.user_id1 = :userId OR f.user_id2 = :userId) AND (u.first_name LIKE CONCAT('%', :searchName, '%') OR u.last_name LIKE CONCAT('%', :searchName, '%')) AND f.is_accepted = TRUE AND u.id != :userId;\n", nativeQuery = true)
    List<UserDTO> searchNameFriendships(@Param("userId") Integer userId, @Param("searchName") String searchName);

    @Query(value = "SELECT * FROM Friendships f WHERE (f.user_id1 = :userId1 AND f.user_id2 = :userId2) OR (f.user_id1 = :userId2 AND f.user_id2 = :userId1)", nativeQuery = true)
    Friendship findFriendshipByUserIds(@Param("userId1") Integer userId1, @Param("userId2") Integer userId2);
    
    @Query(value = "SELECT DISTINCT u.id AS userId, u.first_name as userFirstName, u.last_name as userLastName, u.profile_picture_url as userProfilePictureUrl\n" +
            "FROM friendships f2\n" +
            "JOIN users u ON u.id = CASE\n" +
            "                        WHEN f2.user_id1 = :userId2 THEN f2.user_id2\n" +
            "                        WHEN f2.user_id2 = :userId2 THEN f2.user_id1\n" +
            "                      END\n" +
            "WHERE u.id NOT IN (\n" +
            "    SELECT DISTINCT CASE\n" +
            "                        WHEN f1.user_id1 = :userId1 THEN f1.user_id2\n" +
            "                        WHEN f1.user_id2 = :userId1 THEN f1.user_id1\n" +
            "                    END\n" +
            "    FROM friendships f1\n" +
            "    WHERE (:userId1 IN (f1.user_id1, f1.user_id2))\n" +
            "      AND f1.is_deleted = FALSE\n" +
            "      AND f1.is_accepted = TRUE\n" +
            "    UNION\n" +
            "    SELECT DISTINCT CASE\n" +
            "                        WHEN f1.user_id1 = :userId1 THEN f1.user_id2\n" +
            "                        WHEN f1.user_id2 = :userId1 THEN f1.user_id1\n" +
            "                    END\n" +
            "    FROM friendships f1\n" +
            "    WHERE (:userId1 IN (f1.user_id1, f1.user_id2))\n" +
            "      AND f1.is_deleted = FALSE\n" +
            "      AND f1.is_accepted = FALSE\n" +
            ")\n" +
            "  AND u.id != :userId1 \n" +
            "  AND (:userId2 IN (f2.user_id1, f2.user_id2))\n" +
            "  AND f2.is_deleted = FALSE\n" +
            "  AND f2.is_accepted = TRUE;\n", nativeQuery = true)
    Page<UserDTO> suggestedFriendsListPage (@Param("userId1") Integer userId1, @Param("userId2") Integer userId2, Pageable pageable);

    @Query(value = "SELECT u.id AS userId, u.first_name as userFirstName, u.last_name as userLastName, u.profile_picture_url as userProfilePictureUrl\n" +
            "FROM users u\n" +
            "JOIN friendships f on f.user_id1 = u.id\n" +
            "where f.user_id2 = :userId AND f.is_accepted = FALSE AND f.is_deleted = FALSE;", nativeQuery = true)
    Page<UserDTO> friendRequestList (@Param("userId") Integer userId, Pageable pageable);

        @Query(value = "SELECT DISTINCT u.id AS userId, u.first_name as userFirstName, u.last_name as userLastName, u.profile_picture_url as userProfilePictureUrl\n" +
                "FROM \n" +
                "    friendships f1\n" +
                "JOIN \n" +
                "    friendships f2 ON f1.user_id2 = f2.user_id2\n" +
                "JOIN \n" +
                "    users u ON u.id = f1.user_id2\n" +
                "WHERE \n" +
                "    f1.user_id1 = :userId1\n" +
                "    AND f2.user_id1 = :userId2\n" +
                "    AND f1.is_accepted = TRUE\n" +
                "    AND f2.is_accepted = TRUE\n" +
                "    AND f1.is_deleted = FALSE\n" +
                "    AND f2.is_deleted = FALSE\n" +
                "    AND u.is_deleted = FALSE;", nativeQuery = true)
    Page<UserDTO> mutualFriendList (@Param("userId1") Integer userA, @Param("userId2") Integer userB, Pageable pageable);
}
