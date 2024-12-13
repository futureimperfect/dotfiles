##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
	    # How many characters of the $PWD should be kept
	    local pwdmaxlen=25
	    # Indicate that there has been dir truncation
	    local trunc_symbol=".."
	    local dir=${PWD##*/}
	    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
	    NEW_PWD=${PWD/$HOME/~}
	    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
	    if [ ${pwdoffset} -gt "0" ]
	        then
	        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen} NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
	    fi
}
#
bash_prompt() {
    local NONE='\[\033[0m\]'    # unsets color to term's fg color

        # regular colors
	local K='\[\033[0;30m\]'    # black
	local R='\[\033[0;31m\]'    # red
	local G='\[\033[0;32m\]'    # green
	local Y='\[\033[0;33m\]'    # yellow
	local B='\[\033[0;34m\]'    # blue
	local M='\[\033[0;35m\]'    # magenta
	local C='\[\033[036m\]'     # cyan
	local W='\[\033[0;37m\]'    # white
						    
	# empahsized (bolded) colors
	local EMK='\[\033[1;30m\]'
	local EMR='\[\033[1;31m\]'
	local EMG='\[\033[1;32m\]'
	local EMY='\[\033[1;33m\]'
	local EMB='\[\033[1;34m\]'
	local EMM='\[\033[1;35m\]'
	local EMC='\[\033[1;36m\]'
	local EMW='\[\033[1;37m\]'
										        
	# background colors
	local BGK='\[\033[40m\]'
	local BGR='\[\033[41m\]'
	local BGG='\[\033[42m\]'
	local BGY='\[\033[43m\]'
	local BGB='\[\033[44m\]'
	local BGM='\[\033[45m\]'
	local BGC='\[\033[46m\]'
	local BGW='\[\033[47m\]'
															    
	local UC=$C                 # user's color
        [ $UID -eq "0" ] && UC=$R   # root's color

	# PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
	PS1="${W}[\t${W}] ${R}[${Y}\u${Y}@${Y}\h ${G}\${NEW_PWD}${R}]${W}\\$ ${NONE}"
} 
#	
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

######################################################################

# Brett Terpstra's bundle ID retrieval function
# http://brettterpstra.com/2012/07/31/overthinking-it-fast-bundle-id-retrieval-for-mac-apps/
bid() {
    local shortname location
 
    # combine all args as regex
    # (and remove ".app" from the end if it exists due to autocomplete)
    shortname=$(echo "${@%%.app}"|sed 's/ /.*/g')
    # if the file is a full match in apps folder, roll with it
    if [ -d "/Applications/$shortname.app" ]; then
        location="/Applications/$shortname.app"
    else # otherwise, start searching
        location=$(mdfind -onlyin /Applications -onlyin ~/Applications -onlyin /Developer/Applications 'kMDItemKind==Application'|awk -F '/' -v re="$shortname" 'tolower($NF) ~ re {print $0}'|head -n1)
    fi
    # No results? Die.
    [[ -z $location || $location = "" ]] && echo "$1 not found, I quit" && return
    # Otherwise, find the bundleid using spotlight metadata
    bundleid=$(mdls -name kMDItemCFBundleIdentifier -r "$location")
    # return the result or an error message
    [[ -z $bundleid || $bundleid = "" ]] && echo "Error getting bundle ID for \"$@\"" || echo "$location: $bundleid"
}

# Homebrew on Apple Silicon installs to /opt/homebrew/bin instead of /usr/local/bin.
CPU=$(uname -p)
if [[ "$CPU" == "arm" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# To use Homebrew's directories rather than ~/.rbenv add to your profile:
export RBENV_ROOT="$(brew --prefix)"/var/rbenv

# To enable shims and autocompletion add to your profile:
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export OSA='osascript -e '
export SE='"AppleScript Editor"'

alias cse='$OSA "tell application $SE to quit"'
alias gist='gist -c'
alias listen='sudo lsof -n -i | grep LISTEN'
alias ll="ls -lah"
alias ose='open /Applications/Utilities/AppleScript\ Editor.app/'
alias speedtest='echo "scale=2; `curl  --progress-bar -w "%{speed_download}" http://speedtest.wdc01.softlayer.com/downloads/test10.zip -o /dev/null` / 131072" | bc | xargs -I {} echo {} mbps'
alias apep="autopep8 --in-place --aggressive --aggressive"

### Add `ghar` to $PATH and source its bash completion script.
export PATH="$HOME/.ghar/bin:$PATH"
if [ -f ~/.ghar/ghar-bash-completion.sh ]; then
    . ~/.ghar/ghar-bash-completion.sh
fi

### Add ~/bin to $PATH
export PATH=$PATH:~/bin

# Source bash_completion.sh, ~/.git-completion.sh, and ~/.git-prompt.sh
PREFIX="$(brew --prefix)" && [[ -r "${PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${PREFIX}/etc/profile.d/bash_completion.sh"

PREFIX="$(brew --prefix)" && [[ -r "${PREFIX}/etc/bash_completion.d/git-completion.bash" ]] && . "${PREFIX}/etc/bash_completion.d/git-completion.bash"

PREFIX="$(brew --prefix)" && [[ -r "${PREFIX}/etc/bash_completion.d/git-prompt.sh" ]] && . "${PREFIX}/etc/bash_completion.d/git-prompt.sh"

if [ -f ~/git-completion.bash ]; then
    . ~/git-completion.bash
fi

if [ -f ~/git-prompt.bash ]; then
    . ~/git-prompt.bash
fi

# Source virtualenvwrapper
BREW_PREFIX="$(brew --prefix)"
test -e "${BREW_PREFIX}/bin/virtualenvwrapper.sh" && source "${BREW_PREFIX}/bin/virtualenvwrapper.sh" || true

# grep colors
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;35;40'

# Make vim my $EDITOR
export EDITOR=/usr/bin/vim

# Export ANDROID_HOME dir
export ANDROID_HOME="/usr/local/opt/android-sdk"

# iTerm2 Shell Integration settings
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e ~/.iterm2_shell_integration.bash && source ~/.iterm2_shell_integration.bash || true

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/src/google-cloud-sdk/path.bash.inc" ]; then source "${HOME}/src/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/src/google-cloud-sdk/completion.bash.inc" ]; then source "${HOME}/src/google-cloud-sdk/completion.bash.inc"; fi

# The next line updates PATH for the Google Cloud SDK when installed via Homebrew.
if [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc" ]; then source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud when installed via Homebrew.
if [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]; then source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"; fi

# YK4 SSH key stuff
export OPENSC_LIBS=$(brew --prefix opensc)/lib

# Work stuff
if [ -f "${HOME}/scripts/work.env" ]; then source "${HOME}/scripts/work.env"; fi

# Other stuff
if [ -f "${HOME}/scripts/env.env" ]; then source "${HOME}/scripts/env.env"; fi

# Added by Krypton
export GPG_TTY=$(tty)

export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH="$HOME/Library/Python/3.7/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="$HOME/Library/Python/3.10/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources:$PATH"

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$(brew --prefix)/opt/python@3.13/libexec/bin:$PATH"
