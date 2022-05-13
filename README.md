# vim-groff-viewer

A very beta version of a vim plugin for displaying Groff files in the Zathura document viewer.  Not yet for public use.

## Setting postscript viewer

This plugin was written with Zathura being the intended postscript viewer.  However the plugin will not default to Zathura but rather the system default for opening postscript files according to [xdg-open](https://portland.freedesktop.org/doc/xdg-open.html).  The default xdg-open postscript application can be [changed to Zathura](https://wiki.archlinux.org/title/zathura#Make_zathura_the_default_pdf_viewer) (or other) by the following terminal command:

```bash
xdg-mime default org.pwmt.zathura.desktop application/postscript
```

Alternatively if you do not wish to make a system wide change, then the plugin will ignore the xdg-open default if the following line is adding to the **.vimrc**, with the variable as the postscript viewer:

```vimrc
let g:groffviewer="zathura"
```
or, for instance:

```vimrc
let g:groffviewer="okular"
```

