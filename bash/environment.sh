echo -e "script:\n$0"
echo -e "working directory:\n$(pwd)"
echo "arguments:"
for arg; do echo "$arg"; done
echo "environment"
echo "whoami: $(whoami)"
echo "HOME: $HOME"
echo "PATH: $PATH"
