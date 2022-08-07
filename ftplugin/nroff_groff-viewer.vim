" vim-groff-viewer: Displays groff files in document viewer
" Last Change:	2022 Aug 7
" Maintainer:	gene@preciouschicken.com
" License:	Apache-2.0
" URL: https://github.com/PreciousChicken/vim-groff-viewer
	
" Disabling option per :help write-filetype-plugin
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" Creates temp file for buffer
let b:tempName = tempname()

" If user has not specified groff viewer (e.g. Zathura) then uses xdg-open
if ! exists('g:groffviewer_default')
    let g:groffviewer_default = 'xdg-open'
endif

" If user has not specified groff options then sets nil
if ! exists('g:groffviewer_options')
    let g:groffviewer_options = ' '
endif

" Runs groff to produce postscript temp file
function! s:SaveTempPS()
	let fullPath = expand("%:p")
	" reads macro package (e.g. ms, mom) from file extension
	let macro = expand('%:e')
	execute "silent !groff -m " . macro . " " . g:groffviewer_options . " " . fullPath . " > " . b:tempName
endfunction

" Opens viewer loads temp file
function! OpenViewer()
	call s:SaveTempPS()
	execute "silent !" . g:groffviewer_default . " " . b:tempName . " &"
	redraw
	echom "Opening " . expand('%:t') . " with " . g:groffviewer_default . " viewer."
endfunction

" Runs groff to produce ps on printer
function! PrintPS()
	let fullPath = expand("%:p")
	execute "silent !groff -me '" . fullPath . "' | lp"
	redraw
	echom "Printing " . expand('%:t') . "."
endfunction

nnoremap <Leader>o :call OpenViewer()<CR>
nnoremap <Leader>p :call PrintPS()<CR>

" Runs SaveTempPS on user :w command
augroup savetemp
	autocmd!
	autocmd BufWritePost * call s:SaveTempPS()
augroup end

