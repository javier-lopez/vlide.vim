" ============================================================================
" File:        slide.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

function! vlide#slide#init(name, ft)
    "create a tmp buffer, this is where the slide content will be shown
    silent edit [VLIDE] | let s:vlide_buffer = bufnr("$")

    "presentation mode defaults applied only to the unnamed buffer
    setlocal buftype=nofile
    setlocal cmdheight=1
    setlocal nocursorcolumn
    setlocal nocursorline
    setlocal nofoldenable
    setlocal nonumber
    setlocal norelativenumber
    setlocal noswapfile
    setlocal wrap
    setlocal linebreak
    silent! setlocal breakindent "not be available in old vim versions
    setlocal nolist
    setlocal bufhidden=wipe
    setlocal nobuflisted

    let s:vlide_statusline_orig=&statusline
    let &statusline=g:vlide_statusline

    call vlide#slide#name(fnamemodify(a:name, ":t")) "basename
    call vlide#slide#ft(a:ft) "set default filetype
endfunction

function! vlide#slide#destroy()
    if exists('s:vlide_buffer') && bufexists(s:vlide_buffer)
        execute 'silent bwipeout ' . s:vlide_buffer | let s:vlide_buffer = -1
    endif
    let &statusline=s:vlide_statusline_orig
endfunction

function! vlide#slide#parse(buffer)
    let l:vlide_slide_separator_expanded = matchstr(a:buffer, g:vlide_slide_separator)

    if len(l:vlide_slide_separator_expanded) > 0
        let s:raw_slides = map(split(join(a:buffer, "\n"), l:vlide_slide_separator_expanded), 'split(v:val, "\n")')
    else
        let s:raw_slides = [a:buffer]
    endif

    "echo s:raw_slides
    "echo join(s:raw_slides[0], "\n")
endfunction

function! vlide#slide#display(slide, subslide)
    if !exists('s:raw_slides')
        echoerr 'no slides found, call vlide#slide#parse() before this function'
        return
    endif

    if a:slide < 1
        call vlide#util#echoerr("Already at the first slide")
        return
    elseif a:slide > vlide#slide#total()
        call vlide#util#echoerr("Already at the last slide")
        return
    endif

    if a:slide != vlide#slide#current()
        call vlide#subslide#parse(s:raw_slides[a:slide-1])
    endif

    "negative => positive list indices
    let l:subslide = a:subslide < 0 ? vlide#subslide#total() + 1 + a:subslide : a:subslide

    call vlide#subslide#display(l:subslide)

    "load syntax efficiently
    if &ft != vlide#slide#ft() | let &ft=vlide#slide#ft() | endif
    "deal with auto triggered ftplugins, some of them could override Vlide mappings
    call vlide#init#mappings()

    call vlide#slide#current(a:slide)
endfunction

function! vlide#slide#next(...)
    let l:next_slide  = vlide#slide#current()
    let l:next_slide += a:0 > 0 ? a:1 : 1

    call vlide#slide#display(l:next_slide, 1)
endfunction

function! vlide#slide#previous(...)
    let l:previous_slide  = vlide#slide#current()
    let l:previous_slide -= a:0 > 0 ? a:1 : 1

    call vlide#slide#display(l:previous_slide, -1)
endfunction

function! vlide#slide#current(...)
    if a:0 > 0 "set behavior
        let s:current_slide = a:1
    else       "get behavior
        if exists('s:current_slide')
            return s:current_slide
        else
            return 0
        endif
    endif
endfunction

function! vlide#slide#total()
    if exists('s:raw_slides')
        return len(s:raw_slides)
    else
        return 0
    endif
endfunction

function! vlide#slide#name(...)
    if a:0 > 0 "set behavior
        let s:name = a:1
    else       "get behavior
        if exists('s:name')
            return s:name
        else
            return "unnamed"
        endif
    endif
endfunction

function! vlide#slide#ft(...)
    if a:0 > 0 "set behavior
        let s:ft = a:1
    else       "get behavior
        if exists('s:ft')
            return s:ft
        else
            return "help"
        endif
    endif
endfunction
