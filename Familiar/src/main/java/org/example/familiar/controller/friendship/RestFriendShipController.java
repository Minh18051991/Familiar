package org.example.familiar.controller.friendship;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.model.Friendship;
import org.example.familiar.service.friendship.IFriendsShipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("api/friendships")
public class RestFriendShipController {
    @Autowired
    private IFriendsShipService friendshipService;

    @GetMapping("/list/{userId}")
    public ResponseEntity<List<UserDTO>> listFriendShips(@PathVariable("userId") Integer userId) {
        List<UserDTO> listFriendShips = friendshipService.listFriendShips(userId);
        if (listFriendShips.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(listFriendShips, HttpStatus.OK);
    }

    @GetMapping("/search/{userId}")
    public ResponseEntity<List<UserDTO>> searchFriendShips(@PathVariable("userId") Integer userId,
                                                           @RequestParam(name = "name_like", defaultValue = "") String searchName) {
        List<UserDTO> listFriendship = friendshipService.searchNameFriendships(userId, searchName);
        if (listFriendship.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(listFriendship, HttpStatus.OK);
    }

    @PostMapping("/send/{userId1}/{userId2}")
    public ResponseEntity<?> sendFriendship(@PathVariable("userId1") Integer userId1, @PathVariable("userId2") Integer userId2) {
        Friendship friendship = friendshipService.sendFriendship(userId1, userId2);
        return new ResponseEntity<>(friendship, HttpStatus.OK);
    }

    @DeleteMapping("/delete/{userId1}/{userId2}")
    public ResponseEntity<?> deleteFriendShip(@PathVariable("userId1") Integer userId1, @PathVariable("userId2") Integer userId2) {
        try {
            Friendship updatedFriendship = friendshipService.deleteFriendShip(userId1, userId2);
            return new ResponseEntity<>(updatedFriendship, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>("Đã xảy ra lỗi", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/accept/{userId1}/{userId2}")
    public ResponseEntity<?> acceptFriendship(@PathVariable("userId1") Integer userId1, @PathVariable("userId2") Integer userId2) {
        try {
            Friendship updatedFriendship = friendshipService.acceptFriendship(userId1, userId2);
            return new ResponseEntity<>(updatedFriendship, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>("Đã xảy ra lỗi", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/cancel/{userId1}/{userId2}")
    public ResponseEntity<?> cancelFriendship(@PathVariable("userId1") Integer userId1, @PathVariable("userId2") Integer userId2) {
        try {
            Friendship updatedFriendship = friendshipService.cancelFriendship(userId1, userId2);
            return new ResponseEntity<>(updatedFriendship, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>("Đã xảy ra lỗi", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/suggestions-page/{userId1}/{userId2}")
    public ResponseEntity<Page<UserDTO>> suggestedFriendsListPage(@PathVariable("userId1") Integer userId1,
                                                                  @PathVariable("userId2") Integer userId2,
                                                                  @RequestParam(name = "_page",required = false, defaultValue = "0") int page,
                                                                  @RequestParam(name = "_limit", required = false, defaultValue = "5") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<UserDTO> friendList = friendshipService.suggestedFriendsListPage(userId1, userId2, pageable);
        if (friendList.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(friendList, HttpStatus.OK);
    }

    @GetMapping("/request/{userId}")
    public ResponseEntity<Page<UserDTO>> friendRequestList(@PathVariable("userId") Integer userId,
                                                           @RequestParam(name = "_page",required = false, defaultValue = "0") int page,
                                                           @RequestParam(name = "_limit", required = false, defaultValue = "5") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<UserDTO> listFriendRequest = friendshipService.friendRequestList(userId, pageable);
        if (listFriendRequest.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(listFriendRequest, HttpStatus.OK);
    }

    @GetMapping("/status/{userId1}/{userId2}")
    public ResponseEntity<?> getFriendShipStatus(@PathVariable("userId1") Integer userId1,
                                                 @PathVariable("userId2") Integer userId2){
        String status = friendshipService.getFriendShipStatus(userId1, userId2);
        if (status == null) {
            return new ResponseEntity<>("Status not found", HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(status, HttpStatus.OK);
    }

}

