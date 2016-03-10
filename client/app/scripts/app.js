/* exported app*/

var app = angular.module('myApp', ['ngRoute', 'ngAnimate', 'ui.bootstrap'])
.config(function($routeProvider) {
	'use strict';
    $routeProvider
      .when('/lb', {
        templateUrl: 'views/LeaderBoard.html',
        controller: 'LeaderBoardCtrl'
      });

//	$routeProvider.otherwise({redirectTo:'/main'});

//    $locationProvider.html5Mode({
//		enabled: true,
//  		requireBase: false
//	});
});