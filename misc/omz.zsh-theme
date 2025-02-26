#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Prompt for the Zsh shell:
#   * One line.
#   * VCS info on the right prompt.
#   * Only shows the path on the left prompt by default.
#   * Crops the path to a defined length and only shows the path relative to
#     the current VCS repository root.
#   * Wears a different color whether the last command succeeded/failed.
#   * Shows user@hostname if connected through SSH.
#   * Shows if logged in as root or not.
# ------------------------------------------------------------------------------

# Customizable parameters.
PROMPT_PATH_MAX_LENGTH=30
PROMPT_DEFAULT_END=❯
PROMPT_ROOT_END=❯❯❯
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_STAGEDSTR_COLOR=$FG[071]
PROMPT_UNSTAGEDSTR_COLOR=$FG[124]

# Set required options.
setopt promptsubst

# Load required modules.
autoload -U add-zsh-hook
autoload -Uz vcs_info

# Add hook for calling vcs_info before each command.
add-zsh-hook precmd vcs_info

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*:*' unstagedstr "%{$PROMPT_UNSTAGEDSTR_COLOR%}"'!'"%{$FX[reset]%}"
zstyle ':vcs_info:*:*' stagedstr  "%{$PROMPT_STAGEDSTR_COLOR%}"'+'"%{$FX[reset]%}"
zstyle ':vcs_info:*:*' actionformats "%S" "%~ (%b) %u%c (%a)"
zstyle ':vcs_info:*:*' formats "%S" "%~ (%b) %u%c"
zstyle ':vcs_info:*:*' nvcsformats "%~" ""

# Define prompts.
PROMPT="${DEVENV:+[●]}${SSH_TTY:+[%n@%m]}%{$FX[bold]%}%$PROMPT_PATH_MAX_LENGTH<..<"'${vcs_info_msg_0_%%.}'"%<<%(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%{$FX[no-bold]%}%{$FX[reset]%} "
RPROMPT="%{$PROMPT_VCS_INFO_COLOR%}"'$vcs_info_msg_1_'"%{$FX[reset]%}"
