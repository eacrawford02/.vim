set number
set hlsearch
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

" Configure colorscheme
set background=dark
if !has("gui_running")
  let g:solarized_termcolors=256
endif
colorscheme solarized

" Automatically apply changes made to ~/.vimrc when saved to disk. Sources file 
" opened in current buffer (~/.vimrc) after writing buffer to ~/.vimrc
autocmd BufWritePost $MYVIMRC so %
