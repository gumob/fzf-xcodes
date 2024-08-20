
function fzf-xcodes() {
  ######################
  ### Option Parser
  ######################

  local __parse_options (){
    local prompt="$1" && shift
    local option_list
    if [[ "$SHELL" == *"/bin/zsh" ]]; then
      option_list=("$@")
    elif [[ "$SHELL" == *"/bin/bash" ]]; then
      local -n arr_ref=$1
      option_list=("${arr_ref[@]}")
    fi

    ### Select the option
    local selected_option=$(printf "%s\n" "${option_list[@]}" | fzf --ansi --prompt="${prompt} > ")
    if [[ -z "$selected_option" || "$selected_option" =~ ^[[:space:]]*$ ]]; then
      return 1
    fi

    ### Normalize the option list
    local option_list_normal=()
    for option in "${option_list[@]}"; do
        # Remove $(tput bold) and $(tput sgr0) from the string
        option_normalized="${option//$(tput bold)/}"
        option_normalized="${option_normalized//$(tput sgr0)/}"
        # Add the normalized string to the new array
        option_list_normal+=("$option_normalized")
    done
    ### Get the index of the selected option
    index=$(printf "%s\n" "${option_list_normal[@]}" | grep -nFx "$selected_option" | cut -d: -f1)
    if [ -z "$index" ]; then
      return 1
    fi

    ### Generate the command
    command=""
    if [[ "$SHELL" == *"/bin/zsh" ]]; then
      command="${option_list_normal[$index]%%:*}"
    elif [[ "$SHELL" == *"/bin/bash" ]]; then
      command="${option_list_normal[$index-1]%%:*}"
    else
      echo "Error: Unsupported shell. Please use bash or zsh to use fzf-xcodes."
      return 1
    fi
    echo $command
    return 0
  }

  local __extract_version() {
    local version=$1
    [[ -z "$version" || "$version" =~ ^[[:space:]]*$ ]] && return 1
    local version_only=$(echo "$version" | sed 's/\s*(.*).*//; s/[[:space:]]*$//')
    echo "$version_only"
    return 0
  }

  ######################
  ### xcodes commands
  ######################

  local fzf-xcodes-select() {
    local options=$(xcodes installed | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes select > ")
    local version_only=$(__extract_version "$version")
    xcodes install "$version_only"
    local installed_path=$(xcodes installed | grep 'Selected' | grep -o '/Applications.*')
    local app_path="/Applications/Xcode.app"
    if [ -L $app_path ]; then
        rm -rf $app_path
    fi
    ln -s "$installed_path" "$app_path"
    echo "$(tput setaf 2)A symbolic link has been created to $app_path$(tput sgr0)"
    return 0
  }

  local fzf-xcodes-list() {
    local options=$(xcodes list | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes list > ")
    if command -v pbcopy &>/dev/null; then
      echo -n "$version" | pbcopy
    elif command -v xclip &>/dev/null; then
      echo -n "$version" | xclip -selection clipboard
    fi
    echo "$version"
    return 0
  }

  local fzf-xcodes-download() {
    local options=$(xcodes list | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes download > ")
    local version_only=$(__extract_version "$version")
    echo "version_only: $version_only"
    # xcodes download "$version_only"
    return 0
  }

  local fzf-xcodes-install() {
    local options=$(xcodes list | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes install > ")
    local version_only=$(__extract_version "$version")
    echo "version_only: $version_only"
    # xcodes install "$version_only"
    return 0
  }

  local fzf-xcodes-installed() {
    local options=$(xcodes installed | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes installed > ")
    if command -v pbcopy &>/dev/null; then
        echo -n "$version" | pbcopy
    elif command -v xclip &>/dev/null; then
        echo -n "$version" | xclip -selection clipboard
    fi
    echo "$version"
    return 0
  }

  local fzf-xcodes-update() {
    local options=$(xcodes update | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes update > ")
    if command -v pbcopy &>/dev/null; then
        echo -n "$version" | pbcopy
    elif command -v xclip &>/dev/null; then
        echo -n "$version" | xclip -selection clipboard
    fi
    echo "$version"
    return 0
  }

  local fzf-xcodes-uninstall() {
    local options=$(xcodes installed | sort -nr | sed "s/Installed/$(tput setaf 4)&$(tput sgr0)/g" | sed "s/Selected/$(tput setaf 2)&$(tput sgr0)/g")
    local version=$(echo $options | fzf --ansi --prompt="xcodes uninstall > ")
    local version_only=$(__extract_version "$version")
    echo "version_only: $version_only"
    # xcodes uninstall "$version_only"
    return 0
  }

  local fzf-xcodes-runtimes() {
    local option_list=(
      "$(tput bold)install:$(tput sgr0)                   Download and install a specific simulator runtime"
      "$(tput bold)install --include-betas:$(tput sgr0)   Download and install a specific simulator runtime including betas"
      "$(tput bold)download:$(tput sgr0)                  Download a specific simulator runtime"
      "$(tput bold)download --include-betas:$(tput sgr0)  Download a specific simulator runtime including betas"
    )
    command=$(__parse_options "xcodes" ${option_list[@]})
    if [ $? -eq 1 ]; then
        zle accept-line
        zle -R -c
        return 1
    fi
    case "$command" in
      install)                    fzf-xcodes-runtimes-install;;
      install\ --include-betas)   fzf-xcodes-runtimes-install-betas;;
      download)                   fzf-xcodes-runtimes-download;;
      download\ --include-betas)  fzf-xcodes-runtimes-download-betas;;
      *) echo "Error: Unknown command 'xcodes $command'" ;;
    esac
    return 0
  }

  local __get_runtimes() {
    local option=$1
    local prompt=$2
    local runtimes_output=$(xcodes runtimes ${option} | sed '/^Note:/d' | sed '/^$/d')
    local runtime_ios=$(echo "$runtimes_output" | awk '/-- iOS --/{flag=1;next}/--/{flag=0}flag' | sort -Vr)
    local runtime_watchos=$(echo "$runtimes_output" | awk '/-- watchOS --/{flag=1;next}/--/{flag=0}flag' | sort -Vr)
    local runtime_tvos=$(echo "$runtimes_output" | awk '/-- tvOS --/{flag=1;next}/--/{flag=0}flag' | sort -Vr)
    local runtime_visionos=$(echo "$runtimes_output" | awk '/-- visionOS --/{flag=1;next}/--/{flag=0}flag' | sort -Vr)
    local runtimes="${runtime_ios}\n${runtime_watchos}\n${runtime_tvos}\n${runtime_visionos}"
    local selected_runtime=$(echo "$runtimes" | fzf --ansi --prompt="xcodes runtimes ${prompt} > ")
    local runtime=$(__extract_version "$selected_runtime")
    echo "$runtime"
  }

  local fzf-xcodes-runtimes-download() {
    local runtime=$(__get_runtimes "" "download")
    xcodes runtimes download "$runtime"
    return 0
  }

  local fzf-xcodes-runtimes-download-betas() {
    local runtime=$(__get_runtimes "--include-betas" "download")
    xcodes runtimes download --include-betas "$runtime"
    return 0
  }

  local fzf-xcodes-runtimes-install() {
    local runtime=$(__get_runtimes "" "install")
    sudo xcodes runtimes install "$runtime"
    return 0
  }

  local fzf-xcodes-runtimes-install-betas() {
    local runtime=$(__get_runtimes "--include-betas" "install")
    sudo xcodes runtimes install --include-betas "$runtime"
    return 0
  }

  local fzf-xcodes-version() {
    xcodes version
    return 0
  }

  local fzf-xcodes-signout() {
    res=$(echo "Yes\nNo" | fzf --ansi --prompt="xcodes signout > ")
    if [ "$res" = "Yes" ]; then
      xcodes signout
      echo "Signed out."
      return 0
    else
      echo "Cancelled."
      return 1
    fi
  }

  ######################
  ### Entry Point
  ######################
  local init() {
    local option_list=(
      "$(tput bold)select:$(tput sgr0)                  Change the selected Xcode"
      " "
      "$(tput bold)list:$(tput sgr0)                    List all versions of Xcode that are available to install"
      "$(tput bold)download:$(tput sgr0)                Download a specific version of Xcode"
      "$(tput bold)install:$(tput sgr0)                 Download and install a specific version of Xcode"
      "$(tput bold)installed:$(tput sgr0)               List the versions of Xcode that are installed"
      "$(tput bold)update:$(tput sgr0)                  Update the list of available versions of Xcode"
      "$(tput bold)uninstall:$(tput sgr0)               Uninstall a version of Xcode"
      " "
      "$(tput bold)runtimes:$(tput sgr0)                List all simulator runtimes that are available to install"
      " "
      "$(tput bold)version:$(tput sgr0)                 Print the version number of xcodes itself"
      " "
      "$(tput bold)signout:$(tput sgr0)                 Clears the stored username and password"
    )

    command=$(__parse_options "xcodes" ${option_list[@]})
    if [ $? -eq 1 ]; then
        zle accept-line
        zle -R -c
        return 1
    fi

    case "$command" in
      select)     fzf-xcodes-select;;
      list)       fzf-xcodes-list;;
      download)   fzf-xcodes-download;;
      install)    fzf-xcodes-install;;
      installed)  fzf-xcodes-installed;;
      update)     fzf-xcodes-update;;
      uninstall)  fzf-xcodes-uninstall;;
      runtimes)   fzf-xcodes-runtimes;;
      version)    fzf-xcodes-version;;
      signout)    fzf-xcodes-signout;;
      *) echo "Error: Unknown command 'xcodes $command'" ;;
    esac

    zle accept-line
    zle -R -c
  }
  init
}

zle -N fzf-xcodes
if [[ "$SHELL" == *"/bin/zsh" ]]; then
  bindkey "${FZF_XCODES_KEY_BINDING}" fzf-xcodes
elif [[ "$SHELL" == *"/bin/bash" ]]; then
  bind -x "'${FZF_XCODES_KEY_BINDING}': fzf-xcodes"
fi