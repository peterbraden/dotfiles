# PYENV 
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# The next line updates PATH for poetry
export PATH="/Users/peterbraden/.local/bin:$PATH"
export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/1.9.1/include
export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/1.9.1/lib
