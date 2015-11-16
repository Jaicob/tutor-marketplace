var Checkout = React.createClass({
  componentWillMount: function () {
    this.setDelegates();
  },
  getInitialState: function () {
    return {
      "promo": null,
      "error": false
    }
  },
  setDelegates: function () {
    navBar = this.props.UINavigationBarDelegate;
    navBar.canGoForward = true;
    navBar.canGoBack = true;
    navBar.titleBarText = "Checkout";
    navBar.backButtonText = "Change location";
    navBar.forwardButtonText = "Proceed to Payment";
    this.props.updateDelegate(navBar);
  },
  applyPromoCode: function () {
    var endpoint = API.endpoints.promo({
      code: this.promoInput.value
    });

    $.getJSON(endpoints, function(promo){
      if (promo.valid) {
        modified_promo = promo;
        this.setState({
          promo: modified_promo
        });
      } else {
        console.log("Promo not valid", promo.description);
        this.promoInput.value = "Promo not valid.";
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
    if (this.state.promo != null) {
      switch (this.state.promo.type) {
        case "flat":
          total -= this.state.promo.value;
          break;
        case "percentage":
          total *= (1 - this.state.promo.value/100);
          break;
        default:
          break;
      }
    }

    return total;
  },
  render: function () {
    var rate = this.props.selectedSubject.rate * (1 + this.props.margin/100);
    return (
      <div className="main-view">
        <div className="checkout row">
          <div className="cart medium-6 columns">
              <h4>Your Booking</h4>
              <div className="header center">{this.props.selectedSubject.course_name} with {this.props.tutor_name}<br></br></div>
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
                  this.state.promo != null &&
                    <li className="cart-item">
                      {this.state.promo.name}
                      <span className="rate">{(function(){
                        switch (this.state.promo.type) {
                          case "flat":
                            return "-$" + this.state.promo.value.toFixed(2);
                            break;
                          case "percentage":
                            return "-" + this.state.promo.value + "%";
                            break;
                          default:
                            break;
                        }
                      }.bind(this))()}</span>
                    </li>
                }
              </ul>
              <div className="total">Total <span className="rate">${this.getTotal().toFixed(2)}</span></div>
          </div>
          <div className="promo-code medium-6 columns">
            <div className="wrapper">
              <h4>Promo Codes</h4>
                {this.state.promo == null && <input type="text" ref={(ref) => this.promoInput = ref}></input>}
                {this.state.promo == null && <input type="button" className="apply custom-button"  value="Apply"  onClick={this.applyPromoCode}></input>}
                {this.state.promo != null && <input type="button" className="remove custom-button" value="Remove" onClick={this.removePromoCode}></input>}
              </div>
          </div>
        </div>
      </div>
    );
  }
});