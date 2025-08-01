package com.fisa.chat_service.repository;

import com.fisa.chat_service.entity.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    boolean existsByLoginId(String loginId);

    Optional<User> findByLoginId(String loginId);

}
