" ============================================================================
" File:        init.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#init#mappings()
    if !hasmapto('<Plug>VlideNext', "n")     "normal mode
        exe "nmap <buffer> <silent>" . g:vlide_next . " <Plug>VlideNext"
    endif

    if !hasmapto('<Plug>VlidePrevious', "n") "normal mode
        exe "nmap <buffer> <silent>" . g:vlide_previous . " <Plug>VlidePrevious"
    endif
endf
