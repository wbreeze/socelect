import React from "react";
import ReactDOM from "react-dom";
import { PartoWithSelection } from "poui";
import TimeField from "react-simple-timefield";
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
  const now = new Date();
  const initial = now.getHours() + ":" + now.getMinutes();
  ReactDOM.render(<TimeField
      value={initial}
      onChange={(time) => {console.log("Selected time " + time);}}
    />, document.getElementById("time-entry"));
  },
  { "once": true }
);
