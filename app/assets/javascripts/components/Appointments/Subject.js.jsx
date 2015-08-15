var Subject = React.createClass({
  componentWillMount: function () {
    this.componentWillReceiveProps(this.props)
  },
  componentWillReceiveProps: function (newProps) {
      if(newProps.selectedSubject == newProps.subject ) {
        this.setState({
          state: "active"
        });
      } else {
        this.setState({
          state: "neutral"
        })
      }
  },
  getInitialState: function () {
      return {
          state: "neutral" // disabled, active, etc.
      };
  },
  getBackground: function () {
    return ["subject-item", this.state.state].join("--");
  },
  handleClick: function () {
    this.props.handleClick(this.props.subject)
  },
  render: function () {
    return (
      <a onClick={this.handleClick}
         className={this.getBackground()}>
        {this.props.subject.name} -- ${this.props.subject.rate}/hr
      </a>
    )
  }
});