angular.module('myApp')
	.controller('LeaderBoardCtrl', ['$scope',function($scope) {
	'use strict';

	$scope.athletes = [
			{
				name: 'Athlete Name',
				sex: 'men',
				category: 'elite',
				photo: 'img/man.png',
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
				photo: 'img/woman.png',
				category: 'elite',
				gym: 'independent',
				score: 32
			},
			{
				name: 'Aneta Mala',
				sex: 'female',
				photo: 'img/woman.png',
				category: 'elite',
				gym: 'independent',
				score: 30
			},
			{
				name: 'Aneta Druha',
				sex: 'female',
				photo: 'img/woman.png',
				category: 'elite',
				score: 28,
				gym: 'independent'
			},
			{
				name: 'Frantisek Heriban',
				gym: 'The gym',
				photo: 'img/man.png',
				category: 'open',
				score: 66
			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'open',
				photo: 'img/man.png',
				score: 125

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'open',
				photo: 'img/man.png',
				score: 82

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'masters',
				photo: 'img/man.png',
				score: 125

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'masters',
				photo: 'img/man.png',
				score: 80

			},
			{
				name: 'Frantisek Heriban',
				gym: 'The gym',
				category: 'masters',
				photo: 'img/man.png',
				score: 66

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'masters',
				photo: 'img/man.png',
				score: 125

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'masters',
				photo: 'img/man.png',
				score: 80

			}
		];

	$scope.sortType     = 'score'; // set the default sort type
	$scope.sortReverse  = true;  // set the default sort order
	$scope.searchName   = '';

	// Colapse support
	$scope.isCollapsed = true;
	$scope.oneAtATime = true;
	$scope.isOpen=false;

	$scope.selectedCategory = '';
	$scope.filteredAthletes = $scope.athletes;


// $(document).ready(function () {
// 	$( '#elite' ).click(function() {
// 		$( '#toggle_slider' ).animate({ 'left': '0px' }, 400 );
// $scope.showCategory = 'elite';
// 	});

// 	$( '#masters' ).click(function() {
// 		$( '#toggle_slider' ).animate({ 'left': '120px' }, 400 );
// $scope.showCategory = 'masters';
// 	});

// 	$( '#open' ).click(function(){
// 		$( '#toggle_slider' ).animate({ 'left': '240px' }, 400 );
// $scope.showCategory = 'open';
// 	});
// });


// $scope.categoryClickHandler = function(cat) {
//   $scope.selectedCategory = cat;

// 	$scope.filteredAthletes = $scope.athletes.filter(function(ath) {
// 		if ($scope.selectedCategory === '') {
// 			return true;
// 		} else {
// 			return ath.category === $scope.selectedCategory;
// 		}
// 	});
// };



// sex button
$('#men').click(function() {
	$(this).animate ({width: '40px', height: '40px'}, 500);
	$('#sex').html('<h1><MENS</h1>');
	});

$('#women').click(function() {
	$(this).animate ({width: '40px', height: '40px'}, 500);
	$('#sex').html('<h1><WOMENS</h1>');
	});

}]);
