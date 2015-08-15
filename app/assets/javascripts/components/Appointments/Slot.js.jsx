var Slot = React.createClass({
  getInitialState: function () {
      return {
          active: false
      };
  },
  handleClick: function () {
    this.setState({
      active: !this.state.active
    })
    this.props.handleSlotClick(this.props.slot)
  },
  generateStyle: function () {
    if(this.state.active) {
      return "appointment-selector__slot-selector__day--slot--active"
    } else {
      return "appointment-selector__slot-selector__day--slot--neutral"
    }
  },
  render: function () {
    var time = moment.utc(this.props.slot.start_time).format("hh:mm A");
    return <div ref="slot" className={this.generateStyle()} onClick={this.handleClick}>{time}</div>
  }
})