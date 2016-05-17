angular.module('FitBoard').controller('StartBoardCtrl', function($scope, Api) {
	'use strict';

	$scope.sortType     = 'startN'; // set the defaulr sort type
	$scope.sortReverse  = false;  // set the defaulr sort order
	$scope.searchName   = '';

	$scope.placeText = 'OVERALL';

	// Colapse support
	$scope.isCollapsed = true;

	// Initialization
	$scope.category 	 = 'elite';
	$scope.sex		     = 'male';

	$scope.$watch('sex', function() {
		if ($scope.sex === 'male') {
			$scope.sexHeaderHtml = 'MEN';
		} else {
			$scope.sexHeaderHtml = 'WOMEN';
		}
	}, 'true');

	// rowClass
	$scope.rowClass = function(athlete, place){
		if($scope.getPlace(athlete, place) === 1){
			return 'mainRowFirst';
		 }
		// else if (index === 1){
		// 	return 'mainRowSecond';
		// }
		else if (athlete.qualified === 0){
			return 'mainRowDNQ';
		} else {
			return 'mainRow';
		}
	};

	$scope.getPlace = function(athlete, place) {
		return athlete.startN;
 	};

 //Search by firstName and lastName at the same time
 $scope.searchName = function(item) {
 		// to search by full name as well as only by first name or last name
 		var name = item.firstName.toLowerCase() + '' + item.lastName.toLowerCase();
    if (!$scope.query ||
    	(item.firstName.toLowerCase().indexOf($scope.query.toLowerCase()) > -1) ||
    	(item.lastName.toLowerCase().indexOf($scope.query.toLowerCase()) > -1) ||
    	(name.indexOf($scope.query.toLowerCase()) > -1)) {
        return true;
    }
    return false;
 };

////////////////////////// Athletes  ////////////////////////////////////

	$scope.athletes = [];

	Api.getSb('fitmonster2016', 
		function(data){
			$scope.athletes = data.data.sb;
		},
		function(resp){ //ERROR
			if(resp.status === 503){
				$scope.errors.unavailable = true;
			}else{
				$scope.errors.internal =  true;
			}
		}
	);

	// {
	// 	firstName: 'Athlete',
	// 	lastName: 'Name 13',
	// 	sex: 'male',
	// 	gym: 'independent',
	// 	category: 'elite',
	// 	photo: '',
	// 	pointsA: 0,
	// 	pointsB: 0,
	// 	pointsO: 0,
	// 	placeA: 13,
	// 	placeB: 13,
	// 	placeOV: 13,
	// 	qualified: 0
	// }
});
