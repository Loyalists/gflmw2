#include maps\_anim;
#include maps\_slowmo_breach;
#include common_scripts\utility;
#include maps\_utility;
#using_animtree( "generic_human" );
main()
{
	idle_c4_drone_anims();
	friendly_anims();
	anims();
	dialogue();
	rope_anims();
	player_anims();
	submarine_anims();
	blackhawk_anims();
	scuba_gear_anims();
	scuba_gear_prop_anims();
}

idle_c4_drone_anims()
{
//	level.dronedeathanims[ 0 ] = %exposed_death_firing_02;
//	level.dronedeathanims[ 1 ] = %exposed_death;
//	level.dronedeathanims[ 2 ] = %exposed_death_nerve;
//	level.dronedeathanims[ 3 ] = %exposed_death_02;
//	level.dronedeathanims[ 4 ] = %exposed_death_falltoknees_02;
//	level.dronedeathanims[ 5 ] = %exposed_death_falltoknees;
//	level.dronedeathanims[ 6 ] = %exposed_death_nerve;
//	level.dronedeathanims[ 7 ] = %exposed_death_02;
//	level.dronedeathanims[ 8 ] = %exposed_death;
//	level.dronedeathanims[ 9 ] = %exposed_death;
	
}

friendly_anims()
{

	/*-----------------------
	HOSTAGES
	-------------------------*/	
	//level.scr_anim[ "generic" ][ "hostage_chair_idle" ][ 0 ]			= %hostage_chair_idle;
	//level.scr_anim[ "generic" ][ "hostage_chair_idle" ][ 1 ]			= %hostage_chair_twitch;
	//level.scr_anim[ "generic" ][ "hostage_chair_idle" ][ 2 ]			= %hostage_chair_twitch2;

	/*-----------------------
	UNDERWATER
	-------------------------*/	
	level.scr_anim[ "sdv01_pilot" ][ "sdv_ride_in" ]				 = %oilrig_sub_A_disembark_1;
	level.scr_anim[ "sdv01_copilot" ][ "sdv_ride_in" ]				 = %oilrig_sub_A_disembark_2;
	level.scr_anim[ "sdv01_swimmer1" ][ "sdv_ride_in" ]				 = %oilrig_sub_A_disembark_4;

	level.scr_anim[ "sdv02_pilot" ][ "sdv_ride_in" ]				 = %oilrig_sub_B_disembark_1;
	level.scr_anim[ "sdv02_copilot" ][ "sdv_ride_in" ]				 = %oilrig_sub_B_disembark_2;
	level.scr_anim[ "sdv02_swimmer1" ][ "sdv_ride_in" ]				 = %oilrig_sub_B_disembark_3;
	level.scr_anim[ "sdv02_swimmer2" ][ "sdv_ride_in" ]				 = %oilrig_sub_B_disembark_4;
	
	/*-----------------------
	WATER SURFACE
	-------------------------*/	
	level.scr_anim[ "sdv01_pilot" ][ "surface_idle" ][ 0 ]				 = %oilrig_sub_A_idle_1;
	level.scr_anim[ "sdv01_copilot" ][ "surface_idle" ][ 0 ]				 = %oilrig_sub_A_idle_2;
	level.scr_anim[ "sdv01_swimmer1" ][ "surface_idle" ][ 0 ]				 = %oilrig_sub_A_idle_4;

	level.scr_anim[ "sdv02_pilot" ][ "surface_idle" ][ 0 ]				 	= %oilrig_sub_B_idle_1;		//friendly waiting to stealth kill
	level.scr_anim[ "sdv02_copilot" ][ "surface_idle" ][ 0 ]				 = %oilrig_sub_B_idle_2;	
	level.scr_anim[ "sdv02_swimmer1" ][ "surface_idle" ][ 0 ]				 = %oilrig_sub_B_idle_3;	
	level.scr_anim[ "sdv02_swimmer2" ][ "surface_idle" ][ 0 ]				 = %oilrig_sub_B_idle_4;	

	/*-----------------------
	STEALTH KILL
	-------------------------*/	
	level.scr_anim[ "hostile_stealthkill_player" ][ "grate_idle" ][ 0 ]	 	= %oilrig_underwater_guard_2_idle;
	level.scr_anim[ "hostile_stealthkill_friendly" ][ "grate_idle" ][ 0 ]	= %oilrig_underwater_guard_1_idle;
	
	level.scr_anim[ "hostile_stealthkill_player" ][ "stealth_kill" ]		 = %oilrig_underwater_guard_2_death;
	level.scr_anim[ "hostile_stealthkill_friendly" ][ "stealth_kill" ]		 = %oilrig_underwater_guard_1_death;
	level.scr_anim[ "sdv02_pilot" ][ "stealth_kill" ]						 = %oilrig_underwater_kill_1;

	addNotetrack_customFunction( "hostile_stealthkill_player", "blood", maps\oilrig_fx::underwater_bleedout );
	addNotetrack_customFunction( "hostile_stealthkill_player", "splash", maps\oilrig_fx::underwater_struggle );
	addNotetrack_customFunction( "hostile_stealthkill_friendly", "blood", maps\oilrig_fx::underwater_bleedout );
	
	/*-----------------------
	HELP OUT OF WATER
	-------------------------*/	
	level.scr_anim[ "water_helper_01" ][ "surface_helpout" ]				 = %oilrig_helpout_1;
	level.scr_anim[ "water_helper_02" ][ "surface_helpout" ]				 = %oilrig_helpout_2;

	/*-----------------------
	HOSTAGE EVAC ANIMS
	-------------------------*/	
	level.scr_anim[ "manhandle_soldier_walk" ][ "prisoner_manhandle_walk" ]				 = %prisoner_pickup2walk_soldier;
	level.scr_anim[ "manhandle_prisoner_walk" ][ "prisoner_manhandle_walk" ]				 = %prisoner_pickup2walk_prisoner;
	level.scr_anim[ "manhandle_soldier_run" ][ "prisoner_manhandle_run" ]				 = %prisoner_pickup2run_soldier;
	level.scr_anim[ "manhandle_prisoner_run" ][ "prisoner_manhandle_run" ]				 = %prisoner_pickup2run_prisoner;

	/*-----------------------
	CQB
	-------------------------*/	
	level.scr_anim[ "generic" ][ "stand_exposed_wave_move_up" ]				 = %stand_exposed_wave_move_up;

	/*-----------------------
	C4 PLANT
	-------------------------*/	
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_death" ]				= %execution_slamwall_hostage_death;	
	level.scr_anim[ "generic" ][ "run_death_roll" ]									= %run_death_roll;
	
	
	level.scr_anim[ "generic" ][ "C4_plant_start" ]					 = %explosive_plant_knee;
	level.scr_anim[ "generic" ][ "C4_plant" ]						 = %explosive_plant_knee;

	/*-----------------------
	C4 PLANT
	-------------------------*/	
	level.scr_anim[ "generic" ][ "railing_execute_reach" ]			 = %covercrouch_aim5;
	level.scr_anim[ "generic" ][ "railing_execute_idle" ][ 0 ]		 = %covercrouch_aim5;
	level.scr_anim[ "generic" ][ "railing_execute_shoot" ]			 = %covercrouch_aim5;
}

anims()
{
	maps\_props::add_smoking_notetracks( "generic" );
	level.scr_anim[ "generic" ][ "smoking_reach" ]				 = %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				 = %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				 = %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_react" ]				 = %parabolic_leaning_guy_react;

	level.scr_anim[ "generic" ][ "bored_idle_reach" ]			 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 1 ]			 = %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 2 ]			 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "bored_alert" ]				 = %exposed_idle_twitch_v4;// %patrol_bored_2_combat_alarm;

	level.scr_anim[ "generic" ][ "bored_cell_loop" ][ 0 ]		 = %patrol_bored_idle_cellphone;
	
	level.scr_anim[ "generic" ][ "oilrig_balcony_smoke_idle" ][ 0 ]	 = %oilrig_balcony_smoke_idle;
	level.scr_anim[ "generic" ][ "railing_death" ]				 = %oilrig_balcony_death;

	addNotetrack_customFunction( "generic", "detach cig", maps\_props::detach_cig );
	//addNotetrack_customFunction( "generic", "flick", maps\oilrig::XXX );

	level.scr_anim[ "generic" ][ "pronehide_dive" ]				 = %hunted_dive_2_pronehide_v1;
	level.scr_anim[ "generic" ][ "pronehide_idle" ][ 0 ]			 = %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "pronehide_idle_frame" ]		 = %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "prone_2_run_roll" ]			 = %hunted_pronehide_2_stand_v1;


	level.scr_anim[ "generic" ][ "fastrope_fall" ]			 = %fastrope_fall;
	level.scr_anim[ "generic" ][ "oilrig_rappel_over_rail_R" ]	 = %oilrig_rappel_over_rail_R;
	level.scr_anim[ "generic" ][ "oilrig_rappel_2_crouch" ]					 = %oilrig_rappel_2_crouch;
	
	addNotetrack_customFunction( "generic", "over_solid", maps\oilrig::ai_rappel_over_ground_death_anim, "oilrig_rappel_over_rail_R" );
	addNotetrack_customFunction( "generic", "over_solid", maps\oilrig::ai_rappel_over_ground_death_anim, "oilrig_rappel_2_crouch" );
	addNotetrack_customFunction( "generic", "feet_on_ground", maps\oilrig::ai_rappel_reset_death_anim, "oilrig_rappel_over_rail_R" );
	addNotetrack_customFunction( "generic", "feet_on_ground", maps\oilrig::ai_rappel_reset_death_anim, "oilrig_rappel_2_crouch" );
	/*-----------------------
	PATROL
	-------------------------*/	

	level.scr_anim[ "generic" ][ "patrol_walk" ]			 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		 = %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			 = %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			 = %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			 = %patrol_bored_2_walk_180turn;

	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			 = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			 = %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			 = %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			 = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			 = %patrol_bored_twitch_stretch;

	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		 = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	 = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		 = %patrol_bored_idle_cellphone;

	level.scr_anim[ "generic" ][ "patrol_jog" ]				 = %patrol_jog;
	level.scr_anim[ "generic" ][ "combat_jog" ]				 = %combat_jog;
	level.scr_anim[ "generic" ][ "patrol_jog_turn180" ]		 = %patrol_jog_360;

	level.scr_anim[ "generic" ][ "stealth_jog" ]			 = %patrol_jog;
	level.scr_anim[ "generic" ][ "stealth_walk" ]			 = %patrol_bored_patrolwalk;


	// _slowmo_breach anims
	level.scr_anim[ "generic" ][ "breach_react_desk_v1" ] = %breach_react_desk_v1;
	level.scr_anim[ "generic" ][ "breach_chair_reaction_v1" ] = %breach_chair_reaction_v1;
	level.scr_anim[ "generic" ][ "execution_shield_soldier" ] = %execution_shield_soldier;
	level.scr_anim[ "generic" ][ "execution_onknees_soldier" ] = %execution_onknees_soldier;
	level.scr_anim[ "generic" ][ "patrol_bored_react_walkstop" ] = %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v1" ] = %breach_react_blowback_v1;
	level.scr_anim[ "generic" ][ "breach_react_push_guy1" ] = %breach_react_push_guy1;
	level.scr_anim[ "generic" ][ "breach_react_push_guy2" ] = %breach_react_push_guy2;
	level.scr_anim[ "generic" ][ "breach_react_desk_v4" ] = %breach_react_desk_v4;
	level.scr_anim[ "generic" ][ "execution_onknees2_soldier" ] = %execution_onknees2_soldier;
	level.scr_anim[ "generic" ][ "execution_slamwall_soldier" ] = %execution_slamwall_soldier;
	level.scr_anim[ "generic" ][ "execution_knife_soldier" ] = %execution_knife_soldier;
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy2" ] = %breach_react_guntoss_v2_guy2;
	level.scr_anim[ "generic" ][ "breach_react_knife_charge" ] = %breach_react_knife_charge;
	level.scr_anim[ "generic" ][ "breach_react_knife_charge_death" ] = %death_shotgun_back_v1;
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy1" ] = %breach_react_guntoss_v2_guy1;
	level.scr_anim[ "generic" ][ "breach_react_desk_v7" ] = %breach_react_desk_v7;
	level.scr_anim[ "generic" ][ "hostage_stand_fall" ] = %hostage_stand_fall;
	level.scr_anim[ "generic" ][ "hostage_stand_fall_idle" ][ 0 ] = %hostage_knees_idle;
	level.scr_anim[ "generic" ][ "hostage_stand_fall_idle" ][ 1 ] = %hostage_knees_twitch;
	level.scr_anim[ "generic" ][ "hostage_stand_fall_manhandled" ] = %takedown_room1A_hostageA;
	level.scr_anim[ "generic" ][ "hostage_stand_fall_manhandled_idle" ][ 0 ] = %takedown_room1A_hostageA_idle;
	level.scr_anim[ "generic" ][ "hostage_stand_fall_manhandledV2" ] = %takedown_room1B_hostage;
	level.scr_anim[ "generic" ][ "hostage_stand_fall_manhandled_idleV2" ][ 0 ] = %takedown_room1B_hostage_idle;
	level.scr_anim[ "generic" ][ "execution_shield_hostage" ] = %execution_shield_hostage;
	level.scr_anim[ "generic" ][ "execution_shield_hostage_death" ] = %execution_shield_hostage_death;
	level.scr_anim[ "generic" ][ "execution_shield_hostage_survives" ]  = %execution_shield_hostage_survives;
	level.scr_anim[ "generic" ][ "execution_shield_hostage_idle" ][ 0 ]	 = %hostage_knees_idle;
	
	level.scr_anim[ "generic" ][ "execution_onknees_hostage" ] = %execution_onknees_hostage;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_death" ] = %execution_onknees_hostage_death;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_idle" ][ 0 ] = %execution_onknees_hostage_survives;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_manhandled_guarded" ] = %takedown_room1A_hostageB;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_manhandled_guarded_idle" ][ 0 ] = %takedown_room1A_hostageB_idle;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage" ] = %execution_onknees2_hostage;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_survives" ] = %execution_onknees2_hostage_survives;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_death" ] = %execution_onknees2_hostage_death;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_manhandled_guarded" ] = %takedown_room2B_hostageB;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_manhandled_guarded_idle" ][ 0 ] = %takedown_room2B_hostageB_idle;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_manhandled_guardedV2" ] = %takedown_room2A_hostageB;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_manhandled_guarded_idleV2" ][ 0 ] = %takedown_room2A_hostageB_end_idle;
	level.scr_anim[ "generic" ][ "execution_onknees2_hostage_manhandled_guarded_prepare_idleV2" ][ 0 ] = %takedown_room2A_hostageB_start_idle;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage" ] = %execution_slamwall_hostage;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_death" ] = %execution_slamwall_hostage_death;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_idle" ][ 0 ] = %hostage_stand_idle;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_manhandled" ] = %takedown_room2A_hostageA;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_manhandled_idle" ][ 0 ] = %takedown_room2A_hostageA_end_idle;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_manhandled_prepare_idle" ][ 0 ] = %takedown_room2A_hostageA_hide_idle;
	level.scr_anim[ "generic" ][ "execution_slamwall_hostage_manhandled_prepare" ] = %takedown_room2A_hostageA_flee;
	level.scr_anim[ "generic" ][ "execution_knife_hostage" ] = %execution_knife_hostage;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_death" ] = %execution_knife_hostage_death;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_idle" ][ 0 ] = %hostage_knees_idle;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_manhandled" ] = %takedown_room2B_hostageA;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_manhandled_idle" ][ 0 ] = %takedown_room2B_hostageA_idle;
	level.scr_anim[ "generic" ][ "hostage_chair_twitch" ] = %hostage_chair_twitch;
	level.scr_anim[ "generic" ][ "hostage_chair_twitch_idle" ][ 0 ] = %hostage_chair_idle;
	level.scr_anim[ "generic" ][ "hostage_chair_twitch2" ] = %hostage_chair_twitch2;
	level.scr_anim[ "generic" ][ "hostage_chair_twitch2_idle" ][ 0 ] = %hostage_chair_idle;
	level.scr_anim[ "generic" ][ "exposed_idle_reactA" ] = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "hostage_stand_react_front" ] = %hostage_stand_react_front;
	level.scr_anim[ "generic" ][ "hostage_stand_react_front_idle" ][ 0 ] = %hostage_stand_idle;
	level.scr_anim[ "generic" ][ "hostage_stand_react_front_manhandled" ] = %takedown_room1Alt_hostage;
	level.scr_anim[ "generic" ][ "hostage_stand_react_front_manhandled_idle" ][ 0 ] = %takedown_room1Alt_hostage_idle;
	level.scr_anim[ "generic" ][ "takedown_room1B_soldier" ] = %takedown_room1B_soldier;
	level.scr_anim[ "generic" ][ "takedown_room1B_soldier_idle" ][ 0 ] = %takedown_room1B_soldier_idle;
	level.scr_anim[ "generic" ][ "takedown_room1A_soldier" ] = %takedown_room1A_soldier;
	level.scr_anim[ "generic" ][ "takedown_room1A_soldier_idle" ][ 0 ] = %takedown_room1A_soldier_idle;
	level.scr_anim[ "generic" ][ "takedown_room2A_soldier" ] = %takedown_room2A_soldier;
	level.scr_anim[ "generic" ][ "takedown_room2A_soldier_idle" ][ 0 ] = %takedown_room2A_soldier_end_idle;
	level.scr_anim[ "generic" ][ "takedown_room2B_soldier" ] = %takedown_room2B_soldier;
	level.scr_anim[ "generic" ][ "takedown_room2B_soldier_idle" ][ 0 ] = %takedown_room2B_soldier_idle;
	level.scr_anim[ "generic" ][ "takedown_room1Alt_soldier" ] = %takedown_room1Alt_soldier;
	level.scr_anim[ "generic" ][ "takedown_room1Alt_soldier_idle" ][ 0 ] = %takedown_room1Alt_soldier_idle;

}


dialogue()
{
	/*-----------------------
	TO ADD
	-------------------------*/
	//Command 	The sooner we get the hostages, the sooner we can send reinforcements to take care of the SAM sites, over."	oilrig_sbc_sooner	Friendly breaching dialogue (all radio headset)	
	//level.scr_radio[ "oilrig_sbc_sooner" ] = "oilrig_sbc_sooner";

	/*-----------------------
	UNDERWATER SEQUENCE
	-------------------------*/
	//"Sub Command: USS Indiana actual to drydock shelter. We have a go."
	level.scr_radio[ "oilrig_sbc_drydock" ] = "oilrig_sbc_drydock";

	//"Sub Officer: Flooding DDS hangar."
	//level.scr_radio[ "oilrig_sbo_flooding" ] = "oilrig_sbo_flooding";

	//"Sub Officer: DDS hangar flooded. Full pressure."
	level.scr_radio[ "oilrig_sbo_fullpressure" ] = "oilrig_sbo_fullpressure";

	//"Sub Command: Begin deployment."
	level.scr_radio[ "oilrig_sbc_deployment" ] = "oilrig_sbc_deployment";

	//"Sub Officer: Opening DDS hatch, vehicle is in position."
	//level.scr_radio[ "oilrig_sbo_vehicleposition" ] = "oilrig_sbo_vehicleposition";

	//"Sub Officer: Team one SDV is away."
	level.scr_radio[ "oilrig_sbo_tm1away" ] = "oilrig_sbo_tm1away";

	//"Sub Command: Team two SDV en route to objective."
	//level.scr_radio[ "oilrig_sbc_enroute" ] = "oilrig_sbc_enroute";

	//"Sub Command: USS Dallas deploying team two. RV at the objective."
	level.scr_radio[ "oilrig_sbc_ussdallas" ] = "oilrig_sbc_ussdallas";

	//"Sub Command: USS Indiana proceeding to overlook. Good luck."
	//level.scr_radio[ "oilrig_sbc_overlook" ] = "oilrig_sbc_overlook";

	//"Sub Command: Team two at the objective."
	level.scr_radio[ "oilrig_sbc_tm2objective" ] = "oilrig_sbc_tm2objective";

	//"Sub Command: Team one has reached the objective."
	//level.scr_radio[ "oilrig_sbc_tm1objective" ] = "oilrig_sbc_tm1objective";

	//"Sub Officer: Team one in position."
	//level.scr_radio[ "oilrig_sbo_tm1position" ] = "oilrig_sbo_tm1position";

	//"Sub Officer: Team signals A-OK."
	//level.scr_radio[ "oilrig_sbo_teamsignals" ] = "oilrig_sbo_teamsignals";

	//"Sub Officer: Roger that."
	//level.scr_radio[ "oilrig_sbo_rogerthat" ] = "oilrig_sbo_rogerthat";

	//"Sub Officer: Hotel-Six bearing zero-one-niner."
	level.scr_radio[ "oilrig_sbo_zerooneniner" ] = "oilrig_sbo_zerooneniner";

	//"Sub Officer: Hotel-Six depth 26 meters."
	level.scr_radio[ "oilrig_sbo_depth26" ] = "oilrig_sbo_depth26";

	//"Sub Officer: SDV approaching objective. 10 knots."
	//level.scr_radio[ "oilrig_sbo_approaching" ] = "oilrig_sbo_approaching";

	//"Sub Officer: Bearing zero-one-niner, 11 knots."
	//level.scr_radio[ "oilrig_sbo_11knots" ] = "oilrig_sbo_11knots";

	//"Sub Officer: Hotel-Six depth 20 meters."
	level.scr_radio[ "oilrig_sbo_depth20" ] = "oilrig_sbo_depth20";

	//"Sub Officer: Depth 10 meters."
	//level.scr_radio[ "oilrig_sbo_depth10" ] = "oilrig_sbo_depth10";

	/*-----------------------
	INTRO GERMAN CONVERSATION
	-------------------------*/
	//ENEMY COMMAND (German radio): Team one patroling the perimeter. We've got two on the lower deck.
	//level.scr_sound[ "oilrig_enc_lowerdeck" ] = "oilrig_enc_lowerdeck";

	//ENEMY COMMAND (German radio): Switch patrols at 08:00. Teams three, five and seven will return to the crew quarters on deck 3.
	//level.scr_sound[ "oilrig_enc_switchpatrols" ] = "oilrig_enc_switchpatrols";
	
	//level.scr_sound[ "hostile_stealthkill_friendly" ][ "cliff_pri_pubcrawl" ]				 = "cliff_pri_pubcrawl";
	
	//MERC 1 (in German): Those unfiltered pieces of shit will kill you.
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_killyou" ] = "oilrig_mrc1_killyou";
	
	//MERC 1 (in German): Alright, give me one.
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_givemeone" ] = "oilrig_mrc1_givemeone";

	//MERC 2 (in German): Fuck off.
	level.scr_sound[ "hostile_stealthkill_player" ][ "oilrig_mrc2_foff" ] = "oilrig_mrc2_foff";

	//MERC 1 (in German): This sea air makes me sick. Prefered the last job. Private security in a limo all day.
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_limoallday" ] = "oilrig_mrc1_limoallday";

	//MERC 2 (in German): You complain too much. 
	level.scr_sound[ "hostile_stealthkill_player" ][ "oilrig_mrc2_complain" ] = "oilrig_mrc2_complain";

	//MERC 1 (in German): yeah, well, not as much as the Italians. Who hired those lazy fucks anyways? Did you see that one guy the other day? Didn't even know how to clean his gun.
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_theitalians" ] = "oilrig_mrc1_theitalians";

	//MERC 1 (in German): Yeah, too much spent on gear but no clue how to use it.
	level.scr_sound[ "hostile_stealthkill_player" ][ "oilrig_mrc2_noclue" ] = "oilrig_mrc2_noclue";
	
	//You know what they call a cheesburger in Russian?	
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_cheeseburger" ] = "oilrig_mrc1_cheeseburger";
	
	//You've got to be kidding me. You think this is a Tarantino movie or something? 	
	level.scr_sound[ "hostile_stealthkill_player" ][ "oilrig_mrc2_tarantino" ] = "oilrig_mrc2_tarantino";

	//(laughs) Alright, well at least the Russians pay well. I was hesitant to take the job till I saw the bottom line. I don't know where their financing comes from, but I don't really care either. Still...they're pretty damn secretive.	
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_paywell" ] = "oilrig_mrc1_paywell";

	//As long as I get paid, I could care less. They can be as secretive as they like. It's none of my business what their politics are.	
	level.scr_sound[ "hostile_stealthkill_player" ][ "oilrig_mrc2_careless" ] = "oilrig_mrc2_careless";

	//(YAWNS) How much longer until the patrol changes. I've gotta take a piss.	
	level.scr_sound[ "hostile_stealthkill_friendly" ][ "oilrig_mrc1_patrolchange" ] = "oilrig_mrc1_patrolchange";

	//***Merc 1		The Americans have a new kind of scanning device that detects movement. It attaches to their rifles. 		russian - Not in combat, deadpan.	
	level.scr_radio[ "oilrig_mrc3_cheeseburger" ] = "oilrig_mrc3_cheeseburger";

	//***Merc 2		Hmph. Americans and their toys. You can't replace training and fighting spirit with mere gadgets. The new Russian President thinks the same way as the Americans. It's disgraceful.		russian - Conversational, calm, unsuspecting	
	level.scr_radio[ "oilrig_mrc2_tarantino" ] = "oilrig_mrc2_tarantino";

	//***Merc 1		Agreed. But it is still a cause for concern. Makarov is offering a bounty for the capture of one of these devices. 	
	level.scr_radio[ "oilrig_mrc1_paywell" ] = "oilrig_mrc1_paywell";
	
	//***Merc 2		If such a device exists, then we're going to be cannon fodder - they'll kill us before we even realize what's happening.
	level.scr_radio[ "oilrig_mrc2_careless" ] = "oilrig_mrc2_careless";

	//***Merc 1		True, but the metal in this structure supposedly causes interference for this motion detector, which gives us some chance to fight back
	level.scr_radio[ "oilrig_mrc1_patrolchange" ] = "oilrig_mrc1_patrolchange";

	
	/*-----------------------
	INTRO STEALTH KILL DIALOGUE
	-------------------------*/
	//In position. Let's take them out together. On your go.	
	level.scr_radio[ "oilrig_nsl_outtogether_00" ] = "oilrig_nsl_outtogether";
	
	//We'll take them out at the same time...on your go.	
	level.scr_radio[ "oilrig_nsl_outtogether_01" ] = "oilrig_nsl_sametime";
	
	//We'll take them both out...on your go.	
	level.scr_radio[ "oilrig_nsl_outtogether_02" ] = "oilrig_nsl_bothout";
	
	//In position...on your go.	
	level.scr_radio[ "oilrig_nsl_outtogether_03" ] = "oilrig_nsl_inposition";

	/*-----------------------
	INTRO STEALTH KILL FINISHED DIALOGUE
	-------------------------*/
	//SEAL LEADER (radio): Two hostiles down in section 1-alpha. Moving up to section 2.
	level.scr_radio[ "oilrig_nsl_sect1alpha" ] = "oilrig_nsl_sect1alpha";

	//"Sub Command: Roger that, Hotel Six."
	//radio_dialogue( "oilrig_sbc_rogerhtlsix" );
	level.scr_radio[ "oilrig_sbc_rogerhtlsix" ] = "oilrig_sbc_rogerhtlsix";

	//"Navy Seal 1: Got a visual by the railing."
	level.scr_radio[ "oilrig_ns1_visbyrailing" ] = "oilrig_ns1_visbyrailing";

	//SEAL LEADER (radio): Free to engage. Suppressed weapons only.
	level.scr_radio[ "oilrig_nsl_suppweapons" ] = "oilrig_nsl_suppweapons";

	/*-----------------------
	UP THE STAIRS AMPED UP
	-------------------------*/
	//Cpt. MacTavish			Ready weapons.	
	level.scr_radio[ "oilrig_nsl_readyweapons" ] = "oilrig_nsl_readyweapons";
	
	//Cpt. MacTavish			Move up.		stealthy, commanding
	level.scr_radio[ "oilrig_nsl_moveup2" ] = "oilrig_nsl_moveup2";
	
	//Cpt. MacTavish			Keep it tight people.		stealthy, commanding	
	level.scr_radio[ "oilrig_nsl_keepittight" ] = "oilrig_nsl_keepittight";
	
	//Cpt. MacTavish			Eyes open. Watch your sectors.		stealthy, commanding
	level.scr_radio[ "oilrig_nsl_eyesopen" ] = "oilrig_nsl_eyesopen";
		
	//Cpt. MacTavish			Get ready.		stealthy, commanding	
	level.scr_radio[ "oilrig_nsl_getready" ] = "oilrig_nsl_getready";
	
	
	/*-----------------------
	BREACHING DIALOGUE
	-------------------------*/

	//"Sub Command: Civilian hostages hostages at your position, watch your fire."
	//radio_dialogue( "oilrig_sbc_civilhostages" );
	level.scr_radio[ "oilrig_sbc_civilhostages" ] = "oilrig_sbc_civilhostages";

	//SEAL COMMANDER (radio): Roger that. Team one moving to breach.
	//radio_dialogue( "oilrig_nsl_tm1tobreach" );
	level.scr_radio[ "oilrig_nsl_tm1tobreach" ] = "oilrig_nsl_tm1tobreach";

	//SEAL COMMANDER (radio): Get a frame charge on the door. We'll hit the room from both sides.
	//radio_dialogue( "oilrig_nsl_framecharge" );
	level.scr_radio[ "oilrig_nsl_framecharge" ] = "oilrig_nsl_framecharge";

	//"Seal Leader: Get a charge on the door. We'll breach from both sides."
	//radio_dialogue( "oilrig_nsl_chargeondoor" );
	level.scr_radio[ "oilrig_nsl_chargeondoor" ] = "oilrig_nsl_chargeondoor";

	//"Seal Leader: Blow the doors. We'll hit them from both sides."
	//radio_dialogue( "oilrig_nsl_blowdoors" );
	level.scr_radio[ "oilrig_nsl_blowdoors" ] = "oilrig_nsl_blowdoors";

	//"Seal Leader: Get into position."
	level.scr_radio[ "oilrig_nsl_intopostion" ] = "oilrig_nsl_intopostion";





	//SEAL COMMANDER (radio): Get a frame charge on the door. We'll hit the room from both sides.
	//radio_dialogue( "oilrig_nsl_framecharge" );
	level.scr_radio[ "breach_nag_00" ] = "oilrig_nsl_framecharge";

	//"Seal Leader: Get a charge on the door. We'll breach from both sides."
	//radio_dialogue( "oilrig_nsl_chargeondoor" );
	level.scr_radio[ "breach_nag_01" ] = "oilrig_nsl_chargeondoor";

	//"Seal Leader: Blow the doors. We'll hit them from both sides."
	//radio_dialogue( "oilrig_nsl_blowdoors" );
	level.scr_radio[ "breach_nag_02" ] = "oilrig_nsl_blowdoors";

	//"Seal Leader: Get into position."
	level.scr_radio[ "breach_nag_03" ] = "oilrig_nsl_intopostion";
	
	
	
	
	//"Navy Seal 1: In position."
	//radio_dialogue( "oilrig_ns1_inposition" );
	level.scr_radio[ "oilrig_ns1_inposition" ] = "oilrig_ns1_inposition";

	//"Navy Seal 2: In position."
	//radio_dialogue( "oilrig_ns2_inposition" );
	level.scr_radio[ "oilrig_ns2_inposition" ] = "oilrig_ns2_inposition";

	//"Navy Seal 1: Ready to breach."
	//radio_dialogue( "oilrig_ns1_readybreach" );
	level.scr_radio[ "oilrig_ns1_readybreach" ] = "oilrig_ns1_readybreach";

	//"Navy Seal 2: Ready to breach."
	//radio_dialogue( "oilrig_ns2_readybreach" );
	level.scr_radio[ "oilrig_ns2_readybreach" ] = "oilrig_ns2_readybreach";

	//"Navy Seal 1: In position to breach."
	//radio_dialogue( "oilrig_ns1_inposbreach" );
	level.scr_radio[ "oilrig_ns1_inposbreach" ] = "oilrig_ns1_inposbreach";

	//"Navy Seal 2: In position to breach."
	//radio_dialogue( "oilrig_ns2_inposbreach" );
	level.scr_radio[ "oilrig_ns2_inposbreach" ] = "oilrig_ns2_inposbreach";

	//"Navy Seal 1: Breaching."
	//radio_dialogue( "oilrig_ns1_breaching" );
	level.scr_radio[ "oilrig_ns1_breaching" ] = "oilrig_ns1_breaching";

	//"Navy Seal 2: Breaching."
	//radio_dialogue( "oilrig_ns2_breaching" );
	level.scr_radio[ "oilrig_ns2_breaching" ] = "oilrig_ns2_breaching";

	//"Navy Seal 1: Planting charge."
	//radio_dialogue( "oilrig_ns1_plantingcharge" );
	level.scr_radio[ "oilrig_ns1_plantingcharge" ] = "oilrig_ns1_plantingcharge";

	//SEAL 2 (radio): planting charge
	//radio_dialogue( "oilrig_ns2_plantingcharge" );
	level.scr_radio[ "oilrig_ns2_plantingcharge" ] = "oilrig_ns2_plantingcharge";

	//SEAL 1 (radio): planting frame charge
	//radio_dialogue( "oilrig_ns1_plantfrmcharge" );
	level.scr_radio[ "oilrig_ns1_plantfrmcharge" ] = "oilrig_ns1_plantfrmcharge";

	//SEAL 2 (radio): planting frame charge
	//radio_dialogue( "oilrig_ns2_plantfrmcharge" );
	level.scr_radio[ "oilrig_ns2_plantfrmcharge" ] = "oilrig_ns2_plantfrmcharge";

	//"Navy Seal 1: Watch your field of fire."
	//radio_dialogue( "oilrig_ns1_watchfieldfire" );
	level.scr_radio[ "oilrig_ns1_watchfieldfire" ] = "oilrig_ns1_watchfieldfire";

	//"Navy Seal 2: Check your targets. We've got civilians here."
	//radio_dialogue( "oilrig_ns2_checktargets" );
	level.scr_radio[ "oilrig_ns2_checktargets" ] = "oilrig_ns2_checktargets";

	//"Navy Seal 1: On my mark...go!"
	//radio_dialogue( "oilrig_ns1_onmarkgo" );
	level.scr_radio[ "oilrig_ns1_onmarkgo" ] = "oilrig_ns1_onmarkgo";

	//"Navy Seal 1: On my mark..."
	//radio_dialogue( "oilrig_ns1_onmymark" );
	level.scr_radio[ "oilrig_ns1_onmymark" ] = "oilrig_ns1_onmymark";

	//"Navy Seal 1: Go!"
	//radio_dialogue( "oilrig_ns1_go" );
	level.scr_radio[ "oilrig_ns1_go" ] = "oilrig_ns1_go";

	//"Navy Seal 2: On my mark...go!"
	//radio_dialogue( "oilrig_ns2_onmarkgo" );
	level.scr_radio[ "oilrig_ns2_onmarkgo" ] = "oilrig_ns2_onmarkgo";

	//"Navy Seal 2: On my mark..."
	//radio_dialogue( "oilrig_ns2_onmymark" );
	level.scr_radio[ "oilrig_ns2_onmymark" ] = "oilrig_ns2_onmymark";

	//"Navy Seal 2: Go!"
	//radio_dialogue( "oilrig_ns2_go" );
	level.scr_radio[ "oilrig_ns2_go" ] = "oilrig_ns2_go";

	//"Navy Seal 1: Breaching. Watch your fire."
	//radio_dialogue( "oilrig_ns1_breachwatchfire" );
	level.scr_radio[ "oilrig_ns1_breachwatchfire" ] = "oilrig_ns1_breachwatchfire";

	//"Navy Seal 2: Breaching. Check your targets."
	//radio_dialogue( "oilrig_ns2_breachchecktarg" );
	level.scr_radio[ "oilrig_ns2_breachchecktarg" ] = "oilrig_ns2_breachchecktarg";


	//"Ghost: We're clear."
	//radio_dialogue( "oilrig_ns1_wereclear" );
	level.scr_radio[ "oilrig_roomclear_ghost_00" ] = "oilrig_ns1_wereclear";

	//"Ghost: Room clear."
	//radio_dialogue( "oilrig_ns1_roomclear" );
	level.scr_radio[ "oilrig_roomclear_ghost_01" ] = "oilrig_ns1_roomclear";

	//"Ghost: Clear."
	//radio_dialogue( "oilrig_ns1_clear" );
	level.scr_radio[ "oilrig_roomclear_ghost_02" ] = "oilrig_ns1_clear";

	//"Ghost: We're clear."
	//radio_dialogue( "oilrig_ns2_wereclear" );
	level.scr_radio[ "oilrig_roomclear_ghost_03" ] = "oilrig_ns2_wereclear";

	//"Ghost: Room clear."
	//radio_dialogue( "oilrig_ns2_roomclear" );
	level.scr_radio[ "oilrig_roomclear_ghost_04" ] = "oilrig_ns2_roomclear";

	//"Ghost: Clear."
	level.scr_radio[ "oilrig_roomclear_ghost_05" ] = "oilrig_ns2_clear";


	//MacTavish	6	31	We're clear.	
	level.scr_radio[ "oilrig_nsl_wereclear" ] = "oilrig_nsl_wereclear";
	
	//MacTavish	6	32	Room clear.	
	level.scr_radio[ "oilrig_nsl_roomclear" ] = "oilrig_nsl_roomclear";
	
	//MacTavish	6	33	Clear.	
	level.scr_radio[ "oilrig_nsl_clear" ] = "oilrig_nsl_clear";
	

	//"Seal Leader: Precious cargo secured in section 2-echo."
	//radio_dialogue( "oilrig_nsl_preciouscargo" );
	level.scr_radio[ "oilrig_hostsec_00" ] = "oilrig_nsl_preciouscargo";

	//"Seal Leader: Hostages secure in section 2-echo."
	//radio_dialogue( "oilrig_nsl_hostsec" );
	level.scr_radio[ "oilrig_hostsec_01" ] = "oilrig_nsl_hostsec";

	//"Seal Leader: Packages secured in section 2-echo."
	//radio_dialogue( "oilrig_nsl_packsec" );
	//level.scr_radio[ "oilrig_hostsec_02" ] = "oilrig_nsl_packsec";

	//"Sub Command: Roger that Hotel Six, Team 2 will secure and evac, continue your search topside."
	//radio_dialogue( "oilrig_sbc_secandevac" );
	level.scr_radio[ "oilrig_sbc_secandevac" ] = "oilrig_sbc_secandevac";

	//HOSTAGE 1: Thank God you're here. They won't tell us what they want. Speak about 5 different languages between them.
	level.scr_sound[ "generic" ][ "oilrig_hst1_5lang" ] = "oilrig_hst1_5lang";
	level.scr_sound[ "generic" ][ "oilrig_hst1_5lang2" ] = "oilrig_hst1_5lang2";


	/*-----------------------
	NAGS TO MOVE FROM BREACH 1 TO 2
	-------------------------*/
	//***Cpt. MacTavish			All teams move out.			
	//level.scr_radio[ "oilrig_deck2_movenag_00" ] = "oilrig_nsl_allteamsmove";
	
	//***Cpt. MacTavish			Let's go. We're oscar mike - moving to deck 2.			
	//level.scr_radio[ "oilrig_deck2_movenag_00" ] = "oilrig_nsl_oscarmdeck2";

	//***Cpt. MacTavish			Ok, move upstairs. Control - we're advancing to deck two.		stealthy, commanding	
	level.scr_radio[ "oilrig_deck2_movenag_start" ] = "oilrig_nsl_moveupstairs";
	
	//***Cpt. MacTavish			Move up to deck 2 and watch your sectors.			
	level.scr_radio[ "oilrig_deck2_movenag_00" ] = "oilrig_nsl_watchsectors";
	
	//***Cpt. MacTavish			Moving to deck two.		stealthy, commanding	
	level.scr_radio[ "oilrig_deck2_movenag_01" ] = "oilrig_nsl_deck2";
	
	//***Cpt. MacTavish			Let's move - we've got more hostages on the upper decks.		stealthy, commanding	
	level.scr_radio[ "oilrig_deck2_movenag_02" ] = "oilrig_nsl_letsmove";

	/*-----------------------
	MANHANDLER NAGS TO MOVE FROM BREACH 1 TO 2
	-------------------------*/
	//***Robot	Get topside, we got this area covered.	
	//level.scr_radio[ "room1_manhandler_nag_01" ] = "oilrig_ns2_regrouptopside";
	level.scr_radio[ "room1_manhandler_nag_00" ] = "oilrig_ns2_gettopside";

	//***Zach	We've got these hostages covered. Regroup with the rest of the team topside.		
	level.scr_radio[ "room1_manhandler_nag_01" ] = "oilrig_ns2_regrouptopside";

	//***Zach	We got this area covered. Move up to deck 2 with your team.		
	level.scr_radio[ "room1_manhandler_nag_03" ] = "oilrig_ns2_moveup";
	
	//***Robot	4Roach, get moving topside, this area is secure.			
	level.scr_radio[ "room1_manhandler_nag_02" ] = "oilrig_ns2_getmoving";


	/*-----------------------
	MOVING TO OUTER DECKS
	-------------------------*/
	//"Sub Command: Enemy helo patroling the perimeter. Keep a low profile, Hotel Six."
	//radio_dialogue( "oilrig_sbc_lowprofile" );
	level.scr_radio[ "oilrig_sbc_lowprofile" ] = "oilrig_sbc_lowprofile";

	//"Seal Leader: Roger that."
	//radio_dialogue( "oilrig_nsl_rogerthat" );
	level.scr_radio[ "oilrig_nsl_rogerthat" ] = "oilrig_nsl_rogerthat";

	//"Navy Seal 1: Helo approaching. Get down."
	//radio_dialogue( "oilrig_ns1_heloapproach" );
	level.scr_radio[ "oilrig_heloapproach_00" ] = "oilrig_ns1_heloapproach";

	//"Navy Seal 2: Enemy helo. Get down."
	//radio_dialogue( "oilrig_ns2_helogetdown" );
	level.scr_radio[ "oilrig_heloapproach_01" ] = "oilrig_ns2_helogetdown";

	//"Navy Seal 1: Chopper inbound, keep low."
	//radio_dialogue( "oilrig_ns1_chopperinbound" );
	level.scr_radio[ "oilrig_heloapproach_02" ] = "oilrig_ns1_chopperinbound";

	//"Seal Leader: Enemy helo, get out of sight."
	//radio_dialogue( "oilrig_nsl_getouttasight" );
	level.scr_radio[ "oilrig_heloapproach_03" ] = "oilrig_nsl_getouttasight";

	//"Seal Leader: Ok, move."
	//radio_dialogue( "oilrig_nsl_okmove" );
	level.scr_radio[ "dialogue_heli_all_clear_00" ] = "oilrig_nsl_okmove";

	//"Seal Leader: Move."
	//radio_dialogue( "oilrig_nsl_move" );
	level.scr_radio[ "dialogue_heli_all_clear_01" ] = "oilrig_nsl_move";

	//"Seal Leader: All clear, move up."
	//radio_dialogue( "oilrig_nsl_allcealmove" );
	level.scr_radio[ "dialogue_heli_all_clear_02" ] = "oilrig_nsl_allclearmove";

	//"Seal Leader: We've been spotted."
	//radio_dialogue( "oilrig_nsl_beenspotted" );
	level.scr_radio[ "dialogue_heli_spotted_00" ] = "oilrig_nsl_beenspotted";

	//"Seal Leader: We've been compromised."
	//radio_dialogue( "oilrig_nsl_compsomised" );
	level.scr_radio[ "dialogue_heli_spotted_01" ] = "oilrig_nsl_compsomised";

	//"Seal Leader: We've been detected."
	//radio_dialogue( "oilrig_nsl_detected" );
	level.scr_radio[ "dialogue_heli_spotted_03" ] = "oilrig_nsl_detected";

	/*-----------------------
	AMBUSH SEQUENCE
	-------------------------*/

	//"Sub Command: Hotel Six, The remaining hostages are at your position."
	level.scr_radio[ "oilrig_sbc_hostatposition" ] = "oilrig_sbc_hostatposition";

	//"Seal Leader: Copy that."
	//radio_dialogue( "oilrig_nsl_copythat" );
	level.scr_sound[ "soap" ][ "oilrig_nsl_copythat" ] = "oilrig_nsl_copythat";
	level.scr_face[ "soap" ][ "oilrig_nsl_copythat" ] = %oilrig_nsl_copythat;

	//"Seal Leader: Control, all hostages in stronghold secured..."
	//radio_dialogue( "oilrig_nsl_strongholdsec" );
	level.scr_sound[ "soap" ][ "oilrig_nsl_strongholdsec" ] = "oilrig_nsl_strongholdsec";
	level.scr_face[ "soap" ][ "oilrig_nsl_strongholdsec" ] = %oilrig_nsl_strongholdsec;

	//"Navy Seal 1: Sir, I think we're going to have company..."
	//radio_dialogue( "oilrig_ns1_havecompany" );
	level.scr_radio[ "oilrig_ns1_havecompany" ] = "oilrig_ns1_havecompany";

	//ENEMY RADIO: (In German) Maerhoffer, come in. Please respond. (In accented English) Maerhoffer, are you there? Pleae respond. We're sending a team down.
	//radio_dialogue( "oilrig_enc_maerhoffer" );
	level.scr_radio[ "oilrig_enc_maerhoffer" ] = "oilrig_enc_maerhoffer";

	//ENEMY RADIO: (In German) Team 5 this is central, come in. (In accented English) Team 5, this is command, please respond. We're sending a team down to your position.
	//radio_dialogue( "oilrig_enc_team5" );
	level.scr_radio[ "oilrig_enc_team5" ] = "oilrig_enc_team5";

	//"Seal Leader: Alright. Get some C4 on those bodies. We're going loud."
	//radio_dialogue( "oilrig_nsl_goingloud" );
	level.scr_sound[ "soap" ][ "oilrig_nsl_goingloud" ] = "oilrig_nsl_goingloud";
	level.scr_face[ "soap" ][ "oilrig_nsl_goingloud" ] = %oilrig_nsl_goingloud;
	
	//"Seal Leader: Plant C4 on the bodies. The patrol will be here any minute."
	//radio_dialogue( "oilrig_nsl_plantc4" );
	level.scr_radio[ "oilrig_nsl_plantc4" ] = "oilrig_nsl_plantc4";

	//"Seal Leader: Get C4 on those bodies ASAP. We don't have much time."
	//radio_dialogue( "oilrig_nsl_donthavetime" );
	level.scr_radio[ "oilrig_nsl_donthavetime" ] = "oilrig_nsl_donthavetime";

	//"Navy Seal 1: Charges planted. They're in for a surprise when they find these bodies."
	//radio_dialogue( "oilrig_ns1_forasurprise" );
	level.scr_radio[ "oilrig_ns1_forasurprise" ] = "oilrig_ns1_forasurprise";

	//"Navy Seal 2: C4 placed, sir."
	//radio_dialogue( "oilrig_ns2_c4placed" );
	level.scr_radio[ "oilrig_ns2_c4placed" ] = "oilrig_ns2_c4placed";

	//"Seal Leader: Get to an elevated position. We'll ambush them when they discover the bodies."
	//radio_dialogue( "oilrig_nsl_ambushthem" );
	level.scr_radio[ "oilrig_nsl_ambushthem" ] = "oilrig_nsl_ambushthem";


	//"Seal Leader: We've got to set up an ambush. Get to an elevated position and wait."
	//radio_dialogue( "oilrig_nsl_elevatedposwait" );
	level.scr_radio[ "oilrig_nsl_elevatedposwait" ] = "oilrig_nsl_elevatedposwait";

	//"Seal Leader: There's the patrol. Hold fire until they find the bodies."
	level.scr_radio[ "oilrig_nsl_holdfire" ] = "oilrig_nsl_holdfire";

	//"Seal Leader: Standby..."
	level.scr_radio[ "oilrig_nsl_standby1" ] = "oilrig_nsl_standby1";

	//"Seal Leader: Standby..."
	level.scr_radio[ "oilrig_nsl_standby2" ] = "oilrig_nsl_standby2";

	//MERC 3 (IN GERMAN): Alarm! We've got a man down! (IN ACCENTED ENGLISH) Sound the alarm! We've got men down!!!
	level.scr_radio[ "oilrig_mrc3_alarm" ] = "oilrig_mrc3_alarm";
	//level.scr_sound[ "generic" ]["oilrig_mrc3_alarm"] = "oilrig_mrc3_alarm";

	//"Seal Leader: Do it."
	level.scr_radio[ "oilrig_nsl_doit" ] = "oilrig_nsl_doit";


	/*-----------------------
	BALLS OUT START
	-------------------------*/

	//"Seal Leader: Control, this is Hotel Six, all hostages secured, but our cover is blown."
	level.scr_radio[ "oilrig_nsl_coverblown" ] = "oilrig_nsl_coverblown";

	//"Sub Command: Copy that, intel still indicates hostages and possible explosives on the top deck. 
	//radio_dialogue( "oilrig_sbc_possibleexpl" );
	level.scr_radio[ "oilrig_sbc_possibleexpl" ] = "oilrig_sbc_possibleexpl";

	//Sub Command	7	Your team needs to secure that location before we can send in reinforcements to handle the SAM sites, over.	
	level.scr_radio[ "oilrig_sbc_secthatloc" ] = "oilrig_sbc_secthatloc";

	//"Seal Leader: Roger that. Will call in for exfil at LZ bravo."
	level.scr_radio[ "oilrig_nsl_callforexfil" ] = "oilrig_nsl_callforexfil";

	//"Seal Leader: Move up."
	//radio_dialogue( "oilrig_nsl_moveup" );
	level.scr_radio[ "oilrig_nsl_moveup" ] = "oilrig_nsl_moveup";

	//"Seal Leader: Move."
	//radio_dialogue( "oilrig_nsl_move2" );
	level.scr_radio[ "oilrig_nsl_move2" ] = "oilrig_nsl_move2";

	//Cpt. MacTavish			CentCom needs us to take the top deck ASAP so they can send in the Marines. Move.	
	level.scr_radio[ "oilrig_nsl_centcom" ] = "oilrig_nsl_centcom";


	/*-----------------------
	STAIRS TO DECK 2
	-------------------------*/
	//"Sub Command: Hotel Six, hostages from lower decks are being extracted by Team 2. Proceed to the top deck ASAP to secure the rest, over."
	//radio_dialogue( "oilrig_sbc_gettolz" );
	level.scr_radio[ "oilrig_sbc_gettolz" ] = "oilrig_sbc_gettolz";

	//"Seal Leader: Copy that."
	//radio_dialogue( "oilrig_nsl_copythat2" );
	level.scr_radio[ "oilrig_nsl_copythat2" ] = "oilrig_nsl_copythat2";

	/*-----------------------
	HELICPTER ALERT
	-------------------------*/
	//Peasant	7	1	Enemy helicopter! Get down get down!	oilrig_ns1_getdown	Under heavy fire, surprised, shouting	
	level.scr_radio[ "oilrig_ambush_helo_alert_00" ] = "oilrig_ns1_getdown";

	//Cherub	7	2	Enemy helo! Take cover!	oilrig_ns2_enemyhelo	Under heavy fire, surprised, shouting	
	level.scr_radio[ "oilrig_ambush_helo_alert_01" ] = "oilrig_ns2_enemyhelo";

	//Peasant	7	3	Attack heli 12 o'clock, find some cover!	oilrig_ns1_attackheli	Under heavy fire, surprised, shouting
	level.scr_radio[ "oilrig_ambush_helo_alert_02" ] = "oilrig_ns1_attackheli";

	/*-----------------------
	FLANKING DIALOGUE (HALLWAYS/STAIRS)
	-------------------------*/
	//***Cpt. MacTavish			Split up. We can flank through these hallways.	
	level.scr_radio[ "oilrig_nsl_splitup" ] = "oilrig_nsl_splitup";
	
	
	//***Cpt. MacTavish			Fan out and flank them.	
	level.scr_radio[ "oilrig_nsl_outflank" ] = "oilrig_nsl_outflank";
	
	/*-----------------------
	MCTAVISH LEADS THE WAY
	-------------------------*/
	//Cpt. MacTavish			The clock's ticking. We need to get topside and secure any remaining hostages before we call in the Marines.	
	level.scr_radio[ "oilrig_nsl_clocksticking" ] = "oilrig_nsl_clocksticking";
	
	//Cpt. MacTavish  Let's go! Those hostages aren't going to rescue themselves.	
	level.scr_radio[ "oilrig_nsl_rescuethemselves" ] = "oilrig_nsl_rescuethemselves";

	/*-----------------------
	HELICOPTER NAGS (WITHOUT ROCKET)
	-------------------------*/
	//Seal Leader			Find some heavy ordinance to take down that bird.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_00" ] = "oilrig_nsl_takeoutbird1";
	
	//Seal Leader			Take out that chopper. Look for some rockets.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_01" ] = "oilrig_nsl_takeoutbird2";
	
	//Seal Leader			That helo is pinning us down. Take it out with some rockets	
	level.scr_radio[ "oilrig_nsl_takeoutbird_02" ] = "oilrig_nsl_takeoutbird3";
	
	//Seal Leader			We're getting shredded by that Littlebird. Look for some RPGs or rockets and take it down.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_03" ] = "oilrig_nsl_takeoutbird4";
	
	//Seal Leader			We've gotta neutralize that Littlebird. Keep an eye out for any heavy artillery and take it out.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_04" ] = "oilrig_nsl_takeoutbird5";

	/*-----------------------
	HELICOPTER NAGS (WITH ROCKET)
	-------------------------*/
	//Bring down that Littlebird, it's got us pinned.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_withrocket_00" ] = "oilrig_nsl_takeoutbird6";
	
	//Take out that helo, use your heavy weapons.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_withrocket_01" ] = "oilrig_nsl_takeoutbird7";
	
	//That helo is killing us, take it down.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_withrocket_02" ] = "oilrig_nsl_takeoutbird8";
	
	//I want heavy weapons fire on that chopper NOW.	
	level.scr_radio[ "oilrig_nsl_takeoutbird_withrocket_03" ] = "oilrig_nsl_takeoutbird9";

	/*-----------------------
	FRIENDLIES FIRING MISSILES
	-------------------------*/
	//Firing AT4.	
	level.scr_radio[ "oilrig_ns2_fireat4_00" ] = "oilrig_ns2_fireat4";

	//Firing missile.	
	level.scr_radio[ "oilrig_ns2_fireat4_01" ] = "oilrig_ns3_firemissile";

	//I can't get a clear shot.	
	level.scr_radio[ "oilrig_ns2_fireat4_02" ] = "oilrig_ns2_clearshot";

	/*-----------------------
	THERMAL
	-------------------------*/
	//Cpt. MacTavish	All teams be advised: these guys are a step up - they're using thermal optics to see through the smoke.
	level.scr_radio[ "oilrig_use_thermal_00" ] = "oilrig_nsl_seethrusmoke";

	//Cpt. MacTavish	These guys have thermal optics. Stay clear of the smoke.	oilrig_nsl_gettarget	tense, aggressive, breathing, under fire	
	level.scr_radio[ "oilrig_use_thermal_01" ] = "oilrig_nsl_gettarget";
	
	//Cpt. MacTavish	If you've got thermal sights, now would be a good time! 	oilrig_nsl_pickoff	tense, aggressive, under fire, a bit sarcastic	
	level.scr_radio[ "oilrig_find_thermal_00" ] = "oilrig_nsl_pickoff";
	
	//Enemies are using thermal optics...Switching to thermal scope�
	level.scr_radio[ "oilrig_find_thermal_01" ] = "oilrig_ns3_switching";

	/*-----------------------
	APPROACHING DECK 3 DERRICK ROOM
	-------------------------*/
	//Sub Command			Hotel Six, be advised, hostages have been confirmed at your location along with possible explosives, over.		Intense, military orders	
	level.scr_radio[ "oilrig_sbc_hostconfirmed" ] = "oilrig_sbc_hostconfirmed";
	
	//Cpt. MacTavish			Copy that. All teams check your fire - we don't know what's behind these doors.		Intense, military orders	
	level.scr_radio[ "oilrig_nsl_behinddoors" ] = "oilrig_nsl_behinddoors";


	/*-----------------------
	HELICOPTER ATTABOYS
	-------------------------*/
	//Robot			Nice shooting Roach.	oilrig_ns3_tacoman	Calm	
	level.scr_radio[ "oilrig_heli_grats_00" ] = "oilrig_ns2_tacoman";
	
	//Cherub			Nice shot, Roach.	oilrig_ns2_tacoman	Calm	
	level.scr_radio[ "oilrig_heli_grats_01" ] = "oilrig_ns3_tacoman";
	
	//Seal 2	Enemy helo down. Good shot.	
	level.scr_radio[ "oilrig_heli_grats_02" ] = "oilrig_ns2_goodshot";
	
	//Seal 3	Littlebird has been neutralized.	
	level.scr_radio[ "oilrig_heli_grats_03" ] = "oilrig_ns3_lbneutralized";
	
	//Seal 2	Nice work.	
	level.scr_radio[ "oilrig_heli_grats_04" ] = "oilrig_ns2_nicework";
	
	//Seal 3	That helo is history. Nice shot.	
	level.scr_radio[ "oilrig_heli_grats_05" ] = "oilrig_ns3_niceshot";


	/*-----------------------
	FUEL TANKS
	-------------------------*/
	//XXX TO IMPLEMENT
	//Aim for those fuel tanks.	
	level.scr_radio[ "oilrig_fueltanks_00" ] = "oilrig_ns3_aimfueltanks";
	
	//XXX TO IMPLEMENT
	//Shoot the fuel tanks.	
	level.scr_radio[ "oilrig_fueltanks_01" ] = "oilrig_ns2_shoottanks";
	
	//XXX TO IMPLEMENT
	//Aim for the fuel storage tanks.	
	level.scr_radio[ "oilrig_fueltanks_02" ] = "oilrig_ns3_aimfuelstorage";
	
	//XXX TO IMPLEMENT
	//Put some fire on those fuel storage tanks.	
	level.scr_radio[ "oilrig_fueltanks_03" ] = "oilrig_nsl_firefuelstorage";

	/*-----------------------
	ENEMY POPPING SMOKE
	-------------------------*/
//	//Seal 2 They're popping smoke.	oilrig_ns2_popsmoke
	level.scr_radio[ "oilrig_enemy_smoke_00" ] = "oilrig_ns2_popsmoke";
//	
//	//Seal 2 Smokescreen.	
	level.scr_radio[ "oilrig_enemy_smoke_01" ] = "oilrig_ns2_smokescreen";
//
//	//Seal 3 Enemy is popping smoke.	
	level.scr_radio[ "oilrig_enemy_smoke_02" ] = "oilrig_ns3_enempop";
//	
//	//Seal 3 They're throwing up a smokescreen.	
	level.scr_radio[ "oilrig_enemy_smoke_03" ] = "oilrig_ns3_smokescreen";

//	//Seal 2 Hostiles are popping smoke.	
	level.scr_radio[ "oilrig_enemy_smoke_04" ] = "oilrig_ns2_hostpopsmoke";


	/*-----------------------
	END OF LEVEL
	-------------------------*/
	//***Cpt. MacTavish			Control, all hostages have been secured. I repeat - all hostages secured. Proceeding to LZ Bravo, over.	
	level.scr_radio[ "oilrig_nsl_allhostsec" ] = "oilrig_nsl_allhostsec";
	
	//***Sub Command			Good job, Hotel Six. Marine reinforcements are inserting now to dismantle the SAM sites. Get your team ready for phase two of the operation. Out.	
	level.scr_radio[ "oilrig_sbc_phase2" ] = "oilrig_sbc_phase2";

	/*-----------------------
	RADIO FLAVOR
	-------------------------*/

	//***Marine HQ			Hunter Two-Two, this is Punisher Actual. GOPLAT secure. All EOD teams are cleared for landing.
	level.scr_radio[ "oilrig_rmv_goplat" ] = "oilrig_rmv_goplat";
	
	//***Marine 1			Roger Punisher, Hunter Two-Two copies all.		military monotone, background flavor dialogue	
	level.scr_radio[ "oilrig_gm1_copies" ] = "oilrig_gm1_copies";
	
	//***F-15 Pilot			Punisher this is Phoenix One-One, flight of two F-15s en route to grid 257221 for SEAD mission, requesting sitrep over
	level.scr_radio[ "oilrig_f15_twof15s" ] = "oilrig_f15_twof15s";
	
	//***Marine HQ			Phoenix One-One, Punisher. Blue sky, I repeat blue sky. Come to heading two-four-zero and continue on course to target area. Good hunting. Over.
	level.scr_radio[ "oilrig_rmv_bluesky" ] = "oilrig_rmv_bluesky";
	
	//***F-15 Pilot			Phoenix One-One copies. Out.
	level.scr_radio[ "oilrig_f15_copies" ] = "oilrig_f15_copies";
	
	//***Marine HQ			Punisher to all flights in vicinity of grid 255202, local airspace is secure. I repeat, local airspace is secure. Proceed on course to target area along Route November Two.
	level.scr_radio[ "oilrig_rmv_localairspace" ] = "oilrig_rmv_localairspace";

	//***Marine 1			Punisher this Hunter Actual. Hunter Two-Two is moving to secure the SAM site at the southwest corner of main deck. Hunter Two-Three is proceeding towards the derrick building to disarm the explosives.
	level.scr_radio[ "oilrig_gm1_hunteractual" ] = "oilrig_gm1_hunteractual";
	
	//***Marine HQ			Punisher copies all. We have eyes on two-two. They are arriving at the southwest SAM site� standby� standby�Site is secure, repeat site is secure.
	level.scr_radio[ "oilrig_rmv_standby" ] = "oilrig_rmv_standby";
	
	//***Marine HQ			Punisher Actual to all strike teams - all SAM sites neutralized, repeat, all SAM sites have been neutralized. Blue sky in effect.
	level.scr_radio[ "oilrig_rmv_samsitesneut" ] = "oilrig_rmv_samsitesneut";

	/*-----------------------
	MARINES SECURING SITES
	-------------------------*/
	//Marine 1			I want these SAMs secure in five! Let's go! Move move!
	level.scr_sound[ "oilrig_gm1_samssecure" ] = "oilrig_gm1_samssecure";
	
	/*-----------------------
	MERC BREACH DIALOGUE
	-------------------------*/
	//Merc 3	KILL THE HOSTAGES!!!
	level.scr_sound[ "oilrig_mrc_killhostages_room_100_00" ] = "oilrig_mrc3_killhostages2";
	
	//Merc 2 INTRUDERS!!!! FIRE!!!	
	level.scr_sound[ "oilrig_mrc_killhostages_room_100_01" ] = "oilrig_mrc2_intruders";

	//Merc 4 EXECUTE THEM! KILL THEM ALL!
	level.scr_sound[ "oilrig_mrc_killhostages_room_200_00" ] = "oilrig_mrc4_executethem";
	
	//Merc 1 KILL THEM!!!	
	level.scr_sound[ "oilrig_mrc_killhostages_room_200_01" ] = "oilrig_mrc1_killthem";

	/*-----------------------
	MERC AMBIENT COMM CHATTER
	-------------------------*/
	//moving in
	level.scr_sound[ "oilrig_merc_chatter_00" ] = "oilrig_mrc1_movingin";
	
	//watch my back
	level.scr_sound[ "oilrig_merc_chatter_01" ] = "oilrig_mrc1_watchmyback";
	
	//team is moving in
	level.scr_sound[ "oilrig_merc_chatter_02" ] = "oilrig_mrc1_teammoving";
	
	//standby
	level.scr_sound[ "oilrig_merc_chatter_03" ] = "oilrig_mrc1_standby";
	
	//on me
	level.scr_sound[ "oilrig_merc_chatter_04" ] = "oilrig_mrc1_onme";
	
	//take point
	level.scr_sound[ "oilrig_merc_chatter_05" ] = "oilrig_mrc1_takepoint";
	
	//watch your corners
	level.scr_sound[ "oilrig_merc_chatter_06" ] = "oilrig_mrc1_watchcorners";

	//Moving in.	
	
	level.scr_sound[ "oilrig_merc_chatter_07" ] = "oilrig_mrc2_movingin";
	
	//Watch my back.	
	level.scr_sound[ "oilrig_merc_chatter_08" ] = "oilrig_mrc2_watchmyback";

	//Team is moving in.
	level.scr_sound[ "oilrig_merc_chatter_09" ] = "oilrig_mrc2_teammoving";

	//Standby.	
	level.scr_sound[ "oilrig_merc_chatter_10" ] = "oilrig_mrc2_standby";

	//On me.	
	level.scr_sound[ "oilrig_merc_chatter_11" ] = "oilrig_mrc2_onme";
	
	//Take point.	
	level.scr_sound[ "oilrig_merc_chatter_12" ] = "oilrig_mrc2_takepoint";
	
	//Watch your corners.	
	level.scr_sound[ "oilrig_merc_chatter_13" ] = "oilrig_mrc2_watchcorners";
	
	//Moving in.	
	level.scr_sound[ "oilrig_merc_chatter_14" ] = "oilrig_mrc3_movingin";
	
	//Watch my back.	
	level.scr_sound[ "oilrig_merc_chatter_15" ] = "oilrig_mrc3_watchmyback";
	
	//Team is moving in.	
	level.scr_sound[ "oilrig_merc_chatter_16" ] = "oilrig_mrc3_teammoving";
	
	//Standby.	
	level.scr_sound[ "oilrig_merc_chatter_17" ] = "oilrig_mrc3_standby";
	
	//On me.	
	level.scr_sound[ "oilrig_merc_chatter_18" ] = "oilrig_mrc3_onme";
	
	//Take point.	
	level.scr_sound[ "oilrig_merc_chatter_19" ] = "oilrig_mrc3_takepoint";
	
	//Watch your corners.	
	level.scr_sound[ "oilrig_merc_chatter_20" ] = "oilrig_mrc3_watchcorners";
	
	
	
	
	/*-----------------------
	NOT USED
	-------------------------*/
//	Peasant	11	"In position."	oilrig_ns1_inposition	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_INPOSITION
//	Cherub	12	"In position."	oilrig_ns2_inposition	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_INPOSITION
//	Peasant	"Ready to breach."	oilrig_ns1_readybreach	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_READYBREACH
//	Cherub	1"Ready to breach."	oilrig_ns2_readybreach	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_READYBREACH
//	Peasant	15	"In position for breach."	oilrig_ns1_inposbreach	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_INPOSBREACH
//	Cherub	1"In position for breach."	oilrig_ns2_inposbreach	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_INPOSBREACH
//	4Peasant	"Breaching."	oilrig_ns1_breaching	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_BREACHING
//	Cherub	18	"Breaching."	oilrig_ns2_breaching	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_BREACHING
//	Peasant	1"Planting charge."	oilrig_ns1_plantingcharge	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_PLANTINGCHARGE
//	Cherub	20	"Planting charge."	oilrig_ns2_plantingcharge	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_PLANTINGCHARGE
//	Peasant	21	"Planting frame charge."	oilrig_ns1_plantfrmcharge	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_PLANTFRMCHARGE
//	Cherub	22	"Planting frame charge."	oilrig_ns2_plantfrmcharge	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_PLANTFRMCHARGE
//	Peasant	23	"Watch your field of fire."	oilrig_ns1_watchfieldfire	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_WATCHFIELDFIRE
//	Cherub	2"Check your targets. We've got civilians here."	oilrig_ns2_checktargets	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_CHECKTARGETS
//	Peasant	25	"On my mark...go!"	oilrig_ns1_onmarkgo	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_ONMARKGO
//	Peasant	2"On my mark..."	oilrig_ns1_onmymark	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_ONMYMARK
//	Peasant	27	"Go!"	oilrig_ns1_go	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_GO
//	Cherub	28	"On my mark...go!"	oilrig_ns2_onmarkgo	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_ONMARKGO
//	Cherub	2"On my mark..."	oilrig_ns2_onmymark	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_ONMYMARK
//	Cherub	"Go!"	oilrig_ns2_go	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_GO
//	5Peasant	"Breaching. Watch your fire."	oilrig_ns1_breachwatchfire	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS1_BREACHWATCHFIRE
//	Cherub	"Breaching. Check your targets."	oilrig_ns2_breachchecktarg	Friendly breaching dialogue (all radio headset)	SUBTITLE_OILRIG_NS2_BREACHCHECKTARG


}

#using_animtree( "player" );
player_anims()
{
	//the animtree to use with the invisible model with animname "player_rig"
	level.scr_animtree[ "player_rig" ]	 = #animtree;
	//the invisible model with the animname "player_rig" that the anims will be played on
	level.scr_model[ "player_rig" ]		 = "ch_viewhands_player_gk_ar15";

	//animations that will be played by the player (actually played by an invisible model the player is linked to)
	
	level.scr_anim[ "player_rig" ][ "underwater_player_start" ]		= %oilrig_sub_A_disembark_player;
	level.scr_anim[ "player_rig" ][ "player_stealth_kill" ]			= %oilrig_underwater_kill_player;

	addNotetrack_attach( "player_rig", "knife", "weapon_parabolic_knife", "tag_weapon_right", "player_stealth_kill" );
	addNotetrack_detach( "player_rig", "putback", "weapon_parabolic_knife", "tag_weapon_right", "player_stealth_kill" );

	addNotetrack_customFunction( "player_rig", "throat", maps\oilrig_fx::knife_blood );
	addNotetrack_customFunction( "player_rig", "", maps\oilrig_fx::playerDrips_left );
	addNotetrack_customFunction( "player_rig", "drips_right", maps\oilrig_fx::playerDrips_right );
	
	level.scr_anim[ "player_rig" ][ "player_evac" ]				 = %blackout_bh_evac_player;
	//level.scr_anim[ "player_rig" ][ "underwater_player_start" ]	 = %oilrig_sub_A_idle_player;
	
	//level.scr_anim[ "player_rig" ][ "underwater_player_idle" ][ 0 ]	 = %oilrig_sub_A_idle_player;
	//level.scr_anim[ "player_rig" ][ "underwater_player_disembark" ]	 = %oilrig_sub_A_disembark_player;
}

#using_animtree( "vehicles" );
submarine_anims()
{
	level.scr_anim[ "submarine_01" ][ "intro_sequence" ]	= %oilrig_sub_1;
	level.scr_anim[ "submarine_02" ][ "intro_sequence" ]	= %oilrig_sub_2;
	level.scr_anim[ "sdv_01" ][ "intro_sequence" ]			= %oilrig_SDV_1;
	level.scr_anim[ "sdv_02" ][ "intro_sequence" ]			= %oilrig_SDV_2;
	
	level.scr_animtree[ "submarine_01" ] 					= #animtree;
	level.scr_animtree[ "submarine_02" ] 					= #animtree;
	level.scr_animtree[ "sdv_01" ] 							= #animtree;
	level.scr_animtree[ "sdv_02" ] 							= #animtree;
}

#using_animtree( "vehicles" );
blackhawk_anims()
{
	level.scr_anim[ "blackhawk" ][ "idle" ][ 0 ] 				 = %blackout_bh_evac_heli_idle;
	level.scr_anim[ "blackhawk" ][ "landing" ] 					 = %blackout_bh_evac_heli_land;
	level.scr_anim[ "blackhawk" ][ "take_off" ] 				 = %blackout_bh_evac_heli_takeoff;
	level.scr_anim[ "blackhawk" ][ "rotors" ] 					 = %bh_rotors;
	level.scr_animtree[ "blackhawk" ] 							 = #animtree;
}

#using_animtree( "generic_human" );
scuba_gear_anims()
{
	/*-----------------------
	GEAR REMOVAL
	-------------------------*/	
	level.scr_anim[ "generic" ][ "oilrig_seal_surface_fins_off" ]				= %oilrig_seal_surface_fins_off;
	level.scr_anim[ "generic" ][ "oilrig_seal_surface_mask_off" ]				= %oilrig_seal_surface_mask_off;
	level.scr_anim[ "generic" ][ "oilrig_seal_surface_rebreather_off_guy1" ]	= %oilrig_seal_surface_rebreather_off_guy1;
	level.scr_anim[ "generic" ][ "oilrig_seal_surface_rebreather_off_guy2" ]	= %oilrig_seal_surface_rebreather_off_guy2;
}

	
#using_animtree( "script_model" );
scuba_gear_prop_anims()
{
	//prop for anim oilrig_seal_surface_fins_off
	level.scr_animtree[ "fins_off_oilrig_seal_surface_fins_off" ] 										= #animtree;	
	level.scr_anim[ "fins_off_oilrig_seal_surface_fins_off" ][ "oilrig_seal_surface_fins_off_prop" ]	= %oilrig_seal_surface_fins_off_prop;
	level.scr_model[ "fins_off_oilrig_seal_surface_fins_off" ] 											= "prop_seal_udt_flippers";
	
	//prop for anim oilrig_seal_surface_mask_off
	level.scr_animtree[ "mask_off_oilrig_seal_surface_mask_off" ] 										= #animtree;	
	level.scr_anim[ "mask_off_oilrig_seal_surface_mask_off" ][ "oilrig_seal_surface_mask_off_prop" ]	= %oilrig_seal_surface_mask_off_prop;
	level.scr_model[ "mask_off_oilrig_seal_surface_mask_off" ] 											= "prop_seal_udt_goggles";
	
	//prop for anim oilrig_seal_surface_rebreather_off_guy1
	level.scr_animtree[ "rebreather_off_oilrig_seal_surface_rebreather_off_guy1" ] 													= #animtree;	
	level.scr_anim[ "rebreather_off_oilrig_seal_surface_rebreather_off_guy1" ][ "oilrig_seal_surface_rebreather_off_guy1_prop" ]	= %oilrig_seal_surface_rebreather_off_guy1_prop;
	level.scr_model[ "rebreather_off_oilrig_seal_surface_rebreather_off_guy1" ] 													= "prop_seal_udt_draeger";

	//prop for anim oilrig_seal_surface_rebreather_off_guy2
	level.scr_animtree[ "rebreather_off_oilrig_seal_surface_rebreather_off_guy2" ] 													= #animtree;	
	level.scr_anim[ "rebreather_off_oilrig_seal_surface_rebreather_off_guy2" ][ "oilrig_seal_surface_rebreather_off_guy2_prop" ]	= %oilrig_seal_surface_rebreather_off_guy2_prop;
	level.scr_model[ "rebreather_off_oilrig_seal_surface_rebreather_off_guy2" ] 													= "prop_seal_udt_draeger";
	

}
scuba_gear_removal( sAnimName, sAnimScene, eNodeEntity, flagName )
{
	//Call when cooresponding AI animation is called
	//example: thread maps\oilrig_anim::scuba_gear_removal( "fins_off_oilrig_seal_surface_fins_off", "oilrig_seal_surface_fins_off_prop", level.eNodeIntroDuplicate, "player_ready_to_be_helped_from_water" );
	propModel = spawn_anim_model( sAnimName );
	propModel hide();
	eNodeEntity anim_first_frame_solo( propModel, sAnimScene );
	flag_wait( flagName );
	propModel show();
	eNodeEntity anim_single_solo( propModel, sAnimScene );
}

#using_animtree( "script_model" );
rope_anims()
{
	level.scr_animtree[ "rope" ] 										= #animtree;	
	level.scr_anim[ "rope" ][ "oilrig_rappelrope_2_crouch" ]	 = %oilrig_rappelrope_2_crouch;
	level.scr_anim[ "rope" ][ "oilrig_rappelrope_over_rail_R" ]	 = %oilrig_rappelrope_over_rail_R;
}
