"opens groff me file in zathura

let s:tempName = tempname()

function! SaveTempPS()
	let fullPath = expand("%:p")
	" TODO: I need to setdpaper in a variable
	execute "silent !groff -me -dpaper=a4 '" . fullPath . "' > '" . s:tempName . "' &"
endfunction

function! ZathuraOpenPS()
	call SaveTempPS()
	" let fullPath = expand("%:p")
	" let fileName = expand("%:t")
	" execute "silent !groff -me '" . fullPath . "' > '" . s:tempName . "' | zathura '" . s:tempName . "' &"
	execute "silent !zathura '" . s:tempName . "' &"
endfunction

function! PrintPS()
	let fullPath = expand("%:p")
	execute "silent !groff -me '" . fullPath . "' | lp"
endfunction

nnoremap <Leader>s :call ZathuraOpenPS()<CR>
nnoremap <Leader>p :call PrintPS()<CR>

autocmd BufWritePost * call SaveTempPS()
