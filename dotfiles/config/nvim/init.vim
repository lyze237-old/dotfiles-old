execute pathogen#infect()

" Generic {{{
set shell=sh
syntax on
set cursorline
set showcmd
set wildmenu
set showmatch  "highlights brackets
" }}}

" Searching {{{
set incsearch " search as characters are entered
set hlsearch  "highlight matches
" }}}

" Tab stuff, spaces instead of tabs {{{
set tabstop=4
set softtabstop=4
set expandtab
" }}}

" Map enter to new line {{{
function! Delete_key(...)
  let line=getline (".")
  if line=~'^\s*$'
    execute "normal dd"
    return
  endif
  let column = col(".")
  let line_len = strlen (line)
  let first_or_end=0
  if column == 1
    let first_or_end=j
  else
    if column == line_len
      let first_or_end=1
    endif
  endif
  execute "normal i\<DEL>\<Esc>"
  if first_or_end == 0
    execute "normal l"
  endif
endfunction

nnoremap <silent> <DEL> :call Delete_key()<CR>
nmap <CR> a<CR><Esc>
" }}}

" Folding {{{
set foldenable
set foldlevelstart=0
set foldnestmax=10
nnoremap <space> za
set foldmethod=marker
set modelines=1
" }}}

" Remove Arrow Keys {{{
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Right> <Nop>
inoremap <Left> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Right> <Nop>
nnoremap <Left> <Nop>
" }}}

" Allows you to save the file with sudo if you don't have access rights  {{{
cnoremap w!! w !sudo tee > /dev/null %
" }}}

" ctrl+hjkl to move between splits {{{
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

map <C-j> :call WinMove('j')<cr>
map <C-k> :call WinMove('k')<cr>
map <C-h> :call WinMove('h')<cr>
map <C-l> :call WinMove('l')<cr>
set splitbelow
set splitright
" }}}

" Set line numbers {{{
nmap <silent> <leader>ln :exec &nu==&rnu? "se nu!" : "se rnu!"<cr>
set nu
set relativenumber
" }}}

" Gruvbox colorscheme {{{
colorscheme gruvbox
set background=dark
autocmd VimEnter * hi Normal ctermbg=none
" }}}

" Powerline {{{
let g:airline_powerline_fonts = 1
" }}}

" Easy motion stuff {{{
let g:EasyMotion_smartcase = 1 
" }}}

" NERDTree {{{
map <C-n> :NERDTreeToggle<CR>	
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
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

" vim:foldmethod=marker:foldlevel=0
