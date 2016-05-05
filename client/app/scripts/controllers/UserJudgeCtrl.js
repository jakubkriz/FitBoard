angular.module('FitBoard').controller('UserJudgeCtrl', function($scope, Api) {
	'use strict';

	$scope.nextToJudge = {};
	$scope.judged = null;

	$scope.reload = function(){
		$scope.err = '';
		Api.getQual('fitmonster2016', function(data){
			$scope.nextToJudge = {};
			$scope.qual = data.data;
			if ($scope.qual && typeof($scope.qual.usersReserved) !== 'undefined' && $scope.qual.usersReserved){
				$scope.nextToJudge = $scope.qual.usersReserved[0];
				if (typeof($scope.nextToJudge) !== 'undefined'){
					$scope.nextToJudge.pointsA_j = $scope.nextToJudge.pointsA;
					$scope.nextToJudge.pointsA_j_norep = 0;
					$scope.nextToJudge.pointsB_j = $scope.nextToJudge.pointsB;
				}
			}
			if($scope.qual && typeof($scope.qual.usersQual) !== 'undefined' && $scope.qual.usersQual){
				$scope.judged = $scope.qual.usersQual;
			}
		},function(err){
			$scope.err = err.data;
		});
	};

	// Set User
	Api.getParams( $scope, function(){
		$scope.reload();
	} );

	$scope.parseScore = function(){
		if ($scope.nextToJudge.pointsA_j && $scope.nextToJudge.pointsA_j.split(':').length === 2){ //score is time
			var sp = $scope.nextToJudge.pointsA_j.split(':');
			var sec = parseInt(sp[0]*60)+parseInt(sp[1]);
			if ($scope.nextToJudge.pointsA_j_norep){
				sec = sec + parseInt($scope.nextToJudge.pointsA_j_norep)*5;
			}
			$scope.nextToJudge.overallA = parseInt(sec/60).toString()+':'+parseInt(sec%60).toString();
		}else{
			if ($scope.nextToJudge.pointsA_j_norep && $scope.nextToJudge.pointsA_j){
				$scope.nextToJudge.overallA = parseInt($scope.nextToJudge.pointsA_j) - parseInt($scope.nextToJudge.pointsA_j_norep);
			}else{
				$scope.nextToJudge.overallA = parseInt($scope.nextToJudge.pointsA_j);
			}
		}
	};

	$scope.$watch('nextToJudge.pointsA_j', function(){
		$scope.parseScore();
	});
	$scope.$watch('nextToJudge.pointsA_j_norep', function(){
		$scope.parseScore();
	});

	$scope.reserve = function(login){
		Api.reserveQual('fitmonster2016', login, function(){
			$scope.nextToJudge.reserved = 1;
		},function(err){
			$scope.err = err.data;
		});
	};

	$scope.save = function(){
		var data = {};
		data.login = $scope.nextToJudge.login;
		data.pointsA_j = $scope.nextToJudge.pointsA_j;
		data.pointsA_j_norep = $scope.nextToJudge.pointsA_j_norep;
		data.pointsB_j = $scope.nextToJudge.pointsB_j;
		data.overallA = $scope.nextToJudge.overallA;
		Api.judgeQual('fitmonster2016', data, function(){
			$scope.reload();
		},function(err){
			$scope.err = err.data;
		});
	};

	$scope.cancelReserved = function(){
		$scope.err = '';
		Api.cancelQual('fitmonster2016', function(){
			$scope.nextToJudge.reserved = '';
			$scope.reload();
		},function(err){
			$scope.err = err.data;
		});
	};

});