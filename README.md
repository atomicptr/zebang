# zebang

File based script runner powered by shebangs

## Usage / How does it work?

zebang assumes you have a .zebang directory in your project root and then
looks for a filename matching the sub command you requested.

For instance running

```bash
$ zb test
```

will run .zebang/test.sh

while for instance

```bash
$ zb build
```

could run a script like: .zebang/build.py

You can also group several commands by putting them inside a directory

```bash
$ zb lint
```

could for instance run the scripts: .zebang/lint/eslint.js and .zebang/lint/prettier.js

If you however only want to use the lint > eslint script you can do so by setting a colon:

```bash
$ zb lint:eslint
```

## Name and pronounciation

The name is a variation of shebang. Imagine this being pronounced by a German.

## License

GNU General Public License v3

![](https://www.gnu.org/graphics/gplv3-127x51.png)
