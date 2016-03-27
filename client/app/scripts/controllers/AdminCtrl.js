var admin = angular.module('FitBoard');

admin.controller('AdminCtrl', function($scope) {
	'use strict';

////////////////////////// Athletes  ////////////////////////////////////

	$scope.athletes = [
			{
				name: 'Athlete Name',
				sex: 'default',
				category: 'elite',
				photo: 'img/man.png',
				gym: 'independent',
				score: 125
			},
			{
				name: 'Michal Dovrtel',
				sex: 'default',
				category: 'elite',
				gym: 'independent2',
				photo: 'img/profile.jpg',
				score: 125
	
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
				sex: 'default',
				name: 'Frantisek Heriban',
				gym: 'The gym',
				photo: 'img/man.png',
				category: 'open',
				score: 66
			},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'open',
				photo: 'img/man.png',
				score: 125

			},
			{
				sex: 'default',
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'open',
				photo: 'img/man.png',
				score: 82

			},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'masters',
				photo: 'img/man.png',
				score: 125

			},
			{
				sex: 'default',
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'masters',
				photo: 'img/man.png',
				score: 80

			},
			{
				sex: 'default',
				name: 'Frantisek Heriban',
				gym: 'The gym',
				category: 'masters',
				photo: 'img/man.png',
				score: 66

			},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				gym: 'inependent',
				category: 'masters',
				photo: 'img/man.png',
				score: 125

			},
			{
				sex: 'default',
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				category: 'masters',
				photo: 'img/man.png',
				score: 80

			}
		];
});
