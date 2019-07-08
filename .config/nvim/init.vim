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
  call dein#add('Shougo/deoplete.nvim')
	call dein#add('Shougo/neoinclude.vim')
	call dein#add('junegunn/fzf.vim')
	call dein#add('Shougo/deol.nvim')

" vue
  call dein#add('posva/vim-vue')

" gql
  call dein#add('jparise/vim-graphql')

" typescript
  call dein#add('leafgarland/typescript-vim')
  call dein#add('mhartington/nvim-typescript', {'build': './install.sh'})

" themes
  call dein#add('kristijanhusak/vim-hybrid-material')
	call dein#add('vim-airline/vim-airline')
	call dein#add('drewtempelmeyer/palenight.vim')

" style
	call dein#add('editorconfig/editorconfig-vim')
  call dein#add('sbdchd/neoformat')

" html
  call dein#add('valloric/MatchTagAlways', {'on_ft': 'html'})
  call dein#add('othree/html5.vim')
  call dein#add('posva/vim-vue')

" css
  call dein#add('hail2u/vim-css3-syntax')
  call dein#add('ap/vim-css-color')
  call dein#add('ncm2/ncm2-cssomni')

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

set background=dark
colorscheme palenight
let g:enable_bold_font=1
let g:enable_italic_font=1
let g:hybrid_transparent_background=1
let Grep_Skip_Dirs='node_modules dist build'
let g:airline_powerline_fonts=1 

" neoformatter
let g:standard_prettier_settings={
              \ 'exe': 'prettier',
              \ 'args': ['--stdin', '--stdin-filepath', '%:p'],
              \ 'stdin': 1,
              \ }

let g:standard_tslint_settings={
        \ 'exe': 'tslint',
        \ 'args': ['--fix', '-c tslint.json'],
        \ 'replace': 1
        \ }


let g:neoformat_typescript_prettier=g:standard_prettier_settings
let g:neoformat_enabled_typescript=['prettier']

let g:neoformat_javascript_prettier=g:standard_prettier_settings
let g:neoformat_enabled_javascript=['eslint']

let g:neoformat_enabled_vue=['prettier']

let g:neoformat_markdown_prettier = g:standard_prettier_settings
let g:neoformat_enabled_markdown = ['prettier']

let g:neoformat_json_prettier = g:standard_prettier_settings
let g:neoformat_enabled_json = ['prettier']

let g:neoformat_scss_prettier = g:standard_prettier_settings
let g:neoformat_enabled_scss = ['prettier']

augroup fmt
	autocmd!
	autocmd BufWritePre * undojoin | Neoformat
augroup END

augroup GENERIC
	autocmd!

	map <c-t>					:Deol -split=vertical <cr>
	tnoremap <ESC>		<C-\><C-n>
	map <c-v><c-r>		:vertical resize 
	map <c-c>					:Ag 
augroup END

augroup XML
  autocmd!

  autocmd FileType xml let g:xml_syntax_folding=1
  autocmd FileType xml setlocal foldmethod=syntax
  autocmd FileType xml normal zR
augroup END

augroup TYPESCRIPT
	autocmd!

	autocmd FileType typescript setlocal foldmethod=syntax
  autocmd FileType typescript normal zR
	
	" Key mappings
	map <c-f> :TSGetCodeFix <cr>
	map <c-d> :TSDefPreview <cr>
	map <c-e> :TSGetErrorFull <cr>
augroup END

