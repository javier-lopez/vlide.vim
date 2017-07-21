About
-----

[![Build Status](https://travis-ci.org/javier-lopez/vlide.vim.png?branch=master)](https://travis-ci.org/javier-lopez/vlide.vim)

[VLide.vim](https://github.com/javier-lopez/vlide.vim) is a global plugin for interactive presentations.

<p align="center">
    <img src="http://javier.io/assets/img/vlide.gif" alt="vlide demo"/>
</p>

Requirements
------------

* Vim 7.0+

Usage
-----

[VLide.vim](https://github.com/javier-lopez/vlide.vim) allows you to use Vim as
a presentation tool.

Slides are separated by:

  - `====================================================`

Subslides by:

  - `----------------------------------------------------`

Besides displaying content it can run commands and modify syntax highlighting
per slide by using @blocks:

    @autoexe{ vim: set tw=78 ts=8 ft=sh: }

    @autoexe{sh}
        printf "%s\\n" "Hello world!"
    @end

To move around, it maps the following keys:

|            Key            |      Action     |
| :-----------------------: | :-------------: |
|    <kbd>\<Space\></kbd>   |    Next Slide   |
|  <kbd>\<Backspace\></kbd> |  Previous Slide |

Subslides
---------

Slides separated by `g:vlide_subslide_separator` are automatically handled as
steps of the main slide and displayed in order.

------------------------------------------------------------------------------

Subslide 1

------------------------------------------------------------------------------

Subslide 2

------------------------------------------------------------------------------

Subslide 3

------------------------------------------------------------------------------

<p align="center">
    <img src="http://javier.io/assets/img/vlide-subslide.gif" alt="vlide subslide demo"/>
</p>

Tmux
----

A specially interesting use case is combining
[vlide.vim](https://github.com/javier-lopez/vlide.vim) with
[tmux](https://github.com/tmux) to launch interactive demo sessions. To get a
glanse at this, execute the following command in a new terminal:

    $ tmux kill-session -t vlide-demo; tmux new-session -s vlide-demo vim

Now type `:VLideReferenceSlide 12` from the recently opened tmux session.  You
should see a `<0>` blinking a couple of times, if that's the case you've
followed the procedure sucessfully, keep pressing `<Space>` in the new session
to see the demo

<p align="center">
    <img src="http://javier.io/assets/img/vlide-tmux.gif" alt="vlide and tmux demo"/>
</p>

See <kbd>:h Vlide</kbd> for more help.

Installation
------------

Use your plugin manager of choice.

- [Vundle](https://github.com/gmarik/vundle)
  - Add `Bundle 'javier-lopez/vlide.vim'` to `~/.vimrc` and run `:BundleInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
  - Add `NeoBundle 'javier-lopez/vlide.vim'` to `~/.vimrc` and run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
  - Add `Plug 'javier-lopez/vlide.vim'` to `~/.vimrc` and run `:PlugInstall`
- [Pathogen](https://github.com/tpope/vim-pathogen)
  - `git clone https://github.com/javier-lopez/vlide.vim ~/.vim/bundle/vlide.vim`
- **Manual** (simplest if you've never heard of vundle or pathogen), download the zip file generated from github and extract it to `$HOME/.vim`
  - `mv vlide.vim*.zip $HOME/.vim && cd $HOME/.vim && unzip vlide.vim*.zip`
  - Update the help tags from vim: `:helpt ~/.vim/doc/`

Inspiration and alternative plugins
-----------------------------------

- https://blog.dbi-services.com/using-tmux-for-semi-interactive-demos/ #original idea
- https://github.com/alfredodeza/posero.vim
- https://github.com/sotte/presenting.vim
