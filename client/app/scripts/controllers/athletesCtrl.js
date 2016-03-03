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
				age: "24",
				height: "175 cm",
				weight: "80 kg",
				yInC: "5y",
				cj: "90 kg",
				snatch: "75 kg",
				deadlift: "150 kg",
				frontSquat: "150 kg",
				backSquat: "160 kg",
				fran: "3:14",
				helen: "132",
				grace: "2:15",
				sprint: "1:30",
				row: "4:00"

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