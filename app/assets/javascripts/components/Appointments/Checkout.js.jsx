var Checkout = React.createClass({
  componentWillMount: function () {
    this.setDelegates();
  },
  getInitialState: function () {
    return {
      "promo": this.props.promo || null
    }
  },
  setDelegates: function () {
    navBar = this.props.UINavigationBarDelegate;
    navBar.canGoForward = true;
    navBar.canGoBack = true;
    navBar.titleBarText = "Checkout";
    navBar.backButtonText = "Change location";
    navBar.forwardButtonText = "Proceed to Payment";
    navBar.backButtonClick = function (update) {
      this.props.handlePromo(this.state.promo);
      update();
    }.bind(this);
    navBar.forwardButtonClick = function (update) {
      this.props.handlePromo(this.state.promo);
      update();
    }.bind(this);
    this.props.updateDelegate(navBar);
  },
  applyPromoCode: function () {
    var endpoint = API.endpoints.promo({
      promo_code: $("#promoInput").val(),
      tutor_id: this.props.tutor
    });

    $.getJSON(endpoint, function(promo){
      if (promo.is_valid) {
        this.setState({
          promo: promo
        });
      } else {
        console.log("Promo not valid", promo.description);
        $("#promoInput").val("Promo not valid.");
      }
    }.bind(this));
  },
  removePromoCode: function () {
    this.setState({
      "promo": null
    });
  },
  getTotal: function () {
    props = this.props;
    console.log("props", props);
    total = props.selectedSubject.rate * (1 + props.margin/100) * props.selectedSlots.length;
    console.log("total", total);
    var promo = this.state.promo;
    if (promo != null) {
      if (promo.type.indexOf("percent") > -1) {
        total *= (1 - promo.value / 100);
      } else if (promo.type.indexOf("free") > -1) {
        total *= 0;
      } else if (promo.type.indexOf("dollar") > -1) {
        total -= promo.value;
      }

      if (total < 0) {
        total = 0;
      };
    }

    return total;
  },
  render: function () {
    var rate = this.props.selectedSubject.rate * (1 + this.props.margin/100);
    var promo = this.state.promo;
    return (
      <div className="main-view">
        <div className="checkout row">
          <div className="cart medium-6 columns">
              <h4>Your Booking</h4>
              <div className="header center">{this.props.tutor_school}<br></br>{this.props.selectedSubject.course_name} with {this.props.tutor_name}<br></br></div>
              <ul className="cart-list">
                {
                  this.props.selectedSlots.map((slot) =>
                    <li className="cart-item">
                      {moment.utc(slot.start_time).format("ddd, MM/DD/YYYY, h:mm A")} - {moment.utc(slot.start_time).add(1, 'h').format("h:mm A")}
                      <span className="rate">${rate.toFixed(2)}</span>
                    </li>
                  )
                }
                {
                  promo != null &&
                    <li className="cart-item">
                      {promo.description || "Discount"}
                      <span className="rate">
                      {
                        (function(){
                          // [ ] TODO (AJ): Refactor/dry this later
                          if (promo.type.indexOf("percent") > -1) {
                            return promo.value + "% off";
                          } else if (promo.type.indexOf("free") > -1) {
                            return "100% off";
                          } else if (promo.type.indexOf("dollar") > -1) {
                            return "-$" + promo.value.toFixed(2);
                          }
                        }.bind(this))()
                      }
                    </span>
                    </li>
                }
              </ul>
              <div className="total">Total <span className="rate">${this.getTotal().toFixed(2)}</span></div>
          </div>
          <div className="promo-code medium-6 columns">
            <div className="wrapper">
              <h4>Promo Codes</h4>
                {promo == null && <input type="text" id="promoInput"></input>}
                {promo == null && <input type="button" className="apply custom-button"  value="Apply"  onClick={this.applyPromoCode}></input>}
                {promo != null && <input type="button" className="remove custom-button" value="Remove" onClick={this.removePromoCode}></input>}
              </div>
          </div>
        </div>
      </div>
    );
  }
});