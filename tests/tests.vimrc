if !executable('git')
    echoerr "Tests require 'git'"
    cq!
endif

if !isdirectory(expand("~/.vim/bundle/vader.vim/.git/"))
    if !isdirectory(expand("vader.dep"))
        silent !printf "Installing the Vader test framework ...\n"
        silent !git clone --depth=1 https://github.com/junegunn/vader.vim vader.dep
    endif
    if !isdirectory(expand("vader.dep"))
        echoerr "Tests: couldn't install vader, exiting ..."
        cq!
    endif
endif

filetype off
set rtp+=~/.vim/bundle/vader.vim
set rtp+=./vader.dep
set rtp+=..
filetype plugin indent on
syntax enable

"comented because it produces no output
"autocmd VimEnter * Vader! * tests/*
