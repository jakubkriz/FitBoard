angular.module('FitBoard').controller('AdminCtrl', function($scope) {
	'use strict';

  $scope.gridOptions = {};
  $scope.gridOptions.data = $scope.athletes;
  $scope.gridOptions.enableColumnResizing = true;
  $scope.gridOptions.enableFiltering = true;
  $scope.gridOptions.enableGridMenu = true;
  // $scope.gridOptions.showGridFooter = true;
  // $scope.gridOptions.showColumnFooter = true;
  // $scope.gridOptions.fastWatch = true;

  // $scope.gridOptions.rowIdentity = function(row) {
  //   return row.id;
  // };
  // $scope.gridOptions.getRowIdentity = function(row) {
  //   return row.id;
  // };

  $scope.deleteRow = function(row) {
    var index = $scope.gridOptions.data.indexOf(row.entity);
    $scope.gridOptions.data.splice(index, 1);
  };

  $scope.gridOptions.columnDefs = [
		{ 	name:'full name',
			field: 'name',
			enableCellEdit:false
		},
		{ 	name:'email',
			field: 'email',
			enableCellEdit:false
		},
		{ 	name:'birthday',
			enableCellEdit:true,
			enableFiltering:false,
			type: 'date',
			field: 'birthday'
		},
		{ 	name:'telephone',
			enableCellEdit:false,
			enableFiltering:false
		},
		{ 	name:'sex',
			field: 'sex',
			enableCellEdit:false
		},
		{ 	name:'category',
			field: 'category',
			enableCellEdit:false
		},
		{ 	name:'t-shirt',
			field: 'tShirt',
			enableCellEdit: true,
			enableFiltering:false
		},
		{ 	name:'payment',
			type:'boolean',
			cellTemplate: '<input type="checkbox" value="paid">'
		},
		{ 	name:'qualified',
			type:'boolean',
			cellTemplate: '<input type="checkbox" value="paid">'
		},
		{ 	name:'position',
			type:'number',
			enableFiltering:false
		},
		{ 	name: 'edit',
 				enableCellEdit: false,
				cellTemplate: '<button class="btn primary" ng-click="grid.appScope.deleteRow(row)">Delete</button>'

		}
  ];

  // $scope.callsPending = 0;

  // var i = 0;
  // $scope.refreshData = function(){
  //   $scope.myData = [];

  //   var start = new Date();
  //   var sec = $interval(function () {
  //     $scope.callsPending++;

  //     $http.get('/data/500_complex.json')
  //       .success(function(data) {
  //         $scope.callsPending--;

  //         data.forEach(function(row){
  //           row.id = i;
  //           i++;
  //           row.registered = new Date(row.registered)
  //           $scope.myData.push(row);
  //         });
  //       })
  //       .error(function() {
  //         $scope.callsPending--
  //       });
  //   }, 200, 10);


  //   var timeout = $timeout(function() {
  //      $interval.cancel(sec);
  //      $scope.left = '';
  //   }, 2000);

  //   $scope.$on('$destroy', function(){
  //     $timeout.cancel(timeout);
  //     $interval.cancel(sec);
  //   });

  // };

////////////////////////// Athletes  ////////////////////////////////////

	$scope.athletes = [
			{
				name: 'Athlete Name',
				email: 'athl@gmail.com',
				telephone: '773773773',
				sex: 'default',
				category: 'elite',
				tShirt: 'M',
				gym: 'independent',
				age: 23,
				mailSend: 1,
				birthday: '12.12.1990'

			},
			{
				name: 'Michal Dovrtel',
				sex: 'default',
				category: 'elite',
				telephone: '7737737732',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
			},
			{
				name: 'Aneta Velika',
				sex: 'female',
				email: 'athl@gmail.com',
				category: 'elite',
				telephone: '773773773',
				tShirt: 'S',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				name: 'Aneta Mala',
				sex: 'female',
				email: 'athl@gmail.com',
				category: 'elite',
				telephone: '773773773',
				tShirt: 'S',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				name: 'Aneta Druha',
				sex: 'female',
			email: 'athl@gmail.com',
				category: 'elite',
				tShirt: 'S',
				telephone: '773773773',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
			},
			{
				sex: 'default',
				name: 'Frantisek Heriban',
				telephone: '773773773',
				email: 'athl@gmail.com',
				category: 'open',
				tShirt: 'S',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
			},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
			telephone: '773773773',
				category: 'open',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				sex: 'default',
				name: 'Adam Ohral',
				telephone: '773773773',
				category: 'open',
				email: 'athl@gmail.com',
				tShirt: 'XXXL',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				sex: 'default',
				name: 'Adam Ohral',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'XS',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				sex: 'default',
				name: 'Frantisek Heriban',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'S',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		},
			{
				sex: 'default',
				name: 'Adam Ohral',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23,
				birthday: '12.12.1990'
		  }
		];
});
