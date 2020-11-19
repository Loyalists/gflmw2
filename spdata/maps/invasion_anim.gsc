#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\invasion;


main_anim()
{
	vehicles();
	anims();
	dialog();
	script_models();
	player();
}

/*
Here are the anims for humvee exit


V1 are guys from first vehicle
V2 are from 2nd one

Anim names match vehicle tags for script node
Guy1 --> tag_guy1
Guy0 --> tag_guy0
Passenger --> tag_passenger
Driver --> tag_driver


- invasion_humvee_exit_v1_guy1_idle
- invasion_humvee_exit_v1_guy1_react
- invasion_humvee_exit_v1_passenger_idle
- invasion_humvee_exit_v1_passenger_react

"explosion_react1" "explosion_react2"


- invasion_humvee_exit_v2_driver_idle
- invasion_humvee_exit_v2_driver_react
- invasion_humvee_exit_v2_guy0_idle
- invasion_humvee_exit_v2_guy0_react
- invasion_humvee_exit_v2_guy1_idle
- invasion_humvee_exit_v2_guy1_react
- invasion_humvee_exit_v2_passenger_idle
- invasion_humvee_exit_v2_passenger_react
*/

/*
parachute_cargo_animated


animations
paradrop_cargo_chute
paradrop_cargo_vehicle

animation
paratrooper_jet_opendoors
*/

/*
Use this model:
//iw4-depot/iw4/game/model_export/props/parachute/parachute_hanging_animated_char_invasion_lod0.XMODEL_EXPORT
invasion_parachute_hanging_char_animated
With these anims:

parachute_detach_reaction
parachute_detach_idle
parachute_detach_endidle
parachute_detach_death
*/



#using_animtree( "script_model" );
script_models()
{
	level.scr_animtree[ "tangled_chute_parachute" ]					 = #animtree;
	level.scr_anim[ "tangled_chute_parachute" ][ "idle" ][0]		 = %parachute_detach_idle;
	level.scr_anim[ "tangled_chute_parachute" ][ "end_idle" ][0]		 = %parachute_detach_endidle;
	level.scr_anim[ "tangled_chute_parachute" ][ "reaction" ]		 = %parachute_detach_reaction;
	level.scr_anim[ "tangled_chute_parachute" ][ "death" ]		 = %parachute_detach_death;
	level.scr_model[ "tangled_chute_parachute" ]					 = "invasion_parachute_hanging_char_animated";
	
	
	level.scr_animtree[ "burning_tree" ] 								 = #animtree;
	level.scr_model[ "burning_tree" ]					 = "foliage_tree_oak_1_animated";
	level.scr_anim[ "burning_tree" ][ "tree_oak_fire" ][0]						 = %tree_oak_fire;

	level.scr_animtree[ "roof_landing_parachute" ]					 = #animtree;
	level.scr_anim[ "roof_landing_parachute" ][ "roof_landing_parachute" ]		 = %invasion_paratrooper_roof_landing_parachute;
	level.scr_model[ "roof_landing_parachute" ]					 = "parachute_roof";



	level.scr_animtree[ "distant_parachute_guy" ]					 = #animtree;
	level.scr_anim[ "distant_parachute_guy" ][ "distant_parachute_guy_left1" ]		 = %paratrooper_jump_leftA_chute;
	level.scr_anim[ "distant_parachute_guy" ][ "distant_parachute_guy_right1" ]		 = %paratrooper_jump_RightA_chute;
	level.scr_anim[ "distant_parachute_guy" ][ "distant_parachute_guy_left2" ]		 = %paratrooper_jump_leftB_chute;
	level.scr_anim[ "distant_parachute_guy" ][ "distant_parachute_guy_right2" ]		 = %paratrooper_jump_RightB_chute;


	level.scr_model[ "distant_parachute_guy" ]					 = "parachute_deploy";
	
	
	level.scr_animtree[ "paradrop_cargo_tank_chuteA" ]					 = #animtree;
	level.scr_anim[ "paradrop_cargo_tank_chuteA" ][ "paradrop_cargo_tank_chuteA" ]		 = %paradrop_cargo_tank_chuteA;
	level.scr_model[ "paradrop_cargo_tank_chuteA" ]					 = "parachute_tank_animated";
	level.scr_animtree[ "paradrop_cargo_tank_chuteB" ]					 = #animtree;
	level.scr_anim[ "paradrop_cargo_tank_chuteB" ][ "paradrop_cargo_tank_chuteB" ]		 = %paradrop_cargo_tank_chuteB;
	level.scr_model[ "paradrop_cargo_tank_chuteB" ]					 = "parachute_tank_animated";
	level.scr_animtree[ "paradrop_cargo_tank_chuteC" ]					 = #animtree;
	level.scr_anim[ "paradrop_cargo_tank_chuteC" ][ "paradrop_cargo_tank_chuteC" ]		 = %paradrop_cargo_tank_chuteC;
	level.scr_model[ "paradrop_cargo_tank_chuteC" ]					 = "parachute_tank_animated";
	
	level.scr_animtree[ "bmp_chute_paradrop" ]					 = #animtree;
	level.scr_anim[ "bmp_chute_paradrop" ][ "bmp_chute_paradrop" ]		 = %paradrop_cargo_chute;
	level.scr_model[ "bmp_chute_paradrop" ]					 = "parachute_cargo_animated";
}

#using_animtree( "vehicles" );
vehicles()
{
	level.scr_animtree[ "btr_ground_smash" ]					 = #animtree;
	level.scr_anim[ "btr_ground_smash" ][ "btr_ground_smash" ]		 = %invasion_btr_crash_btr;
	level.scr_model[ "btr_ground_smash" ]					 = "vehicle_btr80";
	
	level.scr_animtree[ "btr_squashedcar" ]					 = #animtree;
	level.scr_anim[ "btr_squashedcar" ][ "btr_squashedcar" ]		 = %invasion_btr_crash_squashedcar;
	level.scr_model[ "btr_squashedcar" ]					 = "vehicle_80s_sedan1_tankcrush";


	
	level.scr_animtree[ "bmp_paradrop" ]					 = #animtree;
	level.scr_anim[ "bmp_paradrop" ][ "bmp_paradrop" ]		 = %paradrop_cargo_vehicle;
	level.scr_model[ "bmp_paradrop" ]					 = "vehicle_btr80";
	
	level.scr_animtree[ "anatov_opendoors" ]					 = #animtree;
	level.scr_anim[ "anatov_opendoors" ][ "anatov_opendoors" ]		 = %paratrooper_jet_opendoors;
	
	level.scr_animtree[ "hummer2" ]					 = #animtree;
	level.scr_anim[ "hummer2" ][ "invasion_opening_hummer2" ]		 = %invasion_opening_hummer2;
	
	level.scr_animtree[ "hummer1" ]					 = #animtree;
	level.scr_anim[ "hummer1" ][ "invasion_opening_hummer1" ]		 = %invasion_opening_hummer1;
	
	//level.scr_animtree[ "btr80" ]					 = #animtree;
	//level.scr_anim[ "btr80" ][ "invasion_opening_BTR" ]		 = %invasion_opening_BTR;
	
	//addNotetrack_customFunction( <animname>, <notetrack> , <function> , <anime> );
	//addNotetrack_customFunction( "btr80", "BTRfire", ::btr80_notetrack_fire, "invasion_opening_BTR" );
}

//#using_animtree( "vehicles" );
//bmp_door_close()
//{
//	self ClearAnim( %bmp_doors_open, 0 );
//	self SetAnim( %bmp_doors_close );
//}


#using_animtree( "player" );
player()
{
	level.scr_anim[ "player_hummer_ride" ][ "player_hummer_ride" ]						 = %invasion_opening_hummer2_player;
	level.scr_animtree[ "player_hummer_ride" ] 								 = #animtree;
	level.scr_model[ "player_hummer_ride" ] 									 = "ch_viewhands_player_gk_ump9";
}

#using_animtree( "generic_human" );
anims()
{
	level.scr_anim[ "generic" ][ "invasion_opening_hummer1_soldier2" ] = %invasion_opening_hummer1_soldier2;
	level.scr_anim[ "generic" ][ "invasion_opening_hummer1_soldier1" ] = %invasion_opening_hummer1_soldier1;
	level.scr_anim[ "generic" ][ "invasion_opening_hummer2_soldier1" ] = %invasion_opening_hummer2_soldier1;
	
	//invasion_opening_hummer2_player  - play on player viewmodel
	
	level.scr_anim[ "generic" ][ "invasion_humvee_exit_v1_guy1_idle" ][ 0 ] = %invasion_humvee_exit_v1_guy1_idle;
	level.scr_anim[ "generic" ][ "invasion_humvee_exit_v1_guy1_react" ] = %invasion_humvee_exit_v1_guy1_react;
	
	/*
	addNotetrack_flag( "generic", "explosion_react1", "explosion_react1", "invasion_humvee_exit_v1_guy1_react" );
	addNotetrack_flag( "generic", "explosion_react2", "explosion_react2", "invasion_humvee_exit_v1_guy1_react" );
	
	addNotetrack_flag( "generic", "explosion_react1", "explosion_react1", "invasion_humvee_exit_v1_passenger_react" );
	addNotetrack_flag( "generic", "explosion_react2", "explosion_react2", "invasion_humvee_exit_v1_passenger_react" );
	*/
	
	
	//addNotetrack_customFunction( <animname>, <notetrack> , <function> , <anime> );
	addNotetrack_customFunction( "generic", "explosion_react1", ::humvee_explosion1, "invasion_humvee_exit_v1_guy1_react" );
	addNotetrack_customFunction( "generic", "explosion_react2", ::humvee_explosion2, "invasion_humvee_exit_v1_guy1_react" );
	//addNotetrack_flag( "generic", "explosion_react1", "explosion_react1" );
	//addNotetrack_flag( "generic", "explosion_react2", "explosion_react2" );
	
	
	level.scr_anim[ "generic" ][ "invasion_humvee_exit_v1_passenger_idle" ][ 0 ] = %invasion_humvee_exit_v1_passenger_idle;
	level.scr_anim[ "generic" ][ "invasion_humvee_exit_v1_passenger_react" ] = %invasion_humvee_exit_v1_passenger_react;
	

	level.scr_anim[ "generic" ][ "invasion_parachute_ground_detach_idle" ][ 0 ] = %invasion_parachute_ground_detach_idle;
	level.scr_anim[ "generic" ][ "tangled_guy_trys_to_free_self" ] = %invasion_parachute_ground_detach_reaction;
	level.scr_anim[ "generic" ][ "invasion_parachute_ground_detach_death	" ] = %invasion_parachute_ground_detach_death;

	level.scr_anim[ "generic" ][ "distant_parachute_guy_left1" ] 		 = %paratrooper_jump_leftA_guy;
	level.scr_anim[ "generic" ][ "distant_parachute_guy_right1" ] 		 = %paratrooper_jump_RightA_guy;
	level.scr_anim[ "generic" ][ "distant_parachute_guy_left2" ] 		 = %paratrooper_jump_leftB_guy;
	level.scr_anim[ "generic" ][ "distant_parachute_guy_right2" ] 		 = %paratrooper_jump_RightB_guy;

	//level.scr_anim[ "generic" ][ "airdrop_idles" ][ 0 ]		 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "pronehide_dive" ] 		 = %hunted_dive_2_pronehide_v1;

	level.scr_anim[ "generic" ][ "roof_landing_parachute" ] 		 = %invasion_paratrooper_roof_landing;
	level.scr_anim[ "generic" ][ "rolldeath" ]		 = %invasion_paratrooper_roof_landing_rolldeath;
	level.scr_anim[ "generic" ][ "crawldeath" ]		 = %invasion_paratrooper_roof_landing_crawldeath;
	//addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "generic", "roll_death", 			::notetrack_roll_death, "roof_landing_parachute" );
	addNotetrack_customFunction( "generic", "crawl_death_start", 	::notetrack_crawl_death_start, "roof_landing_parachute" );
	addNotetrack_customFunction( "generic", "crawl_death", 			::notetrack_crawl_death, "roof_landing_parachute" );
	
	addNotetrack_flag( "generic", "roll_death", 			"roll_death", "roof_landing_parachute" );
	addNotetrack_flag( "generic", "crawl_death_start", 	"crawl_death_start", "roof_landing_parachute" );
	addNotetrack_flag( "generic", "crawl_death", 		"crawl_death", "roof_landing_parachute" );


	//level.scr_anim[ "generic" ][ "airdrop_idles" ][ 0 ]		 = %killhouse_gaz_idleA;
	//level.scr_anim[ "generic" ][ "airdrop_idles" ][ 1 ]		 = %killhouse_gaz_idleB;
	
	
	level.scr_anim[ "generic" ][ "invasion_vehicle_cover_dialogue_guy1" ] = %invasion_vehicle_cover_dialogue_guy1;
	level.scr_anim[ "generic" ][ "invasion_vehicle_cover_dialogue_guy1_idle" ][ 0 ] = %invasion_vehicle_cover_dialogue_guy1_idle;
	level.scr_anim[ "generic" ][ "invasion_vehicle_cover_dialogue_guy2" ] = %invasion_vehicle_cover_dialogue_guy2;

	/*
	dialog_inv_six_gimmesitrep
	dialog_inv_sgw_meatlocker
	dialog_inv_six_status
	dialog_inv_sgw_unconscious
	dialog_inv_six_whatelse
	dialog_inv_sgw_supplydrop
	dialog_inv_six_sentrygunsouth

	notetrack for dunn to check it out
	dunn_checkout
	*/
	
	//addNotetrack_customFunction( <animname>, <notetrack> , <function> , <anime> );
	addNotetrack_customFunction( "generic", "dialog_inv_six_gimmesitrep", ::notetrack_gimmesitrep, "invasion_vehicle_cover_dialogue_guy2" );
	addNotetrack_customFunction( "generic", "dialog_inv_six_status", ::notetrack_status, "invasion_vehicle_cover_dialogue_guy2" );
	addNotetrack_customFunction( "generic", "dialog_inv_six_whatelse", ::notetrack_whatelse, "invasion_vehicle_cover_dialogue_guy2" );
	addNotetrack_customFunction( "generic", "dialog_inv_six_sentrygunsouth", ::notetrack_sentrygunsouth, "invasion_vehicle_cover_dialogue_guy2" );
	addNotetrack_customFunction( "generic", "dunn_checkout", ::notetrack_checkout, "invasion_vehicle_cover_dialogue_guy2" );
	
	addNotetrack_customFunction( "generic", "dialog_inv_sgw_meatlocker", ::notetrack_meatlocker, "invasion_vehicle_cover_dialogue_guy1" );
	addNotetrack_customFunction( "generic", "dialog_inv_sgw_unconscious", ::notetrack_unconscious, "invasion_vehicle_cover_dialogue_guy1" );
	addNotetrack_customFunction( "generic", "dialog_inv_sgw_supplydrop", ::notetrack_supplydrop, "invasion_vehicle_cover_dialogue_guy1" );
}

notetrack_gimmesitrep( guy )
{
	flag_set( "notetrack_gimmesitrep" );
}

notetrack_status( guy )
{
	flag_set( "notetrack_status" );
}

notetrack_whatelse( guy )
{
	flag_set( "notetrack_whatelse" );
}

notetrack_sentrygunsouth( guy )
{
	flag_set( "notetrack_sentrygunsouth" );
}

notetrack_checkout( guy )
{
	flag_set( "notetrack_checkout" );
}

notetrack_meatlocker( guy )
{
	flag_set( "notetrack_meatlocker" );
}

notetrack_unconscious( guy )
{
	flag_set( "notetrack_unconscious" );
}

notetrack_supplydrop( guy )
{
	flag_set( "notetrack_supplydrop" );
}





tangled_parachute_guy()
{
	self.ignoreme = true;
	self thread magic_bullet_shield();
	self.deathanim = %invasion_parachute_ground_detach_death;
	node = getent( "tangled_parachute_guy_node", "targetname" );
	//node = spawn( "script_origin", self.origin );

	chute = spawn_anim_model( "tangled_chute_parachute" );
	//chute.animname = "tangled_chute_parachute";
	node thread anim_loop_solo( chute, "idle", "stop_tangled_chute_idle" );
	
	node thread anim_generic_loop( self, "invasion_parachute_ground_detach_idle", "stop_tangled_guy_idle" );

	while ( !players_looking_at( self GetEye() ) )
		wait .05;
		
	self.allowdeath = true;		
	self thread stop_magic_bullet_shield();
	self thread chute_death_reaction( node, chute );
	//thread spawn_pizza_rushers();
	
	self endon( "death" );
	
	wait 1;
	//time to try to free self
	
	self thread try_to_free_self( node, chute );
}

try_to_free_self( node, chute )
{
	self endon( "death" );
	node notify( "stop_tangled_chute_idle" );
	node notify( "stop_tangled_guy_idle" );
	
	self.ignoreme = false;
	node thread anim_single_solo( chute, "reaction" );
	
	node anim_generic( self, "tangled_guy_trys_to_free_self" );
	
	node thread anim_loop_solo( chute, "end_idle" );
	self.deathanim = undefined;
	
	node notify( "he got free" );
}

chute_death_reaction( node, chute )
{
	node endon( "he got free" );
	self waittill( "death" );
	
	node notify( "stop_tangled_chute_idle" );//he might die before trying to free self
	node anim_single_solo( chute, "death" );
	
	node thread anim_loop_solo( chute, "end_idle" );
}


spawn_pizza_rushers()
{
	wait 3;
	activate_trigger_with_targetname( "pizza_rushers_trigger" );
}



animate_burning_tree()
{
	wait 3;
	burning_tree = getent( "burning_tree", "script_noteworthy" );
	burning_tree.animname = "burning_tree";
	burning_tree assign_animtree();
	burning_tree anim_loop_solo( burning_tree, "tree_oak_fire", "stop_burning_tree" );
}

setup_shotgun_guy()
{
	self linkto( level.humvee_front, "tag_guy1" );
	level.humvee_front thread anim_generic_loop( self, "invasion_humvee_exit_v1_guy1_idle", "stop_front_humvee_anims", "tag_guy1" );
	
	level waittill( "humvee_blows_up" );
	self notify( "stop_front_humvee_anims" );
	
	level.humvee_front anim_generic( self, "invasion_humvee_exit_v1_guy1_react", "tag_guy1" );

	self.allowdeath = true;
	self.a.nodeath = true;
	self kill();
}

setup_backseat_right_guy()
{
	self linkto( level.humvee_front, "tag_passenger" );
	level.humvee_front thread anim_generic_loop( self, "invasion_humvee_exit_v1_passenger_idle", "stop_front_humvee_anims", "tag_passenger" );
	
	level waittill( "humvee_blows_up" );
	self notify( "stop_front_humvee_anims" );
	
	level.humvee_front anim_generic( self, "invasion_humvee_exit_v1_passenger_react", "tag_passenger" );

	self.allowdeath = true;
	self.a.nodeath = true;
	self kill();
}


setup_roof_parachute_guy( humvee_guy )
{
/*
	level.scr_anim[ "roof_landing_parachute" ][ "rolldeath" ]		 = %invasion_paratrooper_roof_landing_rolldeath;
	level.scr_anim[ "roof_landing_parachute" ][ "crawldeath" ]		 = %invasion_paratrooper_roof_landing_crawldeath;

	notetrack in invasion_paratrooper_roof_landing

	addNotetrack_customFunction( "generic", "roll_death", 			::notetrack_roll_death, "roof_landing_parachute" );
	addNotetrack_customFunction( "generic", "crawl_death_start", 	::notetrack_crawl_death_start, "roof_landing_parachute" );
	addNotetrack_customFunction( "generic", "crawl_death", 			::notetrack_crawl_death, "roof_landing_parachute" );


	So, if the guy gets shot before roll_death notetrack ----� play invasion_paratrooper_roof_landing_rolldeath 
	upon roll_death notetrack
	It uses the same script node as the landing

	And if he gets shot between crawl_death_start and crawl_death notetrack ---� play 
	invasion_paratrooper_roof_landing_crawldeath
	It�s a regular delta anim with no scipt node.

	If he gets shot after crawl_death notetrack, finish the landing anim and have him die on the top.

	There�s a few frames where he�s not suppose to get shot cause it might not blend with the death anim well.  
	between roll_death and crawl_death_start.
	but if that�s too much trouble, we can ignor crawl_death_start and see how it looks.
*/
	self.allowdeath = false;
	self.noragdoll = true;
	if( isdefined( humvee_guy ) )
		self.humvee_guy = true;
	//self.deathanim = %invasion_paratrooper_roof_landing_rolldeath;
	
	self.health = 1;
	parachute_landing = spawn( "script_origin", self.origin );
	parachute_landing.angles = self.angles;
	//parachute_landing = getent( "parachute_landing", "targetname" );
	chute = spawn_anim_model( "roof_landing_parachute" );
	parachute_landing thread anim_generic( self, "roof_landing_parachute" );
	parachute_landing anim_single_solo( chute, "roof_landing_parachute" );
	chute delete();
	level notify( "roof_landing_anim_finished" );
	//self delete();
}

notetrack_roll_death( guy )
{
	if( isdefined( guy.humvee_guy ) )
		return;
	
	//level notify( "roll_death" );
	//if( guy.delayedDeath ) //he has been shot
	{
		guy.skipdeathanim = true;
		self thread anim_generic( guy, "rolldeath" );
		wait .5;
		guy.allowdeath = true;
		//guy.a.nodeath = true;
		guy kill();
	}
}

notetrack_crawl_death_start( guy )
{
	if( isdefined( guy.humvee_guy ) )
		return;
		
	//guy.deathanim = %invasion_paratrooper_roof_landing_crawldeath;
	
	//if( guy.delayedDeath ) //he has been shot
	//{
	//	guy anim_generic( guy, "crawldeath" );
	//	guy.allowdeath = true;
	//	guy.a.nodeath = true;
	//	guy kill();
	//	return;
	//}
	level endon( "crawl_death_finished" );
	wait 2;//tweaking
	//guy waittill( "damage" );
	
	guy.skipdeathanim = true;
	guy thread anim_generic( guy, "crawldeath" );
	wait .5;
	guy.allowdeath = true;
	//guy.a.nodeath = true;
	guy kill();
}

notetrack_crawl_death( guy )
{
	guy.allowdeath = false;//he finishes the animation
	level notify( "crawl_death_finished" );
	
	level waittill( "roof_landing_anim_finished" );
	guy delete();
}


dialog()
{


	
//LOCAL
	//Seal Six-One:	We got a BMP! Get out, get out!	
	level.scr_sound[ "raptor" ][ "inv_six_gotbmp" ]				 = "inv_six_gotbmp";

	//Seal Six-One:	Team, this way! Let's go let's go!	
	level.scr_sound[ "raptor" ][ "inv_six_teamthisway" ]				 = "inv_six_teamthisway";

	//Seal Six-One:	I got a fix on the package. 300 meters east.�	
	level.scr_sound[ "raptor" ][ "inv_six_300meast" ]				 = "inv_six_300meast";


//LOCAL HOUSE DESTROYER
	//Seal Six-One:	That BMP hasn�t spotted us! Hang to the right and stay behind it!	
	level.scr_sound[ "raptor" ][ "inv_six_hangright" ]				 = "inv_six_hangright";

	//Seal Six-One:	I got a visual on smoke coming from the crash site.	
	level.scr_sound[ "raptor" ][ "inv_six_viscrashsite" ]				 = "inv_six_viscrashsite";

	//Seal Six-One:	We're spotted! Roach - grab that RPG! Taco, Worm - cover him!	
	level.scr_sound[ "raptor" ][ "inv_six_grabrpg" ]				 = "inv_six_grabrpg";

	//Seal Six-One:	Roach - there�s an RPG by that supply drop! Move!	
	level.scr_sound[ "raptor" ][ "inv_six_rpgsupplydrop" ]				 = "inv_six_rpgsupplydrop";

	//Seal Six-One:	Roach, take point - we're cuttin' to the right.	
	level.scr_sound[ "raptor" ][ "inv_six_takepoint" ]				 = "inv_six_takepoint";


//LOCAL PIZZA TO CRASH
	//Seal Six-One:	Incoming! Truck 12 o�clock!	
	level.scr_sound[ "raptor" ][ "inv_six_truck12" ]				 = "inv_six_truck12";

	//Taco:	We got a Juggernaut inbound! 	
	level.scr_sound[ "taco" ][ "inv_tco_juggernaut" ]				 = "inv_tco_juggernaut";

	//Seal Six-One:	Copy on Juggernaut, hit it with a flashbang!	
	level.scr_sound[ "raptor" ][ "inv_six_hitflashbang" ]				 = "inv_six_hitflashbang";

	//Seal Six-One:	Stay back!	
	level.scr_sound[ "raptor" ][ "inv_six_stayback" ]				 = "inv_six_stayback";

	//Seal Six-One:	Aim for the head!	
	level.scr_sound[ "raptor" ][ "inv_six_aimforthehead" ]				 = "inv_six_aimforthehead";

	//Seal Six-One:	Go for a headshot!	
	level.scr_sound[ "raptor" ][ "inv_six_headshot" ]				 = "inv_six_headshot";

	//Seal Six-One:	Team, don�t engage that APC - our objective is the crash site.	
	level.scr_sound[ "raptor" ][ "inv_six_dontengageapc" ]				 = "inv_six_dontengageapc";

	//Seal Six-One:	Roach! Get back from that APC!	
	level.scr_sound[ "raptor" ][ "inv_six_getbackfromapc" ]				 = "inv_six_getbackfromapc";

	//Seal Six-One:	Team be advised, enemy has close air support operating in our AO.	
	level.scr_sound[ "raptor" ][ "inv_six_closeairsupport" ]				 = "inv_six_closeairsupport";

	//Seal Six-One:	Check your fire check your fire! Friendlies at 10 o'clock in the purple building.	
	level.scr_sound[ "raptor" ][ "inv_six_purplebuilding" ]				 = "inv_six_purplebuilding";


//LOCAL AT CRASH SITE
	//Seal Six-One:	Marine! Gimme a sitrep! Where's the President?	
	level.scr_sound[ "raptor" ][ "inv_six_gimmesitrep" ]				 = "inv_six_gimmesitrep";

	//Sgt Wells:	We moved him to the meat locker, it's practically bulletproof!	
	level.scr_sound[ "wells" ][ "inv_sgw_meatlocker" ]				 = "inv_sgw_meatlocker";

	//Seal Six-One:	What's his status?	
	level.scr_sound[ "raptor" ][ "inv_six_status" ]				 = "inv_six_status";

	//Sgt Wells:	He's still unconscious, you got a corpsman?	
	level.scr_sound[ "wells" ][ "inv_sgw_unconscious" ]				 = "inv_sgw_unconscious";

	//Seal Six-One:	(aside) Taco, check it out! (back to Marine) What else?	
	level.scr_sound[ "raptor" ][ "inv_six_whatelse" ]				 = "inv_six_whatelse";

	//Sgt Wells:	We got a supply drop on the roof with an M-5 sentry gun!	
	level.scr_sound[ "wells" ][ "inv_sgw_supplydrop" ]				 = "inv_sgw_supplydrop";

	//Seal Six-One:	Roach - get to the roof and get that sentry gun pointed south!	
	level.scr_sound[ "raptor" ][ "inv_six_sentrygunsouth" ]				 = "inv_six_sentrygunsouth";

	//Seal Six-One:	What about anti-tank weapons, air support?	
	level.scr_sound[ "raptor" ][ "inv_six_antitank" ]				 = "inv_six_antitank";

	//Sgt Wells:	We're all out! It's just Ramirez, Collins and myself sir!	
	level.scr_sound[ "wells" ][ "inv_sgw_allout" ]				 = "inv_sgw_allout";

	//Seal Six-One:	Roger that!	
	level.scr_sound[ "raptor" ][ "inv_six_rogerthat" ]				 = "inv_six_rogerthat";

	//Seal Six-One:	Roger that!	
	level.scr_radio[ "inv_six_rogerthat" ]				 = "inv_six_rogerthat";


//RADIO
	//Seal Six-One:	Roach, use the ladder in the kitchen and get to the roof.	
	level.scr_radio[ "inv_six_ladderinkitchen" ]					 = "inv_six_ladderinkitchen";

	//Seal Six-One:	Roach this is raptor. Get to the roof, there's a maintenance ladder in the kitchen.	
	level.scr_radio[ "inv_six_gettoroof" ]					 = "inv_six_gettoroof";

	//Seal Six-One:	Roach, you on the roof yet? Get that sentry gun online and make sure its pointed south.	
	level.scr_radio[ "inv_six_onroofyet" ]					 = "inv_six_onroofyet";

	//Seal Six-One:	Heads up ladies, we got trucks to the south.	
	level.scr_radio[ "inv_six_headsupladies" ]					 = "inv_six_headsupladies";

	//Seal Six-One:	Team, this is raptor. Switch to thermal optics if you got 'em.	
	level.scr_radio[ "inv_six_thermaloptics" ]					 = "inv_six_thermaloptics";

	//Seal Six-One:	Looks like Ivan's had enough.	
	level.scr_radio[ "inv_six_hadenough" ]					 = "inv_six_hadenough";

	//Seal Six-One:	Team, check weapons and ammo. They'll be back.	
	level.scr_radio[ "inv_six_checkammo" ]					 = "inv_six_checkammo";

	//Worm:	What the hell was that?!	
	level.scr_radio[ "inv_wrm_whatwasthat" ]					 = "inv_wrm_whatwasthat";

	//Seal Six-One:	Roach! Get the <garble> off the roof!	
	level.scr_radio[ "inv_six_offtheroof" ]					 = "inv_six_offtheroof";

//	//Taco:	raptor, this is Taco how copy over?	
//	level.scr_radio[ "inv_tco_howcopy" ]					 = "inv_tco_howcopy";
//
//	//Seal Six-One:	Solid copy Taco, go ahead!	
//	level.scr_radio[ "inv_six_solidcopy" ]					 = "inv_six_solidcopy";
//
//	//Taco:	I scoped a UAV operator in the diner across the street to the west, break. That's where the missiles are coming from, over.	
//	level.scr_radio[ "inv_tco_uavop" ]					 = "inv_tco_uavop";
//
//	//Seal Six-One:	Copy that. Taco, you and Roach get over there and kill that SOB. Everyone else cover 'em.	
//	level.scr_radio[ "inv_six_killthatsob" ]					 = "inv_six_killthatsob";
//
//	//Taco:	Taco copies all. Roach, you're with me let's go.	
//	level.scr_radio[ "inv_tco_copiesall" ]					 = "inv_tco_copiesall";

	//Seal Six-One:	Taco, be advised, two BMPs coming in from the north.	
	level.scr_radio[ "inv_six_bmpsfromnorth" ]					 = "inv_six_bmpsfromnorth";

	//Taco:	Roger that.	
	level.scr_radio[ "inv_tco_rogerthat" ]					 = "inv_tco_rogerthat";


//LOCAL -DINER
	//Taco:	Roach - get the control rig for the UAV!	
	level.scr_sound[ "taco" ][ "inv_tco_controlrig" ]				 = "inv_tco_controlrig";

	//Taco:	Roach - I got you covered! Pick up the control rig! 	
	level.scr_sound[ "taco" ][ "inv_tco_pickupcontrolrig" ]				 = "inv_tco_pickupcontrolrig";

	//Taco:	Incoming!	
	level.scr_sound[ "taco" ][ "inv_tco_incoming" ]				 = "inv_tco_incoming";

	//Taco:	Back door!	
	level.scr_sound[ "taco" ][ "inv_tco_backdoor" ]				 = "inv_tco_backdoor";


//RADIO
	//Seal Six-One:	Roach! Waste those BMPs! Now!	
	level.scr_radio[ "inv_six_wastebmpsnow" ]					 = "inv_six_wastebmpsnow";

	//Seal Six-One:	Enemy fast moverrrs!!! Take coverr!!!	
	level.scr_radio[ "inv_six_fastmovers" ]					 = "inv_six_fastmovers";

	//Taco:	raptor you still there?	
	level.scr_radio[ "inv_tco_stillthere" ]					 = "inv_tco_stillthere";

	//Seal Six-One:	<cough> Taco, Roach, new plan.	
	level.scr_radio[ "inv_six_newplan" ]					 = "inv_six_newplan";

	//Seal Six-One:	Secure the Burgertown and get on the <cough> roof.	
	level.scr_radio[ "inv_six_secureburgertown" ]					 = "inv_six_secureburgertown";

	//Seal Six-One:	Everyone on this net, listen up, we're moving the package asap.	
	level.scr_radio[ "inv_six_listenup" ]					 = "inv_six_listenup";

	//Seal Six-One:	We need to get the hell out of this building before those fast movers make another pass.	
	level.scr_radio[ "inv_six_anotherpass" ]					 = "inv_six_anotherpass";

	//Seal Six-One:	Taco, Roach, we still got hostiles in the Burgertown, move it!	
	level.scr_radio[ "inv_six_hostilesinbt" ]					 = "inv_six_hostilesinbt";

	//Seal Six-One:	Taco, Roach! Clear the Burgertown roof asap!	
	level.scr_radio[ "inv_six_clearbtroof" ]					 = "inv_six_clearbtroof";

	
	

	//Seal Six-One:	Alright, stay on the roof and cover us! We got the President and we're movin' out now.	
	level.scr_radio[ "inv_six_gotpresident" ]					 = "inv_six_gotpresident";

	//Seal Six-One:	Keep these guys off me!	
	level.scr_radio[ "inv_six_keepoffme" ]					 = "inv_six_keepoffme";
	level.scr_sound[ "raptor" ][ "inv_six_keepoffme" ]				 = "inv_six_keepoffme";

	//Taco:	Incoming, north side!	
	level.scr_radio[ "inv_tco_incomingnorth" ]					 = "inv_tco_incomingnorth";

	//Taco:	Contact to the north!	
	level.scr_radio[ "inv_tco_contactnorth" ]					 = "inv_tco_contactnorth";

	//Taco:	Incoming, south side!	
	level.scr_radio[ "inv_tco_incomingsouth" ]					 = "inv_tco_incomingsouth";

	//Taco:	Contact to the south!	
	level.scr_radio[ "inv_tco_contactsouth" ]					 = "inv_tco_contactsouth";

	//Taco:	Contact northwest!	
	level.scr_radio[ "inv_tco_contactnw" ]					 = "inv_tco_contactnw";

	//Taco:	Contact southeast!	
	level.scr_radio[ "inv_tco_contactse" ]					 = "inv_tco_contactse";

	//Taco:	Incoming helo!	
	level.scr_radio[ "inv_tco_incominghelo" ]					 = "inv_tco_incominghelo";

	//Seal Six-One:	Taco, Roach, get off the roof!	
	level.scr_radio[ "inv_six_getoffroof" ]					 = "inv_six_getoffroof";

	//Seal Six-One:	The convoy's here! I got the President! Move move!	
	level.scr_radio[ "inv_six_convoyshere" ]					 = "inv_six_convoyshere";

	//Radio HQ Voice 1: 	Seal Six-One, this is Overlord, gimme a sitrep over.	
	level.scr_radio[ "inv_hqr_sitrep" ]					 = "inv_hqr_sitrep";

	//Seal Six-One:	Overlord, Six-One Actual. Be advised: precious cargo is secure, repeat, precious cargo is secure. We're oscar mike.	
	level.scr_radio[ "inv_six_cargosecure" ]					 = "inv_six_cargosecure";

	//Radio HQ Voice 1: 	Overlord copies all. Good job. Out.	
	level.scr_radio[ "inv_hqr_goodjob" ]					 = "inv_hqr_goodjob";



//NEWEST
	//Team the crashed heli at 12 o'clock is our objective. 	***
	level.scr_sound[ "raptor" ][ "inv_six_ourobjective" ]					 = "inv_six_ourobjective";

	//Pick up that RPG by the supply drop! 	
	level.scr_sound[ "raptor" ][ "inv_six_pickuprpg" ]					 = "inv_six_pickuprpg";

	//Roach! Pick up that RPG! 	
	level.scr_sound[ "raptor" ][ "inv_six_pickupthatrpg" ]					 = "inv_six_pickupthatrpg";

	//Roach get more rockets from the supply drop! 	
	level.scr_sound[ "raptor" ][ "inv_six_morerockets" ]					 = "inv_six_morerockets";

	//Roach get another RPG from the supply drop! 	
	level.scr_sound[ "raptor" ][ "inv_six_anotherrpg" ]					 = "inv_six_anotherrpg";
	
	
	//Pick up the explosives by the supply drop!    
	level.scr_sound[ "raptor" ][ "inv_six_pickup" ]					 = "inv_six_pickup";  
	
	//Roach get more explosives from the supply drop!	
	level.scr_sound[ "raptor" ][ "inv_six_getmore" ]					 = "inv_six_getmore";
	

//radio
	//He's down! 	
	level.scr_radio[ "inv_tco_hesdown" ]					 = "inv_tco_hesdown";
	level.scr_sound[ "taco" ][ "inv_tco_hesdown" ]					 = "inv_tco_hesdown";

	//Nice one Roach. 	
	level.scr_radio[ "inv_six_niceoneheli" ]					 = "inv_six_niceoneheli";
	level.scr_sound[ "raptor" ][ "inv_six_niceoneheli" ]				 = "inv_six_niceoneheli";
	

	//Nice one guys. 	
	level.scr_radio[ "inv_six_niceoneguys" ]					 = "inv_six_niceoneguys";
	level.scr_sound[ "raptor" ][ "inv_six_niceoneguys" ]				 = "inv_six_niceoneguys";

	//Stay with us Roach! 	
	level.scr_radio[ "inv_six_staywithus" ]					 = "inv_six_staywithus";
	level.scr_sound[ "raptor" ][ "inv_six_staywithus" ]				 = "inv_six_staywithus";

//radio
	//On me! 	
	level.scr_radio[ "inv_six_onme" ]					 = "inv_six_onme";
	level.scr_sound[ "raptor" ][ "inv_six_onme" ]				 = "inv_six_onme";

	//Get over here! 	
	level.scr_radio[ "inv_six_getoverhere" ]					 = "inv_six_getoverhere";

	//Go go go! 	
	level.scr_radio[ "inv_six_gogogo" ]					 = "inv_six_gogogo";
	level.scr_sound[ "raptor" ][ "inv_six_gogogo" ]				 = "inv_six_gogogo";

	//Roach, we're at the crash site get over here. 	
	level.scr_radio[ "inv_six_crashsite" ]					 = "inv_six_crashsite";

	//The crash site is on the north side of Nate's restaurant. 	
	level.scr_radio[ "inv_six_northofnates" ]					 = "inv_six_northofnates";

//radio
	//Incoming from the south! Two dozen plus foot mobiles! 	
	level.scr_radio[ "inv_six_2dozen" ]					 = "inv_six_2dozen";

	//They're using smoke to cover their advance! 	
	level.scr_radio[ "inv_tco_usingsmoke" ]					 = "inv_tco_usingsmoke";

	//Get off the roof! 	
	level.scr_radio[ "inv_six_getoffroof2" ]					 = "inv_six_getoffroof2";

	//Get down from the roof now! 	
	level.scr_radio[ "inv_six_getoffroofnow" ]					 = "inv_six_getoffroofnow";


	//Nice work team. Regroup over here.	
	level.scr_radio[ "inv_six_regroup" ]					 = "inv_six_regroup";

	//Taco, Roach, regroup in the restaurant.
	level.scr_radio[ "inv_six_regroupinrest" ]					 = "inv_six_regroupinrest";


//////////////////////////////////////NEW


//
	//Team, shift your fire north.	
	level.scr_radio[ "inv_six_shiftfiren" ]					 = "inv_six_shiftfiren";

	//Team, we got contacts to the north.	
	level.scr_radio[ "inv_six_contactsn" ]					 = "inv_six_contactsn";




//
	//They're layin' down a smokescreen to the north.	
	level.scr_radio[ "inv_tco_smokescrnth" ]					 = "inv_tco_smokescrnth";

	//Roger. Switch to thermal if you got it.	
	level.scr_radio[ "inv_six_switchthermal" ]					 = "inv_six_switchthermal";


//
	//Roach, get on the roof of that Burger Town and get ready to cover us.	
	level.scr_radio[ "inv_six_readytocover" ]					 = "inv_six_readytocover";

	//Taco, Roach - cover us from the Burger Town roof. Go!	
	level.scr_radio[ "inv_six_coverusgo" ]					 = "inv_six_coverusgo";


///
	//Taco, Roach, we need to move ASAP! Clear that restaurant!	
	level.scr_radio[ "inv_six_needtomove" ]					 = "inv_six_needtomove";

	//Team, what's the hold up? Secure that restaurant!	
	level.scr_radio[ "inv_six_whatsholdup" ]					 = "inv_six_whatsholdup";

///
	//Roach take cover! That BMP's spotted you!	
	level.scr_radio[ "inv_six_bmpspottedyou" ]					 = "inv_six_bmpspottedyou";

	//Roach take cover! One of the BMPs has a visual on you!	
	level.scr_radio[ "inv_six_bmphasavisual" ]					 = "inv_six_bmphasavisual";

	//Get behind something solid! That BMP's got you in his sights!	
	level.scr_radio[ "inv_six_behindsolid" ]					 = "inv_six_behindsolid";


//
	//The BMP's lost you! Go go go!	
	level.scr_radio[ "inv_six_bmplostyou" ]					 = "inv_six_bmplostyou";

	//That BMP's lost sight of you! Move!	
	level.scr_radio[ "inv_six_bmplostyoumove" ]					 = "inv_six_bmplostyoumove";

	//All right the BMP's lost you! Go go go!	
	level.scr_radio[ "inv_six_bmplostyougo" ]					 = "inv_six_bmplostyougo";


//
	//Roach, neutralize that enemy armor.	
	level.scr_radio[ "inv_six_neutralizearmor" ]					 = "inv_six_neutralizearmor";

	//Destroy those APCs!	
	level.scr_radio[ "inv_six_destroyapcs" ]					 = "inv_six_destroyapcs";

	//There's still one BMP left!	
	level.scr_radio[ "inv_six_stillonebmp" ]					 = "inv_six_stillonebmp";

	//Waste that BMP now!	
	level.scr_radio[ "inv_six_wastethatbmpnow" ]					 = "inv_six_wastethatbmpnow";

///
	//Team, we're inside, we've got the President!	
	level.scr_radio[ "inv_six_gotthepresident" ]					 = "inv_six_gotthepresident";

	//Friendly convoy is oscar mike.	
	level.scr_radio[ "inv_six_friedlyconvoy" ]					 = "inv_six_friedlyconvoy";



///////////////////////////////NOT IN
	//Hostile paratrooper on the roof. 	
	level.scr_sound[ "raptor" ][ "inv_six_paratrooper" ]					 = "inv_six_paratrooper";
	//level.scr_radio[ "inv_six_paratrooper" ]					= "inv_six_paratrooper";

	//Enemy paratrooper at our 12.	
	level.scr_sound[ "raptor" ][ "inv_six_enemyptroop" ]					 = "inv_six_enemyptroop";
	//level.scr_radio[ "inv_six_enemyptroop" ]					= "inv_six_enemyptroop";

	//Russian paratrooper coming down at our 12 o'clock.	
	level.scr_sound[ "raptor" ][ "inv_six_rusptroop" ]					 = "inv_six_rusptroop";
	//level.scr_radio[ "inv_six_rusptroop" ]					= "inv_six_rusptroop";

	//Taco:	Roger that.	
	level.scr_sound[ "taco" ][ "inv_tco_rogerthat" ]					 = "inv_tco_rogerthat";

	//Team, shift your fire to the west.	
	level.scr_radio[ "inv_six_shiftfirew" ]					 = "inv_six_shiftfirew";

	//Team, contacts to the west.	
	level.scr_radio[ "inv_six_contactsw" ]					 = "inv_six_contactsw";

	//Got an enemy smokescreen to the west.	
	level.scr_radio[ "inv_tco_smokescrwest" ]					 = "inv_tco_smokescrwest";
	
	
	
	//   vvvvvvvvvvv  NEW BT ROOF vvvvvvvvvvvvvvvvvv
	//Taco, get on the roof of Burger Town and provide overwatch! Roach, regroup on me! We're gonna move the package!	
	level.scr_radio[ "inv_six_overwatch" ]					 = "inv_six_overwatch";
	
	//Roger that! Moving! Roach - regroup with the squad, go!		
	level.scr_radio[ "inv_tco_regroupsquad" ]					 = "inv_tco_regroupsquad";
	
	//Roach, on me! Regroup with the squad!		
	level.scr_radio[ "inv_six_roachonme" ]					 = "inv_six_roachonme";
	
	//Roach, Taco's got the roof covered! We need you back here! Move!		
	level.scr_radio[ "inv_six_backhere" ]					 = "inv_six_backhere";



	//   BT DEFEND
	//Roach, use the UAV on the infantry!	
	level.scr_radio[ "inv_six_theinfantry" ]					 = "inv_six_theinfantry";
	
	//Roach use the UAV on that armor!	
	level.scr_radio[ "inv_six_thatarmor" ]					 = "inv_six_thatarmor";


	//Stay with us Roach! 	
	//level.scr_radio[ "inv_six_staywithus" ]					 = "inv_six_staywithus";

	//Get over here! 	
	//level.scr_radio[ "inv_six_getoverhere" ]					 = "inv_six_getoverhere";
	

	// HUMVEE INTRO
	//The Russians have everything east of I-95! My sector's gonna fall within the hour! 	
	level.scr_radio[ "inv_gm1_eastof95" ]					 = "inv_gm1_eastof95";
	
	//We've lost contact with Annapolis, where is the air support!	
	level.scr_radio[ "inv_gm2_airsupport" ]					 = "inv_gm2_airsupport";
	
	//Counterbattery fire is unable to engage! Enemy paratroopers have infiltrated their positions, we are cut off, I repeat we are cut off!	
	level.scr_radio[ "inv_gm3_cutoff" ]					 = "inv_gm3_cutoff";
	
	//Broken arrow broken arrow! Drop that thousand pounder on the red smoke, now!	
	level.scr_radio[ "inv_gm4_brokenarrow" ]					 = "inv_gm4_brokenarrow";
	
	//Interrogative, can your Harriers take out the interchange at I-495 and US-50 over?	
	level.scr_radio[ "inv_gm1_495and50" ]					 = "inv_gm1_495and50";
	
	
	//   YARDS STORY
	//Overlord this is Raptor Six requesting air support, over!	
	level.scr_sound[ "raptor" ][ "inv_six_reqairsupport" ]				 = "inv_six_reqairsupport";
	
	//Raptor Six, all air support is already engaged. Additional ground support is enroute to your position but has encountered heavy resistance, over.	
	level.scr_sound[ "raptor" ][ "inv_hqr_engaged" ]				 = "inv_hqr_engaged";
	
	//Roger that Overlord. Be advised we have encountered enemy armor and are proceeding on foot, over.	
	level.scr_sound[ "raptor" ][ "inv_six_onfoot" ]				 = "inv_six_onfoot";
	
	//Overlord copies all. Good luck. Out.	
	level.scr_sound[ "raptor" ][ "inv_hqr_goodluck" ]				 = "inv_hqr_goodluck";
	
	
	
//////////////////////// NEW FEB 11


	
	//The convoy's here! Everyone on me! We're getting the hell outta here! Let's go, let's go!!	
	level.scr_radio[ "inv_six_convoyshere" ]					 = "inv_six_convoyshere";
	//Ramirez! The convoy is just south of Burgertown, get your ass over here! Move!	
	level.scr_radio[ "inv_six_southofbtown" ]					 = "inv_six_southofbtown";
	//Ramirez! We gotta get back to the convoy! Let's go!	
	level.scr_radio[ "inv_tco_backtoconvoy" ]					 = "inv_tco_backtoconvoy";


///IN:
	//Hang right and stay behind it!	
	level.scr_sound[ "raptor" ][ "inv_six_staybehind" ]				 = "inv_six_staybehind";
	
	
	//Ramirez, throw some Semtex on that BMP!
	level.scr_sound[ "raptor" ][ "inv_six_throwsemtex" ]				 = "inv_six_throwsemtex";		
	//Ramirez, get some Semtex on that BMP!
	level.scr_sound[ "raptor" ][ "inv_six_getsemtex" ]				 = "inv_six_getsemtex";
	//Ramirez, destroy that BMP with Semtex!
	level.scr_sound[ "raptor" ][ "inv_six_destroy" ]				 = "inv_six_destroy";	

	
	
	
//INTRO
	//Hunter Two-One this is Overlord. We got a visual on an enemy attack helicopter headed for your area, over.	
	level.scr_radio[ "inv_hqr_enemyhelo" ]					 = "inv_hqr_enemyhelo";
	
	//Hunter Two-One, be advised, enemy helo approaching your sector. CAP is unavailable at this time, good luck, over.	
	level.scr_radio[ "inv_hqr_capunavail" ]					 = "inv_hqr_capunavail";
	
	//Solid copy Overlord. Ramirez! Take down that helicopter! Go!	
	level.scr_radio[ "inv_six_takedown" ]					 = "inv_six_takedown";
	

	
	
//HELP
	//Ramirez! I saw a couple Stingers on the roof of Nate's! Use 'em to take down that sonofabitch! Go!	
	level.scr_radio[ "inv_tco_roofofnates" ]					 = "inv_tco_roofofnates";
	
	//Ramirez! There's Stingers on the roof of Nate's restaurant! Use 'em to kill that helo! Go! Go!	
	level.scr_radio[ "inv_tco_killthathelo" ]					 = "inv_tco_killthathelo";
	
	//Ramirez! I saw some Stinger missiles in that diner to the west! Use them to to dispatch that chopper! I'll cover you! Go!	
	level.scr_radio[ "inv_tco_dispatchchopper" ]					 = "inv_tco_dispatchchopper";
	
	//Ramirez! There's Stinger missiles in that stockpile to the west, inside the diner! Move! I got ya covered!	
	level.scr_radio[ "inv_tco_insidediner" ]					 = "inv_tco_insidediner";
	
	
	
//SECOND
	//Hunter Two-One, relay from Goliath One: you got an enemy helicopter loaded for bear, approaching your area, over.	
	level.scr_radio[ "inv_hqr_relaygol1" ]					 = "inv_hqr_relaygol1";
	
	//Eyes up!!! Enemy gunship comin' in hot!!!	
	level.scr_radio[ "inv_tco_eyesup" ]					 = "inv_tco_eyesup";
	
	//Roger Overlord, Hunter copies all. Ramirez, we've got another enemy helo, take it out!!	
	level.scr_radio[ "inv_six_anotherhelo" ]					 = "inv_six_anotherhelo";
	
	
	
//NAGS
	
	//Ramirez, take out that helicopter before the convoy arrives!! Move!!	
	level.scr_radio[ "inv_six_beforeconvoy" ]					 = "inv_six_beforeconvoy";
	
	//Ramirez, find an anti-aircraft weapon and take out the gunship!!	
	level.scr_radio[ "inv_six_antiaircraft" ]					 = "inv_six_antiaircraft";
	
	//Ramirez! Take out that gunship before the convoy arrives! Go! Go!	
	level.scr_radio[ "inv_six_takegunship" ]					 = "inv_six_takegunship";
	
/////////////IN:
	//<Garble!> Someone just fired a missile at the UAV!	
	level.scr_radio[ "inv_tco_firedmissile" ]					 = "inv_tco_firedmissile";
	
	//Be advised, the UAV is offline I repeat, the UAV is offline!! <Garble!>	
	level.scr_radio[ "inv_tco_uavoffline" ]					 = "inv_tco_uavoffline";
	
	
	
	
	
	
/////////////IN:
	
	//Hunter Two-One this is Overlord Actual, we're seeing enemy reinforcements to your north, over.	
	level.scr_radio[ "inv_hqr_enemynorth" ]					 = "inv_hqr_enemynorth";
	
	//Be advised Hunter Two-One, you got enemy infantry by that bank to the north, over.	
	level.scr_radio[ "inv_hqr_banktonorth" ]					 = "inv_hqr_banktonorth";
	
	//Hunter Two-One, be advised, enemy foot-mobiles approaching north of your location, over.	
	level.scr_radio[ "inv_hqr_footmobiles" ]					 = "inv_hqr_footmobiles";
	
	
	
	//Hunter Two-One, Overlord. Enemy foot-mobiles approaching you from the southeast, over.	
	level.scr_radio[ "inv_hqr_southeast" ]					 = "inv_hqr_southeast";
	
	//Hunter Two-One, Goliath One has a visual on hostiles coming from the southeast, over.	
	level.scr_radio[ "inv_hqr_visualse" ]					 = "inv_hqr_visualse";
	
	//Hunter Two-One, be advised, enemy foot-mobiles have been sighted near the taco joint, over.	
	level.scr_radio[ "inv_hqr_tacojoint" ]					 = "inv_hqr_tacojoint";
	
	
	
	//Hunter Two-One, Hunter Four has a visual on hostiles near the Nova gas station, over.	
	level.scr_radio[ "inv_hqr_novagasstation" ]					 = "inv_hqr_novagasstation";
	
	//Hunter Two-One, relay from Goliath Two, enemy reinforcements approaching from the west, over.	
	level.scr_radio[ "inv_hqr_enemywest" ]					 = "inv_hqr_enemywest";
	
	//Hunter Two-One, tangos approaching near the diner to the west, over.	
	level.scr_radio[ "inv_hqr_dinerwest" ]					 = "inv_hqr_dinerwest";
	


	
	//Additional ground support is en route to your position but has encountered heavy resistance, over.
	level.scr_sound[ "raptor" ][ "inv_hqr_engaged2" ]				 = "inv_hqr_engaged2";	
	//Be advised, we have encountered enemy armor and are proceeding on foot, over.
	level.scr_sound[ "raptor" ][ "inv_six_onfoot2" ]				 = "inv_six_onfoot2";	
	//Sarge, did HQ just tell us to 'F' ourselves?
	level.scr_sound[ "raptor" ][ "inv_tco_fourselves" ]				 = "inv_tco_fourselves";		
	//Pretty much, Corporal!
	level.scr_sound[ "taco" ][ "inv_six_prettymuch" ]				 = "inv_six_prettymuch";
	
	
//I have a visual on an enemy UAV operator remote-piloting those missiles!	
	level.scr_radio[ "inv_tco_uavop" ]					 = "inv_tco_uavop";
	
//He's inside that diner to the west, over!	
	level.scr_radio[ "inv_tco_uavop2" ]					 = "inv_tco_uavop2";
	
//Ramirez! Get over there, and kill that SOB!	
	level.scr_radio[ "inv_six_killthatsob" ]					 = "inv_six_killthatsob";
	
//I'm sending part of the squad to help you out! Go!	
	level.scr_radio[ "inv_six_killthatsob2" ]					 = "inv_six_killthatsob2";
	
	
	//Good effect on target. That's a kill. One more to go.
	level.scr_radio[ "inv_six_onemore" ]					 = "inv_six_onemore";	
	
	//The door is shut - you guys keep Ivan out.
	level.scr_radio[ "inv_six_gotthepresident2" ]					 = "inv_six_gotthepresident2";
	
	//Ramirez, use the UAV! We got incoming infantry!
	level.scr_radio[ "inv_six_theinfantry2" ]					 = "inv_six_theinfantry2";	
	
	
	
	
	//Use 'em to take down that sonofabitch! Go!	
	level.scr_radio[ "inv_tco_roofofnates2" ]					 = "inv_tco_roofofnates2";
	//Use 'em to kill that helo! Go! Go!	
	level.scr_radio[ "inv_tco_killthathelo2" ]					 = "inv_tco_killthathelo2";
	
	//Ramirez! Check the roof of Nate's restaurant! I saw some Stingers up there!	
	level.scr_radio[ "inv_six_checktheroof" ]					 = "inv_six_checktheroof";
	//Ramirez! There's some Stingers by the supply drop on the roof of Nate's!	
	level.scr_radio[ "inv_six_supplydroponroof" ]					 = "inv_six_supplydroponroof";
	
	//Use it to to dispatch that chopper! I'll cover you! Go!	
	level.scr_radio[ "inv_tco_dispatchchopper2" ]					 = "inv_tco_dispatchchopper2";
	
	//Ramirez! Next to the gas station to the west is a diner! Check there for a Stinger missile!	
	level.scr_radio[ "inv_tco_nexttostation" ]					 = "inv_tco_nexttostation";
	//Ramirez! I saw a Stinger missile in the diner where we got the UAV control rig! 
	level.scr_radio[ "inv_tco_dineruav" ]					 = "inv_tco_dineruav";	


///in
	//Corporal Dunn, give me a sitrep on Raptor, over.	
	level.scr_radio[ "inv_six_sitreponraptor" ]					 = "inv_six_sitreponraptor";	
	//Raptor is secure and stable.	
	level.scr_radio[ "inv_tco_secureandstable" ]					 = "inv_tco_secureandstable";	
	
	
	//Everyone lock and load! We're going to move from here to the Burger Town as a group, hua?	
	level.scr_radio[ "inv_six_lockandload" ]					 = "inv_six_lockandload";	
	
	//On three!	
	level.scr_radio[ "inv_six_onthree" ]					 = "inv_six_onthree";	
	
	//One!	
	level.scr_radio[ "inv_six_one" ]					 = "inv_six_one";	
	
	//Two!	
	level.scr_radio[ "inv_six_two" ]					 = "inv_six_two";	
	
	//Three!!	
	level.scr_radio[ "inv_six_three" ]					 = "inv_six_three";	
	
	//Go go go! 	
	level.scr_radio[ "inv_six_gogogo2" ]					 = "inv_six_gogogo2";	


	//Squad, concentrate all your fire on that that gunship! Take it out!!!	
	level.scr_radio[ "inv_six_concentratefire" ]					 = "inv_six_concentratefire";	
	
	//Keep firing!! Take it down!!!	
	level.scr_radio[ "inv_six_keepfiring" ]					 = "inv_six_keepfiring";	
	
	//Tangos on the roof behind us!	
	level.scr_sound[ "raptor" ][ "inv_six_roofbehind" ]				 = "inv_six_roofbehind";
	//Our perimeter is breached! Enemies on the roof! 	
	level.scr_sound[ "raptor" ][ "inv_six_enemiesonroof" ]				 = "inv_six_enemiesonroof";
	//Contact! Hostiles are on our roof! Inside our perimeter!	
	level.scr_sound[ "raptor" ][ "inv_six_insideperim" ]				 = "inv_six_insideperim";
	//Squad! Hostiles on the roof! Turn around!	
	level.scr_sound[ "raptor" ][ "inv_six_turnaround" ]				 = "inv_six_turnaround";
	

	// MikeD: Used for _remotemissile
	level.uav_radio_initialized = true;


	//Hunter Two-One Hellfire missile is online. 	
	//level.scr_radio[ "uav_online_variant" ][0]							= "inv_hqr_hellfireonline";	
	//Hunter Two-One AGM missile is online. 	
//	level.scr_radio[ "inv_hqr_hellfireonline" ]							= "inv_hqr_hellfireonline";	
	//Hellfire missile is online. 	
	//level.scr_radio[ "uav_online_variant" ][1]							= "inv_hqr_hellfireonline2";	
	//AGM missile is online. 	
//	level.scr_radio[ "inv_hqr_hellfireonline2" ]					 	= "inv_hqr_hellfireonline2";	
	//Hellfire missile is online. I repeat Hellfire missile is online.	
	//level.scr_radio[ "uav_online_variant" ][2]							= "inv_hqr_hellfireonline3";	
	//AGM missile is online. I repeat AGM missile is online.	
//	level.scr_radio[ "inv_hqr_hellfireonline3" ]					 	= "inv_hqr_hellfireonline3";	
	

	//Hellfires are off line.	
	level.scr_radio[ "uav_offline" ]								= "inv_hqr_hellfireoffline";	
	//AGMs are off line.	
//	level.scr_radio[ "inv_hqr_hellfireoffline" ]					= "inv_hqr_hellfireoffline";	

	//The predator drone is off line.	
//	level.scr_radio[ "inv_hqr_predatoroffline" ]					= "inv_hqr_predatoroffline";	
	//The UAV is off line.	
//	level.scr_radio[ "inv_hqr_predatoroffline" ]					= "inv_hqr_predatoroffline";	
	//Predator drone is off line.	
//	level.scr_radio[ "inv_hqr_predatoroffline2" ]					= "inv_hqr_predatoroffline2";	
	//UAV is off line.	
//	level.scr_radio[ "inv_hqr_predatoroffline2" ]					= "inv_hqr_predatoroffline2";	


	//Hellfires are down hunter two one.	
	level.scr_radio[ "uav_down" ]									= "inv_hqr_hellfiredown";
	//AGMs are down hunter two one.	
//	level.scr_radio[ "inv_hqr_hellfiredown" ]					= "inv_hqr_hellfiredown";

	level.scr_radio[ "uav_down_variant" ][0]							= "inv_hqr_hellfiredown";
	level.scr_radio[ "uav_down_variant" ][1]							= "inv_hqr_predatoroffline";
	level.scr_radio[ "uav_down_variant" ][2]							= "inv_hqr_hellfireoffline";
	level.scr_radio[ "uav_down_variant" ][3]							= "inv_hqr_predatoroffline2";

	
	
	//That looks to be at least five no, ten kills, hunter two one. Keep it up.	
	level.scr_radio[ "inv_hqr_fivenotenkills" ]					 = "inv_hqr_fivenotenkills";	
	//Oh man. Thats at least ten more confirms hunter two one. Good shooting.	
	level.scr_radio[ "inv_hqr_tenmoreconfirms" ]					 = "inv_hqr_tenmoreconfirms";	
	//Ten plus KIAs. Good hit. Good hit.	
	level.scr_radio[ "inv_hqr_tenpluskia" ]					 = "inv_hqr_tenpluskia";	
	//Five plus confirmed kills. Nice work. Hunter two one.	
	level.scr_radio[ "inv_hqr_fiveplus" ]					 = "inv_hqr_fiveplus";	
	//Hunter two one, thats another five plus confirmed. 	
	level.scr_radio[ "inv_hqr_another5plus" ]					 = "inv_hqr_another5plus";	
	//Good hit. More than five KIAs.	
	level.scr_radio[ "inv_hqr_morethanfive" ]					 = "inv_hqr_morethanfive";	
	//You got 'em. Good kill.	
	level.scr_radio[ "inv_hqr_yougotem" ]					 = "inv_hqr_yougotem";	
	//Good kills hunter two one. Good kills.	
	level.scr_radio[ "inv_hqr_goodkills" ]					 = "inv_hqr_goodkills";	
	//Thats a direct hit hunter two one, keep up the fire.	
	level.scr_radio[ "inv_hqr_directhit" ]					 = "inv_hqr_directhit";	
	//He's down.	
	level.scr_radio[ "inv_hqr_hesdown" ]					 = "inv_hqr_hesdown";	
	
	//Use the cover of the smoke to run past the BTR into the alley!	
	level.scr_sound[ "raptor" ][ "inv_six_coverofsmoke" ]				 = "inv_six_coverofsmoke";
	//Ramirez! Come to alley!	
	level.scr_sound[ "raptor" ][ "inv_six_cometoalley" ]				 = "inv_six_cometoalley";
	
	//Squad, we still got 2,000 civvies in Arcadia! If you got family there it's your lucky day - we're gonna go save their lives!
	level.scr_radio[ "inv_fly_2kcivvies" ]				 = "inv_fly_2kcivvies";
 
 

}



	
	//need go to diner nags

	
	
	
	
	
	
	
	




//level.raptor anim_single_queue( level.raptor, "inv_six_getbackfromapc" );
//radio_dialogue( soundAlias, timeout );

/*
//LOCAL HOUSE DESTROYER
	
	
	
	
	
//LOCAL PIZZA TO CRASH
	

	
	//Seal Six-One:	Roach! Get back from that APC!	
	level.raptor anim_single_queue( level.raptor, "inv_six_getbackfromapc" );
	
	
//RADIO
	
	
	


*/