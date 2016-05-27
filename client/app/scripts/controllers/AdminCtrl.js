angular.module('FitBoard').controller('AdminCtrl', function($scope, uiGridConstants, Api) {
	'use strict';

  // Initialization
  $scope.wod      = 'wod1'; //wod1, wod2, wod3, OV_1, wod4, OV_2 ....
  
  $scope.columns = [
    {
      name: 'Place wod1',
      field: 'score_wod1',
      enableFiltering: false,
    },
    {
      name:'Start number',
      field: 'startN',
      enableFiltering: true,
      headerCellClass: $scope.highlightFilteredHeader,
      filter: {
        condition: function(searchTerm, cellValue) {
          var pattern = new RegExp("^"+searchTerm+"$","i");
          return cellValue.match(pattern);
        }
      }
    },
    {
      name:'First name',
      field: 'firstName',
      enableFiltering: true,
      headerCellClass: $scope.highlightFilteredHeader
    },
    {
      name:'Last name',
      field: 'lastName',
      enableFiltering: true,
      headerCellClass: $scope.highlightFilteredHeader
    },
    {
      name:'Category',
      field: 'category',
      headerCellClass: $scope.highlightFilteredHeader,
      filter: {
        type: uiGridConstants.filter.SELECT,
        selectOptions: [ { value: 'elite', label: 'elite' }, { value: 'masters', label: 'masters' }, { value: 'open', label: 'open'} ]
      },
    },
    {
      name:'Sex',
      field: 'sex',
      headerCellClass: $scope.highlightFilteredHeader,
      filter: {
        type: uiGridConstants.filter.SELECT,
        selectOptions: [ { value: 'male', label: 'male' }, { value: 'female', label: 'female' } ],
        condition: function(searchTerm, cellValue) {
          var pattern = new RegExp("^"+searchTerm,"i");
          return cellValue.match(pattern);
        }
      },
    },
    {
      name:'Score wod1',
      field: 'points_wod1_j',
      enableFiltering: false
    },
    {
      name:'Judge wod1',
      type: 'number',
      field: 'judgeN_wod1',
      enableFiltering: false
    },
    {
      name:'Modified',
      field: 'modified',
      enableFiltering: false,
      sort: {
          direction: uiGridConstants.DESC,
          priority: 10
        }
    },
  ];

  $scope.gridOptions = {
    enableColumnResizing: true,
    enableFiltering: true,
    enableGridMenu: true,
    rowHeight: 38,
    columnDefs: $scope.columns
  };

  $scope.gridOptions.onRegisterApi = function(gridApi) {
    $scope.gridApi = gridApi;
  };

  $scope.gridOptions.importerDataAddCallback = function(grid, newObjects) {
      $scope.data = $scope.data.concat(newObjects);
  };

  $scope.querysn = function(){
    $scope.gridApi.grid.columns[1].filters[0].term = $scope.query;
  };

  $scope.refresh = function() {
    $scope.gridApi.core.clearAllFilters();
  };

  $scope.highlightFilteredHeader = function( row, rowRenderIndex, col, colRenderIndex ) {
    if( col.filters[0].term ){
      return 'header-filtered';
    } else {
      return '';
    }
  };

  $scope.$watch('gridApi.grid.columns[1].filters[0].term', function(newValue, oldValue) {
     $scope.counter = $scope.counter + 1;
  });

  $scope.putshow = 1;
  $scope.wodSwitch = function(newValue) {
      if (newValue.match(/OV_/)){
        $scope.points = 'score'+newValue;
        $scope.place = 'place'+newValue;
        $scope.putshow = 0;
      }else{
        $scope.points = 'points_'+newValue+'_j';
        $scope.place = 'score_'+newValue;
        $scope.putshow = 1;
        $scope.judge = 'judgeN_'+newValue;
      }

      $scope.columns[0] = {
        name: 'Place '+newValue,
        field: $scope.place,
        enableFiltering: false,
      };

      $scope.columns[6] = {
        name: 'Score '+newValue,
        field: $scope.points,
        enableFiltering: false,
      };

      $scope.columns[7] = {
        name: 'Judge '+newValue,
        type: 'number',
        field: $scope.judge,
        enableFiltering: false,
      };

      $scope.wod = newValue;
  };
 
 ////////////////////////// Athletes  ////////////////////////////////////
  $scope.athletes = [];
  $scope.reload = function(){
    Api.getAdmin('fitmonster2016', 
      function(data){
        $scope.athletes = data.data.users;
        $scope.gridOptions.data = $scope.athletes;
      },
      function(resp){ //ERROR
        if(resp.status === 503){
          $scope.errors.unavailable = true;
        }else{
          $scope.errors.internal =  true;
        }
      }
    );
  };

  $scope.cleanErrors = function(){
    // Clean errors
    $scope.errors = {};
    $scope.errors.notExistsUser = false;
    $scope.errors.notExists = false;
    $scope.errors.cantChangeLogin = false;
    $scope.errors.badRequest = false;
    $scope.errors.unavailable = false;
    $scope.errors.internal =  false;
    $scope.errors.notExistsJudge = false;
    $scope.errors.notExistsScore = false;
  };

  $scope.cleanErrors();
  $scope.reload();

  function getAthlete(item) {
      return item.startN === $scope.query;
  }
  $scope.submit = function() {
    $scope.cleanErrors();
    if ($scope.query && !$scope.wod.match(/OV_/)) {
        if (!$scope.judgeN){
          $scope.errors.notExistsJudge = true;
          return;
        }
        if (!$scope.scoreWod){
          $scope.errors.notExistsScore = true;
          return;
        }

        var val = $scope.athletes.find(getAthlete);
        if (!val){
          $scope.errors.notExists = true;
          return;
        }
        var athl = {};
        athl['judgeN_'+$scope.wod] = $scope.judgeN;
        athl.login = val.login;
        athl['points_'+$scope.wod+'_j'] = $scope.scoreWod;

       Api.saveScore('fitmonster2016', val.login,
         athl,
        function(resp){ // OK
          if (resp){
            $scope.reload();
            $scope.judgeN = null;
            $scope.scoreWod = null;
            $scope.query = null;
            $scope.querysn();
          }
        },
        function(resp){ //ERROR

          if (resp.status === 400 && resp.data[0] === 'User doesn\'t exist'){
            $scope.errors.notExistsUser = true;
          }else if(resp.status === 400 && resp.data[0] === 'StartN doesn\'t exist'){
            $scope.errors.notExists = true;
          }else if (resp.status === 400 && resp.data[0] === 'Login can\'t be changed. Drop and create new start.'){
            $scope.errors.cantChangeLogin = true;
          }else if(resp.status === 400 && resp.data[0] === 'Bad request'){
            $scope.errors.badRequest = true;
          }else if(resp.status === 503){
            $scope.errors.unavailable = true;
          }else{
            $scope.errors.internal =  true;
          }
        }
      );
    }else{
      $scope.errors.notExists = true;
    }
  };

});