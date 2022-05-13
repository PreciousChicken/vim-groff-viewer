# vim-groff-viewer

## Introduction

A very beta version of a vim plugin for displaying [Groff](https://www.gnu.org/software/groff/) files in the Zathura, or similar, document viewer.  Not yet for public use.

## Installation

TODO

## Usage

With a groff file open in the current buffer select:

- `<leader>o` - Open groff file in selected document viewer
- `<leader>p` -  Hard copy print groff file

The groff macro used by the plugin is determined by the file extension, for example the file ***myfile.me*** will be processed using the ***me*** macro package.  For further information on groff file extensions see [man 5 groff_filenames](https://manpages.ubuntu.com/manpages/bionic/en/man7/groff_filenames.7.html).

## Configuration

### Setting postscript viewer

This plugin was written with Zathura being the intended postscript viewer.  However the plugin will not default to Zathura but will use the system default for opening postscript files according to [xdg-open](https://portland.freedesktop.org/doc/xdg-open.html).  The default xdg-open postscript application can be [changed to Zathura](https://wiki.archlinux.org/title/zathura#Make_zathura_the_default_pdf_viewer) by the following terminal command:

```bash
xdg-mime default org.pwmt.zathura.desktop application/postscript
```

Alternatively if you do not wish to make a system wide change, then the plugin will ignore the xdg-open default if the following line is adding to the **.vimrc**, with the variable as the postscript viewer:

```vimrc
let groffviewer="zathura"
```
or, for instance:

```vimrc
let groffviewer="okular"
```

### Setting groff options

The command line options available to groff can be added via your ***vim.rc***  e.g.:

```vimrc
let groffviewer_options="-dpaper=a4"
```

## Contributing

TODO

## Credits

TODO



