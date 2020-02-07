"use strict";
///*
const electron = require('electron')
const isDev = require("electron-is-dev");
const os = require("os");
// Module to control application life.
const app = electron.app
var eos;
(function (eos) {
    eos["MAC"] = "darwin";
    eos["WINDOWS"] = "win32";
})(eos || (eos = {}));
function getIconFile() {
    switch (os.platform()) {
        case eos.MAC:
            return 'mac/icon.icns';
        case eos.WINDOWS:
        default:
            return 'win/icon.ico';
    }
}
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow

const path = require('path')
const url = require('url')

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
  // Create the browser window.
  //mainWindow = new BrowserWindow({titleBarStyle: 'hidden',transparent: true, frame: true, width: 800, height: 600})
  //mainWindow = new BrowserWindow({resizable: true,transparent: true, frame: true, width: 800, height: 600});
  //mainWindow = new BrowserWindow({" -integration": false, resizable: true,width: 1050, height: 840});
  mainWindow = new BrowserWindow({resizable: true,width: 1050, height: 840});

  mainWindow.setResizable(true);
  
  

  // and load the index.html of the app.
  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'index.html'),
    protocol: 'file:',
    slashes: true
  }));
  if (isDev) {
        //mainWindow.webContents.openDevTools();
    }
    mainWindow.on('closed', () => {
        mainWindow = null;
    });
    const template = [{
            label: "Application",
            submenu: [{
                    label: "About LCC64 v.3.0",
                    click: function () {
                        mainWindow.webContents.send('open-about');
                    }
                },
                {
                    type: "separator"
                }
				/*
				,
				{
                    label: "Estyjs - Atari Emulator",
                    accelerator: "CommandOrControl+Option+R",
                    click: function () {
                        mainWindow.loadURL(url.format({
                            pathname: path.join(__dirname, 'atari.html'),
                            protocol: 'file:',
                            slashes: true
                          }));
                    }
                },
				{
                    label: "Estyjs",
                    accelerator: "CommandOrControl+Option+R",
                    click: function () {
                        mainWindow.loadURL(url.format({
                            pathname: path.join(__dirname, 'estyjs.html'),
                            protocol: 'file:',
                            slashes: true
                          }));
                    }
                }*/,
                {
                    label: "Reload",
                    accelerator: "CommandOrControl+Option+R",
                    click: function () {
                        mainWindow.loadURL(url.format({
                            pathname: path.join(__dirname, 'index.html'),
                            protocol: 'file:',
                            slashes: true
                          }));
                    }
                },
                {
                    label: "Toggle Developer Tools",
                    accelerator: "CommandOrControl+Option+J",
                    click: function () {
                        mainWindow.webContents.openDevTools();
                    }
                },
                {
                    type: "separator"
                },
                {
                    label: "Quit",
                    accelerator: "CommandOrControl+Q",
                    click: function () {
                        electron.app.quit();
                    }
                }
            ]
        },
        {
            label: "Edit",
            submenu: [{
                    label: "Undo",
                    accelerator: "CmdOrCtrl+Z",
                    role: "undo"
                },
                {
                    label: "Redo",
                    accelerator: "Shift+CmdOrCtrl+Z",
                    role: "redo"
                },
                {
                    type: "separator"
                },
                {
                    label: "Cut",
                    accelerator: "CmdOrCtrl+X",
                    role: "cut"
                },
                {
                    label: "Copy",
                    accelerator: "CmdOrCtrl+C",
                    role: "copy"
                },
                {
                    label: "Paste",
                    accelerator: "CmdOrCtrl+V",
                    role: "paste"
                },
                {
                    label: "Select All",
                    accelerator: "CmdOrCtrl+A",
                    role: "selectall"
                }
            ]
        },
        {
            label: "Support",
            submenu: [{
                    label: "Help",
                    click: function () {
                        electron.shell.openExternal('http://letztechance.org/contact.html');
                    }
                },
                {
                    label: "Docs",
                    click: function () {
                        electron.shell.openExternal('http://letztechance.org');
                    }
                },
                {
                    type: "separator"
                },
                {
                    label: "Homepage",
                    click: function () {
                        electron.shell.openExternal('https://letztechance.org/');
                    }
                },
            ]
        },
        {
            label: "Terms of use",
            submenu: [{
                    label: "Disclaimer",
                    click: function () {
                        electron.shell.openExternal('https://letztechance.org/#disclaimer');
                    }
                }]
        },
    ];
    electron.Menu.setApplicationMenu(electron.Menu.buildFromTemplate(template));
  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
// app.on('ready', function() {
      // var mainWindow = new BrowserWindow({
        // "node-integration": false
      // })
	  // createWindow
// //rest of your initialization code here.
// })
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
})