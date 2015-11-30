var Slot = React.createClass({
  getInitialState: function () {
      return {
          active: this.props.selected
      };
  },
  handleClick: function () {
    this.setState({
      active: !this.state.active
    })
    this.props.handleSlotClick(this.props.slot, this.state.active)
  },
  generateStyle: function () {
    if(this.state.active) {
      return "active"
    } else {
      return "neutral"
    }
  },
  render: function () {
    var time = moment(this.props.slot.start_time).format("hh:mm A");
    return (
      <li onClick={this.handleClick}><a className={this.generateStyle()}>{time}</a></li>
    );
  }
})