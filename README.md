# fzf-xcodes

## Table of Contents

- [fzf-xcodes](#fzf-xcodes)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Installation](#installation)
    - [Install junegunn/fzf using Homebrew](#install-junegunnfzf-using-homebrew)
    - [Install XcodesOrg/xcodes using Homebrew](#install-xcodesorgxcodes-using-homebrew)
    - [Download fzf-xcodes to your home directory](#download-fzf-xcodes-to-your-home-directory)
    - [Usingsing key bindings](#usingsing-key-bindings)
  - [Usage](#usage)
  - [License](#license)

## Overview

This is a shell plugin that allows you to execute [`XcodesOrg/xcodes`](https://github.com/XcodesOrg/xcodes) commands using keyboard shortcuts utilizing [`junegunn/fzf`](https://github.com/junegunn/fzf) and [`XcodesOrg/xcodes`](https://github.com/XcodesOrg/xcodes).

## Installation

### Install [junegunn/fzf](https://github.com/junegunn/fzf) using Homebrew

```shell
brew install fzf
```

Please refer to the [fzf official documentation](https://github.com/junegunn/fzf#installation) for installation instructions on other operating systems.

### Install [XcodesOrg/xcodes](https://github.com/XcodesOrg/Xcodes) using Homebrew

```shell
brew install xcodesorg/made/xcodes
```

### Download [fzf-xcodes](https://github.com/gumob/fzf-xcodes) to your home directory

```shell
wget -O ~/.fzfxcodes https://raw.githubusercontent.com/gumob/fzf-xcodes/main/fzf-xcodes.sh
```

### Usingsing key bindings

Source `fzf` and `fzfxcodes` in your run command shell.
By default, no key bindings are set. If you want to set the key binding to `Ctrl+X`, please configure it as follows:

```shell
cat <<EOL >> ~/.zshrc
export FZF_XCODES_KEY_BINDING="^X"
source ~/.fzfxcodes
EOL
```

`~/.zshrc` should be like this.

```shell
source <(fzf --zsh)
export FZF_XCODES_KEY_BINDING='^X'
source ~/.fzfxcodes
```

Source run command

```shell
source ~/.zshrc
```

## Usage

Using the shortcut key set in `FZF_XCODES_KEY_BINDING`, you can execute `fzf-xcodes`, which will display a list of `xcodes` commands.

To run `fzf-xcodes` without using the keyboard shortcut, enter the following command in the shell:

```shell
fzf-xcodes
```

## License

This project is licensed under the MIT License. The MIT License is a permissive free software license that allows for the reuse, modification, distribution, and sale of the software. It requires that the original copyright notice and license text be included in all copies or substantial portions of the software. The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement.
