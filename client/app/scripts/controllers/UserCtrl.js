angular.module('FitBoard').controller('UserCtrl', function($scope, Api) {
	'use strict';

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

// overall score
// if ($scope.athlete.pointsA.split(':').length === 2) { // score is time
//     	$scope.athlete.overallA = $scope.athlete.pointsA.split(':')[0] + ':' + (parseInt($scope.athlete.pointsA.split(':')[1]) + $scope.athlete.norepA * 5).toString();
// 		} else { // score is a number
//     	$scope.athlete.overallA = parseInt($scope.athlete.pointsA) + $scope.athlete.norepA;
//     }

// Judge
	
	$scope.nextToJudge = true;

});