# vim-groff-viewer

## Introduction

A very beta version of a vim plugin for displaying [Groff](https://www.gnu.org/software/groff/) files in a document viewer as determined by the system default or chosen by the user.  The document viewer used should auto-update[^1] and preferably support the postscript file format - examples are [Zathura](https://pwmt.org/projects/zathura/), [Evince](https://help.gnome.org/users/evince/stable/), [Okular](https://okular.kde.org/) or [Xreader](https://github.com/linuxmint/xreader/).

[^1]: A document viewer that auto-updates is one that refreshes the view when the underlying document changes.

## Installation

Install using your preferred package manager, or manually install:

### Neovim

```bash
mkdir -p ~/.local/share/nvim/site/pack/preciouschicken/start/groff-viewer
git clone https://github.com/PreciousChicken/vim-groff-viewer.git ~/.local/share/nvim/site/pack/preciouschicken/start/groff-viewer
```

### Vim

```bash
mkdir -p ~/.vim/pack/preciouschicken/start/groff-viewer
git clone https://github.com/PreciousChicken/vim-groff-viewer.git ~/.vim/pack/preciouschicken/start/groff-viewer
```

## Usage

With a groff file open in the current buffer select:

- `<leader>o` - Open groff file in selected document viewer
- `<leader>p` -  Hard copy print groff file

Saving the file in the normal way, e.g. `:w`, will result in the groff preview updating in the document viewer, providing the selected viewer auto-updates[^1].

The groff macro used by the plugin is determined by the file extension, for example the file _myfile.me_ will be processed using the _me_ macro package.  For further information on groff file extensions see [man 5 groff_filenames](https://manpages.ubuntu.com/manpages/bionic/en/man7/groff_filenames.7.html).

## Configuration

### Setting postscript viewer

The system default for opening postscript files according to [xdg-open](https://portland.freedesktop.org/doc/xdg-open.html) will be used as the default document viewer.  The default xdg-open postscript application can be [changed to Zathura](https://wiki.archlinux.org/title/zathura#Make_zathura_the_default_pdf_viewer) by the following terminal command:

```bash
xdg-mime default org.pwmt.zathura.desktop application/postscript
```

Alternatively if you do not wish to make a system wide change, then the plugin will ignore the xdg-open default if the following line is adding to the _.vimrc_ / _init.vim_, with the variable as the postscript viewer:

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

Using a document viewer that supports pdf but not postscript is possible by amending the groff options in your _vim.rc_ / _init.vim_ for pdf output.  For example should you want to use [ePDFView](http://freshmeat.sourceforge.net/projects/epdfview) as a document viewer:

```vimrc
let groffviewer_default="epdfview"
let groffviewer_options="-T pdf"
```

A pdf document viewer that auto-reloads[^1] should however still be chosen otherwise the document will fail to update on write (ePDFView would be a bad choice in this regard).

### Setting the printer

The `<leader>p` mapping uses the [lp](https://man7.org/linux/man-pages/man1/lp.1.html) command to hard copy print; this assumes a [default printer has been set](https://www.mattcutts.com/blog/change-default-printer-linux-firefox/).

## Documentation 

TODO

## Known issues

The pdf-only document viewers [mupdf](https://mupdf.com/) and [apvlp](https://github.com/naihe2010/apvlv) do not work with the `-T pdf` option listed above.

## Contributing

Contributions welcome: issues, pull requests, etc.

## Credits

TODO



