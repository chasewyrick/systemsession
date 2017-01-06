# System Session
A watchdog that runs in the background. It makes sure that all system applications are running in case of system crash/error.
Made specifically for Kedos's system components, but you can extend it in src/Control.vala

Building
-----------

You need acis, gee-0.8, gio-2.0, and of course, the apps you need to watch (deepy, mfk, and rado).
cd to the directory, then: 

```
mkdir build
cd build
cmake ..
sudo make install
./systemsession
```
