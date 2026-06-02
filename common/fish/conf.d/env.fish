# Add PATHs
switch (uname)
    case Linux
        fish_add_path -a /opt/miniconda3/bin # /conda
        fish_add_path -a ~/.npm-global/bin
        fish_add_path -a ~/.local/bin
    case Darwin
        fish_add_path -a /opt/homebrew/bin
        fish_add_path -a /opt/homebrew/sbin
        fish_add_path -a /usr/local/sbin
        #
        # Added by LM Studio CLI (lms)
        set -gx PATH $PATH $HOME/.lmstudio/bin
        # End of LM Studio CLI section
end
