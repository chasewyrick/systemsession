//  
//  Copyright (C) 2012-2015 Abraham Masri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 

using Acis;

namespace SystemSession {

    /* Wether to debug or not */
    bool Debug = false;
    VolumeMonitor _Monitor;

    public static void ManageOutput (string? d, LogLevelFlags flags, string msg) {

        switch (flags) {

            case LogLevelFlags.LEVEL_ERROR:
                LogEvent (msg, true);
                break;
            
            case LogLevelFlags.LEVEL_INFO:
            case LogLevelFlags.LEVEL_CRITICAL:
            case LogLevelFlags.LEVEL_MESSAGE:
            case LogLevelFlags.LEVEL_DEBUG:
            case LogLevelFlags.LEVEL_WARNING:
                if(Debug)
                    LogEvent (msg, false);
            break;

            default:
                LogEvent (msg, false);
                break;
        }


    }

    private Control _Control;


    GLib.Application _Application = null;


    public static int main (string[] args) {

        /* Be nice to logs */
        PrintWelcome("System Session", COLOR.White);

        // Setup our output text shape
        if(args[1].down() == "--debug" || args[1].down() == "debug")
            Debug = true;

        if(args[1].down() == "--version" || args[1].down() == "version") {
            print("Version: 0.1 - Summit\nCreated by: Abraham Masri\n\n");
            return 0;
        }


        /* Run SystemSession once */
        _Application = new GLib.Application("com.kedos.systemsession",
                                            ApplicationFlags.FLAGS_NONE);
        _Control = new Control();
        Log.set_default_handler(ManageOutput);

        
        _Application.hold();
        return _Application.run(args);
    }
}
