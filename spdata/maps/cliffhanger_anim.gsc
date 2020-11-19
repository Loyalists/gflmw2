#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\cliffhanger;
#include maps\cliffhanger_code;


main_anim()
{
	generic_human();
	script_models();
	player_anims();
	vehicles();
	
	climbing_test();
	dialog();
}

#using_animtree( "generic_human" );
climbing_test()
{
	level.scr_anim[ "price_a" ][ "climbing_test_scene" ]	 = %cliff_hero1_pose_A;
	level.scr_anim[ "cake_a" ][ "climbing_test_scene" ]		 = %cliff_hero2_pose_A;

	level.scr_anim[ "price_b" ][ "climbing_test_scene" ]	 = %cliff_hero1_pose_B;
	level.scr_anim[ "cake_b" ][ "climbing_test_scene" ]		 = %cliff_hero2_pose_B;

	level.scr_anim[ "price_c" ][ "climbing_test_scene" ]	 = %cliff_hero1_pose_C;
	level.scr_anim[ "cake_c" ][ "climbing_test_scene" ]		 = %cliff_hero2_pose_C;

	level.scr_anim[ "price_d" ][ "climbing_test_scene" ]	 = %cliff_hero1_pose_D;
	level.scr_anim[ "cake_d" ][ "climbing_test_scene" ]		 = %cliff_hero2_pose_D;

	level.scr_anim[ "price_jump" ][ "climbing_test_jump1" ]	 = %cliff_hero1_pose_jump1;
	level.scr_anim[ "price_jump" ][ "climbing_test_jump2" ]	 = %cliff_hero1_pose_jump2;
	level.scr_anim[ "price_jump" ][ "climbing_test_jump3" ]	 = %cliff_hero1_pose_jump3;
	level.scr_anim[ "price_jump" ][ "climbing_test_jump4" ]	 = %cliff_hero1_pose_jump4;
	level.scr_anim[ "price_jump" ][ "climbing_test_jump5" ]	 = %cliff_hero1_pose_jump5;
	level.scr_anim[ "price_jump" ][ "climbing_test_jump6" ]	 = %cliff_hero1_pose_jump6;
}

#using_animtree( "generic_human" );
generic_human()
{
	// quiet door open
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] = 			%hunted_open_barndoor;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] = 		%hunted_open_barndoor_idle;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][ 0 ] = 	%hunted_open_barndoor_idle;

	level.scr_anim[ "price" ][ "evac" ]							 = %blackout_bh_evac_1;
	
	// cliff deaths
	level.scr_anim[ "generic" ][ "cliffdeath_1" ] = %death_run_onfront;
	level.scr_anim[ "generic" ][ "cliffdeath_2" ] = %death_run_onleft;
	level.scr_anim[ "generic" ][ "cliffdeath_3" ] = %death_run_forward_crumple;
	level.scr_anim[ "generic" ][ "cliffdeath_4" ] = %run_death_roll;
	
	level.scr_anim[ "price" ][ "casual_crouch_exit" ] = %cliffhanger_casual_crouch_exit;
	
	// snowmobile price action
	level.scr_anim[ "price" ][ "hill_slide" ]			 = %cliffhanger_price_hill_slide;
	level.scr_anim[ "price" ][ "crash_rescue" ]			 = %cliffhanger_crash_rescue_price;
	level.scr_anim[ "generic" ][ "balcony_death" ]		 = %death_explosion_run_F_v2;

	addNotetrack_customFunction( "price", "price_land", ::price_land_fx );
	addNotetrack_customFunction( "price", "price_land_settle", ::price_land_settle_fx );
	addNotetrack_customFunction( "price", "price_slide_start", ::price_slide_fx );
	addNotetrack_customFunction( "price", "price_slide_end", ::price_stop_slide_fx );

	maps\_hand_signals::initHandSignals();

	level.scr_anim[ "generic" ][ "lean_balcony" ][ 0 ]			 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "lean_balcony" ][ 1 ]			 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "lean_balcony" ][ 2 ]			 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "lean_balcony" ][ 3 ]			 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "lean_balcony" ][ 4 ]			 = %killhouse_gaz_talk_side;
	level.scr_anim[ "generic" ][ "lean_react" ]					 = %exposed_idle_reactB;

	level.scr_anim[ "generic" ][ "sit_idle" ][ 0 ]				 = %breach_chair_idle_v2;
	level.scr_anim[ "generic" ][ "sit_react" ]					 = %breach_chair_reaction_v2;

	level.scr_anim[ "generic" ][ "party1" ][ 0 ]					 = %coup_guard1_idle;
	level.scr_anim[ "generic" ][ "party1" ][ 1 ]					 = %coup_guard1_jeer;
	level.scr_anim[ "generic" ][ "party1_react" ]				 = %breach_chair_reaction_v2;

	level.scr_anim[ "generic" ][ "party2" ][ 0 ]					 = %coup_guard2_idle;
	level.scr_anim[ "generic" ][ "party2" ][ 1 ]					 = %coup_guard2_jeerA;
	level.scr_anim[ "generic" ][ "party2" ][ 2 ]					 = %coup_guard2_jeerB;
	level.scr_anim[ "generic" ][ "party2" ][ 3 ]					 = %coup_guard2_jeerC;
	level.scr_anim[ "generic" ][ "party2_react" ]				 = %breach_chair_reaction_v2;

	//STANDARD COVER BEHAVIOR
	level.scr_anim[ "generic" ][ "alert2look_cornerR" ]				 = %corner_standr_alert_2_look;
	level.scr_anim[ "generic" ][ "look_idle_cornerR" ][ 0 ]			 = %corner_standR_look_idle;
	level.scr_anim[ "generic" ][ "look2alert_cornerR" ]				 = %corner_standR_look_2_alert;

	level.scr_anim[ "generic" ][ "look_up_stand" ]					 = %coverstand_look_moveup;
	level.scr_anim[ "generic" ][ "look_idle_stand" ][ 0 ]				 = %coverstand_look_idle;
	level.scr_anim[ "generic" ][ "look_down_stand" ]				 = %coverstand_look_movedown;

	level.scr_anim[ "generic" ][ "alert2look_cornerL" ]				 = %corner_standl_alert_2_look;
	level.scr_anim[ "generic" ][ "look_idle_cornerL" ][ 0 ]			 = %corner_standl_look_idle;
	level.scr_anim[ "generic" ][ "look2alert_cornerL" ]				 = %corner_standl_look_2_alert;

	level.scr_anim[ "generic" ][ "run_2_crouch_F" ]			 = %run_2_crouch_F;
	level.scr_anim[ "generic" ][ "run_2_crouch_90R" ]		 = %run_2_crouch_90R;
	level.scr_anim[ "generic" ][ "crouch_aim_arrive" ]		 = %exposed_crouch_aim_5;
	level.scr_anim[ "generic" ][ "crouch_aim" ][ 0 ]			 = %exposed_crouch_aim_5;
	level.scr_anim[ "generic" ][ "crouch_2run_L" ]			 = %crouch_2run_L;
	level.scr_anim[ "generic" ][ "exposed_crouch_flinchR" ]	 = %exposed_crouch_pain_right_arm;

	//LEDGE CLIMB
	level.scr_anim[ "price" ][ "ledge_climb" ]			= %cliffhanger_ledge_mantle_Price;

	//BASE
//	level.scr_anim[ "generic" ][ "fence_cut_guy1" ]		= %cliffhanger_price_fence_cut;
	level.scr_anim[ "generic" ][ "c4plant" ]			 = %cliffhanger_c4_setup;

	//ICEPICK
	level.scr_anim[ "price" ][ "icepick_fight" ]						= %cliffhanger_icepick_fight_Price;
	addNotetrack_attach(  "price", "attach pick", "weapon_ice_picker", "TAG_INHAND", "icepick_fight" );
	addNotetrack_detach( "price", "drop pick", "weapon_ice_picker", "TAG_INHAND", "icepick_fight" );

	level.scr_anim[ "driver" ][ "icepick_deathA" ]						= %cliffhanger_icepick_fight_driver_deathA;
	level.scr_anim[ "driver" ][ "icepick_deathB" ]						= %cliffhanger_icepick_fight_driver_deathB;
	level.scr_anim[ "driver" ][ "icepick_fight" ]						= %cliffhanger_icepick_fight_driver;
	addNotetrack_customFunction( "driver", "deathA", ::set_deathanim_a, "icepick_fight" );
	addNotetrack_customFunction( "driver", "deathB", ::set_deathanim_b, "icepick_fight" );

	level.scr_anim[ "passenger" ][ "icepick_fight" ]					= %cliffhanger_icepick_fight_passenger;
	addNotetrack_customFunction( "passenger", "dropgun", ::ai_kill, "icepick_fight" );
	
	level.scr_anim[ "generic" ][ "snowmobile_driver_climb_out" ]		 = %pickup_passenger_climb_out;
	level.scr_anim[ "generic" ][ "snowmobile_passenger_climb_out" ]		 = %pickup_driver_climb_out;
	level.scr_anim[ "generic" ][ "prone_death_quickdeath" ]				 = %prone_death_quickdeath;
	level.scr_anim[ "generic" ][ "death_shotgun_back_v2" ]				 = %death_shotgun_back_v1;

	//LOCKERROOM
	level.scr_anim[ "price" ][ "locker_brawl" ]			= %cliffhanger_lockerroom_fight_Price;
	addNotetrack_customFunction( "price", "locker slam", ::locker_slam, "locker_brawl" );
	addNotetrack_attach(  "price", "knife attach", "weapon_parabolic_knife", "TAG_INHAND", "locker_brawl" );
	addNotetrack_detach(  "price", "knife detach", "weapon_parabolic_knife", "TAG_INHAND", "locker_brawl" );

	level.scr_anim[ "defender" ][ "locker_brawl" ]		= %cliffhanger_lockerroom_fight_guard;
	addNotetrack_customFunction( "defender", "ignoreall", ::ignore_all, "locker_brawl" );
	addNotetrack_customFunction( "defender", "dropgun", ::ai_kill, "locker_brawl" );

	//BACKSIDE
	level.scr_anim[ "generic" ][ "crouch_walk_start_1" ]		 = %launchfacility_b_ventwalk_v1_start;
	level.scr_anim[ "generic" ][ "crouch_walk_stop_1" ]			 = %launchfacility_b_ventwalk_v1_stop;
	level.scr_anim[ "generic" ][ "crouch_walk_stop_1_idle" ][ 0 ]	 = %launchfacility_b_ventwalk_stop_idle;
	level.scr_anim[ "generic" ][ "crouch_walk_1" ]				 = %launchfacility_b_ventwalk_v1_cycle;
	level.scr_anim[ "generic" ][ "crouch_walk_1_twitch" ]		 = %launchfacility_b_ventwalk_v1_twitch;

	level.scr_anim[ "generic" ][ "crouch_walk_start_2" ]		 = %launchfacility_b_ventwalk_v2_start;
	level.scr_anim[ "generic" ][ "crouch_walk_stop_2" ]			 = %launchfacility_b_ventwalk_v2_stop;
	level.scr_anim[ "generic" ][ "crouch_walk_stop_2_idle" ][ 0 ]	 = %launchfacility_b_ventwalk_v2_stopidle;
	level.scr_anim[ "generic" ][ "crouch_walk_2" ]				 = %launchfacility_b_ventwalk_v2_cycleA;
	level.scr_anim[ "generic" ][ "crouch_walk_2_twitch1" ]		 = %launchfacility_b_ventwalk_v2_twitchA;
	level.scr_anim[ "generic" ][ "crouch_walk_2_twitch2" ]		 = %launchfacility_b_ventwalk_v2_twitchB;


	//WELDERS
	level.scr_anim[ "welder_wing" ][ "welding" ][ 0 ]			= %cliffhanger_welder_wing;
	level.scr_anim[ "welder_engine" ][ "welding" ][ 0 ]		= %cliffhanger_welder_engine;



	//HANGER
	/*
	level.scr_anim[ "price" ][ "capture" ]			= %cliffhanger_capture_Price;
	level.scr_anim[ "guard1" ][ "capture" ]		= %cliffhanger_capture_guard;
	level.scr_anim[ "guard2" ][ "capture" ]		= %cliffhanger_capture_guard2;
	level.scr_anim[ "guard3" ][ "capture" ]		= %cliffhanger_capture_guard3;
	level.scr_anim[ "guard4" ][ "capture" ]		= %cliffhanger_capture_guard4;
	level.scr_anim[ "guard5" ][ "capture" ]		= %cliffhanger_capture_guard5;
	level.scr_anim[ "guard6" ][ "capture" ]		= %cliffhanger_capture_guard6;
	*/
	level.scr_anim[ "price" ][ "capture_idle" ][0]			= %cliffhanger_capture_Price_idle;
	level.scr_anim[ "price" ][ "capture_pullout" ]		= %cliffhanger_capture_Price_pullout;

	
	//addNotetrack_customFunction( "price", "explosion_start", ::explosion_chain_reaction );
	//addNotetrack_customFunction( "price", "explosion_start", ::player_slow_mo );

	level.scr_anim[ "guard1" ][ "runin" ]		= %CQB_runin_R1;
	level.scr_anim[ "guard2" ][ "runin" ]		= %CQB_runin_R2;
	level.scr_anim[ "guard3" ][ "runin" ]		= %CQB_runin_L1;
	level.scr_anim[ "guard4" ][ "runin" ]		= %CQB_runin_L2;


	//Price�s Anims for the sat.
	level.scr_anim[ "price" ][ "enter" ]							= %cliffhanger_hanger_enter;
	level.scr_anim[ "price" ][ "satellite_idle" ][0]				= %cliffhanger_hanger_cycle;
	/*
	level.scr_anim[ "price" ][ "satellite_idle" + "weight" ][ 0 ]	= 100;
	level.scr_anim[ "price" ][ "satellite_idle" ][1]				= %cliffhanger_hanger_waveA;
	level.scr_anim[ "price" ][ "satellite_idle" + "weight" ][ 1 ]	= 100;
	level.scr_anim[ "price" ][ "satellite_idle" ][2]				= %cliffhanger_hanger_waveB;
	level.scr_anim[ "price" ][ "satellite_idle" + "weight" ][ 2 ]	= 100;
	*/

	//You can throw these in randomly on the guys in CQB to make them less static.
	level.scr_anim[ "generic" ][ "capture_shoutingA" ]		= %CQB_stand_shout_A;
	level.scr_anim[ "generic" ][ "capture_shoutingB" ]		= %CQB_stand_shout_B;

	//added 5 reaction animations for cliffhanger capture sequence. 
	level.scr_anim[ "generic" ][ "explosion_reactA" ]		= %CQB_stand_react_A;
	level.scr_anim[ "generic" ][ "explosion_reactB" ]		= %CQB_stand_react_B;
	level.scr_anim[ "generic" ][ "explosion_reactC" ]		= %CQB_stand_react_C;
	level.scr_anim[ "generic" ][ "explosion_reactD" ]		= %CQB_stand_react_D;
	level.scr_anim[ "generic" ][ "explosion_reactE" ]		= %CQB_stand_react_E;

	// cold patrol
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_a" ]	= %patrolwalk_cold_gunup_idle;
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_b" ]	= %patrolwalk_cold_gunup_idle;
	
	level.scr_anim[ "generic" ][ "patrol_cold_huddle" ][0]		= %patrolwalk_cold_huddle_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle" ][1]		= %patrolwalk_cold_huddle_twitch;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle_pause" ]	= %patrolwalk_cold_huddle_stand_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle_stop" ]	= %patrolwalk_cold_huddle_walk2stand;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle_start" ]	= %patrolwalk_cold_huddle_stand2walk;
	
	level.scr_anim[ "generic" ][ "patrol_cold_crossed" ][0]		= %patrolwalk_cold_crossed_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed" ][1]		= %patrolwalk_cold_crossed_twitch;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed_pause" ]	= %patrolwalk_cold_crossed_stand_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed_stop" ]	= %patrolwalk_cold_crossed_walk2stand;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed_start" ]	= %patrolwalk_cold_crossed_stand2walk;

	weights = [];
	weights[0] = 8;
	weights[1] = 2;
	
	level.scr_anim[ "generic" ][ "patrol_twitch_weights" ] = get_cumulative_weights( weights );
	
	level.scr_anim[ "generic" ][ "patrol_cold_gunup_search" ] = %patrolwalk_cold_gunup_idle;
	
	level.scr_anim[ "generic" ][ "patrol_cold_gunup" ][0]	= %patrolwalk_cold_gunup_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_gunup" ][1]	= %patrolwalk_cold_gunup_twitchA;
	level.scr_anim[ "generic" ][ "patrol_cold_gunup" ][2]	= %patrolwalk_cold_gunup_twitchB;	
	
	weights = [];
	weights[0] = 4;
	weights[1] = 3;	
	weights[2] = 3;	
	
	level.scr_anim[ "generic" ][ "patrol_gunup_twitch_weights" ] = get_cumulative_weights( weights );
	
	//TRUCKRIDE
	level.scr_anim[ "generic" ][ "truckride_climbin" ]			 = %traverse_stepup_52;

	//JEEPCRASH
//	level.scr_anim[ "generic" ][ "cliff_jeep_crash_price" ]		= %cliff_jeep_crash_price;	
}

set_deathanim_a( guy )
{
	guy set_deathAnim( "icepick_deathA" );
}

set_deathanim_b( guy )
{
	guy set_deathAnim( "icepick_deathB" );
}

price_land_fx ( price )
{
	//iprintlnbold( "Touch Down" );
	//playfxontag( getfx( "price_landing" ), price, "J_Ankle_RI");

	tagPos = price gettagorigin( "J_Ankle_RI" );	// rough tag to play fx on
	tagPos = PhysicsTrace( tagPos + ( 0,0,64), tagPos + ( 0,0,-64) );
	playfx( level._effect[ "price_landing" ], tagPos );

}

price_land_settle_fx ( price )
{
	tagPos = price gettagorigin( "J_Ankle_LE" );	// rough tag to play fx on
	tagPos = PhysicsTrace( tagPos + ( 0,0,64), tagPos + ( 0,0,-64) );
	playfx( level._effect[ "price_landing" ], tagPos );
}

price_slide_fx( price )
{
	self endon( "stop_slide_fx" );
	while ( true )
	{
		playfxontag( getfx( "price_sliding" ), price, "J_Ankle_LE" );
		wait( .1 );
	}
}

price_stop_slide_fx( price )
{
	self notify( "stop_slide_fx" );	
}

#using_animtree( "script_model" );
script_models()
{
//	level.scr_animtree[ "fence" ]						= #animtree;
//	level.scr_anim[ "fence" ][ "fence_cut_model" ]		= %cliffhanger_price_fence_cut_fence;
//	level.scr_model[ "fence" ]							= "cliffhanger_fence_cut";

	level.scr_animtree[ "flag_square" ]					= #animtree;
	level.scr_anim[ "flag_square" ][ "flag_waves" ]		= %cliffhanger_square_flag_high_wind;
	level.scr_model[ "flag_square" ]					= "com_square_flag";

	level.scr_animtree[ "flag_triangle" ]				= #animtree;
	level.scr_anim[ "flag_triangle" ][ "flag_waves" ]	= %cliffhanger_triangle_flag_high_wind;
	level.scr_model[ "flag_triangle" ]					= "com_triangle_flag";

	level.scr_animtree[ "locker_1" ]				= #animtree;
	level.scr_anim[ "locker_1" ][ "locker_brawl" ]	= %cliffhanger_lockerroom_fight_locker_1;
	level.scr_model[ "locker_1" ]					= "com_locker_open";

	level.scr_animtree[ "locker_2" ]				= #animtree;
	level.scr_anim[ "locker_2" ][ "locker_brawl" ]	= %cliffhanger_lockerroom_fight_locker_2;
	level.scr_model[ "locker_2" ]					= "com_locker_open";
	
	level.scr_animtree[ "fallingtree" ]											= #animtree;
	level.scr_anim[ "fallingtree" ][ "destroyed_fallen_tree_cliffhanger01" ]	= %destroyed_fallen_tree_cliffhanger01;
	level.scr_model[ "fallingtree" ]											= "foliage_tree_destroyed_fallen_tree_a_animated";

	thread destroyed_fallen_tree_cliffhanger01();
	
//map_source/prefabs/cliffhanger/flag_triangle_anim01.map  
	level.scr_anim[ "drill" ][ "enter" ]							= %cliffhanger_hangar_drill;
	level.scr_model[ "drill" ] 										= "weapon_power_drill";
	level.scr_animtree[ "drill" ]									= #animtree;
}

locker_slam( price )
{
	locker_dyn_explosion_orgs = getentarray( "locker_dyn_explosion_org", "targetname" );
	foreach ( org in locker_dyn_explosion_orgs )
	{
		PhysicsExplosionSphere( org.origin, 100, 80, 0.3 );	
	}
}

destroyed_fallen_tree_cliffhanger01()
{
	fallingtree = spawn_anim_model( "fallingtree" );
	node = getent( "animated_destroyed_fallen_tree01", "targetname" );
	node anim_first_frame_solo( fallingtree, "destroyed_fallen_tree_cliffhanger01" );

	flag_wait ( "destroyed_fallen_tree_cliffhanger01" );
	exploder ( 18 ); //set in createfx
	wait( .25 );
	playfx( level._effect[ "tree_trunk_explosion" ], node.origin );
	node anim_single_solo( fallingtree, "destroyed_fallen_tree_cliffhanger01" );
			
}


#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_rig" ] 							 = #animtree;
	level.scr_model[ "player_rig" ] 							 = "ch_viewhands_player_gk_ar15";

	level.scr_anim[ "player_rig" ][ "player_evac" ]				 = %blackout_bh_evac_player;
}

#using_animtree("vehicles");
vehicles()
{	
	level.scr_animtree[ "mig" ]							= #animtree;
	level.scr_anim[ "mig" ][ "mig_landing1" ]			= %cliffhanger_mig_landing_1;
	level.scr_anim[ "mig" ][ "mig_landing2" ]			= %cliffhanger_mig_landing_2;
	level.scr_model[ "mig" ]							= "vehicle_mig29";	

	level.scr_animtree[ "snowmobile" ]					= #animtree;
	level.scr_anim[ "snowmobile" ][ "icepick_fight" ]	= %cliffhanger_icepick_fight_snowmobile;
	level.scr_model[ "snowmobile" ]						= "vehicle_snowmobile_alt";
	
	level.scr_animtree[ "heli" ]						= #animtree;
	level.scr_anim[ "heli" ][ "avalanche_heli_wipeout" ]	= %cliffhanger_crash_mi28_crash;
	

	addNotetrack_customFunction( "mig", "touchdown_fx", ::mig_touchdown_fx );
	addNotetrack_customFunction( "snowmobile", "snowmobile_skidout", ::snowmobile_skidout_fx );
	addNotetrack_customFunction( "snowmobile", "snowmobile_stop_skidout", ::snowmobile_stop_skidout_fx );
	
//	level.scr_animtree[ "jeep" ]						= #animtree;
//	level.scr_anim[ "jeep" ][ "cliff_jeep_crash" ]		= %cliff_jeep_crash;
//	level.scr_model[ "jeep" ]							= "vehicle_uaz_winter";	
//	
}

snowmobile_skidout_fx ( snowmobile )
{

// commented out to hand off to code.  the effect behavior "effect at spawn" playing from a 
// "playfxontag" isn't taking on the bone position, as it should
//	playfxontag( getfx( "tread_snow_snowmobile_skidout" ), snowmobile, "tag_deathfx" );
	
	level endon( "stop_skidout_fx" );
	while ( true )
	{
		playfxontag( getfx( "tread_snow_snowmobile_skidout" ), snowmobile, "tag_deathfx" );
		wait( .03 );
	}
}

snowmobile_stop_skidout_fx( snowmobile )
{
	level notify( "stop_skidout_fx" );	
}

mig_touchdown_fx ( mig )
{
	//iprintlnbold( "Touch Down" );
	playfxontag( getfx( "mig_landing_snow" ), mig, "tag_origin");
	playfxontag( getfx( "mig_landing_trail_snow" ), mig, "origin_animate_jnt");
	
}

#using_animtree( "generic_human" );


c4_swap( guy )
{
	C4org = guy gettagorigin( "TAG_INHAND" );
	C4angles = guy gettagangles( "TAG_INHAND" );

	c4_model = spawn( "script_model", C4org );
	c4_model setmodel( "weapon_c4" );
	c4_model.angles = C4angles;

	c4_model thread maps\_c4::playC4Effects();
}

lockerroom_noturningback( guy )
{
	flag_set( "locker_room_noturningback" );
}

ignore_all( guy )
{
	guy.allowDeath = false;
	flag_set( "locker_brawl_becomes_uninteruptable" );
}

ai_kill( guy )
{
	if ( !isalive( guy ) )
		return;
	guy.allowDeath = true;
	guy.a.nodeath = true;
	guy set_battlechatter( false );

	guy kill();

	/*
	tagPos = guy gettagorigin( "j_SpineUpper" );	// rough tag to play fx on
	tagPos = PhysicsTrace( tagPos + ( 0,0,64), tagPos + ( 0,0,-64) );
	playfx( level._effect[ "deathfx_bloodpool_generic" ], tagPos );
	*/	
}

dialog()
{
//THEY HAVE NO IDEA
	//Soap, these muppets have no idea we�re here. Let�s take this nice and slow.	
	level.scr_sound[ "price" ][ "cliff_pri_noidea" ]				 = "cliff_pri_noidea";
	



	//Target down.	
	level.scr_sound[ "price" ][ "cliff_pri_killfirm" ]				 = "cliff_pri_killfirm";







//RUN ACROSS TARMAC
	//Soap! Follow me! Let's go!!!	
	level.scr_sound[ "price" ][ "follow_me" ]				 = "cliff_pri_followmeletsgo";

	

//RUSSIAN YELLING
	
//PLAYER KILLED SOMEONE	
	level.scr_sound[ "price" ][ "cliff_pri_killfirm_plyr" ]				 = "cliff_pri_killfirm_plyr";

//PLAYER STABBED SOMEONE	
	level.scr_sound[ "price" ][ "cliff_pri_melee_plyr" ]				 = "cliff_pri_melee_plyr";


//PRICE OUT OF BASE DIALOG
//HEART BEAT SETUP---
	
	//Soap, check your heartbeat sensor.	
	level.scr_sound[ "price" ][ "cliff_pri_checksensor" ]		 = "cliff_pri_checksensor";
	level.scr_face[ "price" ][ "cliff_pri_checksensor" ]		 = %cliff_pri_checksensor;

	//You should be able to see me on the scope.	
	level.scr_sound[ "price" ][ "cliff_pri_seeme" ]		 = "cliff_pri_seeme";
	level.scr_face[ "price" ][ "cliff_pri_seeme" ]		 = %cliff_pri_seeme;
	
	//That blue dot is me.	
	level.scr_sound[ "price" ][ "cliff_pri_bluedot" ]		 = "cliff_pri_bluedot";
	level.scr_face[ "price" ][ "cliff_pri_bluedot" ]		 = %cliff_pri_bluedot;
	
	
	//Any unrecognized contacts will show up as white dots.	
	level.scr_sound[ "price" ][ "cliff_pri_whitedots" ]		 = "cliff_pri_whitedots";
	level.scr_face[ "price" ][ "cliff_pri_whitedots" ]		 = %cliff_pri_whitedots;
	
	
//FIRST ENCOUNTER	---
	//You take the one on the left. 	
	level.scr_sound[ "price" ][ "cliff_pri_youtakeleft" ]		 = "cliff_pri_youtakeleft";
	//On three. One...two...three.	
	level.scr_sound[ "price" ][ "cliff_pri_onthree" ]		 = "cliff_pri_onthree";
	
//SECOND ENCOUNTER	---
	//Same plan.	
	level.scr_sound[ "price" ][ "cliff_pri_sameplan" ]		 = "cliff_pri_sameplan";
	
	
//IVE GOT YOUR BACK	---
	//All right, I've tapped into their comms.	
	level.scr_sound[ "price" ][ "cliff_pri_tappedcomms" ]		 = "cliff_pri_tappedcomms";
	//Picking up a lot of chatter about some bird named Pvt. Natalya. 	
	level.scr_sound[ "price" ][ "cliff_pri_pvtnatalya" ]		 = "cliff_pri_pvtnatalya";
	//That's odd. Last I checked, they didn't allow female combatants in their army.	
	level.scr_sound[ "price" ][ "cliff_pri_femcombatants" ]		 = "cliff_pri_femcombatants";
	
//STORM	---
	//The storm's brewing up.	
	level.scr_sound[ "price" ][ "cliff_pri_stormsbrewing" ]		 = "cliff_pri_stormsbrewing";

	
//ON YOUR LEFT
	//Tango to your left.	
	level.scr_sound[ "price" ][ "cliff_pri_tangoleft" ]		 = "cliff_pri_tangoleft";
	//Target on your left.	
	level.scr_sound[ "price" ][ "cliff_pri_targetleft" ]		 = "cliff_pri_targetleft";

//ON YOUR RIGHT	
	//Hostile to the right.	
	level.scr_sound[ "price" ][ "cliff_pri_hostileright" ]		 = "cliff_pri_hostileright";
	//Target on your right.	
	level.scr_sound[ "price" ][ "cliff_pri_targetright" ]		 = "cliff_pri_targetright";

//BEHIND YOU	
	//Tango on your six.	
	level.scr_sound[ "price" ][ "cliff_pri_tangosix" ]		 = "cliff_pri_tangosix";
	//Target behind you.	
	level.scr_sound[ "price" ][ "cliff_pri_targetbehindyou" ]		 = "cliff_pri_targetbehindyou";
	


//THEY ARE RESPAWNING---
	//Hold up.	
	level.scr_sound[ "price" ][ "cliff_pri_holdup" ]		 = "cliff_pri_holdup";
	//I'm seeing some activity on the runway.	
	level.scr_sound[ "price" ][ "cliff_pri_activityonrunway" ]		 = "cliff_pri_activityonrunway";
	//Looks like twenty plus 'foot-mobiles' headed your way
	level.scr_sound[ "price" ][ "cliff_pri_footmobiles" ]		 = "cliff_pri_footmobiles";

//STAY AWAY FROM BMP	---
	//Picking up large heat signatures near the tower, could be BMPs. I'd avoid that area.
	level.scr_sound[ "price" ][ "cliff_pri_avoidarea" ]		 = "cliff_pri_avoidarea";

//GOTO HANGER	---
	//I'm picking more radio traffic about the satellite. Standby.	
	level.scr_sound[ "price" ][ "cliff_pri_radiotraffic" ]		 = "cliff_pri_radiotraffic";
	//Got it. Sounds like the satellite's in the far hangar.	
	level.scr_sound[ "price" ][ "cliff_pri_infarhangar" ]		 = "cliff_pri_infarhangar";
	//Race you there. Oscar Mike. Out.	
	level.scr_sound[ "price" ][ "cliff_pri_oscarmike" ]		 = "cliff_pri_oscarmike";

//THEY FOUND A BODY	---
	//Hold on - they've only found a body. They don't know where you are.	
	level.scr_sound[ "price" ][ "cliff_pri_foundabody" ]		 = "cliff_pri_foundabody";
	//Looks like they've found a corpse, but they haven't seen you yet. Keep quiet.	
	level.scr_sound[ "price" ][ "cliff_pri_keepquiet" ]		 = "cliff_pri_keepquiet";
	//Soap - they found a corpse but they're not onto you yet. Stay calm.	
	level.scr_sound[ "price" ][ "cliff_pri_staycalm" ]		 = "cliff_pri_staycalm";

//GOOD JOB	---
	//Nicely done.	
	level.scr_sound[ "price" ][ "cliff_pri_nicelydone" ]		 = "cliff_pri_nicelydone";



//PRICE KILLED SOMEONE---
	level.scr_sound[ "price" ][ "tango_down" ]					= "cliff_pri_killfirm";





//LETS SPLIT UP -----
	//Let�s split up. I'll use the thermal scope and provide overwatch from this ridge.	
	level.scr_sound[ "price" ][ "cliff_pri_splitup" ]					= "cliff_pri_splitup";
	
	//You'll be like a ghost in this blizzard, so the guards won�t see you until you�re very close.	
	level.scr_sound[ "price" ][ "cliff_pri_likeaghost" ]					= "cliff_pri_likeaghost";

//YOU'RE IN - PLAN B -----
	//All right, you're in. Head to the left and plant your C4 on a fuel tank. We may need to go to �Plan B� if things go south.	
	level.scr_sound[ "price" ][ "cliff_pri_yourein" ]					= "cliff_pri_yourein";

//TRUCK COMING ----
	//There�s a truck coming! Stay out of sight.	
	level.scr_sound[ "price" ][ "cliff_pri_truckcoming" ]					= "cliff_pri_truckcoming";


//TRUCK BLOWN UP ----
	//Gee, I wonder if they will notice a flaming wreck in the middle of the road�.	
	level.scr_sound[ "price" ][ "cliff_pri_flamingwreck" ]					= "cliff_pri_flamingwreck";

	
	//Stay out of sight - you�ve alerted some guards.	
	level.scr_sound[ "price" ][ "cliff_pri_outofsight" ]					= "cliff_pri_outofsight";


//SILENCER ADVICE ----
	//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
	level.scr_sound[ "price" ][ "cliff_pri_attractattn" ]					= "cliff_pri_attractattn";
	
//SNEAKY PROGRESS	----
	//Pretty sneaky Soap. No one�s been alerted to your presence.	
	level.scr_sound[ "price" ][ "cliff_pri_prettysneaky" ]					= "cliff_pri_prettysneaky";

//GET INTO POSITION FIRST FOUR ----
	//Two tangos in front.	
	level.scr_sound[ "price" ][ "cliff_pri_2tangosfront" ]					= "cliff_pri_2tangosfront";
	
//BMP DANGER ----
	//That BMP�s got thermal sights � get the hell out of there!	
	level.scr_sound[ "price" ][ "cliff_pri_getoutofthere" ]					= "cliff_pri_getoutofthere";
	
	
	//Nice work.	
	level.scr_sound[ "price" ][ "cliff_pri_nicework" ]					= "cliff_pri_nicework";
	
//PRICE SNIPES	****
	//I'll take this one.	
	level.scr_sound[ "price" ][ "cliff_pri_takethisone" ]		 = "cliff_pri_takethisone";
	//He's mine.	
	level.scr_sound[ "price" ][ "cliff_pri_hesmine" ]		 = "cliff_pri_hesmine";
	//I've got him.	
	level.scr_sound[ "price" ][ "cliff_pri_ivegothim" ]					= "cliff_pri_ivegothim";
	//This one is mine.	
	level.scr_sound[ "price" ][ "cliff_pri_onesmine" ]					= "cliff_pri_onesmine";
	//I'll take him.	
	level.scr_sound[ "price" ][ "cliff_pri_illtakehim" ]					= "cliff_pri_illtakehim";
	

//PLAYER LATE TO HANGER ****
	//Took the scenic route eh?	
	level.scr_sound[ "price" ][ "cliff_pri_scenicroute" ]					= "cliff_pri_scenicroute";
	level.scr_face[ "price" ][ "cliff_pri_scenicroute" ]					= %cliff_pri_scenicroute;
	

//TRUCK STOPPED ****
	//Heads up, the truck just stopped.	
	level.scr_sound[ "price" ][ "cliff_pri_headsup" ]					= "cliff_pri_headsup";
	
	//Four tangos just got out and are looking around.	
	level.scr_sound[ "price" ][ "cliff_pri_lookingaround" ]					= "cliff_pri_lookingaround";



//STEALTH BROKEN ****
	//Take cover! They're on to you!	
	level.scr_sound[ "price" ][ "cliff_pri_takecover" ]					= "cliff_pri_takecover";
	
	//You've been spotted take cover!	
	level.scr_sound[ "price" ][ "cliff_pri_beenspotted" ]					= "cliff_pri_beenspotted";
	
	//Get out of there they've found you!	
	level.scr_sound[ "price" ][ "cliff_pri_foundyou" ]					= "cliff_pri_foundyou";
	
	//Heads up! I see tangos coming from multiple directions!	
	level.scr_sound[ "price" ][ "cliff_pri_multipledirections" ]					= "cliff_pri_multipledirections";

	
//STEALTH FAILURE
	//Not very sneaky, Soap.	
	level.scr_sound[ "price" ][ "cliff_pri_notsneaky" ]				 = "cliff_pri_notsneaky";
	
	//This is easier when you don't alert them.	
	level.scr_sound[ "price" ][ "cliff_pri_dontalertthem" ]				 = "cliff_pri_dontalertthem";
	
	//That was sloppy.	
	level.scr_sound[ "price" ][ "cliff_pri_sloppy" ]					= "cliff_pri_sloppy";
	
	//There is a reason we brought silencers. 	
	level.scr_sound[ "price" ][ "cliff_pri_silencers" ]				 = "cliff_pri_silencers";

	

	
	//* Let�s go.	
	level.scr_sound[ "price" ][ "letsgo" ] = "cliff_pri_letsgo";
	level.scr_face[ "price" ][ "letsgo" ] = %cliff_pri_letsgo;
	


	//* Good luck mate - see you on the far side.	
	level.scr_sound[ "price" ][ "thefarside" ] = "cliff_pri_thefarside";

//	enemies_persue_on_bike
	// �More tangos to the rear! Just outrun them! Go! Go!�	
	level.scr_radio[ "outrunthem" ] = "cliff_pri_outrunthem";
	
	// �Don�t slow down! Keep moving or you�re dead!�	
	level.scr_radio[ "keepmoving" ] = "cliff_pri_keepmoving";

	// �Go! Go! Go!�	
	level.scr_radio[ "gogogo" ] = "cliff_pri_gogogo";
	
	// �Avalaaaanche!!!!!�	
	level.scr_radio[ "avalanche" ] = "cliff_pri_avalanche";
	
	// �More tangos on our six! Take �em out!� 	
	level.scr_radio[ "moretangos" ] = "cliff_pri_moretangos";
	
//	player_survived_minijump + 2 sec
	// �We�re gonna make it! Just hang on!�	
	level.scr_radio[ "gonnamakeit" ] = "cliff_pri_gonnamakeit";
	
//	snowmobile_price_full_speed
	// �Come on! Come on!� 	
	level.scr_radio[ "comeoncomeon" ] = "cliff_pri_comeoncomeon";
	
//	price_hang_on
	// �Hang ooonnn!!!� 	
	level.scr_radio[ "hangon2" ] = "cliff_pri_hangon2";
	
	// �Stay close and hug the wall! We�ll use the MiGs for cover and cross the tarmac to the southeast!�	
	level.scr_sound[ "price" ][ "hugthewall" ] = "cliff_pri_hugthewall";

	// "Alright, let's go!"
	level.scr_sound[ "price" ][ "allright" ] = "cliff_pri_allright";
	
	// �Head for that MiG, I�ll cover you!�	
	level.scr_sound[ "price" ][ "headformig" ] = "cliff_pri_headformig";
	
	// �I�m heading for those jeeps, cover me!�	
	level.scr_sound[ "price" ][ "headingforjeeps" ] = "cliff_pri_headingforjeeps";
	
	// �I�ll make a run for the next MiG! Give me some covering fire!�	
	level.scr_sound[ "price" ][ "runtonextmig" ] = "cliff_pri_runtonextmig";
		
	// �Cover me, I�m making a break for it!�	
	level.scr_sound[ "price" ][ "makingabreak" ] = "cliff_pri_makingabreak";
	
	// �I�ve got you covered Soap! Move up! Move up!�	
	level.scr_sound[ "price" ][ "moveup" ] = "cliff_pri_moveup";
	
	// �I�ll cover you! Come to me!�	
	level.scr_sound[ "price" ][ "cometome" ] = "cliff_pri_cometome";
	
	// �Snowmobiles! Take �em out!!�	
	level.scr_sound[ "price" ][ "snowmoibles" ] = "cliff_pri_snowmoibles";
	
	// "Soap, I've been compromised! Keep a low profile and hold your fire." 
	level.scr_sound[ "price" ][ "compromised" ] = "cliff_pri_compromised";
		
	// "Soap, Go to plan b
	level.scr_sound[ "price" ][ "plan_b" ] = "cliff_pri_goplanb";

	// put it on price for now		
	// "This is major petrov! Come out with your hands up!
	level.scr_sound[ "price" ][ "petrov" ] = "cliff_pet_thisispetrov";
	
	// To enemy infiltrators, we have captured one of your comrades!	
	level.scr_sound[ "price" ][ "cliff_pet_capturedcomrade" ] = "cliff_pet_capturedcomrade";
	
	// We know you are up there! Surrender now and we will spare your comrade!	
	level.scr_sound[ "price" ][ "cliff_pet_surrender" ] = "cliff_pet_surrender";
	
	// If you do not surrender, your comrade will die.	
	level.scr_sound[ "price" ][ "cliff_pet_willdie" ] = "cliff_pet_willdie";
	
	// Come out with your hands up!	
	level.scr_sound[ "price" ][ "cliff_pet_handsup" ] = "cliff_pet_handsup";
	
	// Very well - I will give you five seconds before I execute your comrade!	
	level.scr_sound[ "price" ][ "cliff_pet_verywell" ] = "cliff_pet_verywell";
	
	// "You have five seconds to comply!"	"cliff_pet_fiveseconds
	level.scr_sound[ "price" ][ "fiveseconds" ] = "cliff_pet_fiveseconds";
	
	// 5 4 3 2 1
	level.scr_sound[ "price" ][ "count_five" ] = "cliff_pet_countfive";
	level.scr_sound[ "price" ][ "count_four" ] = "cliff_pet_countfour";
	level.scr_sound[ "price" ][ "count_three" ] = "cliff_pet_countthree";
	level.scr_sound[ "price" ][ "count_two" ] = "cliff_pet_counttwo";
	level.scr_sound[ "price" ][ "count_one" ] = "cliff_pet_countone";

	// �Soap, get upstairs and download the files.�	
	level.scr_sound[ "price" ][ "downloadfiles" ] = "cliff_pri_downloadfiles";
	level.scr_face[ "price" ][ "downloadfiles" ] = %cliff_pri_downloadfiles;
	

	// �To the east, soap! Go!�	
	level.scr_sound[ "price" ][ "eastgo" ] = "cliff_pri_eastgo";

	// �Soap, make a run for that MIG to the east!�	
	level.scr_sound[ "price" ][ "runformigeast" ] = "cliff_pri_runformigeast";
	level.scr_face[ "price" ][ "runformigeast" ] = %cliff_pri_runformigeast;
	
	
		

 

 

 
 
 
 
 
 ///////////////////////////////////////////////
 
 ///////////////RADIO
		
		
		//PLAYER KILLED SOMEONE	
	level.scr_radio[ "cliff_pri_killfirm_plyr" ]				 = "cliff_pri_killfirm_plyr";

//PLAYER STABBED SOMEONE	
	level.scr_radio[ "cliff_pri_melee_plyr" ]				 = "cliff_pri_melee_plyr";



//PRICE OUT OF BASE DIALOG
//HEART BEAT SETUP---
	
	//Soap, check your heartbeat sensor.	
	level.scr_radio[ "cliff_pri_checksensor" ]		 = "cliff_pri_checksensor";
	//You should be able to see me on the scope.	
	level.scr_radio[ "cliff_pri_seeme" ]		 = "cliff_pri_seeme";
	//That blue dot is me.	
	level.scr_radio[ "cliff_pri_bluedot" ]		 = "cliff_pri_bluedot";
	
	//Any unrecognized contacts will show up as white dots.	
	level.scr_radio[ "cliff_pri_whitedots" ]		 = "cliff_pri_whitedots";
	
	//You take the one on the left. 	
	level.scr_radio[ "cliff_pri_youtakeleft" ]		 = "cliff_pri_youtakeleft";
	//On three. One...two...three.	
	level.scr_radio[ "cliff_pri_onthree" ]		 = "cliff_pri_onthree";
	
//SECOND ENCOUNTER	---
	//Same plan.	
	level.scr_radio[ "cliff_pri_sameplan" ]		 = "cliff_pri_sameplan";
	
	
//IVE GOT YOUR BACK	---
	//All right, I've tapped into their comms.	
	level.scr_radio[ "cliff_pri_tappedcomms" ]		 = "cliff_pri_tappedcomms";
	//Picking up a lot of chatter about some bird named Pvt. Natalya. 	
	level.scr_radio[ "cliff_pri_pvtnatalya" ]		 = "cliff_pri_pvtnatalya";
	//That's odd. Last I checked, they didn't allow female combatants in their army.	
	level.scr_radio[ "cliff_pri_femcombatants" ]		 = "cliff_pri_femcombatants";
	
//STORM	---
	//The storm's brewing up.	
	level.scr_radio[ "cliff_pri_stormsbrewing" ]		 = "cliff_pri_stormsbrewing";

	
//ON YOUR LEFT
	//Tango to your left.	
	level.scr_radio[ "cliff_pri_tangoleft" ]		 = "cliff_pri_tangoleft";
	//Target on your left.	
	level.scr_radio[ "cliff_pri_targetleft" ]		 = "cliff_pri_targetleft";

//ON YOUR RIGHT	
	//Hostile to the right.	
	level.scr_radio[ "cliff_pri_hostileright" ]		 = "cliff_pri_hostileright";
	//Target on your right.	
	level.scr_radio[ "cliff_pri_targetright" ]		 = "cliff_pri_targetright";

//BEHIND YOU	
	//Tango on your six.	
	level.scr_radio[ "cliff_pri_tangosix" ]		 = "cliff_pri_tangosix";
	//Target behind you.	
	level.scr_radio[ "cliff_pri_targetbehindyou" ]		 = "cliff_pri_targetbehindyou";
	


//THEY ARE RESPAWNING---
	//Hold up.	
	level.scr_radio[ "cliff_pri_holdup" ]		 = "cliff_pri_holdup";
	//I'm seeing some activity on the runway.	
	level.scr_radio[ "cliff_pri_activityonrunway" ]		 = "cliff_pri_activityonrunway";
	//Looks like twenty plus 'foot-mobiles' headed your way
	level.scr_radio[ "cliff_pri_footmobiles" ]		 = "cliff_pri_footmobiles";

//STAY AWAY FROM BMP	---
	//Picking up large heat signatures near the tower, could be BMPs. I'd avoid that area.
	level.scr_radio[ "cliff_pri_avoidarea" ]		 = "cliff_pri_avoidarea";

//GOTO HANGER	---
	//I'm picking more radio traffic about the satellite. Standby.	
	level.scr_radio[ "cliff_pri_radiotraffic" ]		 = "cliff_pri_radiotraffic";
	//Got it. Sounds like the satellite's in the far hangar.	
	level.scr_radio[ "cliff_pri_infarhangar" ]		 = "cliff_pri_infarhangar";
	//Race you there. Oscar Mike. Out.	
	level.scr_radio[ "cliff_pri_oscarmike" ]		 = "cliff_pri_oscarmike";

//THEY FOUND A BODY	---
	//Hold on - they've only found a body. They don't know where you are.	
	level.scr_radio[ "cliff_pri_foundabody" ]		 = "cliff_pri_foundabody";
	//Looks like they've found a corpse, but they haven't seen you yet. Keep quiet.	
	level.scr_radio[ "cliff_pri_keepquiet" ]		 = "cliff_pri_keepquiet";
	//Soap - they found a corpse but they're not onto you yet. Stay calm.	
	level.scr_radio[ "cliff_pri_staycalm" ]		 = "cliff_pri_staycalm";

//GOOD JOB	---
	//Nicely done.	
	level.scr_radio[ "cliff_pri_nicelydone" ]		 = "cliff_pri_nicelydone";

//PRICE KILLED SOMEONE---
	level.scr_radio[ "tango_down" ]					= "UK_pri_inform_killfirm_generic_s";





//LETS SPLIT UP -----
	//Let�s split up. I'll use the thermal scope and provide overwatch from this ridge.	
	level.scr_radio[ "cliff_pri_splitup" ]					= "cliff_pri_splitup";
	
	//You'll be like a ghost in this blizzard, so the guards won�t see you until you�re very close.	
	level.scr_radio[ "cliff_pri_likeaghost" ]					= "cliff_pri_likeaghost";
	
//YOU'RE IN - PLAN B -----
	//All right, you're in. Head to the left and plant your C4 on a fuel tank. We may need to go to �Plan B� if things go south.	
	level.scr_radio[ "cliff_pri_yourein" ]					= "cliff_pri_yourein";

//TRUCK COMING ----
	//There�s a truck coming! Stay out of sight.	
	level.scr_radio[ "cliff_pri_truckcoming" ]					= "cliff_pri_truckcoming";


//TRUCK BLOWN UP ----
	//Gee, I wonder if they will notice a flaming wreck in the middle of the road�.	
	level.scr_radio[ "cliff_pri_flamingwreck" ]					= "cliff_pri_flamingwreck";
	
	//Stay out of sight - you�ve alerted some guards.	
	level.scr_radio[ "cliff_pri_outofsight" ]					= "cliff_pri_outofsight";


//SILENCER ADVICE ----
	//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
	level.scr_radio[ "cliff_pri_attractattn" ]					= "cliff_pri_attractattn";
	
//SNEAKY PROGRESS	----
	//Pretty sneaky Soap. No one�s been alerted to your presence.	
	level.scr_radio[ "cliff_pri_prettysneaky" ]					= "cliff_pri_prettysneaky";

//GET INTO POSITION FIRST FOUR ----
	//Two tangos in front.	
	level.scr_radio[ "cliff_pri_2tangosfront" ]					= "cliff_pri_2tangosfront";
	
	//Get over here.	
	level.scr_radio[ "cliff_pri_getoverhere" ]					= "cliff_pri_getoverhere";
	level.scr_sound[ "price" ][ "cliff_pri_getoverhere" ]					= "cliff_pri_getoverhere";
	
//BMP DANGER ----
	//That BMP�s got thermal sights � get the hell out of there!	
	level.scr_radio[ "cliff_pri_getoutofthere" ]					= "cliff_pri_getoutofthere";
	
	//Nice work.	
	level.scr_radio[ "cliff_pri_nicework" ]					= "cliff_pri_nicework";
	
//PRICE SNIPES	****
	//I'll take this one.	
	level.scr_radio[ "cliff_pri_takethisone" ]		 = "cliff_pri_takethisone";
	//He's mine.	
	level.scr_radio[ "cliff_pri_hesmine" ]		 = "cliff_pri_hesmine";
	//I've got him.	
	level.scr_radio[ "cliff_pri_ivegothim" ]					= "cliff_pri_ivegothim";
	//This one is mine.	
	level.scr_radio[ "cliff_pri_onesmine" ]					= "cliff_pri_onesmine";
	//I'll take him.	
	level.scr_radio[ "cliff_pri_illtakehim" ]					= "cliff_pri_illtakehim";
	

//PLAYER LATE TO HANGER ****
	//Took the scenic route eh?	
	level.scr_radio[ "cliff_pri_scenicroute" ]					= "cliff_pri_scenicroute";

//TRUCK STOPPED ****
	//Heads up, the truck just stopped.	
	level.scr_radio[ "cliff_pri_headsup" ]					= "cliff_pri_headsup";
	
	//Four tangos just got out and are looking around.	
	level.scr_radio[ "cliff_pri_lookingaround" ]					= "cliff_pri_lookingaround";



//STEALTH BROKEN ****
	//Take cover! They're on to you!	
	level.scr_radio[ "cliff_pri_takecover" ]					= "cliff_pri_takecover";
	
	//You've been spotted take cover!	
	level.scr_radio[ "cliff_pri_beenspotted" ]					= "cliff_pri_beenspotted";
	
	//Get out of there they've found you!	
	level.scr_radio[ "cliff_pri_foundyou" ]					= "cliff_pri_foundyou";
	
	//Heads up! I see tangos coming from multiple directions!	
	level.scr_radio[ "cliff_pri_multipledirections" ]					= "cliff_pri_multipledirections";

	
//STEALTH FAILURE
	//Not very sneaky, Soap.	
	level.scr_radio[ "cliff_pri_notsneaky" ]				 = "cliff_pri_notsneaky";
	
	//This is easier when you don't alert them.	
	level.scr_radio[ "cliff_pri_dontalertthem" ]				 = "cliff_pri_dontalertthem";
	
	//That was sloppy.	
	level.scr_radio[ "cliff_pri_sloppy" ]					= "cliff_pri_sloppy";
	
	//You alerted them.	
	level.scr_radio[ "cliff_pri_alertedthem" ]					= "cliff_pri_alertedthem";
	
	//There is a reason we brought silencers. 	
	level.scr_radio[ "cliff_pri_silencers" ]				 = "cliff_pri_silencers";



//////////////////////////in
	//PRICE: The truck is coming back.
	level.scr_radio[ "cliff_pri_truckcomingback" ]				 = "cliff_pri_truckcomingback";
	//PRICE: The truck is coming.
	level.scr_radio[ "cliff_pri_truckiscoming" ]				 = "cliff_pri_truckiscoming";
	
	                    
	
	//PRICE: They are going back to their positions.
	level.scr_radio[ "cliff_pri_theygoingback" ]				 = "cliff_pri_theygoingback";
	
	//PRICE: You're in the clear, they're returning to their positions.
	level.scr_radio[ "cliff_pri_youreclear" ]				 = "cliff_pri_youreclear";
	
	//PRICE: The rest of them have given up looking for you and are returning to their original positions.
	level.scr_radio[ "cliff_pri_resthavegivenup" ]				 = "cliff_pri_resthavegivenup";
	
	
//////////////////////////in
	//PRICE: Hide! You've alerted one of the guards.
	level.scr_radio[ "cliff_pri_hidealerted" ]				 = "cliff_pri_hidealerted";
	
	
	//PRICE: Stay out of sight - you�ve alerted one of them!
	level.scr_radio[ "cliff_pri_sightalertedone" ]				 = "cliff_pri_sightalertedone";
	
	 
	
	
	
	
	//Keep an eye on your heart beat sensor, good luck.
	level.scr_radio[ "cliff_pri_keepeyeonheart" ]				 = "cliff_pri_keepeyeonheart";	

/////////////////////////////////////////

//This is easier when you do some of the work.	--
	level.scr_sound[ "price" ][ "cliff_pri_somework" ] = "cliff_pri_somework";

//I guess I have to do everything?	--
	level.scr_sound[ "price" ][ "cliff_pri_doeverything" ] = "cliff_pri_doeverything";



//Never mind.	--
	level.scr_radio[ "cliff_pri_nevermind" ]				 = "cliff_pri_nevermind";

//Then again, maybe not.	--
	level.scr_radio[ "cliff_pri_maybenot" ]				 = "cliff_pri_maybenot";



//Use the cover of the storm to enter the base.       --  	
	level.scr_radio[ "cliff_pri_coverofstorm" ]				 = "cliff_pri_coverofstorm";



//Head southeast and plant your C4 at the fueling station. 
	level.scr_radio[ "cliff_pri_yourein_2" ]				 = "cliff_pri_yourein_2";

//We may need to go to �Plan B� if things go south.
	level.scr_radio[ "cliff_pri_yourein_3" ]				 = "cliff_pri_yourein_3";



//Soap, the fueling station is near the northeast corner of the runway.	
	level.scr_radio[ "cliff_pri_necorner" ]				 = "cliff_pri_necorner";

//Soap - search the northeast part of the runway for the fueling station.	
	level.scr_radio[ "cliff_pri_searchntheast" ]				 = "cliff_pri_searchntheast";                                             



//That's the fueling station.	
	level.scr_radio[ "cliff_pri_fuelingstation" ]				 = "cliff_pri_fuelingstation";

//You found it.	
	level.scr_radio[ "cliff_pri_foundit" ]				 = "cliff_pri_foundit";




//I'm headed for the hanger. Get there asap.	
	level.scr_radio[ "cliff_pri_getthereasap" ]				 = "cliff_pri_getthereasap";



//Soap I'm waiting behind the hangars at the southwest corner of the runway.	
	level.scr_radio[ "cliff_pri_behindhangars" ]				 = "cliff_pri_behindhangars";

//Soap, meet me behind the hangers at the southwest corner of the runway.	
	level.scr_radio[ "cliff_pri_meetme" ]				 = "cliff_pri_meetme";



//Brought some friends with you?	
	level.scr_sound[ "price" ][ "cliff_pri_broughtfriends" ]				 = "cliff_pri_broughtfriends";

//Soap, go back to the fueling station and plant your C4.	
	level.scr_radio[ "cliff_pri_goback" ]				 = "cliff_pri_goback";


//////////////////////////in
	// � �On three.�
	level.scr_sound[ "price" ][ "Cliff_pri_onthree" ] = "Cliff_pri_onthree";
	
	// � �One��
	level.scr_sound[ "price" ][ "Cliff_pri_one" ] = "Cliff_pri_one";
	
	
	// � �Two��
	level.scr_sound[ "price" ][ "Cliff_pri_two" ] = "Cliff_pri_two";
	
	
	// � �Three.�
	level.scr_sound[ "price" ][ "Cliff_pri_three" ] = "Cliff_pri_three";
	
	
	//Target down.	
	level.scr_radio[ "UK_pri_inform_killfirm_generic_s" ]		 = "cliff_pri_killfirm";
	
	
	// Kilo Six-One, the primary exfil point is compromised! We�re en route to Bravo using enemy transport! Meet us there! Over!
	level.scr_radio[ "cliff_pri_enroute" ] = "cliff_pri_enroute";

	// Papa Six, this Kilo Six-One, roger that, we�ll see you at Bravo. Out.	
	level.scr_radio[ "cliff_hp1_seeyouatbravo" ] = "cliff_hp1_seeyouatbravo";
	
	// Papa Six, we�re getting close to bingo fuel. What�s your status over?	
	level.scr_radio[ "cliff_hp1_status" ] = "cliff_hp1_status";
	
	// Kilo Six-One, we�re taking heavy fire but we�re almost there! Standby!	
	level.scr_radio[ "cliff_pri_almostthere" ] = "cliff_pri_almostthere";
	
	// Papa Six we have you on visual. Get your ass on board! We�re running on fumes here!	
	level.scr_radio[ "cliff_hp1_fumes" ] = "cliff_hp1_fumes";
	
	//Ok they got the ACS, we're outta here!
	level.scr_radio[ "cliff_crc_gotacs" ] = "cliff_crc_gotacs";

	// Pin the throttle!! Keep going!!	
	level.scr_radio[ "cliff_pri_pinthrottle" ] = "cliff_pri_pinthrottle";
	
	// There�s the chopper! Let�s go!	
	level.scr_radio[ "cliff_pri_thechopper" ] = "cliff_pri_thechopper";
	
	// Watch my back.	
	level.scr_sound[ "price" ][ "cliff_pri_watchmyback" ] = "cliff_pri_watchmyback";
	
	// Go up stairs and look for the DSM.	
	level.scr_sound[ "price" ][ "cliff_pri_goupstairs" ] = "cliff_pri_goupstairs";

	// Soap, take that snowmobile! Let's get the hell out of here!	
	level.scr_sound[ "price" ][ "cliff_pri_takesnowmobile" ] = "cliff_pri_takesnowmobile";
	
	// Soap! Get on that snowmobile let's go!	
	level.scr_sound[ "price" ][ "cliff_pri_snowmobileletsgo" ] = "cliff_pri_snowmobileletsgo";


}	