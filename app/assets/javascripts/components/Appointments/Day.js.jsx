var Day = React.createClass({
  render: function () {
    return (
      <li className={"day " + this.props.day.format("dddd").toLowerCase()}>
        <label htmlFor={this.props.day.format("dddd").toLowerCase()}>{this.props.day.format("ddd M/DD")}</label>
        <input id={this.props.day.format("dddd").toLowerCase()} name="radio" type="radio" className="radio"></input>
        <ul className="available-times">
          {
            this.props.slots.map(function (slot) {
              if (this.props.disabledSlots.indexOf(slot) > -1) {
                return;
              } else {
                var isSelected = this.props.selectedSlots.find(function(element, index, array){
                  return element.id == slot.id && element.start_time === slot.start_time;
                }) != undefined;
                return <Slot key={MD5(slot.id + slot.start_time)} slot={slot} selected={isSelected} handleSlotClick={this.props.handleSlotClick} />;
              }
            }.bind(this))
          }
        </ul>
      </li>
    );
  }
})