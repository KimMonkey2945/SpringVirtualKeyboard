package com.spring.keyboard.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class SpringKeyboardController {
	
	 private static final Logger logger = Logger.getLogger(SpringKeyboardController.class);
	
	//로그인 화면 호출
	@RequestMapping(value = "/keyboard.do" ,method = RequestMethod.GET)
	public String loginForm() {
		return "keyboard";
	}

}
