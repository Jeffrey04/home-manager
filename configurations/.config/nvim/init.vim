""
" Neo-specific vim options
"


"
" Startup Options
"


"
" Appearance
"

" Enable true-color support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

" GUI font
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'guifont'>
if has("gui_macvim")
    set guifont=Input:h10
elseif has("gui_gtk")
    set guifont=Input\ 10
elseif has("gui_vimr")
    set title
endif

" Load color scheme
" <http://vimdoc.sourceforge.net/htmldoc/syntax.html#:colorscheme>
if !exists('g:vscode')
    colorscheme base16-seti
endif
au ColorScheme * hi Normal ctermbg=none guibg=none
let g:vawahl="ctermbg=black ctermfg=blue guifg=#f22c40 guibg=#000000 gui=bold"


" switch syntax highlighting on
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'syntax'>
syntax enable
syntax on

" Setting dark background
" http://vimdoc.sourceforge.net/htmldoc/options.html#'background'
set background=dark

" color character after from 85 chars onwards
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#important-vimrc-lines
set colorcolumn=85

" Print the line number in front of each line.
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'number'>
set number


"
" Editor Options
"

fun! StripTrailingWhitespace()
    " Don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\s\+$//e
endfun

" automatically change working directory
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * silent! lcd %:p:h

" Highlight space character
autocmd InsertEnter * match Todo /\s\+\%#\@<!$/
autocmd InsertLeave * match Todo /\s\+$/

" auto trim trailing whitespace
" <http://vim.wikia.com/wiki/Remove_unwanted_spaces>
" <http://stackoverflow.com/a/6496995/5742>
autocmd BufWritePre * call StripTrailingWhitespace()

" better backspacing
" http://vimdoc.sourceforge.net/htmldoc/options.html
set backspace=indent,eol,start

" always use system clipboard
" <https://neovim.io/doc/user/nvim_clipboard.html#nvim-clipboard-intro>
set clipboard+=unnamedplus

" Use the appropriate number of spaces to insert a <Tab>
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'expandtab'>
set expandtab

" Newline format
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'fileformat'>
" unix: <NL>
set fileformat=unix

" do not highlight all matching candidates
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'hlsearch'>
set nohlsearch

" ignore case in search pattern
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'ignorecase'>
set ignorecase

" Number of spaces to use for each step of (auto)indent
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'shiftwidth'>
set shiftwidth=4

" Override the 'ignorecase' option if the search pattern contains upper case
" characters
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'smartcase'>
set smartcase

" Do smart autoindenting when starting a new line.
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'smartindent'>
set smartindent

" a <Tab> in front of a line inserts blanks according to 'shiftwidth'
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'smarttab'>
set smarttab

" Number of spaces that a <Tab> counts for while performing editing operations
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'softtabstop'>
set softtabstop=4

" split new window to the right
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'splitright'>
set splitright

" Auto-completion mode for commands
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'wildmode'>
" list:longest: When more than one match, list all matches and complete till
" longest common string.
set wildmode=longest:full

" lines longer than the width of the window will wrap and displaying continues
" on the next line.
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'wrap'>
set nowrap

" for leader key
" "http://stackoverflow.com/questions/1764263/what-is-the-leader-in-a-vimrc-file/8160809#8160809
set showcmd

" Number of spaces that a <Tab> in the file counts for
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'tabstop'>
set tabstop=4


"
" Filetype Plugins
" <http://vimdoc.sourceforge.net/htmldoc/filetype.html#filetypes>
"

" when a file is edited its plugin file is loaded
filetype plugin on

" when a file is edited its indent file is loaded
filetype plugin indent on


"
" Stop sourcing if this is vscode
" <https://vi.stackexchange.com/a/26376>
"
if exists('g:vscode')
    finish
endif


"
" Leader Key & Shortcuts
"

"
" Buffer Management
"
nnoremap <leader>n <ESC>:bnext<CR>
nnoremap <leader>p <ESC>:bprevious<CR>

" Flying is faster than cycling.
" https://plus.google.com/104286962752255423480/posts/bmHQXnKeimj
nnoremap <leader>l :ls<CR>:b<space>

" remove whitespace
" <http://vim.wikia.com/wiki/Remove_unwanted_spaces>
" help 40.2
nnoremap <leader>ks normal!:%s/\s\+$<CR>

"
" enter in normal mode
"
nnoremap m i<CR><ESC>
nnoremap M a<CR><ESC>
nnoremap <SPACE> i<SPACE><ESC>l
nnoremap <TAB> >>
nnoremap <S-TAB> <<


"
" Plugin Settings
"

"
" Airline
"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

let g:airline_theme='base16'

"
" Deoplete
"
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\  'smart_case': v:true
\ })
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" automatically close autocomplete pane
" http://stackoverflow.com/questions/3105307/how-do-you-automatically-remove-the-preview-window-after-autocompletion-in-vim/3107159#3107159
autocmd CursorMovedI * if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
autocmd CompleteDone * pclose " To close preview window of deoplete automagically

"
" Rainbow Parenthesis
"
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces

"
" Mouse support
"
set mouse=a
