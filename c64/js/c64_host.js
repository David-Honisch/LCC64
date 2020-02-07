var statusElement = document.getElementById('status');
var progressElement = document.getElementById('progress');
var diskBoxCombo = document.getElementById('diskbox_combo');
var networkStatusDiv = document.getElementById('network_status');
var highScoreStatus = document.getElementById('highScore_status');
var highScoreButton = document.getElementById('highScore_button');
var highScoreTitle = document.getElementById('highScore_title');
var helpElement = document.getElementById('help_div');
	  
var C64Module = {
	keyboardListeningElement: document.getElementById('c64TextInputReceiver'),
	hasFocus: false,
	startSequence: 0,
	error: function(v) {
		console.log(v);
	},
    preRun: [ function(){C64Module.c64preRun();} ],
    postRun: [ function(){C64Module.c64postRun();} ],
	c64preRun: function() {
		try {
			FS.mkdir('/data');
			FS.mount(IDBFS, {}, '/data');
			FS.syncfs(true, function (err) {
				C64Module.c64FsSync();
			});		
		}
		catch(e) {
			C64Module.startSequence|= 2;
		}
	},
	c64postRun: function() {
		C64Module.startSequence|= 1;
		if( C64Module.startSequence == 3 ) C64Module.c64startup();
	},
	c64FsSync: function() {
		C64Module.startSequence|= 2;
		if( C64Module.startSequence == 3 ) C64Module.c64startup();
	},
	c64startup: function() {
		C64Module.keyboardListeningElement.focus();
		C64Module.hasFocus = true;
		C64Module.selectJoystick(0, 0);
		C64Module.setMute(true);
		
		c64_global_startup();
		
		var game = this.requestValue('game');
		var room = this.requestValue('room');
		if( game != null ) {
			this.loadSnapshot(game, false);
		}
		else {
			this.updateLoadSnapshot();
		}
		if( room != null ) {
			this.enableNetwork(room);
		}
	},
	requestValue: function(name) {
		if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
			return decodeURIComponent(name[1]);
		return null;
	},
	canvas: document.getElementById('canvas'),
	setStatus: function(text) {
	  if (!C64Module.setStatus.last) C64Module.setStatus.last = { time: Date.now(), text: '' };
	  if (text === C64Module.setStatus.text) return;
	  var m = text.match(/([^(]+)\((\d+(\.\d+)?)\/(\d+)\)/);
	  var now = Date.now();
	  if (m && now - Date.now() < 30) return; // if this is a progress update, skip it if too soon
	  if (m) {
		text = m[1];
		progressElement.value = parseInt(m[2])*100;
		progressElement.max = parseInt(m[4])*100;
		progressElement.hidden = false;
	  } else {
		progressElement.value = null;
		progressElement.max = null;
		progressElement.hidden = true;
	  }
	  statusElement.innerHTML = text;
	},
	registerCallback: function(name, callback) {
		return C64Module.ccall('js_registerCallback', 'number', ['string', 'number'], [name, Runtime.addFunction(callback, 'vii')]);
	},
	totalDependencies: 0,
	monitorRunDependencies: function(left) {
	  this.totalDependencies = Math.max(this.totalDependencies, left);
	  C64Module.setStatus(left ? 'Preparing... (' + (this.totalDependencies-left) + '/' + this.totalDependencies + ')' : 'All downloads complete.');
	},
	lastSnapshot: '',
	lastFilename: '',
	loadSnapshot: function(fileName, useStorage) {
		C64Module.keyboardListeningElement.focus();
		C64Module.hasFocus = true;
		C64Module.lastSnapshot = fileName;
		C64Module.lastFilename = fileName;
		if( useStorage && fileName != '' && C64Module.snapshotStorage(0) ) {
			return;
		}
		C64Module.lastSnapshot = '';
		C64Module.lastFilename = '';
		var request;
		if (window.XMLHttpRequest) {
			request = new XMLHttpRequest();
		} else {
			request = new ActiveXObject('Microsoft.XMLHTTP');
		}
		// load
		request.open('GET', '/c64/pp_javascript_game.php?game='+fileName, true);
		request.responseType = "arraybuffer";
		request.onload = function (oEvent) {
		  if (request.readyState === 4 && request.status === 200 ) {
			var arrayBuffer = request.response;
			if (arrayBuffer) {
				var byteArray = new Uint8Array(arrayBuffer);
				if( C64Module.ccall('js_LoadSnapshot', 'number', ['array', 'number'], [byteArray, byteArray.byteLength]) ) {
					C64Module.lastSnapshot = fileName;
					C64Module.lastFilename = fileName;
					highScoreButton.disabled = false;
					C64Module.uploadHighscore('', 'request', 'self');
				}
				C64Module.updateDiskBox();
				C64Module.updateLoadSnapshot();
			}
		  }
		};
		request.send();
	},
	loadSnapshotData: function(snapshotData) {
		C64Module.keyboardListeningElement.focus();
		C64Module.hasFocus = true;
		C64Module.lastSnapshot = '';
		C64Module.lastFilename = '';
		if(snapshotData)  {
			if( C64Module.ccall('js_LoadSnapshot', 'number', ['array', 'number'], [snapshotData[1], snapshotData[1].byteLength]) ) {
				C64Module.lastSnapshot = snapshotData[0];
				C64Module.lastFilename = snapshotData[0];
				highScoreButton.disabled = snapshotData[2];
				C64Module.uploadHighscore('', 'request', 'self');
			}
			C64Module.updateDiskBox();
		}
	},
	saveSnapshotData: function() {
		var buffer = C64Module.ccall('js_SaveSnapshot', 'number', ['number'], [0]);
		var bsize = C64Module.ccall('js_SaveSnapshotSize', 'number', [], []);
		return [C64Module.lastSnapshot, new Uint8Array(C64Module.HEAPU8.buffer, buffer, bsize), highScoreButton.disabled];
	},
	loadFile: function(file, startup) {
		C64Module.keyboardListeningElement.focus();
		C64Module.hasFocus = true;
		C64Module.lastSnapshot = '';
		C64Module.lastFilename = file.name;
		
		var fileReader  = new FileReader();
		fileReader.onload  = function() {
			var byteArray = new Uint8Array(this.result);
			if(startup) C64Module.ccall('js_removeDevice', 'number', ['number'], 0);
			C64Module.ccall('js_LoadFile', 'number', ['string', 'array', 'number', 'number'], [file.name, byteArray, byteArray.byteLength, startup]);
			//allowed: highScoreButton.disabled = true;
			highScoreTitle.innerHTML = '';
			C64Module.updateDiskBox();
			C64Module.updateLoadSnapshot();
		}
		fileReader.readAsArrayBuffer(file);
	},
	openHelp: function(lang) {		
		if( C64Module.lastSnapshot == '' ) return false;
		var helprequest;
		if (window.XMLHttpRequest) {
			helprequest = new XMLHttpRequest();
		} else {
			helprequest = new ActiveXObject('Microsoft.XMLHTTP');
		}
		helpElement.style.display = 'none';
		helprequest.open('GET', '/c64/pp_help.php?game='+C64Module.lastSnapshot+'&lang='+lang, true);
		helprequest.onload = function ()
		{
			if (helprequest.readyState == 4 && helprequest.status == 200)
			{
				helpElement.innerHTML = helprequest.responseText;
				if( helprequest.responseText != '' ) {
					helpElement.style.display = 'inline-block';
					window.clearTimeout(C64Module.helpTimer);
					C64Module.helpTimer = window.setTimeout(function(){document.getElementById('help_div').style.display='none';}, 20000);
				}
			}
		}
		helprequest.send();
		return true;
	},
	helpTimer: null,
	highscoreTimer: null,
	cancelHighscore: function() {
		C64Module.keyboardListeningElement.focus();
		C64Module.hasFocus = true;
		C64Module.setPause(false);
	},
	uploadHighscore: function(userName, scoreId, snapName) {
		C64Module.keyboardListeningElement.focus();
		C64Module.hasFocus = true;
		C64Module.setPause(false);
		var lang = document.head.querySelector("[name=Content-Language]").content;
		if( snapName == 'self' ) snapName = C64Module.lastSnapshot;
		if( snapName == '' && scoreId != '' ) return false;
		
		var boundary = "---------------------------7da24f2e50046";
		var hirequest;
		if (window.XMLHttpRequest) {
			hirequest = new XMLHttpRequest();
		} else {
			hirequest = new ActiveXObject('Microsoft.XMLHTTP');
		}
		hirequest.open('POST', '/c64/pp_highscore_upload.php', true);
		hirequest.setRequestHeader('Content-type', 'multipart/form-data; boundary='+boundary);
		hirequest.onreadystatechange = function ()
		{
			if (hirequest.readyState == 4)
			{
				var defaultText = 'Highscore Upload';
				if( hirequest.status == 200 && hirequest.responseText.substring(0, 5) == 'json:' ) {
					var obj = JSON.parse(hirequest.responseText.substring(5));
					if (typeof obj !== 'undefined')
					{
						if (typeof obj.status !== 'undefined') {
							highScoreTitle.innerHTML = obj.status;
						}
						else highScoreTitle.innerHTML = '';
						if (typeof obj.button !== 'undefined') {
							highScoreButton.innerHTML = obj.button;
							highScoreButton.className='button add bhighlight';
						}
						if (typeof obj.help !== 'undefined') {
							helpElement.innerHTML = obj.help;
							if( obj.help != '' ) {
								helpElement.style.display = 'inline-block';
								window.clearTimeout(C64Module.helpTimer);
								C64Module.helpTimer = window.setTimeout(function(){document.getElementById('help_div').style.display='none';}, 20000);
							}
						}
					}
				}
				else if( hirequest.status == 200 && hirequest.responseText.substring(0, 5) == 'form:' ) {
					highScoreStatus.innerHTML = hirequest.responseText.substring(5);
					document.getElementById('highSave').addEventListener("submit", function(e) {
						e.preventDefault();
						handleHighscore();
						}, false);
					document.getElementById('highCancel').addEventListener("click", function(e) {
						handleHighscoreCancel();
						}, false);
					C64Module.hasFocus = false;
					C64Module.setPause(true);
				}
				else {
					highScoreButton.innerHTML = hirequest.responseText;
					highScoreButton.className='button add bhighlight';
				}
				window.clearTimeout(C64Module.highscoreTimer);
				C64Module.highscoreTimer = window.setTimeout(function(){highScoreButton.innerHTML = defaultText; highScoreButton.className='button add';}, 3000);
			}
		}
		
		var body2 = '--' + boundary + '\r\n'
				 + 'Content-Disposition: form-data; name="game"\r\n\r\n'
				 + snapName + '\r\n'
				 + '--' + boundary + '\r\n'
				 + 'Content-Disposition: form-data; name="userName"\r\n\r\n'
				 + userName + '\r\n'
				 + '--' + boundary + '\r\n'
				 + 'Content-Disposition: form-data; name="scoreid"\r\n\r\n'
				 + scoreId + '\r\n'
				 + '--' + boundary + '\r\n'
				 + 'Content-Disposition: form-data; name="lang"\r\n\r\n'
				 + lang + '\r\n'
				 + '--' + boundary + '--' + '\r\n';

		var blob;
		if( scoreId == '' && snapName != '' )
		{
			var buffer = C64Module.ccall('js_SaveSnapshot', 'number', ['number'], [1]);
			var bsize = C64Module.ccall('js_SaveSnapshotSize', 'number', [], []);
			var imgData = new Uint8Array(C64Module.HEAPU8.buffer, buffer, bsize);
			
			var body = '--' + boundary + '\r\n'
					 + 'Content-Disposition: form-data; name="highscore";'
					 + 'filename="temp.s64"\r\n'
					 + 'Content-type: application/octet-stream\r\n'
					 + 'Content-length: ' + imgData.length + '\r\n\r\n';
					 
			blob = new Blob([body, imgData, '\r\n', body2]);
		}
		else
		{
			blob = new Blob([body2]);
		}
			
		var fileReader  = new FileReader();
		fileReader.onload  = function() {
			hirequest.send(this.result);
		}
		fileReader.readAsArrayBuffer(blob);
		return true;
	},
	getProperty: function(name) {
		return C64Module.ccall('js_getProperty', 'string', ['string'], [name]);
	},
	setProperty: function(name, value) {
		return C64Module.ccall('js_setProperty', 'number', ['string', 'string'], [name, value]);
	},
	setJoystick: function(key, down) {
		C64Module.ccall('js_setJoystick', 'number', ['number', 'number'], [key, down]);
	},
	selectJoystick: function(player1, player2) {
		C64Module.ccall('js_selectJoystick', 'number', ['number', 'number'], [player1, player2]);
	},
	setKey: function(key, down) {
		C64Module.ccall('js_setKey', 'number', ['number', 'number'], [key, down]);
	},
	handleDiskBoxClick: function(event) {
		if(event && event.preventDefault) event.preventDefault();
		C64Module.ccall('js_setDiskbox', 'number', ['number'], [document.getElementById("diskSelect").value]);
		document.getElementById("diskSelect").blur();
		return false;
	},
	getDiskBoxHtml: function() {
		return C64Module.ccall('js_getDiskboxHtml', 'string', ['number'], [1]);
	},
	updateDiskBox: function() {
		var db = C64Module.getDiskBoxHtml();
		if( db != '' ) {
			diskBoxCombo.innerHTML  = db;
			document.getElementsByName('diskbox')[0].addEventListener('submit', C64Module.handleDiskBoxClick, false);			
			document.getElementById('diskSelect').addEventListener('change', C64Module.handleDiskBoxClick, false);			
		}
		else {
			diskBoxCombo.innerHTML  = '';
		}
	},
	updateLoadSnapshot: function() {
		var ext = C64Module.lastFilename.split('.').pop().toUpperCase();
		var isTape = (ext == 'TAP') || (C64Module.getProperty('tape_pos') != '-1');
		document.getElementById('tape_keys').className = isTape ? 'show_tape' : 'hide_tape';
	},
	openAndUnlockAudioContext: function() {
		C64Module.SDL.openAudioContext();
		var buffer = C64Module.SDL.audioContext.createBuffer(1, 1, 48000);
		var source = C64Module.SDL.audioContext.createBufferSource();
		source.connect(C64Module.SDL.audioContext.destination);
		if (typeof source['start'] !== 'undefined') {
		  source['start'](0);
		} else if (typeof source['noteOn'] !== 'undefined') {
		  source['noteOn'](0);
		}
	},
	muteState: 0,
	toggleMute: function() {
		C64Module.setMute(C64Module.muteState^1);
		return C64Module.muteState;
	},
	setMute: function(mute) {
		if( !mute && C64Module.hasOwnProperty('SDL') && !C64Module.SDL.audioContext ) {	
			C64Module.openAndUnlockAudioContext();
		}
		C64Module.muteState = mute;
		C64Module.ccall('js_setMute', 'number', ['number'], [mute]);
	},
	setPause: function(pause) {
		C64Module.ccall('js_setPause', 'number', ['number'], [pause]);
	},
	setTape: function(cmd) {
		C64Module.ccall('js_setTape', 'number', ['number'], [cmd]);
	},
	resetEmulation: function(type) {
		C64Module.ccall('js_reset', 'number', ['number'], [type]);
		C64Module.updateDiskBox();
		C64Module.updateLoadSnapshot();
	},
	storageFileExists: function() {
		var storageSnapshot = C64Module.lastSnapshot;
		if( storageSnapshot == '' ) storageSnapshot = 'default.s64';
		try {
			var fst = FS.stat('data/'+storageSnapshot);
			return fst!= null && fst.size;
		}
		catch(e) {
		}
		return false;
	},
	snapshotStorage: function(save) {
		var storageSnapshot = C64Module.lastSnapshot;
		if( storageSnapshot == '' ) storageSnapshot = 'default.s64';
		var res = C64Module.ccall('js_snapshotStorage', 'number', ['number', 'string'], [save, 'data/'+storageSnapshot]);
		if( res && save ) {
			FS.syncfs(function (err) {
				C64Module.updateLoadSnapshot();
			});
		}
		else if( !save ) {
			if( res ) {
				highScoreButton.disabled = true;
				c64_checkfile_type( new File(["data"], storageSnapshot), true );
			}
			C64Module.updateDiskBox();
			C64Module.updateLoadSnapshot();
		}
		return res;
	},
	requestC64FullScreen: function() {
		C64Module.ccall('js_requestFullscreen', 'number', ['number', 'number'], [1, 0]);
	},
	onFullScreenExit: function(softFullscreen) {
		if(softFullscreen) {
			C64Module.keyboardListeningElement.focus();
			C64Module.hasFocus = true;	
		}
	},
    connection: null,
	isConnected: false,
    MODERATOR_SESSION_ID: "C64-8682F682-3230-4A4C-A1B6-FC49AD2DFE68",
    MODERATOR_SESSION: {
		          audio:     false, // by default, it is true
		          video:     false, // by default, it is true
		          screen:    false,
    		      
		          data:      true,
    		      
		          oneway:    false,
		          broadcast: false
		      },
    MODERATOR_EXTRA: {},
	enableNetwork: function(roomName) {
		networkStatusDiv.innerHTML = roomName!='' ? '<h3>Connecting to Network...</h3>' : '<h3>Network Off</h3>';
		return C64Module.ccall('js_enableNetwork', 'number', ['string'], ['c64emulator-'+roomName]);
	},
	connectionStatus: function(state) {
		var c_onopen = C64Module.cwrap('js_net_OnOpen', 'number', ['number']);
		this.isConnected = state;
		networkStatusDiv.innerHTML = state ? '<h3>Network Connected</h3>' : '<h3>Network Disconnected</h3>';
		c_onopen(state);
	},
	createConnection: function(roomName) {
	  var c_onopen = C64Module.cwrap('js_net_OnOpen', 'number', ['number']);
	  
      this.connection = new RTCMultiConnection( this.MODERATOR_SESSION_ID );
	  
		var SIGNALING_SERVER = 'https://webrtcweb.com:9559/';
		this.connection.openSignalingChannel = function(config) {
			var channel = config.channel || C64Module.connection.channel || 'default-namespace';
			var sender = Math.round(Math.random() * 9999999999) + 9999999999;
			io.connect(SIGNALING_SERVER).emit('new-channel', {
				channel: channel,
				sender: sender
			});
			var socket = io.connect(SIGNALING_SERVER + channel);
			socket.channel = channel;
			socket.on('connect', function() {
				if (config.callback) config.callback(socket);
			});
			socket.send = function(message) {
				socket.emit('message', {
					sender: sender,
					data: message
				});
			};
			socket.on('message', config.onmessage);
		};

      this.connection.join(roomName);

      this.connection.onopen = function(event) {
		C64Module.connectionStatus(1);
      }     
      this.connection.onerror = function(event) {
		C64Module.connectionStatus(0);
      }     
      this.connection.onclose = function() {
		C64Module.connectionStatus(0);
      }     
      
      this.connection.onmessage = function(event) {
		var c_onmessage = C64Module.cwrap('js_net_OnMessage', 'number', ['string', 'number']);
		c_onmessage(event.data, 0);
     }
  }
};