if test (count $argv) -eq 0
  command nix-shell --run fish
else
  command nix-shell --run fish $argv
end
