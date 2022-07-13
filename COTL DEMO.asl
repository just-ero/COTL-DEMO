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
    
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var mbox = MessageBox.Show(
            "The Demo for Cult of the Lamb uses in-game time.\nWould you like to switch to it?",
            "LiveSplit | Cult of the Lamb Demo",
            MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
    
    settings.Add("Any%");
    settings.CurrentDefaultParent = "Any%";
    settings.Add("Escape");
    settings.Add("Base");
    settings.Add("Dungeon");
    settings.Add("Mini-Boss");
    #endregion
}

init
{
    vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
    {
        var uim = mono.GetClass("UIManager", 1);
        vars.Helper["isPaused"] = uim.Make<bool>("_instance", "IsPaused");

        var map = mono.GetClass("GameManager");
        vars.Helper["currentDungeonFloor"] = map.Make<int>("CurrentDungeonFloor");

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
    current.CurrentDungeonFloor = vars.Helper["currentDungeonFloor"].Current;
    vars.Log(current.Scene);
    vars.Log(current.CurrentDungeonFloor);
}
split
{
    if (settings["Base"] && current.Scene == "Base Biome 1" && old.Scene == "BufferScene"){
        return true;
    };

    if (settings["Dungeon"] && current.Scene == "Dungeon1" && old.Scene == "BufferScene"){
        return true;
    };

    if (current.Scene == "DemoOver"){
        return true;
    };

    if (settings["Escape"] && current.CurrentDungeonFloor > old.CurrentDungeonFloor && current.Scene != "Dungeon1"){
        return true;
    };

    if (current.CurrentDungeonFloor == 2 && current.Scene == "Dungeon1"){
        return false;
    }

    if (settings["Mini-Boss"] && current.CurrentDungeonFloor > old.CurrentDungeonFloor && current.Scene == "Dungeon1"){
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
