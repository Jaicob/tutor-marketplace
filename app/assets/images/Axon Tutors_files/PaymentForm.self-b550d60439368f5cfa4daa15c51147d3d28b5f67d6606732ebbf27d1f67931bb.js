var PaymentForm = React.createClass({
  displayName: "PaymentForm",

  handleDefaultCard: function (customer_id) {
    this.props.onChange(customer_id, null);
  },

  handleNewCard: function (token) {
    this.props.onChange(null, token);
  },

  render: function () {
    if (Object.keys(this.props.currentStudent).length > 0) {
      return React.createElement(
        "div",
        { className: "row" },
        React.createElement(
          "div",
          { className: "small-6 columns" },
          React.createElement(DefaultCard, { currentStudent: this.props.currentStudent, onCardSelect: this.handleDefaultCard })
        ),
        React.createElement(
          "div",
          { className: "small-6 columns" },
          React.createElement(NewCard, { currentStudent: this.props.currentStudent, onTokenChange: this.handleNewCard })
        )
      );
    } else {
      return React.createElement(
        "div",
        { className: "row" },
        React.createElement(
          "h3",
          null,
          "You are not signed in"
        ),
        React.createElement(
          "div",
          { className: "small-6 columns" },
          React.createElement(
            "h4",
            null,
            "Log in"
          )
        ),
        React.createElement(
          "div",
          { className: "small-6 columns" },
          React.createElement(
            "h4",
            null,
            "Sign Up"
          )
        )
      );
    }
  }
});