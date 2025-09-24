package com.login.baitap8.resolver;

import com.login.baitap8.entity.Category;
import com.login.baitap8.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
public class CategoryResolver {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @QueryMapping
    public List<Category> getAllCategories() {
        return categoryRepository.findAllWithProducts();
    }
    
    @QueryMapping
    public Optional<Category> getCategoryById(@Argument Long id) {
        return categoryRepository.findById(id);
    }
    
    @MutationMapping
    public Category createCategory(@Argument Map<String, Object> input) {
        Category category = new Category();
        category.setName((String) input.get("name"));
        category.setImages((String) input.get("images"));
        
        return categoryRepository.save(category);
    }
    
    @MutationMapping
    public Category updateCategory(@Argument Long id, @Argument Map<String, Object> input) {
        Optional<Category> optionalCategory = categoryRepository.findById(id);
        if (optionalCategory.isEmpty()) {
            throw new RuntimeException("Category not found with id: " + id);
        }
        
        Category category = optionalCategory.get();
        category.setName((String) input.get("name"));
        category.setImages((String) input.get("images"));
        
        return categoryRepository.save(category);
    }
    
    @MutationMapping
    public Boolean deleteCategory(@Argument Long id) {
        if (categoryRepository.existsById(id)) {
            categoryRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
