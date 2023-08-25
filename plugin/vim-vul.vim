""
" @usage {}
" Run Vul against the current directory and populate the QuickFix list
command! Vul call s:Vul()

""
" @usage {}
" Install the latest version of Vul to %GOPATH/bin/Vul
command! VulInstall call s:VulInstall()


" Vul runs Vul and prints adds the results to the quick fix buffer
function! s:Vul() abort
  try
		" capture the current error format
		let errorformat = &g:errorformat

		let s:template = '"@' . expand('<sfile>:p:h:h') . '/vim-vul/csv.tpl"'
		let s:command = 'vul fs -q --security-checks vuln,config --exit-code 0 -f template --template ' . s:template . ' . | sort -u | sed -r "/^\s*$/d"'
		
 		" set the error format for use with Vul
		let &g:errorformat = '%f\,%l\,%m'
		" get the latest Vul comments and open the quick fix window with them
		cgetexpr system(s:command) | cw
		call setqflist([], 'a', {'title' : ':Vul'})
		copen
	finally
		" restore the errorformat value
		let &g:errorformat = errorformat
  endtry
endfunction

" VulInstall runs the go install command to get the latest version of Vul
function! s:VulInstall() abort
	try 
		echom "Downloading the latest version of Vul"
    let installResult = system('curl https://raw.githubusercontent.com/khulnasoft-lab/vul/main/contrib/install.sh | bash')
		if v:shell_error != 0
    	echom installResult
		else
			echom "Vul downloaded successfully"
		endif
	endtry
endfunction
