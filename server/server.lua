print("[KUI] Serveur chargé avec succès.")

RegisterCommand("getip", function(source, args, rawCommand)
    local target = tonumber(args[1])
    if target then
        local ip = GetPlayerEndpoint(target)
        if ip then
            print(("L'IP du joueur %d est : %s"):format(target, ip))
        else
            print("Impossible de récupérer l'IP.")
        end
    else
        print("Usage : /getip [ID du joueur]")
    end
end, false)
