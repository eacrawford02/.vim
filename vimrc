set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set number
set hlsearch
set ignorecase
set smartcase
set shiftwidth=2
set softtabstop=2
set whichwrap+=<,>,[,]
set signcolumn=auto
set textwidth=80
set colorcolumn=81

" Status line configuration
let g:currentmode={
  \ 'n'	     : "  NORMAL ",
  \ 'v'      : "  VISUAL ",
  \ 'V'      : "  VISUAL LINE ",
  \ "\<C-V>" : "  VISUAL BLOCK ",
  \ 'i'	     : "  INSERT ",
  \ 'R'      : "  REPLACE ",
  \ "Rv"     : "  VREPLACE ",
  \ 'c'      : "  COMMAND ",
\}

set noshowmode
set laststatus=2
set statusline=
" Different text highlighting for normal mode vs. other modes
set statusline+=%#CursorColumn#%{mode()=='n'?g:currentmode[mode()]:''}
set statusline+=%#Pmenu#%{mode()!='n'?g:currentmode[mode()]:''}
set statusline+=%#LineNr# " Filepath highlight colour
set statusline+=%f " Path to file in current buffer
set statusline+=\ %m " Indicate if file is modified
set statusline+=%= " Right align following items
set statusline+=%#CursorColumn#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} " Vim/file encoding
set statusline+=\ [%{&fileformat}] " Line ending for current file
set statusline+=\ %l:%c " Line and column numbers
set statusline+=\ %p%% " Percentage through file (in lines)
set statusline+=\  " Trailing space

" Open split views in correct directions
set splitbelow
set splitright

" Enable syntax highlighting. Note that Vim supports Verilog and SystemVerilog
" natively (see $VIMRUNTIME/syntax for a full list of languages
syntax enable

filetype indent on

" Configure colorscheme
set background=dark
if !has("gui_running")
  let g:solarized_termcolors=256
endif
colorscheme solarized

" Automatically apply changes made to (g)vimrc when saved to disk. Sources file 
" opened in current buffer ((g)vimrc) after writing buffer to config file
augroup AutoSrc
  autocmd!
  autocmd BufWritePost $MYVIMRC so %
  autocmd BufWritePost $MYGVIMRC so %
augroup END

" Map terminal keycodes associated with alt key chords. This is terminal
" dependent. Run `sed -n l` do determine the escape characters your specific
" terminal is sending to Vim and adjust the following list accordingly
if !has("gui_running")
  map <Esc>h <A-h>
  map <Esc>j <A-j>
  map <Esc>k <A-k>
  map <Esc>l <A-l>
  map <Esc>c <A-c>
  map <Esc>t <A-t>
endif

" Map window navigation to the Alt key. See :h map-alt-keys for more info
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

" Clear highlighted search with ; key
nnoremap <silent>; :let @/=""<cr>

" Indent and un-indent multiple lines
vnoremap <Tab> >
vnoremap <S-Tab> <

" Insert mode autocompletion shortcuts
inoremap <C-F> <C-X><C-F> " Autocomplete filenames
inoremap <C-D> <C-X><C-D> " Autocomplete macros
inoremap <C-L> <C-X><C-L> " Autocomplete lines
inoremap <C-I> <C-X><C-I> " Autocomplete keywords in included files

" Initialize terminal toggle variables
function! TermInit()
  " Tab page variables allow for more than one terminal window across multiple
  " tab pages
  let t:termBuf = 0
  let t:termWin = 0
endfunction

" Terminal window toggle function
function! ToggleTerm(height)
  if win_gotoid(t:termWin)
    " If the terminal window is not the last window, hide it and return the
    " cursor to the previous window. Otherwise, quit Vim
    if winnr('$') > 1
      hide
      execute winnr('#') .. "wincmd w"
    else
      q!
    endif
  else
    " Note that at no point will :startinsert work in terminal mode
    split new
    execute "resize " .. a:height
    " Try re-opening previous terminal buffer
    try
      execute "buffer " .. t:termBuf
    " If it does not exist, open a new terminal buffer
    catch
      " If Vim complains about a job still running when trying to quit after a
      " terminal window has been opened, a stronger signal argument will need to
      " be provided for the terminal kill option. See :help job_stop() for a
      " list of values
      terminal ++curwin ++kill=term
      let t:termBuf = bufnr("$")
      set nonumber
    endtry
    let t:termWin = win_getid()
  endif
endfunction

" Terminal window close function
function! CloseTerm()
  " If the terminal window and only one other window are open, hide the terminal
  " window
  if win_gotoid(t:termWin) && winnr('$') == 2
    hide
  endif
endfunction

augroup TermWrapper
  autocmd!
  " Initialize terminal toggle variables when entering Vim/opening new tabpage
  autocmd VimEnter,TabNew * :call TermInit()
  " Close the terminal window when quitting the last window (exiting Vim)
  autocmd QuitPre * :call CloseTerm()
augroup END

" Terminal window maps
nnoremap <A-c> :call ToggleTerm(12)<cr>
tnoremap <Esc> <C-\><C-N> " Return to normal mode
tnoremap <A-c> <C-W>:call ToggleTerm(12)<cr>

" File tree config
let g:fern#default_hidden=1 " Display hidden files
let g:fern#disable_drawer_tabpage_isolation=1 " All tabs share drawer

augroup FernStartup
  autocmd!
  autocmd FileType fern set nonumber
augroup END

" File tree toggle map
nnoremap <A-t> :Fern . -reveal=% -drawer -toggle<cr>

" Configure Git signs plugin to improve performance
set updatetime=100 " More responsive Git sign column updates
let g:signify_skip = {"vcs": {"allow": ["git"]}} " Only track git repositories

let g:signify_sign_change='~'

" Match signcolumn background colour to line number background colour. Note that
" the color values will need to be changed if the solarized colorscheme is no
" longer used. Run ./pack/vim-signify/start/vim-signify/showcolors.bash to print
" the cterm colours
if &background == "dark"
  highlight SignColumn ctermbg=235 guibg=#073642
else
  highlight SignColumn ctermbg=187 guibg=#eee8d5
endif

augroup GitHunk
  autocmd!
  " 'User' autocommand is manually invoked by the Signify plugin. Necessary if
  " we want a trigger event that is defined in a plugin (i.e., 'user' defined)
  autocmd User SignifyHunk call s:ShowCurrentHunk()
augroup END

function! s:ShowCurrentHunk()
  let h=sy#util#get_hunk_stats()
  if !empty(h)
    echo printf("[Hunk %d/%d]", h.current_hunk, h.total_hunks)
  endif
endfunction

nmap <Leader>j <Plug>(signify-next-hunk)
nmap <Leader>k <Plug>(signify-prev-hunk)
nnoremap <Leader>d :SignifyHunkDiff<cr>
