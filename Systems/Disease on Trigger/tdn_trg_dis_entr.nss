/////////////////////////////////
// tdn_trg_dis_entr
// Trigger OnEnter
// Written: 02/11/2020
// Written By: InfyDae
//
//
// Description: Flag PCs for a Fortitude Save vs Disease to be triggered on heartbeat by `tdn_trg_dis_hrtb`.
////////////////////////////////////

void main()
{
    object oPC = GetEnteringObject();

    if (GetLocalInt(oPC, "TriggerDiseaseTimer") == 0)
    {
        SetLocalInt(oPC, "TriggerDiseaseTimer", 1);
    }
}
