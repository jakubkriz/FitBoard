angular.module('FitBoard').controller('UserCtrl', function($scope) {
	'use strict';


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

//User
	$scope.athlete = 
		{
					firstName: 'Michal',
					lastName: 'Dovrtel',
					email: 'm.dovrtel@gmail.com',
					phone: '+420 774 252 025',
					gym: 'Fit Monster',
					bDay: '06/06/1991',
					password: 'michal',
					sex: 'female',
					category: 'elite',
					shirt: 'm',
					terms: 1,
					registred: 1,
					qualFee: 1,
					qualified: 0,
					startFee: 0,
					photo: '',
					score: 0,
					height: 175,
					weight: 80,
					yInC: 5,
					cj: 90,
					snatch: 75,
					deadlift: 150,
					frontSquat: 150,
					backSquat: 160,
					fran: '3:14',
					helen: '132',
					grace: '2:15',
					sprint: '1:30',
					row: '4:00',
					qual161: '',
					score161: ''

				};


// Judge
	
	$scope.nextTo = true;


//my profile

// 	$scope.saveBasic = function() {
//     // $scope.athlete already updated!
//     	return $http.post('/saveBasic', $scope.athlete).error(function(err) {
//       		if(err.field && err.msg) {
//         	// err like {field: "name", msg: "Server-side error for this username!"} 
//         		$scope.editableForm.$setError(err.field, err.msg);
//       		} else { 
//         	// unknown error
//         		$scope.editableForm.$setError('name', 'Unknown error!');
//       		}
//     	});
//   	};

//   	$scope.savePass = function() {
//     // $scope.athlete already updated!
//     	return $http.post('/savePass', $scope.athlete).error(function(err) {
//       		if(err.field && err.msg) {
//         	// err like {field: "name", msg: "Server-side error for this username!"} 
//         		$scope.editableForm.$setError(err.field, err.msg);
//       		} else { 
//         	// unknown error
//         		$scope.editableForm.$setError('name', 'Unknown error!');
//       		}
//     	});
//   	};

//   	// ---------------- mock $http requests --------------------
// angular.module('FitBoard').run(function($httpBackend) {
    
//   $httpBackend.whenPOST(/\/saveUser/).respond(function(method, url, data) {
//     data = angular.fromJson(data);
//     if(data.name === 'error') {
//       return [500, {field: 'name', msg: 'Server-side error for this username!'}]; 
//     } else {
//       return [200, {status: 'ok'}]; 
//     }
//   });

// 	});
});