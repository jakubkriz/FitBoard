angular.module('myApp')
	.controller('LeaderBoardCtrl', ['$scope',function($scope) {
	'use strict';

	$scope.sortType     = 'score'; // set the default sort type
	$scope.sortReverse  = true;  // set the default sort order
	$scope.searchName   = '';

	// Colapse support
	$scope.isCollapsed = true;
	$scope.oneAtATime = true;
	$scope.isOpen=false;
	
	$scope.athletes = [
			{
				name: 'Athlete Name',
				sex: 'men',
				category: 'elite',
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
				sex: 'men',
				category: 'elite',
				gym: 'independent2',
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
				name: 'Frantisek Heriban',
				gym: 'The gym',
				score: 66,

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,

			},
			{
				name: 'Frantisek Heriban',
				gym: 'The gym',
				score: 66,

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,

			}
		];
	

	}]);