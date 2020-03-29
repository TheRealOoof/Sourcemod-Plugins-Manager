/**
* Sourcemod Plugin Manager
* by Timothy Belt aka 'TheRealOoof'
*/

#include <sourcemod>
#include <sdktools>


#pragma semicolon 1

bool g_autoplantEnabled = true;

enum PluginEnabled {
  Plgn_None = 0,
  Plgn_Retakes = 1,
  Plgn_Practice = 2,
  Plgn_1v1Arena = 3,
};

PluginEnabled g_Mode = Plgn_None;

public Plugin Plugin_Manager = 
{
    name = "Sourcemod Plugin Manager",
    author = "TheRealOoof",
    description = "Manages plugins with chat commands",
    version = "0.01",
    url = "https://github.com/TheRealOoof/Sourcemod-Plugins-Manager"
};

// Forwards ------------------------------------------------------------------------------------------
public void OnPluginStart()
{
    RegAdminCmd("sm_enableretakes", Command_RetakesEnabled, ADMFLAG_CHANGEMAP, "Enables retake mode");
    RegAdminCmd("sm_enableretake", Command_RetakesEnabled, ADMFLAG_CHANGEMAP, "Enables retake mode");
    RegAdminCmd("sm_retakes", Command_RetakesEnabled, ADMFLAG_CHANGEMAP, "Enables retake mode");
    RegAdminCmd("sm_retake", Command_RetakesEnabled, ADMFLAG_CHANGEMAP, "Enables retake mode");
    RegAdminCmd("sm_disableretakes", Command_RetakesDisabled, ADMFLAG_CHANGEMAP, "Disables retake mode");
    RegAdminCmd("sm_disableretake", Command_RetakesDisabled, ADMFLAG_CHANGEMAP, "Disables retake mode");

    RegAdminCmd("sm_enableprac", Command_PracticeEnabled, ADMFLAG_CHANGEMAP, "Enabled practice mode");
    RegAdminCmd("sm_enablepractice", Command_PracticeEnabled, ADMFLAG_CHANGEMAP, "Enabled practice mode");
    RegAdminCmd("sm_prac", Command_PracticeEnabled, ADMFLAG_CHANGEMAP, "Enabled practice mode");
    RegAdminCmd("sm_disableprac", Command_PracticeDisabled, ADMFLAG_CHANGEMAP, "Disables practice mode");
    RegAdminCmd("sm_disablepractice", Command_PracticeDisabled, ADMFLAG_CHANGEMAP, "Disables practice mode");

    RegAdminCmd("sm_disableall", Command_DisableAllPlugins, ADMFLAG_CHANGEMAP, "Disables all plugins");
    RegAdminCmd("sm_endwarmup", Command_WarmupEnd, ADMFLAG_CHANGEMAP, "Ends warmup");

    RegAdminCmd("sm_enableautoplant", Command_AutoPlantEnabled, ADMFLAG_CHANGEMAP, "Enables Autoplant, only in retake mode");
    RegAdminCmd("sm_enableap", Command_AutoPlantEnabled, ADMFLAG_CHANGEMAP, "Enables Autoplant, only in retake mode");
    RegAdminCmd("sm_autoplant", Command_AutoPlantEnabled, ADMFLAG_CHANGEMAP, "Enables Autoplant, only in retake mode");
    RegAdminCmd("sm_ap", Command_AutoPlantEnabled, ADMFLAG_CHANGEMAP, "Enables Autoplant, only in retake mode");
    RegAdminCmd("sm_disableautoplant", Command_AutoPlantDisabled, ADMFLAG_CHANGEMAP, "Disables Autoplant, only in retake mode");
    RegAdminCmd("sm_disableap", Command_AutoPlantDisabled, ADMFLAG_CHANGEMAP, "Disables Autoplant, only in retake mode");

    RegAdminCmd("sm_enable1v1", Command_1v1Enabled, ADMFLAG_CHANGEMAP, "Enable Multi 1v1");
    RegAdminCmd("sm_enable1v1s", Command_1v1Enabled, ADMFLAG_CHANGEMAP, "Enable Multi 1v1");
    RegAdminCmd("sm_1v1", Command_1v1Enabled, ADMFLAG_CHANGEMAP, "Enable Multi 1v1");
    RegAdminCmd("sm_1v1s", Command_1v1Enabled, ADMFLAG_CHANGEMAP, "Enable Multi 1v1");
    RegAdminCmd("sm_disable1v1", Command_1v1Disabled, ADMFLAG_CHANGEMAP, "Disable Multi 1v1");
    RegAdminCmd("sm_disable1v1s", Command_1v1Disabled, ADMFLAG_CHANGEMAP, "Disable Multi 1v1");

    RegAdminCmd("sm_autohop", Command_EnableAutoHop, ADMFLAG_CHANGEMAP, "Enable Auto-Bunnyhopping");
    RegAdminCmd("sm_disableautohop", Command_DisableAutoHop, ADMFLAG_CHANGEMAP, "Disable Auto-Bunnyhopping");
}

public void OnPluginEnd()
{
    OnMapEnd();
}

// Functions -----------------------------------------------------------------------------------------

public void OnMapEnd() {
  if (g_Mode != Plgn_None) {
    DisableAllPlugins();
  }
}

public void DisableAllPlugins() {
    ServerCommand("sm_exitpractice");
    ServerCommand("sm_cvar sm_retakes_enabled 0");
    ServerCommand("sm_cvar sm_autoplant_enabled 0");
    ServerCommand("sm_cvar sm_multi1v1_enabled 0");
    ServerCommand("sm_say All Plugins Disabled");
    g_Mode = Plgn_None;
}

public void OnAllPluginsLoaded() {
  DisableAllPlugins();
}

public void MoveAllPlayersToSpec() { 
  int totalPlayers = GetClientCount(true);
  for (int i = 1; i <= totalPlayers; i++) {
    ChangeClientTeam(i, 1);
    ForcePlayerSuicide(i);
  }
}

public void KickAllBots() { 
	ServerCommand("bot_kick");
}



// Commands ------------------------------------------------------------------------------------------
public Action Command_RetakesEnabled(int client, int args) {
  if (g_Mode == Plgn_None) {
    ServerCommand("sm_cvar sm_retakes_enabled 1");
    ServerCommand("sm_say Retakes enabled.");
    if (g_autoplantEnabled) { 
        ServerCommand("sm_cvar sm_autoplant_enabled 1"); 
        ServerCommand("sm_say AutoPlant enabled"); }
    g_Mode = Plgn_Retakes;
    return Plugin_Handled;
  } else if (g_Mode == Plgn_Retakes) {
    ServerCommand("sm_say |Error| Retakes already enabled. Use !disableretakes to disable retakes");
    return Plugin_Handled;
  } else {
      ServerCommand("sm_say |Error| Another mode enabled. Disable all plugin modes with !disableall");
      return Plugin_Handled;
  }
}

public Action Command_RetakesDisabled(int client, int args) {
  if (g_Mode == Plgn_Retakes) {
    ServerCommand("sm_cvar sm_retakes_enabled 0");
    ServerCommand("sm_say Retakes disabled.");
    if (g_autoplantEnabled) { 
        ServerCommand("sm_cvar sm_autoplant_enabled 0"); 
        ServerCommand("sm_say AutoPlant disabled"); }
    g_Mode = Plgn_None;
    return Plugin_Handled;
    }
  else {
    ServerCommand("sm_say |Error| Another mode enabled. Disable all plugin modes with !disableall");
    return Plugin_Handled;
  }
}

public Action Command_PracticeEnabled(int client, int args) {
  if (g_Mode == Plgn_None) {
    ServerCommand("sm_launchpractice");
    ServerCommand("sm_say Practice Mode Enabled");
    g_Mode = Plgn_Practice;
    return Plugin_Handled;
    }
  else if (g_Mode == Plgn_Practice) {
    ServerCommand("sm_say |Error| Practice already enabled. Use .setup to change settings, use !disableprac to disable practice.");
    return Plugin_Handled;
  }
  else {
    ServerCommand("sm_say |Error| Another mode enabled. Disable all plugin modes with !disableall");
    return Plugin_Handled;
  }
}

public Action Command_PracticeDisabled(int client, int args) {
  if (g_Mode == Plgn_Practice) {
    ServerCommand("sm_exitpractice");
    ServerCommand("sm_say Practice Mode Disabled");
    g_Mode = Plgn_None;
    return Plugin_Handled;
    }
  else {
    ServerCommand("sm_say |Error| Another mode enabled. Disable all plugin modes with !disableall");
    return Plugin_Handled;
  }
}

public Action Command_DisableAllPlugins(int client, int args) {
  if (g_Mode != Plgn_None)
  {
    DisableAllPlugins();
    g_Mode = Plgn_None;
    return Plugin_Handled;
  } else {
    ServerCommand("sm_say All plugins already disabled.");
    return Plugin_Handled;
  }
}

public Action Command_WarmupEnd(int client, int args) {
    ServerCommand("mp_warmup_end");
    ServerCommand("sm_say Warmup ended.");
    return Plugin_Handled;
}

public Action Command_AutoPlantEnabled(int client, int args) {
  if (g_Mode != Plgn_Retakes) {
    ServerCommand("sm_say |Error| Retakes not enabled. Use !enableretakes to enable retakes");
    return Plugin_Handled;
  } else {
    ServerCommand("sm_cvar sm_autoplant_enabled 1");
    ServerCommand("sm_say Autoplant Enabled");
    return Plugin_Handled;
  }
}

public Action Command_AutoPlantDisabled(int client, int args) {
  if (g_Mode != Plgn_Retakes) {
    ServerCommand("sm_say |Error| Retakes not enabled. Use !enableretakes to enable retakes");
    return Plugin_Handled;
  } else {
    ServerCommand("sm_cvar sm_autoplant_enabled 0");
    ServerCommand("sm_say Autoplant Disabled");
    return Plugin_Handled;
  }
}

public Action Command_1v1Enabled(int client, int args) {
  if (g_Mode == Plgn_None) {
    ServerCommand("mp_force_assign_teams 1");
    KickAllBots();
    ServerExecute();    //ServerExecute needed to make sure all the bots get kicked before MoveAllPlayersToSpec gets called
    MoveAllPlayersToSpec();
    ServerCommand("sm_cvar sm_multi1v1_enabled 1");
    ServerCommand("sm_say 1v1's Enabled");
    g_Mode = Plgn_1v1Arena;
    return Plugin_Handled;
  } else if (g_Mode == Plgn_1v1Arena) {
    ServerCommand("sm_say |Error| 1v1s are already enabled. Use !disable1v1 to disable 1v1's.");
    return Plugin_Handled;
  } else {
    ServerCommand("sm_say |Error| Another mode enabled. Disable all plugin modes with !disableall");
    return Plugin_Handled;
  }
}

public Action Command_1v1Disabled(int client, int args) {
  if (g_Mode != Plgn_1v1Arena) {
    ServerCommand("sm_say |Error| 1v1's are not enabled. Disable all plugin modes with !disableall");
    return Plugin_Handled;
  } else {
  	ServerCommand("mp_force_assign_teams 0");
    ServerCommand("sm_cvar sm_multi1v1_enabled 0");
    ServerCommand("sm_say 1v1's Disabled");
    g_Mode = Plgn_None;
    return Plugin_Handled;
  }
}

public Action Command_EnableAutoHop(int client, int args) {
  ServerCommand("sv_autobunnyhopping 1");
  ServerCommand("sm_say Auto-Bunnyhop Enabled");
  return Plugin_Handled;
}

public Action Command_DisableAutoHop(int client, int args) {
  ServerCommand("sv_autobunnyhopping 0");
  ServerCommand("sm_say Auto-Bunnyhop Disabled");
  return Plugin_Handled;
}