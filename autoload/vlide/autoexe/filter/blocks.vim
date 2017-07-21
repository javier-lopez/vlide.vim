" ============================================================================
" File:        blocks.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#autoexe#filter#blocks#multiline(subslide)
    let l:ignore = 0 | let l:ignore_next_whiteline = 0

    let l:stripped_subslide = [] | for l:line in a:subslide
        if match(l:line, "^@autoexe{ vim:") != -1
            call add(l:stripped_subslide, l:line)
            let l:ignore_next_whiteline = 1 | continue
        elseif match(l:line, "^@autoexe{")  != -1
            let l:ignore = 1 | continue
        elseif match(l:line, "^@end") != -1
            let l:ignore = 0 | let l:ignore_next_whiteline = 1 | continue
        endif

        if l:ignore == 0 && l:ignore_next_whiteline == 0
            call add(l:stripped_subslide, l:line)
        elseif  l:ignore_next_whiteline ==  1
            let l:ignore_next_whiteline  =  0
            if match(l:line, "^\\s*$")  == -1
                call add(l:stripped_subslide, l:line)
            else
                continue
            endif
        else
            continue
        endif
    endfor

    return l:stripped_subslide
endf
