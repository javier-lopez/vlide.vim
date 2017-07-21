" ============================================================================
" File:        vlide.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#start(bang, ...)
    if a:bang
        call vlide#toggle()
    else
        let l:deck     = a:0 > 0 ? a:1 : bufname("%")
        let l:slide    = a:0 > 1 ? a:2 : 1
        let l:subslide = a:0 > 2 ? a:3 : 1

        if filereadable(l:deck)
            let l:buffer = readfile(l:deck)
            "https://vi.stackexchange.com/q/9962/
            "get-filetype-by-extension-or-filename-in-vimscript
            enew "slow, but mostly correct
            silent edit l:deck
            let l:ft = &ft
            silent bdelete
        else
            if l:deck =~ '\d' "is a digit and not a valid fname
                let l:subslide = l:slide
                let l:slide    = l:deck
                let l:deck     = bufname("%")
            endif
            let l:buffer = getline(1, line('$'))
            let l:ft = &ft
        endif

        if empty(join(l:buffer,"\n"))
            call vlide#util#echoerr("Vlide: empty deck!")
            return
        endif

        if empty(l:ft) | let l:ft=vlide#slide#ft() | endif "use default value

        "echo "l:deck: "     . l:deck
        "echo "l:ft: "       . l:ft
        "echo "l:slide: "    . l:slide
        "echo "l:subslide: " . l:sublide
        "echo "l:buffer: "   . join(l:buffer,"\n")

        if !exists('s:vlide_loaded')
            call vlide#slide#init(l:deck, l:ft)
            call vlide#slide#parse(l:buffer)
            call vlide#slide#display(l:slide, l:subslide)
        else
            call vlide#slide#display(l:slide, l:subslide)
        endif

        let s:vlide_loaded = 1
    endif
endfunction

function! vlide#exit()
    if exists ("s:vlide_loaded")
        unlet s:vlide_loaded
        call vlide#slide#destroy()
    endif
endfunction

function! vlide#toggle(...)
    if !exists ("s:vlide_loaded")
        "https://stackoverflow.com/q/11703297
        "/how-can-i-pass-varargs-to-another-function-in-vimscript
        call call("vlide#start", ["bang"] + a:000) "vim syntax is weird
    else
        call vlide#exit()
    endif
endfunction

function! vlide#reference(...)
    let l:reference_slide = split(globpath(&runtimepath, "doc/vlide.txt"))
    if !empty(l:reference_slide)
        if a:0 > 0
            call call("vlide#start", ["bang"] + l:reference_slide + a:000)
        else
            call call("vlide#start", ["bang"] + l:reference_slide)
        endif
    else
        echoerr "VLide: the reference slide wasn't found, please reinstall VLide"
    endif
endfunction

function! vlide#next(...)
    let l:next = a:0 > 0 ? a:1 : 1

    try | call vlide#subslide#next(l:next)
    catch /Already.*/
        call vlide#slide#next(l:next)
    endtry
endfunction

function! vlide#previous(...)
    let l:previous = a:0 > 0 ? a:1 : 1

    try | call vlide#subslide#previous(l:previous)
    catch /Already.*/
        call vlide#slide#previous(l:previous)
    endtry
endfunction
