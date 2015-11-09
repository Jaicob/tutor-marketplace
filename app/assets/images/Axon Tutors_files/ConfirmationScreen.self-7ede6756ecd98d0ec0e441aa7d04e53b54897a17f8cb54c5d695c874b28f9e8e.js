var ConfirmationScreen = React.createClass({
  displayName: "ConfirmationScreen",

  render: function () {
    return React.createElement(
      "div",
      null,
      React.createElement(
        "p",
        null,
        "Here is a summary of your appointment.",
        React.createElement("br", null),
        "Subject: ",
        this.props.selectedSubject.course_name,
        " ($",
        this.props.selectedSubject.rate,
        " per hour)",
        React.createElement("br", null),
        "Total: $",
        this.props.selectedSlots.length * this.props.selectedSubject.rate,
        React.createElement("br", null),
        "Times: ",
        React.createElement("br", null),
        " ",
        this.props.selectedSlots.map(function (slot) {
          return React.createElement(
            "span",
            { style: { display: "block" } },
            moment(slot.start_time).utc().format("M/DD/YYYY hh:mm A") + " - " + moment(slot.start_time).utc().add(1, 'h').format("M/DD/YYYY hh:mm A")
          );
        })
      )
    );
  }
});