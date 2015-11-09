var Day = React.createClass({
  displayName: "Day",

  render: function () {
    return React.createElement(
      "li",
      { className: "day " + this.props.day.format("dddd").toLowerCase() },
      React.createElement(
        "label",
        { htmlFor: this.props.day.format("dddd").toLowerCase() },
        this.props.day.format("M/DD")
      ),
      React.createElement("input", { id: this.props.day.format("dddd").toLowerCase(), name: "radio", type: "radio", className: "radio" }),
      React.createElement(
        "ul",
        { className: "available-times" },
        this.props.slots.map((function (slot) {
          if (this.props.disabledSlots.indexOf(slot) > -1) {
            return;
          } else {
            var isSelected = this.props.selectedSlots.filter(function (item) {
              return item.id === slot.id && item.start_time === slot.start_time;
            }).length > 0;
            return React.createElement(Slot, { slot: slot, selected: isSelected, handleSlotClick: this.props.handleSlotClick });
          }
        }).bind(this))
      )
    );
  }
});