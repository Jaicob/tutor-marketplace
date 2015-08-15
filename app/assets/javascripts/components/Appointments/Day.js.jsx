var Day = React.createClass({
  render: function () {
    return (
      <div className="appointment-selector__slot-selector__day">
        <span className="appointment-selector__slot-selector__day--title">{this.props.day.format("M/DD")}</span>
        {
          this.props.slots.map(function (slot) {
            return <Slot slot={slot} handleSlotClick={this.props.handleSlotClick} />
          }.bind(this))
        }
      </div>
    );
  }
})