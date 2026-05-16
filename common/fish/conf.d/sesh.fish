# Sesh integration for fish shell
# Provides sesh-related functions and aliases

# Auto-connect to a sesh session using walker for selection
# This was previously in tmux.extra.conf with invalid shell syntax
function sesh-connect-interactive
    set -l session (sesh l -t -T -d -H | walker -d -f -k -p "Sesh sessions")
    if test -n "$session"
        sesh cn --switch $session
    end
end

# Alias for quick access
alias sesh-connect='sesh-connect-interactive'
