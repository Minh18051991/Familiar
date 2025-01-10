package org.example.familiar.service.friendship;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.model.Friendship;
import org.example.familiar.model.User;
import org.example.familiar.repository.friendship.IFriendRepository;
import org.example.familiar.repository.user.IUserRepository;
import org.example.familiar.service.user.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FriendShipService implements IFriendsShipService {
    @Autowired
    private IFriendRepository friendRepository;

    @Autowired
    private IUserRepository userRepository;

    @Override
    public List<UserDTO> listFriendShips(Integer userId) {
        return friendRepository.listFriendShips(userId);
    }

    @Override
    public List<UserDTO> searchNameFriendships(Integer userId, String searchName) {
        return friendRepository.searchNameFriendships(userId, searchName);
    }

    @Override
    public Friendship sendFriendship(Integer userId1, Integer userId2) {
        Friendship friendship = friendRepository.findFriendshipByUserIds(userId1, userId2);
        if (friendship != null && !friendship.getIsDeleted()) {
            return friendship;
        }

        if (friendship != null && friendship.getIsDeleted()) {
            friendship.setIsDeleted(false);
            friendship.setIsAccepted(false);
            return friendRepository.save(friendship);
        }

        Friendship friendship1 = new Friendship();
        User user1 = userRepository.findById(userId1).orElse(null);
        User user2 = userRepository.findById(userId2).orElse(null);
        friendship1.setUser1(user1);
        friendship1.setUser2(user2);
        friendship1.setIsDeleted(false);
        friendship1.setIsAccepted(false);
        return friendRepository.save(friendship1);
    }

    @Override
    public Friendship deleteFriendShip(Integer userId1, Integer userId2) {
        Friendship friendship = friendRepository.findFriendshipByUserIds(userId1, userId2);
        if (friendship == null) {
            throw new RuntimeException("Không tìm thấy bạn bè");
        }

        if (friendship.getIsDeleted()) {
            throw new RuntimeException("Bạn bè đã bị xoá");
        }

        friendship.setIsDeleted(true);
        return friendRepository.save(friendship);
    }

    @Override
    public Friendship acceptFriendship(Integer userId1, Integer userId2) {
        Friendship friendship = friendRepository.findFriendshipByUserIds(userId1, userId2);

        if (friendship == null) {
            throw new RuntimeException("Không tìm thấy tình bạn");
        }

        if (friendship.getIsAccepted()) {
            throw new RuntimeException("Tình bạn này đã được chấp nhận");
        }

        if (friendship.getIsDeleted()) {
            friendship.setIsDeleted(false);
        }

        friendship.setIsAccepted(true);
        return friendRepository.save(friendship);
    }

    @Override
    public Friendship cancelFriendship(Integer userId1, Integer userId2) {
        Friendship friendship = friendRepository.findFriendshipByUserIds(userId1, userId2);
        if (friendship == null) {
            throw new RuntimeException("Không tìm thấy tình bạn");
        }
        if (friendship.getIsDeleted()) {
            throw new RuntimeException("Tình bạn đã xoá");
        }
        if (friendship.getIsAccepted()) {
            throw new RuntimeException("Tình bạn đã được chấp nhận");
        }
        friendship.setIsDeleted(true);
        return friendRepository.save(friendship);
    }

    @Override
    public List<UserDTO> suggestedFriendsList(Integer userId1, Integer userId2) {
        return friendRepository.suggestedFriendsList(userId1, userId2);
    }

    @Override
    public Page<UserDTO> suggestedFriendsListPage(Integer userId1, Integer userId2, Pageable pageable) {
        return friendRepository.suggestedFriendsListPage(userId1, userId2, pageable);
    }

    @Override
    public Page<UserDTO> friendRequestList(Integer userId, Pageable pageable) {
        return friendRepository.friendRequestList(userId, pageable);
    }

    @Override
    public String getFriendShipStatus(Integer userId1, Integer userId2) {
        Friendship friendship = friendRepository.findByUserIdsFriendShip(userId1, userId2);
        
        if (friendship == null) {
            return "notFriend";
        }

        if (friendship.getIsAccepted() && !friendship.getIsDeleted()) {
            return "friend";
        }

        if (friendship.getUser1().getId().equals(userId1)) {
            if (!friendship.getIsDeleted()) {
                return "pending";
            } else {
                return "deleted";
            }
        }

        if (friendship.getUser2().getId().equals(userId1)) {
            if (!friendship.getIsDeleted()) {
                return "waiting";
            } else {
                return "deleted";
            }
        }

        return "notFriend";
    }

}
