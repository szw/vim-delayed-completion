" vim-delayed-completion - starts omni-completion after certain triggers in
" the insert mode.
" Maintainer:   Szymon Wrozynski
" Version:      0.0.1
"
" License:
" Copyright (c) 2012-2013 Szymon Wrozynski and Contributors.
" Distributed under the same terms as Vim itself.
" See :help license

if exists('g:loaded_vim_delayed_completion') || &cp || v:version < 700
  finish
endif
let g:loaded_vim_delayed_completion = 1

if !exists('g:dc_completion_triggers')
  let g:dc_completion_triggers =  {
    \   'c' : ['->', '.'],
    \   'objc' : ['->', '.'],
    \   'ocaml' : ['.', '#'],
    \   'cpp,objcpp' : ['->', '.', '::'],
    \   'perl' : ['->'],
    \   'php' : ['->', '::'],
    \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
    \   'lua' : ['.', ':'],
    \   'erlang' : [':'],
    \ }
endif

if !exists('g:dc_completion_sequence')
  let g:dc_completion_sequence = "\<C-x>\<C-o>\<C-p>"
endif

au CursorHoldI * call <SID>try_complete()

function! <SID>try_complete()
  let start_column = getpos(".")[2] - 1
  let line = getline(".")
  let line_length = len(line)
  if (line_length == 0) || ((start_column - 1) >= line_length)
    return 0
  endif

  for [filetypes, triggers] in items(g:dc_completion_triggers)
    if index(split(filetypes, ","), &ft) >= 0
      for trigger in triggers
        let index = -1
        let trigger_length = len(trigger)
        while 1
          let line_index = start_column + index

          if (line_index < 0) || (line[line_index] != trigger[trigger_length + index])
            break
          endif

          if abs(index) == trigger_length
            call feedkeys(g:dc_completion_sequence)
            return 1
          endif
          let index -= 1
        endwhile
      endfor
    endif
  endfor
  return 0
endfunction