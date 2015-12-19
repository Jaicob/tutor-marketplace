var ConfirmationScreen = React.createClass({
  render: function () {
    return (
      <div>
        <p>
          Here is a summary of your appointment.<br></br>
          Subject: {this.props.selectedSubject.course_name} (${this.props.selectedSubject.rate} per hour)<br></br>
          Total: ${this.props.selectedSlots.length * this.props.selectedSubject.rate}<br></br>
          Times: <br></br> {this.props.selectedSlots.map(
            (slot) =>
              <span style={{display: "block"}}>
                {moment(slot.start_time).format("M/DD/YYYY hh:mm A") + " - " + moment(slot.start_time).add(1, 'h').format("M/DD/YYYY hh:mm A")}
              </span>
          )}
        </p>
      </div>
    );
  }
});