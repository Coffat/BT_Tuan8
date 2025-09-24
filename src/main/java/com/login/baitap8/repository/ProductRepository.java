package com.login.baitap8.repository;

import com.login.baitap8.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Lấy tất cả products sắp xếp theo price từ thấp đến cao
    List<Product> findAllByOrderByPriceAsc();
    
    // Lấy products theo category
    @Query("SELECT p FROM Product p JOIN p.categories c WHERE c.id = :categoryId")
    List<Product> findByCategoryId(@Param("categoryId") Long categoryId);
    
    // Lấy products theo title
    List<Product> findByTitleContainingIgnoreCase(String title);
    
    // Lấy products theo price range
    List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);
    
    // Lấy products theo user
    List<Product> findByUserId(Long userId);
    
    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.categories LEFT JOIN FETCH p.user")
    List<Product> findAllWithCategoriesAndUser();
}
