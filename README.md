Gosu-Android
============
A [Gosu](http://www.libgosu.org/) implementation for Adroid devices.

Installation
-----------

Install [ruboto](https://github.com/ruboto/ruboto/) and create a project. 

### Recomended

With this installation method you will have a clean enviroment (bundler) to make your gosu games.

* Create a file named `Gemfile.apk` in your ruboto project and add the lines:

```ruby
source "http://rubygems.org"
gem 'gosu_android'
```

* Create a folder inside `res` called `drawable-nodpi` and copy this [file] (https://github.com/neochuky/gosu-android/tree/master/res/drawable-nodpi/character_atlas8.png)
in it. On linux you can do it easily with: 
`mkdir res/drawable-nodpi` 
`wget https://raw.github.com/neochuky/gosu-android/master/res/drawable-nodpi/character_atlas8.png` 
`mv character_atlas8.png res/drawable-nodpi`

### Alternative
With this installation method you will have a dirty enviroment (simple file copy) to try the samples.

* `gem install gosu_android`

* As with ruboto, place yourself in the root directory of your app.
* Then execute `gosu_android -a` or `gosu_android --add` to automatically copy every gosu_android file to your ruboto project. 
It will also copy all the media files that are use in gosu_android examples.

General Information
-------------------
* This is still an early effort, so there are a number of features that had not yet been added. 
* There are some known bugs that I hope to fix soon.
* In its current status there are some small changes to Gosu Window initialization, check examples with many comments in the [wiki](https://github.com/neochuky/gosu-android/wiki).

Troubleshooting
-------------------
* When using several audio files double check that all have the same codification or you could get: `E/MediaPlayer(16127): Unable to to create media player`
 	* http://forums.pragprog.com/forums/152/topics/9144
