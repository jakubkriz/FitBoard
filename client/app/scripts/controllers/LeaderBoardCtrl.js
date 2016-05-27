angular.module('FitBoard').controller('LeaderBoardCtrl', function($scope, Api) {
	'use strict';

	$scope.wod     	 = 'qualOV';
	// $scope.place   	 = 'placeOV'; 	// set the default sort type
	$scope.placeText1 = 'OVERALL';
	$scope.placeText2 = 'Overall';
	$scope.placeText3 = 'Overall';
	$scope.placeText4 = 'Overall';
	$scope.placeText5 = 'OVERALL';

	$scope.searchName   = '';


	// Colapse support
	$scope.isCollapsed = true;

	// Initialization
	$scope.category 	 = 'elite';
	$scope.sex		     = 'male';

	$scope.$watch('sex', function() {
		if ($scope.sex === 'male') {
			$scope.sexHeaderHtml = 'MEN';
		} else {
			$scope.sexHeaderHtml = 'WOMEN';
		}
	}, 'true');

	$scope.wodSwitch = function(wod) {
		//$scope.placeText, $scope.place, $scope.wod
		$scope.wod = wod;
		// Qualification
		if($scope.wod === 'qualA') {
			$scope.place = 'placeA';
			$scope.placeText1 = 'WOD A';
		} else if($scope.wod === 'qualB') {
			$scope.place = 'placeB';
			$scope.placeText1 = 'WOD B';
		} else if($scope.wod === 'qualOV') {
			$scope.place = 'placeOV';
			$scope.placeText1 = 'OVERALL';
		}
		// WODs
		else if($scope.wod === 'wod1') {
			$scope.place = 'score_wod1';
			$scope.placeText2 = 'WOD 1';
		} else if($scope.wod === 'wod2') {
			$scope.place2 = 'score_wod2';
			$scope.placeText2 = 'WOD 2';
		} else if($scope.wod === 'wod3') {
			$scope.place = 'score_wod3';
			$scope.placeText2 = 'WOD 3';
		} else if($scope.wod === 'wod4') {
			$scope.place = 'score_wod4';
			$scope.placeText3 = 'WOD 4';
		} else if($scope.wod === 'wod5') {
			$scope.place = 'score_wod5';
			$scope.placeText4 = 'WOD 5';
		} else if($scope.wod === 'wod6') {
			$scope.place = 'score_wod6';
			$scope.placeText5 = 'WOD 6';
		} else if($scope.wod === 'OV_1') {
			$scope.place = 'placeOV_1';
			$scope.placeText2 = 'Overall';
		} else if($scope.wod === 'OV_2') {
			$scope.place = 'placeOV_2';
			$scope.placeText3 = 'Overall';
		} else if($scope.wod === 'OV_3') {
			$scope.place = 'placeOV_3';
			$scope.placeText4 = 'Overall';
		} else if($scope.wod === 'OV_4') {
			$scope.place = 'placeOV_4';
			$scope.placeText5 = 'OVERALL';
		}
	};

	//to change the colors appropriately, the main dropdown button changes WODs as well
	$scope.changeWodbyText = function(text, wodType) {
		if(text === 'WOD A') {
			$scope.wodSwitch('qualA');
		} else if(text === 'WOD B') {
			$scope.wodSwitch('qualB');
		} else if(text === 'WOD 1') {
			$scope.wodSwitch('wod1');
		} else if(text === 'WOD 2') {
			$scope.wodSwitch('wod2');
		} else if(text === 'WOD 3') {
			$scope.wodSwitch('wod3');
		} else if(text === 'WOD 4') {
			$scope.wodSwitch('wod4');
		} else if(text === 'WOD 5') {
			$scope.wodSwitch('wod5');
		} else if(text === 'WOD 6') {
			$scope.wodSwitch('wod6');
		}
		// OVERALL and Overall
		// else if(text.toLowerCase().indexOf('overall') > -1) {
		else {
			if (wodType.toLowerCase().indexOf('qual') > -1) {
				$scope.wodSwitch('qualOV');
			} else if (wodType.toLowerCase().indexOf('cut1') > -1) {
				$scope.wodSwitch('OV_1');
			} else if (wodType.toLowerCase().indexOf('cut2') > -1) {
				$scope.wodSwitch('OV_2');
			} else if (wodType.toLowerCase().indexOf('cut3') > -1) {
				$scope.wodSwitch('OV_3');
			} else if (wodType.toLowerCase().indexOf('finals') > -1) {
				$scope.wodSwitch('OV_4');
			}
		}
	};
	// rowClass
	$scope.rowClass = function(athlete){
		var place = $scope.getPlace(athlete);
		if(place === 1){
			return 'mainRowFirst';
		 } else if(($scope.wod.substring(0,4) === 'qual' && athlete.qualified === 0)
		 				//CUT1 OPEN MEN
		 				|| ($scope.category === 'open' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod1' || $scope.wod === 'wod2' || $scope.wod === 'wod3' || $scope.wod === 'OV_1') && place > 56)
		 				//CUT1 OPEN WOMEN
		 				|| ($scope.category === 'open' && $scope.sex === 'female'
		 						&& ($scope.wod === 'wod1' || $scope.wod === 'wod2' || $scope.wod === 'wod3' || $scope.wod === 'OV_1') && place > 42)
		 				//CUT1 MASTERS MEN
		 				|| ($scope.category === 'masters' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod1' || $scope.wod === 'wod2' || $scope.wod === 'wod3' || $scope.wod === 'OV_1') && place > 14)
		 				//CUT1 ELITE MEN
		 				|| ($scope.category === 'elite' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod1' || $scope.wod === 'wod2' || $scope.wod === 'wod3' || $scope.wod === 'OV_1') && place > 42)
		 				//CUT2 OPEN MEN
		 				|| ($scope.category === 'open' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod4' || $scope.wod === 'OV_2') && place > 28)
		 				//CUT2 OPEN WOMEN
		 				|| ($scope.category === 'open' && $scope.sex === 'female'
		 						&& ($scope.wod === 'wod4' || $scope.wod === 'OV_2') && place > 28)
		 				//CUT2 MASTERS MEN
		 				|| ($scope.category === 'masters' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod4' || $scope.wod === 'OV_2') && place > 14)
		 				//CUT2 ELITE MEN
		 				|| ($scope.category === 'elite' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod4' || $scope.wod === 'OV_2') && place > 24)
		 				//CUT3 OPEN MEN
		 				|| ($scope.category === 'open' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod5' || $scope.wod === 'OV_3') && place > 10)
		 				//CUT3 OPEN WOMEN
		 				|| ($scope.category === 'open' && $scope.sex === 'female'
		 						&& ($scope.wod === 'wod5' || $scope.wod === 'OV_3') && place > 10)
		 				//CUT3 MASTERS MEN
		 				|| ($scope.category === 'masters' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod5' || $scope.wod === 'OV_3') && place > 10)
		 				//CUT3 ELITE MEN
		 				|| ($scope.category === 'elite' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod5' || $scope.wod === 'OV_3') && place > 10)
		 				//CUT3 ELITE WOMEN
		 				|| ($scope.category === 'elite' && $scope.sex === 'female'
		 						&& ($scope.wod === 'wod5' || $scope.wod === 'OV_3') && place > 10)
		 				//FINALS OPEN MEN
		 				|| ($scope.category === 'open' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod6' || $scope.wod === 'OV_4') && place > 10)
		 				//FINALS OPEN WOMEN
		 				|| ($scope.category === 'open' && $scope.sex === 'female'
		 						&& ($scope.wod === 'wod6' || $scope.wod === 'OV_4') && place > 10)
		 				//FINALS MASTERS MEN
		 				|| ($scope.category === 'masters' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod6' || $scope.wod === 'OV_4') && place > 10)
		 				//FINALS ELITE MEN
		 				|| ($scope.category === 'elite' && $scope.sex === 'male'
		 						&& ($scope.wod === 'wod6' || $scope.wod === 'OV_4') && place > 10)
		 				//FINALS ELITE WOMEN
		 				|| ($scope.category === 'elite' && $scope.sex === 'female'
		 						&& ($scope.wod === 'wod6' || $scope.wod === 'OV_4') && place > 10)
		 				 )	{
			return 'mainRowDNQ';
		} else {
			return 'mainRow';
		}
	};

	$scope.getPlace = function(athlete) {
		// Qualification
		if($scope.wod === 'qualA') {
			return athlete.placeA;
		} else if($scope.wod === 'qualB') {
			return athlete.placeB;
		} else if($scope.wod === 'qualOV') {
			return athlete.placeOV;
		}
		// WODs
		else if($scope.wod === 'wod1') {
			return athlete.score_wod1;
		} else if($scope.wod === 'wod2') {
			return athlete.score_wod2;
		} else if($scope.wod === 'wod3') {
			return athlete.score_wod3;
		} else if($scope.wod === 'wod4') {
			return athlete.score_wod4;
		} else if($scope.wod === 'wod5') {
			return athlete.score_wod5;
		} else if($scope.wod === 'wod6') {
			return athlete.score_wod6;
		} else if($scope.wod === 'OV_1') {
			return athlete.placeOV_1;
		} else if($scope.wod === 'OV_2') {
			return athlete.placeOV_2;
		} else if($scope.wod === 'OV_3') {
			return athlete.placeOV_3;
		} else if($scope.wod === 'OV_4') {
			return athlete.placeOV_4;
		}
 	};

	$scope.getPoints = function(athlete) {
		// Qualification
		if($scope.wod === 'qualA') {
			return athlete.pointsA;
		} else if($scope.wod === 'qualB') {
			return athlete.pointsB;
		} else if($scope.wod === 'qualOV') {
			return athlete.pointsO;
		}
		// WODs
		else if($scope.wod === 'wod1') {
			return athlete.points_wod1_j;
		} else if($scope.wod === 'wod2') {
			return athlete.points_wod2_j;
		} else if($scope.wod === 'wod3') {
			return athlete.points_wod3_j;
		} else if($scope.wod === 'wod4') {
			return athlete.points_wod4_j;
		} else if($scope.wod === 'wod5') {
			return athlete.points_wod5_j;
		} else if($scope.wod === 'wod6') {
			return athlete.points_wod6_j;
		} else if($scope.wod === 'OV_1') {
			return athlete.scoreOV_1;
		} else if($scope.wod === 'OV_2') {
			return athlete.scoreOV_2;
		} else if($scope.wod === 'OV_3') {
			return athlete.scoreOV_3;
		} else if($scope.wod === 'OV_4') {
			return athlete.scoreOV_4;
		}
 	};

 //Search by firstName and lastName at the same time
 $scope.searchName = function(item) {
 		// to search by full name as well as only by first name or last name
 		var name = item.firstName.toLowerCase() + ' ' + item.lastName.toLowerCase();
    if (!$scope.query ||
    	(item.firstName.toLowerCase().indexOf($scope.query.toLowerCase()) > -1) ||
    	(item.lastName.toLowerCase().indexOf($scope.query.toLowerCase()) > -1) ||
    	(name.indexOf($scope.query.toLowerCase()) > -1)) {
        return true;
    }
    return false;
 };

////////////////////////// Athletes  ////////////////////////////////////

	$scope.athletes = [];

	$scope.$watch('wod', function() {
		if($scope.wod.substring(0,4) === 'qual') {
			Api.getLbQual('fitmonster2016',
				function(data){
					$scope.athletes = data.data.lb;
				},
				function(resp){ //ERROR
					if(resp.status === 503){
						$scope.errors.unavailable = true;
					}else{
						$scope.errors.internal =  true;
					}
				}
			);
		} else {
			Api.getLbWod('fitmonster2016',
				function(data){
					$scope.athletes = data.data.users;
				},
				function(resp){ //ERROR
					if(resp.status === 503){
						$scope.errors.unavailable = true;
					}else{
						$scope.errors.internal =  true;
					}
				}
			);
		}
	}, 'true');


  // {
	// 	firstName: 'Athlete',
	// 	lastName: 'Name 13',
	// 	sex: 'male',
	// 	gym: 'independent',
	// 	category: 'elite',
	// 	photo: '',
	// 	pointsA: 0,
	// 	pointsB: 0,
	// 	pointsO: 0,
	// 	placeA: 13,
	// 	placeB: 13,
	// 	placeOV: 13,
	// 	qualified: 0
	// }
});
