/* global qualvideoForm*/

function clone(obj) {
	'use strict';
    if (null === obj || 'object' !== typeof obj){
    	return obj;
    }
    var copy = obj.constructor();
    for (var attr in obj) {
        if (obj.hasOwnProperty(attr)){
        	copy[attr] = obj[attr];
        }
    }
    return copy;
}

angular.module('FitBoard').controller('qualCtrl', function($scope, $uibModal, Api) {
	'use strict';

	// Clean errors
	$scope.errors = {};
	$scope.errors.emailAlreadyExists = false; //400
	$scope.errors.internal = false; //500
	$scope.errors.unavailable = false; //503

	// Set default
	$scope.athlete = {};

	$scope.setDefault = function(){
		$scope.athlete = {
			login: '',
			points: 0,
			video: '',
		};
	};
	$scope.setDefault();

	// Submit registration
	$scope.submit = function() {
		if ($scope.athlete.video && $scope.athlete.login) {
			var athl = clone($scope.athlete);

			// Clean errors
			$scope.errors.emailError = false;
			$scope.errors.emailAlreadyExists = false;
			$scope.errors.badRequest = false;
			$scope.errors.unavailable = false;
			$scope.errors.internal =  false;

			Api.qual('fitmonster2016',
				athl,
				function(resp){ // OK
					if (resp){

						// Show modal page
						$uibModal.open({
							animation: true,
							templateUrl: 'views/utilities/videoSubmitted.html',
							controller: 'ModalInstanceCtrl',
							size: 'm',
							backdrop: 'static',
							keyboard: false
						});
//						$scope.setDefault();
					}
				},
				function(resp){ //ERROR

					if (resp.status === 400 && resp.data[0] === 'User doesn\'t exist'){
						qualvideoForm.$invalid = true;
						$scope.errors.emailError = true;
					}else if(resp.status === 400 && resp.data[0] === 'Qual for user exists'){
						qualvideoForm.$invalid = true;
						$scope.errors.emailAlreadyExists = true;
					}else if(resp.status === 400 && resp.data[0] === 'Bad request'){
						qualvideoForm.$invalid = true;
						$scope.errors.badRequest = true;
					}else if(resp.status === 503){
						$scope.errors.unavailable = true;
					}else{
						$scope.errors.internal =  true;
					}
				}
			);
		}
	};

});