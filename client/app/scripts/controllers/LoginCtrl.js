'use strict';

angular.module('FitBoard')
	.controller('LoginCtrl', function ($scope, authService, Api) {
		$scope.submit = function() {
			Api.login($scope.username, $scope.password, $scope.remember, 
				function(data){
					if (data.data.login === 'success'){
						authService.loginConfirmed();
					} else {
						$scope.errors.forbidden = 1;
					}
				},
				function(resp){
					if(resp.status === 503){
						$scope.errors.unavailable = true;
					}else{
						$scope.errors.internal =  true;
					}
				}
			);
		};
	}
);
