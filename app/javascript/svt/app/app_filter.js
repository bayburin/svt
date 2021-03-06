import { app } from './app';

(function() {
  'use strict';

  app
  /**
   * Фильтр, выбирающий нужные значения property_list, взависимости от model_id и property_id.
   */
    .filter('inventPropList', function() {
      // Фильтровать по указанному model_id.
      return function(inputArray, model_id) {
        /**
         * Если model_id не задан, вернуть целиком массив
         * -1 - выберите ...
         * null или 0 - ввести ... вручную
         */
        if (!model_id || model_id == -1) { return inputArray; }

        let
          // Флаг, определяющий, были ли найдены совпадения в массиве model_property_lists. true - если были найдены.
          flag = false,
          result = [];

        // Проверяем каждое возможное значение свойства
        inputArray.forEach(function(list_value) {
          list_value.model_property_lists.forEach(function(model_value) {
            // Если model_id и property_id совпадает, значит фильтрация пройдена
            if (model_value.model_id == model_id && model_value.property_id == list_value.property_id) {
              result.push(list_value);
              flag = true;
            }
          });
        });

        // Если совпадений нет, вернуть целиком массив.
        if (!flag) { return inputArray; }

        return result;
      }
    })
    /**
     * Фильтр, определяющий, входит ли заданное значение search в inputArray.
     */
    .filter('contains', function() {
      // Поиск значения search в массиве inputArray.
      return function(inputArray, search) {
        return inputArray.indexOf(search) >= 0;
      }
    })
    /**
     * Возвращает фамилию и инициалы
     */
    .filter('fioInitials', function() {
      return function(fullName) {
        if (!fullName) { return ''; }

        let arr = fullName.split(' ');
        let point = '.';

        return `${arr.shift()} ${arr.map((el) => el[0].toUpperCase() + point).join(' ')}`;
      }
    })
    .filter('positiveVal', function() {
      return function(val) {
        return Math.abs(val);
      }
    });
})();
