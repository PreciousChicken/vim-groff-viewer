" vim-groff-viewer: Displays groff files in document viewer
" Last Change:	2026 Nov 1
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

" External programs are run with argument lists, never through 'shell', so
" the plugin works whatever shell is set (e.g. nushell).

" Returns [command list, error message]
function! s:GroffCmd(options)
  let l:file = expand('%:p')
  if g:groffviewer_grog isnot v:true
    return [['groff'] + split(a:options) + [l:file], '']
  endif
  " grog 1.24 removed --run: it only prints 'groff <flags> <file>', and
  " does not quote the file name
  let l:out = systemlist(['grog'] + split(a:options) + [l:file])
  if v:shell_error || empty(l:out)
    return [[], "Error: grog failed to process " . expand('%:t')]
  endif
  let l:head = strpart(l:out[0], 0, len(l:out[0]) - len(l:file))
  if strpart(l:out[0], len(l:head)) !=# l:file
    return [[], "Error: Unable to parse grog output: " . l:out[0]]
  endif
  return [split(l:head) + [l:file], '']
endfunction

" Runs command, writes its stdout to file. Returns '' or an error message
function! s:RunToFile(cmd, file)
  if has('nvim-0.10')
    " Raw bytes, so binary output (e.g. -T pdf) is intact
    return luaeval('(function(cmd, out)
          \ local r = vim.system(cmd, {}):wait()
          \ if r.code ~= 0 then return "groff failed" end
          \ local f, e = io.open(out, "wb")
          \ if not f then return e end
          \ f:write(r.stdout)
          \ f:close()
          \ return ""
          \ end)(_A[1], _A[2])', [a:cmd, a:file])
  elseif has('nvim')
    " Older neovim, text output only
    let l:lines = systemlist(a:cmd)
    if v:shell_error
      return 'groff failed'
    endif
    call writefile(l:lines, a:file)
    return ''
  endif
  let l:job = job_start(a:cmd, {'out_io': 'file', 'out_name': a:file,
        \ 'in_io': 'null', 'err_io': 'null'})
  while job_status(l:job) ==# 'run'
    sleep 10m
  endwhile
  if job_status(l:job) ==# 'fail' || job_info(l:job).exitval != 0
    return 'groff failed'
  endif
  return ''
endfunction

" Starts program in the background, returns v:true if it started
function! s:Spawn(cmd)
  if has('nvim')
    return jobstart(a:cmd) > 0
  endif
  let l:job = job_start(a:cmd, {'stoponexit': '', 'in_io': 'null',
        \ 'out_io': 'null', 'err_io': 'null'})
  return job_status(l:job) !=# 'fail'
endfunction

" Saves output of groff as temporary file
function! s:SaveTempPS(options)
  let [l:cmd, l:msg] = s:GroffCmd(a:options)
  if l:msg != ''
    return l:msg
  endif
  if s:RunToFile(l:cmd, b:tempName) != ''
    return "Error: Groff failed to process " . expand('%:t')
  endif
  return "Ran: " . join(l:cmd)
endfunction

" Opens viewer loads temporary file
function! OpenViewer(options, viewer)
  let l:msg = s:SaveTempPS(a:options)
  echom l:msg
  if l:msg =~# '^Error'
    return
  endif
  let l:ok = s:Spawn(split(a:viewer) + [b:tempName])
  redraw
  if l:ok
    echom "Opening " . expand('%:t') . " with " . a:viewer . " viewer."
  else
    echom "Error: Unable to open " . a:viewer
  endif
endfunction

" Calls function that saves groff as temporary file, prints that temporary file
function! PrintPS(options)
  let l:msg = s:SaveTempPS(a:options)
  if l:msg =~# '^Error'
    echom l:msg
    return
  endif
  call s:Spawn(['lp', b:tempName])
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
  return systemlist(['groff'] + split(a:options) + [expand('%:p')])
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

