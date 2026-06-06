{ pkgs }:

pkgs.writeShellScriptBin "web-search" ''
  set -euo pipefail

  case "''${1:-}" in
    -h|--help)
      echo "Usage: web-search"
      echo "Pick a search engine via rofi, enter a query, open it in the browser."
      exit 0 ;;
  esac

  declare -A URLS=(
    ["🌎 Search"]="https://search.brave.com/search?q="
    ["❄️  Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
    ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
    ["🦥 Arch Wiki"]="https://wiki.archlinux.org/title/"
    ["🐃 Gentoo Wiki"]="https://wiki.gentoo.org/index.php?title="
  )

  platform=$(printf '%s\n' "''${!URLS[@]}" | ${pkgs.rofi}/bin/rofi -dmenu -p "Search engine") || exit 0
  [ -n "$platform" ] || exit 0

  # Guard against a selection that isn't one of our keys.
  if [ -z "''${URLS[$platform]:-}" ]; then
    exit 0
  fi

  query=$(${pkgs.rofi}/bin/rofi -dmenu -p "Query") || exit 0
  [ -n "$query" ] || exit 0

  exec ${pkgs.xdg-utils}/bin/xdg-open "''${URLS[$platform]}$query"
''
