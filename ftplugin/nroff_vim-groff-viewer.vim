"opens groff files in user selected viewer
	
" Disabling option per :help write-filetype-plugin
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

let b:tempName = tempname()

" If user has not specified groff viewer (e.g. Zathura) then uses system
" default
if ! exists('g:groffviewer_default')
    let g:groffviewer_default = 'xdg-open'
endif

" If user has not specified groff options then provides none
if ! exists('g:groffviewer_options')
    let g:groffviewer_options = ' '
endif

function! s:SaveTempPS()
	let fullPath = expand("%:p")
	" reads macro package (e.g. ms, mom) from file extension
	let macro = expand('%:e')
	execute "silent !groff -m " . macro . " " . g:groffviewer_options . " " . fullPath . " > " . b:tempName . " &"
endfunction

function! OpenViewer()
	echo "silent !" . g:groffviewer_default . " " . b:tempName . " &"
	call s:SaveTempPS()
	execute "silent !" . g:groffviewer_default . " " . b:tempName . " &"
endfunction

function! PrintPS()
	let fullPath = expand("%:p")
	execute "silent !groff -me '" . fullPath . "' | lp"
endfunction

nnoremap <Leader>o :call OpenViewer()<CR>
nnoremap <Leader>p :call PrintPS()<CR>

" TODO Can I limit to just groff files?
autocmd BufWritePost * call s:SaveTempPS()
