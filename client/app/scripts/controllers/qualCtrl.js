angular.module('FitBoard').controller('qualCtrl', function($scope, $uibModal, Api) {
	'use strict';

	$uibModal.open({
			animation: true,
			templateUrl: 'views/utilities/videoSubmitted.html',
			controller: 'ModalInstanceCtrl',
			size: 'm',
			backdrop: 'static',
			keyboard: false
	});
});