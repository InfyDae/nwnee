/////////////////////////////////
// tdn_trg_dis_exit
// Trigger OnExit
// Written: 02/11/2020
// Written By: InfyDae
//
//
// Description: Removes flag from PCs for a Fortitude Save vs Disease created by `tdn_trg_dis_entr`.
////////////////////////////////////

void main()
{
    object oPC = GetEnteringObject();

    if (GetLocalInt(oPC, "TriggerDiseaseTimer") != 0)
    {
        DeleteLocalInt(oPC, "TriggerDiseaseTimer");
    }
}
