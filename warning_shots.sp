/*  SM Warning Shots
 *
 *  Copyright (C) 2017 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>
#include <cstrike>

#define VERSION "1.1"

new Handle:W_Weapon;

public Plugin:myinfo =
{
	name = "SM Warning Shots",
	author = "Franc1sco Steam: franug",
	description = "Warning Shots for jail server",
	version = VERSION,
	url = "http://steamcommunity.com/id/franug"
};

public OnPluginStart()
{
	CreateConVar("sm_warningshots_version", VERSION, "version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

        W_Weapon = CreateConVar("sm_warningshots_weapon", "weapon_p228", "warning weapon used");
}

public OnClientPutInServer(client)
{
    SDKHook(client, SDKHook_TraceAttack, HookTraceAttack);
}


public IsValidClient( client ) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}

public Action:HookTraceAttack(victim, &attacker, &inflictor, &Float:damage, &damagetype, &ammotype, hitbox, HitGroup)
{
       if(!attacker || !IsValidClient(attacker)) // invalid attacker
              return Plugin_Continue;

       if(!victim || !IsValidClient(victim)) // invalid victim
              return Plugin_Continue;


       if (GetClientTeam(attacker) != CS_TEAM_CT || GetClientTeam(victim) != CS_TEAM_T)
              return Plugin_Continue;

       new String:szWeapon[32];
       GetClientWeapon(attacker, szWeapon, sizeof(szWeapon));

       new String:warning_weapon[32];
       GetConVarString(W_Weapon, warning_weapon, sizeof(warning_weapon));

       if(!StrEqual(szWeapon, warning_weapon))
              return Plugin_Continue;

       if(HitGroup == 1) // headshot
              return Plugin_Continue;

       // nota: como es pagina inglesa tengo que publicarlo aqui en ingles por defecto :s (english translate: in this web is english for default)
       //
       //PrintToChat(victim, "\x04[SM_WarningShots] \x01El guardia \x03%N \x01 te ha dado un disparo de aviso!", attacker); // en español
       //PrintToChat(attacker, "\x04[SM_WarningShots] \x01Has dado un disparo de aviso al prisionero \x03%N \x01!", victim); // en español

       PrintToChat(victim, "\x04[SM_WarningShots] \x01The guard \x03%N \x01 has given you a warning shot", attacker); // english
       PrintToChat(attacker, "\x04[SM_WarningShots] \x01You have given a warning shot to prisoner \x03%N \x01", victim); // english

       FakeClientCommand(victim, "drop");

       damage = 0.0;
       return Plugin_Changed;
}
// me encanta scriptear :)
// y a ti no?
