package com.login.baitap8.controller;

import com.login.baitap8.entity.Category;
import com.login.baitap8.entity.User;
import com.login.baitap8.repository.CategoryRepository;
import com.login.baitap8.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserRestController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        Optional<User> user = userRepository.findById(id);
        return user.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/by-email/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        Optional<User> user = userRepository.findByEmail(email);
        return user.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public User createUser(@RequestBody Map<String, Object> input) {
        User user = new User();
        user.setFullname((String) input.get("fullname"));
        user.setEmail((String) input.get("email"));
        
        // Encrypt password
        String password = (String) input.get("password");
        user.setPassword(passwordEncoder.encode(password));
        
        user.setPhone((String) input.get("phone"));
        
        // Set categories if provided
        @SuppressWarnings("unchecked")
        List<String> categoryIds = (List<String>) input.get("categoryIds");
        if (categoryIds != null && !categoryIds.isEmpty()) {
            HashSet<Category> categories = new HashSet<>();
            for (String categoryIdStr : categoryIds) {
                Long categoryId = Long.valueOf(categoryIdStr);
                Optional<Category> category = categoryRepository.findById(categoryId);
                category.ifPresent(categories::add);
            }
            user.setCategories(categories);
        }
        
        return userRepository.save(user);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody Map<String, Object> input) {
        Optional<User> optionalUser = userRepository.findById(id);
        if (optionalUser.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        User user = optionalUser.get();
        user.setFullname((String) input.get("fullname"));
        user.setEmail((String) input.get("email"));
        
        // Update password if provided
        String password = (String) input.get("password");
        if (password != null && !password.isEmpty()) {
            user.setPassword(passwordEncoder.encode(password));
        }
        
        user.setPhone((String) input.get("phone"));
        
        // Update categories if provided
        @SuppressWarnings("unchecked")
        List<String> categoryIds = (List<String>) input.get("categoryIds");
        if (categoryIds != null) {
            HashSet<Category> categories = new HashSet<>();
            for (String categoryIdStr : categoryIds) {
                Long categoryId = Long.valueOf(categoryIdStr);
                Optional<Category> category = categoryRepository.findById(categoryId);
                category.ifPresent(categories::add);
            }
            user.setCategories(categories);
        }
        
        return ResponseEntity.ok(userRepository.save(user));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Boolean> deleteUser(@PathVariable Long id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }
}
