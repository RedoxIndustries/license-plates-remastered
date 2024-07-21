# License Plates Remastered
Plaques d'immatriculations remasterisé pour MyParisCity

> [!TIP]
> Pour ajouter une plaque à un véhicule :
> Aller dans le dossier lua/ll_plates/**sh_autogen.lua**
> ```
> PLATE:RegisterPlate("id_du_véhicule", -- Nom du véhicule
> {pos = Vector(0, 114.1, 22), ang = Angle(0, 180, 91), plaquetype = "avant", bg = {id = false, val = {}}}, -- Position de la plaque avant
> {pos = Vector(-18, -115.8, 38.3), ang = Angle(0, 0, 82), plaquetype = "arriere", bg = {id = false, val = {}}}) -- Position de la plaque arrière
> ```
