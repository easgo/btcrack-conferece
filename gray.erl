main(_) ->
    Args = init:get_arguments(),
    case Args of
        [] -> io:format("Missing ESSID~n");
        [ESSID] -> start(ESSID);
        [ESSID, Channel] -> start(ESSID, Channel);
        [ESSID, Channel, Interface] -> start(ESSID, Channel, Interface)
    end.

start(ESSID) ->
    start(ESSID, "1").

start(ESSID, Channel) ->
    start(ESSID, Channel, "wlo1mon").

start(ESSID, Channel, Interface) ->
    SedCmd1 = "s/<ESSID>/" ++ ESSID ++ "/",
    SedCmd2 = "s/<CHANNEL>/" ++ Channel ++ "/",
    SedCmd3 = "s/<INTERFACE>/" ++ Interface ++ "/",
    SedCmd4 = "\"" ++ SedCmd1 ++ "\"",
    SedCmd5 = string:join([SedCmd4, SedCmd2], " | sed "),
    SedCmd6 = string:join([SedCmd5, SedCmd3], " | sed "),
    WifihoneyTemplateFile = "wifi_honey_template.rc",
    ScreenWifiHoneyFile = "screen_wifi_honey.rc",
    {ok, WifihoneyTemplate} = file:read_file(WifihoneyTemplateFile),
    Commands = ["screen -c " ++ ScreenWifiHoneyFile],
    SedCommand = "sed " ++ SedCmd6 ++ " > " ++ ScreenWifiHoneyFile,
    ok = file:write_file(ScreenWifiHoneyFile, ""),
    os:cmd(SedCommand),
    start_screen(ScreenWifiHoneyFile, Commands).

start_screen(ConfigFile, Commands) ->
    ScreenCmd = "screen -c " ++ ConfigFile ++ " ",
    Args = ["-D", "-m"],
    FullCmd = string:join([ScreenCmd | Args | Commands], " "),
    os:cmd(FullCmd).
