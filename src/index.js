import React from "react";
import ReactDOM from "react-dom";
import { PartoWithSelection } from "poui";
document.addEventListener("DOMContentLoaded", function() {
  ReactDOM.render(<PartoWithSelection
      itemList={
        { "key": "a", "description": "Apple" },
        { "key": "p", "description": "Pear" },
        { "key": "b", "description": "Banana" }
      }
      parto={[]}
    />, document.getElementById("root"));
  },
  { "once": true }
);
