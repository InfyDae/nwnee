/////////////////////////////////
// util_cr_undeath1
// OnDamaged event
// Written: ?
// Written By: ?
//
//
// Description: Attach to OnDamaged event. Tracks amount of damage dealt to the object executing the script.
////////////////////////////////////

void main()
{
    SetLocalInt(OBJECT_SELF, "GetDamageDealt", GetTotalDamageDealt());

    ExecuteScript("nw_c2_default6", OBJECT_SELF);
}
