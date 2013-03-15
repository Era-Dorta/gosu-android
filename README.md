Gosu-Android
============
A Gosu implementation for Adroid devices.

Installation
-----------
Sadly right now you need to manually copy every file to every ruboto proyect you want to use it.

- Download the sources
- Copy the `lib` folder and the `gosu.rb` to the `proyect_name/src/` folder inside your [ruboto](http://github.com/ruboto/ruboto) proyect.
- Copy the `gosu.java.jar` in the `proyect_name/libs/` folder.
- Place the `res` files in the `proyect_name/res` folder.
- It is very important that you do not copy the `java` files in your proyect folder, they are included for developers only.


General Information
-------------------
* This is still an early effort, so there are a number of features that had not yet been added. 
* There are some known bugs that I hope to fix soon.
* In its current status there are some small changes to Gosu Window initialization, check examples.
* A new object with some basic physics has been added.

FAQ
-------------------
* I get `(SystemStackError) stack level too deep` in `require 'gosu'` 
	Replace `require 'gosu'` by `with_large_stack { require 'gosu' }` 
	Thanks [@ashes999](https://github.com/ashes999)
