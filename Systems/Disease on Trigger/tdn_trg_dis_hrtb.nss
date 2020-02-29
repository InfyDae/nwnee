/////////////////////////////////
// tdn_trg_dis_hrtb
// Trigger Heartbeat
// Written: 02/11/2020
// Written By: InfyDae
//
//
// Description: Triggers a Fortitude Save vs Disease effect on a timer for PCs flagged by `tdn_trg_dis_entr`.
////////////////////////////////////

// Local constants for the script
float fInGameHourCoefficient = 15.0/60.0; // 15 real life minutes for every 60 in game ones
int iDiseaseFreqInHours = 2;
int iFortSaveDC = 20;
int iDiseaseType = DISEASE_RED_SLAAD_EGGS;
int iDiseaseVisual = VFX_DUR_FLIES;

void applyDisease(object oPC);

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oPC = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oPC))
    {
        if (GetIsPC(oPC))
        {
            applyDisease(oPC);
        }

        oPC = GetNextObjectInArea(oArea);
    }
}

void applyDisease(object oPC)
{
    int iTriggerDiseaseTimer = GetLocalInt(oPC, "TriggerDiseaseTimer");

    // If the character does not have the disease flag, return early
    if (iTriggerDiseaseTimer == 0)
    {
        return;
    }

    // Each heartbeat is 6 seconds. 10 hearts to a minute. 600 heartbeats to an hour.
    // We calculate the actual time in seconds then apply a coefficient of real time hours to in game hours
    float fDiseaseApplicationTime = (iDiseaseFreqInHours * 600) * fInGameHourCoefficient;

    if (iTriggerDiseaseTimer - 1 >= FloatToInt(fDiseaseApplicationTime))
    {
        SetLocalInt(oPC, "TriggerDiseaseTimer", 1);

        if (FortitudeSave(oPC, iFortSaveDC, SAVING_THROW_TYPE_DISEASE) == 0)
        {
            effect eDisease = EffectDisease(iDiseaseType);
            effect eDiseaseVisual = EffectVisualEffect(iDiseaseVisual);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDiseaseVisual, oPC, 2.0);
        }
    }
    else
    {
        // Increment the heartbeat timer if the disease wasn't applied
        SetLocalInt(oPC, "TriggerDiseaseTimer", iTriggerDiseaseTimer + 1);
    }
}
