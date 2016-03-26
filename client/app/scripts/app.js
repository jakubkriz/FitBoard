/* exported app*/

var app = angular.module('FitBoard', ['ngRoute', 'ngAnimate', 'ui.bootstrap', 'ngSanitize', 'ui.router']);

app.config(function($routeProvider) {
	'use strict';
    $routeProvider
      .when('/lb', {
        templateUrl: 'views/LeaderBoard.html',
        controller: 'LeaderBoardCtrl'
      });
      $routeProvider
      .when('/user', {
        templateUrl: 'views/User.html',
        controller: 'UserCtrl'
      });

//	$routeProvider.otherwise({redirectTo:'/main'});

//    $locationProvider.html5Mode({
//		enabled: true,
//  		requireBase: false
//	});
});
