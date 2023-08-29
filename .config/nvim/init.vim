if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" theme
Plug 'flrnprz/candid.vim'
Plug 'vim-airline/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'mhartington/oceanic-next'
Plug 'Mofiqul/vscode.nvim'

" javascript
" Plug 'othree/yajs.vim'
Plug 'HerringtonDarkholme/yats.vim'

" gql
Plug 'jparise/vim-graphql'

" css
Plug 'ap/vim-css-color'

" svelte
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" vue
Plug 'posva/vim-vue'

" swig
Plug 'SpaceVim/vim-swig'

" markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

" editor
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "installs the binary
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'akinsho/toggleterm.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'kdheepak/lazygit.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

call plug#end()

if (has("termguicolors"))
  set termguicolors
endif

syntax on" enable but don't override syntax

set number " line numbers
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set rtp+=/usr/local/opt/fzf
colorscheme vscode
"let g:airline_powerline_fonts=1 
"let g:airline_statusline_ontop=1
let g:airline_theme='oceanicnext'
let g:airline#extensions#tabline#enabled = 1

"set background=light
set signcolumn=yes
set clipboard=unnamedplus " yank and pase with system clipboard
set noshowmode " hide default command bar at bottomn
set autoread " reload files on disk change
set completeopt=longest,menuone
set cmdheight=2
set backupcopy=yes
set foldmethod=syntax
autocmd Syntax * normal zR

" barbar
"let bufferline = get(g:, 'bufferline', {})
"let bufferline.maximum_padding = 1

lua << EOF
require'barbar'.setup {
  auto_hide = true,
  clickable = false,
  icons = {current = {filetype = {enabled = false}}},
  maximum_padding = math.huge,
}
EOF

let g:coc_global_extensions=[ 'coc-tsserver', '@yaegassy/coc-volar', 'coc-prettier', 'coc-css', 'coc-json', 'coc-svelte', 'coc-sh', 'coc-yaml', 'coc-eslint', 'coc-stylelint' ]

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
"autocmd FileType typescript,scss,css,markdown,vue,svelte,json autocmd BufWritePre * call CocAction('format')

augroup GENERIC
	autocmd!

	tnoremap <ESC>		<C-\><C-n>
	map <c-v><c-r>		:vertical resize 
	map <c-s><c-g>		:Ag 
	map <c-s><c-r>		:%s/
	map <c-h>					:noh<cr>
	map <c-x>					:Explore<cr>
	map <Home>				:FZF<cr>
  nnoremap <silent> <leader>gg :LazyGit<CR>
augroup END

" Fix current line
nmap <leader>cf  <Plug>(coc-fix-current)

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> <A-space> <Plug>(coc-codeaction-line)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gtd <Plug>(coc-type-definition)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> cr <Plug>(coc-rename)

nnoremap <silent> <A-h> <Cmd>NERDTreeToggle<CR>

vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! RestartTsServer()
  call CocAction('runCommand', 'tsserver.restart')
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>
" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" MARKDOWN
augroup MD
	autocmd!
  "au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

	autocmd FileType md :setlocal spell spelllang=en_uk
	autocmd FileType markdown :setlocal spell spelllang=en_uk
	"autocmd FileType markdown.pandoc :setlocal spell spelllang=en_uk
augroup END

if !empty(glob("~/.local.vim"))
  source ~/.local.vim
endif

if !empty(glob(".init.vim"))
	source .init.vim
endif

source ~/dotfiles/.config/nvim/lua_init.lua
