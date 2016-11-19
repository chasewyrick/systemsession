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

    public class MonitoredProcess : Object {


        private uint Crashes;
        private uint FailedRuns;
        private string Executable;
        private bool IsRunning = false;

        private Pid _Pid = -1;
        private Timer? _Timer = null;

        public MonitoredProcess (string Executable) {

            this.Executable = Executable;
            Start();

        }


        public void Start () {

            if(FailedRuns >= 3) {

                return;
            }

            Pid TmpPid;
            string[] argvp = null;

            try {

                Shell.parse_argv (Executable, out argvp);

            } catch {

            }

            if (argvp == null)
                return;

            try {

                Process.spawn_async (null, argvp, null, SpawnFlags.SEARCH_PATH
                                                       |SpawnFlags.STDOUT_TO_DEV_NULL
                                                       |SpawnFlags.DO_NOT_REAP_CHILD
                                                       , null, out TmpPid);
            } catch (Error e) {
                
                LogEvent(@"Unable to run $Executable. Error message: $(e.message)");   
                FailedRuns++;
                Start();

                return;
            }



            _Pid = TmpPid;

            ChildWatch.add (_Pid, ProcessExited);

            IsRunning = true;

        }

        /* Called when the process is terminated */
        private void ProcessExited (Pid TmpPid, int TmpStatus) {

            if (TmpPid == _Pid) 
                if (Process.if_signaled (TmpStatus) || Process.if_exited (TmpStatus) 
                                                    || Process.core_dump (TmpStatus)) {

                    Process.close_pid (_Pid);

                    bool normal_exit = true;

                    Crashes++;

                    if(Crashes >= 4) {

                        LogEvent(Executable + " kept crashing. Stopped running.");
                        return;

                    } else {

                        LogEvent(Executable + " has crashed.");
                        Start();
                    }

                }

        }
    }
}