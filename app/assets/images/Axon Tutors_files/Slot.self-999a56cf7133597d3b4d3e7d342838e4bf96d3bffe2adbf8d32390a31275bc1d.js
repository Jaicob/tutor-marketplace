var Slot = React.createClass({
  displayName: "Slot",

  getInitialState: function () {
    return {
      active: this.props.selected
    };
  },
  handleClick: function () {
    this.setState({
      active: !this.state.active
    });
    this.props.handleSlotClick(this.props.slot, this.state.active);
  },
  generateStyle: function () {
    if (this.state.active) {
      return "active";
    } else {
      return "neutral";
    }
  },
  render: function () {
    var time = moment.utc(this.props.slot.start_time).format("hh:mm A");
    return React.createElement(
      "li",
      { onClick: this.handleClick },
      React.createElement(
        "a",
        { className: this.generateStyle() },
        time
      )
    );
  }
});