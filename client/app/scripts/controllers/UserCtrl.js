angular.module('FitBoard').controller('UserCtrl', function($scope) {
	'use strict';


//dropdown controller
	$scope.status = {
	isopen: false
	};

//User
	$scope.athlete = 
		{
					firstName: 'Michal',
					lastName: 'Dovrtel',
					email: 'm.dovrtel@gmail.com',
					phone: '+420 774 252 025',
					gym: 'Fit Monster',
					bDay: '06/06/1991',
					sex: 'male',
					category: 'elite',
					shirt: 'm',
					terms: 1,
					registred: 1,
					qualFee: 1,
					qualified: 0,
					startFee: 0,
					photo: 'img/man.png',
					score: 0,
					height: '175 cm',
					weight: '80 kg',
					yInC: '5y',
					cj: '90 kg',
					snatch: '75 kg',
					deadlift: '150 kg',
					frontSquat: '150 kg',
					backSquat: '160 kg',
					fran: '3:14',
					helen: '132',
					grace: '2:15',
					sprint: '1:30',
					row: '4:00',
					qual161: '',
					score161: ''

				};

//my profile
	$scope.editName = false;
  
	$scope.enableEditName = function() {
		$scope.editName = true;
		$scope.editableFirstName = $scope.athlete.firstName;
		$scope.editableLastName = $scope.athlete.lastName;
	};
	  
	$scope.disableEditName = function() {
		$scope.editName = false;
	};
	  
	$scope.saveName = function() {
		$scope.athlete.firstName = $scope.editableFirstName;
		$scope.athlete.lastName = $scope.editableLastName;
		$scope.disableEditName();
	};

});
