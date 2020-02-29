/////////////////////////////////
// tdn_evt_ondist
// When:        OnDisturbed event for containers
// Written:     02/16/2020
// Written By:  InfyDae
// 
//
// Description: When a PC loots a container, nearby PCs will roll Sleight of Hand vs Spot in order to see if they noticed what was taken.
////////////////////////////////////

int getSleightOfHandDC(object oItem);
void rollOpposingSleightOfHand(object oPC, object oPCSpotter, object oItem, object oContainer, int iDC);

void main()
{
    // We only care about items being removed from a container
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED) return;

    object oContainer = OBJECT_SELF;
    object oPC = GetLastDisturbed();
    object oItem = GetInventoryDisturbItem();
    location lLoc = GetLocation(oPC);
    int iDC = getSleightOfHandDC(oItem);

    // Ignoring low weight/easy to steal objects
    if (iDC <= 0) return;

    // Grab all PCs nearby and let them roll to spot the item taken
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        // Ignore the looting player for spot checks
        if (oTarget != oPC && GetIsPC(oTarget)) rollOpposingSleightOfHand(oPC, oTarget, oItem, oContainer, iDC);

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}

int getSleightOfHandDC(object oItem)
{
    int iItemWeight = GetWeight(oItem);

    // Ignoring light items (50 == 5.0 pounds)
    if (iItemWeight <= 50) return 0;
    
    // Default to the item's weight for additional DC
    return iItemWeight / 10;
}

void rollOpposingSleightOfHand(object oPC, object oPCSpotter, object oItem, object oContainer, int iDC)
{
    // Auto-fail if not trained (-1) in Sleight of Hand, otherwise roll:
    // Sleight of Hand skill + d20 vs Spot skill + d20 + Item DC
    if (GetSkillRank(SKILL_PICK_POCKET, oPC) == -1 ||
        GetSkillRank(SKILL_PICK_POCKET, oPC) + d20() <= GetSkillRank(SKILL_SPOT, oPCSpotter) + d20() + iDC)
    {
        SendMessageToPC(oPCSpotter, "You spotted " + GetName(oPC) + " take a " + GetName(oItem) + " from " + GetName(oContainer) + ".");
    }
}