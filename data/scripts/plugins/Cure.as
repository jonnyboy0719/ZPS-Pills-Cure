/*
	Plugin Created by Johan "JonnyBoy0719" Ehrendahl
*/

// Requires colors plugin addon, which is located on the ZP Community Forums, under Custom Content > Plugins:
// URL: https://zombiepanicsource.com/forums/showthread.php?tid=30
// Author: Johan "JonnyBoy0719" Ehrendahl

#include "colors"

void PluginInit()
{
	// Hooks
	Events::Player::OnEntityPickedUp.Hook( @PlayerPickupEntity );
	Events::Player::OnCommandExecute.Hook( @OnCommandExecuted );
	
	// Cvars
	if ( !Cvar::Exist( "cure_instant" ) )
		Cvar::Create( "cure_instant", "0", FLAG_RCON );
	
	if ( !Cvar::Exist( "cure_infectiondelay" ) )
		Cvar::Create( "cure_infectiondelay", "65.0", FLAG_RCON );
	
	if ( !Cvar::Exist( "cure_percentage" ) )
		Cvar::Create( "cure_percentage", "35", FLAG_RCON );
	
	InitColors();
}

HookReturnCode OnCommandExecuted( CBasePlayer@ pPlayer, const string& in strCommand, const string& in strValue, ADMIN_FLAGS& in flags )
{
	if ( Utils.StrEql( strCommand, "cure_instant" ) )
	{
		if ( Utils.StrEql( strValue, "" ) )
		{
			string result = Cvar::GrabBool( strCommand ) ? "true" : "false";
			Engine.Print( console, pPlayer, "cure_instant: " + result + "\n" );
			return HOOK_CONTINUE;
		}
	}
	else if ( Utils.StrEql( strCommand, "cure_infectiondelay" ) )
	{
		if ( Utils.StrEql( strValue, "" ) )
		{
			Engine.Print( console, pPlayer, "cure_infectiondelay: " + Cvar::GrabFloat( strCommand ) + "\n" );
			return HOOK_CONTINUE;
		}
	}
	else if ( Utils.StrEql( strCommand, "cure_percentage" ) )
	{
		if ( Utils.StrEql( strValue, "" ) )
		{
			Engine.Print( console, pPlayer, "cure_percentage: " + Cvar::GrabInt( strCommand ) + "\n" );
			return HOOK_CONTINUE;
		}
	}
	
	Cvar::Set( strCommand, strValue );
	
	return HOOK_CONTINUE;
}

HookReturnCode PlayerPickupEntity( CHL2MP_Player@ pPlayer, const string& in skey )
{
	// If it's not item_healthvial
	if ( !Utils.StrEql( skey, "item_healthvial" ) )
		return HOOK_HANDLED;
	
	if ( !pPlayer.IsPracticallyZombie() )
		return HOOK_HANDLED;
	
	if ( Math::RandomInt(1, 100) <= Cvar::GrabInt( "cure_percentage" ) )
	{
		// Remove infection
		pPlayer.UnInfectPlayer();
		
		// If we are just going to do instant cure, skip the rest
		if ( Cvar::GrabBool( "cure_instant" ) )
		{
			Engine.PrintC( chat, pPlayer, FormatToString( "[{GREEN}Cure{DEFAULT}] You have been {GREEN}cured{DEFAULT} from the infection.\n" ) );
			return HOOK_HANDLED;
		}
		else
		{
			Engine.PrintC( chat, pPlayer, FormatToString( "[{GREEN}Cure{DEFAULT}] Your infection is gone, {RED}for now{DEFAULT}...\n" ) );
			// Redo infection!
			pPlayer.InfectPlayer( Cvar::GrabFloat( "cure_infectiondelay" ) );
		}
	}
	return HOOK_CONTINUE;
}
