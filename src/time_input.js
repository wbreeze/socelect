import React from "react";

/*
 * This is essentially the input element that react-simple-timefield uses, only:
 * - the input element has tel type so that mobile keypads
 *   will come up with numbers, but the ':' is allowed in the value, and
 * - it eliminates the inline styling
*/
export default function TimeInputElement(props) {
  const {value, name, ...rest_props} = props;
  return (
    <input
      {...rest_props}
      type="tel"
      name={name}
      value={value}
    />
  );
}
