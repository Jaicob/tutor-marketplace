var SlotRangeControls = React.createClass({
  render: function () {
    return (
      <nav className="calendar-nav">
          <ul className="navigation-menu navigation--schedule">
              <li className="menu-item previous">
                  <a onClick={this.props.handlePreviousRange} className="btn date-range-paginate previous" alt="This Week" title="This Week" rel="nofollow"><span className="fi-arrow-left"></span> Previous Week</a>
              </li>
              <li className="menu-item next">
                  <a onClick={this.props.handleNextRange} className="btn date-range-paginate next" alt="Next Week" title="Next Week" rel="nofollow">Next Week <span className="fi-arrow-right"></span></a>
              </li>
              <li className="menu-item instructions">
                Select a time.
              </li>
          </ul>
      </nav>
    );
  }
})