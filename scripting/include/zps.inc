/**
 * Gets the owner of the entity
 */
stock GetInfection(client)
{
	return GetEntProp(client, Prop_Send, "m_IsInfected");
}

/**
 * Sets the owner of the entity
 */
stock SetInfection(client, value)
{
	// If the value is more than 1, send a warning
	if (value > 1)
		ThrowError("The value can't be more than 1!");

	SetEntProp(client, Prop_Send, "m_IsInfected", value);
}