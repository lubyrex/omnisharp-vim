if !OmniSharp#util#CheckCapabilities() | finish | endif

let s:save_cpo = &cpoptions
set cpoptions&vim

if !g:OmniSharp_server_stdio
  " Load python helper functions
  call OmniSharp#py#Bootstrap()
endif

function! OmniSharp#GetHost(...) abort
  let bufnr = a:0 ? a:1 : bufnr('%')
  if g:OmniSharp_server_stdio
    " Using the stdio server, b:OmniSharp_host is a dict containing the
    " `sln_or_dir` and an `initialized` flag indicating whether this buffer has
    " successfully been registered with the server:
    " { 'sln_or_dir': '/path/to/solution_or_dir', 'initialized': 1 }
    let host = getbufvar(bufnr, 'OmniSharp_host', {})
    if get(host, 'sln_or_dir', '') ==# ''
      let host.sln_or_dir = OmniSharp#FindSolutionOrDir(1, bufnr)
      let host.initialized = 0
      call setbufvar(bufnr, 'OmniSharp_host', host)
    endif
    " The returned dict includes the job, but the job is _not_ part of
    " b:OmniSharp_host. It is important to always fetch the job from
    " OmniSharp#proc#GetJob, ensuring that the job properties (job.job_id,
    " job.loaded, job.pid etc.) are always correct and up-to-date.
    return extend(copy(host), { 'job': OmniSharp#proc#GetJob(host.sln_or_dir) })
  else
    " Using the HTTP server, b:OmniSharp_host is a localhost URL
    if empty(getbufvar(bufnr, 'OmniSharp_host'))
      let sln_or_dir = OmniSharp#FindSolutionOrDir(1, bufnr)
      let port = OmniSharp#py#GetPort(sln_or_dir)
      if port == 0
        return ''
      endif
      let host = get(g:, 'OmniSharp_host', 'http://localhost:' . port)
      call setbufvar(bufnr, 'OmniSharp_host', host)
    endif
    return getbufvar(bufnr, 'OmniSharp_host')
  endif
endfunction


function! OmniSharp#Complete(findstart, base) abort
  if a:findstart
    "locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~# '\v[a-zA-z0-9_]'
      let start -= 1
    endwhile
    return start
  else
    return OmniSharp#actions#complete#Get(a:base)
  endif
endfunction


function! OmniSharp#CodeCheck(...) abort
  call s:WarnObsolete('OmniSharp#actions#diagnostics#Check()')
  call OmniSharp#actions#diagnostics#Check(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#CodeFormat(...) abort
  call s:WarnObsolete('OmniSharp#actions#format#Format()')
  call OmniSharp#actions#format#Format(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#CountCodeActions(...) abort
  call s:WarnObsolete('OmniSharp#actions#codeactions#Count()')
  call OmniSharp#actions#codeactions#Count(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#FindImplementations(...) abort
  call s:WarnObsolete('OmniSharp#actions#implementations#Find()')
  call OmniSharp#actions#implementations#Find(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#FindMembers(...) abort
  call s:WarnObsolete('OmniSharp#actions#members#Find()')
  call OmniSharp#actions#members#Find(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#FindSymbol(...) abort
  call s:WarnObsolete('OmniSharp#actions#symbols#Find()')
  call OmniSharp#actions#symbols#Find(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#FindUsages(...) abort
  call s:WarnObsolete('OmniSharp#actions#usages#Find()')
  call OmniSharp#actions#usages#Find(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#FixUsings(...) abort
  call s:WarnObsolete('OmniSharp#actions#usings#Fix()')
  call OmniSharp#actions#usings#Fix(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#GetCodeActions(mode) range abort
  call s:WarnObsolete('OmniSharp#actions#codeactions#Get()')
  call OmniSharp#actions#codeactions#Get(a:mode)
endfunction

function! OmniSharp#GlobalCodeCheck() abort
  call s:WarnObsolete('OmniSharp#actions#diagnostics#CheckGlobal()')
  call OmniSharp#actions#diagnostics#CheckGlobal()
endfunction

function! OmniSharp#GotoDefinition(...) abort
  call s:WarnObsolete('OmniSharp#actions#definition#Find()')
  call OmniSharp#actions#definition#Find(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#HighlightBuffer() abort
  call s:WarnObsolete('OmniSharp#actions#highlight#Buffer()')
  call OmniSharp#actions#highlight#Buffer()
endfunction

function OmniSharp#HighlightEchoKind() abort
  call s:WarnObsolete('OmniSharp#actions#highlight#Echo()')
  call OmniSharp#actions#highlight#Echo()
endfunction

function! OmniSharp#NavigateDown() abort
  call s:WarnObsolete('OmniSharp#actions#navigate#Down()')
  call OmniSharp#actions#navigate#Down()
endfunction

function! OmniSharp#NavigateUp() abort
  call s:WarnObsolete('OmniSharp#actions#navigate#Up()')
  call OmniSharp#actions#navigate#Up()
endfunction

function! OmniSharp#OpenLog(...) abort
  call s:WarnObsolete('OmniSharp#log#Open()')
  call OmniSharp#log#Open(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#PreviewDefinition(...) abort
  call s:WarnObsolete('OmniSharp#actions#definition#Preview()')
  call OmniSharp#actions#definition#Preview(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#PreviewImplementation() abort
  call s:WarnObsolete('OmniSharp#actions#implementations#Preview()')
  call OmniSharp#actions#implementations#Preview()
endfunction

function! OmniSharp#Rename() abort
  call s:WarnObsolete('OmniSharp#actions#rename#Prompt()')
  call OmniSharp#actions#rename#Prompt()
endfunction

function! OmniSharp#RenameTo(renameto, ...) abort
  call s:WarnObsolete('OmniSharp#actions#rename#To()')
  call OmniSharp#actions#rename#To(a:renameto, a:0 ? a:1 : 0)
endfunction

function! OmniSharp#RunTest() abort
  call s:WarnObsolete('OmniSharp#actions#test#Run()')
  call OmniSharp#actions#test#Run()
endfunction

function! OmniSharp#RunTestsInFile(...) abort
  call s:WarnObsolete('OmniSharp#actions#test#RunInFile()')
  call OmniSharp#actions#test#RunInFile(a:0 ? a:000 : 0)
endfunction

function! OmniSharp#SignatureHelp() abort
  call s:WarnObsolete('OmniSharp#actions#signature#SignatureHelp()')
  call OmniSharp#actions#signature#SignatureHelp()
endfunction

function! OmniSharp#TypeLookupWithDocumentation(...) abort
  call s:WarnObsolete('OmniSharp#actions#documentation#Documentation()')
  call OmniSharp#actions#documentation#Documentation(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#TypeLookupWithoutDocumentation(...) abort
  call s:WarnObsolete('OmniSharp#actions#documentation#TypeLookup()')
  call OmniSharp#actions#documentation#TypeLookup(a:0 ? a:1 : 0)
endfunction

function! OmniSharp#UpdateBuffer(...) abort
  call s:WarnObsolete('OmniSharp#actions#buffer#Update()')
  call OmniSharp#actions#buffer#Update(a:0 ? a:1 : 0)
endfunction

function! s:WarnObsolete(newName) abort
  echohl WarningMsg
  echomsg printf('This function is obsolete; use %s instead', a:newName)
  echohl None
endfunction


function! OmniSharp#IsAnyServerRunning() abort
  return !empty(OmniSharp#proc#ListRunningJobs())
endfunction

function! OmniSharp#IsServerRunning(...) abort
  let opts = a:0 ? a:1 : {}
  if has_key(opts, 'sln_or_dir')
    let sln_or_dir = opts.sln_or_dir
  else
    let bufnr = get(opts, 'bufnum', bufnr('%'))
    let sln_or_dir = OmniSharp#FindSolutionOrDir(1, bufnr)
  endif
  if empty(sln_or_dir)
    return 0
  endif

  let running = OmniSharp#proc#IsJobRunning(sln_or_dir)

  if g:OmniSharp_server_stdio
    if !running
      return 0
    endif
  else
    " If the HTTP port is hardcoded, another vim instance may be running the
    " server, so we don't look for a running job and go straight to the network
    " check. Note that this only applies to HTTP servers - Stdio servers must be
    " started by _this_ vim session.
    if !OmniSharp#py#IsServerPortHardcoded(sln_or_dir) && !running
      return 0
    endif
  endif

  if g:OmniSharp_server_stdio
    return OmniSharp#proc#GetJob(sln_or_dir).loaded
  else
    return OmniSharp#py#CheckAlive(sln_or_dir)
  endif
endfunction

" Find the solution or directory for this file.
function! OmniSharp#FindSolutionOrDir(...) abort
  let interactive = a:0 ? a:1 : 1
  let bufnr = a:0 > 1 ? a:2 : bufnr('%')
  if empty(getbufvar(bufnr, 'OmniSharp_buf_server'))
    let dir = s:FindServerRunningOnParentDirectory(bufnr)
    if !empty(dir)
      call setbufvar(bufnr, 'OmniSharp_buf_server', dir)
    else
      try
        let sln = s:FindSolution(interactive, bufnr)
        call setbufvar(bufnr, 'OmniSharp_buf_server', sln)
      catch
        return ''
      endtry
    endif
  endif

  return getbufvar(bufnr, 'OmniSharp_buf_server')
endfunction

function! OmniSharp#StartServerIfNotRunning(...) abort
  if OmniSharp#FugitiveCheck() | return | endif
  " Bail early in this check if the file is a metadata file
  if type(get(b:, 'OmniSharp_metadata_filename')) == type('') | return | endif
  let sln_or_dir = a:0 ? a:1 : ''
  call OmniSharp#StartServer(sln_or_dir, 1)
endfunction

function! OmniSharp#FugitiveCheck() abort
  return &buftype ==# 'nofile'
  \ || match(expand('%:p'), '\vfugitive:(///|\\\\)' ) == 0
endfunction

function! OmniSharp#StartServer(...) abort
  let sln_or_dir = a:0 && a:1 !=# '' ? fnamemodify(a:1, ':p') : ''
  let check_is_running = a:0 > 1 && a:2

  if sln_or_dir !=# ''
    if filereadable(sln_or_dir)
      let file_ext = fnamemodify(sln_or_dir, ':e')
      if file_ext !=? 'sln'
        call OmniSharp#util#EchoErr(
        \ printf("'%s' is not a solution file", sln_or_dir))
        return
      endif
    elseif !isdirectory(sln_or_dir)
      call OmniSharp#util#EchoErr(
      \ printf("'%s' is not a solution file or directory", sln_or_dir))
      return
    endif
  else
    let sln_or_dir = OmniSharp#FindSolutionOrDir()
    if empty(sln_or_dir)
      if expand('%:e') ==? 'csx' || expand('%:e') ==? 'cake'
        " .csx and .cake files do not require solutions or projects
        let sln_or_dir = expand('%:p:h')
      else
        call OmniSharp#util#EchoErr(
        \ 'Could not find a solution or project to start server with')
        return
      endif
    endif
  endif

  " Optionally perform check if server is already running
  if check_is_running
    let job = OmniSharp#proc#GetJob(sln_or_dir)
    if type(job) == type({}) && get(job, 'stopped')
      " The job has been manually stopped - do not start it again until
      " instructed
      return
    endif
    let running = OmniSharp#proc#IsJobRunning(sln_or_dir)
    if !g:OmniSharp_server_stdio
      " If the port is hardcoded, we should check if any other vim instances
      " have started this server
      if !running && OmniSharp#py#IsServerPortHardcoded(sln_or_dir)
        let running = OmniSharp#IsServerRunning({ 'sln_or_dir': sln_or_dir })
      endif
    endif
    if running | return | endif
  endif

  call s:StartServer(sln_or_dir)
endfunction

function! s:StartServer(sln_or_dir) abort
  if OmniSharp#proc#IsJobRunning(a:sln_or_dir)
    call OmniSharp#util#EchoErr(
    \ printf("OmniSharp is already running '%s'", a:sln_or_dir))
    return
  endif

  let l:command = OmniSharp#util#GetStartCmd(a:sln_or_dir)

  if l:command ==# []
    call OmniSharp#util#EchoErr(
    \ 'Failed to build command to start the OmniSharp server')
    return
  endif

  call OmniSharp#proc#Start(command, a:sln_or_dir)
  if g:OmniSharp_server_stdio
    let b:OmniSharp_host = {
    \ 'sln_or_dir': a:sln_or_dir
    \}
  endif
endfunction

function! OmniSharp#StopAllServers() abort
  for sln_or_dir in OmniSharp#proc#ListRunningJobs()
    call OmniSharp#StopServer(1, sln_or_dir)
  endfor
endfunction

function! OmniSharp#StopServer(...) abort
  let force = a:0 ? a:1 : 0
  let sln_or_dir = a:0 > 1 ? a:2 : OmniSharp#FindSolutionOrDir()
  if force || OmniSharp#proc#IsJobRunning(sln_or_dir)
    if !g:OmniSharp_server_stdio
      call OmniSharp#py#Uncache(sln_or_dir)
    endif
    call OmniSharp#proc#StopJob(sln_or_dir)
  endif
endfunction

function! OmniSharp#RestartServer() abort
  let sln_or_dir = OmniSharp#FindSolutionOrDir()
  if empty(sln_or_dir)
    call OmniSharp#util#EchoErr('Could not find solution file or directory')
    return
  endif
  call OmniSharp#StopServer(1, sln_or_dir)
  sleep 500m
  call s:StartServer(sln_or_dir)
endfunction

function! OmniSharp#RestartAllServers() abort
  let running_jobs = OmniSharp#proc#ListRunningJobs()
  for sln_or_dir in running_jobs
    call OmniSharp#StopServer(1, sln_or_dir)
  endfor
  sleep 500m
  for sln_or_dir in running_jobs
    call s:StartServer(sln_or_dir)
  endfor
endfunction


function! s:FindSolution(interactive, bufnr) abort
  let solution_files = s:FindSolutionsFiles(a:bufnr)
  if empty(solution_files)
    return ''
  endif

  if len(solution_files) == 1
    return solution_files[0]
  elseif g:OmniSharp_sln_list_index > -1 &&
  \      g:OmniSharp_sln_list_index < len(solution_files)
    return solution_files[g:OmniSharp_sln_list_index]
  else
    if g:OmniSharp_autoselect_existing_sln
      if !g:OmniSharp_server_stdio
        let running_slns = OmniSharp#py#FindRunningServer(solution_files)
        if len(running_slns) == 1
          return running_slns[0]
        endif
      endif
      if exists('s:selected_sln')
        " Return the previously selected solution
        return s:selected_sln
      endif
    endif

    if !a:interactive
      throw 'Ambiguous solution file'
    endif

    let labels = ['Solution:']
    let index = 1
    for solutionfile in solution_files
      call add(labels, index . '. ' . solutionfile)
      let index += 1
    endfor

    let choice = inputlist(labels)

    if choice <= 0 || choice > len(solution_files)
      throw 'No solution selected'
    endif
    let s:selected_sln = solution_files[choice - 1]
    return s:selected_sln
  endif
endfunction

function! s:FindServerRunningOnParentDirectory(bufnr) abort
  let filename = expand('#' . a:bufnr . ':p')
  let longest_dir_match = ''
  let longest_dir_length = 0
  let running_jobs = OmniSharp#proc#ListRunningJobs()
  for sln_or_dir in running_jobs
    if isdirectory(sln_or_dir) && s:DirectoryContainsFile(sln_or_dir, filename)
      let dir_length = len(sln_or_dir)
      if dir_length > longest_dir_length
        let longest_dir_match = sln_or_dir
        let longest_dir_length = dir_length
      endif
    endif
  endfor
  return longest_dir_match
endfunction

function! s:DirectoryContainsFile(directory, file) abort
  let idx = stridx(a:file, a:directory)
  return (idx == 0)
endfunction


let s:plugin_root_dir = expand('<sfile>:p:h:h')

function! OmniSharp#Install(...) abort
  if exists('g:OmniSharp_server_path')
    echohl WarningMsg
    echomsg 'Installation not attempted, g:OmniSharp_server_path defined.'
    echohl None
    return
  endif

  echo 'Installing OmniSharp Roslyn, please wait...'

  call OmniSharp#StopAllServers()

  let l:http = g:OmniSharp_server_stdio ? '' : '-H'
  let l:version = a:0 > 0 ? '-v ' . shellescape(a:1) : ''
  let l:location = shellescape(g:OmniSharp_server_install)

  if has('win32')
    let l:logfile = s:plugin_root_dir . '\log\install.log'
    let l:script = shellescape(
    \ s:plugin_root_dir . '\installer\omnisharp-manager.ps1')
    let l:version_file_location = l:location . '\OmniSharpInstall-version.txt'

    let l:command = printf(
    \ 'powershell -ExecutionPolicy Bypass -File %s %s -l %s %s',
    \ l:script, l:http, l:location, l:version)
  else
    let l:logfile = s:plugin_root_dir . '/log/install.log'
    let l:script = shellescape(
    \ s:plugin_root_dir . '/installer/omnisharp-manager.sh')
    let l:mono = g:OmniSharp_server_use_mono ? '-M' : ''
    let l:version_file_location = l:location . '/OmniSharpInstall-version.txt'

    let l:command = printf('/bin/sh %s %s %s -l %s %s',
    \ l:script, l:http, l:mono, l:location, l:version)
  endif

  " Begin server installation
  let l:error_msgs = systemlist(l:command)

  if v:shell_error
    " Log executed command and full error log
    call writefile(['> ' . l:command, repeat('=', 80)], l:logfile)
    call writefile(l:error_msgs, l:logfile, 'a')

    echohl ErrorMsg
    echomsg 'Failed to install the OmniSharp-Roslyn server'

    " Display extra error information for Unix users
    if !has('win32')
      echomsg l:error_msgs[-1]
    endif

    echohl WarningMsg
    echomsg 'The full error log can be found in the file: ' l:logfile
    echohl None
  else
    let l:version = ''
    try
      let l:command = has('win32') ? 'type ' : 'cat '
      let l:version = trim(system(l:command . l:version_file_location)) . ' '
    catch | endtry
    echohl Title
    echomsg printf('OmniSharp-Roslyn %sinstalled to %s', l:version, l:location)
    echohl None
  endif
endfunction


function! s:FindSolutionsFiles(bufnr) abort
  "get the path for the current buffer
  let dir = expand('#' . a:bufnr . ':p:h')
  let lastfolder = ''
  let solution_files = []

  while dir !=# lastfolder
    let solution_files += s:globpath(dir, '*.sln')
    let solution_files += s:globpath(dir, 'project.json')

    call filter(solution_files, 'filereadable(v:val)')

    if g:OmniSharp_prefer_global_sln
      let global_solution_files = s:globpath(dir, 'global.json')
      call filter(global_solution_files, 'filereadable(v:val)')
      if !empty(global_solution_files)
        let solution_files = [dir]
        break
      endif
    endif

    if !empty(solution_files)
      return solution_files
    endif

    let lastfolder = dir
    let dir = fnamemodify(dir, ':h')
  endwhile

  if empty(solution_files)
    let dir = expand('#' . a:bufnr . ':p:h')
    let lastfolder = ''
    let solution_files = []

    while dir !=# lastfolder
      let solution_files += s:globpath(dir, '*.csproj')

      call uniq(map(solution_files, 'fnamemodify(v:val, ":h")'))

      if !empty(solution_files)
        return solution_files
      endif

      let lastfolder = dir
      let dir = fnamemodify(dir, ':h')
    endwhile
  endif

  if empty(solution_files) && g:OmniSharp_start_without_solution
    let solution_files = [getcwd()]
  endif

  return solution_files
endfunction

if has('patch-7.4.279')
  function! s:globpath(path, file) abort
    return globpath(a:path, a:file, 1, 1)
  endfunction
else
  function! s:globpath(path, file) abort
    return split(globpath(a:path, a:file, 1), "\n")
  endfunction
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
