import { app } from '../../app/app';
import { FormValidationController } from '../../shared/functions/form-validation';

(function () {
  'use strict';

  app.controller('ExecOrderController', ExecOrderController);

  ExecOrderController.$inject = ['$uibModal', '$uibModalInstance', 'WarehouseOrder', 'Flash', 'Error', 'Server'];

  function ExecOrderController($uibModal, $uibModalInstance, WarehouseOrder, Flash, Error, Server) {
    this.setFormName('order');

    this.$uibModal = $uibModal;
    this.$uibModalInstance = $uibModalInstance;
    this.Order = WarehouseOrder;
    this.Flash = Flash;
    this.Error = Error;
    this.Server = Server;

    this.order = this.Order.order;
    this.Order.prepareToExec();
    this.checkSelected();
  }

  // Унаследовать методы класса FormValidationController
  ExecOrderController.prototype = Object.create(FormValidationController.prototype);
  ExecOrderController.prototype.constructor = ExecOrderController;

  /**
   * Исполнить приходный ордер.
   */
  ExecOrderController.prototype._executeIn = function() {
    let sendData = this.Order.getObjectToSend();

    if (!confirm('Вы действительно хотите исполнить выбранные позиции? Удалить исполненные позиции или отменить их исполнение невозможно')) {
      return false;
    }

    this.Server.Warehouse.Order.executeIn(
      { id: this.order.id },
      { order: sendData },
      (response) => {
        this.Flash.notice(response.full_message);
        this.$uibModalInstance.close();
      },
      (response, status) => {
        this.Error.response(response, status);
        this.errorResponse(response);
      }
    )
  };

  /**
   * Исполнить расходный ордер.
   */
  ExecOrderController.prototype._executeOut = function() {
    this.Order.prepareToDeliver()
      .then(
        (response) => {
          this.clearErrors();
          let modalInstance = this.$uibModal.open({
            templateUrl: 'deliveryOfItems.slim',
            controller: 'DeliveryItemsCtrl',
            controllerAs: 'delivery',
            size: 'lg',
            backdrop: 'static'
          });

          modalInstance.result.then(() => this.cancel());
        },
        (response) => this.errorResponse(response)
      );
  };

  /**
   * Исполнить ордер на списание.
   */
  ExecOrderController.prototype._executeWriteOff = function() {
    let sendData = this.Order.getObjectToSend();

    if (!confirm('Вы действительно хотите списать выбранные позиции? Удалить исполненные позиции или отменить их исполнение невозможно')) {
      return false;
    }

    this.Server.Warehouse.Order.executeWriteOff(
      { id: this.order.id },
      { order: sendData },
      (response) => {
        this.Flash.notice(response.full_message);
        this.$uibModalInstance.close();
      },
      (response, status) => this.Error.response(response, status)
    )
  };

  /**
   * Поставить/убрать все позиции на исполнение.
   */
  ExecOrderController.prototype.toggleAll = function() {
    let status = this.isAllOpSelected ? 'done' : 'processing';
    this.order.operations_attributes.forEach((op) => op.status = status);
  };

  // /**
  //  * Обновить данные ордера.
  //  */
  // ExecOrderController.prototype.reloadOrder = function() {
  //   this.Order.reloadOrder();
  //   this.Order.prepareToExec();
  // };

  /**
   * Проверка, исполнена ли операция.
   */
  ExecOrderController.prototype.isOperationDone = function(op) {
    return op.status == 'done' && op.date;
  };

  /**
   * Установить/снять флаг, показывающий, выбраны ли все пункты.
   */
  ExecOrderController.prototype.checkSelected = function() {
    this.isAllOpSelected = this.order.operations_attributes.every((op) => op.status == 'done');
  };

  /**
   * Утвердить/отклонить ордер.
   */
  ExecOrderController.prototype.confirmOrder = function() {
    this.Server.Warehouse.Order.confirm(
      { id: this.order.id },
      {},
      (response) => {
        this.Flash.notice(response.full_message);
        this.$uibModalInstance.close();
      },
      (response, status) => {
        this.Error.response(response, status);
        this.errorResponse(response);
      }
    );
  };

  /**
   * Исполнить выбранные поля ордера.
   */
  ExecOrderController.prototype.ok = function() {
    if (this.order.operation == 'in') {
      this._executeIn();
    } else if (this.order.operation == 'out') {
      this._executeOut();
    } else if (this.order.operation == 'write_off') {
      this._executeWriteOff();
    }
  };

  /**
   * Распечатать ордер.
   */
  ExecOrderController.prototype.printOrder = function() {
    let sendData = this.Order.getObjectToSend();

    window.open('/warehouse/orders/' + this.order.id + '/print?order=' + JSON.stringify(sendData), '_blank');
  };

  /**
   * Закрыть модальное окно.
   */
  ExecOrderController.prototype.cancel = function() {
    this.$uibModalInstance.dismiss();
  };
})();
