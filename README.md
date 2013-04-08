Gosu-Android
============
A Gosu implementation for Adroid devices.

Installation
-----------

### Recomended

* Create a file named Gemfile.apk in your ruboto project and add the lines

```ruby
source "http://rubygems.org"
gem 'gosu_android'
```

* Create a folder inside `res` folder call `drawable-nodpi` and copy this [file] (https://github.com/neochuky/gosu-android/tree/master/res/drawable-nodpi/character_atlas8.png)
in it. On linux you can do it easily with: 
`mkdir res/drawable-nodpi` 
`wget https://raw.github.com/neochuky/gosu-android/master/res/drawable-nodpi/character_atlas8.png` 
`mv character_atlas8.png res/drawable-nodpi`

### Alternative
* `gem install gosu_android`

* As with ruboto, place yourself in the root directory of your app, then execute
`gosu_android -a` or `gosu_android --add` to automatically copy every gosu_android file to your ruboto project. 
It will also copy all the media files that are use in gosu_android examples.

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
