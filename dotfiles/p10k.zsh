# Enable transient prompt for cleaner terminal
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# Minimal but informative prompt segments
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status)

# Clean, professional styling
typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{4}❯%f "

# Directory settings
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
unset POWERLEVEL9K_DIR_BACKGROUND

# Git VCS colors - minimal but clear
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2       # Green
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=3   # Yellow
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=1    # Red

# Only show command execution time when commands take longer than 1 second
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1

# Status indicators - show only errors
typeset -g POWERLEVEL9K_STATUS_OK=false
