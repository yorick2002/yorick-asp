fx_version 'cerulean'

game { 'gta5enhanced' }

author 'Yorick'
description 'FiveM C# template'
version '1.0.0'

client_script 'Client/bin/Release/net10.0/publish/Client*.dll'
server_script 'Server/bin/Release/net10.0/publish/Server*.dll'

files {
    'Client/bin/Release/net10.0/publish/CitizenFX*'
}
