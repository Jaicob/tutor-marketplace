var Day = React.createClass({
  render: function () {
    return (
      <div className="appointment-selector__slot-selector__day">
        <span className="appointment-selector__slot-selector__day--title">{this.props.day.format("M/DD")}</span>
        {
          this.props.slots.map(function (slot) {
            if (this.props.disabledSlots.indexOf(slot) > -1) {
              return;
            } else {
              var isSelected = this.props.selectedSlots.filter(
                (item) => (item.id === slot.id) && (item.start_time === slot.start_time)
              ).length > 0;
              return <Slot slot={slot} selected={isSelected} handleSlotClick={this.props.handleSlotClick} />;
            }
          }.bind(this))
        }
      </div>
    );
  }
})