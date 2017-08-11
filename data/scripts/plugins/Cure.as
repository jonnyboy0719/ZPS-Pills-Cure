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

HookReturnCode PlayerPickupEntity( CBasePlayer@ pPlayer, const string& in skey )
{
	// If the player doesn't exist
	if ( pPlayer is null )
		return HOOK_HANDLED;
	
	// If it's not item_healthvial
	if ( Utils.StrEql( skey, "item_healthvial" ) )
		return HOOK_HANDLED;
	
	// Remove infection
	pPlayer.UnInfectPlayer();
	
	if ( pPlayer.IsPracticallyZombie() )
	{
		if ( CureSettings_Instant )
			Engine.Print( chat, pPlayer, "[Cure] You have been \0x006400cured\x01 from the infection.\n" );
		else
			Engine.Print( chat, pPlayer, "[Cure] Your infection is gone, \0x8B0000for now\x01...\n" );
	}
	
	// If we are just going to do instant cure, skip the rest
	if ( CureSettings_Instant )
		return HOOK_HANDLED;
	
	// Redo infection!
	pPlayer.InfectPlayer( CureSettings_InfectionDelay );
	
	return HOOK_CONTINUE;
}
