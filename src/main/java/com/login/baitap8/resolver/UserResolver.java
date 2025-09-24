package com.login.baitap8.resolver;

import com.login.baitap8.entity.Category;
import com.login.baitap8.entity.User;
import com.login.baitap8.repository.CategoryRepository;
import com.login.baitap8.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
public class UserResolver {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    @QueryMapping
    public List<User> getAllUsers() {
        return userRepository.findAllWithCategories();
    }
    
    @QueryMapping
    public Optional<User> getUserById(@Argument Long id) {
        return userRepository.findById(id);
    }
    
    @QueryMapping
    public Optional<User> getUserByEmail(@Argument String email) {
        return userRepository.findByEmail(email);
    }
    
    @MutationMapping
    public User createUser(@Argument Map<String, Object> input) {
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
    
    @MutationMapping
    public User updateUser(@Argument Long id, @Argument Map<String, Object> input) {
        Optional<User> optionalUser = userRepository.findById(id);
        if (optionalUser.isEmpty()) {
            throw new RuntimeException("User not found with id: " + id);
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
        
        return userRepository.save(user);
    }
    
    @MutationMapping
    public Boolean deleteUser(@Argument Long id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
