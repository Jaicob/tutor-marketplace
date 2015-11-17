var PaymentForm = React.createClass({

  handleDefaultCard: function(customer) {
    this.props.onChange(customer, null)
  },

  handleNewCard: function(token) {
    this.props.onChange(null, token)
  },

  render: function () {
    return (
      <div className="main-view">
        {
          (function(){
            if (Object.keys(this.props.currentStudent).length > 0) {
              return (
                <div className="row">
                  <div className="small-6 columns">
                    <DefaultCard currentStudent={this.props.currentStudent} onCardSelect={this.handleDefaultCard} />
                  </div>
                  <div className="small-6 columns">
                    <NewCard currentStudent={this.props.currentStudent} onTokenChange={this.handleNewCard} />
                  </div>
                </div>
              );
            } else {
              return (
                <div className="row">
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