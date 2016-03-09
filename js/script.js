$(document).ready(function(){


	var min_rand = 18
	var max_rand = 632
	var counter = 0
	var counter_whore = 0
	var lives = 3		
	var whore_animate
	var right_direction = true
	var total_time = 0



    function intersects(a, b) {
      var x1 = a.offset().left;
      var y1 = a.offset().top;
      var h1 = a.outerHeight(true) - 18 ;
      var w1 = a.outerWidth(true);
      var b1 = y1 + h1;
      var r1 = x1 + w1;
      var x2 = b.offset().left;
      var y2 = b.offset().top;
      var h2 = b.outerHeight(true);
      var w2 = b.outerWidth(true);
      var b2 = y2 + h2;
      var r2 = x2 + w2;
        
      if (b1 < y2 || y1 > b2 || r1 < x2 || x1 > r2) return false;
      return true;
    }


	function whore_animation() {
			var timerId = setInterval(function() {
				total_time +=50;
				$.each($(".whore"), function(i, whore) {
					$whore = $(whore)
				  $whore.animate({ "top": "+=5px" }, 50 );
				  	var cross = intersects($whore, $('.catcher'));
					if (cross == true) {
						$('body').append('<audio src="coinsound.mp3" autoplay ></audio>')
						counter += 1
						$('.whore-counter').html("ШЛЮХ: " + counter)
						$whore.remove();
						whore_builder()

						console.log( (counter/(counter_whore)) )

						if ( counter/(counter_whore) > 0.8 ){
							whore_builder()
						}



						
					}else if ( $whore.position().top > 400 ){
						lives -= 1;
						console.log(lives);
						$('.live-counter span').text("x " + lives);
						$whore.remove();
						whore_builder();
						if (lives < 1){
							$(".whore").remove();
							$('.wrapper').fadeIn('slow').addClass('finish-wrapper');
							$('.total_time').html("Время игры: " + (total_time/1000));
							console.log(counter);
							$('.total_whore').html("ШЛЮХ: " + counter);
							clearInterval(timerId);
							// alert('finish!');
							// alert('Время игры ' + (total_time/1000) + ' секунд'+ '\n' +'Поймано шлюх: '+ counter);
						} 
					}
				})
			}, 50);	

	}

	var  whore_builder = function whore_builder() {
		setTimeout(function() {
			$whore = $('<div class="whore"></div>')
        	$whore.fadeIn('slow').prependTo('.wrapper');
			$whore.css('left', Math.floor(Math.random() * 600));
			counter_whore +=1

		}, Math.floor(Math.random() * 2000))
	
	}

	$('.start_button').click(function(){
	  	$('.headpiece').remove();
	  	console.log($('audio').attr('src'));
	  	$('audio').attr('src', 'bit.mp3')
	  	

	  	whore_builder()	
		window.whore_builder = whore_builder
		whore_animation()
	});
	

	

	$('body').keypress(function(eventObject){

		if (eventObject.which == '97') {
			console.log('Left buttom')
			$('.catcher').removeClass('right-direction').addClass('left-direction');
			$('.catcher-head').removeClass('right-direction').addClass('left-direction');
			$('.catcher-basket').removeClass('right-direction').addClass('left-direction');


			if (right_direction == true) {
				$('.catcher-head').css('left', '+=100px');
				$('.catcher-basket').css('left', '+=100px');
			}

			right_direction = false

			if ($('.catcher').position().left >= '10') {
				$('.catcher').css('left', '-=20px');
				$('.catcher-head').css('left', '-=20px');
				$('.catcher-basket').css('left', '-=20px');

			}

		} else if (eventObject.which == '100') { 
			console.log('Right buttom');
			$('.catcher').removeClass('left-direction').addClass('right-direction');
			$('.catcher-head').removeClass('left-direction').addClass('right-direction');
			$('.catcher-basket').removeClass('left-direction').addClass('right-direction');

			if (right_direction == false) {
				$('.catcher-head').css('left', '-=100px');
				$('.catcher-basket').css('left', '-=100px');
			}

			right_direction = true

			if ($('.catcher').position().left <= '555') {
				$('.catcher').css('left', '+=20px');
				$('.catcher-head').css('left', '+=20px');
				$('.catcher-basket').css('left', '+=20px');
			}
		  			
		}
		// var cross1 = intersects($( ".whore" ), $('.catcher'));
		// console.log(cross1);
	});

});