""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"        VIMRC configuration file for vim
"   Author  :   Gobind Prasad
"   Email   :   gobprasad@gmail.com
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable compatibilty with Vi.
set nocompatible

" Allow plugins to be used.
filetype plugin indent on

" Use syntax highlighting.
syntax on

" Show line numbers.
set number

" Highlight line with cursor.
set cursorline

" Highlight column with cursor.
set cursorcolumn

" Split window to open a pane in the bottom.
set splitbelow

" Split window to open a pane to the right.
set splitright

" Always leave a number of rows below cursor.
set scrolloff=10

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab stop to 4 spaces.
set tabstop=4

" Indent automatically.
set autoindent

" Use the appropriate number of spaces to insert a tap in insert mode.
"set expandtab

" Show command in the last line of the screen.
set showcmd

" Show the line and column position of cursor.
set ruler

" Show matching words during a search.
set showmatch

" Highlight matching words while searching for text.
set hlsearch

" Set the number of lines to save in history.
set history=8000

" Back up files.
"set backup

" Set a directory to save file backups with full path.
"set backupdir=~/.vim/backup//

" Undo changes to files after saving them.
"set undofile

" Set a directory to save undo data with full path.
"set undodir=~/.vim/undo//

" Set number of times a file can be undone.
"set undoreload=2000

" Undo changes to files after saving them.
"set undofile

" Set location for temporary (swp) files.
"set directory=/tmp

" Check to see if an file has changed by another text editor.
set autoread

" Switch to another buffer without saving.
set hidden

" Set text width
set textwidth=85

" Display colorcolumn  relative to textwidth
set colorcolumn=-0
" Hide mouse when typing.
set mousehide

" Set colorscheme.
"colorscheme molokai

" Greatly enhance command line tab completion.
set wildmenu

" Set wildmode.
set wildmode=list:longest

" Ignore files.
set wildignore=*.jpg,*.mp4,*.zip,*.iso,*.pdf,*.pyc,*.odt,*.png,*.gif,*.tar,*.gz,*.xz,*.bz2,*.tgz,*.db,*.exe,*.odt,*.xlsx,*.docx,*.tar,*.rar,*.img,*.odt,*.m4a,*.bmp,*.ogg,*.mp3,*.gzip,*.flv,*.deb,*.rpm

"I don't like swap files
set noswapfile

"turn on numbering
set nu

set encoding=utf-8

" system wide cut,copy, paste
set clipboard=unnamed

" make backspaces more powerfull
set backspace=indent,eol,start

let python_highlight_all=1


set background=dark
"colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN MANAGER CONFIGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jiangmiao/auto-pairs'
Plugin 'vim-scripts/Mark--Karkat'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'morhetz/gruvbox'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'azabiong/vim-highlighter'
Plugin 'nvie/vim-flake8'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme gruvbox

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"           MAPPINGS - KEY BINDINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

"python indentation
au BufNewFile,BufRead *.py,*.pyw set tabstop=4
au BufNewFile,BufRead *.py,*.pyw set softtabstop=4
au BufNewFile,BufRead *.py,*.pyw set shiftwidth=4
au BufNewFile,BufRead *.py,*.pyw set textwidth=79
au BufNewFile,BufRead *.py,*.pyw set expandtab
au BufNewFile,BufRead *.py,*.pyw set autoindent
au BufNewFile         *.py,*.pyw set fileformat=unix
au BufRead,BufNewFile *.py,*.pyw let b:comment_leader = '#'

"c, c++ indentation
au BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.tin,*.tac set tabstop=4
au BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.tin,*.tac set softtabstop=4
au BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.tin,*.tac set shiftwidth=4
au BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.tin,*.tac set textwidth=79
au BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.tin,*.tac set expandtab
au BufNewFile,BufRead *.c,*.cpp,*.cc,*.h,*.tin,*.tac set autoindent
au BufNewFile         *.c,*.cpp,*.cc,*.h,*.tin,*.tac set fileformat=unix
au BufRead,BufNewFile *.c,*.cpp,*.cc,*.h,*.tin,*.tac let b:comment_leader = '/* '

"js, html, css indentation
au BufNewFile,BufRead *.js,*.html,*.css set tabstop=2
au BufNewFile,BufRead *.js,*.html,*.css set softtabstop=2
au BufNewFile,BufRead *.js,*.html,*.css set shiftwidth=2

au BufRead,BufNewFile *.tin,*.tac set filetype=cpp

"split navigtions
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Key combos:
"    Ctrl-j move to the split below
"    Ctrl-k move to the split above
"    Ctrl-l move to the split to the right
"    Ctrl-h move to the split to the left


" CODE FOLDING
" Note :
"       Most “modern” IDEs provide a way to collapse (or fold) methods and classes,
"       showing you just the class/method definition lines instead of all the code.

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

"
"  BUFFER MANAGEMENT
"
:nnoremap <leader>l :bnext<CR>
:nnoremap <leader>k :bprevious<CR>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

"
"  SPELL CHECK
"
" Toggle spell checking on and off with `,s`
nmap <silent> <leader>s :set spell!<CR>
hi clear SpellBad
hi SpellBad cterm=underline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"            PLUGIN CONFIGURATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline Theme configuration
let g:airline#extensions#tabline#enabled = 1
" Always show status line
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'
" Only show file name in tabs
let g:airline#extensions#tabline#fnamemod = ':t'

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'passive_filetypes': ['cpp'] }

" NERDTree
nnoremap <S-x> :NERDTreeToggle<CR>
" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIMSCRIPT FILE SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

