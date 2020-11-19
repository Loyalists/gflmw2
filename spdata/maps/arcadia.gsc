#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\arcadia_code;
#include maps\arcadia_stryker;
#using_animtree( "generic_human" );

main()
{
	destructible_volumes = getentarray( "volume_second_half", "targetname" );
	mask_destructibles_in_volumes( destructible_volumes );
	mask_interactives_in_volumes( destructible_volumes );
	
	default_start( ::startStreet );
	add_start( "street", ::startStreet );
	add_start( "checkpoint", ::startCheckpoint );
	add_start( "golf", ::startGolf );
	add_start( "crash", ::startCrash );
	
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.2 );
	setsaveddvar( "r_lightGridContrast", 0 );
	setsaveddvar( "sm_sunShadowScale", 0.7 );
	
	precacheString( &"ARCADIA_OBJECTIVE_AA_GUNS" );
	precacheString( &"ARCADIA_OBJECTIVE_BROOKMERE" );
	precacheString( &"ARCADIA_OBJECTIVE_INTEL" );
	precacheString( &"ARCADIA_LASER_HINT" );
	precacheString( &"ARCADIA_LASER_HINT_GOLFCOURSE" );
	precacheString( &"ARCADIA_PICK_UP_BRIEFCASE_HINT" );
	
	precacheShader( "dpad_laser_designator" );
	precacheShader( "black" );
	
	precacheModel( "vehicle_zpu4_burn" );
	precacheModel( "cs_vodkabottle01" );
	precacheModel( "electronics_camera_pointandshoot_animated" );
	precacheModel( "com_metal_briefcase_opened_obj" );
	
	precacheRumble( "arcadia_artillery_rumble" );
	
	setDvarIfUninitialized( "arcadia_debug_stryker", "0" );
	
	precacheItem( "rpg_straight" );
	
	precache_masked_destructibles();
	
	add_earthquake( "b2bomb", 0.5, 0.5, 2000 );
	
	maps\arcadia_fx::main();
	maps\arcadia_precache::main();
	maps\createart\arcadia_art::main();
	maps\_load::main();
	maps\arcadia_anim::main();
	maps\_drone_ai::init();
	common_scripts\_sentry::main();
	
	maps\_compass::setupMiniMap("compass_map_arcadia");
	
	thread maps\arcadia_amb::main();
	
	flag_init( "used_laser" );
	flag_init( "used_laser_golf" );
	flag_init( "laser_hint_print" );
	flag_init( "stealth_bombed_0" );
	flag_init( "stealth_bombed_1" );
	flag_init( "lazed_targets_0" );
	flag_init( "lazed_targets_1" );
	flag_init( "golfcourse_vehicles_dead" );
	flag_init( "objective_laze_golfcourse" );
	flag_init( "foley_in_panic_room" );
	flag_init( "picked_up_briefcase" );
	flag_init( "examine_tats" );
	flag_init( "player_can_pick_up_briefcase" );
	flag_init( "end_dialog_done" );
	flag_init( "foley_leaves_panic_room" );
	flag_init( "disable_stryker_dialog" );
	
	//--------------------------------
	// Friendlies and Friendly Respawn
	//--------------------------------
	
	level.foley = getent( "foley", "script_noteworthy" );
	assert( isAlive( level.foley ) );
	level.foley.animname = "foley";
	level.foley magic_bullet_shield();
	level.foley make_hero();
	
	level.dunn = getent( "dunn", "script_noteworthy" );
	assert( isAlive( level.dunn ) );
	level.dunn.animname = "dunn";
	level.dunn magic_bullet_shield();
	level.dunn make_hero();
	
	friends = getaiarray( "allies" );
	array_thread( friends, ::ai_avoid_stryker );
	friends = array_remove_array( friends, get_heroes() );
	
	level.friendly_startup_thread = ::ai_avoid_stryker;
	flag_set( "respawn_friendlies" );
	set_empty_promotion_order( "r" );
	set_empty_promotion_order( "b" );
	array_thread( friends, ::replace_on_death );
	
	//--------------------------------
	// spawners with script_parameters get processed on spawn
	//--------------------------------
	all_axis_spawners = getspawnerteamarray( "axis" );
	script_parameter_spawners = [];
	foreach( spawner in all_axis_spawners )
	{
		if ( !isdefined( spawner.script_parameters ) )
			continue;
		script_parameter_spawners[ script_parameter_spawners.size ] = spawner;
	}
	array_spawn_function( script_parameter_spawners, ::process_ai_script_parameters );
	
	//--------------------------------
	// Spawn Stryker vehicle
	//--------------------------------
	level.stryker = spawn_vehicle_from_targetname_and_drive( "stryker" );
	//level.stryker.veh_pathtype = "follow";
	level.stryker.vehicle_stays_alive = true;
	level.stryker vehPhys_DisableCrashing();
	level.stryker.damageIsFromPlayer = true;
	setup_stryker_modes();
	level.stryker.lastTarget = level.stryker;
	level.stryker thread stryker_setmode_ai();
	level.stryker thread stryker_laser_reminder_dialog();
	level.stryker thread stryker_death_wait();
	level.stryker thread stryker_dialog();
	level.stryker thread stryker_laser_reminder_dialog();
	level.stryker thread stryker_damage_monitor();
	level.stryker thread stryker_threats_eliminated_dialog_1();
	level.stryker thread stryker_threats_eliminated_dialog_2();
	level.stryker setVehicleLookAtText( "Honey Badger", &"" );
	level.stryker.missileAttractor = spawn( "script_origin", level.stryker.origin + ( 0, 0, 70 ) );
	level.stryker.missileAttractor LinkTo( level.stryker );
	missile_CreateAttractorEnt( level.stryker.missileAttractor, 10000, 3000 );
	thread stryker_run_over_player_monitor();
	
	level.stealth_bombed_target[ 0 ] = false;
	level.stealth_bombed_target[ 1 ] = false;
	
	set_cull_dist( 9000 );
	
	//--------------------------------
	// Array / Spawn threads
	//--------------------------------
	array_spawn_function_noteworthy( "drop_plane", ::drop_plane );
	run_thread_on_targetname( "sentry_activate", ::sentry_activate_trigger );
	run_thread_on_targetname( "vehicle_path_disconnector", ::vehicle_path_disconnector );
	run_thread_on_targetname( "delete_ai_trigger", ::delete_ai_trigger );
	run_thread_on_noteworthy( "plane_sound", maps\_mig29::plane_sound_node );
	run_thread_on_noteworthy( "moveup_trig", ::move_up_dialog );
	run_thread_on_noteworthy( "evac_chopper_1", ::add_spawn_function, ::evac_chopper_1 );
	run_thread_on_noteworthy( "ignore_until_unload", ::ignore_until_unload );
	run_thread_on_noteworthy( "checkpoing_clear_activate", ::force_trigger_on_flag, "checkpoint_enemies_dead" );
	run_thread_on_noteworthy( "checkpoing_clear_activate", ::undo_cull_dist );
	
	add_hint_string( "use_laser", &"ARCADIA_LASER_HINT", ::should_stop_laser_hint );
	add_hint_string( "use_laser_golf", &"ARCADIA_LASER_HINT_GOLFCOURSE", ::should_stop_laser_golf_hint );
	
	//--------------------------------
	// Level threads
	//--------------------------------
	thread civilian_car();
	thread checkpoint_cleared_dialog();
	thread checkpoint_cleared_dialog_ac130();
	thread laser_targeting_device( level.player );
	thread fake_checkpoint_choppers();
	thread fake_creek_choppers();
	thread golf_course_fake_choppers();
	thread second_street_friendlies();
	thread golf_course_battle();
	thread crashing_c130();
	thread harriers();
	thread fridge_guy();
	thread foley_dunn_get_to_ending();
	thread level_ending_sequence();
	thread pool();
	thread player_picks_up_briefcase();
	thread activate_second_half_destructibles();
	thread all_enemies_low_health();
	thread foley_leads_through_mansion();
	thread block_progression_until_artillery();
	thread bmps_kill_player_before_artillery();
	thread bmps_force_kill_player();
	thread force_artillery_if_player_bypasses();
	thread set_culldist_first_bridge();
	thread undo_culldist_mansion();

	//--------------------------------
	// Make friendlies less accurate so the AI will fight longer without player interaction
	//--------------------------------
	wait 0.05;
	friendlies = getaiarray( "allies" );
	foreach( friend in friendlies )
		friend.baseaccuracy = 0.4;
	
	after0 = get_golf_geo( "golf_after", 0 );
	assert( after0.size > 0 );
	array_call( after0, ::hide );
	
	after1 = get_golf_geo( "golf_after", 1 );
	assert( after1.size > 0 );
	array_call( after1, ::hide );
}

undo_cull_dist()
{
	self waittill( "trigger" );
	set_cull_dist( 0 );
}

set_culldist_first_bridge()
{
	flag_wait( "first_bridge" );
	set_cull_dist( 9000 );
}

undo_culldist_mansion()
{
	flag_wait( "golf_course_mansion" );
	set_cull_dist( 0 );
}

activate_second_half_destructibles()
{
	//flag_wait( "past_checkpoint" );
	wait 1;
	volume = getent( "volume_second_half", "targetname" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();
}

precache_masked_destructibles()
{
	loadfx( "smoke/car_damage_whitesmoke" );
	loadfx( "smoke/car_damage_blacksmoke" );
	loadfx( "smoke/car_damage_blacksmoke_fire" );
	loadfx( "explosions/small_vehicle_explosion" );
	loadfx( "props/car_glass_large" );
	loadfx( "props/car_glass_med" );
	loadfx( "props/car_glass_headlight" );
	loadfx( "smoke/motorcycle_damage_blacksmoke_fire" );
	loadfx( "props/car_glass_brakelight" );
	loadfx( "props/mail_box_explode" );
	loadfx( "props/garbage_spew_des" );
	loadfx( "props/garbage_spew" );
	loadfx( "explosions/wallfan_explosion_dmg" );
	loadfx( "explosions/wallfan_explosion_des" );
	loadfx( "props/filecabinet_dam" );
	loadfx( "props/filecabinet_des" );
	loadfx( "misc/light_blowout_runner" );
	loadfx( "props/electricbox4_explode" );
	loadfx( "explosions/ceiling_fan_explosion" );
	loadfx( "props/firehydrant_leak" );
	loadfx( "props/firehydrant_exp" );
	loadfx( "props/firehydrant_spray_10sec" );
	loadfx( "explosions/tv_flatscreen_explosion" );
	
	precachemodel( "ma_flatscreen_tv_wallmount_broken_02" );
	precachemodel( "vehicle_van_green_destructible" );
	precachemodel( "vehicle_van_green_destroyed" );
	precachemodel( "vehicle_van_green_hood" );
	precachemodel( "vehicle_van_green_door_rb" );
	precachemodel( "vehicle_van_green_mirror_l" );
	precachemodel( "vehicle_van_green_mirror_r" );
	precachemodel( "vehicle_van_wheel_lf" );
	precachemodel( "vehicle_pickup_destructible_mp" );
	precachemodel( "vehicle_pickup_destroyed" );
	precachemodel( "vehicle_pickup_hood" );
	precachemodel( "vehicle_pickup_door_lf" );
	precachemodel( "vehicle_pickup_door_rf" );
	precachemodel( "vehicle_pickup_mirror_l" );
	precachemodel( "vehicle_pickup_mirror_r" );
	precachemodel( "vehicle_luxurysedan_2008_white_destructible" );
	precachemodel( "vehicle_luxurysedan_2008_white_destroy" );
	precachemodel( "vehicle_luxurysedan_2008_white_hood" );
	precachemodel( "vehicle_luxurysedan_2008_white_wheel_lf" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_lf" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_rf" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_lb" );
	precachemodel( "vehicle_luxurysedan_2008_white_door_rb" );
	precachemodel( "vehicle_luxurysedan_2008_white_mirror_l" );
	precachemodel( "vehicle_luxurysedan_2008_white_mirror_r" );
	precachemodel( "vehicle_coupe_gold_destructible" );
	precachemodel( "vehicle_coupe_gold_destroyed" );
	precachemodel( "vehicle_coupe_gold_door_lf" );
	precachemodel( "vehicle_coupe_gold_spoiler" );
	precachemodel( "vehicle_coupe_gold_mirror_l" );
	precachemodel( "vehicle_coupe_gold_mirror_r" );
	precachemodel( "vehicle_coupe_black_destructible" );
	precachemodel( "vehicle_coupe_black_destroyed" );
	precachemodel( "vehicle_coupe_black_door_lf" );
	precachemodel( "vehicle_coupe_black_spoiler" );
	precachemodel( "vehicle_coupe_black_mirror_l" );
	precachemodel( "vehicle_coupe_black_mirror_r" );
	precachemodel( "vehicle_suburban_destructible_beige" );
	precachemodel( "vehicle_suburban_destroyed_beige" );
	precachemodel( "vehicle_suburban_wheel_rf" );
	precachemodel( "vehicle_suburban_door_lb_beige" );
	precachemodel( "vehicle_motorcycle_01_destructible" );
	precachemodel( "vehicle_motorcycle_01_destroy" );
	precachemodel( "vehicle_motorcycle_01_front_wheel_d" );
	precachemodel( "vehicle_motorcycle_01_rear_wheel_d" );
	precachemodel( "vehicle_motorcycle_02_destructible" );
	precachemodel( "vehicle_motorcycle_02_destroy" );
	precachemodel( "vehicle_policecar_lapd_destructible" );
	precachemodel( "vehicle_policecar_lapd_destroy" );
	precachemodel( "vehicle_policecar_lapd_wheel_lf" );
	precachemodel( "vehicle_policecar_lapd_door_lf" );
	precachemodel( "vehicle_policecar_lapd_door_rf" );
	precachemodel( "vehicle_policecar_lapd_door_lb" );
	precachemodel( "vehicle_policecar_lapd_mirror_l" );
	precachemodel( "vehicle_policecar_lapd_mirror_r" );
	precachemodel( "mailbox_black" );
	precachemodel( "mailbox_black_dam" );
	precachemodel( "mailbox_black_dest" );
	precachemodel( "mailbox_black_door" );
	precachemodel( "mailbox_black_flag" );
	precachemodel( "com_trashbin02" );
	precachemodel( "com_trashbin02_dmg" );
	precachemodel( "com_trashbin02_lid" );
	precachemodel( "com_recyclebin01" );
	precachemodel( "com_recyclebin01_dmg" );
	precachemodel( "com_recyclebin01_lid" );
	precachemodel( "cs_wallfan1" );
	precachemodel( "cs_wallfan1_dmg" );
	precachemodel( "com_filecabinetblackclosed" );
	precachemodel( "com_filecabinetblackclosed_dam" );
	precachemodel( "com_filecabinetblackclosed_des" );
	precachemodel( "com_filecabinetblackclosed_drawer" );
	precachemodel( "com_light_ceiling_round_on" );
	precachemodel( "com_light_ceiling_round_off" );
	precachemodel( "me_electricbox2" );
	precachemodel( "me_electricbox2_dest" );
	precachemodel( "me_electricbox2_door" );
	precachemodel( "me_electricbox2_door_upper" );
	precachemodel( "me_electricbox4" );
	precachemodel( "me_electricbox4_dest" );
	precachemodel( "me_electricbox4_door" );
	precachemodel( "me_fanceil1" );
	precachemodel( "me_fanceil1_des" );
	precachemodel( "com_trashbin01" );
	precachemodel( "com_trashbin01_dmg" );
	precachemodel( "com_trashbin01_lid" );
	precachemodel( "com_firehydrant" );
	precachemodel( "com_firehydrant_dest" );
	precachemodel( "com_firehydrant_dam" );
	precachemodel( "com_firehydrant_cap" );
}

startStreet()
{
	movePlayerToStartPoint( "playerstart_street" );
	thread objective_aa_guns();
	
	thread dialog_enemies_yellow_house();
	thread dialog_enemies_grey_house();
	thread dialog_enemies_pink_house();
	thread dialog_enemies_apartments();
	thread get_off_streets_dialog();
	
	array_thread( getentarray( "opening_rpg_location", "targetname" ), ::opening_rpgs );
	
	level.stryker thread stryker_rpg_dialog();
}

startCheckpoint()
{
	flag_set( "used_laser" );
	
	activate_trigger( "checkpoint_vision_trigger", "script_noteworthy" );
	
	getent( "friendlyspawn_trigger_checkpoint", "script_noteworthy" ) notify( "trigger", level.player );
	
	movePlayerToStartPoint( "playerstart_checkpoint" );
	thread objective_aa_guns();
}

startGolf()
{
	flag_set( "golf_course_vehicles" );
	flag_set( "golf_course_mansion" );
	flag_set( "used_laser" );
	
	activate_trigger( "golfcourse_vision_trigger", "script_noteworthy" );
	
	movePlayerToStartPoint( "playerstart_golf" );
	thread objective_aa_guns();
	thread objective_laze_golfcourse();
	
	flag_set( "first_bridge" );
	flag_set( "golf_course_battle" );
	
	wait 0.05;
	
	allies = getaiarray( "allies" );
	locations = getentarray( "start_golf_friendly_teleport", "targetname" );
	foreach( i, guy in allies )
		guy forceTeleport( locations[ i ].origin, locations[ i ].angles );
	
	trig = getent( "start_golf_friendly_trigger", "script_noteworthy" );
	trig notify( "trigger", level.player );
	
	exploder( "tanker_explosion_tall" );
	thread sun_blocker();
}

startCrash()
{
	activate_trigger( "crash_vision_trigger", "script_noteworthy" );
	movePlayerToStartPoint( "playerstart_crash" );
	
	flag_set( "fridge_guy" );
	flag_set( "ending_prep" );
	flag_set( "used_laser" );
	flag_set( "disable_stryker_dialog" );
	
	wait 0.05;
	
	// delete stryker when the player goes through the house
	level notify( "golf_course_mansion" );
	level.stryker connectPaths();
	level.stryker delete();
	
	allies = getaiarray( "allies" );
	locations = getentarray( "start_crash_friendly_teleport", "targetname" );
	foreach( i, guy in allies )
	{
		guy forceTeleport( locations[ i ].origin, locations[ i ].angles );
		guy.goalradius = 32;
		guy setGoalPos( locations[ i ].origin );
	}
	
	trig = getent( "start_crash_friendly_respawn_trigger", "script_noteworthy" );
	trig notify( "trigger", level.player );
	
	thread objective_brookmere_road();
	
	//exploder( "tanker_explosion_tall" );
	thread sun_blocker();
}

objective_aa_guns()
{
	objective_add( 0, "current", &"ARCADIA_OBJECTIVE_AA_GUNS" );
	objective_onentity( 0, level.foley );
}

objective_laze_golfcourse()
{
	if ( flag( "objective_laze_golfcourse" ) )
		return;
	flag_set( "objective_laze_golfcourse" );
	
	level notify( "objective_laze_golfcourse" );
	wait 0.05;
	thread objective_brookmere_road();
	
	objective_position( 0, ( 0, 0, 0 ) );
	objective_additionalposition( 0, 0, getent( "obj_location_stealth_0", "targetname" ).origin );
	objective_additionalposition( 0, 1, getent( "obj_location_stealth_1", "targetname" ).origin );
	
	thread laser_golf_hint_print();
	
	flag_wait( "stealth_bombed_0" );
	flag_wait( "stealth_bombed_1" );
	
	wait 3.0;
	
	objective_state( 0, "done" );
	
	wait 2;
	
	flag_set( "golfcourse_vehicles_dead" );
}

objective_brookmere_road()
{
	flag_wait_any( "second_bridge", "golfcourse_vehicles_dead" );
	
	thread brookmere_road_dialog();
	
	location = getent( "objective_brookmere_location", "targetname" );
	objective_add( 1, "current", &"ARCADIA_OBJECTIVE_BROOKMERE", location.origin );
	
	flag_wait( "brookmere_house" );
	
	objective_state( 1, "done" );
	
	thread objective_intel();
}

objective_intel()
{
	location = getent( "objective_intel_location", "targetname" );
	objective_add( 2, "current", &"ARCADIA_OBJECTIVE_INTEL", location.origin );
}

brookmere_road_dialog()
{
	battlechatter_off( "allies" );
	flavorbursts_off( "allies" );
	
	// Overlord, Hunter Two-One-Actual. Triple-A has been neutralized. We're heading to 4677 Brookmere Road, over.
	level.foley thread anim_single_solo( level.foley, "arcadia_fly_headingto4677" );
	wait 7.5;
	
	// Interrogative - what exactly are we looking for, over?
	level.foley thread anim_single_solo( level.foley, "arcadia_fly_lookingfor" );
	wait 3;
	
	// Sergeant Foley, this is General Shepherd.
	radio_dialogue( "arcadia_shp_genshep" );
	
	// Your objective is to extract a high value individual from a 'panic room' on the second floor of that house.
	radio_dialogue( "arcadia_shp_panicroom" );
	
	// Yes sir!
	level.foley thread anim_single_solo( level.foley, "arcadia_fly_yessir" );
	wait 1;
	
	// He'll be expecting you. Challenge is "Icepick", countersign is "Phoenix".
	radio_dialogue( "arcadia_shp_phoenix" );
	
	// Get him outta there and report back to Overlord. Shepherd out.
	radio_dialogue( "arcadia_shp_reportback" );
	wait 0.5;
	
	// All right, you heard the man - 4677 Brookmere Road. Move!
	level.foley thread anim_single_solo( level.foley, "arcadia_fly_heardtheman" );
	wait 2.0;
	
	flavorbursts_on( "allies" );
}

second_street_friendlies()
{
	// once coming up to the second street before the bridge we change all the friendlies
	// to GREEN color group so they all stick together.
	// Also, 2 friendlies get set to 1 health and are told to no longer respawn on death.
	// This leaves us with 4 friendlies instead of 6 for the new area
	
	flag_wait( "first_bridge" );
	
	friendlies = getaiarray( "allies" );
	foreach( count, friend in friendlies )
	{
		if ( count == 0 || count == 1 )
		{
			friend thread disable_replace_on_death();
			friend.health = 1;
		}
		friend thread set_force_color( "g" );
	}
	
}

dialog_enemies_yellow_house()
{
	flag_wait( "enemies_yellow_house" );
	
	// We got hostiles in the yellow house!
	level.foley thread dialogue_queue( "arcadia_fly_yellowhouse" );
}

dialog_enemies_grey_house()
{
	flag_wait( "enemies_grey_house" );
	
	// Enemies in the grey house!!!
	level.dunn thread dialogue_queue( "arcadia_cpd_greyhouse" );
	
	wait 1;
	
	// Squad, we got hostiles that grey house! Take 'em out!!
	level.foley thread dialogue_queue( "arcadia_fly_greyhouse" );
}

dialog_enemies_pink_house()
{
	flag_wait( "enemies_pink_house" );
	
	// Squad, put suppressing fire on that house!!
	level.foley thread dialogue_queue( "arcadia_fly_suppressingfire" );
	
	wait 8;
	
	// Squad, concentrate your fire on that house!!
	level.foley thread dialogue_queue( "arcadia_fly_suppressingfire" );
}

dialog_enemies_apartments()
{
	flag_wait( "enemies_apartments" );
	
	// Enemy foot-mobiles by the apartments!
	level.dunn thread dialogue_queue( "arcadia_cpd_apartments" );
	
	wait 1;
	
	// Roger that, enemy foot-mobiles by the apartments, take 'em ouuut!!
	level.foley thread dialogue_queue( "arcadia_fly_apartments" );
}

get_off_streets_dialog()
{
	battlechatter_off( "allies" );
	
	wait 5;
	
	// Hunter Two-One, this is Hunter Two-One Actual. Our evac choppers are taking heavy losses from ground fire!
	level.foley thread dialogue_queue( "arcadia_fly_heavylosses" );
	
	wait 1;
	
	// We gotta destroy those triple-A positions so they can get the rest of the civvies outta here! Let's go!
	level.foley thread dialogue_queue( "arcadia_fly_destroytriplea" );
	
	battlechatter_on( "allies" );
	
	wait 10;
	
	// Get off the streets!!
	level.foley thread dialogue_queue( "arcadia_fly_getoffstreets" );
	
	wait 10;
	
	// Get off the streets, use the houses for cover!!
	level.foley thread dialogue_queue( "arcadia_fly_offstreets" );
	
	wait 15;
	
	// Get outta the street!!
	level.foley thread dialogue_queue( "arcadia_fly_outtastreets" );
	
	wait 15;
	
	// Flank 'em through the houses!! Go go go!!
	level.foley thread dialogue_queue( "arcadia_fly_flankthruhouses" );
	
	wait 20;
	
	// Squad, move up through these houses, let's go, let's go!!
	level.foley thread dialogue_queue( "arcadia_fly_movethruhouses" );
}

move_up_dialog()
{
	// wait for the trigger to get hit that tells the friendlies to move up
	self waittill( "trigger" );
	
	guy = undefined;
	anime = undefined;
	
	rand = randomint( 4 );
	switch( rand )
	{
		case 0:
			// Everyone move up!
			guy = level.foley;
			anime = "arcadia_fly_everyoneup";
			break;
		case 1:
			// Move up!
			guy = level.foley;
			anime = "arcadia_fly_moveup";
			break;
		case 2:
			// Move up!!!
			guy = level.dunn;
			anime = "arcadia_cpd_moveup";
			break;
		case 3:
			// Let's go, let's go!!
			guy = level.dunn;
			anime = "arcadia_cpd_letsgo";
			break;
	}
	
	assert( isalive( guy ) );
	assert( isdefined( anime ) );
	
	guy thread dialogue_queue( anime );
}

stryker_rpg_dialog()
{
	self endon( "death" );
	
	flag_wait( "stryker_rpg_danger_dialog_1" );
	wait 8;
	
	// Squad! Protect the Stryker! Watch for foot-mobiles with RPGs!
	level.foley thread dialogue_queue( "arcadia_fly_protectstryker" );
	
	flag_wait( "stryker_rpg_danger_dialog_2" );
	wait 8;
	
	// Squad! They're targeting the Stryker! Watch for RPGs!
	level.foley thread dialogue_queue( "arcadia_fly_watchforrpgs" );
	
	flag_wait( "stryker_rpg_danger_dialog_3" );
	wait 8;
	
	// Hunter Two-One Actual, this is Badger One! Our anti-missile system cannot handle the volume of RPG fire, we need your team to thin 'em out, how copy, over?
	thread radio_dialogue( "arcadia_str_rpgfire" );
	
	// Solid copy Badger One, we're on it! Out!
	level.foley thread dialogue_queue( "arcadia_fly_wereonit" );
}

checkpoint_cleared_dialog_ac130()
{
	flag_wait( "crashing_c130" );
	
	wait 3;
	
	marine1 = undefined;
	marine2 = undefined;
	allies = getaiarray( "allies" );
	assert( allies.size >= 4 );
	foreach( guy in allies )
	{
		if ( guy is_hero() )
			continue;
		if ( !isdefined( marine1 ) )
			marine1 = guy;
		else
			marine2 = guy;
		if ( isdefined( marine1 ) && isdefined( marine2 ) )
			break;
	}
	assert( isdefined( marine1 ) );
	assert( isdefined( marine2 ) );
	
	marine1 endon( "death" );
	marine2 endon( "death" );
	
	// Look look! That's an AC-130 man.
	marine1 anim_generic( marine1, "arcadia_ar1_lookac130" );
	
	// That's why they don't fly during the day soldier.
	marine2 anim_generic( marine2, "arcadia_ar2_dontfly" );
	
	// Damn…sucks to be them…
	marine1 anim_generic( marine1, "arcadia_ar1_suckstobethem" );
	
	// Huah.
	marine2 anim_generic( marine2, "arcadia_ar2_huah" );
}

checkpoint_cleared_dialog()
{
	flag_wait( "past_checkpoint" );
	
	battlechatter_off( "allies" );
	flavorbursts_off( "allies" );
	flag_set( "disable_stryker_dialog" );
	
	// Hunter Two-One-Actual, Overlord. Gimme a sitrep over.
	radio_dialogue( "arcadia_hqr_sitrep" );
	
	// We're just past the enemy blockade at Checkpoint Lima. Now proceeding into Arcadia, over.
	level.foley dialogue_queue( "arcadia_fly_intoarcadia" );
	
	// Roger that. I have new orders for you. This comes down from the top, over.
	radio_dialogue( "arcadia_hqr_neworders" );
	
	// Solid copy Overlord, send it.
	level.foley dialogue_queue( "arcadia_fly_solidcopy" );
	
	// Your team is to divert to 4677 Brookmere Road after you have eliminated the triple-A.
	radio_dialogue( "arcadia_hqr_divertto4677" );
	
	// Solid copy Overlord. Divert to 4677 Brookmere Road once the guns are destroyed. Got it.
	level.foley dialogue_queue( "arcadia_fly_divertto4677" );
	
	// Check back with me when you've completed your main objective. Overlord out.
	radio_dialogue( "arcadia_hqr_checkback" );
	
	battlechatter_on( "allies" );
	flavorbursts_on( "allies" );
	flag_clear( "disable_stryker_dialog" );
}

fridge_guy()
{
	flag_wait( "fridge_guy" );
	
	guy = spawn_targetname( "fridge_guy_spawner" );
	guy.animname = "fridge_guy";
	guy set_ignoreme( true );
	guy disable_surprise();
	thread fridge_guy_death_wait( guy );
	
	fridge = getent( "fridge", "targetname" );
	assert( isdefined( fridge ) );
	fridge.animname = "fridge";
	fridge setAnimTree();
	
	bottle = spawn( "script_model", guy.origin );
	bottle setModel( "cs_vodkabottle01" );
	bottle linkTo( guy, "tag_inhand", (0,0,0), (0,0,0) );
	guy thread fridge_guy_remove_bottle_drop( bottle );
	guy thread fridge_guy_remove_bottle_death( bottle );
	
	guy_and_fridge[ 0 ] = guy;
	guy_and_fridge[ 1 ] = fridge;
	
	fridge thread anim_loop( guy_and_fridge, "fridge_idle", "stop_idle" );
	guy.allowdeath = true;
	
	fridge thread fridge_guy_spots_player( guy_and_fridge );
}

fridge_guy_death_wait( guy )
{
	guy waittill( "death" );
	wait 3.0;
	flag_set( "icepick_callout" );
}

fridge_guy_remove_bottle_drop( bottle )
{
	self endon( "death" );
	self waittillmatch( "single anim", "break_bottle" );
	bottle notify( "delete" );
	bottle delete();
}

fridge_guy_remove_bottle_death( bottle )
{
	bottle endon( "delete" );
	self waittill( "death" );
	bottle delete();
}

fridge_guy_spots_player_or_takes_damage( guy )
{
	guy endon( "death" );
	guy endon( "damage" );
	trigger_wait( "fridge_guy_react", "targetname" );
}

fridge_guy_spots_player( guy_and_fridge )
{
	guy_and_fridge[ 0 ] endon( "death" );
	
	fridge_guy_spots_player_or_takes_damage( guy_and_fridge[ 0 ] );
	
	self notify( "stop_idle" );
	self thread anim_single( guy_and_fridge, "fridge_react" );
	
	guy_and_fridge[ 0 ] set_ignoreme( false );
}

foley_dunn_get_to_ending()
{
	flag_wait( "heros_become_red" );
	
	// move foley and dunn to red
	level.foley thread set_force_color( "r" );
	level.foley.animplaybackrate = 1.2;
	level.foley allowedStances( "stand" );
	
	level.dunn thread set_force_color( "r" );
	level.dunn.animplaybackrate = 1.2;
	level.dunn allowedStances( "stand" );
}

level_ending_sequence()
{
	thread level_ending_sequence_dialog();
	
	// Wait for player to be approaching the end
	flag_wait( "ending_prep" );
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	flavorbursts_off( "allies" );
	flavorbursts_off( "axis" );
	
	allies = getaiarray( "allies" );
	foreach( friend in allies )
		friend.baseaccuracy = 100;
	
	housenode_foley = getnode( "housenode_foley", "targetname" );
	housenode_dunn = getnode( "housenode_dunn", "targetname" );
	hallnode_foley = getnode( "hallnode_foley", "targetname" );
	hallnode_dunn = getnode( "hallnode_dunn", "targetname" );
	node_foley = getnode( "ending_node_foley", "targetname" );
	node_dunn = getent( "ending_node_dunn", "targetname" );
	node_dunn_guard = getnode( "node_dunn_guard", "targetname" );
	
	// put HVI and dead enemy in position
	thread ending_sequence_deadguy( "hvi_spawner", "ending_node_hvi", "panicroom_hvi", "ending_pose" );
	thread ending_sequence_deadguy( "ending_enemy_spawner", "ending_node_dunn", "panicroom_enemy", "ending_pose" );
	
	level.foley pushPlayer( true );
	level.dunn pushPlayer( true );
	
	wait 0.1;
	
	level.foley.goalradius = 16;
	level.foley setGoalNode( housenode_foley );
	level.dunn.goalradius = 16;
	level.dunn setGoalNode( housenode_dunn );
	
	flag_wait( "player_approaching_house" );
	
	level.foley.goalradius = 16;
	level.foley setGoalNode( hallnode_foley );
	wait 0.5;
	level.dunn.goalradius = 16;
	level.dunn setGoalNode( hallnode_dunn );
	
	// Wait for player to enter panic room
	flag_wait( "start_ending" );
	
	// Foley goes and stands in the panic room
	level.foley.goalradius = 16;
	level.foley setGoalNode( node_foley );
	level.foley cqb_walk( "on" );
	level.dunn.goalradius = 16;
	level.dunn setGoalNode( node_dunn_guard );
	level.foley.alertlevel = "noncombat";
	level.dunn.alertlevel = "noncombat";
	
	level.foley waittill( "goal" );
	flag_set( "foley_in_panic_room" );
	
	// wait for player to pick up briefcase before doing final anims
	flag_wait( "picked_up_briefcase" );
	
	// Objective is complete
	objective_state( 2, "done" );
	flag_set( "examine_tats" );
	
	// Dunn examines tats
	thread ending_sequence_dunn( node_dunn );
	
	flag_wait( "foley_leaves_panic_room" );
	
	// Foley walks out to see the tattoo guy
	level.foley thread maps\_patrol::patrol( "ending_node_foley3" );
	
	flag_wait( "end_dialog_done" );
	nextmission();
}

ending_sequence_dunn( node_dunn )
{
	level.dunn allowedStances( "stand" );
	
	node_dunn anim_teleport_solo( level.dunn, "ending" );
	node_dunn anim_single_solo( level.dunn, "ending" );
	
	level.dunn.alertlevel = "noncombat";
	level.dunn.goalradius = 16;
	level.dunn allowedStances( "stand" );
	level.dunn setGoalPos( level.dunn.origin );
}

ending_sequence_deadguy( spawner_targetname, node_targetname, animName, anime )
{
	assert( isdefined( spawner_targetname ) );
	assert( isdefined( node_targetname ) );
	assert( isdefined( animName ) );
	assert( isdefined( anime ) );
	
	spawner = getent( spawner_targetname, "targetname" );
	assert( isdefined( spawner ) );
	
	node = getent( node_targetname, "targetname" );
	assert( isdefined( node ) );
	
	guy = ending_sequence_deadguy_create( spawner );
	
	guy.animname = animName;
	node thread anim_first_frame_solo( guy, anime );
	
	//flag_wait( "player_approaching_house" );
	//wait 0.05;
	
	//guy.team = "neutral";
	//guy.no_friendly_fire_penalty = true;
	//guy.allowdeath = false;
	//guy.a.nodeath = true;
	//guy.noragdoll = true;
	//guy gun_remove();
	//guy magic_bullet_shield();
	//guy.noDrop = true;
	//guy kill();
}

ending_sequence_deadguy_create( spawner )
{
	guy = spawner spawn_ai( true );
	assert( isdefined( guy ) );
	guy gun_remove();
	
	model = spawn( "script_model", guy.origin );
	model.angles = guy.angles;
	model setmodel( guy.model );

	numAttached = guy getattachsize();
	for ( i = 0; i < numAttached; i++ )
	{
		modelname 	 = guy getattachmodelname( i );
		tagname 	 = guy getattachtagname( i );
		model attach( modelname, tagname, true );
	}
	
	model UseAnimTree( #animtree );
	
	guy delete();
	
	return model;
}

level_ending_sequence_dialog()
{
	flag_wait( "icepick_callout" );
	
	// Icepick.
	level.foley dialogue_queue( "arcadia_fly_icepick1" );
	
	wait 1.5;
	
	flag_wait( "player_upstairs" );
	
	// Icepick!
	level.foley dialogue_queue( "arcadia_fly_icepick2" );
	
	wait 1.0;
	
	// Something's not right here…Check the panic room - move!
	level.foley dialogue_queue( "arcadia_fly_notright" );
	thread music_play( "arcadia_panicroom" );
	
	flag_wait( "start_ending" );
	
	// Hmph. No sign of forced entry…
	level.foley anim_single_solo( level.foley, "arcadia_fly_nosign" );
	
	flag_wait( "foley_in_panic_room" );
	
	wait 1;
	
	// Ramirez, get that briefcase...what's left of it.
	level.foley anim_single_solo( level.foley, "arcadia_fly_getthatbriefcase" );
	flag_set( "player_can_pick_up_briefcase" );
	
	flag_wait( "examine_tats" );
	flag_set( "foley_leaves_panic_room" );
	
	wait 5.5;
	
	// Sarge, check out these tats. Not your average paratrooper, huah?
	//played from anim
	
	// Huah. Get a couple photos for G-2 and check the bodies for intel.
	level.foley setLookAtEntity( level.dunn );
	level.foley anim_single_solo( level.foley, "arcadia_fly_photosforg2" );
	
	// Huah.
	level.dunn dialogue_queue( "arcadia_cpd_huah" );
	level.foley setLookAtEntity();
	
	// Shepherd's not gonna like this.
	level.foley anim_single_solo( level.foley, "arcadia_fly_notgoingtolike" );
	
	wait 1.5;
	
	thread delayThread( 1.5, ::flag_set, "end_dialog_done" );
	
	// Overlord, the HVI is dead.
	level.foley anim_single_solo( level.foley, "arcadia_fly_overlordhvi" );
}

player_picks_up_briefcase()
{
	use_trig = getent( "briefcase_trigger", "targetname" );
	use_trig setHintString( &"ARCADIA_PICK_UP_BRIEFCASE_HINT" );
	
	briefcase = getent( "briefcase", "targetname" );
	
	use_trig trigger_off();
	
	flag_wait( "player_can_pick_up_briefcase" );
	
	briefcase setmodel( "com_metal_briefcase_opened_obj" );
	use_trig trigger_on();
	
	use_trig waittill( "trigger" );
	briefcase thread play_sound_in_space( "intelligence_briefcase_pickup" );
	
	flag_set( "picked_up_briefcase" );
	
	use_trig delete();
	briefcase delete();
}