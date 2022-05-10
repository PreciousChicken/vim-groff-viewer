"opens groff files in user selected viewer

let s:tempName = tempname()

" If user has not specified groff viewer (e.g. Zathura) then uses system
" default
if ! exists('g:groffviewer_default')
    let g:groffviewer_default = 'xdg-open'
endif

" If user has not specified groff options then provides none
if ! exists('g:groffviewer_options')
    let g:groffviewer_options = ' '
endif

function! SaveTempPS()
	let fullPath = expand("%:p")
	" reads macro package (e.g. ms, mom) from file extension
	let macro = expand('%:e')
	execute "silent !groff -m " . macro . " " . g:groffviewer_options . " " . fullPath . " > " . s:tempName . " &"
endfunction

function! ZathuraOpenPS()
	echo "silent !" . g:groffviewer_default . " " . s:tempName . " &"
	call SaveTempPS()
	execute "silent !" . g:groffviewer_default . " " . s:tempName . " &"
endfunction

function! PrintPS()
	let fullPath = expand("%:p")
	execute "silent !groff -me '" . fullPath . "' | lp"
endfunction

nnoremap <Leader>o :call ZathuraOpenPS()<CR>
nnoremap <Leader>p :call PrintPS()<CR>

" TODO Can I limit to just groff files?
autocmd BufWritePost * call SaveTempPS()
