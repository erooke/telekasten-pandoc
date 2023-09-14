# Telekasten-pandoc

A crude collection of shell scripts which use [pandoc](https://pandoc.org) to generate
a static site of [telekasten](https://github.com/renerocksai/telekasten.nvim)
files. The only absolute dependency is [gnu
parallel](https://www.gnu.org/software/parallel/).

# How it works

`telekasten-pandoc` is a rather stupid script which mostly calls user defined
scripts to do its work.
 
`$XDG_CONFIG_HOME/finder` is expected to spit out every source file on `stdout`.

`$XDG_CONFIG_HOME/format` takes a source file as an argument and prints a
formatted file on `stdout`.

`$XDG_CONFIG_HOME/index` takes in a list of source files on `stdin` and produces
a formatted index file on `stdout`.

`$XDG_CONFIG_HOME/watch` after generating the initial site is done this script
is called to monitor the source directory for updates. If a file changes it is
expected that this script prints the changed (or created) file to `stdout`.

`$XDG_CONFIG_HOME/host` is the script which is responsible for hosting the website
locally. It is given the output directory of the script as input.

Finally, any files in `$XDG_CONFIG_HOME/static` are copied over to the output
directory. This allows CSS files (and probably others) to be included.

## Environment

Right now each of these scripts is given access to the location of the `format`
script because index needed access to it and I didn't want to figure out a
better way to do it.

# Bootstrap

My personal scripts are available in `scripts`, the css ([from
here](https://gist.github.com/killercup/5917178)) I use is in `static`, and
systemd unit file is available in `systemd`. The script `bootstrap` will
install them in the right places (prompting before installing anything). My
scripts require:
- watch: `inotify-wait`,
- format: `pandoc`
- host: [`host these things please`](https://github.com/thecoshman/http).
