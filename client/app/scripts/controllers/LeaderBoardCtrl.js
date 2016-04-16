angular.module('FitBoard').controller('LeaderBoardCtrl', function($scope) {
	'use strict';

	$scope.sortType     = 'score'; // set the defaulr sort type
	$scope.sortReverse  = true;  // set the defaulr sort order
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
				name: 'Athlete Name',
				sex: 'male',
				category: 'elite',
				photo: '',
				gym: 'independent',
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
				row: '4:00'
			},
			{
				name: 'Michal Dovrtel',
				sex: 'male',
				category: 'elite',
				gym: 'independent2',
				photo: 'img/profile.jpg',
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
				row: '4:00'
			},
			{
				name: 'Aneta Velika',
				sex: 'female',
				photo: '',
				category: 'elite',
				gym: 'independent',
				score: 32
			},
			{
				name: 'Aneta Mala',
				sex: 'female',
				photo: '',
				category: 'elite',
				gym: 'independent',
				score: 30
			},
			{
				name: 'Aneta Druha',
				sex: 'female',
				photo: '',
				category: 'elite',
				score: 28,
				gym: 'independent'
			},
			{
				sex: 'male',
				name: 'Frantisek Heriban',
				gym: 'The gym',
				photo: '',
				category: 'open',
				score: 66
			},
			{
				sex: 'male',
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'open',
				photo: '',
				score: 125

			},
			{
				sex: 'male',
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'open',
				photo: '',
				score: 82

			},
			{
				sex: 'male',
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'masters',
				photo: '',
				score: 125

			},
			{
				sex: 'male',
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'masters',
				photo: '',
				score: 80

			},
			{
				sex: 'male',
				name: 'Frantisek Heriban',
				gym: 'The gym',
				category: 'masters',
				photo: '',
				score: 66

			},
			{
				sex: 'male',
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'masters',
				photo: '',
				score: 125

			},
			{
				sex: 'male',
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'masters',
				photo: '',
				score: 80

			}
		];
});
