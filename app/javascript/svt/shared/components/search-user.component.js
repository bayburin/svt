import { app } from '../../app/app';

app
  .component('searchUser', {
    // templateUrl: require('./search-user.component.html'),
    template: `
    <div class="input-group multiline-select">
      <ui-select ng-model="su.selectedUser" theme="bootstrap">
        <ui-select-match placeholder="ФИО или таб. №">
          {{$select.selected.fio}}
        </ui-select-match>
        <ui-select-choices refresh="su.searchUsers($select.search)" refresh-delay="300" repeat="user in su.users | filter: $select.search">
          <div ng-bind-html="user.fio + ' (отд. ' + user.dept + ')' | highlight: $select.search"></div>
        </ui-select-choices>
      </ui-select>
      <span class="input-group-btn">
        <button type="button" class="btn-default" ng-click="su.clearUser()" uib-tooltip="Очистить" tooltip-append-to-body="true" ng-disabled="!su.selectedUser">
          <i class="fa fa-times"></i>
        </button>
      </span>
    </div>
    `,
    controller: 'SearchUserController',
    controllerAs: 'su',
    bindings: {
      selectedUser: '='
    }
  });
