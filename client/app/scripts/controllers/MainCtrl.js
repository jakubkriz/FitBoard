angular.module('FitBoard').controller('MainCtrl', function($location, $scope, $state, Api) {
	'use strict';
	$scope.errors = {};

    // Set default value
    $scope.user = undefined;
    $scope.version = undefined;

    $scope.logout = function (){
      Api.logout(function(){
      	$state.reload();
      },function(){
      });
    };

});
