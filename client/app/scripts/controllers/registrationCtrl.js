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

	$scope.dateOpened = false;
	$scope.format = 'dd.MM.yyyy';
	$scope.altInputFormats = ['M!/d!/yyyy'];

	// Submit registration
	$scope.submit = function() {
		if ($scope.athlete.terms === true) {
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
					if (resp.status === 400){
						$scope.errors.emailAlreadyExists = true; //400
					}else if(resp.status === 503){
						$scope.errors.unavailable = true; //503
					}else{
						$scope.errors.internal =  true; //500
					}
				}
			);
		}
	};

});
