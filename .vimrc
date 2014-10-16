" James Barclay's vimrc file.
"
" Maintainer:   James Barclay <james@everythingisgray.com>
" Last change:  2013-06-08

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup      " do not keep a backup file, use versions instead
else
  set backup        " keep a backup file
  set backupdir=~/.vim/tmp,.
  set directory=~/.vim/tmp,.
endif
set history=50      " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching

" Fix for using fish-beta as shell
set shell=/bin/bash

let mapleader = ","
let maplocalleader = ";"

" Makes plugins look smoother
set lazyredraw

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
"map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  ""set hlsearch
endif

colorscheme desert
" Statusbar filename
"hi User1   guifg=#b1d631 guibg=#444444 gui=none ctermfg=253 ctermbg=238 cterm=none
" Statusbar warning
"hi User2   guifg=#ca1850 guibg=#444444 gui=none ctermfg=208 ctermbg=238 cterm=none

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  filetype plugin on
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Enable OmniCompletion
  set omnifunc=syntaxcomplete#Complete
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

  "autocmd BufWinLeave *.otl mkview
  "autocmd BufWinEnter *.otl silent loadview
  "autocmd BufWinLeave *.otl write

  " Don't pollute Dropbox
  autocmd BufReadPre */Dropbox/* BackupOff
  " Don't pollute Egnyte
  autocmd BufReadPre */Local\ Cloud/* BackupOff
  " Don't pollute Box
  autocmd BufReadPre */Box\ Documents/* BackupOff

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")

" Smart indenting, based on the typed code.
set smartindent 

" Soft word wrap
set formatoptions+=l
set lbr

" Tab spacing.
" set shiftround
" function TabSize(size)
"   let &tabstop=a:size
"   let &shiftwidth=a:size
"   let &softtabstop=a:size
" endfunction
" command -nargs=1 TabSize call TabSize(<args>)

"TabSize 4

set tabstop=4
set shiftwidth=4
set expandtab

" Searching
set ignorecase
set smartcase

" Completing
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Background buffers
set hidden

" Tab-complete menu
set wildmenu

" Remove the hated K-binding
map K <nop>

set laststatus=2

function ClutterTurnOn()
    set ruler
    set laststatus=2
endfunction
function ClutterTurnOff()
    set noruler
    set laststatus=1
endfunction
command ClutterOn  call ClutterTurnOn()
command ClutterOff call ClutterTurnOff()

function BackupTurnOn()
    set backup
    set writebackup
    set swapfile
    set backupdir=./.backup,.,/tmp
    set directory=.,./.backup,/tmp
endfunction
function BackupTurnOff()
    set nobackup
    set nowritebackup
    set noswapfile
endfunction
command BackupOn  call BackupTurnOn()
command BackupOff call BackupTurnOff()

function Marked()
    silent! !open -a Marked\ 2 "%"
    echo "Opened file in Marked 2.app"
endfunction
command Marked call Marked()

" Show line numbers
set number
