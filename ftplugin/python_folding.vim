setlocal foldmethod=expr
setlocal foldexpr=PythonFoldExpr(v:lnum)
setlocal foldtext=PythonFoldText()

" Only do this once
if exists('*PythonFoldText()')
    finish
endif
    
function! PythonFoldText()

    let size = 1 + v:foldend - v:foldstart
    if size < 10
        let size = " " . size
    endif
    if size < 100
        let size = " " . size
    endif
    if size < 1000
        let size = " " . size
    endif
    
    if match(getline(v:foldstart), '"""') >= 0
        let text = substitute(getline(v:foldstart), '"""', '', 'g' ) . ' '
    elseif match(getline(v:foldstart), "'''") >= 0
        let text = substitute(getline(v:foldstart), "'''", '', 'g' ) . ' '
    else
        let text = getline(v:foldstart)
    endif
    
    return size . ' lines:'. text . ' '

endfunction

function! PythonFoldExpr(lnum)

    if indent( nextnonblank(a:lnum) ) == 0
        return 0
    endif
    
    if getline(a:lnum-1) =~ '^\(class\|def\)\s'
        return 1
    endif
        
    if getline(a:lnum) =~ '^\s*$'
        return "="
    endif
    
    if indent(a:lnum) == 0
        return 0
    endif

    return '='

endfunction

" In case folding breaks down
function! PythonReFold()
    setlocal foldmethod=expr
    setlocal foldexpr=0
    setlocal foldnestmax=1
    setlocal foldmethod=expr
    setlocal foldexpr=PythonFoldExpr(v:lnum)
    setlocal foldtext=PythonFoldText()
    redraw!
endfunction

