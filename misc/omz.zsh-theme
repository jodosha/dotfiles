#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Prompt for the Zsh shell:
#   * One line.
#   * Only shows the path on the left prompt by default.
#   * Wears a different color whether the last command succeeded/failed.
#   * Shows user@hostname if connected through SSH.
#   * Shows if logged in as root or not.
# ------------------------------------------------------------------------------

# Customizable parameters.
PROMPT_PATH_MAX_LENGTH=30
PROMPT_DEFAULT_END=❯
PROMPT_ROOT_END=❯❯❯
PROMPT_STAGEDSTR_COLOR=$FG[071]
PROMPT_UNSTAGEDSTR_COLOR=$FG[124]

# Set required options.
setopt promptsubst

# Load required modules.
autoload -U add-zsh-hook

# Set vcs_info parameters.

# Define prompts.
PROMPT="${DEVENV:+[●]}${SSH_TTY:+[%n@%m]}%{$FX[bold]%}%$PROMPT_PATH_MAX_LENGTH<..<"'${vcs_info_msg_0_%%.}'"%<<%(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%{$FX[no-bold]%}%{$FX[reset]%} "
