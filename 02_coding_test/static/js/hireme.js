var stage = document.getElementById('stage');

window.onload = function start() {
		stage.innerHTML = '<span id="color">Hire me</span>';
	    color();
	    slide();
	}

	function slide() {	
	    window.setInterval(function () {
			var x = Math.floor(Math.random()*700);
			var y = Math.floor(Math.random()*2000);
			stage.style.top = x + 'px';
			stage.style.left = y + 'px';

		}, 200);
	}

	function color() {
		window.setInterval(function () {
			var r = Math.floor(Math.random() * (255 - 0 + 1) + 0);
			var g = Math.floor(Math.random() * (255 - 0 + 1) + 0);
			var b = Math.floor(Math.random() * (255 - 0 + 1) + 0);
			var rgbString = r + ", " + g + ", " + b;
			document.getElementById('color').style.color = 'rgb(' + rgbString + ')';
		}, 200);
	}