#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_props;

main()
{
	add_smoking_notetracks( "generic" );
	add_cellphone_notetracks( "generic" );

	maps\_patrol_anims::main();
	maps\so_ghillies_anim::main();
	
	dialog();
}

dialog()
{
// RADIATION
	//Careful. Watch for posts marking radiation pockets. If you absorb too much...
	level.scr_radio[ "so_hid_ghil_rad_warning" ]	= "so_hid_ghil_rad_warning";

// HINTS
	//If you think you see a sniper, watch that area and wait for him to make a mistake.
	level.scr_radio[ "so_hid_ghil_sniper_hint" ]	= "so_hid_ghil_sniper_hint";
	//Be patient. Watch the patrolling enemy patterns. Find a time to take them down quickly and quietly.
	level.scr_radio[ "so_hid_ghil_patrol_hint" ]	= "so_hid_ghil_patrol_hint";
	//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
	level.scr_radio[ "so_hid_ghil_pri_attractattn" ]= "so_hid_ghil_pri_attractattn";
	
// STEALTH KILLS
	//Good night.
	level.scr_radio[ "so_hid_ghil_goodnight" ]		= "so_hid_ghil_goodnight";
	//Beautiful.
	level.scr_radio[ "so_hid_ghil_beautiful" ]		= "so_hid_ghil_beautiful";
	//Perfect
	level.scr_radio[ "so_hid_ghil_perfect" ]		= "so_hid_ghil_perfect";

// QUIET KILLS
	//Tango down
	level.scr_radio[ "so_hid_ghil_tango_down" ]		= "so_hid_ghil_tango_down";
	//He's down
	level.scr_radio[ "so_hid_ghil_hesdown" ]		= "so_hid_ghil_hesdown";
	//Target neutralized
	level.scr_radio[ "so_hid_ghil_neutralized" ]	= "so_hid_ghil_neutralized";

// BASIC KILLS
	//Sloppy work
	level.scr_radio[ "so_hid_ghil_sloppy" ]			= "so_hid_ghil_sloppy";
	//Too noisy
	level.scr_radio[ "so_hid_ghil_noisy" ]			= "so_hid_ghil_noisy";
	//You can do better
	level.scr_radio[ "so_hid_ghil_do_better" ]		= "so_hid_ghil_do_better";
	
// MULTI KILLS
	//Double kill… excellent.
	level.scr_radio[ "so_hid_ghil_double_kill" ]	= "so_hid_ghil_double_kill";
	//Triple kill… most impressive!
	level.scr_radio[ "so_hid_ghil_triple_kill" ]	= "so_hid_ghil_triple_kill";
}