if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Linux
        fish_add_path /home/roastcabose/.local/bin
        fish_add_path /home/roastcabose/.cargo/bin
        set -gx EDITOR /usr/bin/hx
    case Darwin
    case "*"
end

oh-my-posh init fish --config ~/.config/fish/layout.omp.yml | source
#oh-my-posh init fish | source
