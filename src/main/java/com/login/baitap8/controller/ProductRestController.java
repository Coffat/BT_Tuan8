package com.login.baitap8.controller;

import com.login.baitap8.entity.Category;
import com.login.baitap8.entity.Product;
import com.login.baitap8.entity.User;
import com.login.baitap8.repository.CategoryRepository;
import com.login.baitap8.repository.ProductRepository;
import com.login.baitap8.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductRestController {
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @GetMapping
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    @GetMapping("/sorted-by-price")
    public List<Product> getProductsSortedByPrice() {
        return productRepository.findAllByOrderByPriceAsc();
    }
    
    @GetMapping("/by-category/{categoryId}")
    public List<Product> getProductsByCategory(@PathVariable Long categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Optional<Product> product = productRepository.findById(id);
        return product.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public Product createProduct(@RequestBody Map<String, Object> input) {
        Product product = new Product();
        product.setTitle((String) input.get("title"));
        product.setQuantity((Integer) input.get("quantity"));
        product.setDescription((String) input.get("description"));
        
        // Convert price to BigDecimal
        Object priceObj = input.get("price");
        BigDecimal price;
        if (priceObj instanceof Double) {
            price = BigDecimal.valueOf((Double) priceObj);
        } else if (priceObj instanceof Integer) {
            price = BigDecimal.valueOf((Integer) priceObj);
        } else {
            price = new BigDecimal(priceObj.toString());
        }
        product.setPrice(price);
        
        // Set user if provided
        Object userIdObj = input.get("userId");
        if (userIdObj != null) {
            Long userId = Long.valueOf(userIdObj.toString());
            Optional<User> user = userRepository.findById(userId);
            user.ifPresent(product::setUser);
        }
        
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
            product.setCategories(categories);
        }
        
        return productRepository.save(product);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @RequestBody Map<String, Object> input) {
        Optional<Product> optionalProduct = productRepository.findById(id);
        if (optionalProduct.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        Product product = optionalProduct.get();
        product.setTitle((String) input.get("title"));
        product.setQuantity((Integer) input.get("quantity"));
        product.setDescription((String) input.get("description"));
        
        // Convert price to BigDecimal
        Object priceObj = input.get("price");
        BigDecimal price;
        if (priceObj instanceof Double) {
            price = BigDecimal.valueOf((Double) priceObj);
        } else if (priceObj instanceof Integer) {
            price = BigDecimal.valueOf((Integer) priceObj);
        } else {
            price = new BigDecimal(priceObj.toString());
        }
        product.setPrice(price);
        
        // Update user if provided
        Object userIdObj = input.get("userId");
        if (userIdObj != null) {
            Long userId = Long.valueOf(userIdObj.toString());
            Optional<User> user = userRepository.findById(userId);
            user.ifPresent(product::setUser);
        }
        
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
            product.setCategories(categories);
        }
        
        return ResponseEntity.ok(productRepository.save(product));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Boolean> deleteProduct(@PathVariable Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }
}
