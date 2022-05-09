"opens groff me file in zathura

let s:tempName = tempname()
if ! exists('g:groffviewer')
    let g:groffviewer = 'xdg-open'
endif


function! SaveTempPS()
	let fullPath = expand("%:p")
	" TODO: I need to setdpaper in a variable
	execute "silent !groff -me -dpaper=a4 '" . fullPath . "' > '" . s:tempName . "' &"
endfunction

function! ZathuraOpenPS()
	echo "silent !" . g:groffviewer . " " . s:tempName . " &"
	call SaveTempPS()
	execute "silent !" . g:groffviewer . " " . s:tempName . " &"
endfunction

function! PrintPS()
	let fullPath = expand("%:p")
	execute "silent !groff -me '" . fullPath . "' | lp"
endfunction

nnoremap <Leader>o :call ZathuraOpenPS()<CR>
nnoremap <Leader>p :call PrintPS()<CR>

" TODO Can I limit to just groff files?
autocmd BufWritePost * call SaveTempPS()
