import React from "react";

const DIRS  = "Directories"
const DIR_CONSTS = "Directory Constants"
const CATS  = "Document Categories"
const FORMATS = "Document Formats"
const META = "Document Metadata"
const MATCHERS = "Matchers"
const WEIGHT = "Match Weights"
const DISCOUNT = "Match Discount"
const MATCHER_CONFIG = "Matcher Config"

class App extends React.Component {

   constructor() {
      super();
		
      this.state = {
         showTable: false,
         tableName: "Database Management"
      }

      this.updateState = this.updateState.bind(this);
   };
  
    updateState(e) {
      this.setState({showTable: true, tableName: e.target.id})
   };

    render() {
      return (
         <div>
            <Navbar/>
            <div className="container-fluid">
              <div className="row">
                <Sidebar updateStateProp = {this.updateState}/>
                <div className="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                  <h2 className="page-header">{this.state.tableName}</h2>
                  { this.state.showTable ? <DataTable /> : null }
                </div>
              </div>
            </div>
         </div>
      );
   }
}

class Sidebar extends React.Component {
   render() {
      return (
        <div className="col-sm-3 col-md-2 sidebar">
          {/* <button onClick = {this.props.updateStateProp}>CLICK</button>
          <h3>{this.props.myDataProp}</h3> */}
          <ul className="nav nav-sidebar">
            <li className="active"><a href="#">Database Management <span className="sr-only"/></a></li>
            <li><a href="#" id={DIRS} onClick = {this.props.updateStateProp}>{DIRS}</a></li>
            <li><a href="#" id={DIR_CONSTS} onClick = {this.props.updateStateProp}>{DIR_CONSTS}</a></li>
            <li><a href="#" id={CATS} onClick = {this.props.updateStateProp}>{CATS}</a></li>
            <li><a href="#" id={FORMATS} onClick = {this.props.updateStateProp}>{FORMATS}</a></li>
            <li><a href="#" id={META} onClick = {this.props.updateStateProp}>{CATS}</a></li>
          </ul>
          <ul className="nav nav-sidebar">
            <li className="active"><a href="#">Matcher Configuration <span className="sr-only"/></a></li>
            <li><a href="#" id={MATCHERS} onClick = {this.props.updateStateProp}>{MATCHERS}</a></li>
            <li><a href="#" id={WEIGHT} onClick = {this.props.updateStateProp}>{WEIGHT}</a></li>
            <li><a href="#" id={DISCOUNT} onClick = {this.props.updateStateProp}>{DISCOUNT}</a></li>
            <li><a href="#" id={MATCHER_CONFIG} onClick = {this.props.updateStateProp}>{MATCHER_CONFIG}</a></li>
          </ul>
          <ul className="nav nav-sidebar">
            <li className="active"><a href="#">Scanner Configuration <span className="sr-only"/></a></li>
          </ul>
        </div>

      );
   }
}

class Navbar extends React.Component {
   render() {
      return (
         <div>
           <nav className="navbar navbar-inverse navbar-fixed-top">
             <div className="container-fluid">
               <div className="navbar-header">
                 <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                   <span className="sr-only">Toggle navigation</span>
                   <span className="icon-bar"></span>
                   <span className="icon-bar"></span>
                   <span className="icon-bar"></span>
                 </button>
                 <a className="navbar-brand" href="#">Mildred 0.8.7</a>
               </div>
               <div id="navbar" className="navbar-collapse collapse">
                 <ul className="nav navbar-nav navbar-right">
                   <li><a href="/dashboard">Dashboard</a></li>
                   <li><a href="/about">About</a></li>
                   <li><a href="#">Help</a></li>
                 </ul>
                 <Search/>
               </div>
             </div>
           </nav>
         </div>
      );
   }
}

class Search extends React.Component {
   render() {
      return (
        <form className="navbar-form navbar-left">
          <input type="text" className="form-control" placeholder="Search..."/>
        </form>
      );
   }
}

class Dashboard extends React.Component {
  render() {
    return (
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">Dashboard</h1>
          <div class="row placeholders">
            <div class="col-xs-6 col-sm-3 placeholder">
              <img src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" width="200" height="200" class="img-responsive" alt="Generic placeholder thumbnail"/>
              <h4>Label</h4>
              <span class="text-muted">Something else</span>
            </div>
            <div class="col-xs-6 col-sm-3 placeholder">
              <img src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" width="200" height="200" class="img-responsive" alt="Generic placeholder thumbnail"/>
              <h4>Label</h4>
              <span class="text-muted">Something else</span>
            </div>
            <div class="col-xs-6 col-sm-3 placeholder">
              <img src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" width="200" height="200" class="img-responsive" alt="Generic placeholder thumbnail"/>
              <h4>Label</h4>
              <span class="text-muted">Something else</span>
            </div>
            <div class="col-xs-6 col-sm-3 placeholder">
              <img src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" width="200" height="200" class="img-responsive" alt="Generic placeholder thumbnail"/>
              <h4>Label</h4>
              <span class="text-muted">Something else</span>
            </div>
          </div>
        </div>
    );
  }
} 

class DataTable extends React.Component {
   render() {
      return (
          <div className="table-responsive">
            <table id="directories" className="table table-striped">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Header</th>
                  <th>Header</th>
                  <th>Header</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>1,001</td>
                  <td>ABCD</td>
                  <td>ipsum</td>
                  <td>dolor</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,002</td>
                  <td>amet</td>
                  <td>consectetur</td>
                  <td>adipiscing</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,003</td>
                  <td>Integer</td>
                  <td>nec</td>
                  <td>odio</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,003</td>
                  <td>libero</td>
                  <td>Sed</td>
                  <td>cursus</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,004</td>
                  <td>dapibus</td>
                  <td>diam</td>
                  <td>Sed</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,005</td>
                  <td>Nulla</td>
                  <td>quis</td>
                  <td>sem</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,006</td>
                  <td>nibh</td>
                  <td>elementum</td>
                  <td>imperdiet</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,007</td>
                  <td>sagittis</td>
                  <td>ipsum</td>
                  <td>Praesent</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,008</td>
                  <td>Fusce</td>
                  <td>nec</td>
                  <td>tellus</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,009</td>
                  <td>augue</td>
                  <td>semper</td>
                  <td>porta</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,010</td>
                  <td>massa</td>
                  <td>Vestibulum</td>
                  <td>lacinia</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,011</td>
                  <td>eget</td>
                  <td>nulla</td>
                  <td>Class</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,012</td>
                  <td>taciti</td>
                  <td>sociosqu</td>
                  <td>ad</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,013</td>
                  <td>torquent</td>
                  <td>per</td>
                  <td>conubia</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,014</td>
                  <td>per</td>
                  <td>inceptos</td>
                  <td>himenaeos</td>
                  <td><button>...</button></td>
                </tr>
                <tr>
                  <td>1,015</td>
                  <td>sodales</td>
                  <td>ligula</td>
                  <td>in</td>
                  <td><button>...</button></td>
                </tr>
              </tbody>
            </table>
          </div>
      );
   }
}

export default App;
