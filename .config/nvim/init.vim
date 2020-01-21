if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#add('Shougo/denite.nvim')

" editor
  call dein#add('mbbill/undotree')
  call dein#add('tpope/vim-fugitive')
"  call dein#add('Shougo/deoplete.nvim')
"	call dein#add('Shougo/neoinclude.vim')
	call dein#add('junegunn/fzf.vim')
"	call dein#add('Shougo/deol.nvim')
	call dein#add('neoclide/coc.nvim', {'merged':0, 'rev': 'release'})

" vue
"  call dein#add('posva/vim-vue')

" gql
"  call dein#add('jparise/vim-graphql')

" typescript
"  call dein#add('HerringtonDarkholme/yats.vim')
"  call dein#add('mhartington/nvim-typescript', {'build': './install.sh'})

" javascript
"	call dein#add('yuezk/vim-js')

" jsx/tsx
"	call dein#add('MaxMEllon/vim-jsx-pretty')

" themes
	call dein#add('kristijanhusak/vim-hybrid-material')
	call dein#add('vim-airline/vim-airline')
	call dein#add('drewtempelmeyer/palenight.vim')
	call dein#add('flrnprz/candid.vim')

" style
	call dein#add('editorconfig/editorconfig-vim')
	call dein#add('sbdchd/neoformat')

" html
"  call dein#add('valloric/MatchTagAlways', {'on_ft': 'html'})
"  call dein#add('othree/html5.vim')

" css
"  call dein#add('hail2u/vim-css3-syntax')
"  call dein#add('ap/vim-css-color')
"  call dein#add('ncm2/ncm2-cssomni')

" dotnet
"call dein#add('OmniSharp/omnisharp-vim')
"call dein#add('OrangeT/vim-csharp')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

let g:deoplete#enable_at_startup=1

if (has("termguicolors"))
  set termguicolors
endif
syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set number
set rtp+=/usr/local/opt/fzf
let g:netrw_liststyle = 3
set background=dark
colorscheme candid
set showmatch
set ignorecase " case-insensitive search
set clipboard=unnamedplus " yank and pase with system clipboard
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set noshowmode " hide default command bar at bottomn
set autoread " reload files on disk change
set completeopt=longest,menuone

let g:enable_bold_font=1
let g:enable_italic_font=1
let g:hybrid_transparent_background=1
let Grep_Skip_Dirs='node_modules dist build'
let g:airline_powerline_fonts=1 

" coc

" Use <c-space> to trigger completion.
"set completeopt=longest,menuone
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

let g:nvim_typescript#vue_support=1
" neoformatter
let g:standard_prettier_settings={
              \ 'exe': 'prettier',
              \ 'args': ['--stdin', '--stdin-filepath', '%:p', '--prose-wrap', 'always'],
              \ 'stdin': 1,
              \ }

let g:standard_tslint_settings={
        \ 'exe': 'tslint',
        \ 'args': ['--fix', '-c tslint.json'],
        \ 'replace': 1
        \ }


let g:neoformat_typescriptreact_prettier=g:standard_prettier_settings
let g:neoformat_enabled_typescriptreact=['prettier']

let g:neoformat_typescript_prettier=g:standard_prettier_settings
let g:neoformat_enabled_typescript=['prettier']

let g:neoformat_javascript_prettier=g:standard_prettier_settings
let g:neoformat_enabled_javascript=['prettier']

let g:neoformat_enabled_vue=['prettier']

let g:neoformat_markdown_prettier = g:standard_prettier_settings
let g:neoformat_enabled_markdown = ['prettier']

let g:neoformat_json_prettier = g:standard_prettier_settings
let g:neoformat_enabled_json = ['prettier']

let g:neoformat_scss_prettier = g:standard_prettier_settings
let g:neoformat_enabled_scss = ['prettier']


let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
		\ 'vue': 1,
    \}

augroup fmt
	autocmd!
	autocmd BufWritePre * undojoin | Neoformat
augroup END

augroup GENERIC
	autocmd!

	map <c-t>					:Deol -split=vertical<cr>
	tnoremap <ESC>		<C-\><C-n>
	map <c-v><c-r>		:vertical resize 
	map <c-s><c-g>		:Ag 
	map <c-g><c-s>		:Gstatus<cr>
	map <c-g><c-p>		:Gpush<cr>
	map <c-g><c-f>		:! git push --force-with-lease<cr>
	map <c-s><c-r>		:%s/
	map <c-h>					:noh<cr>
	map <c-x>					:Explore<cr>
	map <Home>				:FZF<cr>
augroup END

augroup XML
  autocmd!

  autocmd FileType xml let g:xml_syntax_folding=1
  autocmd FileType xml setlocal foldmethod=syntax
  autocmd FileType xml normal zR
augroup END
