/**
* Sourcemod Plugin Manager
* by Timothy Belt aka 'TheRealOoof'
*/

#include <sourcemod>


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
    RegAdminCmd("sm_enable_retakes", Command_RetakesEnabled, ADMFLAG_CHANGEMAP);
    RegAdminCmd("sm_disable_retakes", Command_RetakesDisabled, ADMFLAG_CHANGEMAP);
}

public void OnPluginEnd()
{
    OnMapEnd();
}


// Functions -----------------------------------------------------------------------------------------

public void OnMapEnd() {
  if (g_Mode != Plgn_None) {
    g_Mode = Plgn_None;
  }
}

// Commands ------------------------------------------------------------------------------------------
public Action Command_RetakesEnabled(int client, int args) {
  if (g_Mode == Plgn_None) {
    ServerCommand("sm_cvar sm_retakes_enabled 1");
    PrintToChatAll("Retakes enabled.");
    if (g_autoplantEnabled) { 
        ServerCommand("sm_cvar sm_autoplant_enabled 1"); 
        PrintToChatAll("AutoPlant enabled"); }
    g_Mode = Plgn_Retakes;
    return Plugin_Handled;
  } else if (g_Mode == Plgn_Retakes) {
    PrintToChatAll("|Error| Another retakes already enabled.");
    return Plugin_Handled;
  } else {
      PrintToChatAll("|Error| Another mode enabled. Disable current mode to start retakes.");
      return Plugin_Handled;
  }
}

public Action Command_RetakesDisabled(int client, int args) {
  if (g_Mode == Plgn_Retakes) {
    ServerCommand("sm_cvar sm_retakes_enabled 0");
    PrintToChatAll("Retakes disabled.");
    if (g_autoplantEnabled) { 
        ServerCommand("sm_cvar sm_autoplant_enabled 0"); 
        PrintToChatAll("AutoPlant disabled"); }
    g_Mode = Plgn_None;
    return Plugin_Handled;
    }
  else {
    PrintToChatAll("|Error| Another mode enabled. Disable all modes with COMMANDHERE");
    return Plugin_Handled;
  }
}

