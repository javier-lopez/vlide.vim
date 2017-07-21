Instructions to (re)create gifs:

  - Launch `x-terminal-emulator` && move it to it's own workspace
  - Set `COLORIZE_PS="lambda"` as the default ps theme in `~/.bashrc` #require https://github.com/javier-lopez/shundle
  - Kill `compton`
  - Execute: `xdotool search --onlyvisible x-terminal windowsize 490 320; tmux kill-session -t vlide-demo; tmux new-session -s vlide-demo vim`
  - Execute: `key-mon --nomouse --nometa --noshift --noctrl --noalt  -t modern --stick --scale=.6`
  - Type: `:VlideReferenceSlide 6` and keep pressing `<Space>`

In another terminal:

  - Execute: `gifcast vlide.gif` and select the vlide window
  - Kill     `avconv|ffmpeg` to stop recording

Review and commit the new gif, give yourself a pat on the back:

<p align="center">
    <img src="http://javier.io/assets/img/cheers.jpg" alt="pat on the back"/>
</p>

Note: The imgs were reallocated to decrease the plugin size
