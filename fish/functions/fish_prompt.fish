function fish_prompt
    set_color white
    echo -n (whoami)"@"(cat /proc/sys/kernel/hostname)" "
    set_color normal
    echo -n "> "
end
