# swift-xdg

Implementation of the XDG Base Directory Specification in Swift.

This package has been largely inspired by [a Rust implementation](https://github.com/whitequark/rust-xdg/blob/main/src/lib.rs).

## Usage
```swift
let dirs = try BaseDirectories(prefixAll: "my-amazing-app")
/* Get existing configuration path. */
let confPath = try dirs.findConfigFile("conf.toml")
/* If all paths are needed, just add an “s”. */
let confPaths = try dirs.findConfigFiles("conf.toml")
/* Get path for writing new config.
 * The method makes sure the parent directory exists for the file 
 *  and return the path where the file should be. */
let newConfPath = try dirs.ensureParentsForConfigFilePath("conf.toml")
```

This particular implementation of the Base Directory Specification makes sure the paths returned never escape the homes in which they should be.

For instance if `XDG_CONFIG_HOME=/home/frizlab/.config`,
 we make sure none of the functions that return a config path in this package would return a path outside of this folder,
 whichever prefixes and file names are required.

A simple example: `let confPath = try dirs.findConfigFile("../conf.toml")` will throw.
