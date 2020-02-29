/////////////////////////////////
// tdn_alc_rec166
// OnUse for Spicedust
// Written: 02/07/2020
// Written By: Aschent_
//
//
// Description: Causes enemies to Save Vs Fear or be effected by Fear (1 Round)
////////////////////////////////////

#include "X0_I0_SPELLS"

void main()
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location lLoc = GetLocation(oTarget);
    if (!GetIsObjectValid(oTarget)) lLoc = GetItemActivatedTargetLocation();
    float fDur = RoundsToSeconds(1);
    
    effect eFear = EffectFrightened();
    effect eFearVisual = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR); 

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
      if (GetIsEnemy(oTarget, oPC))
      {
        // We don't need to throw a save if they're immune to these effects already
        if (GetIsImmune(oTarget, SAVING_THROW_TYPE_MIND_SPELLS) == 0 && GetIsImmune(oTarget, SAVING_THROW_TYPE_FEAR) == 0)
        {
          if (WillSave(oTarget, 20, SAVING_THROW_TYPE_FEAR) == 0)
          {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDur);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFearVisual, oTarget, fDur);
          }
        }
      }
      
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
