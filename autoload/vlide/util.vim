" ============================================================================
" File:        util.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#util#echoerr(msg)
    redraw | echohl WarningMsg
    echomsg a:msg
    echohl None
endf
