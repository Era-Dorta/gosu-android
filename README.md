Gosu-Android
============
A Gosu implementation for Adroid devices.

Installation
-----------

All you need to do is execute:

`gem install gosu_android`

And you're done! For a quick-start sample project, see the Arkanoid example on the Ruboto wiki: https://github.com/ruboto/ruboto/wiki/Tutorial:-write-a-gosu-game

General Information
-------------------
* This is still an early effort, so there are a number of features that had not yet been added. 
* There are some known bugs that I hope to fix soon.
* In its current status there are some small changes to Gosu Window initialization, check examples.
* A new object with some basic physics has been added.

Troubleshooting
-------------------
* When using several audio files double check that all have the same codification or you could get: `E/MediaPlayer(16127): Unable to to create media player`
 	* http://forums.pragprog.com/forums/152/topics/9144
