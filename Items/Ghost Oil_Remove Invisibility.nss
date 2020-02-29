////////////////////////////////////
// tdn_alc_rec077
// Ghost Oil Effect
// Written: 02/09/2020
// Written By: InfyDae
//
//
// Description: Grenadelike - AoE against NPCs that removes Invisibility and stops NPC Heartbeat Invisibility application.
////////////////////////////////////

int removeInvisibility(object oTarget);

void main()
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location lLoc = GetLocation(oTarget);
    if (!GetIsObjectValid(oTarget)) lLoc = GetItemActivatedTargetLocation();

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (GetIsEnemy(oTarget, oPC))
        {
            // Flag to prevent application of invisibility
            SetLocalInt(oTarget, "GhostOil", 1);

            removeInvisibility(oTarget);
        }
        
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
     }
}

// Removes any Invisibility effects present on the passed in object
void removeInvisibility(object oTarget){
    effect eLoop=GetFirstEffect(oTarget);
    
    while (GetIsEffectValid(eLoop))
    {
        if (GetEffectType(eLoop)==EFFECT_TYPE_INVISIBILITY)
        {
            // We can't return early here because the object may have multiple invis effects
            RemoveEffect(oTarget, eLoop);
        }

        eLoop=GetNextEffect(oTarget);
    }
}