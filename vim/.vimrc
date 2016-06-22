"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Original_author:
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Blog_post:
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
" Raw_version:
"       http://amix.dk/vim/vimrc.txt
"
" Current_author:
"       Pierre-Nicolas 'ArkAnoryn' SORMANI
"       pierre-nicolas@phenixies.com
"
" Version:
"       1.0 - 14/05/16 18:28:36
"
" Sections:
"    -> General
"    -> Vundle
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'bling/vim-airline'
Plugin 'jiangmiao/auto-pairs'
Plugin 'junegunn/vim-easy-align'
Plugin 'easymotion/vim-easymotion'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-endwise'                       " Insert 'end' in ruby as smartly as braces
Plugin 'jakedouglas/exuberant-ctags'
Plugin 'tpope/vim-fugitive'
Plugin 'yggdroot/indentline'
Plugin 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch-fuzzy.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'shougo/neomru.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kshenoy/vim-signature'
Plugin 'mhinz/vim-signify'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/syntastic'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
Plugin 'tomtom/tlib_vim'
Plugin 'shougo/unite.vim'
Plugin 'SirVer/ultisnips'
Plugin 'shougo/vimproc.vim'
Plugin 'valloric/youcompleteme'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'qpkorr/vim-bufkill'


" Future Plugins to add
" https://github.com/unblevable/quick-scope
" https://github.com/romainl/vim-qf
" https://github.com/tpope/vim-repeat
" https://github.com/wellle/targets.vim
" ---
"  Origin: https://github.com/IanConnolly/dotfiles/blob/master/vimfiles/vimrc#L472-L478
"

Plugin 'VundleVim/Vundle.vim'


call vundle#end()            " required
filetype plugin indent on    " required


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle's plugin setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"""""""""""
" Autopair
"""""""""""
let g:AutoPairsFlyMode = 1

"""""""""""
" emmet
"""""""""""

"""""""""""
" syntastic
" read: http://usevim.com/2016/03/07/linting/
"""""""""""
"
" set statusline+=%#warningmsg#                     " makes airline crash
" set statusline+=%{SyntasticStatuslineFlag()}      " makes airline crash
" set statusline+=%*                                " makes airline crash

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

"""""""""""
" ==> Svim-ruby highlight operators
"""""""""""
let ruby_operators    = 1
let ruby_no_expensive = 1


"""""""""""
" tagbar
"""""""""""
nmap <C-x>t :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_show_linenumbers = 1
let g:tagbar_singleclick = 1
let g:tagbar_autoshowtag = 1

"""""""""""
" tabular // easy align
"""""""""""

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""
" Unite
"""""""""""
" Use ag (the silver searcher)
if executable('ag')
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
endif

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source( 'buffer', 'converters', ['converter_file_directory'])

nnoremap <C-x>e :<C-u>Unite -no-split -buffer-name=recent -start-insert file_mru<cr>
nnoremap <C-x>f :<C-u>Unite -no-split -buffer-name=files -start-insert file<cr>
nnoremap <C-x>b :<C-u>Unite -no-split -buffer-name=buffer -start-insert buffer<cr>
nnoremap <C-p> :Unite -no-split -start-insert file_rec/async<cr>
nnoremap <C-x>p :Unite -no-split -start-insert -auto-preview -previewheight=35 file_rec/async<cr>
nnoremap <C-f> :Unite -no-split grep:.<cr>

"""""""""""
" NerdTree
"""""""""""
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Nerdtree behavior
let NERDTreeHighlightCursorline=1


nnoremap <C-x>l :<C-u>NERDTreeToggle<CR>


function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('rb', 'Magenta', 'none', '#ff00ff', '#151515')

"""""""""""
" Airline
"""""""""""
" Show open buffer into the airline
let g:airline_theme='onedark'

" Show list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_buffers = 25
let g:airline#extensions#tabline#show_tabs = 3
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Show tagbar
let g:airline#extensions#tagbar#enabled = 1

" limit the branch name to X characters
let g:airline#extensions#branch#displayed_head_limit = 10

" use powerfont
let g:airline_powerline_fonts = 1

"""""""""""
" EasyMotion
"""""""""""
let g:EasyMotion_do_mapping = 0 " Disable default mappings

map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

nmap <C-s> <Plug>(easymotion-overwin-f2)

map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

let g:EasyMotion_smartcase = 1

map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"""""""""""
" Fugitive
"""""""""""
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>

"""""""""""
" IndentLine
"""""""""""
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_char = '¦'

let g:indentLine_enabled = 1

"""""""""""
" multiple cursors
"""""""""""
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-b>'
let g:multi_cursor_skip_key='<C-s>'
let g:multi_cursor_quit_key='<Esc>'

"""""""""""
" Javascript plugin
"""""""""""
let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN        = "ℕ"
let g:javascript_conceal_prototype  = "¶"
let g:javascript_conceal_static     = "•"
let g:javascript_conceal_super      = "Ω"

"""""""""""
" youcompleteme
"""""""""""
let g:EclimCompletionMethod = 'omnifunc'

  " YouCompleteMe and UltiSnips compatibility, with the helper of supertab
let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*.obj,*~,*.pyc,*.so,*.swp,tmp/
set wildignore+=*.pdf,*.jpg,*.dmg,*.zip,*.png,*.gif,*DS_Store*


"Always show current position
set ruler

" Show current line
set cursorline

" Show line number in a gutter
set nu

set colorcolumn=120

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Opacity
if has("gui_macvim")
  set transparency=10
  set noantialias
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

let g:onedark_termcolors=16
colorscheme onedark
set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Set font
set guifont=Cousine\ for\ Powerline:h14


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Showing invisible characters
set list
set listchars=tab:▸\ ,trail:·,extends:»,precedes:« " Unprintable chars mapping
set fillchars=stlnc:\-,vert:\|
set showbreak=›››

autocmd BufWritePre * :%s/\s\+$//e              " remove trailing whitespace on save

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" turn around buffer
nnoremap <c-x>n :bn<CR>
nnoremap <c-x>c :bp<CR>


" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2 " remove because its not needed, due to airline

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" map CMD+S to save the current file w/e the current mode
if has("mac") || has("macunix")
  nmap <D-s> :w<CR>
  vmap <D-s> <Esc><c-s>gv
  imap <D-s> <Esc><c-s>
else
  nmap <c-s> :w<CR>
  vmap <c-s> <Esc><c-s>gv
  imap <c-s> <Esc><c-s>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ackprg = 'ag --nogroup --nocolor --column'
if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
endif

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>v :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
