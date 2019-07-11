"use strict";

var _react = _interopRequireDefault(require("react"));

var _reactDom = _interopRequireDefault(require("react-dom"));

var _poui = require("poui");

var _reactSimpleTimefield = _interopRequireDefault(require("react-simple-timefield"));

var _time_input = _interopRequireDefault(require("./time_input"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

document.addEventListener("DOMContentLoaded", function () {
  _reactDom.default.render(_react.default.createElement(_poui.Poui, {
    itemList: [{
      "key": "a",
      "description": "Apple"
    }, {
      "key": "p",
      "description": "Pear"
    }, {
      "key": "b",
      "description": "Banana"
    }],
    parto: []
  }), document.getElementById("poui-component"));

  var time_fields = document.querySelectorAll('[data-time-field]');
  var now = new Date();
  var initial = now.getHours() + ":" + now.getMinutes();
  time_fields.forEach(function (time_field) {
    var field_id = time_field.getAttribute('data-time-field');
    var field_name = time_field.getAttribute('data-time-name');
    var field_value = time_field.getAttribute('data-time-value') || initial;

    _reactDom.default.render(_react.default.createElement(_reactSimpleTimefield.default, {
      id: field_id,
      name: field_name,
      value: field_value,
      onChange: function onChange() {},
      input: _react.default.createElement(_time_input.default, null)
    }), time_field);
  });
}, {
  "once": true
});