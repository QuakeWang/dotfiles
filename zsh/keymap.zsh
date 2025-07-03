# Mode indicators and visual cues
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';;       # Block cursor for command mode
    viins|main) echo -ne '\e[5 q';;  # Blinking cursor for insert mode
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5 q'  # Ensure blinking cursor on new line
  zle -K viins       # Start in insert mode
}
zle -N zle-line-init

# Custom widget for yanking to system clipboard
function vi-yank-wrapped {
  local last_key="$KEYS[-1]"
  local ori_buffer="$CUTBUFFER"

  zle vi-yank
  if [[ "$last_key" = "Y" ]] then
    echo -n "$CUTBUFFER" | pbcopy -i
    CUTBUFFER="$ori_buffer"
  fi
}
zle -N vi-yank-wrapped

# Quick yank command
bindkey -s "^y" "y\n"

# Menu mode - for completion menus
bindkey -rpM menuselect ""
bindkey -M menuselect "^I"  complete-word
bindkey -M menuselect "^["  send-break
bindkey -M menuselect "^H"  backward-char
bindkey -M menuselect "^L"  forward-char

# Command mode - simplified
bindkey -rpM command ""
bindkey -M command "^[" send-break
bindkey -M command "^M" accept-line

# Normal/Command mode (vicmd) - core functionality
bindkey -rpM vicmd ""
bindkey -M vicmd "^W"  backward-delete-word
bindkey -M vicmd "^L"  clear-screen
bindkey -M vicmd "^M"  accept-line

# Navigation in command mode
bindkey -M vicmd "h"   vi-backward-char
bindkey -M vicmd "l"   vi-forward-char
bindkey -M vicmd "H"   vi-first-non-blank
bindkey -M vicmd "L"   vi-end-of-line

# Word movement in command mode
bindkey -M vicmd "b"   vi-backward-word
bindkey -M vicmd "w"   vi-forward-word
bindkey -M vicmd "e"   vi-forward-word-end

# Mode switching
bindkey -M vicmd "i"   vi-insert
bindkey -M vicmd "I"   vi-insert-bol
bindkey -M vicmd "a"   vi-add-next
bindkey -M vicmd "A"   vi-add-eol

# Editing in command mode
bindkey -M vicmd "d"   vi-delete
bindkey -M vicmd "D"   vi-kill-eol
bindkey -M vicmd "c"   vi-change
bindkey -M vicmd "C"   vi-change-eol
bindkey -M vicmd "x"   vi-delete-char
bindkey -M vicmd "r"   vi-replace-chars
bindkey -M vicmd "dd"  kill-whole-line      # Delete entire line

# Clipboard operations
bindkey -M vicmd "y"   vi-yank-wrapped
bindkey -M vicmd "Y"   vi-yank-wrapped
bindkey -M vicmd "yy"  vi-yank-whole-line   # Yank entire line
bindkey -M vicmd "p"   vi-put-after
bindkey -M vicmd "P"   vi-put-before

# Undo/redo
bindkey -M vicmd "u"   undo
bindkey -M vicmd "U"   redo

# Other useful bindings
bindkey -M vicmd "."   vi-repeat-change
bindkey -M vicmd ","   edit-command-line
bindkey -M vicmd "gg"  beginning-of-buffer-or-history
bindkey -M vicmd "G"   end-of-buffer-or-history

# Insert mode - essential functionality with enhanced shortcuts
bindkey -M viins "^?"  backward-delete-char  # Backspace
bindkey -M viins "^W"  backward-delete-word
bindkey -M viins "^A"  beginning-of-line     # Go to beginning of line
bindkey -M viins "^E"  end-of-line          # Go to end of line
bindkey -M viins "^["  vi-cmd-mode          # Traditional way (Escape)
