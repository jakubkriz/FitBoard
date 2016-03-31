var user = angular.module('FitBoard');

user.controller('registrationCtrl', function($scope) {
	'use strict';

	$scope.clear = function() {
	    $scope.dt = null;
	};


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

	$scope.scaleMale	 = false;
	$scope.scaleFemale = true;
	$scope.eliteCat 	 = true;
	$scope.mastersCat  = false;
	$scope.openCat 		 = false;


	$scope.athlete = {

		firstName: '',
		lastName: '',
		email: '',
		phone: '',
		gym: '',
		bDay: '',
		sex: 'default',
		category: 'elite',
		shirt: 's'

	};

});
