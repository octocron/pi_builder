set nocompatible " Use vim over vi; must be at very top

" place colors in .vim & .zshrc in ~ & install pathogen
"-------------Pathogen-Settings------------------------------------------>>>
execute pathogen#infect()
filetype plugin indent on	"use plugins according to file type
set noshowmode

"-------------Airline-Settings------------------------------------------->>>
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dark'

"-------------Color-Schemes---------------------------------------------->>>
" dante advantage darker-robin dracula elflord koehler miko molokai
" moonlight nightfly synthwave84 sv gruvbox-material-hard cmptrclr
" Isotake hackerman camouflage nachtleben srcery shadesofamber
" cobalt vorange 

colorscheme miko

"colorscheme tokyonight
"let g:tokyonight_style = 'night' " available: night, storm
"let g:tokyonight_enable_italic = 1

"-------------General-Settings------------------------------------------->>>
set number  		" with relative this allows current line to show
set relativenumber		" show numbers relatively
set ruler			" Show file stats
set cursorline		" Highlight the line currently under the cursor
set visualbell		" Flash the screen instead of beeping errors
set history=1000  	" Increase the undo limit
set t_Co=256
set title			" Set window title to file being edited

"-------------Folder-Settings------------------------------------------->>>
" Search down into subfolders
" Add tab complete for all file-related tasks
set path+=**

" Display all matching files when we tab complete
" Allows :find by partial match and * for fuzzy
set wildmenu

" Netrw settings (nerdtree that ships with vim)
"-------------Netrw-Settings-------------------------------------------->>>
let g:netrw_liststyle = 3		" Viewtype can be cycled with i
let g:netrw_banner = 0			" Removes info banner, cycle with I
let g:netrw_browse_split = 1 	" 1 hex, 2 vex, 3 tex, 4 prev window
let g:netrw_altv = 1			" Opens vertical split in wider window (75%)
let g:netrw_winsize = 25		" Set tree width to 25%

" Text rendering options
"-------------Text-Settings-------------------------------------------->>>
set display+=lastline	" Always try to show a paragraph's last line
set encoding=utf-8		" Use unicode
set linebreak			" Avoid wrapping a line in the middle of a word
set scrolloff=1			" Number of lines to keep above/below cursor
set sidescrolloff=5 	" Columns to keep /left/right of cursor
syntax enable			" Turn on syntax highlighting

" Set command window height to 2 lines, to avoid many cases of having to
" Press <enter> to continue
" Set cmdheight=2

" Enable mouse for all modes
set mouse=a

"-------------Whitespace-Settings-------------------------------------->>>
set wrap		" Enable line wrapping
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2		" Indent using # of spaces
set autoindent		" New lines inherit indentation of previous line
set shiftwidth=4	" When shifting, indent # of spaces
set softtabstop=2
set expandtab		" Concert tabs into spaces
set noshiftround	" Round to nearest shiftwidth
set pastetoggle=<F2>	" F2 to pastemode before pasting, helps keep proper indentation
set clipboard=unnamedplus       " Copy/paste between vim and other programs.

"-------------Text-Search-Options------------------------------------->>>
set hlsearch 		" Enables search highlighting
set ignorecase  	" Ignore case when searching
set incsearch   	" Incremental search that shows partial matches
set smartcase   	" Automatically switch search to case-sensitive when search
					" Query contains an uppercase letter.

"--------------Performance-Options------------------------------------->>>
set lazyredraw  	" Don't update screen during macro or script executions

"--------------Cursor-Motion------------------------------------->>>
set scrolloff=3
set backspace=indent,eol,start	" Allow backspace over indent, line braks and insertion start
set matchpairs+=<:> 	" Use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines visually
nnoremap j gj
nnoremap k gk
nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a

set hidden  		" Hide files in background instead of closing them
set ttyfast 		" Speeds up scrolling
set laststatus=2  	" Status bar
set showmode 		" Show current mode at the bottom
set showcmd 		" Show incomplete cmds at the bottom

"--------------Folding-Options------------------------------------->>>
set foldmethod=indent
set foldnestmax=3
"set nofoldenable	" All folds are open, toggle with zi

"--------------Miscellaneous-Options------------------------------->>>
set autoread  		" Automatically reload files changed outside of vim
set confirm 		" Display a confirm when closing unsaved
set formatoptions+=j  	" Delete comment characters when joining lines

