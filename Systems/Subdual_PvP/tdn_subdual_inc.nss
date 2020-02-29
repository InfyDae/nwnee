/////////////////////////////////
// tdn_subdual_inc
// To be called by module events OnPlayerDying and OnPlayerDeath
// Written: 02/20/2020
// Written By: InfyDae
//
//
// Description: Causes players to be subdued on death/dying instead of being killed. Can be toggled on/off with !subdual.
////////////////////////////////////

int DEBUG = FALSE;
int DEBUG_FORCE_SUBUE = FALSE;

// Number of hits while subdued before a PC dies
int SUBDUE_DEATH = 10;
// Number of hits between displaying "is subdued" above the PC
int SUBDUE_MSG_INTERVAL = 3;
// Duration in seconds of the subdue effect
float SUBDUE_TIMER = 300.0;

// Call only in OnPlayerDeath and OnPlayerDying
// Will return TRUE if the PC has been subdued or FALSE if their source of death did not have subdual on
int CheckSubdual(object oPC);
// Adjusts PC health to them from going negative
void SetSubdualHealth(object oPC);
// Applies the subdue effect
void SetSubdued(object oPC, int i);
// Checks attacker of PC for subdual flag
int GetSubdual(object oPC);
// Checks a PC object for a subdual flag
int GetSubdualOffFlag(object oPC, object oKiller);
// Checks a PC object while they're subdued to see if they've been healed. If so, it removes subdual's effects
void CheckHealedDuringSubdual(object oPC, float fCheckTimer);
// Strips a PC of all positive effects if any. Used by subdual script to stop Regeneration and its ilk
void RemovePositiveEffects(object oPC);

// Main subdual check funciton. Call only in OnPlayerDeath and OnPlayerDying.
int CheckSubdual(object oPC)
{
    int iWasSubdued = GetSubdual(oPC);

    if (iWasSubdued)
    {
        int iSubdualHits = GetLocalInt(oPC, "SubdualHits");
        iSubdualHits++;

        if (DEBUG) SendMessageToPC(GetFirstPC(), GetName(oPC) + " iSubdualHits value: " + IntToString(iSubdualHits) + "");

        // Early return if we've reached the number of hits required to kill someone when subdued
        if (iSubdualHits >= SUBDUE_DEATH)
        {
            // Reset the number of subdual hits after the PC dies. Otherwise subsequent subdual will kill them instantly
            // We delay this to ensure both OnDeath and OnDying return correctly on PC death
            DelayCommand(5.0, DeleteLocalInt(oPC, "SubdualHits"));

            return FALSE;
        };

        SetLocalInt(oPC, "SubdualHits", iSubdualHits);
        SetSubdualHealth(oPC);
        SetSubdued(oPC, iSubdualHits);

        // Queue up checking the PC's health in case they've been helped up
        DelayCommand(5.0, CheckHealedDuringSubdual(oPC, 5.0));

        return TRUE;
    }

    if (DEBUG) SendMessageToPC(GetFirstPC(), "Subdual is OFF. Allowing death of " + GetName(oPC));

    return FALSE;
}

int GetSubdual(object oPC)
{
    int iSubdualTotal = 0;

    if (DEBUG_FORCE_SUBUE) iSubdualTotal++;

    // Try all possible hostile actors. Zero to many of these may return a value so we use the sum of all
    iSubdualTotal += GetSubdualOffFlag(oPC, GetLastAttacker(oPC));
    iSubdualTotal += GetSubdualOffFlag(oPC, GetGoingToBeAttackedBy(oPC));
    iSubdualTotal += GetSubdualOffFlag(oPC, GetLastDamager());
    iSubdualTotal += GetSubdualOffFlag(oPC, GetLastKiller());
    iSubdualTotal += GetSubdualOffFlag(oPC, GetLastHostileActor(oPC));

    return iSubdualTotal;
}

int GetSubdualOffFlag(object oPC, object oKiller)
{
    // A player cannot subdue themselves
    if (GetIsObjectValid(oKiller) && oKiller != oPC)
    {
        // Handle PCs and DM's possessing creatures
        if (GetIsPC(oKiller) || GetIsDMPossessed(oKiller))
        {
            if (GetLocalInt(oKiller, "SubdualOffFlag")) return FALSE;

            return TRUE;
        }
        // Handle summons & familiars
        else if (GetIsObjectValid(GetMaster(oKiller)))
        {
            object oMaster = GetMaster(oKiller);
            
            if (GetIsPC(oMaster))
            {
                if (GetLocalInt(oMaster, "SubdualOffFlag")) return FALSE;

                return TRUE;
            }
        }
    }

    return FALSE;
}

void SetSubdualHealth(object oPC)
{
    if ((GetCurrentHitPoints(oPC)) < -9)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    }
    else if ((GetCurrentHitPoints(oPC)) < 1)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(abs(GetCurrentHitPoints(oPC)) + 1), oPC);
    }
}

void SetSubdued(object oPC, int iSubdualTotal)
{
    string sSubduedMessage = "**Subdued**";
    int iACDecrease = GetAC(oPC);

    // Wipe all actions from the PCs queue to ensure actions will apply
    AssignCommand(oPC, ClearAllActions());

    // Display that the PC has been subuded to everyone nearby every few hits (and first)
    if (((iSubdualTotal - 1) % SUBDUE_MSG_INTERVAL) == 0) AssignCommand(oPC, ActionSpeakString(sSubduedMessage));

    // Keep the PC on the ground
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, SUBDUE_TIMER));

    // Blind them for the duration
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, SUBDUE_TIMER);

    // Lower their AC to 0 by applying a negative to every type
    // NOTE: This does NOT remove base AC from items. Such as chest, shield, etc
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(iACDecrease, AC_ARMOUR_ENCHANTMENT_BONUS), oPC, SUBDUE_TIMER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(iACDecrease, AC_DEFLECTION_BONUS), oPC, SUBDUE_TIMER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(iACDecrease, AC_DODGE_BONUS), oPC, SUBDUE_TIMER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(iACDecrease, AC_NATURAL_BONUS), oPC, SUBDUE_TIMER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(iACDecrease, AC_SHIELD_ENCHANTMENT_BONUS), oPC, SUBDUE_TIMER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(iACDecrease, AC_VS_DAMAGE_TYPE_ALL), oPC, SUBDUE_TIMER);

    if (iSubdualTotal == 1)
    {
        // Strip all positive effects. Spells like Regenerate might persist
        RemovePositiveEffects(oPC);

        // Fade the PC's view out one time to make the subdual very obvious
        FadeToBlack(oPC);
        DelayCommand(3.0, FadeFromBlack(oPC));
    }

    // Keep the PC disabled
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE, oPC)));
    AssignCommand(oPC, SetCommandable(FALSE, oPC));
}

void CheckHealedDuringSubdual(object oPC, float fCheckTimer)
{
    // Early return if this PC is not subdued
    if (GetLocalInt(oPC, "SubdualHits") <= 0) return;
    
    // Queue up another check so long as the PC is subdued
    DelayCommand(fCheckTimer, CheckHealedDuringSubdual(oPC, fCheckTimer));

    // If their HP is above 1, they must have been healed by something besides the subdual scripts
    if (GetCurrentHitPoints(oPC) > 1)
    {
        // Reset the subdual flag
        DeleteLocalInt(oPC, "SubdualHits");

        // Clear the on ground animation
        AssignCommand(oPC, ClearAllActions());

        // Allow the PC to move again
        AssignCommand(oPC, SetCommandable(TRUE, oPC));

        // Remove subdual's negative effects
        effect eEffect = GetFirstEffect(oPC);

        while (GetIsEffectValid(eEffect))
        {
            if (GetEffectType(eEffect) == EFFECT_TYPE_AC_DECREASE || GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS)
            {
                RemoveEffect(oPC, eEffect);
            }

            eEffect = GetNextEffect(oPC);
        }

        // Inform the player that they were helped up
        FloatingTextStringOnCreature("Healing brought you out of your subdued state", oPC, FALSE);
    }
}

void RemovePositiveEffects(object oPC)
{
        // Remove subdual's negative effects
        effect eEffect = GetFirstEffect(oPC);

        //Search for positive effects. The list of negative ones is shorter so we ensure it isn't negative
        while (GetIsEffectValid(eEffect))
        {
            if (GetEffectType(eEffect) != EFFECT_TYPE_ABILITY_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_AC_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_ATTACK_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_DAMAGE_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_SAVING_THROW_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_SPELL_RESISTANCE_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_SKILL_DECREASE &&
                GetEffectType(eEffect) != EFFECT_TYPE_BLINDNESS &&
                GetEffectType(eEffect) != EFFECT_TYPE_DEAF &&
                GetEffectType(eEffect) != EFFECT_TYPE_PARALYZE &&
                GetEffectType(eEffect) != EFFECT_TYPE_NEGATIVELEVEL)
                {
                    //Remove effect if it is positive
                    RemoveEffect(oPC, eEffect);
                }

            eEffect = GetNextEffect(oPC);
        }
}