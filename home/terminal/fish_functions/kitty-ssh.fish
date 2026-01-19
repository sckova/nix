if set -q KITTY_WINDOW_ID
  kitty +kitten ssh $argv
else
  command ssh $argv
end
