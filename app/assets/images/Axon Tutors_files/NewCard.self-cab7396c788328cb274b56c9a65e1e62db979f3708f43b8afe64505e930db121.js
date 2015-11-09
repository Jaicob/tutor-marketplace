var NewCard = React.createClass({
  displayName: "NewCard",

  getInitialState: function () {
    return {
      cardNumber: "",
      exp: "",
      cvc: "",
      success: false
    };
  },

  handleCardNumber: function (e) {
    this.setState({ cardNumber: e.target.value });
  },

  handleExpDate: function (e) {
    this.setState({ exp: e.target.value });
  },

  handleCVC: function (e) {
    this.setState({ cvc: e.target.value });
  },

  handleStripe: function () {
    var exp_joined = this.state.exp,
        exp_month,
        exp_year;
    var exp_split = exp_joined.split("/");
    exp_month = exp_split[0];
    exp_year = exp_split[1];
    Stripe.setPublishableKey("pk_test_4VObdz0T8dwNAdD0ZPcU8amz");
    var form = { "number": this.state.cardNumber, "exp_month": exp_month, "exp_year": exp_year, "cvc": this.state.cvc };
    console.log(form);
    Stripe.card.createToken(form, this.stripeResponseHandler);
  },

  stripeResponseHandler: function (status, response) {
    var token = response.id;
    console.log(token);
    this.props.onTokenChange(token);
    this.setState({ cardNumber: "", exp: "", cvc: "", success: true });
  },

  render: function () {
    if (this.state.success == false) {
      return React.createElement(
        "div",
        null,
        React.createElement(
          "h3",
          null,
          "New Card"
        ),
        React.createElement(
          "div",
          { id: "card-form" },
          React.createElement(
            "label",
            { htmlFor: "card-number" },
            "Card Number"
          ),
          React.createElement("input", { id: "card-number", type: "text", value: this.state.cardNumber, onChange: this.handleCardNumber }),
          React.createElement(
            "label",
            { htmlFor: "exp" },
            "Expiration MM/YY"
          ),
          React.createElement("input", { id: "exp", type: "text", value: this.state.exp, onChange: this.handleExpDate }),
          React.createElement(
            "label",
            { htmlFor: "cvc" },
            "CVC"
          ),
          React.createElement("input", { id: "cvc", type: "text", value: this.state.cvc, onChange: this.handleCVC }),
          React.createElement(
            "a",
            { onClick: this.handleStripe, className: "btn" },
            "Use Card"
          )
        )
      );
    } else {
      return React.createElement(
        "div",
        null,
        React.createElement(
          "h3",
          null,
          "Card validated and ready for use."
        ),
        React.createElement(
          "h5",
          null,
          "Note: Your card will not be charged until you confirm on the next screen."
        )
      );
    }
  }
});