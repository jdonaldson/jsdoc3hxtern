jsdoc3-hxtern
============

a jsdoc3 plugin for generating haxe externs

[Jsdoc](http://usejsdoc.org/) is a popular documentation generator for
javascript.  Google uses a special version of jsdoc for its [closure
compiler](https://developers.google.com/closure/compiler/docs/js-for-compiler).
The extended documentation tags enable more specific typing information for
callback arguments, etc.



It's currently in an incomplete alpha state.


## Basic workflow
jsdoc3-hxtern works by plugging directly into jsdoc, extracting individual 
methods, variables, modules, and classes, and then expanding the type
information there using a special closure compiler-comaptible parser called
[doctrine](https://github.com/Constellation/doctrine).

After doclets are extracted and type information gathered from doctrine, there
are still several situations that require special handling.  
 
-  It's typical to have static methods attached to "modules" in javascript,
   rather than to a "class".  E.g. if there were a module of "foo.bar", it's
   common to attach a method to it:
   ```js
   foo.bar.baz = function(){...}
   ```
   In Haxe, this isn't possible.  Hxtern converts the last module into a
   "virtual" class, and attaches the method to that instead:

   ```haxe
   package foo;
   @:native("foo.bar");
   class Bar {
      public static function baz(){...}
   }
   ```
   If there's already a Bar class in the js file, then the process will fail.

-  Hxtern tries to convert js types and jsdoc tags to Haxe equivalents.
   Here's an (incomplete) list:
   ```
      boolean  -> Bool;
      string   -> String;
      Array    -> Array;
      number   -> Float;
      Object   -> Dynamic;
      Function -> Dynamic;
      void     -> Void;
   ```
   Further transformations are possible depending on type details... e.g. 
   Object<string, number> will get translated to Map<String,Float>.

## TODO

- handle @extends
- handle union types
- handle methods, variables, etc. that do not have documentation

