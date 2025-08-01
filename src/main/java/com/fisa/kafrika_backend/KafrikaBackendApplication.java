package com.fisa.kafrika_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class KafrikaBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(KafrikaBackendApplication.class, args);
	}

}
