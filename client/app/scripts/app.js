/* exported app*/
var app = angular.module('FitBoard', ['ngAnimate', 'ui.bootstrap', 'ngSanitize', 'ui.router', 'ui.grid']);

app.config(function($stateProvider, $urlRouterProvider) {
	'use strict';

	$urlRouterProvider.otherwise('404');
	//$urlRouterProvider.when('', 'reg');

	$stateProvider
	  .state('login', {
		url: '',
		templateUrl: 'views/login.html',
		controller: 'loginCtrl'
	  });

	$stateProvider
	 .state('reg', {
	  	url: '/reg',
		templateUrl: 'views/registration.html',
	  });

	$stateProvider
	  .state('404', {
		url: '/404',
		templateUrl: 'views/404.html',
	  });

	$stateProvider
	  .state('lb', {
		url: '/lb',
		templateUrl: 'views/LeaderBoard.html',
		controller: 'LeaderBoardCtrl'
	  });

	  $stateProvider
		.state('user', {
		url: '/user',
		templateUrl: 'views/User/User.html',
		controller: 'UserCtrl'
	  });
			$stateProvider
			.state('user.dashboard', {
			url: '/dash',
			templateUrl: 'views/User/User.dashboard.html',
			controller: 'UserCtrl'
		  });

			$stateProvider
			.state('user.events', {
			url: '/events',
			templateUrl: 'views/User/User.events.html',
			controller: 'UserCtrl'
		  });

			$stateProvider
			.state('user.qual', {
			url: '/qual',
			templateUrl: 'views/User/User.qual.html',
			controller: 'UserCtrl'
		  });

			$stateProvider
			.state('user.profile', {
			url: '/profile',
			templateUrl: 'views/User/User.profile.html',
			controller: 'UserCtrl'
		  });

			$stateProvider
			.state('user.admin', {
			url: '/admin',
			templateUrl: 'views/User/User.admin.html',
			controller: 'AdminCtrl'

		  });

});