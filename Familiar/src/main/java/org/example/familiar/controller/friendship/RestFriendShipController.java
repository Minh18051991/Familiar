package org.example.familiar.controller.friendship;

import org.example.familiar.dto.FriendShipDTO;
import org.example.familiar.service.friendship.IFriendsShipService;
import org.springframework.beans.factory.annotation.Autowired;
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

    @GetMapping("/{userId}")
    public ResponseEntity<List<FriendShipDTO>> listFriendShips(@PathVariable("userId") Integer userId) {
        System.out.println("==================");
        List<FriendShipDTO> listFriendShips = friendshipService.listFriendShips(userId);
        if (listFriendShips.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(listFriendShips, HttpStatus.OK);
    }
    @GetMapping("")
    public ResponseEntity<?> list() {
        return new ResponseEntity<>("hello",HttpStatus.OK);
    }
}
