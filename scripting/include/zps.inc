/**
 * Returns whether or not a survivor is infected.
 */
stock GetInfection(client)
{
	return GetEntProp(client, Prop_Send, "m_IsInfected");
}

/**
 * Toggles survivors infection
 */
stock SetInfection(client, value)
{
	if(value == 1)
	{
		SetEntPropFloat(client,Prop_Data,"m_tbiPrev",GetGameTime() + 60.0);
		SetEntProp(client,Prop_Send,"m_IsInfected",1);
	}
	else if(value == 0)
	{
		SetEntProp(client,Prop_Send,"m_IsInfected",0);
	}
}
