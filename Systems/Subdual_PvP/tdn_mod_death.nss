/////////////////////////////////
// tdn_mod_death
// Module event OnPlayerDeath
// Written: 02/17/2020
// Written By: InfyDae
//
//
// Description: Causes players to be subdued on death/dying instead of being killed. Can be toggled on/off with !subdual.
////////////////////////////////////

#include "tdn_subdual_inc"

void main()
{
    // If the player is subdued, use that logic instead
    if (CheckSubdual(GetLastPlayerDied())) return;

    // Execute standard death script. Or, whatever TDN uses
    ExecuteScript("nw_o0_death", OBJECT_SELF);
}