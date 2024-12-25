
#!/bin/bash -ex

# Help function
print_help() {
    echo "V & HeroLib Installer Script"
    echo
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --reset        Force reinstallation of V"
    echo "  --remove       Remove V installation and exit"
    echo "  --analyzer     Install/update v-analyzer"
    echo "  --herolib      Install our herolib"
    echo
    echo "Examples:"
    echo "  $0"
    echo "  $0 --reset           "
    echo "  $0 --remove          "
    echo "  $0 --analyzer        "
    echo "  $0 --herolib         "
    echo "  $0 --reset --analyzer # Fresh install of both"
    echo
}

# Parse arguments
RESET=false
REMOVE=false
INSTALL_ANALYZER=false
HEROLIB=false

for arg in "$@"; do
    case $arg in
        -h|--help)
            print_help
            exit 0
            ;;
        --reset)
            RESET=true
            ;;
        --remove)
            REMOVE=true
            ;;
        --herolib)
            HEROLIB=true
            ;;            
        --analyzer)
            INSTALL_ANALYZER=true
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use -h or --help to see available options"
            exit 1
            ;;
    esac
done

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

export DIR_BASE="$HOME"
export DIR_BUILD="/tmp"
export DIR_CODE="$DIR_BASE/code"

function sshknownkeysadd {
    mkdir -p ~/.ssh
    touch ~/.ssh/known_hosts
    if ! grep github.com ~/.ssh/known_hosts > /dev/null
    then
        ssh-keyscan github.com >> ~/.ssh/known_hosts
    fi
    if ! grep git.ourworld.tf ~/.ssh/known_hosts > /dev/null
    then
        ssh-keyscan git.ourworld.tf >> ~/.ssh/known_hosts
    fi    
    git config --global pull.rebase false

}

function package_check_install {
    local command_name="$1"
    if command -v "$command_name" >/dev/null 2>&1; then
        echo "command '$command_name' is already installed."
    else    
        package_install '$command_name'
    fi
}

function package_install {
    local command_name="$1"
    if [[ "${OSNAME}" == "ubuntu" ]]; then
        apt -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" install $1 -q -y --allow-downgrades --allow-remove-essential 
    elif [[ "${OSNAME}" == "darwin"* ]]; then
        brew install $command_name
    elif [[ "${OSNAME}" == "alpine"* ]]; then
        apk add $command_name
    elif [[ "${OSNAME}" == "arch"* ]]; then
        pacman --noconfirm -Su $command_name
    else
        echo "platform : ${OSNAME} not supported"
        exit 1
    fi
}


function os_update {
    echo ' - os update'
    if [[ "${OSNAME}" == "ubuntu" ]]; then
        if is_github_actions; then
            echo "github actions"
        else
            rm -f /var/lib/apt/lists/lock
            rm -f /var/cache/apt/archives/lock
            rm -f /var/lib/dpkg/lock*		
        fi    
        export TERM=xterm
        export DEBIAN_FRONTEND=noninteractive
        dpkg --configure -a
        apt update -y
        if is_github_actions; then
            echo "** IN GITHUB ACTIONS, DON'T DO UPDATE"
        else
            set +e
            echo "** UPDATE"
            apt-mark hold grub-efi-amd64-signed
            set -e
            apt upgrade  -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes
            apt autoremove  -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes
        fi 
        #apt install apt-transport-https ca-certificates curl software-properties-common  -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes
        package_install "apt-transport-https ca-certificates curl wget software-properties-common tmux"
        package_install "rclone rsync mc redis-server screen net-tools git htop ca-certificates lsb-release binutils pkg-config"

    elif [[ "${OSNAME}" == "darwin"* ]]; then
        if command -v brew >/dev/null 2>&1; then
            echo 'homebrew installed'
        else 
            export NONINTERACTIVE=1
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"            
            unset NONINTERACTIVE
        fi
        set +e
        brew install mc redis curl tmux screen htop wget rclone tcc
        set -e
    elif [[ "${OSNAME}" == "alpine"* ]]; then
        apk update screen git htop tmux
        apk add mc curl rsync htop redis bash bash-completion screen git rclone
        sed -i 's#/bin/ash#/bin/bash#g' /etc/passwd             
    elif [[ "${OSNAME}" == "arch"* ]]; then
        pacman -Syy --noconfirm
        pacman -Syu --noconfirm
        pacman -Su --noconfirm arch-install-scripts gcc mc git tmux curl htop redis wget screen net-tools git sudo htop ca-certificates lsb-release screen rclone

        # Check if builduser exists, create if not
        if ! id -u builduser > /dev/null 2>&1; then
            useradd -m builduser
            echo "builduser:$(openssl rand -base64 32 | sha256sum | base64 | head -c 32)" | chpasswd
            echo 'builduser ALL=(ALL) NOPASSWD: ALL' | tee /etc/sudoers.d/builduser
        fi

        if [[ -n "${DEBUG}" ]]; then
            execute_with_marker "paru_install" paru_install
        fi
    fi
    echo 'os_update done'
}


function hero_lib_pull {
    pushd $DIR_CODE/github/freeflowuniverse/herolib 2>&1 >> /dev/null     
    if [[ $(git status -s) ]]; then
        echo "There are uncommitted changes in the Git repository herolib."
        return 1
    fi
    git pull
    popd 2>&1 >> /dev/null
}

function hero_lib_get {
    
    mkdir -p $DIR_CODE/github/freeflowuniverse
    if [[ -d "$DIR_CODE/github/freeflowuniverse/herolib" ]]
    then
        hero_lib_pull
    else
        pushd $DIR_CODE/github/freeflowuniverse 2>&1 >> /dev/null
        git clone --depth 1 --no-single-branch https://github.com/freeflowuniverse/herolib.git
        popd 2>&1 >> /dev/null
    fi    
}


remove_all() {
    echo "Removing V installation..."
    # Set reset to true to use existing reset functionality
    RESET=true
    # Call reset functionality
    sudo rm -rf ~/code/v
    sudo rm -rf ~/_code/v
    sudo rm -rf ~/.config/v-analyzer
    if command_exists v; then
        echo "Removing V from system..."
        sudo rm -f $(which v)
    fi
    if command_exists v-analyzer; then
        echo "Removing v-analyzer from system..."
        sudo rm -f $(which v-analyzer)
    fi

    # Remove v-analyzer path from rc files
    for RC_FILE in ~/.zshrc ~/.bashrc; do
        if [ -f "$RC_FILE" ]; then
            echo "Cleaning up $RC_FILE..."
            # Create a temporary file
            TMP_FILE=$(mktemp)
            # Remove lines containing v-analyzer/bin path
            sed '/v-analyzer\/bin/d' "$RC_FILE" > "$TMP_FILE"
            # Remove empty lines at the end of file
            sed -i.bak -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$TMP_FILE"
            # Replace original file
            mv "$TMP_FILE" "$RC_FILE"
            echo "Cleaned up $RC_FILE"
        fi
    done

    echo "V removal complete"
}


# Handle remove if requested
if [ "$REMOVE" = true ]; then
    remove_all
    exit 0
fi

# Handle reset if requested
if [ "$RESET" = true ]; then
    remove_all
    echo "Reset complete"
fi

# Create code directory if it doesn't exist
mkdir -p ~/code

os_update

sshknownkeysadd


# Check if v needs to be installed
if [ "$RESET" = true ] || ! command_exists v; then
    # Only clone and install if directory doesn't exist
    if [ ! -d ~/code/v ]; then
        echo "Installing V..."
        cd ~/code
        git clone --depth=1 https://github.com/vlang/v
        cd v
        make
        sudo ./v symlink
    fi

    # Verify v is in path
    if ! command_exists v; then
        echo "Error: V installation failed or not in PATH"
        echo "Please ensure ~/code/v is in your PATH"
        exit 1
    fi
    echo "V installation successful!"
fi

# Install v-analyzer if requested
if [ "$INSTALL_ANALYZER" = true ]; then
    echo "Installing v-analyzer..."
    v download -RD https://raw.githubusercontent.com/vlang/v-analyzer/main/install.vsh

    # Check if v-analyzer bin directory exists
    if [ ! -d "$HOME/.config/v-analyzer/bin" ]; then
        echo "Error: v-analyzer bin directory not found at $HOME/.config/v-analyzer/bin"
        echo "Please ensure v-analyzer was installed correctly"
        exit 1
    fi

    echo "v-analyzer installation successful!"
fi

# Add v-analyzer to PATH if installed
if [ -d "$HOME/.config/v-analyzer/bin" ]; then
    V_ANALYZER_PATH='export PATH="$PATH:$HOME/.config/v-analyzer/bin"'

    # Function to add path to rc file if not present
    add_to_rc() {
        local RC_FILE="$1"
        if [ -f "$RC_FILE" ]; then
            if ! grep -q "v-analyzer/bin" "$RC_FILE"; then
                echo "" >> "$RC_FILE"
                echo "$V_ANALYZER_PATH" >> "$RC_FILE"
                echo "Added v-analyzer to $RC_FILE"
            else
                echo "v-analyzer path already exists in $RC_FILE"
            fi
        fi
    }

    # Add to both .zshrc and .bashrc if they exist
    add_to_rc ~/.zshrc
    if [ "$(uname)" = "Darwin" ] && [ -f ~/.bashrc ]; then
        add_to_rc ~/.bashrc
    fi
fi

# Final verification
if ! command_exists v; then
    echo "Error: V is not accessible in PATH"
    echo "Please add ~/code/v to your PATH and try again"
    exit 1
fi

if [ "$HEROLIB" = true ]; then
    hero_lib_get
fi


if [ "$INSTALL_ANALYZER" = true ]; then
    echo "Run 'source ~/.bashrc' or 'source ~/.zshrc' to update PATH for v-analyzer"
fi


echo "Installation complete!"
