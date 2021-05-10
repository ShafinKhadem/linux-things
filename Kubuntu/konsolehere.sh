function openkonsoletab() {
    echo "opening konsole tab in: $1";
    konsole --new-tab --workdir "$1" &
}

echo "working directory: $(pwd)"
[[ $# -eq 0 ]] && openkonsoletab "$(pwd)"
for arg; do echo "argument: $arg"; [[ -d "${arg:7}" ]] && dir="${arg:7}" || dir="$(dirname "${arg:7}")"; openkonsoletab "$dir"; done
