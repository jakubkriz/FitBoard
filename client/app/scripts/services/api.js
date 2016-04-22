'use strict';

angular.module('FitBoard')
	.service('Api', function ($http) {

		return {
			register: function (data, callback, callbackErr) {
				$http.post('/api/v1/auth/register', data).then(callback, callbackErr);
			},
			qual: function (compet, data, callback, callbackErr) {
				$http.post('/api/v1/competition/'+compet+'/qual', data).then(callback, callbackErr);
			},
			getRoster: function (compet, callback, callbackErr) {
				$http.get('/api/v1/competition/'+compet+'/roster').then(callback, callbackErr);
			},
		};

	}
);