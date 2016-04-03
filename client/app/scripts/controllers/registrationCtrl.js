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
	$scope.datePattern=/^[0-9]{2}.[0-9]{2}.[0-9]{4}$/i

	$scope.altInputFormats = ['d!.M!.yyyy'];
	$scope.format = 'dd.MM.yyyy';

	// Submit registration
	$scope.submit = function() {
		if ($scope.athlete.terms === true) {

			var bDay = $scope.athlete.bDay;
			if ($scope.athlete.bDay){
				$scope.athlete.bDay = bDay.toLocaleDateString('en-GB');
			}else{
				athleteForm.bDay.$error.date = true;
				return '';
			}

			Api.register(
				$scope.athlete,
				function(resp){ // OK
					if (resp){
						// Clean errors
						$scope.errors.emailAlreadyExists = false; //400
						$scope.errors.internal = false; //500
						$scope.errors.unavailable = false; //503

						// Show modal page
						$uibModal.open({
							animation: true,
							templateUrl: 'views/utilities/regComplete.html',
							controller: 'ModalInstanceCtrl',
							size: 'm',
							backdrop: 'static',
							keyboard: false
						});
						$scope.setDefault();
					}
				},
				function(resp){ //ERROR
					$scope.athlete.bDay = bDay;
					if (resp.status === 400 && resp.statusText === 'Bad email'){
						$scope.errors.emailError = true;
					}else if(resp.status === 400 && resp.statusText === 'User exists'){
						$scope.errors.emailAlreadyExists = true;
					}else if(resp.status === 400 && resp.statusText === 'Bad request'){
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
