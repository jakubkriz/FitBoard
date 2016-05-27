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
			getLbQual: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/app/lb').then(callback, callbackErr);
			},
			getLbWod: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/user').then(callback, callbackErr);
			},
			getSb: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/app/sb').then(callback, callbackErr);
			},
			getAdmin: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/user').then(callback, callbackErr);
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
			getQual: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/app/qual').then(callback, callbackErr);
			},
			reserveQual: function (compet, qual, callback, callbackErr) {
				$http.post('/api/v1/competition/'+compet+'/app/qual/reserve', {'login':qual}).then(callback, callbackErr);
			},
			cancelQual: function (compet, callback, callbackErr) {
				$http.delete('/api/v1/competition/'+compet+'/app/qual/reserve').then(callback, callbackErr);
			},
			judgeQual: function (compet, qual, callback, callbackErr) {
				$http.post('/api/v1/competition/'+compet+'/app/qual/judge', qual).then(callback, callbackErr);
			},
			saveScore: function (compet, id, data, callback, callbackErr) {
				$http.put('/api/v1/competition/'+compet+'/user/'+id, data).then(callback, callbackErr);
			},
		};

	}
);
