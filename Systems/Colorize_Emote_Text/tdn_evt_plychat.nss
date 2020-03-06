/////////////////////////////////
// tdn_evt_plychat
// To be merged into TDN's OnPlayerChat module event
// Written: 03/03/2020
// Written By: InfyDae
//
//
// Description: Colorizes emotes by looking for the presence of asterisks
////////////////////////////////////

#include "x3_inc_string"

void toggleColorText(object oPC);
void applyColorToEmotes(object oPC, string sMessage, int affectOrphanAsterisks = TRUE);

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    if (GetStringLeft(sMessage, 1) == "!")
    {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);

        if (GetStringLeft(sMessage, 10) == "!colortext") toggleColorText(oPC);
    }

    // This just needs to be called somewhere. Maybe at the end of the script since it alters the text?
    applyColorToEmotes(oPC, sMessage);
}

void toggleColorText(object oPC)
{
    if (GetLocalInt(oPC, "ColorizeEmoteText"))
    {
        SetLocalInt(oPC, "ColorizeEmoteText", FALSE);
        FloatingTextStringOnCreature("Colorized emote text is OFF", oPC, FALSE);
    }
    else
    {
        SetLocalInt(oPC, "ColorizeEmoteText", TRUE);
        FloatingTextStringOnCreature("Colorized emote text is ON", oPC, FALSE);
    }
}

// Colorizes any text within pairs of asterisks or to the right of single asterisks
void applyColorToEmotes(object oPC, string sMessage, int affectOrphanAsterisks)
{
    // Early return for anyone who didn't opt in
    if (GetLocalInt(oPC, "ColorizeEmoteText") == FALSE) return;

    // Tan color. NWN RGB color picker: https://colortoken.nwn1.net/?rgb=210,180,140
    string sTextColor = "653";
    string sNewMessage = "";
    string sCurrChar = "";
    int sMessageLength = GetStringLength(sMessage);
    int iAsteriskFound = -1;
    int iReadStringPointer = 0;
    int iIndex;

    // Walk the length of the strength. Colorizing as we go
    for (iIndex = 0; iIndex < sMessageLength; iIndex++ )
    {
        sCurrChar = GetSubString(sMessage, iIndex, 1);

        if (sCurrChar == "*")
        {
            // Matching pair. Apply coloring
            if (iAsteriskFound > -1)
            {
                // Colorize text that appeared between the two asterisks
                sNewMessage += StringToRGBString(GetSubString(sMessage, iAsteriskFound + 1, iIndex - iAsteriskFound - 1), sTextColor);
                iAsteriskFound = -1;
            }
            // Only one asterisk so far. Append non-asterisk text so far
            else
            {
                sNewMessage += GetSubString(sMessage, iReadStringPointer, iIndex - iReadStringPointer);
                iAsteriskFound = iIndex;
            }

            // Update pointers tracking what we've read so far
            iReadStringPointer = iIndex + 1;
        }
    }

    // Handle the unpaired asterisk if it exists. Otherwise, just grab what's left if anything
    if (affectOrphanAsterisks && iAsteriskFound > -1) sNewMessage += StringToRGBString(GetStringRight(sMessage, sMessageLength - iAsteriskFound - 1), sTextColor);
    else sNewMessage += GetSubString(sMessage, iReadStringPointer, sMessageLength - iReadStringPointer);

    SetPCChatMessage(sNewMessage);
}
