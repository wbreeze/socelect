import React, { Component } from "react";
import ReactDOM from "react-dom";
import PropTypes from "prop-types";
import { PartialOrder, PartoWithSelection } from "poui";

const PouiInput = withInput(PartoWithSelection);

function withInput(Wrapped) {
  class WithInput extends Component {
    static propTypes = {
      parto: PropTypes.array.isRequired,
      itemList: PropTypes.array.isRequired,
      inputName: PropTypes.string.isRequired,
      inputClass: PropTypes.string
    }

    state = {
      ordering: this.props.parto
    }

    constructor(props) {
      super(props);
      this.updateOrdering = this.updateOrdering.bind(this);
    }

    updateOrdering(updatedOrdering) {
      this.setState({ ordering: updatedOrdering });
    }

    render() {
      const { inputClass, inputName, ...rest } = this.props;
      const props = { ...rest, updateOrdering: this.updateOrdering };
      const inputValue = JSON.stringify(this.state.ordering);
      return(
        <div className='poui-input'>
          <input type="hidden" name={inputName}
            className={inputClass || 'poui-input'}
            value={inputValue} />
          <Wrapped {...props} />
        </div>
      );
    }
  }

  function getDisplayName(WrappedComponent) {
    return WrappedComponent.displayName || WrappedCompenent.name || 'PouiInput';
  }

  WithInput.displayName = `WithInput(${getDisplayName(Wrapped)})`;
  return WithInput;
}

export default PouiInput;
