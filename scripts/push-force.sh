#!/bin/bash
set -e

# Script examinateur : à exécuter pendant que le candidat développe sur sa branche.
# Modifie UserController et UserRepository sur main, puis push force.

git checkout main

# Modifier le contrôleur : renommer /api/users en /api/v1/users + ajout filtre par name
cat > src/main/java/com/eval/testtech/controller/UserController.java << 'JAVAEOF'
package com.eval.testtech.controller;

import com.eval.testtech.model.User;
import com.eval.testtech.repository.UserRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<User> getAllUsers(@RequestParam(required = false) String name) {
        if (name != null) {
            return userRepository.findByNameContainingIgnoreCase(name);
        }
        return userRepository.findAll();
    }
}
JAVAEOF

# Ajouter la méthode de recherche par nom au repository
cat > src/main/java/com/eval/testtech/repository/UserRepository.java << 'JAVAEOF'
package com.eval.testtech.repository;

import com.eval.testtech.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findByNameContainingIgnoreCase(String name);
}
JAVAEOF

git add -A
git commit -m "refactor: migrate API to v1 and add name filter"
git push --force origin main

echo "Push force effectué. Le candidat devra rebaser sa branche."
