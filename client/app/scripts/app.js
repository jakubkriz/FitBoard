/* exported app*/
var app = angular.module('FitBoard', [
	'ngAnimate', 
	'ui.bootstrap', 
	'ngSanitize', 
	'ui.router', 
	'ui.grid',
	'ui.grid.cellNav',
	'ui.grid.edit',
	'ui.grid.resizeColumns',
	'ui.grid.pinning',
	'ui.grid.moveColumns',
	'ui.grid.exporter',
	'ui.grid.importer',
	'ngMessages',
	'xeditable'
]);

app.config(function($stateProvider, $urlRouterProvider) {
	'use strict';

	$urlRouterProvider.otherwise('404');
	$urlRouterProvider.when('', 'login');

	$stateProvider
	  .state('login', {
		url: '/login',
		templateUrl: 'views/login.html',
		controller: 'loginCtrl'
	  });

	$stateProvider
	 .state('reg', {
	  	url: '/reg',
		templateUrl: 'views/registration.html',
		controller: 'registrationCtrl'
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
	  .state('roster', {
		url: '/roster',
		templateUrl: 'views/roster.html',
		controller: 'rosterCtrl'
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
				.state('qual', {
				url: '/qual',
				templateUrl: 'views/User/User.qual.html',
				controller: 'qualCtrl'
			  });

						$stateProvider
						.state('submitvideo', {
						url: '/submitvideo',
						templateUrl: 'views/User/User.submitvideo.html',
						controller: 'qualCtrl'
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

				$stateProvider
				.state('user.judge', {
				url: '/judge',
				templateUrl: 'views/User/User.judge.html',
				controller: 'UserCtrl'

			  });

});

// editable theme
angular.module('FitBoard').run(function(editableOptions) {
		'use strict';
  editableOptions.theme = 'bs3';
});

