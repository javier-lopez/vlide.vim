" ============================================================================
" File:        autoexe.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#autoexe#parse(subslide)
    if g:vlide_autoexe == 1
        let l:ignore = 1 | let l:snippet = []
        for l:line in a:subslide
            if match(l:line, "^@autoexe{ vim:") != -1
                continue "already evaluated at vlide#subslide#display()
            elseif match(l:line, "^@autoexe.*{")  != -1
                let l:interpreter = matchstr(l:line, '^@autoexe{\zs.*\ze}')
                let l:interpreter = empty(l:interpreter) ? "vim" : l:interpreter
                let l:ignore = 0 | continue
            elseif match(l:line, "^@end") != -1
                call vlide#autoexe#eval(l:interpreter, l:snippet)
                let l:ignore = 1 | let  l:snippet = [] | continue
            endif

            if l:ignore == 0
                call add(l:snippet, l:line)
            else
                continue
            endif
        endfor
    endif
endfunction

function! vlide#autoexe#eval(interpreter, snippet)
    if a:interpreter == "vim"
        for l:line in a:snippet
            try
                execute l:line
            catch /(.*)/
                call vlide#util#echoerr("Exception raised: " . v:exception . " Executing line >> " . l:line')
            endtry
        endfor
    else
        "FIX: spartan version, beautify, something along https://github.com/joonty/vim-do
        let l:output = split(system(a:interpreter, join(a:snippet, "\n")), "\n")
        echon join(l:output, "\n")
    endif
endf

function! vlide#autoexe#enable(bang)
    if a:bang
        call vlide#autoexe#toggle()
    else
        let g:vlide_autoexe = 1
        redraw | echomsg "Vlide: autoexe enabled!"
    endif
endfunction

function! vlide#autoexe#disable()
    let g:vlide_autoexe = 0
    redraw | echomsg "Vlide: autoexe disabled!"
endfunction

function! vlide#autoexe#toggle()
    if g:vlide_autoexe == 0
        call vlide#autoexe#enable("bang")
    else
        call vlide#autoexe#disable()
    endif
endfunction
