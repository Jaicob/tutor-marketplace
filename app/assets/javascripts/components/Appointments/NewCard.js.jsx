var NewCard = React.createClass({

  getInitialState: function() {
    return {
      cardNumber: "",
      exp: "",
      cvc: ""
    };
  },

  handleCardNumber: function(e) {
    this.setState({cardNumber: e.target.value})
  },

  handleExpDate: function(e) {
    this.setState({exp: e.target.value})
  },

  handleCVC: function(e) {
    this.setState({cvc: e.target.value})
  },

  handleStripe: function() {
    var exp_joined = this.state.exp, exp_month, exp_year;
    var exp_split = exp_joined.split("/");
    exp_month = exp_split[0];
    exp_year = exp_split[1];
    Stripe.setPublishableKey("pk_test_4VObdz0T8dwNAdD0ZPcU8amz");
    var form = {"number": this.state.cardNumber, "exp_month": exp_month, "exp_year": exp_year, "cvc": this.state.cvc}
    console.log(form)
    Stripe.card.createToken(form, this.stripeResponseHandler);
  },

  stripeResponseHandler: function(status, response) {
    var token = response.id;
    console.log(token);
    this.props.onTokenChange(token);
  },

  render: function() {
    return (
      <div>
        <h3>New Card</h3>
        <div id="card-form">
          <label htmlFor="card-number">Card Number</label>
          <input id="card-number" type="text" value={this.state.cardNumber} onChange={this.handleCardNumber}/>
          <label htmlFor="exp">Expiration MM/YY</label>
          <input id="exp" type="text" value={this.state.exp} onChange={this.handleExpDate}/>
          <label htmlFor="cvc">CVC</label>
          <input id="cvc" type="text" value={this.state.cvc} onChange={this.handleCVC}/>
          <a  onClick={this.handleStripe} className="btn">Use Card</a>
        </div>
      </div>
    );
  }
});