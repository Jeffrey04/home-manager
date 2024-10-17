autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>

" Number of spaces that a <Tab> in the file counts for
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'tabstop'>
set tabstop=4

" Number of spaces that a <Tab> counts for while performing editing operations
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'softtabstop'>
set softtabstop=4

" Number of spaces to use for each step of (auto)indent
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'shiftwidth'>
set shiftwidth=4

" Use the appropriate number of spaces to insert a <Tab>
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'expandtab'>
set expandtab

" Do smart autoindenting when starting a new line.
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'smartindent'>
set autoindent

" Newline format
" <http://vimdoc.sourceforge.net/htmldoc/options.html#'fileformat'>
" unix: <NL>
set fileformat=unix
