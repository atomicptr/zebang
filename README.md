# zebang

File based script runner powered by shebangs

## Installation

You currently have to download, compile and install (put it inside $HOME/.local/bin or something) yourself, I will change this down the line!

## Usage

zebang stores its scripts inside a directory named **.zebang** that should be in the root of your project.

Every script file represents a sub command and can be written in any programming language as long as you can
use shebang or executable flags (meaning binaries will work too).

Assuming the following directory structure:

```
.zebang/
    test.sh
    lint/
        eslint.js
        tsc.js
    format/
        prettier.js
```

You have the following commands available:

* zb test - runs test.sh
* zb lint - runs everything inside the lint directory (recursively)
* zb lint:eslint - runs lint/eslint.js
* zb lint:tsc - runs lint/tsc.js
* zb format - runs everything inside the format directory
* zb format:prettier - runs prettier.js

## Motivation

In JS projects you often define scripts inside the package.json files scripts key and then run them via: npm run SCRIPT
this is generally something I was always kinda fond off although I often ended up writing more complex scripts that are
stored inside a file so a general runner for an approach like this seemed sensible.

Also working with lots of other programming languages that do not have an unified way to execute scripts made me want to
write this tool.

## Name and pronounciation

The name is a variation of shebang. Imagine this being pronounced by a German.

## License

GNU General Public License v3

![](https://www.gnu.org/graphics/gplv3-127x51.png)
