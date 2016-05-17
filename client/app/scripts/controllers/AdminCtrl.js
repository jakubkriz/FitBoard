angular.module('FitBoard').controller('AdminCtrl', function($scope) {
	'use strict';

  // Initialization
  $scope.category    = 'elite';
  $scope.sex         = 'male';
  $scope.place       = 'placeA';
  $scope.score       = 'pointsA';

  $scope.gridOptions = {};
  // $scope.gridOptions.data = $scope.athletes;
  $scope.gridOptions.data = [];
  $scope.gridOptions.enableColumnResizing = true;
  $scope.gridOptions.enableFiltering = false;
  $scope.gridOptions.enableCellEdit = false;
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

  $scope.search = function(item) {
    if (item.startNo === parseInt($scope.query)) {
        return true;
    }
    return false;
  };

  $scope.addData = function(athlete) {
    $scope.gridOptions.data.push({
                'place': athlete.placeA,
                'startNo': athlete.startNo,
                'name': athlete.firstName,
                'category': athlete.category,
                'sex': athlete.sex,
                'score': athlete.pointsA,
                'Judge number': 10
              });
  };

  $scope.editRow = function(row) {
    var index = $scope.gridOptions.data.indexOf(row.entity);
    // $scope.gridOptions.data.splice(index, 1); //DELETE

  };

  //TODO: budu potrebovat editableCellTemplate -> cell template to be used when editing this column.
  // http://ui-grid.info/docs/#/api/ui.grid.rowEdit.service:uiGridRowEditService
  // http://ui-grid.info/docs/#/api/ui.grid.edit.directive:uiGridCell
  $scope.editButtonHtml = '<div class="ui-grid-cell-contents">' +
                          '<button class="blue-button glyphicon glyphicon-pencil" ng-click="grid.appScope.editRow(row)">' +
                          ' Edit' +
                          '</button>' +
                          '</div>';



  $scope.gridOptions.columnDefs = [
		{
      name: 'Place',
      // field: $scope.place
      field: 'place'
    },
    {
      name:'Start number',
      field: 'startNo',
      enableFiltering: true
    },
    {
      name:'Full name',
      field: 'name',
      enableFiltering: true
		},
    {
      name:'Category',
      field: 'category'
    },
		{
      name:'Sex',
			field: 'sex'
		},
		{
      name:'Score',
      // field: $scope.score
      field: 'score'
		},
		{
      name:'Judge number',
      type: 'number',
      enableFiltering: true
		},
		{ 	name: 'Action',
				cellTemplate: $scope.editButtonHtml
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
        firstName: 'Pepa',
        lastName: 'Veliky 1',
        sex: 'male',
        gym: 'independent',
        category: 'elite',
        startNo: 1,
        pointsA: '06:50',
        pointsB: '100',
        pointsO: 3,
        placeA: 4,
        placeB: 1,
        placeOV: 2,
        qualified: 1
      },
      {
        firstName: 'Adam',
        lastName: 'Zeleny 2',
        sex: 'male',
        gym: 'independent',
        category: 'elite',
        startNo: 2,
        pointsA: '07:00',
        pointsB: '90',
        pointsO: 4,
        placeA: 1,
        placeB: 2,
        placeOV: 1,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 3',
        sex: 'male',
        gym: 'independent',
        category: 'elite',
        startNo: 3,
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
        startNo: 12,
        pointsA: '80',
        pointsB: '70',
        pointsO: 8,
        placeA: 2,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
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
        startNo: 12,
        pointsA: 0,
        pointsB: 0,
        pointsO: 0,
        placeA: 13,
        placeB: 13,
        placeOV: 13,
        qualified: 0
      },
//// WOMEN
{
        firstName: 'Athlete',
        lastName: 'Name 1',
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
        pointsA: '06:50',
        pointsB: '100',
        pointsO: 3,
        placeA: 4,
        placeB: 1,
        placeOV: 2,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 2',
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
        pointsA: '07:00',
        pointsB: '90',
        pointsO: 4,
        placeA: 1,
        placeB: 2,
        placeOV: 1,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 3',
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
        pointsA: '80',
        pointsB: '70',
        pointsO: 8,
        placeA: 2,
        placeB: 4,
        placeOV: 4,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 5',
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'elite',
        startNo: 12,
        pointsA: 0,
        pointsB: 0,
        pointsO: 0,
        placeA: 13,
        placeB: 13,
        placeOV: 13,
        qualified: 0
      },
//// OPEN
{
        firstName: 'Athlete',
        lastName: 'Name 1',
        sex: 'male',
        gym: 'independent',
        category: 'open',
        startNo: 12,
        pointsA: '06:50',
        pointsB: '100',
        pointsO: 3,
        placeA: 4,
        placeB: 1,
        placeOV: 2,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 2',
        sex: 'male',
        gym: 'independent',
        category: 'open',
        startNo: 12,
        pointsA: '07:00',
        pointsB: '90',
        pointsO: 4,
        placeA: 1,
        placeB: 2,
        placeOV: 1,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 3',
        sex: 'male',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
        pointsA: '80',
        pointsB: '70',
        pointsO: 8,
        placeA: 2,
        placeB: 4,
        placeOV: 4,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 5',
        sex: 'male',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
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
        category: 'open',
        startNo: 12,
        pointsA: 0,
        pointsB: 0,
        pointsO: 0,
        placeA: 13,
        placeB: 13,
        placeOV: 13,
        qualified: 0
      },
/// OPEN WOMEN
{
        firstName: 'Athlete',
        lastName: 'Name 1',
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
        pointsA: '06:50',
        pointsB: '100',
        pointsO: 3,
        placeA: 4,
        placeB: 1,
        placeOV: 2,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 2',
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
        pointsA: '07:00',
        pointsB: '90',
        pointsO: 4,
        placeA: 1,
        placeB: 2,
        placeOV: 1,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 3',
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
        pointsA: '80',
        pointsB: '70',
        pointsO: 8,
        placeA: 2,
        placeB: 4,
        placeOV: 4,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 5',
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'open',
        startNo: 12,
        pointsA: 0,
        pointsB: 0,
        pointsO: 0,
        placeA: 13,
        placeB: 13,
        placeOV: 13,
        qualified: 0
      },
// MASTERS
{
        firstName: 'Athlete',
        lastName: 'Name 1',
        sex: 'male',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
        pointsA: '06:50',
        pointsB: '100',
        pointsO: 3,
        placeA: 4,
        placeB: 1,
        placeOV: 2,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 2',
        sex: 'male',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
        pointsA: '07:00',
        pointsB: '90',
        pointsO: 4,
        placeA: 1,
        placeB: 2,
        placeOV: 1,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 3',
        sex: 'male',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
        pointsA: '80',
        pointsB: '70',
        pointsO: 8,
        placeA: 2,
        placeB: 4,
        placeOV: 4,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 5',
        sex: 'male',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
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
        category: 'masters',
        startNo: 12,
        pointsA: 0,
        pointsB: 0,
        pointsO: 0,
        placeA: 13,
        placeB: 13,
        placeOV: 13,
        qualified: 0
      },
// MASTERS WOMEN
{
        firstName: 'Athlete',
        lastName: 'Name 1',
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
        pointsA: '06:50',
        pointsB: '100',
        pointsO: 3,
        placeA: 4,
        placeB: 1,
        placeOV: 2,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 2',
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
        pointsA: '07:00',
        pointsB: '90',
        pointsO: 4,
        placeA: 1,
        placeB: 2,
        placeOV: 1,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 3',
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
        pointsA: '80',
        pointsB: '70',
        pointsO: 8,
        placeA: 2,
        placeB: 4,
        placeOV: 4,
        qualified: 1
      },
      {
        firstName: 'Athlete',
        lastName: 'Name 5',
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
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
        sex: 'female',
        gym: 'independent',
        category: 'masters',
        startNo: 12,
        pointsA: 0,
        pointsB: 0,
        pointsO: 0,
        placeA: 13,
        placeB: 13,
        placeOV: 13,
        qualified: 0
      }
    ];
});
