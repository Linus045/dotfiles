#!/bin/bash
echo "=========================================================="
echo "Installing system dependencies"
echo "=========================================================="
sudo pacman -S --noconfirm --needed git openssh fzf ripgrep gum

echo ""
echo "=========================================================="
echo "Setting up git..."
echo "=========================================================="


username=$(git config --global user.name)
if [[ $? != 0 ]]; then
	echo "Please enter your Username for Git:"
	read username
	git config --global user.name "${username}"
else
	echo "Git global username found: $username"
fi

email=$(git config --global user.email)
if [[ $? != 0 ]]; then
	echo "Please enter your Email for Git:"
	read email
	git config --global user.email "${email}"
else
	echo "Git global email found: $email"
fi

SSH_KEYFILE=~/.ssh/id_github
if ! [[ -f ${SSH_KEYFILE} ]]; then
	echo ""
	echo "=========================================================="
	echo "Generating new SSH key for github"
	echo "=========================================================="
	echo "Please enter your Email:"
	read email
	ssh-keygen -t ed25519 -C "${email}" -f "$SSH_KEYFILE"

	echo "Starting up ssh-agent"
	eval "$(ssh-agent -s)"

	ssh-add "${SSH_KEYFILE}"


	echo "Please add the following public SSH key to your GitHub"
	xdg-open "https://github.com/settings/keys"

Done=0

while [[ ${Done} != "y" ]]; do
	echo "Please enter 'y' when you're done to continue..."
	read Done
done
else
	echo "Git SSH key for github already found. Assuming its installed in Github."
fi

echo ""
echo "=========================================================="
echo "Setting up dotfiles..."
echo "=========================================================="
echo "Creating ${HOME}/dev directory"
mkdir -p "${HOME}/dev"

DOTFILES_DIR="${HOME}/dev/dotfiles"


if ! [[ -d ${DOTFILES_DIR} ]]; then
	echo "Cloning Linus045/dotfiles into ${DOTFILES_DIR}"
	git clone "https://github.com/Linus045/dotfiles" "${DOTFILES_DIR}"
else
	echo "Linus045/dotfiles already exist at ${DOTFILES_DIR}. Skipping cloning..."
fi

echo ""
echo "=========================================================="
echo "Installing stow dependencies"
echo "=========================================================="
sudo pacman -S --noconfirm --needed stow starship zoxide tmux bat 

cd "${DOTFILES_DIR}"

echo "Stowing starship configuration"
stow -R -t "${HOME}" starship 

echo "Stowing zoxide configuration"
stow -R -t "${HOME}" zoxide

echo "Stowing zsh configuration"
stow -R -t "${HOME}" zsh

echo "Stowing tmux configuration"
stow -R -t "${HOME}" tmux

echo "Stowing git configuration"
stow -R -t "${HOME}" git
echo "Setting up git alias file"
echo "Stowing nvim configuration"

stow -R -t "${HOME}" nvim

echo ""
echo "=========================================================="
echo "Setting up git alias include"
echo "=========================================================="

include_path=$(git config --global --list | grep 'include.path=~/.gitalias')
if [[ $? != 0 ]]; then
	echo "Adding ${HOME}/.gitalias include to ${HOME}/.gitconfig file" 
	git config --global --add include.path '~/.gitalias'
else
	echo "Git global include path already found: $include_path"
fi


echo ""
echo "=========================================================="
echo "Installing neovim dependencies"
echo "=========================================================="
sudo pacman -S --noconfirm --needed xxd xclip

echo ""
echo "=========================================================="
echo "Installing neovim LSP dependencies"
echo "=========================================================="
sudo pacman -S --noconfirm --needed npm cmake


# fontdir="${HOME}/.local/share/fonts"
# firacodeFontPath="${fontdir}"'/firacode/FiraCodeNerdFontMono-Regular.ttf'
# mkdir -p $(dirname "${firacodeFontPath}")
# echo "Downloading FiraCode Nerd Font into: ${firacodeFontPath}"
# curl 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf' --output "${firacodeFontPath}"

echo ""
echo "=========================================================="
echo "Installing nerd font"
echo "=========================================================="
sudo pacman -S --noconfirm --needed ttf-firacode-nerd ttf-noto-nerd

echo "Reloading font cache"
fc-cache
