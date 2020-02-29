/////////////////////////////////
// tdn_tool_2
// OnUse for ItemDescriptionChanger
// Written: 02/10/2020
// Written By: InfyDae
//
//
// Description: Allows you to set the description of the targeted object.
////////////////////////////////////

int isValidTargetObject(object oTarget, object oPC);

void main()
{
  object oPC = GetItemActivator();
  object oTarget = GetItemActivatedTarget();
  object oRenamer = OBJECT_SELF;
  string explanation = "You are using the Item Description Changer. The next sentence spoken by your character will be the new description of [";
  
  if (isValidTargetObject(oTarget, oPC) == FALSE)
  {
    FloatingTextStringOnCreature("Invalid target", oPC, FALSE);
    return;
  }

  // Inform the the player how the item works
  FloatingTextStringOnCreature(explanation + GetName(oTarget) + "]", oPC, FALSE);

  // Store a reference to the object we intend to modify.
  // The actual modification occurs in OnPlayerChat() on next chat for the player
  SetLocalObject(oPC, "ObjectToSetDescription", oTarget);
}

// Determines if the targeted object should be able to be altered
int isValidTargetObject(object oTarget, object oPC)
{
  // Only items can be altered
  if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  {
    return FALSE;
  }

  object oTargetPosessor = GetItemPossessor(oTarget);
  // Only items owned by the player be altered
  if (GetIsObjectValid(oTargetPosessor) == FALSE || oTargetPosessor != oPC)
  {
    return FALSE;
  }

  // Plot items cannot be altered
  if (GetPlotFlag(oTarget))
  {
    return FALSE;
  }

  return TRUE;
}
