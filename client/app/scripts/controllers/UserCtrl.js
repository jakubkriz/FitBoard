angular.module('FitBoard').controller('UserCtrl', function($scope) {
	'use strict';


//dropdown controller
	$scope.status = {
	isopen: false
	};

//User
	$scope.athlete = 
		{
					name: 'Michal Dovrtěl',
					sex: 'default',
					category: 'elite',
					gym: 'independent2',
					photo: 'img/man.png',
					score: 125,
					age: '24',
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

});
