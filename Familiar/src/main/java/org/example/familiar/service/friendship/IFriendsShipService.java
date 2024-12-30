package org.example.familiar.service.friendship;

import org.example.familiar.dto.FriendShipDTO;

import java.util.List;

public interface IFriendsShipService {
    List<FriendShipDTO> listFriendShips (Integer userId);
}
