# vim-groff-viewer

## Introduction

A very beta version of a vim plugin for displaying [Groff](https://www.gnu.org/software/groff/) files in a document viewer.  The choice of document viewer is left to the user but should auto-update and preferably support the postscript file format - examples are [Zathura](https://pwmt.org/projects/zathura/) and [Okular](https://okular.kde.org/).

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



