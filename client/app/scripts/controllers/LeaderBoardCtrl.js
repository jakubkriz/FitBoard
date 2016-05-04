angular.module('FitBoard').controller('LeaderBoardCtrl', function($scope) {
	'use strict';

	$scope.sortType     = 'placeA'; // set the defaulr sort type
	$scope.sortReverse  = false;  // set the defaulr sort order
	$scope.searchName   = '';

	// Colapse support
	$scope.isCollapsed = true;

	// Initialization
	$scope.category 	 = 'elite';
	$scope.sex				 = 'male';
	// $scope.scaleMale	 = false;
	// $scope.scaleFemale = true;
	// $scope.eliteCat 	 = true;
	// $scope.mastersCat  = false;
	// $scope.openCat 		 = false;

	$scope.$watch('sex', function() {
		if ($scope.sex === 'male') {
			$scope.sexHeaderHtml = 'MEN';
		} else {
			$scope.sexHeaderHtml = 'WOMEN';
		}
	}, 'true');


	$scope.rowClass = function(item, index, qf){
         if(index === 0){
             return 'mainRowFirst';
         }
        else if ($scope.athletes.qualified === 0){
        	return 'mainRowDNQ';
        } else {
        	return 'mainRow';
        }

    };

// division toggle
 // $(document).ready(function () {
	// $( '#elite' ).click(function() {
	// 	$( '#toggle_slider' ).animate({ 'left': '0px' }, 400 );
	// });

	// $( '#masters' ).click(function() {
	// 	$( '#toggle_slider' ).animate({ 'left': '120px' }, 400 );
	// });

	// $( '#open' ).click(function(){
	// 	$( '#toggle_slider' ).animate({ 'left': '240px' }, 400 );
	// });
 // });



//sex toggle
	// $scope.sex = function(id) {
	// 	if (id === 'male') {
	// 		$('#male').animate({'width':'40px', 'height':'40px'},500);
	// 		return '<h1>MENS</h1>';
	// 	} else if (id === 'female') {
	// 		$('#female').animate({'width':'40px', 'height':'40px'},500);
	// 		return '<h1>WOMENS</h1>';
	// 	}
	// };


////////////////////////// Athletes  ////////////////////////////////////

	$scope.athletes = [
			{
				firstName: 'Athlete',
				lastName: 'Name 1',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '06:50',
				pointsB: '100',
				pointsO: 3,
				placeA: 1,
				placeB: 1,
				placeOV: 1,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 2',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '07:00',
				pointsB: '90',
				pointsO: 4,
				placeA: 2,
				placeB: 2,
				placeOV: 2,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 3',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '90',
				pointsB: '80',
				pointsO: 6,
				placeA: 3,
				placeB: 3,
				placeOV: 3,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 4',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '80',
				pointsB: '70',
				pointsO: 8,
				placeA: 4,
				placeB: 4,
				placeOV: 4,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 5',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '70',
				pointsB: '60',
				pointsO: 10,
				placeA: 5,
				placeB: 5,
				placeOV: 5,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 6',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '60',
				pointsB: '50',
				pointsO: 12,
				placeA: 6,
				placeB: 6,
				placeOV: 6,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 7',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '50',
				pointsB: '40',
				pointsO: 14,
				placeA: 7,
				placeB: 7,
				placeOV: 7,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 8',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '40',
				pointsB: '30',
				pointsO: 16,
				placeA: 8,
				placeB: 8,
				placeOV: 8,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 9',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '30',
				pointsB: '20',
				pointsO: 18,
				placeA: 9,
				placeB: 9,
				placeOV: 9,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 10',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '20',
				pointsB: '10',
				pointsO: 20,
				placeA: 10,
				placeB: 10,
				placeOV: 10,
				qualified: 1
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 11',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: '10',
				pointsB: '0',
				pointsO: 22,
				placeA: 11,
				placeB: 11,
				placeOV: 11,
				qualified: 0
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 12',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: 0,
				pointsB: 0,
				pointsO: 0,
				placeA: 12,
				placeB: 12,
				placeOV: 12,
				qualified: 0
			},
			{
				firstName: 'Athlete',
				lastName: 'Name 13',
				sex: 'male',
				gym: 'independent',
				category: 'elite',
				photo: '',
				pointsA: 0,
				pointsB: 0,
				pointsO: 0,
				placeA: 13,
				placeB: 13,
				placeOV: 13,
				qualified: 0
			},
		];
});
