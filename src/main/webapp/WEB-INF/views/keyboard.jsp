<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<!-- <script src="https://unpkg.com/hangul-js" type="text/javascript"></script> -->
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


	    var makeChar = function(i, m, t) {
	        var code = ((i * 21) + m) * 28 + t + 0xAC00;
	        return String.fromCharCode(code);
	    }
	    var iChrIndex = function(chr) {
	        var index = ((chr.charCodeAt(0) - 0xAC00) / 28) / 21;
	        return parseInt(index);
	    }
	    var mChrIndex = function(chr) {
	        var index = ((chr.charCodeAt(0)- 0xAC00) / 28) % 21;
	        return parseInt(index);
	    }
	    var tChrIndex = function(chr) {
	        var index = (chr.charCodeAt(0) - 0xAC00) % 28;
	        return parseInt(index);
	    }

	    // 초성
	    var indexI = [
	          'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ',
	          'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ',
	          'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']

	    // 중성
	    var indexM = [
	          'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ',
	          'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ',
	          'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ',
	          'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ' ];

	    // 종성
	    var indexT = [
	          '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ',
	          'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ',
	          'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

	    // 조합
	    var indexJComb1 = ['ㄳ','ㄵ','ㄶ','ㄺ','ㄻ','ㄼ','ㄽ','ㄾ','ㄿ','ㅀ','ㅄ'];
	    var indexJComb2 = ['ㄱㅅ','ㄴㅈ','ㄴㅎ','ㄹㄱ','ㄹㅁ','ㄹㅂ','ㄹㅅ','ㄹㅌ','ㄹㅍ','ㄹㅎ','ㅄ'];
	    var indexMComb1 = ['ㅘ','ㅙ','ㅚ','ㅝ','ㅞ','ㅟ','ㅢ'];
	    var indexMComb2 = ['ㅗㅏ','ㅗㅐ','ㅗㅣ','ㅜㅓ','ㅜㅔ','ㅜㅣ','ㅡㅣ'];

	    // 호환용 한글 자모 (3130~318F)
	    var jaCode = 'ㄱ'.charCodeAt(0);
	    var jaCodeLast = 'ㅎ'.charCodeAt(0);
	    var moCode = 'ㅏ'.charCodeAt(0);
	    var moCodeLast = 'ㅣ'.charCodeAt(0);
	    var $input = $('#input');
		var compVal = '';
		var lastPosition = '';
	    
		// 정확한 input의 길이를 계산하기 위해 사용
	    function calculateUTF8StringLength(str) {
	        let length = 0;
	        for (let i = 0; i < str.length; i++) {
	            const codePoint = str.codePointAt(i);
	            if (codePoint >= 0 && codePoint <= 127) {
	                // 1바이트 문자 (ASCII)
	                length++;
	            } else if (codePoint >= 128 && codePoint <= 2047) {
	                // 2바이트 문자
	                length += 2;
	            } else if (codePoint >= 2048 && codePoint <= 65535) {
	                // 3바이트 문자
	                length += 3;
	            } else if (codePoint >= 65536 && codePoint <= 1114111) {
	                // 4바이트 문자
	                length += 4;
	            }
	        }
	        return length;
	    }
	    
		var isAltActive = false;
	    $('.keyboard').on('click',
	    	    '.key:not(#key-tab):not(#key-caps):not(#key-left-ctrl):not(#key-right-ctrl):not(#key-left-alt):not(#key-enter):not(#key-right-alt):not(#key-backspace):not(#key-left-shift):not(#key-right-shift)'
	    	    , function(){
	    	    
	    	    inputValue += $(this).data('val');
	    	    	
	    		if(isAltActive){	  
		    	    var chr = $(this).text();
		    	    if ($(this).attr('id') === 'key-space') {
		    	        chr = ' ';
		    	    }
		    	    var text = $input.val();
	
		    	    $input.focus();
	
		    	    var chrCode = chr.charCodeAt(0);
		    	    var isJa = jaCode <= chrCode && chrCode <= jaCodeLast;
		    	    var isMo = moCode <= chrCode && chrCode <= moCodeLast;
	
		    	    if (text) {
		    	        var lastChr = text.substring(text.length - 1);
		    	        var lastChrCode = lastChr.charCodeAt(0);
		    	        if (jaCode <= lastChrCode && lastChrCode <= moCodeLast) {
		    	            // 자음,모음
		    	            if (jaCode <= lastChrCode && lastChrCode <= jaCodeLast) {
		    	                if (isMo) {
		    	                    var i = indexI.indexOf(lastChr);
		    	                    var m = indexM.indexOf(chr);
		    	                    var t = 0;
		    	                    var c = makeChar(i, m, t);
		    	                    $input.val(text.substring(0, text.length-1) + c);
		    	    	    		compVal = $input.val().charAt($input.val().length - 1);
// 		    	    	    	    console.log('compVal' ,compVal);
		    	                    return;
		    	                }
		    	            } 
		    	        } else if (lastChrCode >= 0xAC00 && lastChrCode <= 0xAC00 + 0x2BA4) {
		    	            // 한글
		    	            var i = iChrIndex(lastChr);
		    	            var m = mChrIndex(lastChr);
		    	            var t = tChrIndex(lastChr);
		    	            if (t == 0) {
		    	                // 종성이 없는경우
		    	                if (isJa) {
		    	                    t = indexT.indexOf(chr);
		    	                    if (t!=-1) { // 없는 종성문자인경우 제외
		    	                        var c = makeChar(i, m, t);
		    	                        $input.val(text.substring(0, text.length-1) + c);
		    	        	    		compVal = $input.val().charAt($input.val().length - 1);
// 		    	        	    	    console.log('compVal' ,compVal);
		    	                        return;
		    	                    }
		    	                } else if (isMo) {
		    	                    // 모음조합문자
		    	                    var chkChr = indexM[m] + chr;
		    	                    var combIndex = indexMComb2.indexOf(chkChr);
		    	                    if (combIndex!=-1) {
		    	                        var combChr = indexMComb1[combIndex];
		    	                        m = indexM.indexOf(combChr);
		    	                        var c = makeChar(i, m, t);
		    	                        $input.val(text.substring(0, text.length-1) + c);
		    	        	    		compVal = $input.val().charAt($input.val().length - 1);
// 		    	        	    	    console.log('compVal' ,compVal);
		    	                        return;
		    	                        
		    	                    }
		    	                }
		    	            } else {
		    	                // 종성이 있는경우
		    	                if (isMo) {
		    	                    var tChr = indexT[t];
	
		    	                    // 조합문자일경우 다시 쪼갠다
		    	                    var combIndex = indexJComb1.indexOf(tChr);
		    	                    if (combIndex!=-1) {
		    	                        var partChr = indexJComb2[combIndex];
		    	                        t = indexT.indexOf(partChr[0]);
		    	                        tChr = partChr[1];
		    	                    } else {
		    	                        t = 0;
		    	                    }
	
		    	                    var c1 = makeChar(i, m, t);
		    	                    i = indexI.indexOf(tChr);
		    	                    if (i!=-1) {
		    	                        m = indexM.indexOf(chr);
		    	                        var c2 = makeChar(i, m, 0);
		    	                        $input.val(text.substring(0, text.length-1) + c1 + c2);
		    	        	    		compVal = $input.val().charAt($input.val().length - 1);
// 		    	        	    	    console.log('compVal' ,compVal);
		    	                        return;
		    	                    }
		    	                } else if (isJa) {
		    	                    // 자음조합문자
		    	                    var chkChr = indexT[t] + chr;
		    	                    var combIndex = indexJComb2.indexOf(chkChr);
		    	                    if (combIndex!=-1) {
		    	                        var combChr = indexJComb1[combIndex];
		    	                        t = indexT.indexOf(combChr);
		    	                        var c = makeChar(i, m, t);
		    	                        $input.val(text.substring(0, text.length-1) + c);
		    	        	    		compVal = $input.val().charAt($input.val().length - 1);
// 		    	        	    	    console.log('compVal' ,compVal);
		    	                        return;
		    	                    }
		    	                }
		    	            }
		    	        }
		    	    }
		    	    $input.val(text + chr);
	    		} else if(!isAltActive){
	    			$('div[data-oval]').each(function(){
	 				  var originValue = $(this).data('oval');	
	 				  $(this).data('val', originValue);
	 				  console.log('else if inputValue : ', inputValue);	
	 				  $input.val(inputValue);
	 				});
	    		}
	    		
			    lastPosition = $input.val().charAt($input.val().length - 1);
	    	   
	    	});


		// 리셋하기
		$('#reset').on('click', function(){
			$('#input').val('');
			inputValue = '';
		});
		
		// 대소문자
		var isCapsActive = false;
		$(document).on('click', '#key-caps', function(){
			isCapsActive = !isCapsActive;
			
			if(isCapsActive && !isAltActive){
				$(this).css('background-color', '#53d9a8'); // 활성화된 상태의 배경색
				// 하나씩 가져와서 변경
			    $('div[data-original-text]').each(function(){
					var originValue = $(this).data('original-text');	
					$(this).data('val', originValue);
				});
				
            } else if(isCapsActive && isAltActive){
            	$(this).css('background-color', '#53d9a8'); 
            	$('div[data-right-alt-cap]').each(function(){
					var capValue = $(this).data('right-alt-cap');	
					$(this).data('val', capValue);
					$(this).text(capValue);
				});   
            	
            } else if(!isCapsActive && isAltActive){
            	$(this).css('background-color', '');
            	$('div[data-right-alt-val]').each(function(){
					var altValue = $(this).data('right-alt-val');	
					$(this).data('val', altValue);
					$(this).text(altValue);
				});
            	
            } else {
                $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
             	// 하나씩 가져와서 변경
                $('div[data-original-text]').each(function(){
					var altValue = $(this).data('original-text');	
					$(this).text(altValue);
				});
                $('div[data-oval]').each(function(){
					var originValue = $(this).data('oval');	
					$(this).data('val', originValue);
				});
            }		
		});
		
		// shift 사용
		var isShiftActive = false;
		$(document).on('click', '#key-left-shift, #key-right-shift', function(){
				isShiftActive = !isShiftActive;
				$(this).css('background-color', '#53d9a8'); // 활성화된 상태의 배경색
				
				if(isShiftActive && !isAltActive){
					
					$('div[data-shift-val]').each(function(){
						var shiftValue = $(this).data('shift-val');	
						$(this).data('val', shiftValue);
// 						console.log(shiftValue);
						$(this).text(shiftValue);
					});
					
				
	            } else if(isShiftActive && isAltActive){

	            	$('div[data-shift-alt-val]').each(function(){
						var shiftAltValue = $(this).data('shift-alt-val'); 
						$(this).data('val', shiftAltValue);
						$(this).text(shiftAltValue);
					});     	
	            	           	
	           } else if(!isShiftActive && isAltActive){
	        	   $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
	        	   
	            	$('div[data-right-alt-val]').each(function(){	
						var altValue = $(this).data('right-alt-val');
						$(this).data('val', altValue);
						$(this).text(altValue);
	            	});
	        	   
	        	   
						
			   } else {
	                $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
	              	//shift 비활성
	                $('div[data-original-text]').each(function(){
						var originValue = $(this).data('original-text'); 
						$(this).text(originValue);
	                });
	                
	                $('div[data-oval]').each(function(){
						var oValue = $(this).data('oval'); 
						$(this).data('val', oValue);
	                });
	                
	                isShiftActive = false;
	            }	
		});
		
		// shift는 한번만 활성하고 비활성화 하도록
		$('.keyboard').on('click', '.key:not(#key-left-shift, #key-right-shift)', function(){
		    if (isShiftActive && !isAltActive) {
		        $('#key-left-shift, #key-right-shift').css('background-color', ''); // 쉬프트 키 배경색 비활성화
		        $('div[data-original-text]').each(function(){
		            var originValue = $(this).data('original-text'); 
		            $(this).text(originValue);
		        });
		        
		        $('div[data-oval]').each(function(){
		            var oValue = $(this).data('oval'); 
		            $(this).data('val', oValue);
		        });
		        
		        isShiftActive = false; // 쉬프트 비활성화
		    }
		    
		    if(isShiftActive && isAltActive){
		    	$('#key-left-shift, #key-right-shift').css('background-color', ''); // 쉬프트 키 배경색 비활성화
		    	
		    	$('div[data-right-alt-val]').each(function(){
					var altValue = $(this).data('right-alt-val');
					$(this).text(altValue);
					$(this).data('val', altValue);
				});
		    	isShiftActive = false; // 쉬프트 비활성화
		    }
		    
		});
		
		//한영 변환
		$(document).on('click', '#key-right-alt' ,function(){
				isAltActive = !isAltActive;
				
				console.log('isCapsActive : ', isCapsActive);
				console.log('isAltActive : ', isAltActive);
				
				if(isAltActive && !isCapsActive){
					$(this).css('background-color', '#53d9a8');
					$('div[data-right-alt-val]').each(function(){
						var altValue = $(this).data('right-alt-val');
						$(this).text(altValue);
						$(this).data('val', altValue);
					});
				
	            } else if(isAltActive && isCapsActive){
	            	$(this).css('background-color', '#53d9a8');
					$('div[data-right-alt-cap]').each(function(){
						var capAltValue = $(this).data('right-alt-cap');
						$(this).text(capAltValue);
						$(this).data('val', capAltValue);
					});
	            }else {
	                $(this).css('background-color', ''); // 비활성화된 상태로 되돌리기
	                    
	                 $('div[data-original-text]').each(function(){
						var originValue = $(this).data('original-text'); 
						$(this).text(originValue);
	                });
	                
	                $('div[data-oval]').each(function(){
						var oValue = $(this).data('oval'); 
						$(this).data('val', oValue);
	                });
	                      
	                isAltActive = false;
	            }	
		});
		
		// 한글분해
		function disassembleHangul(chr) {
		    var result = [];
		    var chrCode = chr.charCodeAt(0);
		    
		    if (chrCode < 0xAC00 || chrCode > 0xD7A3) {
		        return chr; // 한글이 아닌 경우
		    }
		    
		    var i = iChrIndex(chr);
		    var m = mChrIndex(chr);
		    var t = tChrIndex(chr);
		    
		    result.push(indexI[i], indexM[m]);
		    
		    if (t !== 0) {
		        result.push(indexT[t]);
		    }
		    
		    return result;
		}

		// 한글조합
		function assembleHangul(chosung, jungsung, jongsung) {
		    var i = indexI.indexOf(chosung);
		    var m = indexM.indexOf(jungsung);
		    var t = indexT.indexOf(jongsung);
		    
		    if (i === -1 || m === -1) return chosung + jungsung;
		    return makeChar(i, m, t !== -1 ? t : 0);
		}
		
		// 삭제
		$('#key-backspace').on('click', function() {
		    var val = $input.val();
		    var lastChar = val.charAt(val.length - 1);

		    console.log('lastChar : ', lastChar);    
		    console.log('compVal : ', compVal);
		  
		    var updatedVal = val.slice(0, -1);		    
			var disassembled = disassembleHangul(compVal);
			
			if(/[ㄱ-ㅎㅏ-ㅣ가-힣]/.test(lastPosition)){
				if (/[ㄱ-ㅎㅏ-ㅣ가-힣]/.test(compVal) || !disassembled.length > 1) {
					
			        console.log('처음 받아온 disassembled : ', disassembled);
			   
			        if (disassembled.length > 1) {
			        	console.log('초중종');
			            disassembled.pop();
			            var updatedChar = disassembled.length > 1 ? assembleHangul(disassembled[0], disassembled[1], disassembled[2] || '') : disassembled[0];
			            console.log('updateChar : ', updatedChar);
			            updatedVal = val.slice(0, -1) + updatedChar;
				        console.log('disassembled 3의 : ', disassembled);
				     	compVal = updatedChar;
				        
			        } 
//	 		        else if (disassembled.length >= 2) {
//	 		        	console.log('초중');
//	 		        	disassembled.pop();
//	 		            var updatedChar = disassembled.length > 1 ? assembleHangul(disassembled[0], disassembled[1] || '') : disassembled[0];
//	 		            console.log('updateChar : ', updatedChar);
//	 		            updatedVal = val.slice(0, -1) + updatedChar;
//	 			        console.log('disassembled 2의 : ', disassembled);
//	 		        }
			    	
				    $('#input').val(updatedVal);
				    inputValue = updatedVal;
			    }
			}else{
		    	console.log('inputValue : ', inputValue);
		    	$('#input').val(updatedVal);
		    	inputValue = updatedVal;
		    }  
		    

		});
		
		
	});


</script>
<body>

	<div class="input-container">
        <input type="text" id="input" value="" readonly>
        <button id="reset">Reset</button>
    </div>
	
    <div class="keyboard">
        <div class="key" id="key-1" data-val="1"  data-oval="1" data-shift-val="!" data-right-alt-val="1" data-shift-alt-val="!" data-original-text="1">1</div>
        <div class="key" id="key-2" data-val="2" data-oval="2" data-shift-val="@" data-right-alt-val="2" data-shift-alt-val="@" data-original-text="2">2</div>
        <div class="key" id="key-3" data-val="3" data-oval="3"data-shift-val="#" data-right-alt-val="3" data-shift-alt-val="#" data-original-text="3">3</div>
        <div class="key" id="key-4" data-val="4" data-oval="4" data-shift-val="$" data-right-alt-val="4" data-shift-alt-val="$" data-original-text="4">4</div>
        <div class="key" id="key-5" data-val="5" data-oval="5" data-shift-val="%" data-right-alt-val="5" data-shift-alt-val="%" data-original-text="5">5</div>
        <div class="key" id="key-6" data-val="6" data-oval="6" data-shift-val="^" data-right-alt-val="6" data-shift-alt-val="^" data-original-text="6">6</div>
        <div class="key" id="key-7" data-val="7" data-oval="7"data-shift-val="&" data-right-alt-val="7" data-shift-alt-val="&" data-original-text="7">7</div>
        <div class="key" id="key-8" data-val="8" data-oval="8" data-shift-val="*" data-right-alt-val="8" data-shift-alt-val="*" data-original-text="8">8</div>
        <div class="key" id="key-9" data-val="9" data-oval="9" data-shift-val="(" data-right-alt-val="9" data-shift-alt-val="(" data-original-text="9">9</div>
        <div class="key" id="key-0" data-val="0" data-oval="0" data-shift-val=")" data-right-alt-val="0" data-shift-alt-val=")" data-original-text="0">0</div>
        <div class="key" id="key-minus" data-val="-" data-oval="-" data-shift-val="_" data-right-alt-val="-" data-shift-alt-val="_" data-original-text="-">-</div>
        <div class="key" id="key-equals" data-val="=" data-oval="=" data-shift-val="+" data-right-alt-val="=" data-shift-alt-val="+" data-original-text="=">=</div>
        
        <div class="key wide" id="key-backspace" data-val="">Backspace</div>
        <div class="key" id="key-tab" data-val="">Tab</div>
        
        <div class="key" id="key-q" data-val="q" data-oval="q" data-shift-val="Q" data-right-alt-val="ㅂ" data-right-alt-cap="ㅃ" data-shift-alt-val="ㅃ" data-original-text="Q">Q</div>
        <div class="key" id="key-w" data-val="w" data-oval="w" data-shift-val="W" data-right-alt-val="ㅈ" data-right-alt-cap="ㅉ" data-shift-alt-val="ㅉ" data-original-text="W">W</div>
        <div class="key" id="key-e" data-val="e" data-oval="e" data-shift-val="E" data-right-alt-val="ㄷ" data-right-alt-cap="ㄸ" data-shift-alt-val="ㄸ" data-original-text="E">E</div>
        <div class="key" id="key-r" data-val="r" data-oval="r" data-shift-val="R" data-right-alt-val="ㄱ" data-right-alt-cap="ㄲ" data-shift-alt-val="ㄲ" data-original-text="R">R</div>
        <div class="key" id="key-t" data-val="t" data-oval="t" data-shift-val="T" data-right-alt-val="ㅅ" data-right-alt-cap="ㅆ"  data-shift-alt-val="ㅆ"data-original-text="T">T</div>
        <div class="key" id="key-y" data-val="y" data-oval="y" data-shift-val="Y" data-right-alt-val="ㅛ"data-original-text="Y">Y</div>
        <div class="key" id="key-u" data-val="u" data-oval="u" data-shift-val="U" data-right-alt-val="ㅕ" data-original-text="U">U</div>
        <div class="key" id="key-i" data-val="i" data-oval="i" data-shift-val="I" data-right-alt-val="ㅑ" data-original-text="I">I</div>
        <div class="key" id="key-o" data-val="o" data-oval="o" data-shift-val="O" data-right-alt-val="ㅐ" data-right-alt-cap="ㅒ" data-shift-alt-val="ㅒ" data-original-text="O">O</div>
        <div class="key" id="key-p" data-val="p" data-oval="p" data-shift-val="P" data-right-alt-val="ㅔ" data-right-alt-cap="ㅖ"  data-shift-alt-val="ㅖ"data-original-text="P">P</div>
        <div class="key" id="key-left-bracket" data-val="[" data-oval="[" data-shift-val="{" data-right-alt-val="[" data-shift-alt-val="{" data-original-text="[">[</div>
        <div class="key" id="key-right-bracket" data-val="]" data-oval="]" data-shift-val="}" data-right-alt-val="]" data-shift-alt-val="}" data-original-text="]">]</div>
        <div class="key" id="key-backslash" data-val="\" data-oval="\" data-shift-val="|" data-right-alt-val="\" data-shift-alt-val="|" data-original-text="\">\</div>
        
        <div class="key" id="key-caps" data-val="">Caps</div>
        
        <div class="key" id="key-a" data-val="a" data-oval="a" data-shift-val="A" data-right-alt-val="ㅁ" data-original-text="A">A</div>
        <div class="key" id="key-s" data-val="s" data-oval="s" data-shift-val="S" data-right-alt-val="ㄴ" data-original-text="S">S</div>
        <div class="key" id="key-d" data-val="d" data-oval="d" data-shift-val="D" data-right-alt-val="ㅇ" data-original-text="D">D</div>
        <div class="key" id="key-f" data-val="f" data-oval="f" data-shift-val="F" data-right-alt-val="ㄹ" data-original-text="F">F</div>
        <div class="key" id="key-g" data-val="g" data-oval="g" data-shift-val="G" data-right-alt-val="ㅎ" data-original-text="G">G</div>
        <div class="key" id="key-h" data-val="h" data-oval="h" data-shift-val="H" data-right-alt-val="ㅗ" data-original-text="H">H</div>
        <div class="key" id="key-j" data-val="j" data-oval="j" data-shift-val="J" data-right-alt-val="ㅓ" data-original-text="J">J</div>
        <div class="key" id="key-k" data-val="k" data-oval="k" data-shift-val="K" data-right-alt-val="ㅏ" data-original-text="K">K</div>
        <div class="key" id="key-l" data-val="l" data-oval="l" data-shift-val="L" data-right-alt-val="ㅣ" data-original-text="L">L</div>
        <div class="key" id="key-semicolon" data-val=";" data-oval=";" data-shift-val=":" data-right-alt-val=";" data-shift-alt-val=":" data-original-text=";">;</div>
        <div class="key" id="key-quote" data-val="'" data-oval="'" data-shift-val="&quot" data-right-alt-val="'" data-shift-alt-val="&quot" data-original-text="'">'</div>
        
        <div class="key wide" id="key-enter" data-val="" >Enter</div>
        <div class="key wide" id="key-left-shift" data-val="">Shift</div>
        
        <div class="key" id="key-z" data-val="z" data-oval="z" data-shift-val="Z" data-right-alt-val="ㅋ" data-original-text="Z">Z</div>
        <div class="key" id="key-x" data-val="x" data-oval="x" data-shift-val="X" data-right-alt-val="ㅌ" data-original-text="X">X</div>
        <div class="key" id="key-c" data-val="c" data-oval="c" data-shift-val="C" data-right-alt-val="ㅊ" data-original-text="C">C</div>
        <div class="key" id="key-v" data-val="v" data-oval="v" data-shift-val="V" data-right-alt-val="ㅍ" data-original-text="V">V</div>
        <div class="key" id="key-b" data-val="b" data-oval="b" data-shift-val="B" data-right-alt-val="ㅠ" data-original-text="B">B</div>
        <div class="key" id="key-n" data-val="n" data-oval="n" data-shift-val="N" data-right-alt-val="ㅜ" data-original-text="N">N</div>
        <div class="key" id="key-m" data-val="m" data-oval="m" data-shift-val="M" data-right-alt-val="ㅡ" data-original-text="M">M</div>
        <div class="key" id="key-comma" data-val="," data-oval="," data-shift-val="&lt;" data-shift-alt-val="&lt;" data-right-alt-val="," data-original-text=",">,</div>
        <div class="key" id="key-period" data-val="." data-oval="." data-shift-val=">" data-shift-alt-val=">" data-right-alt-val="." data-original-text=".">.</div>
        <div class="key" id="key-slash" data-val="/" data-oval="/" data-shift-val="?" data-shift-alt-val="?" data-right-alt-val="/" data-original-text="/">/</div>
        
        <div class="key wide" id="key-right-shift" data-val="">Shift</div>
        <div class="key" id="key-left-ctrl" data-val="" >Ctrl</div>
        <div class="key" id="key-left-alt" data-val="" >Alt</div>
        <div class="key wide" id="key-space" data-val=" " data-oval=" " style="grid-column: span 10;">Space</div>
        <div class="key" id="key-right-alt" data-val="" >Alt</div>
        <div class="key" id="key-right-ctrl" data-val="" >Ctrl</div>
    </div>
</body>
</html>