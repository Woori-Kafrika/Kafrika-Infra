package com.fisa.auth_service.repository;

import com.fisa.auth_service.entity.ChatMessage;
import com.fisa.auth_service.entity.ChatRoom;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChattingRepository extends JpaRepository<ChatMessage, Long> {

    List<ChatMessage> findByChatRoom(ChatRoom chatRoom);

}
