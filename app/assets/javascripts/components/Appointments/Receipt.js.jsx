var Receipt = React.createClass({
  setDelegates: function () {
    var navBar = this.props.UINavigationBarDelegate;
    navBar.canShowBackButton = false;
    navBar.canShowForwardButton = false;
    this.props.updateDelegate(navBar);
  },

  componentWillMount: function () {
    this.setDelegates();
  },

  render: function() {
    return (
      <div className="main-view">
        <div className="receipt-view">
          <p>Here is a summary of your booking for your records. Thanks for choosing Axon Tutors.</p>
          <div class="receipt">
            <div className="header">Receipt #{"1243"} -- {moment().format("dddd, MMMM Do YYYY, h:mm a")}</div>
            <hr></hr>
            <div className="notes">Tutor Notes: </div>
            <hr></hr>
            <div className="row">
              <div className="wrapper">
                <div className="medium-6 columns student-side">
                  {this.props.student}
                </div>
              </div>
              <div className="medium-6 columns tutor-side">
                {this.props.tutor_name} for {this.props.selectedSubject.course_name}
                <ul>
                  {this.props.selectedSlots.map((slot) => <li>{moment.utc(slot.start_time).format("ddd, MM/DD/YYYY, h:mm A")} - {moment.utc(slot.start_time).add(1, 'h').format("h:mm A")}</li>)}
                </ul>
                <span>Total: ${this.props.total.toFixed(2)}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
})