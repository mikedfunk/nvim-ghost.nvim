if !has('nvim')
  finish
endif

if exists('g:loaded_nvim_ghost')
  finish
endif
let g:loaded_nvim_ghost = 1

let s:saved_updatetime = &updatetime
let s:can_use_cursorhold = v:false
let s:joblog_arguments = {
      \'on_stdout':{id,data,type->nvim_ghost#joboutput_logger(data,type)},
      \'on_stderr':{id,data,type->nvim_ghost#joboutput_logger(data,type)},
      \}
let s:joblog_arguments_nokill = extend(copy(s:joblog_arguments), {
      \'detach': v:true,
      \'cwd': g:nvim_ghost_installation_dir,
      \})

function! nvim_ghost#start_server() abort " {{{1
  call jobstart([g:nvim_ghost_binary_path, '--start-server'], s:joblog_arguments_nokill)
endfunction

function! nvim_ghost#kill_server() abort  " {{{1
  call jobstart([g:nvim_ghost_binary_path, '--kill'], s:joblog_arguments)
endfunction

function! nvim_ghost#request_focus() abort  " {{{1
  call jobstart([g:nvim_ghost_binary_path,'--focus'], s:joblog_arguments)
endfunction

function! nvim_ghost#joboutput_logger(data,type) abort  " {{{1
  if !g:nvim_ghost_logging_enabled
    return
  endif
  if a:type ==# 'stderr'
    echohl WarningMsg
  endif
  for line in a:data
    if len(line) == 0
      continue
    endif
    echom '[nvim-ghost] ' . a:type . ': ' . line
  endfor
  if a:type ==# 'stderr'
    echohl None
  endif
endfunction

function! nvim_ghost#session_closed() abort " {{{1
  call jobstart([g:nvim_ghost_binary_path, '--session-closed'], s:joblog_arguments_nokill)
endfunction
"}}}

" vim: et ts=2 fdm=marker
