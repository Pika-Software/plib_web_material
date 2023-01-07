plib.Require( 'http' )

local materialsFolder = 'materials/'
if file.IsDir( materialsFolder, 'DATA' ) then
    plib.Info( 'Web materials folder detected: \'{0}\'', materialsFolder )
else
    plib.Warn( 'Web materials directory is missing, recreating...' )
    file.Delete( materialsFolder )
    file.CreateDir( materialsFolder, 'DATA' )
end

local string_GetFileFromURL = string.GetFileFromURL
local http_Download = http.Download
local ArgAssert = ArgAssert
local Material = Material

function WebMaterial( url, callback, params )
    ArgAssert( url, 1, 'string' )
    ArgAssert( callback, 2, 'function' )

    http_Download(url, materialsFolder .. string_GetFileFromURL( url, true, false ), function( content, headers, size, path )
        local material = Material( 'data/' .. path, params )
        callback( not material:IsError(), material )
    end,
    function( err, path )
        if file.Exists( path, 'DATA' ) then
            local material = Material( 'data/' .. path, params )
            callback( not material:IsError(), material )
        else
            callback( false, '' )
        end
    end)
end
