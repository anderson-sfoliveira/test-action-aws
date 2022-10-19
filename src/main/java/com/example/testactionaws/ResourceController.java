package com.example.testactionaws;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ResourceController {

    @GetMapping(value = "methodTest")
    public String methodTest(){
        return "Método para teste funcionando!!!!!! Com layers.";
    }
}
