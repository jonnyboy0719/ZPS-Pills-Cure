/*
	Plugin Created by Johan "JonnyBoy0719" Ehrendahl
*/

// If set to delay, how many seconds should we wait until we re-infect em?
float CureSettings_InfectionDelay = 65.0f;

// If we should have instant cure, or just delay infection
bool CureSettings_Instant = false;

void PluginInit()
{
	// Hooks
	Events::Player::OnEntityPickedUp.Hook( @PlayerPickupEntity );
}

HookReturnCode PlayerPickupEntity( CHL2MP_Player@ pPlayer, const string& in skey )
{
	// If it's not item_healthvial
	if ( !Utils.StrEql( skey, "item_healthvial" ) )
		return HOOK_HANDLED;
	
	if ( !pPlayer.IsPracticallyZombie() )
		return HOOK_HANDLED;
	
	// Remove infection
	pPlayer.UnInfectPlayer();
	
	// If we are just going to do instant cure, skip the rest
	if ( CureSettings_Instant )
	{
		Engine.PrintC( chat, pPlayer, "[\x073EFF3ECure\x01] You have been \x073EFF3Ecured\x01 from the infection.\n" );
		return HOOK_HANDLED;
	}
	else
		Engine.PrintC( chat, pPlayer, "[\x073EFF3ECure\x01] Your infection is gone, \x078B0000for now\x01...\n" );
	
	// Redo infection!
	pPlayer.InfectPlayer( CureSettings_InfectionDelay );
	
	return HOOK_CONTINUE;
}
