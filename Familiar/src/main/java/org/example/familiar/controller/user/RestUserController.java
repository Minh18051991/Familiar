package org.example.familiar.controller.user;
import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.service.user.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/users")
public class RestUserController {
    @Autowired
    private IUserService userService;
    @GetMapping("/{id}")
    public ResponseEntity<?> findById(@PathVariable Integer id) {
        UserDTO userDTO = userService.findById(id);
        if (userDTO != null) {
            return new ResponseEntity<>(userDTO, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
}
