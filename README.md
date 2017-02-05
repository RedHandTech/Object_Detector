>### WIP

### TODO

* Fix leaks. Look for TODOs in `ObjectDetector.mm`

Object_Detector (Machine learning based object detector)
===============

## About

- This is a machine learnng based object detector.
- It uses [dlib](http://dlib.net).
- To run this project add the *dependencies* (see below) and compile *dlib* (see below).

## Dependencies

- DLIB can be downloaded from [here](http://dlib.net). This was written with DLIB version `19.2`.
- This project requires that the iOS-Release version of dlib be installed into */usr/local/lib/DLIB/iOS*. (see below for compile instructions)
- This project also requires that *libjpeg* be installed. *libjpeg* can be downloaded via **homebrew**.

## DLIB Compile Instructions

- This requires that *cmake* be installed. *cmake* can be downloaded via **homebrew**.
- This requires that Xcode be downloaded.

To compile DLIB put the unzipped DLIB folder (dlib-xx.xx) into your desktop. 

In the *cmake* file (`CMakeLists.txt`) in *dlib-xx.xx/dlib* comment out the line  `set (DLIB_USE_CUDA_STR 
"Disable this if you don't want to use NVIDIA CUDA" )` (cmake uses the `#` symbol to comment out lines).

>NOTE: Cuda is the GPU library that dlib uses, this is currently not supported by iOS devices as it is `NVIDIA`. If you are using dlib on Mac OS and you have a `NVIDIA` GPU then you should leave this line uncommented.

Then run:

`cd ~/Desktop/dlib-xx.xx/examples`

`mkdir build`

`cd build/`

`cmake -G Xcode ..`


In *dlib-xx.xx/examples/build* there will now be a folder named *dlib_build*. In that folder is an Xcode prokect named *dlib.xcodeproj*. Open that project.

Select **product->scheme->edit scheme** and in the *run* section for each target set the *build configuration* to *Release*.

You will need to build the project for the architecure that you are targeting. In the build settings change the *Base SDK* for the desired target.

>NOTE: If you build the project for `Generic iOS device` it will work on any iOS device but **NOT** the simulator and vice versa.

The products will appear in folders called e.g. *Release* or *Release-iphoneos* **(see above for where to put the libraries you just built)**

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

- Under **Apple LLVM X.X - Language - C++** set *C++ Language Dialect* to **C++11[-std=c++11]** and set *C++ Standard Libary* to **Compiler Default**.
- Under **Apple LLVM X.X - Preprocessing** set *Enable Foundation Assertions* to **YES**. Also set *Enable Strict Checking of objc_msgSend Calls* to **NO**
Also add the following flag under *Preprocessor Macros*: `'CMAKE_INTDIR="$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)"'`
- Ensure that all code files in the project are either `C++` (.cpp) (.h) (.hpp) or `Objctive-C++` (.mm) (.h) or `C` (.c) (.h)
- Set the product scheme under build configuration to *Release* (see above)
- Finnally add a copy of *libdlib.a* to the project (drag and drop). And build!

>NOTE: With Xcode 8 there have been issues with `library not found for -dlib` build errors. To fix this: in the **Library Search Paths** remove any reference to the project directory and instead add a reference to */usr/local/lib* where you should have a copy of the dlib library you built earlier.

## Other Notes

- This Folder also includes binaries, *imgtrain* and *imglab*. *imgtrain* is a command line app for creating new object detectors. *imglab* is a command line app for preparing images for *imgtrain*. See the **README** for each binary.
