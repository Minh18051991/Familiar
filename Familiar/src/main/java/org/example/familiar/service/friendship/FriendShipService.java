package org.example.familiar.service.friendship;

import org.example.familiar.dto.FriendShipDTO;
import org.example.familiar.repository.friendship.IFriendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class FriendShipService implements IFriendsShipService {
    @Autowired
    private IFriendRepository friendRepository;
    @Override
    public List<FriendShipDTO> listFriendShips(Integer userId) {
        System.out.println("Fetching friendships for userId: " + userId);
        return friendRepository.listFriendShips(userId);
    }
}
