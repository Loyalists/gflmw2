#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

main()
{
	anim_human();
	anim_vehicles();
	anim_ropes();
	level_dialog();
}

#using_animtree( "generic_human" );
anim_human()
{
	// RAPPEL
	level.scr_anim[ "generic" ][ "fastrope_fall" ]		= %fastrope_fall;
	level.scr_anim[ "generic" ][ "bridge_rappel_L" ]	= %bridge_rappel_L;
	level.scr_anim[ "generic" ][ "bridge_rappel_R" ]	= %bridge_rappel_R;
	addNotetrack_customFunction( "generic", "over_solid", maps\so_bridge_code::ai_rappel_over_ground_death_anim, "bridge_rappel_L" );
	addNotetrack_customFunction( "generic", "over_solid", maps\so_bridge_code::ai_rappel_over_ground_death_anim, "bridge_rappel_R" );
}

#using_animtree( "vehicles" );
anim_vehicles()
{
	level.scr_animtree[ "ucav_flyby" ]					= #animtree;
	level.scr_model[ "ucav_flyby" ]						= "vehicle_f15";
	level.scr_anim[ "ucav_flyby" ][ "path_a" ]			= %predator_flyby;
}

#using_animtree( "script_model" );
anim_ropes()
{
	level.scr_animtree[ "rope" ] 						= #animtree;	
	level.scr_anim[ "rope" ][ "coop_bridge_rappel_L" ]	= %coop_bridge_rappel_L;
	level.scr_anim[ "rope" ][ "coop_bridge_rappel_R" ]	= %coop_bridge_rappel_R;
	level.scr_anim[ "rope" ][ "coop_ropedrop_01" ]		= %coop_ropedrop_01;
}

level_dialog()
{
	level.scr_radio[ "so_bridge_hqr_enemy_helo" ]		= "so_bridge_hqr_enemy_helo";
}
