var app = angular.module('myApp', ['ngAnimate', 'ui.bootstrap']);


/* equal height */

$('#mainRow').each(function() {
                        $(this).children('#place, #photo, #name, #gym, #border, #score').matchHeight({
    						property: 'ax-height',
                        });
                    });

/* 1st place 

$(document).ready(function() {
	$('#place').addClass(function() {
		if ({{athlete.place}} ==== 1) {
			return ".fplace";
		};
	});
});*/