'use strict';

angular.module('FitBoard')
	.service('Api', function ($http) {

		return {
			register: function (data, callback, callbackErr) {
				$http.post('/api/v1/auth/register', data).then(callback, callbackErr);
			},
		};

	}
);