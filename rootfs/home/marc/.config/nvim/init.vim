"------------------------------------------------------------------------------
" PlugInstall  Install plugins.
" PlugUpdate   Install or update plugins.
" PlugUpgrade  Upgrade vim-plug itself.
" PlugClean    Remove unused directories.
" PlugStatus   Check the status of plugins.
" PlugDiff     Examine changes.
" PlugSnapshot Restoring the current snapshot.
"------------------------------------------------------------------------------

call plug#begin('~/.local/share/nvim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'vim-syntastic/syntastic'
Plug 'w0ng/vim-hybrid'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'wesQ3/vim-windowswap'
call plug#end()

"------------------------------------------------------------------------------
" Enable filetype and plugins:
"------------------------------------------------------------------------------

filetype on
filetype plugin on
filetype indent on

"------------------------------------------------------------------------------
" Use pacman-installed vim addons with neovim:
"------------------------------------------------------------------------------

set runtimepath^=/usr/share/vim/vimfiles

"------------------------------------------------------------------------------
" Hybrid colorscheme:
"------------------------------------------------------------------------------

let g:hybrid_custom_term_colors = 1
set background=dark
colorscheme hybrid

"------------------------------------------------------------------------------
" Set this and set that:
"------------------------------------------------------------------------------

set mouse=r                  " Mouse mode.
set autowrite                " Save on buffer switch.
set number                   " Show line numbers.
set cursorline               " Highlight current line (performance killer).
set cursorcolumn             " Highlight current column (performance killer).
set listchars=tab:▸\ ,eol:¬  " Way whitespace characters are shown.
set shell=bash               " Force bash shell even if using zsh.
set updatetime=100           " Status line updates every 100ms.

"------------------------------------------------------------------------------
" Highlight tabs and trailing spaces:
"------------------------------------------------------------------------------

highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
match ExtraWhitespace /\t/
match ExtraWhitespace /\s\+$/

"------------------------------------------------------------------------------
" Defaults to '\' but ',' is easier to reach:
"------------------------------------------------------------------------------

let mapleader = ","

"------------------------------------------------------------------------------
" Normal mode maps:
"------------------------------------------------------------------------------

nmap <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
nmap <leader>l :set cursorcolumn! cursorline!<CR>
nmap <leader>n :set number!<CR>
nmap <leader>s :set list!<CR>
nmap <leader>t :TagbarToggle<CR>

"------------------------------------------------------------------------------
" Cycle through buffers:
"------------------------------------------------------------------------------

nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprevious!<CR>

"------------------------------------------------------------------------------
" Shortcuts to make it easier to jump between errors in quickfix list
"------------------------------------------------------------------------------

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

"------------------------------------------------------------------------------
" Checks the type of the Go file and executes :GoBuild or :GoTestCompile
"------------------------------------------------------------------------------

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

"------------------------------------------------------------------------------
" Golang mappings:
"------------------------------------------------------------------------------

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

"------------------------------------------------------------------------------
" vim-go settings:
"------------------------------------------------------------------------------

let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1

"------------------------------------------------------------------------------
" Airline settings:
"------------------------------------------------------------------------------

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='hybridline'

"------------------------------------------------------------------------------
" Syntastic settings:
"------------------------------------------------------------------------------

let g:syntastic_aggregate_errors = 1
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
