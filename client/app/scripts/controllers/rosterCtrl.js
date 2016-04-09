angular.module('FitBoard').controller('rosterCtrl', function($scope, Api) {
	'use strict';

	$scope.sortType     = 'score'; // set the default sort type
	$scope.sortReverse  = true;  // set the default sort order
	$scope.searchName   = '';

	// Initialization
	$scope.category      = 'elite';
	$scope.sex           = 'male';

	Api.getRoster('fitmonster2016', 
		function(data){
			$scope.athletes = data.data.users;
		},
		function(resp){ //ERROR
			if(resp.status === 503){
				$scope.errors.unavailable = true;
			}else{
				$scope.errors.internal =  true;
			}
		}
	);

});
