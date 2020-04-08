/////////////////////////////////
// _mod_ondamage
// On damage taken by any object
// Written: 03/14/2020
// Written By: InfyDae
//
//
// Description: Triggers whenever an object takes any damage. e.g., once per missile in Magic Missile.
// Note: This event will fire a lot. Care should be taken to not add anything that won't evaluate quickly.
////////////////////////////////////

#include "nwnx_damage"

struct NWNX_Damage_DamageEventData KeepRegenCreaturesAlive(object oTarget, struct NWNX_Damage_DamageEventData data);
struct NWNX_Damage_DamageEventData ReduceDamageToAmount(struct NWNX_Damage_DamageEventData data, int iDamageAllowed);
int ApplyRemainingDamage(int iDamage, int iRemaining);

//////////////////////////////
//--Misc Helper Functions-- //
//////////////////////////////
int Max(int iFirst, int iSecond);
int Min(int iFirst, int iSecond);

void main()
{
    struct NWNX_Damage_DamageEventData data;
    data = NWNX_Damage_GetDamageEventData();

    object oTarget = OBJECT_SELF;

    data = KeepRegenCreaturesAlive(oTarget, data);

    NWNX_Damage_SetDamageEventData(data);
}

struct NWNX_Damage_DamageEventData KeepRegenCreaturesAlive(object oTarget, struct NWNX_Damage_DamageEventData data)
{
    // Don't allow regenerating creatures to die unless Fire or Acid is used against them
    if (GetLocalInt(oTarget, "REGENERATION_FIRE_ACID") && data.iFire <= 0 && data.iAcid <= 0)
    {
        // Drop health to 1 HP
        data = ReduceDamageToAmount(data, GetCurrentHitPoints(oTarget) - 1);
        
        float fDownDuration = 12.0; // 2 rounds
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, fDownDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oTarget, fDownDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget);
    }

    return data;
}

struct NWNX_Damage_DamageEventData ReduceDamageToAmount(struct NWNX_Damage_DamageEventData data, int iDamageAllowed)
{
    // Short circuit in cases where the damage dealt is <= the desired amount
    // We have to account for -1's here because they denote the absence of a damage type
    if ((
        Max(data.iBludgeoning, 0) +
        Max(data.iPierce, 0) +
        Max(data.iSlash, 0) +
        Max(data.iMagical, 0) +
        Max(data.iAcid, 0) +
        Max(data.iCold, 0) +
        Max(data.iDivine, 0) +
        Max(data.iElectrical, 0) +
        Max(data.iFire, 0) +
        Max(data.iNegative, 0) +
        Max(data.iPositive, 0) +
        Max(data.iSonic, 0) +
        Max(data.iBase, 0)
    ) <= iDamageAllowed)
    return data;

    data.iBludgeoning = ApplyRemainingDamage(data.iBludgeoning, iDamageAllowed);
    iDamageAllowed -= Max(data.iBludgeoning, 0);

    data.iPierce = ApplyRemainingDamage(data.iPierce, iDamageAllowed);
    iDamageAllowed -= Max(data.iPierce, 0);

    data.iSlash = ApplyRemainingDamage(data.iSlash, iDamageAllowed);
    iDamageAllowed -= Max(data.iSlash, 0);

    data.iMagical = ApplyRemainingDamage(data.iMagical, iDamageAllowed);
    iDamageAllowed -= Max(data.iMagical, 0);

    data.iAcid = ApplyRemainingDamage(data.iAcid, iDamageAllowed);
    iDamageAllowed -= Max(data.iAcid, 0);

    data.iCold = ApplyRemainingDamage(data.iCold, iDamageAllowed);
    iDamageAllowed -= Max(data.iCold, 0);

    data.iDivine = ApplyRemainingDamage(data.iDivine, iDamageAllowed);
    iDamageAllowed -= Max(data.iDivine, 0);

    data.iElectrical = ApplyRemainingDamage(data.iElectrical, iDamageAllowed);
    iDamageAllowed -= Max(data.iElectrical, 0);

    data.iFire = ApplyRemainingDamage(data.iFire, iDamageAllowed);
    iDamageAllowed -= Max(data.iFire, 0);

    data.iNegative = ApplyRemainingDamage(data.iNegative, iDamageAllowed);
    iDamageAllowed -= Max(data.iNegative, 0);

    data.iPositive = ApplyRemainingDamage(data.iPositive, iDamageAllowed);
    iDamageAllowed -= Max(data.iPositive, 0);

    data.iSonic = ApplyRemainingDamage(data.iSonic, iDamageAllowed);
    iDamageAllowed -= Max(data.iSonic, 0);

    data.iBase = ApplyRemainingDamage(data.iBase, iDamageAllowed);
    iDamageAllowed -= Max(data.iBase, 0);

    return data;
}

int ApplyRemainingDamage(int iDamage, int iRemaining)
{
    // Early return for -1 which denotes no damage
    if (iDamage == -1) return iDamage;

    return Min(iDamage, iRemaining);
}

int Max(int iFirst, int iSecond)
{
    if (iFirst >= iSecond) return iFirst;

    return iSecond;
}

int Min(int iFirst, int iSecond)
{
    if (iFirst <= iSecond) return iFirst;

    return iSecond;
}