var user = angular.module('FitBoard');

user.controller('registrationCtrl', function($scope, $uibModal) {
	'use strict';


  $scope.status = 400;
  // if ($api.getHttpStatus() == 400) {}
  if ($scope.status === 400) {
	$scope.emailErrors = {
	  emailAlreadyExists: true
	};
  }
  // if ($api.getHttpStatus() == 500) {}
 $scope.serverErrors = {
	internal: false, //500
	unavailable: true //503
  };

  // datepicker
  $scope.dateOptions = {
		formatYear: 'yyyy',
		maxDate: new Date(),
		startingDay: 1
	};

	$scope.open1 = function() {
		$scope.popup1.opened = true;
	};

	$scope.popup1 = {
		opened: false
	};

	$scope.format = 'dd.MM.yyyy';
	$scope.altInputFormats = ['M!/d!/yyyy'];

	$scope.clear = function() {
		$scope.dt = null;
	};

	// toggle buttons
	$scope.scaleMale	 = false;
	$scope.scaleFemale = true;
	$scope.eliteCat 	 = true;
	$scope.mastersCat  = false;
	$scope.openCat 		 = false;
	$scope.sShirt = true;
	$scope.mShirt = false;
	$scope.lShirt = false;
	$scope.xlShirt = false;

	
	
	//modal
	$scope.animationsEnabled = true;

  	$scope.modal = function () {
  		if ($scope.athlete.terms === true) {

		$uibModal.open({
			  animation: $scope.animationsEnabled,
			  templateUrl: 'views/utilities/regComplete.html',
			  controller: 'ModalInstanceCtrl',
			  size: 'm',
			  backdrop: 'static',
			  keyboard: false
			});
		} else {
			$uibModal.close();
		}
	};

	$scope.list = [];
	// data
	$scope.submit = function() {
		if ($scope.athlete) {

			//reset button
			$scope.scaleMale = false;
			$scope.scaleFemale = true;
			$scope.eliteCat = true;
			$scope.mastersCat = false;
			$scope.openCat = false;
			$scope.sShirt = true;
			$scope.mShirt = false;
			$scope.lShirt = false;
			$scope.xlShirt = false;
        	
        	//push to list
        	$scope.list.push(this.athlete);
				$scope.athlete = {

				firstName: '',
				lastName: '',
				email: '',
				phone: '',
				gym: '',
				bDay: '',
				sex: 'default',
				category: 'elite',
				shirt: 's',
				terms: false,
				registred: true,
				qualFee: false,
				qualified: false,
				startFee: false

		};
	}};

});
