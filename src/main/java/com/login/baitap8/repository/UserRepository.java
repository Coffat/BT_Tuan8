package com.login.baitap8.repository;

import com.login.baitap8.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByEmail(String email);
    
    List<User> findByFullnameContainingIgnoreCase(String fullname);
    
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.products")
    List<User> findAllWithProducts();
    
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.categories")
    List<User> findAllWithCategories();
}
