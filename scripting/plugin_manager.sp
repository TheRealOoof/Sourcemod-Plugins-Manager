/**
* Sourcemod Plugin Manager
* by Timothy Belt aka 'TheRealOoof'
*/

#include <sourcemod>

public Plugin Plugin_Manager = 
{
    name = "Sourcemod Plugin Manager",
    author = "TheRealOoof",
    description = "Manages plugins with chat commands",
    version = "0.01",
    url = "https://github.com/TheRealOoof/Sourcemod-Plugins-Manager"
};

public void OnPluginStart()
{
    PrintToServer("Hello World!");
}