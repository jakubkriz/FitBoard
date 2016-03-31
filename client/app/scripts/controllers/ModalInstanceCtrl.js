angular.module('FitBoard').controller('ModalInstanceCtrl', function ($scope, $uibModalInstance) {
	'use strict';

  $scope.ok = function () {
    $uibModalInstance.close('ok');
  };
});