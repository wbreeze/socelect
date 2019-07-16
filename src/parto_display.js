import React, { Component } from "react";
import ReactDOM from "react-dom";
import PropTypes from "prop-types";
import { Parto } from "poui";

function populatePartoDisplay() {
  const parto_divs = document.querySelectorAll('[data-parto-display]');
  parto_divs.forEach((parto_div) => {
    let field_list = parto_div.getAttribute('data-parto-items');
    if (typeof field_list === "string") {
      field_list = JSON.parse(field_list);
    }
    let field_value = parto_div.getAttribute('data-parto-display') || [];
    if (typeof field_value === "string") {
      field_value = JSON.parse(field_value);
    }
    ReactDOM.render(<Parto itemList={field_list} parto={field_value} />,
      parto_div);
  });
}

export default populatePartoDisplay;
