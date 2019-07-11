import React from "react";
import ReactDOM from "react-dom";
import { Poui } from "poui";
import TimeField from "react-simple-timefield";
import TimeInputElement from "./time_input";

document.addEventListener("DOMContentLoaded", function() {
  const poui_fields = document.querySelectorAll('[poui-component]');
  poui_fields.forEach((poui_field) => {
    ReactDOM.render(<Poui
        itemList={[
          { "key": "a", "description": "Apple" },
          { "key": "p", "description": "Pear" },
          { "key": "b", "description": "Banana" }
        ]}
        parto={[]}
      />, poui-field);
  });
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
