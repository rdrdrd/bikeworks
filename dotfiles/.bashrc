# Sarir Khamsi
# -*- bash -*-
#
# $Id: .bashrc,v 1.245 2009/12/26 01:28:20 vav5315 Exp $
###########################################################################

# don't continue if this is NOT an interactive shell,
# "$-" are the flags passed to the script
[[ $- != *i* ]] && return 1

echo "#- In ~/.bashrc on host: $(hostname)" 1>&2

# set the window title
if [[ $TERM = 'xterm' ]]; then
   TITLE_STRING='xterm'
   echo -en "\033]2;${USER}@$(hostname)\007"
   echo -en "\033]0;${TITLE_STRING}\007"
elif [[ $TERM = 'rxvt' ]]; then
   TITLE_STRING='mrxvt'
   echo -en "\033]62;${USER}@$(hostname)\007"
   echo -en "\033]0;${TITLE_STRING}\007"
else
   TITLE_STRING='Linux'
   echo -en "\033]62;${USER}@$(hostname)\007"
   echo -en "\033]0;${TITLE_STRING}\007"
fi

function fancy_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   red=$(tty -s && tput setaf 1)
   green=$(tty -s && tput setaf 2)
   blue=$(tty -s && tput setaf 4)
   reset=$(tty -s && tput sgr0)
   h=$(echo $(hostname) | sed -e 's/^ZTU//') # short hostname
   PS1="\[$red\]\u\[$reset\]@\[$green\]$h\[$reset\]:\[$blue\]\W${addGit}\[$reset\]\$ "
   #   PS1="\[${under}\u@${h}:${blue}\W${magenta}$\] "
}
export -f fancy_ps

function host_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   red=$(tty -s && tput setaf 1)
   green=$(tty -s && tput setaf 2)
   blue=$(tty -s && tput setaf 4)
   reset=$(tty -s && tput sgr0)
   local ho=$(echo $(hostname) | sed -e 's/^ZTU//') # short hostname
   ho=$(echo $ho | sed -re 's/([a-zA-Z0-9]+).*/\1/') # remove *.ray.com
   PS1="\[$green\]$ho\[$reset\]:\[$red\]\W${addGit}\[$reset\]\$ "
}
export -f host_ps

function less_fancy_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   local red=$(tty -s && tput setaf 1)
   local green=$(tty -s && tput setaf 2)
   local blue=$(tty -s && tput setaf 4)
   local bold=$(tty -s && tput smso)
   local boldoff=$(tty -s && tput rmso)
   local magenta=$(tty -s && tput setaf 5)
   local reset=$(tty -s && tput sgr0)
   PS1="\[$red\]\W${addGit}\[$reset\]\$ "
}
export -f less_fancy_ps

function full_path_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   local red=$(tty -s && tput setaf 1)
   local green=$(tty -s && tput setaf 2)
   local blue=$(tty -s && tput setaf 4)
   local bold=$(tty -s && tput smso)
   local boldoff=$(tty -s && tput rmso)
   local magenta=$(tty -s && tput setaf 5)
   local reset=$(tty -s && tput sgr0)
   local user_='\u'
   #   local host_='\h'
   # local host=$(echo $(hostname) | sed -e 's/^ZTU//') # short hostname
   local host=$(echo $(hostname))
   PS1="\[$blue\]\[$user_\]@\[$reset\]\[$green\]$host:\[$reset\]\[$red\]\w${addGit}\[$reset\]$ "
}
export -f full_path_ps

function massive_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   local red=$(tty -s && tput setaf 1)
   local green=$(tty -s && tput setaf 2)
   local blue=$(tty -s && tput setaf 4)
   local bold=$(tty -s && tput smso)
   local boldoff=$(tty -s && tput rmso)
   local magenta=$(tty -s && tput setaf 5)
   local reset=$(tty -s && tput sgr0)
   local user_='\u'
   local host=$(echo $(hostname) | sed -e 's/^ZTU//') # short hostname
   PS1="\n\D{%Y%m%d_%H%M%S}:\[$blue\]\[$user_\]@\[$reset\]\[$green\]$host:\[$reset\]\[$red\]\w${addGit}\[$reset\]\n$ "
}
export -f massive_ps

function just_path_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   local red=$(tty -s && tput setaf 1)
   local green=$(tty -s && tput setaf 2)
   local blue=$(tty -s && tput setaf 4)
   local bold=$(tty -s && tput smso)
   local boldoff=$(tty -s && tput rmso)
   local magenta=$(tty -s && tput setaf 5)
   local reset=$(tty -s && tput sgr0)
   local user_='\u'
   local host_='\h'
   PS1="\[$blue\]\w${addGit}\[$reset\]\$ "
}
export -f just_path_ps

function medium_fancy_ps
{
   export PROMPT_NAME="$FUNCNAME"
   # for first arg, anyArg == useGit, else don't
   local addGit=''
   if [[ -n $1 ]]; then
      addGit='$(__git_ps1 "(%s)")'
      echo "Using git-completion"
   fi
   local red=$(tty -s && tput setaf 1)
   local green=$(tty -s && tput setaf 2)
   local blue=$(tty -s && tput setaf 4)
   local magenta=$(tty -s && tput setaf 5)
   local reset=$(tty -s && tput sgr0)
   local user_='\u'
   local host_='\h'
   PS1="\[$blue\]\[$user_\]@\[$reset\]\[$green\]${host_}:\[$reset\]\[$red\]\W${addGit}\[$reset\]$ "
}
export -f medium_fancy_ps

function simple_ps
{
   export PROMPT_NAME="$FUNCNAME"
   PS1="\W$ "
}
export -f simple_ps

function ps_host_and_path
{
   export PROMPT_NAME="$FUNCNAME"
   PS1="\h:\W$ "
}
export -f ps_host_and_path

if [[ $TERM != emacs ]]; then
#   less_fancy_ps useGit
   if [[ $(uname) =~ CYGWIN ]]; then
      #      less_fancy_ps
      host_ps
      export PROMPT_NAME="host_ps"
   else
      host_ps
#      full_path_ps
      export PROMPT_NAME="host_ps"
   fi
else
   simple_ps
   export PROMPT_NAME="simple_ps"
fi

function cygNOP
{
   # a dummy function to work with UNIX systems
   echo > /dev/null 2>&1
}
export -f cygNOP

# general config
umask 0002
set -o posix
shopt -s cdspell # fix spelling errors in cd command
shopt -s cmdhist # use single line commands in history file
shopt -s extglob # egrep-style pattern matching, eg, x(pattern-list)
stty -ixon # disable XON (ctrl-s) so I can forward search cmd history

# some bash control and history stuff
export HISTFILESIZE=200000
export HISTSIZE=20000
export HISTTIMEFORMAT="%Y-%m-%d %T  "
#export HISTCONTROL=ignoredups
export FIGNORE='.svn:.o:~' # ignore these files endings in completion

if [[ $TERM != emacs ]]; then
   [ -e ${SK_MAIN_DRIVE}/cm/devel/bin/.git-completion.bash ] && \
      . ${SK_MAIN_DRIVE}/cm/devel/bin/.git-completion.bash
fi

alias cygpath=cygNOP

export LC_CTYPE=en_US.UTF-8
export LC_ALL=C
#TERM=linux
#export TERM=xterm
#export LOGNAME=khamsi
export FILE_REGEX='.*\.\(c\(pp\|xx\)?\|h\(pp\)?\)$'

cdable_vars=1 # Set true to cd to variable names will work.
stderror_file="~/.bash.stderr"
cerr="2>> $stderror_file "

# debug stuff...set to some value (ie non-blank) to have bash
# functions echo only and not execute the action
export NOP=''

# general aliases
alias gstat='git status'
alias gt='gnome-terminal &'
alias gsm='gnome-system-monitor 2> /dev/null &'
alias clear1='find . -maxdepth 1 -type f -exec chmod -x {} \;'
alias rs='rs.sh'
alias addpwd='export PATH=$PATH:$(pwd)'
alias xe='xeyes -center red'
alias grep='egrep --color=auto'
alias egrep='egrep --color=auto'
alias ls="ls -CFA --color=auto"
alias ll="ls -lGg"
alias ks='ls'
alias kk="ll"
alias lh='ls -lhG'
alias rm="rm -i"
alias l2="ls -l 2> /dev/null"
alias xt="xterm -n xterm-1 -j -ls -sb -sl 5000 -rightbar -geometry +361+0 -e bash &"
alias xl="xload -update 2 &"
alias rehash='hash -r'

# Dir motion aliases
alias cdd='cd Debug'
alias l="ll"
alias u="cd ../"
alias cx='chmod -x'
alias esl='env | sort | less'
alias gb='git branch -v'
alias gba='git branch -a'
alias gr='git remote -v'

alias antlr4='java -Xmx500M -cp "$HOME/bin/antlr-4.6-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java org.antlr.v4.gui.TestRig'

# Massive bunch of bash functions
cd_file=~/.cdpaths

function f
{
   # grep all C/C++ files that contain the arg you pass in
   if [ -z "$1" ]; then
      echo usage: f regex
      return 1
   fi

   find . -iregex '.*\.[ch]\(pp\|xx\)?$' -print0 | xargs --null egrep -n "$*"
}
export -f f

function fx
{
   # use f() to exclude files with this name
   if [ -z "$1" ]; then
      echo usage: fx regex
      return 1
   fi
   f "$*" | grep -v "${1}\.\(c\|h\)\(pp\|xx\)"
}

function f1
{
   if [ "$2" = "" ]; then
      echo usage: f1 filePattern regex
      return 1
   fi

   find . -name $1 -print | xargs egrep $2 /dev/null
}

function diff_files
{
   if ! diff $1 $2 > /dev/null
   then
      echo "Config files: $1 and $2 differ!"
      return 0
   fi
   return 1
}

function fordoc
{
   echo 'for i in *.?pp'
   echo 'do'
   echo '   # stuff'
   echo 'done'
}

function myxterm
{
   fontStr=''
   if [ -z "$1" ]; then
      echo 'myxterm: use with any param for larger font'
   else
      fontStr='-fn -*-courier-*-r-*-*-*-140-*-*-*-*-*'
   fi

   MYSHELL='-e /bin/bash'
   OPTS="-sl 1000 -sb -rightbar -fg black -bg white -cr blue $fontStr"
   OPTS="${OPTS} -title ${USER}@${HOSTNAME}"
   nohup xterm  $OPTS $MYSHELL &
}

function depend
{
   if [ "$1" = '' ]; then
      echo need to pass in a filename to generate dependencies
      return 1
   fi

   g++ -MM $1
}
export -f depend

function clean_emacs
{
   local action='-delete'
   local pr='-print' # print out files if we are deleting them
   if [ -n "$NOP" ]; then
      action=''
      pr=''
   fi
   nice -4  find . -path ./.snapshot -prune -o -name '*~' -print $action
}

function clean_objs
{
   local action='-delete'
   if [ -n "$NOP" ]; then
      action=''
   fi
   nice -4 find . -regex '.*\.o\(bj\)?$' -print $action
}

function clean_vc
{
   local action='rm -f'
   local pr='-print' # print out files if we are deleting them
   if [ -n "$NOP" ]; then
      action='echo'
      pr=''
   fi
   nice -4 find . -regex '.*\(\.o\(bj\)?\|sbr\|pch\|ncb\|idb\|pdb\|ilk\|exp\|suo\)$' $pr -exec $action {} \;
   nice -4 find . -name BuildLog.htm $pr -exec $action {} \;
}

function clean_thumbs
{
   local action='-delete'
   local pr='-print' # print out files if we are deleting them
   if [[ -n $NOP ]]; then
      action=''
      pr=''
   fi
   nice -4 find . -name 'Thumbs.db' $pr $action
}

function clean_tags
{
   local action='rm -f'
   local pr='-print' # print out files if we are deleting them
   if [ -n "$NOP" ]; then
      action='echo'
      pr=''
   fi
   nice -4 find . -name 'TAGS' $pr -exec $action {} \;
}

function cleanX
{
   if [[ -z $1 ]]; then
      echo usage: cleanX item
      return 1
   fi
   local item="$1"
   local action='-delete'
   local pr='-print' # print out files if we are deleting them
   if [[ -n $NOP ]]; then
      action=''
      pr=''
   fi
   nice -4 find . -name $item $pr $action
}

function clean
{
   local toClean='emacs objs vc svn thumbs'
   if [ -z "$1" ]; then
      echo -n "usage: clean "
      echo $toClean | sed -e 's/ / \| /g'
      echo or...any combination of them separated by spaces
      return 1
   fi

   for selection in $*; do
      echo cleaning $selection ...
      if [ "$selection" = 'objs' ]; then
         clean_objs
      elif [ "$selection" = 'emacs' ]; then
         cleanX '*~'
      elif [ "$selection" = 'svn' ]; then
         cleanX svn
      elif [ "$selection" = 'vc' ]; then
         clean_vc
      elif [ "$selection" = 'thumbs' ]; then
         cleanX 'Thumbs.db'
      elif [ "$selection" = 'tags' ]; then
         cleanX 'tags'
      else
         echo 'Bad option!'
      fi
   done
}

function nox
{
   # This is a regex for the find program that will match any program
   # (script or binary)
   #
   # usage: nox [maxDepth] [-e]
   #   where 'maxDepth' (some integer) means recurse n levels deep in the
   #   dir stucture (1 = just this dir) and don't recurse and '-e' is
   #   some non-zero string and its presence just echos files instead
   #   of taking action

   local progTypes='.*\.\(exe\|pl\|py\|sh\|dll\lib\)$' # regex for prog files
   local echoOption='-e'
   local maxDepth=''
   local action='chmod -x /dev/null'

   for posArg in $@; do
      # find out if and argument is numeric...use that number as the depth
      if  expr match "$posArg" "[0-9]*$">/dev/null; then
         maxDepth="-maxdepth $posArg"
      fi
      # see if the echo option is used
      if [ $posArg = $echoOption ]; then
         action=''
      fi
   done

   # remove execute bit on all files that don't match the regex in
   find . $maxDepth ! -regex $progTypes -type f -print0 | xargs -0 $action
}

function paths1
{
   echo $PATH | sed -e 's/:/\n/g'
}

function paths2
{
   echo -e ${PATH//:/'\n'}
}

function pathsn
{
   oldIFS=$IFS
   IFS=':'
   counter=0
   for p in $PATH
   do
      echo $counter: $p
      counter=$((counter+1))
   done
   IFS=$oldIFS
}

# set the processor affinity of the United Devices process to a CPU
function udlight
{
   udProc=$(ps -W | egrep 'Grid|_R' | cut -d" " -f2-10 | sed -e 's/^ *//g')
   affinity $udProc 1
}

function fqdn
{
   # get the Fully Qualified Domain Name
   python -c "import socket; print socket.getfqdn('${1}')"
}

function pdb
{
   if [ -z "$1" ]; then
      echo usage: pdb pythonProgram [args ...]
      return 1
   fi
   pythonProgram=$(shift)
   python -m pdb $pythonProgram $*
}

function ce
{
   # ce = run Command, then Edit the output
   # This function takes the output of a command and redirects it to
   # a file, this files is then fed into an editor, and the file then
   # deleted.
   if [ -z "$1" ]; then
      echo 'usage: ce command'
      return 1
   fi

   outFile=$TMP/safeToDeleteThis$$
   eval "$*" > $outFile
   $EDITOR -nw -q $outFile
   rm -f $outFile
}

function printable
{
   # filter out all but printable characters
   # usage: printable infile outfile
   if [ -z "$2" ]; then
      echo usage: printable infile outfile
      return 1
   fi
   if [ ! -e "$1" ]; then
      echo $1 does not exist
      return 1
   fi

   local infile=$1
   local outfile=$2

   tr -cd '\11\12\40-\176' < $infile > $outfile
}

function xit
{
   # set execute bit for several type of files
   # (RCS seems to honk this up on checkin/checkout)
   local exts='py pl sh exe'
   for ext in $exts; do
      for file in *.$ext; do
         if [ -e "$file" ]; then
            chmod +x $file
         fi
      done
   done
}

function retag
{
   local appendTo=''
   if [ -n "$1" ]; then
      appendTo='--append'
   fi

   # create a TAGS file for Emacs from C++ source and header files
   # find . -regex '.*\.[cCh]\(xx\|pp\)?$' -print0 | \
   #    xargs --null /usr/bin/etags $appendTo
   cscope -bR # b == scan only, R == recurse
}

function rectag
{
   local appendTo=''
   if [ -n "$1" ]; then
      appendTo='--append'
   fi

   # create a TAGS file for Emacs from C++/Java source and header files
   find . -regex '.*\.[cChj]\(xx\|pp\|ava\)?$' -print0 | \
      xargs --null /usr/local/bin/ctags -e $appendTo
}

function retagj
{
   # retag for Java source
   local appendTo=''
   if [ -n "$1" ]; then
      appendTo='--append'
   fi

   # create a TAGS file for Emacs from C++ source and header files
   find . -regex '.*\.java$' -print0 | xargs --null /usr/bin/etags $appendTo
}

function clean_svn
{
   # find and/or delete Subversion files
   # these are files like "\.\d+$"
   local action='rm -f'
   local pr='-print' # print out files if we are deleting them
   if [ -n "$NOP" ]; then
      action='echo'
      pr=''
   fi
   find . -regex '.*\.\(r[0-9]+\|mine\)$' -print -exec $action {} \;
}

function loc
{
   # use 'locate' but select which database to use
   if [ -z "$1" ]; then
      echo loc filename [driveLetter]
      echo    where driveLetter defaults to c
      return 1
   fi
   local filename=$1
   local drive=${2:-'c'} # default to C drive
   local nameOnly=$(echo $drive | sed -e 's=/==g')
   local dbName=$HOME/.$(hostname).locatedb_$nameOnly # see udb_worker() above
   locate --database=$dbName $filename
}

function typeFunc
{
   # function version of the 'type' command
   if [ -z "$1" ]; then
      echo usage: typeFunc program
      return 1
   fi
   local prog=$1
   local returnPath=''
   local oldIFS=$IFS
   IFS=':'
   for p in $PATH
   do
      if [ -e "$p/$prog" ]; then
         returnPath=$p
      fi
   done
   echo $returnPath
}

function delayCmd
{
   # run a command after a delay of N seconds
   if [ -z "$2" ]; then
      echo usage: delayCmd delaySeconds cmd
      return 1
   fi

   local delayTime=$1
   local cmdOnly=shift
   local cmdArgs=$*
   if eval type $cmdOnly
   then
      sleep $delayTime
      echo $cmdWithArgs
      eval $cmdOnly $cmdArgs
   else
      echo delayCmd: $cmdOnly  is not a command or is not in your path
      return 1
   fi
}

function delMaps
{
   # remove all mapped drives
   alphabet=(a b e f g h i j k l m n o p q r s t u v w x y z)
   for drive in "${alphabet[@]}"
   do
      local cmd="net use ${drive}: /del"
      if [ -e "/$drive" ]; then
         echo unmapping $drive:
         $cmd > /dev/null 2>&1
      fi
   done
}

function lrm
{
   # Function to log and timestamp each file deleted with 'rm'.
   # Uses LRM_DATE_FORMAT env var to format timestamp based on the
   # man pages in the 'date' command.
   local logfile=~/.lrm
   local oldIFS=$IFS
   local dateNow=$(date ${LRM_DATE_FORMAT:-'+%F %T'})
   local rmStr=''
   for f in $*
   do
      if [ -e $f ]; then
         rmStr="$rmStr, $f"
      fi
   done
   local lines=1
   if [ -e $logfile ]; then
      lines=$(($(wc -l $logfile | sed -e 's/^\([0-9]\+\).*/\1/')+1))
   fi
   rmStr=$(echo $rmStr | sed -e 's/^, //') # remove trailing delim
   rm $*
   echo $lines: $rmStr \# $dateNow >> $logfile
}

function q
{
   # function to help answer questions on bash commands
   if [ -z "$1" ]; then
      echo usage: q bashCommand
      return 1
   fi

   local question="$1"
   if [ "$question" == 'for' ]; then
      echo 'for((i = 0; i < N; i++)); do cmd; done'
   fi
}

function ziplogs
{
   for d in *
   do
      if [ -d "$d" ]; then
         cd "$d"
         for f in *.log
         do
            if [ -e "$f" ]; then
               zipit.sh "$f"
            fi
         done
         cd ../
      fi
   done
}

function lo
{
   # function to run any command at a lower priority
   nice -n 4 $*
}

function lsrm
{
   # do an ls on $1 and ask user if they want to do an rm

   # check args
   if [ -z "$1" ]; then
      echo "usage: lsrm file(s)"
      return 1
   fi

   local files="$@"

   # only proceed if ls works, ie, files exist
   if ls $files ; then
      # read 1 char
      read -p "Delete files? " -n 1 answer
      if [ $answer == 'y' ]; then
         rm -f $files
         echo
      fi
   fi
}

function print_term_colors
{
   # print out some TERM colors
   local ending='\e[0m'
   for ((i = 0; i < 50; i++))
   do
      local color="\e[1;${i}m"
      echo -e "${color}Text line: i = ${i}${ending}"
   done
}

function loopcx
{
   # loop over files in a dir and clean the executable bit
   for f in *.*
   do
      if [ -x $f ]; then
         echo $f
         chmod -x $f
      fi
   done
}

function numprocs
{
   # return the number of CPUs
   cat /proc/cpuinfo | egrep '^processor' | wc -l
}

function del0
{
   # delete files that are zero in size and not dirs
   local startDir='.'
   if [ -n "$1" ]; then
      startDir="$1"
   fi
   find $startDir -size 0 -type f -print -delete
}

function uncx
{
   # clear the execute bit for some ordinary files
   # Any additional args will be passed to 'find'
   find . -iregex '.*\.?\(\(doc\|ppt\)x?\|pdf\|xlsx?\|tar\|txt\|zip\|gz\|jpg\|gif\|\(c\|h\)\(pp\)?\)?$' \
        -type f -print0 | xargs --null chmod -x
}

function count
{
   # issue a shell command and display the results in less with line numbers
   if [ -z "$1" ]; then
      echo usage: count someCommand
      return 1
   fi

   local ifsOrig=$IFS
   IFS=' '
   local cmd="$*"
   local tmpFile=$TMP/deleteMe.$$
   $cmd > $tmpFile 2>&1
   less -N $tmpFile
   rm -f $tmpFile
   IFS=$ifsOrig
}

function gfr
{
   # git fetch and rebase (on emacsOrg by default)
   # usage: gfr [repo [branch]]
   local repo=emacsOrg
   if [[ -n $1 ]]; then
      repo="$1"
   fi

   local branch=master
   if [[ -n $2 ]]; then
      branch="$2"
   fi

   echo "Running pull on ${repo}"
   git pull ${repo} master
#   git fetch ${repo} && git rebase ${repo}/${branch}
}

function syncGit
{
   # Sync up all my Git repos
   local repos='devel emacsOrg extern'

   for repo in $repos
   do
      if [[ -e ${SK_MAIN_DRIVE}/cm/$repo ]]; then
         pushd ${SK_MAIN_DRIVE}/cm/$repo > /dev/null 2>&1
         git pull $repo master && git push $repo master
         echo
         popd > /dev/null 2>&1
      fi
   done
}

function gst
{
   # get the Git status for abunch of my repos
   local repos='devel emacsOrg extern'
   local options=''
   [[ -n $1 ]] && options='--short'

   for repo in $repos
   do
      if [[ -e ${SK_MAIN_DRIVE}/cm/$repo ]]; then
         pushd ${SK_MAIN_DRIVE}/cm/$repo > /dev/null 2>&1
         echo -e "\nIn repo: $(pwd)"
         git status $options
         popd > /dev/null 2>&1
      fi
   done
}

function gd
{
   # do a "git diff -- FILE"
   if [[ -z $1 ]]; then
      git diff -- .
   else
      git diff -- $1
   fi
}

function gl
{
   # run log with optional args
   # format: hash user commitMessage
   git log --pretty=format:"%h %ai %an %s" $* | sed -e 's/ [+-][0-9]\{4\}//g'
   echo
}

function gll
{
   # run log with optional args
   # format: hash user commitMessage
   git log --pretty=format:"%h %ai %an %s" $*
}

function gll1
{
   # run log with optional args, list only first line
   # format: hash user commitMessage
   git log --pretty=format:"%h %ai %an %s" $* | head -n 1
}

function gchmod
{
   # helper function for the git chmod command that I can never remember
   if [ -z "$2" ]; then
      echo "usage: gchmod +x|-x file"
      return 1
   fi

   local option="$1"
   local myFile="$2"
   git update-index --chmod=$option $myFile
}

function ipadr
{
   # print out my IP address
   local ipAddress=147
   if [ -n "$1" ]; then
      ipAddress="$1"
   fi
   ipconfig | grep $ipAddress
}

function h
{
   # create an alias for 'history' and if there's an argument, tail
   # that many history items
   if [ -n "$1" ]; then
      history | tail -n $1
   else
      history
   fi
}

function git_complete
{
   if [[ $TERM != emacs ]]; then
      [ -e ${SK_MAIN_DRIVE}/cm/devel/bin/.git-completion.bash ] && . \
         ${SK_MAIN_DRIVE}/cm/devel/bin/.git-completion.bash && \
         echo "#- Using Git complete"
   fi
}

function svn_find_unversioned_files
{
   # find unversioned Subversion files
   svn status | grep '^\?' | cut -c9-
}

function svn_del_unversioned_files
{
   # delete unversioned Subversion files
   svn status | grep '^\?' | cut -c9- | xargs -d \\n rm -r
}

function common
{
   # start some of my common tools
   # usage: common [e]
   # where "e" signals starting eclipse

   if [[ $(uname) =~ Linux ]]; then
      # run some linux stuff and get out
      if type xfce4-terminal > /dev/null 2>&1
      then
         xfce4-terminal 2> /dev/null &
      else
         gnome-terminal 2> /dev/null &
      fi
      
      emacs 2> /dev/null &
      xl
#      firefox 2> /dev/null &
      return 0
   fi

   # clean up nohup first
   rm -f ~/nohup.out

   runx
   local oldTZ=$TZ
   unset TZ
   nohup runemacs > /dev/null 2>&1 &
   export TZ=$oldTZ
   while ! ps -efW | grep -i xwin > /dev/null
   do
      echo Waiting for XWindows
      sleep 1
   done
   mx &
   clock 1 &
   nohup explorer $(cygpath -d $HOME)
   nohup ${SK_MAIN_DRIVE}/usr/firefox/firefox &

   # if there's an arg, start Eclipse
   if [ "$1" = "e" ]; then
      nohup eclipse &
   fi
}

function xstuff
{
   # some things good for X-Windows
   xload -update 2 &
   gnome-terminal &
   emacs &
}

function git_pack
{
   # do some Git housekeeping
   if [[ -d ./.git ]]; then
      git fsck --full
      git gc --aggressive --prune
      git repack
   fi
}

function clock
{
   local updateRate=${1:-5}
   export DISPLAY=:0.0
   xclock -update $updateRate -digital -strftime "%F -- %H:%M:%S" -twentyfour &
}

function cleanXfiles
{
   for i in $(seq 0 10)
   do
      if [[ -e /tmp/.X${i}-lock ]]; then
         rm -f /tmp/.X${i}-lock
      fi
   done
}
export -f cleanXfiles

function cemacs
{
   # ignore all the error crap that comes out
   export USER=$(basename $HOME)
   /usr/bin/emacs -l $HOME/.emacs 2> /dev/null &
}

function updateGithub
{
   for d in *
   do
      if [[ -d $d && -e $d/.git ]]; then
         pushd $d
         git pull origin
         popd
      fi
   done
}

function myIP
{
   python3 -c 'import socket; print(socket.gethostbyname(socket.gethostname()))'
}

function myIPex
{
   # print more info
   python3 -c 'import socket; \
print(socket.gethostbyname_ex(socket.gethostname()))'
}

function clang_ast
{
   if [[ -z $1 ]]; then
      echo "usage: $FUNCNAME filename"
      return 1
   fi
   local file="$1"
   local color=''
   if [[ -n $2 ]]; then
      color='-fdiagnostics-color=never'
   fi
   clang -Xclang -ast-dump -fsyntax-only $color $file
}

function rm_dangling_commits 
{
   git reflog expire --expire-unreachable=now --all
   git gc --prune=now
}

function c
{
   # paginate a command
   if [[ -z $1 ]]; then
      echo "usage: c cmd [OPTIONS]"
      return 1
   fi

   cmd=$1
   shift

   command "$cmd" "$@" |& less -F
}

function gac
{
   if [[ -z $1 ]]; then
      echo "usage: $FUNCNAME commit_message"
      return 1
   fi
   local msg="$*"
   git add .
   git commit -m\'"${msg}"\'
}

function e
{
   # Run some command but send stderr to /dev/null
   eval $@ 2> /dev/null &
}

function getFileSysType
{
   if [[ -z $1 ]]; then
      echo "usage: $FUNCNAME path"
      return 1
   fi

   if [[ ! -e $1 ]]; then
      ehco "$1 does not exist"
      return 1
   fi

   if [[ ! -d $1 ]]; then
      ehco "$1 is not a directory"
      return 1
   fi

   local path="$1"
   df -P -T $path | tail -n +2 | awk '{print $2}'
}
export -f getFileSysType
alias get_fs_type='getFileSysType'

if [[ $(uname) =~ Linux ]]; then
   hostname -I
   export NO_AT_BRIDGE=1 # get rid of warning
fi
