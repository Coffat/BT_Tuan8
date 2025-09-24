package com.login.baitap8.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {
    
    @GetMapping("/")
    public String index() {
        return "index";
    }
    
    @GetMapping("/products")
    public String products() {
        return "products";
    }
    
    @GetMapping("/users")
    public String users() {
        return "users";
    }
    
    @GetMapping("/categories")
    public String categories() {
        return "categories";
    }
}
