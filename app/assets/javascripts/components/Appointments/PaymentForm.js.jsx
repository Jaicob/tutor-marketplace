var PaymentForm = React.createClass({

  render: function() {
    return (
      <div id="payment-form">
        <DefaultCard />
        <NewCard />
      </div>
    );
  }
});