# mruby-cocoa

Interface to Cocoa on mruby.
it's based on [Objective-C Runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html) and [mruby-cfunc](https://github.com/mobiruby/mruby-cfunc/).


## First step

    make test


## Current status

- [x] define class
- [x] define instance method
- [x] define class method
- [x] access to instance variables
- [x] declare instance variables
- [x] define protocol
- [x] define protocol - parent protocols
- [x] define protocol - instance method
- [x] define protocol - class method
- [x] adopt protocol
- [ ] handle exception
- [ ] research NSCopying

- pending
-- declare/use property


## Limitations

### Don't support property access

mruby-cocoa don't support `@property` access.

[Objective-C Runtime](https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html) has propert access. Objective-C Runtime can't access properties that's defined in Category Class.

I found [similar problem](http://stackoverflow.com/questions/9639250/how-to-dynamically-determine-objective-c-property-type) in stackoverflow.

I can make Class properties list by static analytics using clang. It's same way with [BridgeSupport](http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man5/BridgeSupport.5.html). Can somebody help me?



## Todo

* test! test! test!
* rewrite memory management
* examples
* documents


## Contributing

Feel free to open tickets or send pull requests with improvements.
Thanks in advance for your help!


## Authors

Original Authors "MobiRuby developers" are [https://github.com/mobiruby/mobiruby-ios/tree/master/AUTHORS](https://github.com/mobiruby/mobiruby-ios/tree/master/AUTHORS)


## License

See Copyright Notice in [cocoa.h](https://github.com/mobiruby/mruby-cocoa/blob/master/include/cocoa.h).

