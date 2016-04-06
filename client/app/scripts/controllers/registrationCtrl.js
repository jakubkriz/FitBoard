/* global athleteForm*/

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

angular.module('FitBoard').controller('registrationCtrl', function($scope, $uibModal, Api) {
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
			firstName: '',
			lastName: '',
			email: '',
			phone: '',
			gym: '',
			bDay: '',
			sex: 'male',
			category: 'elite',
			shirt: 's',
			terms: false,
			registred: true,
			qualFee: false,
			qualified: false,
			startFee: false
		};
	};
	$scope.setDefault();

	$scope.dateOptions = {
		formatYear: 'yyyy',
		maxDate: new Date(2017, 1, 1),
//		minDate: new Date(),
		startingDay: 1
	};
	$scope.datePattern=/^[0-9]{2}.[0-9]{2}.[0-9]{4}$/i;

	$scope.altInputFormats = ['d!.M!.yyyy'];
	$scope.format = 'dd.MM.yyyy';

	// Submit registration
	$scope.submit = function() {
		if ($scope.athlete.terms === true) {
			var athl = clone($scope.athlete);
			if (athl.bDay){
				athl.bDay = athl.bDay.toLocaleDateString('en-GB');
			}else{
				athleteForm.bDay.$error.date = true;
				return '';
			}

			// Clean errors
			$scope.errors.emailError = false;
			$scope.errors.emailAlreadyExists = false;
			$scope.errors.badRequest = false;
			$scope.errors.unavailable = false;
			$scope.errors.internal =  false;

			Api.register(
				athl,
				function(resp){ // OK
					if (resp){

						// Show modal page
						$uibModal.open({
							animation: true,
							templateUrl: 'views/utilities/regComplete.html',
							controller: 'ModalInstanceCtrl',
							size: 'm',
							backdrop: 'static',
							keyboard: false
						});
//						$scope.setDefault();
					}
				},
				function(resp){ //ERROR

					if (resp.status === 400 && resp.data[0] === 'Bad email'){
						athleteForm.$invalid = true;
						$scope.errors.emailError = true;
					}else if(resp.status === 400 && resp.data[0] === 'User exists'){
						athleteForm.$invalid = true;
						$scope.errors.emailAlreadyExists = true;
					}else if(resp.status === 400 && resp.data[0] === 'Bad request'){
						athleteForm.$invalid = true;
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
