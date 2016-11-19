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

	public class Control : Object {

		/* Desktop startup ID */
		string StartupID = null;

		/* DBus Interfaces for Gnome */
    	private SessionManager? _SessionManager = null;
        private SessionManagerClientPrivate? _Client = null;
        private ObjectPath? _ClientID = null;

		public Control () {

            StartupID = Environment.get_variable ("DESKTOP_AUTOSTART_ID");

            if(StartupID == null || StartupID == "")
            	StartupID = "com.kedos.sessionmanager";

            RegisterSession();
        	var gnomeSettingsDaemon = new MonitoredProcess("gnome-settings-daemon");
        	var rado = new MonitoredProcess("/System/Applications/rado");
        	var mfk = new MonitoredProcess("/System/Applications/mfk");
        	var deepy = new MonitoredProcess("/System/Applications/deepy");

			_Client.QueryEndSession.connect (() => _Client.EndSessionResponse (true, ""));
			_Client.EndSession.connect (() => _Client.EndSessionResponse (true, ""));
			_Client.Stop.connect (EndSession);
		}


		/* Registers SystemSession */
		private void RegisterSession () {

			_SessionManager = Bus.get_proxy_sync (BusType.SESSION,
												  "org.gnome.SessionManager",
                                                  "/org/gnome/SessionManager");

			_SessionManager.RegisterClient ("com.kedos.sessionmanager", StartupID, out _ClientID);
			_Client = Bus.get_proxy_sync (BusType.SESSION, "org.gnome.SessionManager", _ClientID);

			LogEvent("Controlled SessionManager successfully", true);

        }

		/* Ends the session */
		private void EndSession () {

			_SessionManager.UnregisterClient (_ClientID);
			_Application.release();

			LogEvent("Ended the session", true);

		}

	}

}