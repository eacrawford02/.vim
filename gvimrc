" Enable mouse in all five modes
set mouse=a

" Synchronize the unnamedplus register with the real system clipboard and the
" unnamed register with the selection clipboard (latter applies to Linux)
set clipboard^=unnamed,unnamedplus

set guioptions-=m " Turn off menubar
set guioptions-=T " Turn off toolbar

" Turn of cursor blinking in normal mode and decrease blink rate in insert mode
set guicursor+=n:blinkon0
set guicursor+=i-ci:ver25-Cursor/lCursor-blinkwait700-blinkon530-blinkoff530
