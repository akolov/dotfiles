# Functions

function path_prepend --description "Insert existing directories to the beginning of PATH"
  for i in $argv
    if test -d $i
      set -x PATH $i $PATH
    end
  end
end

function path_append --description "Append existing directories the the end of PATH"
  for i in $argv
    if test -d $i
      set -x PATH $PATH $i
    end
  end
end

function fish_user_key_bindings
  bind \cr percol_select_history
  bind \e\b backward-kill-word
  bind \cx\x7f backward-kill-line
end

function nuke_derived_data
  set -l derived_path "$HOME/Library/Developer/Xcode/DerivedData"
  rm -rf "$derived_path"
  if test $status = 0
    echo "Deleted $derived_path"
  else
    echo "Failed to delete $derived_path"
  end
end

### Configuration

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

path_prepend /usr/local/opt/python/libexec/bin
path_prepend /usr/local/var/rbenv/shims
path_prepend /usr/local/sbin
path_prepend ~/.bin
path_append /usr/libexec
path_append ~/.fastlane/bin

if set nvim_path (which nvim)
  set -gx EDITOR $nvim_path
end

set -gx HOMEBREW_GITHUB_API_TOKEN (cat ~/.github_token)
set -gx Z_SCRIPT_PATH  (brew --prefix)/etc/profile.d/z.sh
set -gx OMF_PATH "/Users/alex/.local/share/omf"

alias grep "grep --color=auto"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=(brew --prefix openssl@1.1)"

# Platform-dependent settings
switch (uname)
  case Darwin
    alias fixfinder "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user"
    alias flushdns "sudo discoveryutil mdnsflushcache; and sudo discoveryutil udnsflushcaches; and echo done"
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
