# full credit to u/SupermarketAntique32 on reddit:
# https://www.reddit.com/r/commandline/comments/1sd26he/youtube_search_and_play_in_20_lines_of_bash/
{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "ytfp";
      runtimeInputs = [
        bash
        curl
        fzf
        yt-dlp
        chafa
        config.programs.mpv.finalPackage
      ];
      text = ''
        # `ytfp`: Search YouTube video using `fzf` and play it in `mpv`

        SEARCH_VID() {
          yt-dlp "https://www.youtube.com/results?search_query=$1" \
            --flat-playlist --playlist-items 1:20 --print \
            $'%(thumbnails.0.url)s\t%(title)s\t%(channel)s\t%(view_count)s\t%(url)s' \
            | grep --extended-regexp --invert-match 'playlist|channel'
        }
        RENDER_VID_INFO() {
          curl --silent "$1" | chafa --size=x14 --clear
          echo "Title   : $2"
          echo "Channel : $3"
          echo "Views   : $4"
        }
        export -f SEARCH_VID RENDER_VID_INFO

        fzf --preview-window down --layout reverse --disabled --with-shell 'bash -c' \
          --bind 'start:reload:SEARCH_VID fzf' \
          --bind 'change:reload:sleep 0.3; SEARCH_VID {q} || true' \
          --bind 'load:first' \
          --delimiter '\t' --with-nth 2 \
          --preview 'RENDER_VID_INFO {1} {2} {3} {4}' \
          --bind 'enter:execute-silent(mpv {5})'
      '';
    })
  ];
}
