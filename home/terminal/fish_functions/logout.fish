if status is-login
    builtin exit
else
    /run/current-system/sw/bin/qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
end
