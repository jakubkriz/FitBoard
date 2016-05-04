angular.module('FitBoard').controller('UserCtrl', function($scope, Api) {
	'use strict';

	$scope.athlete = null;

    // Set User
    Api.getParams( $scope, function(){
    	Api.getUser($scope.user, function(data){
    		$scope.athlete = data.data;
    	},function(err){
    		$scope.err = err;
    	});
    } );

	//dropdown controller
	$scope.status = {
		isopen: false
	};

	// sex remote
	$scope.sex = [
	    {value: 'male', text: 'male'},
	    {value: 'female', text: 'female'}
  	];

	// editBasic
	$scope.opened = {};

	$scope.open = function($event, elementOpened) {
		$event.preventDefault();
		$event.stopPropagation();

		$scope.opened[elementOpened] = !$scope.opened[elementOpened];
	};

});