" ============================================================================
" File:        subslide.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#subslide#parse(slide)
    let l:vlide_subslide_separator_expanded = matchstr(a:slide, g:vlide_subslide_separator)

    if len(l:vlide_subslide_separator_expanded) > 0
        let s:raw_subslides = map(split(join(a:slide, "\n"), l:vlide_subslide_separator_expanded), 'split(v:val, "\n")')
        let s:vlide_subslide_separator_expanded = l:vlide_subslide_separator_expanded
    else
        let s:raw_subslides = [a:slide]
    endif

    "echo s:raw_subslides
    "echo join(s:raw_subslides[0], "\n")
endfunction

function! vlide#subslide#display(subslide)
    if !exists('s:raw_subslides')
        echoerr 'no subslides found, call vlide#subslide#parse() before this function'
        return
    endif

    if a:subslide < 1
        throw "Already at the first subslide"
    elseif a:subslide > vlide#subslide#total()
        throw "Already at the last subslide"
    endif

    silent %delete "clean buffer
    let l:current = 0 | while l:current  < a:subslide
        if l:current < a:subslide - 1 "all but last subslide
            call append(line('$'), vlide#autoexe#filter#blocks(s:raw_subslides[l:current]))
            if g:vlide_show_subslide_separator == 1
                call append(line('$'), s:vlide_subslide_separator_expanded)
            endif
        else "last
            if match(s:raw_subslides[l:current], "^@autoexe{ vim:") != -1
                "modelines need to be read from the buffer directly =/
                call append(line('$'), vlide#autoexe#filter#blocks#multiline(s:raw_subslides[l:current]))
                "https://stackoverflow.com/a/24233643/890858
                set modeline | doautocmd BufRead "abuse doautocmd to trigger modeline processing
                call vlide#slide#ft(&ft) "set new filetype
                silent global/^@autoexe{ vim:/delete "remove modeline
                0 "mv back the cursor to the first line
            else
                call append(line('$'), vlide#autoexe#filter#blocks(s:raw_subslides[l:current]))
            endif
            call vlide#autoexe#parse(s:raw_subslides[l:current])
        endif
        let l:current += 1
    endw
    silent delete "remove 1st empty line
    call vlide#subslide#current(a:subslide)
endf

function! vlide#subslide#next(...) "([exception_flag|next_slide], [next_slide])
    "possibly inputs: (), ("exception!"), (2), ("exception!", 3)
    let l:current_slide = vlide#slide#current()
    let l:next_subslide = vlide#subslide#current()

    if     a:0 == 0
        let l:next_subslide   += 1
        let l:handle_exception = 0
    elseif a:0 == 1
        if type(a:1) == type(0) "is integer
            let l:next_subslide   += a:1
            let l:handle_exception = 0
        else "a string or other variable type was passed
            let l:next_subslide   += 1
            let l:handle_exception = 1
        endif
    elseif a:0 == 2
        let l:next_subslide  += a:2
        let handle_exception  = 1
    endif

    if l:handle_exception
        try | call vlide#slide#display(l:current_slide, l:next_subslide)
        catch /Already.*/
            call vlide#util#echoerr(v:exception)
        endtry
    else
        call vlide#slide#display(l:current_slide, l:next_subslide)
    endif
endfunction

function! vlide#subslide#previous(...) "([exception_flag|previous_slide], [previous_slide])
    "possibly inputs: (), ("exception!"), (2), ("exception!", 3)
    let l:current_slide     = vlide#slide#current()
    let l:previous_subslide = vlide#subslide#current()

    if     a:0 == 0
        let l:previous_subslide -= 1
        let l:handle_exception   = 0
    elseif a:0 == 1
        if type(a:1) == type(0) "is integer
            let l:previous_subslide -= a:1
            let l:handle_exception   = 0
        else "a string or other variable type was passed
            let l:previous_subslide -= 1
            let l:handle_exception   = 1
        endif
    elseif a:0 == 2
        let l:previous_subslide -= a:2
        let handle_exception     = 1
    endif

    if l:handle_exception
        try | call vlide#slide#display(l:current_slide, l:previous_subslide)
        catch /Already.*/
            call vlide#util#echoerr(v:exception)
        endtry
    else
        call vlide#slide#display(l:current_slide, l:previous_subslide)
    endif
endfunction

function! vlide#subslide#current(...)
    if a:0 > 0 "set behavior
        let s:current_subslide = a:1
    else       "get one
        if exists('s:current_subslide')
            return s:current_subslide
        else
            return 0
        endif
    endif
endfunction

function! vlide#subslide#total()
    if exists('s:raw_subslides')
        return len(s:raw_subslides)
    else
        return 0
    endif
endfunction
