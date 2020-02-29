/////////////////////////////////
// tdn_evt_plychat
// To be merged into TDN's OnPlayerChat module event
// Written: 02/22/2020
// Written By: InfyDae
//
//
// Description: Allows a use to toggle subdual mode off/on
////////////////////////////////////

void toggleSubdualMode(object oPC);

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    if (GetStringLeft(sMessage, 1) == "!")
    {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);

        if (GetStringLeft(sMessage, 8) == "!subdual") toggleSubdualMode(oPC);
    }
}

void toggleSubdualMode(object oPC)
{
    if (GetLocalInt(oPC, "SubdualOffFlag"))
    {
        SetLocalInt(oPC, "SubdualOffFlag", FALSE);
        FloatingTextStringOnCreature("Subdual mode ON", oPC, FALSE);
    }
    else
    {
        SetLocalInt(oPC, "SubdualOffFlag", TRUE);
        FloatingTextStringOnCreature("Subdual mode OFF", oPC, FALSE);
    }
}