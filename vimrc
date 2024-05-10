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

" Automatically apply changes made to ~/.vimrc when saved to disk. Sources file 
" opened in current buffer (~/.vimrc) after writing buffer to ~/.vimrc
autocmd BufWritePost $MYVIMRC so %

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

" Terminal window toggle function
let g:termBuf = 0
let g:termWin = 0

function! ToggleTerm(height)
  if win_gotoid(g:termWin)
    hide
  else
    " Note that at no point will :startinsert work in terminal mode
    split new
    execute "resize " .. a:height
    " Try re-opening previous terminal buffer
    try
      execute "buffer " .. g:termBuf
    " If it does not exist, open a new terminal buffer
    catch
      terminal ++curwin ++kill=term
      let g:termBuf = bufnr("$")
      set nonumber
    endtry
    let g:termWin = win_getid()
  endif
endfunction

" Terminal window maps
nnoremap <A-c> :call ToggleTerm(12)<cr>
tnoremap <Esc> <C-\><C-N> " Return to normal mode
tnoremap <A-c> <C-W>:call ToggleTerm(12)<cr>
