'use strict';
const electron = require('electron');
var mysql = require('mysql');

const app = electron.app;


// adds debug features like hotkeys for triggering dev tools and reload
require('electron-debug')();

// prevent window being garbage collected
let mainWindow;

function onClosed() {
	// dereference the window
	// for multiple windows store them in an array
	mainWindow = null;
}

function createMainWindow() {
	const win = new electron.BrowserWindow({
		width: 1000,
		height: 600
	});

	win.loadURL(`file://${__dirname}/index.html`);
	win.on('closed', onClosed);

	return win;
}

app.on('window-all-closed', () => {
	if (process.platform !== 'darwin') {
		app.quit();
	}
});

app.on('activate', () => {
	if (!mainWindow) {
		mainWindow = createMainWindow();
	}
});

app.on('ready', () => {

	// var connection = mysql.createConnection({
	// host     : '54.82.250.249',
	// user     : 'remote',
	// password : 'remote',
	// database : 'media'
	// });

	// connection.connect();

	// connection.query('SELECT * from media_format', function(err, rows, fields) {
	// if (!err)
	// 	console.log('The solution is: ', rows);
	// else
	// 	console.log('Error while performing Query.');
	// });

	// connection.end();


	mainWindow = createMainWindow();
});
