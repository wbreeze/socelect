"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = TimeInputElement;

var _react = _interopRequireDefault(require("react"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _extends() { _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; }; return _extends.apply(this, arguments); }

/*
 * This is essentially the input element that react-simple-timefield uses, only:
 * - the input element has tel type so that mobile keypads
 *   will come up with numbers, but the ':' is allowed in the value, and
 * - it eliminates the inline styling
*/
function TimeInputElement(props) {
  return _react.default.createElement("input", _extends({}, props, {
    type: "tel"
  }));
}