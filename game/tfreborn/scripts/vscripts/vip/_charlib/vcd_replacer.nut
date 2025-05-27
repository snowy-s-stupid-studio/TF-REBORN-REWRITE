IncludeIfNot("_charlib/vcd_table.nut", "VCDTable" in ROOT);

function TickScenes()
{
    for (local scene = null; scene = FindByClassname(scene, "instanced_scripted_scene");)
    {
        scene.KeyValueFromString("classname", "invalid");
        local customCharacter = GetCustomCharacter(GetPropEntity(scene, "m_hOwner"));
        if (!customCharacter)
            continue;
        local path = GetPropString(scene, "m_szInstanceFilename");
        if (!path)
            return;
        local soundName = safeget(VCDTable, path.tolower(), null);
        if (soundName)
        {
            if (typeof(soundName) == "string")
                customCharacter.EmitVoiceLine(soundName);
            else
                soundName(scope.customCharacter);
        }
    }
}
AddTimer(-1, TickScenes);