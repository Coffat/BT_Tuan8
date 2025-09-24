package com.login.baitap8.controller;

import com.login.baitap8.entity.Category;
import com.login.baitap8.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/categories")
@CrossOrigin(origins = "*")
public class CategoryRestController {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @GetMapping
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Category> getCategoryById(@PathVariable Long id) {
        Optional<Category> category = categoryRepository.findById(id);
        return category.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public Category createCategory(@RequestBody Map<String, Object> input) {
        Category category = new Category();
        category.setName((String) input.get("name"));
        category.setImages((String) input.get("images"));
        
        return categoryRepository.save(category);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Category> updateCategory(@PathVariable Long id, @RequestBody Map<String, Object> input) {
        Optional<Category> optionalCategory = categoryRepository.findById(id);
        if (optionalCategory.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        Category category = optionalCategory.get();
        category.setName((String) input.get("name"));
        category.setImages((String) input.get("images"));
        
        return ResponseEntity.ok(categoryRepository.save(category));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Boolean> deleteCategory(@PathVariable Long id) {
        if (categoryRepository.existsById(id)) {
            categoryRepository.deleteById(id);
            return ResponseEntity.ok(true);
        }
        return ResponseEntity.ok(false);
    }
}
