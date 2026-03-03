package com.eval.testtech.repository;

import com.eval.testtech.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
