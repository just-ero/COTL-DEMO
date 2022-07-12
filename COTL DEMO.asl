// Autosplitter made by MelloYourFello
// message me on discord @ MelloYourFello#6030 if you're experiencing any issues

state("Cult Of The Lamb") {}

startup
{
    vars.Log = (Action<object>)(output => print("[Cult Of The Lamb] " + output));

    #region Helper Setup
    var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, settings, this);
    vars.Helper.LoadSceneManager = true;
    #endregion

    settings.Add("Any%");
    settings.CurrentDefaultParent = "Any%";
    settings.Add("Base");
    settings.Add("Dungeon");

    vars.Helper.AlertGameTime("Cult Of The Lamb");
}

init
{
    vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
    {
        var uim = mono.GetClass("UIManager", 1);
        vars.Helper["isPaused"] = uim.Make<bool>("_instance", "IsPaused");

        return true;
    });

    vars.Helper.Load();
}

update
{
    if (!vars.Helper.Update())
        return false;

    current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
    current.IsPaused = vars.Helper["isPaused"].Current;
    // vars.Log(current.Scene);
}

split
{
    if (settings["Base"] && current.Scene == "Base Biome 1" && old.Scene == "BufferScene"){
        return true;
    }

    if (settings["Dungeon"] && current.Scene == "Dungeon1" && old.Scene == "BufferScene"){
        return true;
    }

    if (current.Scene == "DemoOver"){
        return true;
    }
}

exit
{
    vars.Unity.Reset(); 
}

shutdown
{
    vars.Unity.Reset();
}

start
{
    return current.Scene == "Game Biome Intro";
}

isLoading
{
    return current.IsPaused;
}

reset
{
    return current.Scene == "Main Menu";
}   
