# -*- mode: shell-script -*-
#
# Shell functions to act as wrapper for Ian Bicking's virtualenv
# (http://pypi.python.org/pypi/virtualenv)
#
#
# Copyright Doug Hellmann, All Rights Reserved
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appear in all copies and that
# both that copyright notice and this permission notice appear in
# supporting documentation, and that the name of Doug Hellmann not be used
# in advertising or publicity pertaining to distribution of the software
# without specific, written prior permission.
#
# DOUG HELLMANN DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
# EVENT SHALL DOUG HELLMANN BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
#
# Project home page: http://www.doughellmann.com/projects/virtualenvwrapper/
#
#
# Setup:
#
#  1. Create a directory to hold the virtual environments.
#     (mkdir $HOME/.virtualenvs).
#  2. Add a line like "export WORKON_HOME=$HOME/.virtualenvs"
#     to your .cshrc.
#  3. Add a line like "source /path/to/virtualenvwrapper.csh "
#     to your .cshrc.
#  4. Run: source ~/.cshrc
#  5. Run: workon
#  6. A list of environments, empty, is printed.
#  7. Run: mkvirtualenv temp
#  8. Run: workon
#  9. This time, the "temp" environment is included.
# 10. Run: workon temp
# 11. The virtual environment is activated.
#

# This is the path to the virtualenvwrapper script, it should be sourced rather
# than run directly, but it needs its own path passed in as an argument

# Files to cleanup upon exit
set VIRTUALENVWRAPPER_CLEANUP = ()
onintr cleanup

# Locate the global Python where virtualenvwrapper is installed.
if ( ! $?VIRTUALENVWRAPPER_PYTHON ) then
    set VIRTUALENVWRAPPER_PYTHON = "`which python`"
endif

# Set the name of the virtualenv app to use.
if ( ! $?VIRTUALENVWRAPPER_VIRTUALENV ) then
    set VIRTUALENVWRAPPER_VIRTUALENV = "virtualenv"
endif

if ( ! $?VIRTUALENVWRAPPER_LIB_PATH ) then
    set VIRTUALENVWRAPPER_LIB_PATH = \
        `"$VIRTUALENVWRAPPER_PYTHON" -c \
            'import virtualenvwrapper, os; print os.path.abspath(virtualenvwrapper.__path__[0])'`
endif

if ( ! $?VIRTUALENVWRAPPER_SCRIPT_PATH ) then
    set VIRTUALENVWRAPPER_SCRIPT_PATH = \
        "$VIRTUALENVWRAPPER_LIB_PATH/virtualenvwrapper.csh"
endif

# Set the name of the virtualenv-clone app to use.
if ( ! $?VIRTUALENVWRAPPER_VIRTUALENV_CLONE ) then
    set VIRTUALENVWRAPPER_VIRTUALENV_CLONE = "virtualenv-clone"
endif

# Define script folder depending on the platorm (Win32/Unix)
# XXX Is this even desired or necessary in csh? Is anybody seriously going to
# be using csh under mingw32?
set VIRTUALENVWRAPPER_ENV_BIN_DIR="bin"
if ( $?OS && $?MSYSTEM ) then
    if ( "$OS" = "Windows_NT" && "$MSYSTEM" = "MINGW32" ) then
        # Only assign this for msys, cygwin use standard Unix paths
	    # and its own python installation 
        set VIRTUALENVWRAPPER_ENV_BIN_DIR="Scripts"
    endif
endif

# Let the user override the name of the file that holds the project
# directory name.
if ( ! $?VIRTUALENVWRAPPER_PROJECT_FILENAME ) then
    setenv VIRTUALENVWRAPPER_PROJECT_FILENAME ".project"
endif

# Portable shell scripting is hard, let's go shopping.
#
# People insist on aliasing commands like 'cd', either with a real
<<<<<<< mine
# alias or even a shell function. Under bash and zsh, "builtin" forces
# the use of a command that is part of the shell itself instead of an
# alias, function, or external command, while "command" does something
# similar but allows external commands. Under ksh "builtin" registers
# a new command from a shared library, but "command" will pick up
# existing builtin commands. We need to use a builtin for cd because
# we are trying to change the state of the current shell, so we use
# "builtin" for bash and zsh but "command" under ksh.
function virtualenvwrapper_cd {
    if [ -n "$BASH" ]
    then
        builtin \cd "$@"
    elif [ -n "$ZSH_VERSION" ]
    then
        builtin \cd "$@"
    else
        command \cd "$@"
    fi
}

function virtualenvwrapper_expandpath {
    if [ "$1" = "" ]; then
        return 1
    else
        "$VIRTUALENVWRAPPER_PYTHON" -c "import os,sys; sys.stdout.write(os.path.normpath(os.path.expanduser(os.path.expandvars(\"$1\")))+'\n')"
        return 0
    fi
}

function virtualenvwrapper_absolutepath {
    if [ "$1" = "" ]; then
        return 1
    else
        "$VIRTUALENVWRAPPER_PYTHON" -c "import os,sys; sys.stdout.write(os.path.abspath(\"$1\")+'\n')"
        return 0
    fi
}

function virtualenvwrapper_derive_workon_home {
    typeset workon_home_dir="$WORKON_HOME"

    # Make sure there is a default value for WORKON_HOME.
    # You can override this setting in your .bashrc.
    if [ "$workon_home_dir" = "" ]
    then
        workon_home_dir="$HOME/.virtualenvs"
    fi

    # If the path is relative, prefix it with $HOME
    # (note: for compatibility)
    if echo "$workon_home_dir" | (unset GREP_OPTIONS; command \grep '^[^/~]' > /dev/null)
    then
        workon_home_dir="$HOME/$WORKON_HOME"
    fi

    # Only call on Python to fix the path if it looks like the
    # path might contain stuff to expand.
    # (it might be possible to do this in shell, but I don't know a
    # cross-shell-safe way of doing it -wolever)
    if echo "$workon_home_dir" | (unset GREP_OPTIONS; command \egrep '([\$~]|//)' >/dev/null)
    then
        # This will normalize the path by:
        # - Removing extra slashes (e.g., when TMPDIR ends in a slash)
        # - Expanding variables (e.g., $foo)
        # - Converting ~s to complete paths (e.g., ~/ to /home/brian/ and ~arthur to /home/arthur)
        workon_home_dir=$(virtualenvwrapper_expandpath "$workon_home_dir")
    fi

    echo "$workon_home_dir"
    return 0
}
=======
# alias or even a shell function.
# http://unix.stackexchange.com/questions/12762/how-do-i-temporarily-bypass-an-alias-in-tcsh
alias virtualenvwrapper_cd 'c\d \!*'

alias virtualenvwrapper_expandpath \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_expandpath \!:1'

alias virtualenvwrapper_derive_workon_home \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_derive_workon_home'
>>>>>>> theirs

# Check if the WORKON_HOME directory exists,
# create it if it does not
# seperate from creating the files in it because this used to just error
# and maybe other things rely on the dir existing before that happens.
alias virtualenvwrapper_verify_workon_home \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_verify_workon_home'

set HOOK_VERBOSE_OPTION = "-q"

# Function to wrap mktemp so tests can replace it for error condition
# testing.
alias virtualenvwrapper_mktemp 'm\ktemp \!*'

# Expects 1 argument, the suffix for the new file.
alias virtualenvwrapper_tempfile \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_tempfile \!:*'

# Run the hooks
alias virtualenvwrapper_run_hook \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_run_hook \!:*'

# Set up tab completion.  (Adapted from Arthur Koziel's version at
# http://arthurkoziel.com/2008/10/11/virtualenvwrapper-bash-completion/)
# function virtualenvwrapper_setup_tab_completion {
#     if [ -n "$BASH" ] ; then
#         _virtualenvs () {
#             local cur="${COMP_WORDS[COMP_CWORD]}"
#             COMPREPLY=( $(compgen -W "`virtualenvwrapper_show_workon_options`" -- ${cur}) )
#         }
#         _cdvirtualenv_complete () {
#             local cur="$2"
#             COMPREPLY=( $(cdvirtualenv && compgen -d -- "${cur}" ) )
#         }
#         _cdsitepackages_complete () {
#             local cur="$2"
#             COMPREPLY=( $(cdsitepackages && compgen -d -- "${cur}" ) )
#         }
#         complete -o nospace -F _cdvirtualenv_complete -S/ cdvirtualenv
#         complete -o nospace -F _cdsitepackages_complete -S/ cdsitepackages
#         complete -o default -o nospace -F _virtualenvs workon
#         complete -o default -o nospace -F _virtualenvs rmvirtualenv
#         complete -o default -o nospace -F _virtualenvs cpvirtualenv
#         complete -o default -o nospace -F _virtualenvs showvirtualenv
#     elif [ -n "$ZSH_VERSION" ] ; then
#         _virtualenvs () {
#             reply=( $(virtualenvwrapper_show_workon_options) )
#         }
#         _cdvirtualenv_complete () {
#             reply=( $(cdvirtualenv && ls -d ${1}*) )
#         }
#         _cdsitepackages_complete () {
#             reply=( $(cdsitepackages && ls -d ${1}*) )
#         }
#         compctl -K _virtualenvs workon rmvirtualenv cpvirtualenv showvirtualenv
#         compctl -K _cdvirtualenv_complete cdvirtualenv
#         compctl -K _cdsitepackages_complete cdsitepackages
#     fi
# }

# Set up virtualenvwrapper properly
alias virtualenvwrapper_initialize \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_initialize'

# Verify that the passed resource is in path and exists
alias virtualenvwrapper_verify_resource \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_verify_resource \!:*'

# Verify that virtualenv is installed and visible
alias virtualenvwrapper_verify_virtualenv \
    'virtualenvwrapper_verify_resource $VIRTUALENVWRAPPER_VIRTUALENV'

alias virtualenvwrapper_verify_virtualenv_clone \
    'virtualenvwrapper_verify_resource $VIRTUALENVWRAPPER_VIRTUALENV_CLONE'

# Verify that the requested environment exists
alias virtualenvwrapper_verify_workon_environment \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_verify_workon_environment \!:*'

# Verify that the active environment exists
alias virtualenvwrapper_verify_active_environment \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_verify_active_environment'

# Help text for mkvirtualenv
alias mkvirtualenv_help \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/mkvirtualenv_help \!:*'

# Create a new environment, in the WORKON_HOME.
#
# Usage: mkvirtualenv [options] ENVNAME
# (where the options are passed directly to virtualenv)
#
<<<<<<< mine
function mkvirtualenv {
    typeset -a in_args
    typeset -a out_args
    typeset -i i
    typeset tst
    typeset a
    typeset envname
    typeset requirements
    typeset packages

    in_args=( "$@" )

    if [ -n "$ZSH_VERSION" ]
    then
        i=1
        tst="-le"
    else
        i=0
        tst="-lt"
    fi
    while [ $i $tst $# ]
    do
        a="${in_args[$i]}"
        # echo "arg $i : $a"
        case "$a" in
            -a)
                i=$(( $i + 1 ));
                project="${in_args[$i]}";;
            -h|--help)
                mkvirtualenv_help $a;
                return;;
            -i)
                i=$(( $i + 1 ));
                packages="$packages ${in_args[$i]}";;
            -p|--python)
                i=$(( $i + 1 ));
                interpreter="${in_args[$i]}";
                interpreter=$(virtualenvwrapper_absolutepath "$interpreter");;
            -r)
                i=$(( $i + 1 ));
                requirements="${in_args[$i]}";
                requirements=$(virtualenvwrapper_expandpath "$requirements");;
            *)
                if [ ${#out_args} -gt 0 ]
                then
                    out_args=( "${out_args[@]-}" "$a" )
                else
                    out_args=( "$a" )
                fi;;
        esac
        i=$(( $i + 1 ))
    done

    if [ ! -z $interpreter ]
    then
        out_args=( "--python=$interpreter" ${out_args[@]} )
    fi;

    set -- "${out_args[@]}"

    eval "envname=\$$#"
    virtualenvwrapper_verify_workon_home || return 1
    virtualenvwrapper_verify_virtualenv || return 1
    (
        [ -n "$ZSH_VERSION" ] && setopt SH_WORD_SPLIT
        virtualenvwrapper_cd "$WORKON_HOME" &&
        "$VIRTUALENVWRAPPER_VIRTUALENV" $VIRTUALENVWRAPPER_VIRTUALENV_ARGS "$@" &&
        [ -d "$WORKON_HOME/$envname" ] && \
            virtualenvwrapper_run_hook "pre_mkvirtualenv" "$envname"
    )
    typeset RC=$?
    [ $RC -ne 0 ] && return $RC

    # If they passed a help option or got an error from virtualenv,
    # the environment won't exist.  Use that to tell whether
    # we should switch to the environment and run the hook.
    [ ! -d "$WORKON_HOME/$envname" ] && return 0

    # If they gave us a project directory, set it up now
    # so the activate hooks can find it.
    if [ ! -z "$project" ]
    then
        setvirtualenvproject "$WORKON_HOME/$envname" "$project"
    fi

    # Now activate the new environment
    workon "$envname"

    if [ ! -z "$requirements" ]
    then
        pip install -r "$requirements"
    fi

    for a in $packages
    do
        pip install $a
    done

    virtualenvwrapper_run_hook "post_mkvirtualenv"
}
=======
alias mkvirtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/mkvirtualenv \!:*'
>>>>>>> theirs

# Remove an environment, in the WORKON_HOME.
alias rmvirtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/rmvirtualenv \!:*'

# List the available environments.
alias virtualenvwrapper_show_workon_options \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_show_workon_options'

alias _lsvirtualenv_usage ' \\
    (echo "lsvirtualenv [-blh]"; \\
     echo "  -b -- brief mode"; \\
     echo "  -l -- long mode"; \\
     echo "  -h -- this help message")'

# List virtual environments
#
# Usage: lsvirtualenv [-l]
#
alias lsvirtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/lsvirtualenv \!:*'

# Show details of a virtualenv
#
# Usage: showvirtualenv [env]
#
alias showvirtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/showvirtualenv \!:*'

# List or change working virtual environments
#
# Usage: workon [environment_name]
#
alias workon \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/workon \!:*'

# Prints the Python version string for the current interpreter.
# Uses the Python from the virtualenv rather than
# VIRTUALENVWRAPPER_PYTHON because we're trying to determine the
# version installed there so we can build up the path to the
# site-packages directory.
alias virtualenvwrapper_get_python_version \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_get_python_version'

# Prints the path to the site-packages directory for the current environment.
alias virtualenvwrapper_get_site_packages_dir \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_get_site_packages_dir'

# Path management for packages outside of the virtual env.
# Based on a contribution from James Bennett and Jannis Leidel.
#
# add2virtualenv directory1 directory2 ...
#
# Adds the specified directories to the Python path for the
# currently-active virtualenv. This will be done by placing the
# directory names in a path file named
# "virtualenv_path_extensions.pth" inside the virtualenv's
# site-packages directory; if this file does not exist, it will be
# created first.
<<<<<<< mine
function add2virtualenv {
    virtualenvwrapper_verify_workon_home || return 1
    virtualenvwrapper_verify_active_environment || return 1

    site_packages="`virtualenvwrapper_get_site_packages_dir`"

    if [ ! -d "${site_packages}" ]
    then
        echo "ERROR: currently-active virtualenv does not appear to have a site-packages directory" >&2
        return 1
    fi

    # Prefix with _ to ensure we are loaded as early as possible,
    # and at least before easy_install.pth.
    path_file="$site_packages/_virtualenv_path_extensions.pth"

    if [ "$*" = "" ]
    then
        echo "Usage: add2virtualenv dir [dir ...]"
        if [ -f "$path_file" ]
        then
            echo
            echo "Existing paths:"
            cat "$path_file" | grep -v "^import"
        fi
        return 1
    fi

    remove=0
    if [ "$1" = "-d" ]
    then
        remove=1
        shift
    fi

    if [ ! -f "$path_file" ]
    then
        echo "import sys; sys.__plen = len(sys.path)" > "$path_file" || return 1
        echo "import sys; new=sys.path[sys.__plen:]; del sys.path[sys.__plen:]; p=getattr(sys,'__egginsert',0); sys.path[p:p]=new; sys.__egginsert = p+len(new)" >> "$path_file" || return 1
    fi

    for pydir in "$@"
    do
        absolute_path=$(virtualenvwrapper_absolutepath "$pydir")
        if [ "$absolute_path" != "$pydir" ]
        then
            echo "Warning: Converting \"$pydir\" to \"$absolute_path\"" 1>&2
        fi

        if [ $remove -eq 1 ]
        then
            sed -i.tmp "\:^$absolute_path$: d" "$path_file"
        else
            sed -i.tmp '1 a\
'"$absolute_path"'
' "$path_file"
        fi
        rm -f "${path_file}.tmp"
    done
    return 0
}

=======
alias add2virtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/add2virtualenv \!:*'
     
>>>>>>> theirs
# Does a ``cd`` to the site-packages directory of the currently-active
# virtualenv.
alias cdsitepackages \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/cdsitepackages \!:*'

# Does a ``cd`` to the root of the currently-active virtualenv.
alias cdvirtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/cdvirtualenv \!:*'

# Shows the content of the site-packages directory of the currently-active
# virtualenv
alias lssitepackages \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/lssitepackages \!:*'

# Toggles the currently-active virtualenv between having and not having
# access to the global site-packages.
alias toggleglobalsitepackages \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/toggleglobalsitepackages \!:*'

# Duplicate the named virtualenv to make a new one.
alias cpvirtualenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/cpvirtualenv \!:*'

#
# virtualenvwrapper project functions
#

# Verify that the PROJECT_HOME directory exists
alias virtualenvwrapper_verify_project_home \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/virtualenvwrapper_verify_project_home \!:*'

# Given a virtualenv directory and a project directory,
# set the virtualenv up to be associated with the
# project
alias setvirtualenvproject \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/setvirtualenvproject \!:*'

# Show help for mkproject
alias mkproject_help \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/mkproject_help'

# Create a new project directory and its associated virtualenv.
alias mkproject \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/mkproject \!:*'

# Change directory to the active project
alias cdproject \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/cdproject \!:*'

#
# Temporary virtualenv
#
# Originally part of virtualenvwrapper.tmpenv plugin
#
alias mktmpenv \
    'source ${VIRTUALENVWRAPPER_SCRIPT_PATH}/mktmpenv'

#
# Invoke the initialization functions
#
virtualenvwrapper_initialize

# cleanup:
#     rm -f ${VIRTUALENVWRAPPER_CLEANUP} >& /dev/null
#     onintr
