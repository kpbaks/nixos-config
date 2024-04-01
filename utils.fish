

function please
    set password (command gum input --password --prompt='root password: ')
    # -n "do not prompt for password", -S "read password from stdin"
    echo $password | sudo -S $argv
end
