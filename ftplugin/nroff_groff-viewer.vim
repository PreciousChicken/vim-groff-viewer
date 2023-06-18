" vim-groff-viewer: Displays groff files in document viewer
" Last Change:	2023 Jun 18
" Maintainer:	gene@preciouschicken.com
" License:	Apache-2.0
" URL: https://preciouschicken.com/software/vim-groff-viewer/

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

" Runs groff and returns array seperated by new lines
function! s:ExecuteGroff(options)
	let fullPath = expand('%:p')
	" reads macro package (e.g. ms, mom) from file extension
	let macro = expand('%:e')
	let l:groff_out = system("groff -m " . macro . " " . a:options . " '" . fullPath . "'")
	return split(l:groff_out, '\n')
endfunction

" Saves output of groff as temporary file
function! s:SaveTempPS()
	let l:groff_out_clean = s:ExecuteGroff(g:groffviewer_options)
	call writefile(l:groff_out_clean, b:tempName)
endfunction

" Opens viewer loads temporary file
function! OpenViewer()
	call s:SaveTempPS()
	execute "silent !" . g:groffviewer_default . " " . b:tempName . " &"
	redraw
	echom "Opening " . expand('%:t') . " with " . g:groffviewer_default . " viewer."
endfunction

" Calls function that saves groff as temporary file, prints that temporary file
function! PrintPS()
	call s:SaveTempPS()
	execute "silent !lp " . b:tempName
	redraw
	echom "Printing " . expand('%:t') . "."
endfunction

" Runs groff with intermediate output option, does not save temp file
" Returns word and character count
function! CountWords()
	let macro = expand('%:e')
		if macro == "mom"
			return "Word count not supported for mom macro, see help GroffViewerUsage"
		endif
	let l:groff_out_clean = s:ExecuteGroff("-Z -T utf8")
	let l:char_count = 0
	let l:word_count = 0
	for line in l:groff_out_clean
		if line =~ '^t'
			let l:char_count = l:char_count + strchars(line) - 1
			let l:word_count += 1
		endif
	endfor
	return "Words: " . l:word_count . ", Characters: " . l:char_count
endfunction

nnoremap <localleader>o :call OpenViewer()<CR>
nnoremap <localleader>p :call PrintPS()<CR>
nnoremap <localleader>wc :echom CountWords()<CR>

" Runs SaveTempPS on user :w command
augroup savetemp
	autocmd!
	autocmd BufWritePost <buffer> call s:SaveTempPS()
augroup end

