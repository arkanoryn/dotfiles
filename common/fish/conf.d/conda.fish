# Lazy-load conda initialization
# Defers heavy conda setup until first use

set -q fish_conda_initialized || set -gx fish_conda_initialized false

function __init_conda --description "Initialize conda on first use"
    if test "$fish_conda_initialized" != true
        set -gx fish_conda_initialized true
        
        # Load the appropriate conda initialization for this system
        if test -f /opt/miniconda3/bin/conda
            eval /opt/miniconda3/bin/conda "shell.fish" hook $argv | source
        else if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
            . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
        else
            set -x PATH /opt/miniconda3/bin $PATH
        end
    end
end

# Create wrapper functions for common conda commands
# These trigger lazy-initialization on first use

function conda --description "Conda package manager (lazy-loaded)"
    __init_conda
    command conda $argv
end

function mamba --description "Mamba package manager (lazy-loaded)"
    __init_conda
    command mamba $argv
end

function conda-build --description "Conda build (lazy-loaded)"
    __init_conda
    command conda-build $argv
end

# Optional: uncomment to auto-initialize conda on shell start
# __init_conda
