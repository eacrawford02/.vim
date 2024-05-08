set number
set shiftwidth=2
set softtabstop=2
set whichwrap+=<,>,[,]
set signcolumn=auto
set textwidth=80
set colorcolumn=81

" Open split views in correct directions
set splitbelow
set splitright

" Automatically apply changes made to ~/.vimrc when saved to disk. Sources file 
" opened in current buffer (~/.vimrc) after writing buffer to ~/.vimrc
autocmd BufWritePost $MYVIMRC so %
