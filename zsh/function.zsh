# Alias - Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"

# Alias - Utils
alias p="pwd"
alias v="nvim"
alias vim="nvim"
alias cat="bat"
alias l="eza -al --icons --group-directories-first"
alias ll="eza -a --icons --group-directories-first"
alias ssh="kitty +kitten ssh"
alias du="dust -r -n 999999999"
alias tree="tree -aC"
alias icpng="mkdir converted-images; sips -s format png * --out converted-images"
alias icjpg="mkdir converted-images; sips -s format jpeg * --out converted-images"
alias clean="mac-cleanup -n"
alias python="python3"
alias pip="pip3"
alias fv='fzf-find-file-and-edit'

# Alias - Git
alias g='XDG_CONFIG_HOME="$HOME/.config" lazygit'
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -v"
alias gc!="git commit -v --amend --no-edit"
alias gl="git pull"
alias gp="git push"
alias gp!="git push --force"
alias gcl="git clone --depth 1 --single-branch"
alias gf="git fetch --all"
alias gb="git branch"
alias gr="git rebase"
alias gt='cd "$(git rev-parse --show-toplevel)"'

function gpr() {
	local username=$(git config user.name)
	if [ -z "$username" ]; then
		echo "Please set your git username"
		return 1
	fi

	local origin=$(git config remote.origin.url)
	if [ -z "$origin" ]; then
		echo "No remote origin found"
		return 1
	fi

	local remote_username=$(basename $(dirname $origin))
	if [ "$remote_username" != "$username" ]; then
		local new_origin=${origin/\/$remote_username\//\/$username\/}
		new_origin=${new_origin/https:\/\/github.com\//git@github.com:/}

		git config remote.origin.url $new_origin
		git remote remove upstream > /dev/null 2>&1
		git remote add upstream $origin
	fi

	git checkout -b "pr-$(openssl rand -hex 4)"
}

# NVM lazy loading
function load_nvm() {
	local silent="${1:-false}"

	if [[ -n "$NVM_LOADED" ]] && typeset -f nvm >/dev/null 2>&1; then
		return 0
	fi
	
	export NVM_DIR="$HOME/.nvm"
	if [[ -s "$NVM_DIR/nvm.sh" ]]; then
		\. "$NVM_DIR/nvm.sh"
	else
		[[ "$silent" == "true" ]] || echo "nvm.sh not found: $NVM_DIR/nvm.sh" >&2
		return 1
	fi
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
	
	export NVM_LOADED=1
	return 0
}

nvm() {
	unset -f nvm node npm npx
	load_nvm false || return 1
	nvm "$@"
}

node() {
	unset -f nvm node npm npx
	if ! load_nvm true; then
		command node "$@"
		return $?
	fi
	node "$@"
}

npm() {
	unset -f nvm node npm npx
	if ! load_nvm true; then
		command npm "$@"
		return $?
	fi
	npm "$@"
}

npx() {
	unset -f nvm node npm npx
	if ! load_nvm true; then
		command npx "$@"
		return $?
	fi
	npx "$@"
}

# Enhanced command line editing
function zsh-edit() {
	# Edit current command in editor
	local TMPFILE=$(mktemp)
	echo "$BUFFER" > $TMPFILE
	nvim $TMPFILE -c "set filetype=zsh"
	BUFFER=$(cat $TMPFILE)
	CURSOR=$#BUFFER
	rm $TMPFILE
	zle redisplay
}
zle -N zsh-edit
bindkey "^V" zsh-edit  # Ctrl+V to edit current command in editor
