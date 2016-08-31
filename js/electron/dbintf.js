const mysql = require('mysql');

// var host     = '54.82.250.249';
// var user     = 'remote';
// var password = 'remote';
// var database = 'media';

exports.getMatchResolutionSourceFolders = function() {

	folders = {}

	mediafolder = {}
	mediafolder.id = 'AVZzIDhCj9LJ-Pt7GUT3';
	mediafolder.path = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/cleanse, fold, and manipulate';
	mediafolder.album = 'Cleanse, Fold and Manipulate';

	folders[0] = mediafolder;

	mediafolder = {}
	mediafolder.id = 'AVZzIDlBj9LJ-Pt7GUT4';
	mediafolder.path = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/Handover';
	mediafolder.album = 'Handover';

	folders[1] = mediafolder;

	mediafolder = {}
	mediafolder.id = 'AVZzIEgfj9LJ-Pt7GUT5';
	mediafolder.path = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/mind - the perpetual intercourse';
	mediafolder.album = 'Mind: The Perpetual Intercourse';

	folders[2] = mediafolder;

	mediafolder = {}
	mediafolder.id = 'AVZzIDhCj9LJ-Pt7GUT3';
	mediafolder.path = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/cleanse, fold, and manipulate';
	mediafolder.album = 'Cleanse, Fold and Manipulate';

	folders[3] = mediafolder;

	mediafolder = {}
	mediafolder.id = 'AVZzIFl8j9LJ-Pt7GUT6';
	mediafolder.path = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/spasmolytic';
	mediafolder.album = 'Spasmolytic';

	folders[4] = mediafolder;


    // var connection = mysql.createConnection({
    //     host     : '54.82.250.249',
    //     user     : 'remote',
    //     password : 'remote',
    //     database : 'media'
	// });

	// connection.connect();

	// connection.query('SELECT * from match_resolution_source_path', function(err, rows, fields) {
	// if (!err)
	// 	console.log('The solution is: ', rows);
	// else
	// 	console.log('Error while performing Query.');
	// });

	// connection.end();
}

exports.getSongs = function() {

	album = {}

	song = {}
	song.trackNum = '1'
	song.filename = '01 - first aid.mp3'
	song.filesize = '987922'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'First Aid'
	album[0] = song

	song = {}
	song.trackNum = '2'
	song.filename = '02 - addiction.mp3'
	song.filesize = '746593'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Addiction'
	album[1] = song

	song = {}
	song.trackNum = '3'
	song.filename = '03 - shadow cast.mp3'
	song.filesize = '746593'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Shadow Cast'
	album[2] = song

	song = {}
	song.trackNum = '3'
	song.filename = '04 - draining faces.mp3'
	song.filesize = '746593'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Draining Faces'
	album[3] = song

	song = {}
	song.trackNum = '5'
	song.filename = '05 - the mourn.mp3'
	song.filesize = '746593'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'The Mourn'
	album[4] = song

	song = {}
	song.trackNum = '6'
	song.filename = '06 - second tooth.mp3'
	song.filesize = '746593'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Second Tooth'
	album[5] = song

	song = {}
	song.trackNum = '7'
	song.filename = '07 - tear or beat.mp3'
	song.filesize = '746593'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Tear or Beat'
	album[6] = song

	song = {}
	song.trackNum = '8'
	song.filename = '08 - deep down trauma hounds.mp3'
	song.filesize = '847483'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Deep Down Trauma Hounds'
	album[7] = song

	song = {}
	song.trackNum = '9'
	song.filename = '09 - anger.mp3.mp3'
	song.filesize = '847483'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Anger'
	album[8] = song
				
	song = {}
	song.trackNum = '10'
	song.filename = '00 - epilogue.mp3.mp3'
	song.filesize = '352628'
	song.artist = 'Skinny Puppy'
	song.album = 'Cleanse, Fold, and Manipulate'
	song.title = 'Epilogue'
	album[9] = song

	return album;
}


//   function delItem() {
  
//     var table = document.getElementById("table");
//     var rows = document.getElementById('table').rows;
//     var x = table.deleteRow(rows.length-1);
//   }
//  function delAllItems() {
  
//     var table = document.getElementById("table");
//     var rows = document.getElementById('table').rows;
//         while (rows.length > 1) {
//         table.deleteRow(rows.length-1);
//       rows = document.getElementById('table').rows;
//     } 
//   }
