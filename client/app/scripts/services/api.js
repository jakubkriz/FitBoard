'use strict';

angular.module('FitBoard')
	.service('Api', function ($http) {

		return {
			getParams: function ($scope, callback) {
				if ($scope.user === undefined){
					$http.get('/api/v1/const').then(function(data){

						$scope.user = data.data.user;
						$scope.version = data.data.ApiVersion;

						if (callback){ callback(); }
					});
				}else{
					if (callback){ callback(); }
				}
			},

			register: function (data, callback, callbackErr) {
				$http.post('/api/v1/auth/register', data).then(callback, callbackErr);
			},
			qual: function (compet, data, callback, callbackErr) {
				$http.post('/api/v1/competition/'+compet+'/qual', data).then(callback, callbackErr);
			},
			getRoster: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/roster').then(callback, callbackErr);
			},
			getUser: function (login, callback, callbackErr) {
				$http.get('/api/v1/auth/user'+'/'+login).then(callback, callbackErr);
			},
			login: function (username, passwd, remember, callback, callbackErr) {
				$http.post('/api/v1/auth/login',{'email':username,'password':passwd,'remember':remember}).then(callback, callbackErr);
			},
			logout: function (callback, callbackErr) {
				$http.get('/api/v1/auth/logout').then(callback, callbackErr);
			},
		};

	}
);