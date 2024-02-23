# zebang

File based script runner powered by shebangs

## How does it work?

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

## Name and pronounciation

The name is a modification of shebang, but imagine this being pronounced by a German.

## License

GNU General Public License v3

![](https://www.gnu.org/graphics/gplv3-127x51.png)
