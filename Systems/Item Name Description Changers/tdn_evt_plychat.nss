/////////////////////////////////
// tdn_evt_plychat
// To be merged into OnPlayerChat event
// Written: 02/11/2020
// Written By: InfyDae
//
//
// Description: Hook in OnPlayerChat to handle item name and description changes.
////////////////////////////////////

void handleItemSetName(object oPC, string sMessage);
void handleItemSetDescription(object oPC, string sMessage);

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    handleItemSetName(oPC, sMessage);
    handleItemSetDescription(oPC, sMessage);
}

void handleItemSetName(object oPC, string sMessage)
{
    object oToSetName = GetLocalObject(oPC, "ObjectToSetName");

    if (GetIsObjectValid(oToSetName))
    {
        if (GetStringLength(sMessage) > 0)
        {
            SetName(oToSetName, sMessage);
            DeleteLocalObject(oPC, "ObjectToSetName");
        }
    }
}

void handleItemSetDescription(object oPC, string sMessage)
{
    object oToSetDescription = GetLocalObject(oPC, "ObjectToSetDescription");

    if (GetIsObjectValid(oToSetDescription))
    {
        if (GetStringLength(sMessage) > 0)
        {
            SetDescription(oToSetDescription, sMessage);
            DeleteLocalObject(oPC, "ObjectToSetDescription");
        }
    }
}