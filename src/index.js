import React from "react";
import ReactDOM from "react-dom";
import { PartoWithSelection } from "poui";
import TimeField from "react-simple-timefield";
import TimeInputElement from "./time_input";

document.addEventListener("DOMContentLoaded", function() {
  /*
  ReactDOM.render(<PartoWithSelection
      itemList={
        { "key": "a", "description": "Apple" },
        { "key": "p", "description": "Pear" },
        { "key": "b", "description": "Banana" }
      }
      parto={[]}
    />, document.getElementById("poui-root"));
  */
  const time_fields = document.querySelectorAll('[data-time-field]');
  const now = new Date();
  const initial = now.getHours() + ":" + now.getMinutes();
  time_fields.forEach((time_field) => {
    const field_name = time_field.getAttribute('data-time-field');
    const field_value = time_field.getAttribute('data-time-value') || initial;
    const input_element = <TimeInputElement
        value={field_value}
        name={field_name}
      />;
    ReactDOM.render(<TimeField
        value={field_value}
        name={field_name}
        onChange={function(){}}
        input={input_element}
      />, time_field);
    });
  },
  { "once": true }
);
