var NewCard = React.createClass({

  render: function() {
    return (
      <div>
        <h3>New Card</h3>
        {this.props.currentStudent.student.user.full_name}
      </div>
    );
  }
});