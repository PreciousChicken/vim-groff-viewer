" vim-groff-viewer: Displays groff files in document viewer
" Last Change:	2024 Jun 1
" Maintainer:	gene@preciouschicken.com
" License:	Apache-2.0
" URL: https://preciouschicken.com/software/vim-groff-viewer/

" Disabling option per :help write-filetype-plugin
if exists("b:did_ftplugin_groff_viewer")
  finish
endif
let b:did_ftplugin_groff_viewer = 1

" Allows user to remove mappings
if !exists('g:groffviewer_no_mappings')
  let g:groffviewer_no_mappings = v:false
endif

" Creates temp file for buffer
let b:tempName = tempname()

" If user has not specified groff viewer (e.g. Zathura) then uses xdg-open
if ! exists('g:groffviewer_default')
  let g:groffviewer_default = 'xdg-open'
endif

" If user has not specified then defaults to using grog
if ! exists('g:groffviewer_grog')
  let g:groffviewer_grog = v:true
endif

" If user has not specified groff options then sets nil
if ! exists('g:groffviewer_options')
  let g:groffviewer_options = ' '
endif

" Saves output of groff as temporary file
function! s:SaveTempPS(options)
  let cmdRun = ' '
  let fullPath = shellescape(expand('%:p'))
  if g:groffviewer_grog is v:true
    let cmdRun = system("grog --run " .  a:options . " '" . fullPath . "' > " . b:tempName)
  else
    call system("groff " .  a:options . " '" . fullPath . "' > " . b:tempName)
    let cmdRun = "groff " .  a:options . " " . fullPath
  endif
  if v:shell_error
    return "Error: Groff failed to process " . expand('%:t')
  else
    return "Ran: " .. cmdRun
  endif
endfunction

" Opens viewer loads temporary file
function! OpenViewer(options, viewer)
  echom s:SaveTempPS(a:options)
  " Required by sioyek which requires different opening for vim vs nvim
  if has('nvim')
    call jobstart([a:viewer, b:tempName])
  else
    call system(a:viewer . " " .  b:tempName . " &")
  endif
  redraw
  if v:shell_error
    echom "Error: Unable to open " . a:viewer
  else
    echom "Opening " . expand('%:t') . " with " . a:viewer . " viewer."
  endif
endfunction

" Calls function that saves groff as temporary file, prints that temporary file
function! PrintPS(options)
  call s:SaveTempPS(a:options)
  execute "silent !lp " . b:tempName
  redraw
  echom "Printing " . expand('%:t') . "."
endfunction

" Returns word and character count, does not save temp file
" This works by running groff with intermediate output format
" See man 5 groff_out, each word printed on new line preceded by t
function! CountWords()
  let macro = expand('%:e')
  if macro == "mom"
    return "Word count not supported for mom macro, see help GroffViewerUsage"
  endif
  let l:groff_out_clean = s:IntermediateOutput("-m " . macro . " -Z -T utf8")
  let l:char_count = 0
  let l:word_count = 0
  for line in l:groff_out_clean
    " Selects lines beginning with t, these represent words
    if line =~ '^t'
      " Counts characters on line, minus 1 for the starting t
      let l:char_count = l:char_count + strchars(line) - 1
      " Counts words on each line
      let l:word_count += 1
    endif
  endfor
  if v:shell_error
    return "Error: Groff failed to run."
  else
    return "Words: " . l:word_count . ", Characters: " . l:char_count
  endif
endfunction

" Runs groff and returns array seperated by new lines, called by CountWords()
function! s:IntermediateOutput(options)
  let fullPath = shellescape(expand('%:p'))
  let l:groff_out = system("groff " . a:options . " '" . fullPath . "'")
  return split(l:groff_out, '\n')
endfunction

if (! exists("no_plugin_maps") || ! no_plugin_maps) &&
      \ (! exists("g:groffviewer_no_mappings") || 
      \ ! g:groffviewer_no_mappings) 
  nnoremap <localleader>o :call OpenViewer(g:groffviewer_options, g:groffviewer_default)<CR>
  nnoremap <localleader>p :call PrintPS(g:groffviewer_options)<CR>
  nnoremap <localleader>wc :echom CountWords()<CR>
endif

" Runs SaveTempPS on user :w command
augroup savetemp
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call s:SaveTempPS(g:groffviewer_options)
augroup end

