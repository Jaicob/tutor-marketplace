var PaymentForm = React.createClass({

  setDelegates: function () {
    navBar = this.props.UINavigationBarDelegate;
    navBar.titleBarText = "Payment";
    navBar.backButtonText = "Review checkout";
    navBar.forwardButtonText = "Process payment";
    navBar.forwardButtonClick = function (update) {
      var endpoint = API.endpoints.process_payment();

      customer_id = this.props.customer;
      if (customer_id == "") {customer_id = null};

      token = this.props.token;
      if (token == "") {token = null};

      promo = this.props.promo;
      if (promo != null && promo.id) {
        promo = promo.id;
      } else {
        promo = null;
      };

      var data = {
        tutor_id: this.props.tutor,
        appt_ids: this.props.appointments.map((appt) => appt.id),
        customer_id: customer_id,
        token: token,
        student_id: this.props.student,
        transaction_percentage: this.props.margin,
        promotion_id: promo
      }

      var request = $.post(endpoint, data, (res) => {
        this.props.handleCharge(res);
        update();
      });

      request.error(function () {
        swal({
          title: "Connectivity Error",
          text: "Please check your Internet connection and try again. Your card has not been charged. If this problem persists, please contact info@axontutors.com",
          type: "error"
        });
      });
    }.bind(this);
    navBar.canShowForwardButton = (this.props.token != "" || this.props.customer != "");

    this.props.updateDelegate(navBar);
  },

  componentWillMount: function () {
    this.setDelegates();
  },

  shouldAllowForward: function (answer) {
    this.props.UINavigationBarDelegate.canShowForwardButton = answer;
    this.props.updateDelegate(this.props.UINavigationBarDelegate);
  },

  handleDefaultCard: function(customer) {
    this.props.onChange(customer, null, this.shouldAllowForward.bind(this, customer != ""));
  },

  handleNewCard: function(token) {
    this.props.onChange(null, token, this.shouldAllowForward.bind(this, token != ""));
  },

  render: function () {
    return (
      <div className="main-view">
        {
          (function(){
            if (Object.keys(this.props.currentStudent).length > 0) {
              return (
                <div className="payment row">
                  <div className="small-6 columns">
                    <div className="card" style={{"borderRight": "1px solid #ccc"}}>
                      <DefaultCard currentStudent={this.props.currentStudent} onCardSelect={this.handleDefaultCard} />
                    </div>
                  </div>
                  <div className="small-6 columns">
                    <div className="card">
                      <NewCard currentStudent={this.props.currentStudent} onTokenChange={this.handleNewCard} />
                    </div>
                  </div>
                </div>
              );
            } else {
              return (
                <div className="payment row">
                  <h3>You are not signed in</h3>
                  <div className="small-6 columns">
                    <h4>Log in</h4>
                  </div>
                  <div className="small-6 columns">
                    <h4>Sign Up</h4>
                  </div>
                </div>
              );
            }
          }.bind(this))()
        }
      </div>
    )
  }
});