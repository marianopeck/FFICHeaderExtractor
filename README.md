# FFICHeaderExtractor
In short, FFICHeaderExtractor is a program to extract information (e.g. constants) from `C` headers and integrate that into Smalltalk `SharedPools`. 

When we use FFI to call a certain library, it's quite common that we need to pass specific constants (for example, `SIGKILL` to `kill()`). These constants are defined in `C` header files and can even change their values in different paltforms. Sometimes, these constants also are defined by the `C` preprocessor and so there is not way to get those values from FFI. If you don't have the value of those constants, you cannot make the FFI call. In other words, if I cannot know that the value of `SIGKILL` is `9`, how do I call `kill()` from FFI?

This tool allows the developers of a FFI tool (any project which uses FFI to call a certain library), to automatically create a `C` program that writes all the user-defined constants values, compile it, run it, and create a Smalltalk init method which initializes the shared pool constants based on `C` program output. This autogenerated init method can then be distributed with the rest of the FFI tool. FFICHeaderExtractor will also automatically initialize (searching and executing the previously autogenerated init method for the current platform) a `SharedPool` upon system startup.

##Table of Contents

  * [FFICHeaderExtractor](#fficheaderextractor)
    * [Table of Contents](#table-of-contents)
    * [Installation](#installation)
    * [Getting Started](#getting-started)
      * [Defining and using a SharedPool with FFI](#defining-and-using-a-sharedpool-with-ffi)
      * [Extracting and storing constants information](#extracting-and-storing-constants-information)
      * [Initializing variables from autogenerated method](#initializing-variables-from-autogenerated-method)
      * [Deploying the FFI tool with autogenerated methods](#deploying-the-ffi-tool-with-autogenerated-methods)
    * [Contributing](#contributing)
    * [History](#history)
    * [Authors](#authors)
    * [License](#license)
    * [Acknowledgments](#acknowledgments)
    * [Funding](#funding)




## Installation
**FFICHeaderExtractor currently only works in Pharo 5.0 with Spur VM**. Until Pharo 5.0 is released, we recommend to always grab a latest image and VM. You can do that in via command line:

```bash
wget -O- get.pharo.org/alpha+vm | bash
```

Then, from within Pharo, execute the following to install FFICHeaderExtractor:

```Smalltalk
Metacello new
    baseline: 'FFICHeaderExtractor';
    repository: 'github://marianopeck/FFICHeaderExtractor:master/repository';
    load.
```

> Important: so far FFICHeaderExtractor works only in OSX and Unix. 

## Getting Started
The user of this tool will be a developer of a FFI-based project. As an example, let's say we want to call some functions from the `libc` (the standard C library) via FFI. `libc` is huge and it has lots of functions and constants. For our example we will take only a small portion of it. 

### Defining and using a SharedPool with FFI

The first step is to define your own subclass of `FFISharedPool` and define all the constants you want to retrieve their values, as class variables:

```Smalltalk
FFISharedPool subclass: #LibCSharedPool
	instanceVariableNames: ''
	classVariableNames: 'EINVAL EPERM SIGCHLD SIGCONT SIGINFO SIGKILL SIGPOLL SIGSTOP SIGTERM'
	package: 'LibC'
```

In this example, we pick up only some signals and some errors. Let's now see the user of this `SharedPool`:

```Smalltalk
Object subclass: #LibCWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'LibCSharedPool'
	package: 'LibC'
```

The imporant line there is `poolDictionaries: 'LibCSharedPool'` were we declare that we want to use `LibCSharedPool`. The `LibCWrapper` is then able to do this:

```Smalltalk
LibCWrapper >> stopProcess: aPidNumber
	self primitiveKill: aPidNumber signal: SIGSTOP.
```

```Smalltalk
LibCWrapper >> continueProcess: aPidNumber
	self primitiveKill: aPidNumber signal: SIGCONT.
```

`SIGSTOP` and `SIGCONT` are signals which, via `kill()`, can pause a process with it's current state and  then resume it's execution later. The details of `primitiveKill:signal:` is not important for this example as it is the simple FFI call to `int kill(pid_t pid, int sig)`.

The important part here is that thanks to `SharedPools`, the `LibCSharedPool` code can access directly to `SIGSTOP` and `SIGCONT` as if they were class variables. However, these are the class variables defined in `LibCWrapper`. For above code to really work, the class variables of `LibCSharedPool` must be initialized with the correct values. If we were using `SIGKILL` or `SIGTERM` for example, it's very likely that the values of them are `9` and `15` in almost every possible platform. But that's not the case of `SIGSTOP` and `SIGCONT`. Do you know their values? Are you sure they do not change among platforms? As we will read later, these constants **do change** between platforms. 

This problematic is part of what FFICHeaderExtractor solves. Let's see how. 

### Extracting and storing constants information
Once you have defined your own `FFISharedPool` subclass and the constants for which you would like to get the values, the next step is to give more information to FFICHeaderExtractor so that it can extract the definitions from `C`. 

The created `FFISharedPool` subclass, must implement the class side method `#headersContainingVariables` which answers an array with the `C` header names that define all the defined constants. In the example of `LibCSharedPool` we have singal constants (defined in `signal.h`) and error constants (defined in `errno.h`). Therefore:

```Smalltalk 
LibCSharedPool class >> headersContainingVariables
	^ #( 'errno.h' 'signal.h' ) 
```

<!-- TO-DO: put sec ref --> 
> For many cases, this is all the needed information. We will later see cases where more definitions are needed.

The last step for the developer of the FFI tool (`LibCWrapper` in our example) is to trigger the extraction itself. The way of doing this is:

```Smalltalk
LibCSharedPool extractAndStoreHeadersInformation
```

<!-- TO-DO: put sec ref --> 
As explained later, to be able to run `#extractAndStoreHeadersInformation` the user must have installed and reached by `$PATH`, `cc` (LLVM Clang) in OSX and `gcc` in Unix. 

The method `#extractAndStoreHeadersInformation` first extracts all the constants values (defined in C header files) **from the current running platform** and then creates a Smalltalk init method which is then compiled into the SharedPool. So, for example, if I execute such a method in OSX with a Pharo 32 bits VM, then the resulting autogenerated method is this:

```Smalltalk
LibCSharedPool class >> initVariablesMacOS32
"Method automatically generated by FFICHeaderExtractor. Read more at https://github.com/marianopeck/FFICHeaderExtractor"
	<platformName: 'Mac OS' wordSize: 4>
	EINVAL := 22.
	EPERM := 1.
	SIGCHLD := 20.
	SIGCONT := 19.
	SIGINFO := 29.
	SIGKILL := 9.
	SIGPOLL := nil."SIGPOLL is UNDEFINED for this platform"
	SIGSTOP := 17.
	SIGTERM := 15.
```

Note that the selector of the autogenerated method is `#initVariablesMacOS32` which matches the platform used to run `#extractAndStoreHeadersInformation`. If later we have Pharo 64 bits VM, then we should also run `#extractAndStoreHeadersInformation` with such a VM. 

The information embebed as part of the selector is just for organization. When FFICHeaderExtractor needs to search the correct method for the current platform, it uses the `platformName` and `wordSize` of the pragma of the autogenerated method. 

The developer of the FFI tool is responsible of running `#extractAndStoreHeadersInformation` for every platform he needs. Ideally, the developer could have a CI (continuous integration) server that automatically runs this for every platform. 


### Initializing variables from autogenerated method
Upon Pharo startup, `FFISharedPool` analyses each subclass to see which ones require the initialization of the class variables. When the initialization of class variables does happen, then the used `platformName` and `wordSize` are stored in the SharedPool. This way, next system startup we can check if the platform has changed compared to what we have stored (like running the image in another OS). If the platform has changed or if the class variables were never initialized before, then `FFISharedPool` will try to do the initialization by sending the message `#initializeVariables`.

`#initializeVariables` simply searches an autogenerated method whose `platformName` and `wordSize` matches the running platform. If the method is found, then it is executed and platform information is stored. If not found, then it simply prints an error into the `Transcript` saying an init methd could not be found for the desired paltform.

For when we are *developing* the FFI tool, we don't want to quit Pharo and start again every time want to initialize variables again. For this cases, you can simply force the autogeneration and initialization this way:

```Smalltalk
LibCSharedPool 
	extractAndStoreHeadersInformation;
	initializeVariables.
```

You can now check the values of the class variables to confirm they were correctly initialized.

Sometimes you want the end user of the FFI tool to be able to use it just after loading it, without any Pharo quit and start, and without having to manually execute the initialization. For this, our recommended approach is to simply create this method for each `FFISharedPool` subclass:

```Smalltalk
LibCSharedPool class >> initialize
	self initializeVariables
```
 
That way, when the package is being loaded, Pharo will automatically send the class side `#initialize` to `LibCSharedPool` and such a method will initialize the class variables with the autogenerated methods.  

>To conclude: end users of the FFI tool have nothing to do as starting Pharo will automatically initialize the class variables of the shared pools.

### Deploying the FFI tool with autogenerated methods
The developers of the FFI tool should extract constants and autogenerate the init method (send `#extractAndStoreHeadersInformation`) for every platform they wish to support. The result will be the autogenerated methods like `#initVariablesMacOS32`, `#initVariablesMacOS64`, `#initVariablesunix32`, `#initVariablesunix64`, etc. All these methods are organized in a protocol called `autogenerated by FFICHeaderExtractor` of the particular SharedPool (`LibCSharedPool` in our example). 

As we also said, to be able to run `#extractAndStoreHeadersInformation`, the developer needs C compiler installed.

Once the autogenerated init methods are created, they should be versioned, distributed and deployed as any other method of the SharedPool class. 

**The end users of the FFI tool (not the developers) do not need a C compiler at all, nor to extract any constant. The end users do not even need to manually initialize the class variables of the SharedPool as that also happens automatically.**


## Contributing
This project is developed with [GitFileTree](https://github.com/dalehenrich/filetree), which, starting in Pharo 5.0, provides what is called `Metadata-less` FileTree. That basically means that there are certain FileTree files (`version` and `methodProperties`) which are not created. **Therefore, you cannot use regular FileTree to contribute to this project. You must use `GitFileTree`.**

The following are the steps to contribute to this project:

* Fork it using Github web interface!
* Clone it to your local machine: `git clone git@github.com:YOUR_NAME/FFICHeaderExtractor.git`
* Create your feature branch: `git checkout -b MY_NEW_FEATURE`
* Download latest Pharo 5.0 and load GitFileTree and this project:

```Smalltalk 
Metacello new
 	baseline: 'FileTree';
   	repository: 'github://dalehenrich/filetree:issue_171/repository';
   	load: 'Git'.	
Metacello new
	baseline: 'FFICHeaderExtractor';
 	repository: 'gitfiletree:///path/to/your/local/clone/FFICHeaderExtractor/repository';
	onConflict: [ :ex | ex allow ];
	load.
```

* You can now perform the changes you want at Pharo level and commit using the regular Monticello Browser.
* Run all FFICHeaderExtractor tests to make sure you did not break anything. 
* Push to the branch. Either from MC browser of with `git push origin MY_NEW_FEATURE`
* Submit a pull request from github web interface.

## History
You can see the whole changelog of the project [Changelog](CHANGELOG.md) for details about the release history. 


## Authors

* **Mariano Martinez Peck** - *Initial work* - [Mariano Martinez Peck](https://github.com/marianopeck)

See also the list of [contributors](https://github.com/marianopeck/FFICHeaderExtractor/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* FFICHeaderExtractor was an idea of Eliot Miranda which helped in many different ways to this project.  


## Funding
This project is sponsored by the [Pharo Consortium](http://consortium.pharo.org/).









