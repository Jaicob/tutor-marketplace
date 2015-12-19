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

  showPromoCode: function () {
    var promo = this.props.promo;

    if (promo == null) {
      return;
    } else {
      return <li>{promo.description || "Discount"}<span className="rate">{
        (function(promo){
          // [ ] TODO (AJ): Refactor/dry this later
          if (promo.type.indexOf("percent") > -1) {
            return promo.value + "% off";
          } else if (promo.type.indexOf("free") > -1) {
            return "100% off";
          } else if (promo.type.indexOf("dollar") > -1) {
            return "-$" + promo.value.toFixed(2);
          }
        }.bind(this))(promo)
      }</span></li>
    }
  },

  render: function() {
    let padToFour = number => number <= 9999 ? ("000"+number).slice(-4) : number;
    return (
      <div className="main-view">
        <div className="receipt-view">
          <p>Here is a summary of your booking for your records. Thanks for choosing Axon Tutors.</p>
          <div class="receipt">
            <div className="header">Receipt #{padToFour(this.props.charge.id)} -- {moment().format("dddd, MMMM Do YYYY, h:mm a")}</div>
            <div className="row">
              <div className="medium-12 columns tutor-side">
                {this.props.student.full_name} (Student) ↔ {this.props.tutor_name} for {this.props.selectedSubject.course_name} on {this.props.tutor_school} campus
                <ul>
                {this.props.selectedSlots.map((slot) => <li>{moment(slot.start_time).format("ddd, MM/DD/YYYY, h:mm A")} - {moment(slot.start_time).add(1, 'h').format("h:mm A")} <span className="rate">${(this.props.selectedSubject.rate * 1 - (this.props.margin / 100)).toFixed(2)}</span></li>)}
                {this.showPromoCode()}
                </ul>
                <hr></hr>
                <span>Total: ${this.props.total.toFixed(2)}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
})