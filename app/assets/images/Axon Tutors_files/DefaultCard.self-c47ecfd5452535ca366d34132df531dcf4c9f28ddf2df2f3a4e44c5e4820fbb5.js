var DefaultCard = React.createClass({
  displayName: "DefaultCard",

  getInitialState: function () {
    return {
      checked: false
    };
  },

  handleUseDefault: function (event) {
    this.setState({ checked: !this.state.checked });
    this.props.onCardSelect(this.props.currentStudent.customer_id);
  },

  render: function () {
    return React.createElement(
      "div",
      null,
      React.createElement(
        "h3",
        null,
        "Default Card"
      ),
      React.createElement(
        "p",
        null,
        "Your default card is: ",
        this.props.currentStudent.card
      ),
      React.createElement(
        "p",
        null,
        React.createElement("input", { type: "checkbox", checked: this.state.checked, onChange: this.handleUseDefault }),
        " Use this card"
      )
    );
  }
});