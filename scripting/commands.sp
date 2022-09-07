#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

public Plugin myinfo ={
	name = "List SourceMod Commands",
	author = "denormal, shanapu (Edit by MRcMAG1C)",
	description = "Lists SourceMod commands accessible to the client in a menu.",
	version = "1.2",
	url = "hjemezez.dk"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_commands", Command_commands, "Open this commands menu");
}

public Action Command_commands(int client,int args)
{
	char command[64];
	char description[128];
	Handle cvar;
	bool isCommand, flags;
	
	cvar = FindFirstConCommand(command, sizeof(command), isCommand, flags, description, sizeof(description));
	
	if(cvar == INVALID_HANDLE) {
		PrintToConsole(client, "Could not load cvar list");
		return Plugin_Handled;
	}
	Menu menu = new Menu(Menu_Callback);
	menu.SetTitle("Commands");

	do {
		if(!isCommand) 
			continue;
		
		bool isSmCmd = command[0] == 's' && command[1] == 'm' && command[2] == '_';	
		if (isSmCmd && CheckCommandAccess(client, command, 0, false)) 
		{
			char display[256];
			Format(display, sizeof(display), "%s\n%s", command ,description);
			menu.AddItem(command, display);
		}
	} while(FindNextConCommand(cvar, command, sizeof(command), isCommand, flags, description, sizeof(description)));
	
	menu.ExitButton = true;
	menu.Display(client, 30);
	
	return Plugin_Handled;
}

public int Menu_Callback(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action) {
		case MenuAction_Select:	
		{
			char command[32];
			menu.GetItem(param2, command, sizeof(command));
			FakeClientCommand(param1, command);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}	
}