var SlotRangeControls = React.createClass({
  render: function () {
    return (
      <div>
        <a onClick={this.props.handlePreviousRange}>←</a>
        <a onClick={this.props.handleNextRange}>→</a>
      </div>
    );
  }
})