var ReactScriptLoaderMixin = require('react-script-loader').ReactScriptLoaderMixin;

var PaymentForm = React.createClass({
  mixins: [ReactScriptLoaderMixin],
  getScriptURL: function() {
    return 'https://checkout.stripe.com/checkout.js';
  },

  statics: {
    stripeHandler: null,
    scriptDidError: false,
  },

  // Indicates if the user has clicked on the button before the
  // the script has loaded.
  hasPendingClick: false,

  onScriptLoaded: function() {
    // This identifies your website in the createToken call below
  Stripe.setPublishableKey("<%= Rails.configuration.stripe[:publishable_key] %>");

  function stripeResponseHandler(status, response) {
    var $form = $('#payment-form');
    if (response.error) {
      // Show the errors on the form
      $form.find('.payment-errors').text(response.error.message);
      $form.find('button').prop('disabled', false).html('Confirm');
    } else {
      // response contains id and card, which contains additional card details
      var token = response.id;
      // Insert the token into the form so it gets submitted to the server
      $form.append($('<input type="hidden" name="stripeToken" />').val(token));

      // and submit
      $form.get(0).submit();
    }
  };



  jQuery(function($) {
    $('.ccn').focus(function(){
      $('#card_id_new_card').prop("checked", true).trigger("click");
    });


    $('#payment-form').submit(function(event) {
      var $form = $(this);

      // Disable the submit button to prevent repeated clicks
      $form.find('button').prop('disabled', true).html("<span class='fa fa-circle-o-notch fa-spin'></span> Checking Availability ...");

      if ($('input[name=card_id]:checked', '#payment-form').val() == "new_card"){
        Stripe.card.createToken($form, stripeResponseHandler);

        // Prevent the form from submitting with the default action
        return false;
      }
    });
  });
  },

  handleCardChange: function(e) {
    this.setState({cardNumber: e.target.value});
  },

  onScriptError: function() {
    PaymentForm.scriptDidError = true;
  },

  render: function() {
    return (
      <div id="payment-form">
        <div className="form-group">
          <label>
            <span>Card Number</span>
            <input type="tel" size="20" data-stripe="number" className="ccn" placeholder="•••• •••• •••• ••••" />
          </label>
        </div>
        <div className="form-group">
          <div className="expiration-wrap">
            <label>Expiration (MM/YYYY)</label>
            <input type="text" size="2" data-stripe="exp-month" id="exp-month" type="tel" className="cc-exp month" autocomplete="cc-exp" placeholder="••" />
            <span>/</span>
            <input type="text" size="4" data-stripe="exp-year" id="exp-year" type="tel" className="cc-exp year" autocomplete="cc-exp" placeholder="••••" />
          </div>
          <div className="cvc-wrap">
            <label>CVC</label>
            <input type="tel" size="4" data-stripe="cvc" className="cc-cvc" autocomplete="off" placeholder="•••" />
          </div>
        </div>
      </div>
    );
  }
});