var admin = angular.module('FitBoard');

// admin.controller('AdminCtrl', function($scope, $http, $timeout, $interval, uiGridConstants, uiGridGroupingConstants) {
admin.controller('AdminCtrl', function($scope) {
	'use strict';


  $scope.gridOptions = {};
  // $scope.gridOptions.data = 'myData';
  $scope.gridOptions.data = 'athletes';
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

  $scope.gridOptions.columnDefs = [
  	{ name:'full name', field: 'name', enableCellEdit:false},
	  { name:'email', field: 'email', enableCellEdit:false},
	  { name:'telephone', enableCellEdit:false, enableFiltering:false },
	  { name:'sex', field: 'sex', enableCellEdit:false},
	  { name:'category', field: 'category', enableCellEdit:false},
	  { name:'t-shirt', field: 'tShirt', enableCellEdit: true, enableFiltering:false },
	  { name:'payment', type:'boolean'},
	  { name:'qualified', type:'boolean'},
	  { name:'position', enableFiltering:false},
///////////////////////////////////////////////////////////
    // { name:'id', width:50 },
    // { name:'name', width:100 },
    // { name:'age', width:100, enableCellEdit: true, aggregationType:uiGridConstants.aggregationTypes.avg, treeAggregationType: uiGridGroupingConstants.aggregation.AVG },
    // { name:'address.street', width:150, enableCellEdit: true },
    // { name:'address.city', width:150, enableCellEdit: true },
    // { name:'address.state', width:50, enableCellEdit: true },
    // { name:'address.zip', width:50, enableCellEdit: true },
    // { name:'company', width:100, enableCellEdit: true },
    // { name:'email', width:100, enableCellEdit: true },
    // { name:'phone', width:200, enableCellEdit: true },
    // { name:'about', width:300, enableCellEdit: true },
    // { name:'friends[0].name', displayName:'1st friend', width:150, enableCellEdit: true },
    // { name:'friends[1].name', displayName:'2nd friend', width:150, enableCellEdit: true },
    // { name:'friends[2].name', displayName:'3rd friend', width:150, enableCellEdit: true },
// !!!// { name:'agetemplate',field:'age', width:150, cellTemplate: '<div class="ui-grid-cell-contents"><span>Age 2:{{COL_FIELD}}</span></div>' },
    // { name:'Is Active',field:'isActive', width:150, type:'boolean' },
    // { name:'Join Date',field:'registered', cellFilter:'date', width:150, type:'date', enableFiltering:false },
    // { name:'Month Joined',field:'registered', cellFilter: 'date:"MMMM"', filterCellFiltered:true, sortCellFiltered:true, width:150, type:'date' }
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

// var columns = [
	// { name: 'full name' },
	// { name: 'email' },
	// { name: 'telephone' },
 //  { name: 'sex' }
 //  { name: 'category' }
 //  { name: 't-shirt' }
// 	  { name:'full name', field: 'name', enableCellEdit:false},
// 	  { name:'email', field: 'email', enableCellEdit:false},
// 	  { name:'telephone', field: 'telephone', enableCellEdit:false},
// 	  { name:'sex', field: 'sex', enableCellEdit:false},
// 	  { name:'category', field: 'category', enableCellEdit:false},
// 	  { name:'t-shirt', field: 'tShirt'},
// ];

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
				age: 23
			},
			{
				name: 'Michal Dovrtel',
				sex: 'default',
				category: 'elite',
				telephone: '7737737732',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23
			},
			{
				name: 'Aneta Velika',
				sex: 'female',
				email: 'athl@gmail.com',
				category: 'elite',
				telephone: '773773773',
				tShirt: 'S',
				gym: 'independent',
				age: 23
	   	},
			{
				name: 'Aneta Mala',
				sex: 'female',
				email: 'athl@gmail.com',
				category: 'elite',
				telephone: '773773773',
				tShirt: 'S',
				gym: 'independent',
				age: 23
   		},
			{
				name: 'Aneta Druha',
				sex: 'female',
	  		email: 'athl@gmail.com',
				category: 'elite',
				tShirt: 'S',
				telephone: '773773773',
				gym: 'independent',
				age: 23
			},
			{
				sex: 'default',
				name: 'Frantisek Heriban',
				telephone: '773773773',
				email: 'athl@gmail.com',
				category: 'open',
				tShirt: 'S',
				gym: 'independent',
				age: 23
			},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
	  		telephone: '773773773',
				category: 'open',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23
   		},
			{
				sex: 'default',
				name: 'Adam Ohral',
				telephone: '773773773',
				category: 'open',
				email: 'athl@gmail.com',
				tShirt: 'XXXL',
				gym: 'independent',
				age: 23
  		},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23
  		},
			{
				sex: 'default',
				name: 'Adam Ohral',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'XS',
				gym: 'independent',
				age: 23
  		},
			{
				sex: 'default',
				name: 'Frantisek Heriban',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'S',
				gym: 'independent',
				age: 23
  		},
			{
				sex: 'default',
				name: 'Michal Dovrtel',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23
  		},
			{
				sex: 'default',
				name: 'Adam Ohral',
				telephone: '773773773',
				category: 'masters',
				email: 'athl@gmail.com',
				tShirt: 'M',
				gym: 'independent',
				age: 23
		  }
		];
});
