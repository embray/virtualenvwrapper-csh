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
#  3. Add a line like "source /path/to/this/file/virtualenvwrapper.csh"
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

# This is the source command used to run this file; it should be sourced rather
# than executed as a script
set COMMAND = ($_)
# The directory containing virtualenvwrapper.csh
set SCRIPTDIR = "`dirname $COMMAND[2]`"
# The directory containing 'functions' for virtualenvwrapper.csh
set FUNCDIR = "${SCRIPTDIR}/.virtualenvwrapper.csh"

# Files to cleanup upon exit
set CLEANUP = ()
onintr cleanup

# Locate the global Python where virtualenvwrapper is installed.
if ( ! $?VIRTUALENVWRAPPER_PYTHON ) then
    set VIRTUALENVWRAPPER_PYTHON="`which python`"
endif

# Set the name of the virtualenv app to use.
if ( ! $?VIRTUALENVWRAPPER_VIRTUALENV ) then
    set VIRTUALENVWRAPPER_VIRTUALENV="virtualenv"
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

alias virtualenvwrapper_derive_workon_home \
    'source ${FUNCDIR}/virtualenvwrapper_derive_workon_home'

# Check if the WORKON_HOME directory exists,
# create it if it does not
# seperate from creating the files in it because this used to just error
# and maybe other things rely on the dir existing before that happens.
alias virtualenvwrapper_verify_workon_home \
    'source ${FUNCDIR}/virtualenvwrapper_verify_workon_home'

set HOOK_VERBOSE_OPTION = "-q"

# Expects 1 argument, the suffix for the new file.
alias virtualenvwrapper_tempfile \
    'set argv = (\!:1); source ${FUNCDIR}/virtualenvwrapper_tempfile; \
     unset argv'

# Run the hooks
alias virtualenvwrapper_run_hook \
    'set argv = (\!:*); source ${FUNCDIR}/virtualenvwrapper_run_hook; \
     unset argv'

# Set up virtualenvwrapper properly
alias virtualenvwrapper_initialize \
    'source ${FUNCDIR}/virtualenvwrapper_initialize'

# Verify that virtualenv is installed and visible
alias virtualenvwrapper_verify_virtualenv \
    'source ${FUNCDIR}/virtualenvwrapper_verify_virtualenv'

# Verify that the requested environment exists
alias virtualenvwrapper_verify_workon_environment \
    'set argv = (\!:*); \
     source ${FUNCDIR}/virtualenvwrapper_verify_workon_environment; \
     unset argv'

## Verify that the active environment exists
#virtualenvwrapper_verify_active_environment () {
#    if [ ! -n "${VIRTUAL_ENV}" ] || [ ! -d "${VIRTUAL_ENV}" ]
#    then
#        echo "ERROR: no virtualenv active, or active virtualenv is missing" >&2
#        return 1
#    fi
#    return 0
#}

# Create a new environment, in the WORKON_HOME.
#
# Usage: mkvirtualenv [options] ENVNAME
# (where the options are passed directly to virtualenv)
#
alias mkvirtualenv \
    'set argv = (\!:*); source ${FUNCDIR}/mkvirtualenv; unset argv'

## Remove an environment, in the WORKON_HOME.
#rmvirtualenv () {
#    typeset env_name="$1"
#    virtualenvwrapper_verify_workon_home || return 1
#    if [ "$env_name" = "" ]
#    then
#        echo "Please specify an enviroment." >&2
#        return 1
#    fi
#    env_dir="$WORKON_HOME/$env_name"
#    if [ "$VIRTUAL_ENV" = "$env_dir" ]
#    then
#        echo "ERROR: You cannot remove the active environment ('$env_name')." >&2
#        echo "Either switch to another environment, or run 'deactivate'." >&2
#        return 1
#    fi
#
#    # Move out of the current directory to one known to be
#    # safe, in case we are inside the environment somewhere.
#    typeset prior_dir="$(pwd)"
#    \cd "$WORKON_HOME"
#
#    virtualenvwrapper_run_hook "pre_rmvirtualenv" "$env_name"
#    \rm -rf "$env_dir"
#    virtualenvwrapper_run_hook "post_rmvirtualenv" "$env_name"
#
#    # If the directory we used to be in still exists, move back to it.
#    if [ -d "$prior_dir" ]
#    then
#        \cd "$prior_dir"
#    fi
#}

# List the available environments.
alias virtualenvwrapper_show_workon_options \
    'source ${FUNCDIR}/virtualenvwrapper_show_workon_options'

alias _lsvirtualenv_usage ' \
    echo "lsvirtualenv [-blh]"; \
    echo "  -b -- brief mode"; \
    echo "  -l -- long mode"; \
    echo "  -h -- this help message"'


# List virtual environments
#
# Usage: lsvirtualenv [-l]
alias lsvirtualenv \
    'set argv = (\!:*); source ${FUNCDIR}/lsvirtualenv; unset argv'

## Show details of a virtualenv
##
## Usage: showvirtualenv [env]
#showvirtualenv () {
#    typeset env_name="$1"
#    if [ -z "$env_name" ]
#    then
#        if [ -z "$VIRTUAL_ENV" ]
#        then
#            echo "showvirtualenv [env]"
#            return 1
#        fi
#        env_name=$(basename $VIRTUAL_ENV)
#    fi
#
#    echo -n "$env_name"
#    virtualenvwrapper_run_hook "get_env_details" "$env_name"
#    echo
#}

# List or change working virtual environments
#
# Usage: workon [environment_name]
#
alias workon 'set argv = (\!:*); source ${FUNCDIR}/workon; unset argv'


## Prints the Python version string for the current interpreter.
#virtualenvwrapper_get_python_version () {
#    # Uses the Python from the virtualenv because we're trying to
#    # determine the version installed there so we can build
#    # up the path to the site-packages directory.
#    python -V 2>&1 | cut -f2 -d' ' | cut -f-2 -d.
#}
#
## Prints the path to the site-packages directory for the current environment.
#virtualenvwrapper_get_site_packages_dir () {
#    echo "$VIRTUAL_ENV/lib/python`virtualenvwrapper_get_python_version`/site-packages"    
#}
#
## Path management for packages outside of the virtual env.
## Based on a contribution from James Bennett and Jannis Leidel.
##
## add2virtualenv directory1 directory2 ...
##
## Adds the specified directories to the Python path for the
## currently-active virtualenv. This will be done by placing the
## directory names in a path file named
## "virtualenv_path_extensions.pth" inside the virtualenv's
## site-packages directory; if this file does not exist, it will be
## created first.
#add2virtualenv () {
#
#    virtualenvwrapper_verify_workon_home || return 1
#    virtualenvwrapper_verify_active_environment || return 1
#    
#    site_packages="`virtualenvwrapper_get_site_packages_dir`"
#    
#    if [ ! -d "${site_packages}" ]
#    then
#        echo "ERROR: currently-active virtualenv does not appear to have a site-packages directory" >&2
#        return 1
#    fi
#    
#    path_file="$site_packages/virtualenv_path_extensions.pth"
#
#    if [ "$*" = "" ]
#    then
#        echo "Usage: add2virtualenv dir [dir ...]"
#        if [ -f "$path_file" ]
#        then
#            echo
#            echo "Existing paths:"
#            cat "$path_file"
#        fi
#        return 1
#    fi
#
#    touch "$path_file"
#    for pydir in "$@"
#    do
#        absolute_path=$("$VIRTUALENVWRAPPER_PYTHON" -c "import os; print os.path.abspath(\"$pydir\")")
#        if [ "$absolute_path" != "$pydir" ]
#        then
#            echo "Warning: Converting \"$pydir\" to \"$absolute_path\"" 1>&2
#        fi
#        echo "$absolute_path" >> "$path_file"
#    done
#    return 0
#}
#
## Does a ``cd`` to the site-packages directory of the currently-active
## virtualenv.
#cdsitepackages () {
#    virtualenvwrapper_verify_workon_home || return 1
#    virtualenvwrapper_verify_active_environment || return 1
#    typeset site_packages="`virtualenvwrapper_get_site_packages_dir`"
#    \cd "$site_packages"/$1
#}
#
## Does a ``cd`` to the root of the currently-active virtualenv.
#cdvirtualenv () {
#    virtualenvwrapper_verify_workon_home || return 1
#    virtualenvwrapper_verify_active_environment || return 1
#    \cd $VIRTUAL_ENV/$1
#}
#
## Shows the content of the site-packages directory of the currently-active
## virtualenv
#lssitepackages () {
#    virtualenvwrapper_verify_workon_home || return 1
#    virtualenvwrapper_verify_active_environment || return 1
#    typeset site_packages="`virtualenvwrapper_get_site_packages_dir`"
#    ls $@ $site_packages
#    
#    path_file="$site_packages/virtualenv_path_extensions.pth"
#    if [ -f "$path_file" ]
#    then
#        echo
#        echo "virtualenv_path_extensions.pth:"
#        cat "$path_file"
#    fi
#}
#
## Toggles the currently-active virtualenv between having and not having
## access to the global site-packages.
#toggleglobalsitepackages () {
#    virtualenvwrapper_verify_workon_home || return 1
#    virtualenvwrapper_verify_active_environment || return 1
#    typeset no_global_site_packages_file="`virtualenvwrapper_get_site_packages_dir`/../no-global-site-packages.txt"
#    if [ -f $no_global_site_packages_file ]; then
#        rm $no_global_site_packages_file
#        [ "$1" = "-q" ] || echo "Enabled global site-packages"
#    else
#        touch $no_global_site_packages_file
#        [ "$1" = "-q" ] || echo "Disabled global site-packages"
#    fi
#}
#
## Duplicate the named virtualenv to make a new one.
#cpvirtualenv() {
#    typeset env_name="$1"
#    if [ "$env_name" = "" ]
#    then
#        virtualenvwrapper_show_workon_options
#        return 1
#    fi
#    typeset new_env="$2"
#    if [ "$new_env" = "" ]
#    then
#        echo "Please specify target virtualenv"
#        return 1
#    fi
#    if echo "$WORKON_HOME" | (unset GREP_OPTIONS; \grep "/$" > /dev/null)
#    then
#        typeset env_home="$WORKON_HOME"
#    else
#        typeset env_home="$WORKON_HOME/"
#    fi
#    typeset source_env="$env_home$env_name"
#    typeset target_env="$env_home$new_env"
#    
#    if [ ! -e "$source_env" ]
#    then
#        echo "$env_name virtualenv doesn't exist"
#        return 1
#    fi
#
#    \cp -r "$source_env" "$target_env"
#    for script in $( \ls $target_env/$VIRTUALENVWRAPPER_ENV_BIN_DIR/* )
#    do
#        newscript="$script-new"
#        \sed "s|$source_env|$target_env|g" < "$script" > "$newscript"
#        \mv "$newscript" "$script"
#        \chmod a+x "$script"
#    done
#
#    "$VIRTUALENVWRAPPER_VIRTUALENV" "$target_env" --relocatable
#    \sed "s/VIRTUAL_ENV\(.*\)$env_name/VIRTUAL_ENV\1$new_env/g" < "$source_env/$VIRTUALENVWRAPPER_ENV_BIN_DIR/activate" > "$target_env/$VIRTUALENVWRAPPER_ENV_BIN_DIR/activate"
#
#    (\cd "$WORKON_HOME" && ( 
#        virtualenvwrapper_run_hook "pre_cpvirtualenv" "$env_name" "$new_env";
#        virtualenvwrapper_run_hook "pre_mkvirtualenv" "$new_env"
#        ))
#    workon "$new_env"
#    virtualenvwrapper_run_hook "post_mkvirtualenv"
#    virtualenvwrapper_run_hook "post_cpvirtualenv"
#}

#
# Invoke the initialization hooks
#
virtualenvwrapper_initialize

cleanup:
    rm -f ${CLEANUP} >& /dev/null
    onintr
