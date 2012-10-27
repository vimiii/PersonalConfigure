"==============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
"==============================================================================

"------------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
"------------------------------------------------------------------------------
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif

"------------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
"------------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif


"==============================================================================
"                          << 以下为软件默认配置 >>
"==============================================================================

"------------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
"------------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

"------------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
"------------------------------------------------------------------------------
if !g:iswindows
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        "        set mouse=a		        " Enable mouse usage (all modes)

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


"==============================================================================
"                          << 以下为用户自定义配置 >>
"==============================================================================

"------------------------------------------------------------------------------
"  < 编码配置 >
"------------------------------------------------------------------------------
"注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "gvim内部编码
set fileencoding=utf-8                                "当前文件编码
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1,big5     "支持打开文件的编码
if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

"------------------------------------------------------------------------------
"  < 编写文件时的配置 >
"------------------------------------------------------------------------------
set nocompatible                                      "关闭 Vi 兼容模式
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将tab键转换为空格
set tabstop=8                                         "设置tab键的宽度
set shiftwidth=8                                      "换行时自动缩进8个空格
"set backspace=2                                       "设置退格键可用
set smarttab                                          "指定按一次backspace就删除4个空格
set foldenable                                        "启用折叠
set foldmethod=indent                                 "indent 折叠方式
"set foldmethod=marker                                "marker 折叠方式

"用空格键来开关折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

"当文件在外部被修改，自动更新该文件
set autoread

"常规模式下输入 cs 清除行尾空格
nmap cs :%s/\s\+$//g<cr>:noh<cr>
"常规模式下输入 cm 清除行尾 ^M 符号
nmap cm :%s/\r$//g<cr>:noh<cr>

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         " 如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
"set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

" Ctrl + K 插入模式下光标向上移动
imap <c-k> <Up>

" Ctrl + J 插入模式下光标向下移动
imap <c-j> <Down>

" Ctrl + H 插入模式下光标向左移动
imap <c-h> <Left>

" Ctrl + L 插入模式下光标向右移动
imap <c-l> <Right>

"每行超过80个的字符用下划线标示
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

"------------------------------------------------------------------------------
"  < 界面配置 >
"------------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "开启状态栏信息
set cmdheight=2                                       "设置命令行的高度为2，默认为1
colorscheme Tomorrow-Night-Eighties                   "设置代码颜色主题
set cursorline                                        "突出显示当前行
"set guifont=DejaVu_Sans_Mono:h10                      "设置字体:字号（字体名称空格用下划线代替）
set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面
"au GUIEnter * simalt ~x                              "窗口启动时自动最大化
winpos 100 20                                         "指定窗口出现的位置，坐标原点在屏幕左上角
set lines=27 columns=90                              "指定窗口大小，lines为高度，columns为宽度

"个性化状栏（增加了文件编码的显示，去掉注释即可）
set statusline=%F%m%r%h%w\ %=%{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\"}\ \|\ %l,%v\ \|\ %p%%

"显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
    \set guioptions-=m <Bar>
    \set guioptions-=T <Bar>
    \set guioptions-=r <Bar>
    \set guioptions-=L <Bar>
    \else <Bar>
    \set guioptions+=m <Bar>
    \set guioptions+=T <Bar>
    \set guioptions+=r <Bar>
    \set guioptions+=L <Bar>
    \endif<CR>
endif

"------------------------------------------------------------------------------
"  < 编译、连接、运行配置 >
"------------------------------------------------------------------------------
" F9 一键保存、编译、连接存并运行
map <F9> :call Run()<CR>
imap <F9> <ESC>:call Run()<CR>

" Ctrl + F9 一键保存并编译
map <c-F9> :call Compile()<CR>
imap <c-F9> <ESC>:call Compile()<CR>

" Ctrl + F10 一键保存并连接
map <c-F10> :call Link()<CR>
imap <c-F10> <ESC>:call Link()<CR>

let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Sou_Error = 0

func! Compile()
    exe ":ccl"
    exe ":update"
    if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
        let s:Sou_Error = 0
        let s:LastShellReturn_C = 0
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        let Obj_Name = expand("%:p:t:r").s:Obj_Extension
        let v:statusmsg = ''
        if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
            redraw!
            if expand("%:e") == "c"
                if g:iswindows
                    setlocal makeprg=gcc\ -std=c99\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o
                else
                    setlocal makeprg=gcc\ -std=c99\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                if g:iswindows
                    setlocal makeprg=g++\ -std=c++98\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o
                else
                    setlocal makeprg=g++\ -std=c++98\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_C = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_C != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " compilation failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " compilation successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " compilation successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Obj_Name"is up to date"
        endif
    else
        let s:Sou_Error = 1
        echohl WarningMsg | echo " please choose the correct source file"
    endif
    setlocal makeprg=make
endfunc

func! Link()
    call Compile()
    if s:Sou_Error || s:LastShellReturn_C != 0
        return
    endif
    let s:LastShellReturn_L = 0
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
        let Exe_Name = expand("%:p:t:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
        let Exe_Name = expand("%:p:t:r")
    endif
    let v:statusmsg = ''
	if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        redraw!
        if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
            if expand("%:e") == "c"
                setlocal makeprg=gcc\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                setlocal makeprg=g++\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_L = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_L != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " linking failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " linking successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " linking successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Exe_Name"is up to date"
        endif
    endif
    setlocal makeprg=make
endfunc

func! Run()
    let s:ShowWarning = 0
    call Link()
    let s:ShowWarning = 1
    if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
        return
    endif
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
    endif
    if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
        redraw!
        echohl WarningMsg | echo " running..."
        if g:iswindows
            exe ":!%<.exe"
        else
            if g:isGUI
                exe ":!gnome-terminal -e ./%<"
            else
                exe ":!./%<"
            endif
        endif
        redraw!
        echohl WarningMsg | echo " running finish"
    endif
endfunc

"------------------------------------------------------------------------------
"  < 其它配置 >
"------------------------------------------------------------------------------
set writebackup                             "设置无写入备份
set nobackup                                "设置无备份文件
"set noswapfile                              "设置无临时文件
set vb t_vb=                                "关闭提示音


"==============================================================================
"                          << 以下为常用插件配置 >>
"==============================================================================

"------------------------------------------------------------------------------
"  < ctags 插件配置 >
"------------------------------------------------------------------------------
"对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags=./tags;                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）

"------------------------------------------------------------------------------
"  < cscope 插件配置 >
"------------------------------------------------------------------------------
"用Cscope自己的话说 - "你可以把它当做是超过频的ctags"
if has("cscope")
    "设定可以使用 quickfix 窗口来查看 cscope 结果
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    "使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转
    set cscopetag
    "如果你想反向搜索顺序设置为1
    set csto=0
    "在当前目录中添加任何数据库
    if filereadable("cscope.out")
        cs add cscope.out
    "否则添加数据库环境中所指出的
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose
    "快捷键设置
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

"------------------------------------------------------------------------------
"  < TagList 插件配置 >
"------------------------------------------------------------------------------
"高效地浏览源码, 其功能就像vc中的workpace 
"那里面列出了当前文件中的所有宏,全局变量, 函数名等

"常规模式下输入 tl 调用插件
nmap tl :Tlist<cr>

let Tlist_Show_One_File=1                   "只显示当前文件的tags
"let Tlist_Enable_Fold_Column=0              "使taglist插件不显示左边的折叠行
let Tlist_Exit_OnlyWindow=1                 "如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_File_Fold_Auto_Close=1            "自动折叠
let Tlist_WinWidth=25                       "设置窗口宽度
"let Tlist_Use_Right_Window=1                "在右侧窗口中显示

"------------------------------------------------------------------------------
"  < SrcExpl 插件配置 >
"------------------------------------------------------------------------------
"增强源代码浏览，其功能就像Windows中的"Source Insight"
":SrcExpl                                   "打开浏览窗口
":SrcExplClose                              "关闭浏览窗口
":SrcExplToggle                             "打开/闭浏览窗口

"------------------------------------------------------------------------------
"  < Tagbar 插件配置 >
"------------------------------------------------------------------------------
"相对 TagList 能更好的支持面向对象

"常规模式下输入 tb 调用插件
nmap tb :TagbarToggle<cr>

let g:tagbar_width=25                       "设置窗口宽度
"let g:tagbar_left=1                         "在左侧窗口中显示

"------------------------------------------------------------------------------
"  < WinManager 插件配置 >
"------------------------------------------------------------------------------
"管理各个窗口, 或者说整合各个窗口

"常规模式下输入 F3 调用插件
nmap <F3> :WMToggle<cr>
"这里可以设置为多个窗口, 如'FileExplorer|TagList'
let g:winManagerWindowLayout='FileExplorer|TagList'

let g:persistentBehaviour=0                 "只剩一个窗口时, 退出vim
let g:winManagerWidth=25                    "设置窗口宽度

"------------------------------------------------------------------------------
"  < MiniBufExplorer 插件配置 >
"------------------------------------------------------------------------------
"快速浏览和操作Buffer 
"主要用于同时打开多个文件并相与切换

let g:miniBufExplMapWindowNavArrows = 1     "用Ctrl加方向键切换到上下左右的窗口中去
let g:miniBufExplMapWindowNavVim = 1        "用<C-k,j,h,l>切换到上下左右的窗口中去
let g:miniBufExplMapCTabSwitchBufs = 1      "功能增强（不过好像只有在Windows中才有用）
"                                            <C-Tab> 向前循环切换到每个buffer上,并在但前窗口打开
"                                            <C-S-Tab> 向后循环切换到每个buffer上,并在当前窗口打开

"------------------------------------------------------------------------------
"  < BufExplorer 插件配置 >
"------------------------------------------------------------------------------
"快速轻松的在缓存中切换（相当于另一种多个文件间的切换方式）
"<Leader>be 在当前窗口显示缓存列表并打开选定文件
"<Leader>bs 水平分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件
"<Leader>bv 垂直分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件

"------------------------------------------------------------------------------
"  < NERD_commenter 插件配置 >
"------------------------------------------------------------------------------
"我主要用于C/C++代码注释(其它的也行)
"以下为插件默认快捷键，其中的说明是以C/C++为例的
"<Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
"<Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
"<Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
"<Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
"<Leader>cA 行尾注释，我对此功能做了一点修改（添加了插入模式下的键映射，也实现
"           了注释对齐，这个对齐是指待注释行的代码少于49列就将注释以50列开始，
"           如果大于或等于49列就按原默认方式注释，具体用法就待你去体会了）
"<Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）

"------------------------------------------------------------------------------
"  < vimtweak 插件配置 > 请确保以安装了插件
"------------------------------------------------------------------------------
"这里只用于窗口透明与置顶
"常规模式下 Shift + k 减小透明度，Shift + j 增加透明度，<Leader>t 窗口置顶与否切换
if (g:iswindows && g:isGUI)
    let g:Current_Alpha = 255
    let g:Top_Most = 0
    func! Alpha_add()
        let g:Current_Alpha = g:Current_Alpha + 10
        if g:Current_Alpha > 255
            let g:Current_Alpha = 255
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Alpha_sub()
        let g:Current_Alpha = g:Current_Alpha - 10
        if g:Current_Alpha < 155
            let g:Current_Alpha = 155	
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Top_window()
        if  g:Top_Most == 0
            call libcallnr("vimtweak.dll","EnableTopMost",1)
            let g:Top_Most = 1
        else
            call libcallnr("vimtweak.dll","EnableTopMost",0)
            let g:Top_Most = 0
        endif
    endfunc
    "快捷键设置
    map <s-k> :call Alpha_add()<cr>
    map <s-j> :call Alpha_sub()<cr>
    map <leader>t :call Top_window()<cr>
endif

"------------------------------------------------------------------------------
"  < gvimfullscreen 插件配置 > 请确保以安装了插件
"------------------------------------------------------------------------------
"用于 Windows Gvim 全屏窗口，可用 F11 切换
"全屏后再隐藏菜单栏、工具栏、滚动条效果更好
if (g:iswindows && g:isGUI)
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

"------------------------------------------------------------------------------
"  < indent_guides 插件配置 >
"------------------------------------------------------------------------------
"用于显示对齐线
"默认键盘映射为 <leader>ig
let g:indent_guides_guide_size=1            "设置对齐线宽度为1
let g:indent_guides_guide_enable_on_vim_startup = 1            "启动vim时候启动对齐线

"------------------------------------------------------------------------------
"  < omnicppcomplete 插件配置 >
"------------------------------------------------------------------------------
"用于C/C++代码补全，这种补全主要针对命名空间、类、结构、共同体等进行补全，详细
"说明可以参考帮助或网络教程等
"使用前先执行如下 ctags 命令
"ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
"我使用上面的参数生成标签后，对函数使用跳转时会出现多个选择
"所以我就将--c++-kinds=+p参数给去掉了，如果大侠有什么其它解决方法希望不要保留呀
set completeopt=menu                        "关闭预览窗口

"------------------------------------------------------------------------------
"  < snipMate 插件配置 >
"------------------------------------------------------------------------------
"用于各种代码补全，这种补全是一种对代码中的词与代码块的缩写补全，详细用法可以参
"考使用说明或网络教程等。不过有时候也会与 supertab 插件在补全时产生冲突，如果大
"侠有什么其它解决方法希望不要保留呀

"------------------------------------------------------------------------------
"  < supertab 插件配置 >
"------------------------------------------------------------------------------
"我主要用于配合 omnicppcomplete 插件，在按 Tab 键时自动补全效果更好更快

"------------------------------------------------------------------------------
"  < a.vim 插件配置 >
"------------------------------------------------------------------------------
"用于切换C/C++头文件
":A     ---切换头文件并独占整个窗口
":AV    ---切换头文件并垂直分割窗口
":AS    ---切换头文件并水平分割窗口

"------------------------------------------------------------------------------
"  < txtbrowser 插件配置 >
"------------------------------------------------------------------------------
"用于文本文件生成标签与与语法高亮（调用TagList插件生成标签，如果可以）
au BufEnter *.txt setlocal ft=txt

"------------------------------------------------------------------------------
"  < visualmark 插件配置 >
"------------------------------------------------------------------------------
"用于生成标签(按下Ctrl + F2)
"F2 正向浏览标签，Shift + F2逆向浏览标签 

"------------------------------------------------------------------------------
"  < auto-pairs 插件配置 >
"------------------------------------------------------------------------------
"用于括号与引号自动补全，不过会与函数原型提示插件echofunc冲突
"所以我就没有加入echofunc插件

"------------------------------------------------------------------------------
"  < cSyntaxAfter 插件配置 >
"------------------------------------------------------------------------------
"高亮括号与运算符等
autocmd! BufRead,BufNewFile,BufEnter *.{c,cpp,h,javascript} call CSyntaxAfter()

"------------------------------------------------------------------------------
"  < std_c 语法文件配置 >
"------------------------------------------------------------------------------
"用于增强C语法高亮

"启用 // 注视风格
let c_cpp_comments = 0

"------------------------------------------------------------------------------
"  < 其它 >
"------------------------------------------------------------------------------
"注：上面配置中的"<Leader>"在本软件中设置为"\"键（引号里的反斜杠），如<Leader>t
"指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
"秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键
