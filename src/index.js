import React from "react";
import ReactDOM from "react-dom";
import TimeField from "react-simple-timefield";
import TimeInputElement from "./time_input";
import PouiInput from "./poui_input";

function populatePoui() {
  const poui_fields = document.querySelectorAll('[data-poui-field]');
  poui_fields.forEach((poui_field) => {
    const field_id = poui_field.getAttribute('data-poui-field');
    let field_list = poui_field.getAttribute('data-poui-items');
    let field_value = poui_field.getAttribute('data-poui-parto') || [];
    if (typeof field_list === "string") {
      field_list = JSON.parse(field_list);
    }
    if (typeof field_value === "string") {
      field_value = JSON.parse(field_value);
    }
    ReactDOM.render(<PouiInput
        itemList={field_list}
        parto={field_value}
        inputName={field_id}
      />, poui_field);
  });
}

document.addEventListener("DOMContentLoaded", function() {
  populatePoui();
  const time_fields = document.querySelectorAll('[data-time-field]');
  const now = new Date();
  const initial = now.getHours() + ":" + now.getMinutes();
  time_fields.forEach((time_field) => {
    const field_id = time_field.getAttribute('data-time-field');
    const field_name = time_field.getAttribute('data-time-name');
    const field_value = time_field.getAttribute('data-time-value') || initial;
    ReactDOM.render(<TimeField
        id={field_id}
        name={field_name}
        value={field_value}
        onChange={function(){}}
        input={<TimeInputElement />}
      />, time_field);
    });
  },
  { "once": true }
);
