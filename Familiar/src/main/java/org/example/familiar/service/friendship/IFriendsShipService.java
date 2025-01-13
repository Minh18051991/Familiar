package org.example.familiar.service.friendship;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.model.Friendship;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IFriendsShipService {
    List<UserDTO> listFriendShips(Integer userId);

    List<UserDTO> searchNameFriendships(Integer userId, String searchName);

    Friendship sendFriendship(Integer userId1, Integer userId2);

    Friendship deleteFriendShip(Integer userId1, Integer userId2);

    Friendship acceptFriendship(Integer userId1, Integer userId2);

    Friendship cancelFriendship(Integer userId1, Integer userId2);

    Page<UserDTO> suggestedFriendsListPage(Integer userId1, Integer userId2, Pageable pageable);

    Page<UserDTO> friendRequestList(Integer userId, Pageable pageable);

    String getFriendShipStatus(Integer userId1, Integer userId2);

    Page<UserDTO> mutualFriendList(Integer userId1, Integer userId2, Pageable pageable);
}
