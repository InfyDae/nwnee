/////////////////////////////////
// util_cr_undeath0
// OnDeath event
// Written: ?
// Written By: ?
//
//
// Description: Attach to OnDeath event. When triggered gives object a chance to heal and come back to life.
////////////////////////////////////

#include "_tdn_utils"

void main()
{
    int nDmg = GetLocalInt(OBJECT_SELF, "GetDamageDealt");
    int nHeal = GetLocalInt(OBJECT_SELF, "HEALAMOUNT");
    if (!nHeal) nHeal = d3();
    int nVFX = GetLocalInt(OBJECT_SELF, "VFX");
    if (!nVFX) nVFX = VFX_IMP_RAISE_DEAD;
    int nFort = GetLocalInt(OBJECT_SELF, "FORT");
    if (!nFort) nFort = 10;

    effect eRes = EffectResurrection();
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(nVFX);

    SetIsDestroyable(TRUE);
    if (FortitudeSave(OBJECT_SELF, nFort+nDmg))
        {
            SetIsDestroyable(FALSE, TRUE, TRUE);
            if (DEBUG()) { SendDebug("Executing Raise Effect"); }
            DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRes, OBJECT_SELF));
            DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF));
            return;
        }

    if (DEBUG()) { SendDebug("Undying reached end of script."); }
}
