" ============================================================================
" File:        vlide.vim
" Description: vim global plugin for presentations
" Maintainer:  Javier López <m@javier.io>
" ============================================================================

"init
if exists('g:loaded_vlide') || &cp
  finish
endif
let g:loaded_vlide = 1

if v:version < '700'
  echoerr "vlide unavailable: requires Vim 7.0+"
  finish
endif

"default configuration
if !exists('g:vlide_autoexe')  | let g:vlide_autoexe  = 1             | endif

if !exists('g:vlide_next')     | let g:vlide_next     = '<SPACE>'     | endif
if !exists('g:vlide_previous') | let g:vlide_previous = '<BACKSPACE>' | endif

if !exists('g:vlide_slide_separator')         | let g:vlide_slide_separator    = '\v^\={78,}' | endif
if !exists('g:vlide_subslide_separator')      | let g:vlide_subslide_separator = '\v^\-{78,}' | endif
if !exists('g:vlide_show_subslide_separator') | let g:vlide_show_subslide_separator = 0       | endif

if !exists('g:vlide_statusline')
    let g:vlide_statusline='%2* '                       "whitespace
    let g:vlide_statusline.='%2*%-.50{vlide#slide#name()} ' "file name
    let g:vlide_statusline.='%*  Press <Space> or <Backspace> to continue'
    let g:vlide_statusline.='%h%1*%m%r%w%0*'            "flags
    let g:vlide_statusline.='%='                        "right align
    let g:vlide_statusline.='(%{vlide#subslide#current()}/%{vlide#subslide#total()}) ' "subslide pager
    let g:vlide_statusline.='[%{vlide#slide#current()}/%{vlide#slide#total()}] '       "slide    pager
    let g:vlide_statusline.='%2*  '                     "whitespace
    let g:vlide_statusline.='%2*%-8{strftime("%H:%M")}' "time
endif

function! s:CompleteReferenceSlide(argLead, cmdLine, cursorPos) abort
    return '8' "start from the autoexe examples
endfunction

"commands & mappings
command! -nargs=* -complete=file -bang Vlide call vlide#start(<bang>0,<f-args>)
command! -nargs=0                  VlideExit call vlide#exit()
command! -nargs=* -complete=file VlideToggle call vlide#toggle(<f-args>)
command! -nargs=? -complete=custom,s:CompleteReferenceSlide VlideReferenceSlide call vlide#reference(<f-args>)

command! -nargs=? VlideNext             call vlide#next(<f-args>)
command! -nargs=? VlideNextSlide        call vlide#slide#next(<f-args>)
command! -nargs=* VlideNextSubslide     call vlide#subslide#next("exception!", <f-args>)
command! -nargs=? VlidePrevious         call vlide#previous(<f-args>)
command! -nargs=? VlidePreviousSlide    call vlide#slide#previous(<f-args>)
command! -nargs=* VlidePreviousSubslide call vlide#subslide#previous("exception!", <f-args>)

command! -nargs=0 -bang VlideAutoExe    call vlide#autoexe#enable(<bang>0)
command! -nargs=0 VlideAutoExeDisable   call vlide#autoexe#disable()

nnoremap <unique> <script> <Plug>VlideNext             :VlideNext<CR>
nnoremap <unique> <script> <Plug>VlidePrevious         :VlidePrevious<CR>
nnoremap <unique> <script> <Plug>VlideNextSlide        :VlideNextSlide<CR>
nnoremap <unique> <script> <Plug>VlidePreviousSlide    :VlidePreviousSlide<CR>
nnoremap <unique> <script> <Plug>VlideNextSubslide     :VlideNextSubslide<CR>
nnoremap <unique> <script> <Plug>VlidePreviousSubslide :VlidePreviousSubslide<CR>
