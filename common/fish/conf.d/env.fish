# Add PATHs
switch (uname)
    case Linux
        fish_add_path -a /opt/miniconda3/bin # /conda
    case Darwin
        fish_add_path -a /opt/homebrew/bin
        fish_add_path -a /opt/homebrew/sbin
        fish_add_path -a /usr/local/sbin
end
