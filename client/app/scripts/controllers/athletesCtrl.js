app.controller('athletesCtrl', ['$scope',function($scope) {
	$scope.sortType     = 'place'; // set the default sort type
 	$scope.sortReverse  = false;  // set the default sort order
  	$scope.searchName   = '';

			$scope.athletes = [
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,
				place: 1,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,
				place: 2,

			},
			{
				name: 'Frantisek Heriban',
				gym: 'The gym',
				score: 66,
				place: 3,

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,
				place: 4,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,
				place: 5,

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,
				place: 6,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,
				place: 7,

			},
			{
				name: 'Frantisek Heriban',
				gym: 'The gym',
				score: 66,
				place: 8,

			},
			{
				name: 'Michal Dovrtel',
				gym: 'inependent',
				score: 125,
				place: 9,

			},
			{
				name: 'Adam Ohral',
				gym: 'Fit Monster Team',
				score: 80,
				place: 10,

			}];
	}]);