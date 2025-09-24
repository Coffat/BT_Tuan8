package com.login.baitap8.resolver;

import com.login.baitap8.entity.Category;
import com.login.baitap8.entity.Product;
import com.login.baitap8.entity.User;
import com.login.baitap8.repository.CategoryRepository;
import com.login.baitap8.repository.ProductRepository;
import com.login.baitap8.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
public class ProductResolver {
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @QueryMapping
    public List<Product> getAllProducts() {
        return productRepository.findAllWithCategoriesAndUser();
    }
    
    @QueryMapping
    public List<Product> getProductsSortedByPrice() {
        return productRepository.findAllByOrderByPriceAsc();
    }
    
    @QueryMapping
    public List<Product> getProductsByCategory(@Argument Long categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }
    
    @QueryMapping
    public Optional<Product> getProductById(@Argument Long id) {
        return productRepository.findById(id);
    }
    
    @QueryMapping
    public List<Product> getProductsByUser(@Argument Long userId) {
        return productRepository.findByUserId(userId);
    }
    
    @MutationMapping
    public Product createProduct(@Argument Map<String, Object> input) {
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
    
    @MutationMapping
    public Product updateProduct(@Argument Long id, @Argument Map<String, Object> input) {
        Optional<Product> optionalProduct = productRepository.findById(id);
        if (optionalProduct.isEmpty()) {
            throw new RuntimeException("Product not found with id: " + id);
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
        
        return productRepository.save(product);
    }
    
    @MutationMapping
    public Boolean deleteProduct(@Argument Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
