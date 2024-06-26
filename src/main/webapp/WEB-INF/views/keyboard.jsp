<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script src="https://unpkg.com/hangul-js" type="text/javascript"></script>
<style>
  body {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      background-color: #f0f0f0;
      flex-direction: column;
  }
  .input-container {
      display: flex;
      align-items: center;
      margin-bottom: 10px;
  }
  #input {
      width: 300px;
      height: 40px;
      padding: 5px;
      font-size: 18px;
      margin-right: 10px;
      border: 1px solid #ccc;
      border-radius: 5px;
  }
  #reset {
      padding: 10px 20px;
      font-size: 16px;
      cursor: pointer;
      background-color: #e0e0e0;
      border: 1px solid #ccc;
      border-radius: 5px;
      user-select: none;
  }
  #reset:active {
      background-color: #d0d0d0;
  }
  .keyboard {
      display: grid;
      grid-template-columns: repeat(14, 1fr);
      gap: 5px;
      padding: 10px;
      background-color: #ffffff;
      border: 1px solid #ccc;
      border-radius: 10px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  .key {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 40px;
      background-color: #e0e0e0;
      border: 1px solid #ccc;
      border-radius: 5px;
      cursor: pointer;
      user-select: none;
  }
  .key:active {
      background-color: #d0d0d0;
  }
  .key.wide {
      grid-column: span 2;
  }
  .key.space {
      grid-column: span 10; /* Adjusted space key span */
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 20px;
      font-weight: bold;
      background-color: #53d9a8; /* Custom color */
      color: #fff; /* Text color */
      border: 1px solid #53d9a8; /* Border color */
      border-radius: 8px; /* Rounded corners */
  }
</style>
</head>
<script>

	$(function(){
		
		var inputValue = '';
        
		$('.keyboard').on('click','.key', function(){
			
	        var val = $(this).data('val');
	        inputValue += val;
	        $('#input').val(Hangul.assemble(inputValue.split('')));
	        $('#input').focus();
	         
    	});				
		
		// 리셋하기
		$('#reset').on('click', function(){
			$('#input').val('');
			inputValue = '';
			values = [];
		});
		
		// 대소문자
		var isCapsActive = false;
		$('#key-caps').on('click', function(){
			isCapsActive = !isCapsActive;
			
			if(isCapsActive){
				$(this).css('background-color', '#53d9a8'); // 활성화된 상태의 배경색
				// 하나씩 가져와서 변경
				$('.key').each(function(){
					var value = $(this).data('val');
					if(value){
						if (typeof value === 'string') {
							var newVal = value.toUpperCase();
							$(this).data('val', newVal);
						}
					}
				});	
            } else {
                $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
             	// 하나씩 가져와서 변경
				$('.key').each(function(){
					var value = $(this).data('val');
					if(value){
						if (typeof value === 'string') {
							var newVal = value.toLowerCase();
							$(this).data('val', newVal);
						}
					}
				});	
            }		
		});
		
		// shift 사용
		var isShiftActive = false;
		$('#key-left-shift, #key-right-shift').on('click', function(){
				isShiftActive = !isShiftActive;
				
				if(isShiftActive){
					$(this).css('background-color', '#53d9a8'); // 활성화된 상태의 배경색
					$('div[data-shift-val]').each(function(){
						var shiftValue = $(this).data('shift-val'); // 특수문자를 담고
						var originValue = $(this).data('val'); // 원래 있던 문자를 담는다
							$(this).data('val', shiftValue); // 서로 스위치 해주기.
							$(this).data('shift-val', originValue);
							$(this).text(shiftValue);
					});
					
					// 하나씩 가져와서 변경
					$('.key').each(function(){
						var value = $(this).data('val');
						if(value){
							if (typeof value === 'string') {
								var newVal = value.toUpperCase();
								$(this).data('val', newVal);
							}
						}
					});	
					
	            } else {
	                $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
	              	//shift 비활성
	                $('div[data-shift-val]').each(function(){
						var originValue = $(this).data('shift-val'); // 스위치한것 반대로 가져오기
						var shiftValue = $(this).data('val'); 	
						$(this).data('val', originValue);
						$(this).data('shift-val', shiftValue);
						$(this).text(originValue);
	                });
	                $('.key').each(function(){
						var value = $(this).data('val');
						if(value){
							if (typeof value === 'string') {
								var newVal = value.toLowerCase();
								$(this).data('val', newVal);
							}
						}
					});	                
	                isShiftActive = false;
	            }	
		});
		
		//한영 변환
		var isAltActive = false;
		$('#key-right-alt').on('click', function(){
				isAltActive = !isAltActive;
				
				if(isAltActive){
					$(this).css('background-color', '#53d9a8'); // 활성화된 상태의 배경색
					console.log('#key-right-alt 실행');
					
					$('div[data-right-alt-val]').each(function(){
						var altValue = $(this).data('right-alt-val'); // 한글을 담고
						var originValue = $(this).data('val');
						$(this).text(altValue); 	//스위치 하기
						$(this).data('val', altValue);
						//소문자로
			            $(this).data('right-alt-val', originValue);
					});
					
					$(document).on('click', '#key-left-shift, #key-right-shift, #key-caps', function(){									
							$('div[data-right-alt-cap]').each(function(){
								var doubleValue = $(this).data('right-alt-cap');
								var originValue = $(this).data('val');
								$(this).text(doubleValue);
								$(this).data('val', doubleValue);
								$(this).data('right-alt-cap', originValue);
							});	
						});

	            } else {
	                $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
	                
	            	$(document).on('click', '#key-left-shift, #key-right-shift, #key-caps', function(){		
		                $('div[data-right-alt-cap]').each(function(){
							var originValue = $(this).data('right-alt-cap');
							var doubleValue = $(this).data('val');
							$(this).text(originValue);
							$(this).data('val', originValue);
							$(this).data('right-alt-cap', doubleValue);
						});
						isDoubleActive = false;
	            	});
	                
	                
	                // alt 비활성
	                $('div[data-right-alt-val]').each(function(){
						var originValue = $(this).data('right-alt-val'); // 스위치한것 반대로 가져오기
						var altValue = $(this).data('val');
						var originText = $(this).data('original-text');
						$(this).text(originText);
						$(this).data('val', originValue);
						$(this).data('right-alt-val', altValue);
	                });
	                      
	                isAltActive = false;
	            }	
		});
		
		
		
// 		// 이게 단 alt가 활성화되어있다는 가정하에를 넣어야함.
// 		var isDoubleActive = false;
// 		$(document).on('click', '#key-left-shift, #key-right-shift, #key-caps', function(){									
// 				isDoubleActive = !isDoubleActive;
// 				if(isDoubleActive){
// 					$('div[data-right-alt-cap]').each(function(){
// 						var doubleValue = $(this).data('right-alt-cap');
// 						var originValue = $(this).data('val');
// 						$(this).text(doubleValue);
// 						$(this).data('val', doubleValue);
// 						$(this).data('right-alt-cap', originValue);
// 					});	
// 				}else{
// 					$('div[data-right-alt-cap]').each(function(){
// 						var originValue = $(this).data('right-alt-cap');
// 						var doubleValue = $(this).data('val');
// 						$(this).text(originValue);
// 						$(this).data('val', originValue);
// 						$(this).data('right-alt-cap', doubleValue);
// 					});
// 					isDoubleActive = false;
// 				}
				
// 		});
		
		
		
		
		
		
		
		
		//삭제
		$('#key-backspace').on('click', function(){
	      	var val = $('#input').val();
			val = val.slice(0, -1);
			inputValue = val;
		});
		
		
	});


</script>
<body>

	<div class="input-container">
        <input type="text" id="input" readonly>
        <button id="reset">Reset</button>
    </div>
	
    <div class="keyboard">
        <div class="key" id="key-1" data-val="1" data-shift-val="!">1</div>
        <div class="key" id="key-2" data-val="2" data-shift-val="@">2</div>
        <div class="key" id="key-3" data-val="3" data-shift-val="#">3</div>
        <div class="key" id="key-4" data-val="4" data-shift-val="$">4</div>
        <div class="key" id="key-5" data-val="5" data-shift-val="%">5</div>
        <div class="key" id="key-6" data-val="6" data-shift-val="^">6</div>
        <div class="key" id="key-7" data-val="7" data-shift-val="&">7</div>
        <div class="key" id="key-8" data-val="8" data-shift-val="*">8</div>
        <div class="key" id="key-9" data-val="9" data-shift-val="(">9</div>
        <div class="key" id="key-0" data-val="0" data-shift-val=")">0</div>
        <div class="key" id="key-minus" data-val="-" data-shift-val="_">-</div>
        <div class="key" id="key-equals" data-val="=" data-shift-val="+">=</div>
        
        <div class="key wide" id="key-backspace" data-val="">Backspace</div>
        <div class="key" id="key-tab" data-val="">Tab</div>
        
        <div class="key" id="key-q" data-val="q" data-right-alt-val="ㅂ" data-right-alt-cap="ㅃ" data-original-text="Q">Q</div>
        <div class="key" id="key-w" data-val="w" data-right-alt-val="ㅈ" data-right-alt-cap="ㅉ" data-original-text="W">W</div>
        <div class="key" id="key-e" data-val="e" data-right-alt-val="ㄷ" data-right-alt-cap="ㄸ"data-original-text="E">E</div>
        <div class="key" id="key-r" data-val="r" data-right-alt-val="ㄱ" data-right-alt-cap="ㄲ" data-original-text="R">R</div>
        <div class="key" id="key-t" data-val="t" data-right-alt-val="ㅅ" data-right-alt-cap="ㅆ" data-original-text="T">T</div>
        <div class="key" id="key-y" data-val="y" data-right-alt-val="ㅛ"data-original-text="Y">Y</div>
        <div class="key" id="key-u" data-val="u" data-right-alt-val="ㅕ" data-original-text="U">U</div>
        <div class="key" id="key-i" data-val="i" data-right-alt-val="ㅑ" data-original-text="I">I</div>
        <div class="key" id="key-o" data-val="o" data-right-alt-val="ㅐ" data-right-alt-cap="ㅒ" data-original-text="O">O</div>
        <div class="key" id="key-p" data-val="p" data-right-alt-val="ㅔ" data-right-alt-cap="ㅖ" data-original-text="P">P</div>
        <div class="key" id="key-left-bracket" data-val="[" data-shift-val="{">[</div>
        <div class="key" id="key-right-bracket" data-val="]" data-shift-val="}">]</div>
        <div class="key" id="key-backslash" data-val="\" data-shift-val="|">\</div>
        
        <div class="key" id="key-caps" data-val="">Caps</div>
        
        <div class="key" id="key-a" data-val="a" data-right-alt-val="ㅁ" data-original-text="A">A</div>
        <div class="key" id="key-s" data-val="s" data-right-alt-val="ㄴ" data-original-text="S">S</div>
        <div class="key" id="key-d" data-val="d" data-right-alt-val="ㅇ" data-original-text="D">D</div>
        <div class="key" id="key-f" data-val="f" data-right-alt-val="ㄹ" data-original-text="F">F</div>
        <div class="key" id="key-g" data-val="g" data-right-alt-val="ㅎ" data-original-text="G">G</div>
        <div class="key" id="key-h" data-val="h" data-right-alt-val="ㅗ" data-original-text="H">H</div>
        <div class="key" id="key-j" data-val="j" data-right-alt-val="ㅓ" data-original-text="J">J</div>
        <div class="key" id="key-k" data-val="k" data-right-alt-val="ㅏ" data-original-text="K">K</div>
        <div class="key" id="key-l" data-val="l" data-right-alt-val="ㅣ" data-original-text="L">L</div>
        <div class="key" id="key-semicolon" data-val=";" data-shift-val=":">;</div>
        <div class="key" id="key-quote" data-val="'" data-shift-val="&quot">'</div>
        
        <div class="key wide" id="key-enter" data-val="">Enter</div>
        <div class="key wide" id="key-left-shift" data-val="">Shift</div>
        
        <div class="key" id="key-z" data-val="z" data-right-alt-val="ㅋ" data-original-text="Z">Z</div>
        <div class="key" id="key-x" data-val="x" data-right-alt-val="ㅌ" data-original-text="X">X</div>
        <div class="key" id="key-c" data-val="c" data-right-alt-val="ㅊ" data-original-text="C">C</div>
        <div class="key" id="key-v" data-val="v" data-right-alt-val="ㅍ" data-original-text="V">V</div>
        <div class="key" id="key-b" data-val="b" data-right-alt-val="ㅠ" data-original-text="B">B</div>
        <div class="key" id="key-n" data-val="n" data-right-alt-val="ㅜ" data-original-text="N">N</div>
        <div class="key" id="key-m" data-val="m" data-right-alt-val="ㅡ" data-original-text="M">M</div>
        <div class="key" id="key-comma" data-val="," data-shift-val="<">,</div>
        <div class="key" id="key-period" data-val="." data-shift-val=">">.</div>
        <div class="key" id="key-slash" data-val="/" data-shift-val="?">/</div>
        
        <div class="key wide" id="key-right-shift" data-val="">Shift</div>
        <div class="key" id="key-left-ctrl" data-val="">Ctrl</div>
        <div class="key" id="key-left-alt" data-val="">Alt</div>
        <div class="key wide" id="key-space" data-val=" "  style="grid-column: span 10;">Space</div>
        <div class="key" id="key-right-alt" data-val="">Alt</div>
        <div class="key" id="key-right-ctrl" data-val="">Ctrl</div>
    </div>
</body>
</html>