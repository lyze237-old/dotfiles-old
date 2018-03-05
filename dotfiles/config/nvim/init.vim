" Plugins {{{ 
call plug#begin("~/.config/nvim/foxes")
Plug 'morhetz/gruvbox' " Theme
Plug 'vim-airline/vim-airline' " Airline

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " Tree view
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle' } " Git integration 

Plug 'airblade/vim-gitgutter' "Git Integration

Plug 'jiangmiao/auto-pairs' " Add auto brackets

Plug 'nathanaelkane/vim-indent-guides' " Guidelines for indention

Plug 'ryanoasis/vim-devicons' " Better icons for nerdtree n co
call plug#end()

" Settings {{{
colorscheme gruvbox
set background=dark
autocmd VimEnter * hi Normal ctermbg=none

let g:airline_powerline_fonts = 1

let g:indent_guides_enable_on_vim_startup = 1

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" Keybinds {{{
map <C-n> :NERDTreeToggle<CR>
"}}}
" }}}

" Settings {{{
" Generic {{{
set shell=sh
syntax on
set cursorline
set showcmd
set wildmenu
set showmatch  "highlights brackets
set encoding=utf8
" }}}

" Searching {{{
set incsearch " search as characters are entered
set hlsearch  "highlight matches
" }}}

" Tab stuff, spaces instead of tabs {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" }}}

" Folding {{{
set foldenable
set foldlevelstart=0
set foldnestmax=10
nnoremap <space> za
set foldmethod=marker
set modelines=1
" }}}
" }}}

" Functions {{{
" Set line numbers {{{
nmap <silent> <leader>ln :exec &nu==&rnu? "se nu!" : "se rnu!"<cr>
set nu
set relativenumber
" }}}

" Toggle Slashes {{{
function! ToggleSlash(independent) range
  let from = ''
  for lnum in range(a:firstline, a:lastline)
    let line = getline(lnum)
    let first = matchstr(line, '[/\\]')
    if !empty(first)
      if a:independent || empty(from)
        let from = first
      endif
      let opposite = (from == '/' ? '\' : '/')
      call setline(lnum, substitute(line, from, opposite, 'g'))
    endif
  endfor
endfunction
command! -bang -range ToggleSlash <line1>,<line2>call ToggleSlash(<bang>1)
noremap <Leader>/ :ToggleSlash<CR>
" }}}
" }}}

" vim:foldmethod=marker:foldlevel=0
