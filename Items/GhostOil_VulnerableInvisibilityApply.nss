////////////////////////////////////
// util_dung_invis
// OnSpawn "Invisibility" for Creatures
// Writte: 3/24/2019 (V1.0)
// Written By: Aschent
//
//
// Description: Use for Ghosts, applies Invisibility effect
////////////////////////////////////

void main()
{
    // Get the object to apply the effect to
    object oNPC = OBJECT_SELF;

    // Early return if the object has the `GhostOil` effect applied to it
    int ghostOilApplied = GetLocalInt(oNPC, "GhostOil");
    if (ghostOilApplied > 0)
    {
        return;
    }

    // Declare the effect
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

    // TODO: Do not apply the invis effect if it already exists. Right now, if this script is called multiple times it will stack
    // Apply the effect instantly to the entering object
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oNPC);
}
