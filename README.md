music-notation-library
======================

# How to include the library in your own XCode project

1. Drag the MusicNotationLibrary.xcodeproj file from Finder into your application project to create the reference.

2. Select your application project to go to the project editor, then select your application target to go to the target editor. Select the build phases tab. Disclose the “Link Binary with Libraries” phase and click the plus button in that phase. Choose libMusicNotationLibrary.a and add it to the phase. Your application will now link against the library.

3. Select the Build Settings tab in your application target editor. Find the “Other Linker Flags” build setting. Add the flag -ObjC to this build setting’s value if it is not already present. This flag will tell the linker to link all Objective-C classes and categories from static libraries into your application, even if the linker can’t tell that they are used. This is needed because Objective-C is a dynamic language and the linker can’t always tell which classes and categories are used by your application code.


# Parsing an .nwc file

```
#import "MusicNotationLibrary/NWCParser.h"

NSString *nwcPath = @”…”;
NSError *err = nil;
MNLSong *song = [NWCParser parseNwcFile:nwcPath error:&err];
if (song == nil)
{
    // inspect err
    return;
}
```
