# vim-groff-viewer

## Introduction

A very beta version of a vim plugin for displaying [Groff](https://www.gnu.org/software/groff/) files in a document viewer.  The document viewer used is determined by the system default or chosen by the user, but should auto-update[^1] and preferably support the postscript file format - examples are [Zathura](https://pwmt.org/projects/zathura/), [Evince](https://help.gnome.org/users/evince/stable/) and [Okular](https://okular.kde.org/).

[^1]: A document viewer that auto-updates is one that refreshes the view when the underlying document changes.

## Installation

Install using your preferred package manager, or manually install:

### Neovim

```bash
mkdir -p ~/.local/share/nvim/site/pack/preciouschicken/start/groff-viewer
git clone https://github.com/PreciousChicken/vim-groff-viewer.git ~/.local/share/nvim/site/pack/preciouschicken/start/groff-viewer
nvim -u NONE -c "helptags groff-viewer/doc" -c q
```

### Vim

```bash
mkdir -p ~/.vim/pack/preciouschicken/start/groff-viewer
git clone https://github.com/PreciousChicken/vim-groff-viewer.git ~/.vim/pack/preciouschicken/start/groff-viewer
vim -u NONE -c "helptags groff-viewer/doc" -c q
```

## Usage

With a groff file open in the current buffer select:

- `<leader>o` - Open groff file in selected document viewer
- `<leader>p` -  Hard copy print groff file

The groff macro used by the plugin is determined by the file extension, for example the file _myfile.me_ will be processed using the _me_ macro package.  For further information on groff file extensions see [man 5 groff_filenames](https://manpages.ubuntu.com/manpages/bionic/en/man7/groff_filenames.7.html).

## Configuration

### Setting postscript viewer

This plugin was written with Zathura being the intended postscript viewer.  However the plugin will not default to Zathura but will use the system default for opening postscript files according to [xdg-open](https://portland.freedesktop.org/doc/xdg-open.html).  The default xdg-open postscript application can be [changed to Zathura](https://wiki.archlinux.org/title/zathura#Make_zathura_the_default_pdf_viewer) by the following terminal command:

```bash
xdg-mime default org.pwmt.zathura.desktop application/postscript
```

Alternatively if you do not wish to make a system wide change, then the plugin will ignore the xdg-open default if the following line is adding to the **.vimrc**, with the variable as the postscript viewer:

```vimrc
let groffviewer_default="zathura"
```
or, for instance:

```vimrc
let groffviewer_default="okular"
```

### Setting groff options

The command line options available to groff can be added via your _vim.rc_ / _init.vim_ e.g.:

```vimrc
let groffviewer_options="-dpaper=a4"
```

### Using a pdf-only document viewer

Using a document viewer that supports pdf but not postscript is possible by changing using the groff options in your _vim.rc_ / _init.vim_, using [ePDFView](http://freshmeat.sourceforge.net/projects/epdfview) for this example:

```vimrc
let groffviewer_default="epdfview"
let groffviewer_options="-T pdf"
```

## Known issues

The pdf-only document viewers [mupdf](https://mupdf.com/) and [apvlp](https://github.com/naihe2010/apvlv) do not work with the `-T pdf` option listed above.

## Contributing

TODO

## Credits

TODO



