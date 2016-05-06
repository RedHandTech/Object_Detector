Object_Detector (Machine learning based object detector)
===============

## About

- This is a machine learnng based object detector.
- It uses [dlib](http://dlib.net).
- The project is built to demo face, hand, and logo detection.
- This is a cocoapods project so open the project root in your terminal and run `pod install`. Once the command has finished open the *Object Detector.xcworkspace* file.
- To run this project add the *dependencies* (see below) and compile *dlib* (see below).

## Dependencies

- DLIB can be downloaded from [here](http://dlib.net). The current version is 18.18.
- This project requires that the iOS-Release version of dlib be installed into */usr/local/lib/DLIB/iOS*. (see below for compile instructions)
- This project also requires that *libjpeg* be installed. *libjpeg* can be downloaded via **homebrew**.
- This project also requires that *Open CV* be installed. *Open CV* can be downloaded via **homebrew**.

## DLIB Compile Instructions

- This requires that *cmake* be installed. *cmake* can be downloaded via **homebrew**.
- This requires that Xcode be downloaded.

To compile DLIB put the unzipped DLIB folder (dlib-xx.xx) into your desktop. 

In the *cmake* file in *dlib-xx.xx/dlib* set *USE_SSE2_INSTRUCTIONS*, *USE_SSE4_INSTRUCTIONS* and *USE_AVX_INSTRUCTIONS*, to **ON**.

Then run:

`cd ~/Desktop/dlib-xx.xx/examples`

`mkdir build`

`cd build/`

`cmake -G Xcode ..`


In *dlib-xx.xx/examples/build* there will now be a folder named *dlib_build*. In that folder is an Xcode prokect named *dlib.xcodeproj*. Open that project.

Select **product->scheme->edit scheme** and in the *run* section for each target set the *build configuration* to *Release*.

In the build settings, change the *Base SDK* for each target to *Latest OS X*. Build the project.

Next change the *Base SDK* to *Latest iOS*. Build the project.

There will now be two folders in *dlib_build* called *Release* and *Release-iphoneos*. You can copy those libraries into */usr/local/lib* **(see above)**.

The contents of *dlib-xx.xx/dlib* needs to be copied to */usr/local/include/DLIB*

## Xcode Project Build Instructions

### This is for setting up new projects to use DLIB

In the **Build Settings** for the project the following changes need to be made:

- Under **Build Options**, set *Enable Bitcode* to **NO**
- Under **Linking** add the following flags under *Other Linker Flags*:
```
/usr/lib/libpthread.dylib
/usr/lib/liblapack.dylib
/usr/local/lib/libjpeg.dylib
/usr/local/lib/libpng.dylib
-Wl,-search_paths_first
/usr/lib/libsqlite3.dylib
/usr/lib/libcblas.dylib
/usr/local/lib/DLIB/iOS/libdlib.a
-Wl,-headerpad_max_install_names
```
- Under **Search Paths**, add the following paths to *Header Search Paths*:
```
/usr/local/include
/usr/local/include/DLIB/..
/usr/local/include/opencv
```
Also set *User Header Maps* to **NO**
- Under **Apple LLVM 7.0 - Code Generation**, set *Generate Debug Symbols* to **NO**. Also set *Optimization Level* for Release to **Fastest [-03]**
- Under ** Apple LLVM 7.0 - Custom Compiler Flags** add the following flags to *Other C++ Flags* for Debug:
```
-DDLIB_PNG_SUPPORT
-DDLIB_JPEG_SUPPORT
-DDLIB_USE_BLAS
-DDLIB_USE_LAPACK
-DENABLE_ASSERTS
```
and for Release:
```
-DDLIB_PNG_SUPPORT
-DDLIB_JPEG_SUPPORT
-DDLIB_USE_BLAS
-DDLIB_USE_LAPACK
-DNDEBUG
```
also add the following under *Other Warning Flags*:
```
-Wmost
-Wno-four-char-constants
-Wno-unknown-pragmas
$(inherited)
```
- Under **Apple LLVM 7.0 - Language - C++** set *C++ Language Dialect* and *C++ Standard Library* to **Compiler Default**
- Under **Apple LLVM 7.0 - Preprocessing** set *Enable Foundation Assertions* to **YES**. Also set *Enable Strict Checking of objc_msgSend Calls* to **NO**
Also add the following flag under *Preprocessor Macros*: `'CMAKE_INTDIR="$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)"'`
- Ensure that all code files in the project are either `C++` (.cpp) (.h) (.hpp) or `Objctive-C++` (.mm) (.h) or `C` (.c) (.h)
- Set the product scheme under build configuration to *Release* (see above)
- Finnally add a copy of *libdlib.a* to the project (drag and drop). And build!

## Other Notes

- This Folder also includes binaries, *imgtrain* and *imglab*. *imgtrain* is a command line app for creating new object detectors. *imglab* is a command line app for preparing images for *imgtrain*. See the **README** for each binary.
