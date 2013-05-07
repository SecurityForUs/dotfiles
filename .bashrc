#
# ~/.bashrc
#

export WORKON_HOME=~/.virtenvs

source /usr/bin/virtualenvwrapper.sh

function cd_vw(){
	# Bash's way of expanding the directory to be absolute
	CD_PATH=$(readlink -f "$1")

	# Get all current virtuel environments created
	VIRTENVS=$(lsvirtualenv)

	# Get the current env (if exists)
	CUR_ENV_PATH=$(readlink -f "$VIRTUAL_ENV" | tr "/" "\n")
	CUR_ENV=$(echo -n ${CUR_ENV_PATH[@]} | awk '{print $NF}')

	# Parts of the directory
	bits=$(echo "$CD_PATH" | tr "/" "\n")

	FOUND=""

	# Loop through every environment currently created
	for env in $VIRTENVS; do
		CHECK=$(echo "${bits[@]}" | fgrep --word-regexp "$env")

		# If a environment matches a directory we are cd'ing to
		if [ -n "$CHECK" ]; then
			# If we aren't already in it, load it
			if [ "$env" != "$CUR_ENV" ]; then
				FOUND="$env"
			fi
		fi
	done

	# Found a virtualenv to switch to, so do it
	if [ -n "$FOUND" ]; then
		# Unset current environment if it exists
		if [ -n "$CUR_ENV" ]; then
			echo "Unloading current environment $CUR_ENV"
			deactivate
		fi

		echo "Switching to virtual environment $FOUND"
		workon "$FOUND"
	else
		# No virtual env found, only deactivate if an environment is in place
		if [ -n "$CUR_ENV" ]; then
			echo "Unloading virtual environment $CUR_ENV"
			deactivate
		fi
	fi

	cd "$CD_PATH"
}

function cdgit(){
	FOLDER=$(readlink -f "/home/eric/git/$1")
	cd_vw "$FOLDER"
}

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias pkginstall="sudo packer -S"
alias pkgremove="sudo pacman -Rns"
alias pkginfo="sudo pacman -Qi"
alias pkgsearch="sudo packer -Ss"
alias vwuse='workon'
alias vwswitch='workon'
alias vwclose='deactivate'
alias vwstart='workon'
alias cd='cd_vw'
alias cdgit='cdgit'
