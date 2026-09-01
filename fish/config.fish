if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Linux
        fish_add_path /home/roastcabose/.local/bin
        fish_add_path /home/roastcabose/.cargo/bin
        fish_add_path /home/linuxbrew/.linuxbrew/bin
        set -gx EDITOR /usr/bin/hx
        set -gx VINTAGE_STORY "/var/lib/flatpak/app/at.vintagestory.VintageStory/current/active/files/extra/vintagestory/"
    case Darwin
    case "*"
end

oh-my-posh init fish --config ~/.config/fish/layout.omp.yml | source
#oh-my-posh init fish | source

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"
