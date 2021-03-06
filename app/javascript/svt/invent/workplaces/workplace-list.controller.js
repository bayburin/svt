import { app } from '../../app/app';

(function() {
  'use strict';

  app.controller('WorkplaceListCtrl', WorkplaceListCtrl);

  WorkplaceListCtrl.$inject = ['$scope', 'Workplaces', 'ActionCableChannel', 'TablePaginator', 'Server', 'Config', 'Flash', 'Error'];

  /**
   * Управление общей таблицей рабочих мест.
   */
  function WorkplaceListCtrl($scope, Workplaces, ActionCableChannel, TablePaginator, Server, Config, Flash, Error) {
    this.Workplaces = Workplaces;
    this.ActionCableChannel = ActionCableChannel;
    this.Server = Server;
    this.Config = Config;
    this.Flash = Flash;
    this.Error = Error;
    this.pagination = TablePaginator.config();

    this._loadWorkplaces(true);
    this._initActionCable();

    $scope.$on('WorkplaceTableCtrl::reloadWorkplacesList', () => this.reloadWorkplaces());
  }

  /**
   * Загрузить данные о РМ.
   *
   * @param init
   */
  WorkplaceListCtrl.prototype._loadWorkplaces = function(init) {
    this.Workplaces.loadListWorkplaces(init).then(
      () => this.workplaces = this.Workplaces.workplaces
    );
  };

  /**
   * Инициировать подключение к каналу WorkplacesListChannel.
   */
  WorkplaceListCtrl.prototype._initActionCable = function() {
    let consumer = new this.ActionCableChannel('Invent::WorkplacesListChannel');

    consumer.subscribe(() => this._loadWorkplaces());
  };

  /**
   * Загрузить список РМ.
   */
  WorkplaceListCtrl.prototype.reloadWorkplaces = function() {
    this._loadWorkplaces();
  };

  /**
   * Удалить РМ.
   *
   * @param id
   */
  WorkplaceListCtrl.prototype.destroyWp = function(id) {
    let confirm_str = `Вы действительно хотите удалить рабочее место "${id}"?`;

    if (!confirm(confirm_str)) { return false; }

    this.Server.Invent.Workplace.delete(
      { workplace_id: id },
      (response) => this.Flash.notice(response.full_message),
      (response, status) => this.Error.response(response, status)
    );
  };
})();
