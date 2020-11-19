#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\boneyard_code;

main()
{
	precacheItem( "littlebird_FFAR" );
	PrecacheItem( "smoke_grenade_american" );
	PrecacheItem( "rpg_straight" );
	PrecacheItem( "rpg_distant" );
	PreCacheRumble( "c130_flyby" );

	PreCacheModel( "ch_viewhands_player_gk_m4_sopmod_ii" );
	PreCacheModel( "ch_viewhands_gk_m4_sopmod_ii" );

	maps\_juggernaut::main();
	maps\_drone_ai::init();

	start_points_setup();

	maps\_load::set_player_viewhand_model( "ch_viewhands_player_gk_m4_sopmod_ii" );
	animscripts\dog\dog_init::initDogAnimations();

	maps\boneyard_precache::main();
	level.vttype = "uaz_physics";
	level.vtmodel = "vehicle_uaz_open_destructible";
	maps\_vehicle::build_aianims( maps\boneyard_anim::uaz_overrides, maps\boneyard_anim::uaz_override_vehicle );
	maps\_vehicle::build_unload_groups( ::uaz_unload_groups );
	level.vttype = "truck_physics";
	level.vtmodel = "vehicle_pickup_roobars";
	maps\_vehicle::build_aianims( maps\boneyard_anim::truck_overrides, maps\boneyard_anim::truck_vehicle_overrides );
	level.vttype = "suburban_minigun";
	level.vtmodel = "vehicle_suburban_technical";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_aianims( maps\boneyard_anim::suburban_minigun_overrides, maps\_suburban_minigun::set_vehicle_anims );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", undefined, "car_explode" );
	level.vttype = "suburban";
	level.vtmodel = "vehicle_suburban";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_aianims( maps\boneyard_anim::suburban_overrides, maps\_suburban::set_vehicle_anims );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", undefined, "car_explode" );

	maps\createart\boneyard_fog::main();
	maps\createfx\boneyard_audio::main();
	maps\boneyard_fx::main();

	maps\_load::main();
	maps\boneyard_anim::main();
	thread maps\boneyard_amb::main();
	maps\_compass::setupMiniMap( "compass_map_boneyard" );

	// setup stuff
	flags_setup();
	threatbiasgroups_setup();
	threewayfight_setup();
	fire_missile_setup();
	delete_not_touching_setup();
	delete_excess_setup();
	vehicle_event_node_setup();
	vehicle_aianimthread_setup();
	launch_object_setup();
//	killer_bird_setup();
	vehicle_sweetener_setup();
	ride_rumble_setup();

	// consines used for fov checks.
	level.cosine[ "20" ] = cos( 20 );
	level.cosine[ "60" ] = cos( 60 );

	thread objectives();

	// used for switching colors on ai
	level.base_colors = [];
	level.base_colors[ "axis" ] = "r";
	level.base_colors[ "team3" ] = "p";

	// gameplay threads
	thread road();
	thread flyby();
	thread higround();
	thread ride();

	thread music_thread();

	// it sounds like they are friendlies because some of the battlechatter is over the radio.
//	battlechatter_off( "team3" );

	// enemies need to be closer to tell each other about an enemy
	setsaveddvar( "ai_eventDistNewEnemy", 512 );

	// makes you less likely to just walk up to enemies.
	setsaveddvar( "ai_eventDistFootstepSprint", 640 );	//400
	setsaveddvar( "ai_eventDistFootstep", 480 );		//256
	setsaveddvar( "ai_eventDistFootstepWalk", 320 );	//128
}

flags_setup()
{
	flag_init( "delete_excess" );
	flag_init( "suburban_target_btr80" );
	flag_init( "littlebird_at_goal" );
	flag_init( "btr80_target_littlebird" );
	flag_init( "btr80_destroyed" );
	flag_init( "littlebird_stage1" );
	flag_init( "uaz_park" );
	flag_init( "uaz_player_in_control" );
	flag_init( "intro_btr80_dead" );
	flag_init( "ride_uaz_arriving" );
	flag_init( "uaz_mounted" );
	flag_init( "ride_enemy_vehicles_spawn" );
	flag_init( "uaz_driver_dead" );
	flag_init( "music_boneyard_intro" );
	flag_init( "music_boneyard_flyby" );
	flag_init( "makarov_dialogue" );
	flag_init( "ride_minigun_gunner_dead" );
	flag_init( "player_loses_control_of_uaz" );
	flag_init( "uaz_nag" );

/*************************
***	FLAGS FROM RADIANT ***
**************************

	blow_tanker_first
	blow_tanker_second
	blow_wing
	boneyard_mission_completed
	btr80_at_end
	btr80_destroy
	c130_hatch_open
	c130_takeoff
	c130_takeoff_missed
	flyby_c130
	flyby_minigun_move
	flyby_rockets
	friendly_stay_ahead
	frontal_suburban_move
	higround_1
	higround_2
	higround_ascend
	hummer_destroy
	hunt_btr80
	intro_btr80_attack
	intro_btr80_attack_kill
	intro_btr80_destroy
	intro_btr80_pre_attack
	intro_littlebird_strafe
	intro_rockets_2
	keep_moving
	littlebird_react
	littlebird_stage1_wait
	music_boneyard_planechase
	no_align
	obj_ride
	ride_shadows
	ride_driver_death
	road
	road_rocket_guys
	road_rocket_guys
	runway_save
	runway_suburban_rightside
	scene_a_wave2
	stop_road_rockets
	switch_color
	uaz_drive
	uaz_driver_dialogue
	uaz_driver_mount
	uaz_mount_end
	uaz_player_control
	wait_for_player
	where_is_nikolai
	wing_fall

*************************/
}

threatbiasgroups_setup()
{
	CreateThreatBiasGroup( "aware_of_player" );
	CreateThreatBiasGroup( "ignore_player" );
	CreateThreatBiasGroup( "enemy_dog" );
	CreateThreatBiasGroup( "lowthreat" );

	SetThreatBias( "allies", "aware_of_player", 0 ); //aware_of_player are using the base threat level.
	SetThreatBias( "allies", "axis", -1000 );	// axis find the player to be less of a threat. // used 1000 before
	SetThreatBias( "allies", "team3", -1000 );	// team3 find the player to be less of a threat. // used 1000 before
	SetThreatBias( "allies", "enemy_dog", -3000 );	// dogs find the player to be less of a threat.
	SetIgnoreMeGroup( "allies", "ignore_player" );	// ignore_player ignores the player
	SetThreatBias( "lowthreat", "axis", -2000 );	// axis find the target less of a threat.
	SetThreatBias( "lowthreat", "team3", -2000 );	// team3 find the target less of a threat.

}

start_points_setup()
{
	default_start( ::start_default );
	add_start( "intro", ::start_default, "Intro" );
	add_start( "road", ::start_road, "Road" );
	add_start( "flyby", ::start_flyby, "Flyby" );
	add_start( "higround", ::start_higround, "Higround" );
	add_start( "ride", ::start_ride, "Ride" );
	add_start( "ride_end", ::start_ride_end, "Ride_end" );
}

objectives()
{
	flag_init( "obj_rallypoint" );
	flag_init( "obj_ride" );
	flag_init( "obj_ride_c130" );

	objective_number = 0;

	// each case is a start point;
	switch( level.start_point )
	{
		default:
		case "intro":
			// this will have to change when I go backwards and do the sniper clearing.
			flag_wait( "obj_rallypoint" );
			objective_number = 0;
			end_position = getent( "rallypoint", "targetname" );
			obj_position = getent( end_position.target, "targetname" );
			objective_add( objective_number, "current", &"BONEYARD_OBJ_RALLYPOINT", obj_position.origin );
			level thread lerp_objective_pos( objective_number, obj_position, end_position );
		case "flyby":
		case "higround":
		case "ride":
			flag_wait( "obj_ride" );

			Objective_State( objective_number, "done" );
			objective_number = 1;
			obj_position = getent( "rallypoint", "targetname" );
			objective_add( objective_number, "current", &"BONEYARD_OBJ_RIDE", obj_position.origin );
			Objective_SetPointerTextOverride( objective_number, &"BONEYARD_OBJ_RIDE_ICON" );
	//		flag_wait( "uaz_drive" );
			Objective_OnEntity( objective_number, level.uaz, (-48,-32,16) );

		case "ride_c130":
			flag_wait( "obj_ride_c130" );

			level notify( "release_objective" );

			Objective_State( objective_number, "done" );
			objective_number = 2;
			obj_position = level.c130;
			objective_add( objective_number, "current", &"BONEYARD_OBJ_C130", obj_position.origin );
			setsaveddvar( "compass", 0 );
			
			thread sp_objective_onentity( objective_number, level.c130 );
	}

	flag_wait( "uaz_park" );
	wait 0.5;

	Objective_State( objective_number, "done" );

	fade_out_level( 2 );

	if ( is_default_start() )
	{
		nextmission();
	}
	else
	{
		IPrintLnBold( "DEVELOPER: END OF SCRIPTED LEVEL" );
	}
}

lerp_objective_pos( objective_number, obj_position, end_position )
{
	flag_wait( "objective_lerp" );

	obj_position moveto( end_position.origin, 60 );

	for ( i = 0; i<6; i++ )
	{
		wait 10;
		Objective_Position( objective_number, obj_position.origin );
	}

	Objective_Position( objective_number, end_position.origin );
}

music_thread()
{
	flag_wait( "music_boneyard_intro" );
	music_loop( "boneyard_intro", 151 );

	flag_wait( "music_boneyard_flyby" );
	music_loop( "boneyard_flyby", 184, 6 );

	flag_wait( "ride_enemy_vehicles_spawn" );
	music_play( "boneyard_jeepride", 4 );

	flag_wait( "music_boneyard_planechase" );
	music_play( "boneyard_planechase", 1 );
	
	flag_wait( "player_loses_control_of_uaz" );
	wait 0.8;
	musicstop( 1.5 );
	level notify( "stop_music" );
	level.player play_sound_on_entity( "boneyard_planechase_end" );	
}

start_default()
{
	level thread intro();
}

intro()
{
	getent( "littlebird", "targetname" ) add_spawn_function( ::littlebird_init );
	getent( "intro_littlebird", "script_noteworthy" ) add_spawn_function( ::littlebird_init, true );
	getent( "intro_littlebird_2", "script_noteworthy" ) add_spawn_function( ::littlebird_init, true );
	getent( "intro_littlebird_2", "script_noteworthy" ) add_spawn_function( ::intro_littlebird_strafe );
	getent( "intro_hummer", "script_noteworthy" ) add_spawn_function( ::intro_hummer );
	getent( "intro_btr80", "script_noteworthy" ) add_spawn_function( ::intro_btr80 );
	getent( "scene_a_suburban", "script_noteworthy" ) add_spawn_function( ::scene_a_suburban );

	level thread intro_player();
	level thread intro_rockets();
	level thread intro_dialogue();

	activate_trigger_with_targetname( "intro_trigger" );
	exploder( "intro_exploder" );

	level thread intro_introscreen();

	flag_wait( "pullup_weapon" );
	wait 0.2;

	level.player.surprisedByMeDistSq = squared( 5000 ); //what is this for? - Roger

	starttime = gettime();
	flag_wait_or_timeout( "player_left_fuselage", 15 );
	wait_for_buffer_time_to_pass( starttime, 5 );

	activate_trigger_with_targetname( "intro_trigger_2" );

	array_thread( getentarray( "littlebird_trigger", "targetname" ), ::littlebird_trigger );
	level thread littlebird_spawn();

	wait 5;

	activate_trigger_with_targetname( "intro_color_trigger" );

	flag_wait( "intro_btr80_destroy" );
	wait 2;
	activate_trigger_with_targetname( "intro_threeway_fight" );
	flag_set( "switch_color" );
}

intro_introscreen()
{
//	flag_wait_either( "intro_btr80_dead", "objective_lerp" );
	flag_wait( "obj_rallypoint" );
	wait 1;
	maps\_introscreen::boneyard_intro();
}

intro_player()
{
	level.player.ignoreme = true;
	level.player waittill_any_timeout( 6, "weapon_fired", "grenade_fire" );
	wait 6;
	level.player.ignoreme = false;
}

intro_dialogue()
{
	wait 2.5;

	flag_set( "music_boneyard_intro" );

	// Soap! Shepherd's trying to wipe out *us* and Makarov at the same time! Head for rally point Bravo to the north! Trust no one!
	radio_dialogue( "byard_pri_wipeoutus" );

	flag_set( "obj_rallypoint" );

	flag_wait_either( "intro_btr80_dead", "objective_lerp" );
	wait 8;

	// I'm gonna call in the backup plan! Head for the rally point while I coordinate with Nikolai!
	radio_dialogue( "byard_pri_backupplan" );
	wait 1;

	// Nikolai! This is Price! Now would be a good time!!! The LZ is hot, I repeat the LZ is hot!!!
	radio_dialogue( "byard_pri_lzishot" );
	// Ok, Captain Price, I am on the way! Try to get the situation under control BEFORE I get there, ok?
	radio_dialogue( "byard_nkl_ontheway" );
	// Right, whatever you say Nikolai! Just get here sharpish!
	radio_dialogue( "byard_pri_sharpish" );

	flag_wait( "let_them_fight" );
	// Soap, let Makarov and Shepherd's men kill each other off as much as you can!
	radio_dialogue( "byard_pri_radiotraffic" );
	// We can use their radios to listen in on their radio traffic! I'm going to try to contact Makarov!
	radio_dialogue( "byard_pri_contactmakarov" );

	wait 2;

	level thread makarov_dialogue();

	level endon( "flyby_c130" );

	flag_waitopen( "makarov_dialogue" );
	flag_wait( "keep_moving" );
	// Soap! Don't get pinned down out there! Keep heading north for the runway area!
	radio_dialogue( "byard_pri_headnorth" );

	flag_wait( "road" );
	// Nikolai, where the hell are you?
	radio_dialogue( "byard_pri_whereareyou" );
	// Sand storms around Kandahar, Captain Price. I have to fly around them. I'm not getting paid enough to crash my plane.
	radio_dialogue( "byard_nkl_sandstorms" );
}

makarov_dialogue()
{
	flag_set( "makarov_dialogue" );
	wait 2;
	// Makarov, this is Price! Shepherd's a war hero now! He's got your operations playbook and he's got a blank check!
	radio_dialogue( "byard_pri_warhero" );
	wait 1.5;
	// Give me what you've got on Shepherd, and I'll take care of the rest!
	radio_dialogue( "byard_pri_takecareofrest" );
	wait 1.5;
	// I know you can hear me on this channel Makarov!
	radio_dialogue( "byard_pri_onthischannel" );
	wait 0.5;
	// You and I both know you won't last a week!
	radio_dialogue( "byard_pri_lastaweek" );
	// And neither will you!
	wait 1;
	radio_dialogue( "byard_mkv_neitherwillyou" );
	wait 0.25;
	// Makarov...you ever hear the old saying...the enemy of my enemy is my friend?
	radio_dialogue( "byard_pri_myfriend" );
	// Price, one day you're going to find that cuts both ways!
	radio_dialogue( "byard_mkv_cutsbothways" );
	// Shepherd is using Site Hotel Bravo. You know where it is! I'll see you in hell!
	radio_dialogue( "byard_mkv_hotelbravo" );
	// Looking forward to it!
	radio_dialogue( "byard_pri_myregards" );
	
	wait 3;
	flag_clear( "makarov_dialogue" );
}

intro_rockets()
{
	flag_wait( "intro_rockets" );
	array_thread( getentarray( "intro_first_rocket", "targetname" ), ::magic_rocket );

	flag_wait( "intro_rockets_2" );
	array_thread( getentarray( "intro_rocket_start", "targetname" ), ::magic_rocket );
}

intro_hummer(){
	damage_types = [];
	damage_types[ tolower( "MOD_PROJECTILE_SPLASH" ) ] = true; 
	damage_types[ tolower( "MOD_PROJECTILE" ) ] = true;
	self waittill_damage( damage_types, undefined, true, 9 );

	self maps\_vehicle::force_kill();
}

intro_btr80()
{
	self main_turret_init();
	self thread makesentient( self.script_team );
	self thread intro_btr80_death();

	flag_wait( "intro_btr80_pre_attack" );
	self ent_flag_set( "hold_fire" );
	self thread main_turret_attack( level.intro_heli.fake_target, ( 0,0,0 ), true );
	level.intro_heli.fake_target = undefined;

	flag_wait( "intro_btr80_attack" );
	self ent_flag_clear( "hold_fire" );

	flag_wait( "intro_btr80_attack_kill" );
	self main_turret_attack( level.intro_heli, ( 0,0,0 ), true );
	wait 1;

	self thread intro_btr80_target_axis();
}

intro_btr80_death()
{
	flag_wait( "intro_btr80_destroy" );

	level.intro_heli.fake_target = undefined;

	damage_types = [];
	damage_types[ tolower( "MOD_PROJECTILE_SPLASH" ) ] = true; 
	damage_types[ tolower( "MOD_PROJECTILE" ) ] = true;
	self waittill_damage( damage_types, undefined, true, 4 );

	flag_set( "intro_btr80_dead" );
	self maps\_vehicle::force_kill();
}

intro_btr80_target_axis()
{
	self endon( "death" );

	while( true )
	{
		ai_arr = getaiarray( "axis" );
		ai_arr = array_add( ai_arr, level.player );
		self main_turret_attack( ai_arr[0], ( 0,0,0 ), true );
	}
}

intro_littlebird_strafe()
{
	level.intro_heli = self;

	flag_wait( "intro_littlebird_strafe" );
	// make turret fire.
	array_thread( self.mgturret, ::road_target, self );
}

vehicle_sweetener_setup()
{
	// ents for helicopters
	array = getentarray( "vehicle_sweetener", "script_noteworthy" );
	array_thread( array, ::vehicle_sweetener );

	// nodes for other vehicles
	array = getvehiclenodearray( "vehicle_sweetener", "script_noteworthy" );
	array_thread( array, ::vehicle_sweetener );
}

vehicle_sweetener()
{
	self waittill( "trigger", vehicle );
	vehicle playsound( self.script_soundalias );
}

road_target( heli )
{
	heli endon( "death" );

	self setconvergencetime( 0 );

	forward = anglestoforward( self.angles );
	target_origin = self.origin + 700 * forward + (0,0,-80);

	target_ent = spawn( "script_origin", target_origin );

/*
	target_ent = spawn( "script_model", target_origin );
	target_ent setmodel( "fx" );
*/
	target_ent linkto( self );

	old_mode = self getmode();
	self setmode( "manual" );
	self SetTargetEntity( target_ent );

	flag_waitopen( "intro_littlebird_strafe" );
	target_ent delete();
	self cleartargetentity();

	self setmode( old_mode );

}

scene_a_suburban()
{
	self endon( "death" );

	self thread set_flag_on_player_damage( "scene_a_wave2" );

	turret = self.mgturret[0];
	turret waittill( "turret_ready" );

//	turret SetMode( "auto_ai" );

	mg_guy = turret getturretowner();
	assert( isdefined( mg_guy ) );

	mg_guy thread set_flag_on_player_damage( "scene_a_wave2" );

	main_target = getent( "mg_target", "targetname" );
	turret thread animscripts\hummer_turret\common::set_manual_target( main_target, 3, 6 );

	flag_wait( "scene_a_wave2" );
	thread scene_a_rpg_guy( self );

	while( true )
	{
		self waittill( "damage", damage, guy );
		assert( isdefined(guy) );
		if ( isdefined( self.rpg_guy ) && guy == self.rpg_guy )
			break;
	}

	self maps\_vehicle::godoff();
	self notify( "death", self.rpg_guy, "MOD_PROJECTILE" );
}

scene_a_rpg_guy( vehicle )
{
	sight_ent = spawn( "script_origin", vehicle.origin + ( 0,0,150 ) );
	sight_ent linkto( vehicle );

	sight_ent waittill_player_lookat( undefined, undefined, undefined, 5, vehicle );

	guy = getent( "scene_a_rpg_guy", "targetname" ) spawn_ai( true );
	guy endon( "death" );
	vehicle.rpg_guy = guy;

	anim_ent = getent( "scene_a_rpg_spot" ,"targetname" );
	guy set_allowdeath( true );
	guy.ignoreall = true;
	guy.ignoreme = true;
	anim_ent anim_generic( guy, "prone_2_stand" );	


	guy SetStableMissile( true );

	guy.ignoreall = false;

	guy SetEntityTarget( vehicle, 1 );
	vehicle waittill_notify_or_timeout( "death", 5 );
	
	guy SetStableMissile( false );

	guy ClearEntityTarget();
	guy.ignoreme = false;
	guy set_force_color( "p" );
	guy.goalheight = 128;
	guy threewayfight_threads_defaults();
}

littlebird_init( no_repulsor )
{
	level notify( "road_heli_spawned" );
	array_thread( self.mgturret, ::littlebird_minigun );
	level.heli = self;
	self.script_AI_invulnerable = true;

	waittillframeend;
	self thread makesentient( self.script_team );

	if ( !isdefined( no_repulsor ) )
		self thread toggle_repulsor();

	self.fake_target = spawn( "script_model", (0,0,0) );
//	self.fake_target setmodel( "fx" );
	self.fake_target linkto( self, "tag_origin", ( 100, 0, 150 ), ( 0, 0, 0 ) );
	self thread fake_target_delete( self.fake_target );

	/#
		self thread drawpath();
		ent = self.currentnode;
		self thread mark_heli_path( ent );
	#/
}

toggle_repulsor()
{
	self endon( "death" );

	while( true )
	{
		self waittill( "rpg_fired" );
		repulsor = Missile_CreateRepulsorEnt( self, 2500, 1000 );
		wait 2.5;
		Missile_DeleteAttractor( repulsor );
	}
}

littlebird_alive()
{
	if ( !isdefined( level.heli ) )
		return false;
	if ( !isalive( level.heli ) )
		return false;
	if ( level.heli.health < level.heli.healthbuffer )
		return false;
	return true;
}

fake_target_delete( fake_target )
{
	fake_target endon( "death" );
	self waittill( "death" );
	fake_target delete();
}

littlebird_minigun()
{
	self SetBottomArc( 18 );
	self setrightarc( 20 );
	self setleftarc( 20 );
	self SetConvergenceTime( 1.5, "yaw" );
	self SetConvergenceTime( 0.7, "pitch" );
}

littlebird_trigger()
{
	level endon( "spawn_littlebird" );
	self waittill( "trigger" );
	level notify( "spawn_littlebird", self.target );
}

littlebird_spawn()
{
	level waittill( "spawn_littlebird", ent_str );	
	ent = getent( ent_str, "targetname" );

	heli_spawner = getent( "littlebird", "targetname" );
	level.heli = heli_spawner move_spawn_and_go( ent );

	flag_clear( "littlebird_react" );
	level.heli thread littlebird_reaction( "strafe_path" );
}

flyby_littlebird()
{
	flag_wait( "flyby_c130" );

	if ( !littlebird_alive() )
	{
		// if dead respawn
		path_ent = getent( "littlebird_flyby_start", "targetname" );
		heli_spawner = getent( "littlebird", "targetname" );
		level.heli = heli_spawner move_spawn_and_go( path_ent );
	}

	// level.heli might be overritten by the higround heli if the player moves fast.
	heli = level.heli;

	heli maps\_vehicle::godon();
	heli notify( "reaction_end" );


	path = getent( "littlebird_flyby_standby", "targetname" );
	heli maps\_vehicle::set_heli_move( "faster" );
	heli Vehicle_SetSpeed( 65, 25, 25 );
	heli thread maps\_vehicle::vehicle_paths( path );

	flag_wait( "flyby_c130" );
	path = getent( "flyby_chase_path", "targetname" );
	heli maps\_vehicle::set_heli_move( "faster" );
	heli Vehicle_SetSpeed( 60, 25, 25 );
	heli thread maps\_vehicle::vehicle_paths( path );

	heli waittill( "reached_dynamic_path_end" );
	heli delete();
}

start_road()
{
	level.player start_at( GetEnt( "start_road_player", "targetname" ) );
	activate_trigger_with_targetname( "middle_road_start_trigger" );

	heli_spawner = getent( "littlebird", "targetname" );
	heli_spawner add_spawn_function( ::littlebird_init );
	array_thread( getentarray( "littlebird_trigger", "targetname" ), ::littlebird_trigger );
	level thread littlebird_spawn();
	getentarray( "littlebird_trigger", "targetname" )[0] notify( "trigger" );

	wait 1;
	flag_set( "littlebird_react" );
	waittillframeend;
	level.heli notify( "react");
	level.heli maps\_vehicle::mgon();
}

road()
{
	level thread road_rocket_guys();
	level thread flyby_c130();
	level thread road_crash();
	getent( "road_hummer", "script_noteworthy" ) add_spawn_function( ::road_hummer );

	triggers = getentarray( "middle_road", "targetname" );
	foreach( trigger in triggers )
		level waittill_stack_add( "trigger", trigger );

	level waittill( "waittill_stack", msg, trigger );

	// tmp fix
	dist = 1000;
	while( true )
	{
		wait 0.5;
		ai = getaiarray( "axis", "team3" );
		if ( !isdefined( ai[0] ) )
			continue;

		ai = SortByDistance( ai, level.player.origin );
		if ( distance( ai[0].origin, level.player.origin ) > dist )
			break;
		dist *= 0.95;
	}

	exploder( "road_exploder" );

	level waittill_stack_clear(); // clear stack
}

road_hummer()
{
	turret = self.mgturret[0];
	turret waittill( "turret_ready" ); // could this break it?
	mg_guy = turret getturretowner();

	if ( littlebird_alive() )
		self thread turret_track_target( turret, level.heli );

	array_thread( self.riders, ::set_flag_on_player_damage, "road" );
	self thread set_flag_on_player_damage( "road" );

	self waittill( "death" );
	level notify( "hummer_dead" );
}

road_crash()
{
	flag_wait( "hummer_destroy" );

	// pickup trucks blow up and switch model after in 1 second instead of the default 2.
	level.vttype = "truck_physics";
	level.vtmodel = "vehicle_pickup_roobars";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0, true );
	maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1, true );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	level.vehicle_deathmodel_delay[ level.vtmodel ] = 0;

	flag_wait( "road" );
	activate_trigger_with_targetname( "road_crash" );
}

road_rocket_guys()
{
	level endon( "stop_road_rockets" ); // called by a flag_set in radiant.

	spawner_arr = getentarray( "road_rocket_guys", "targetname" );
	while( true )
	{
		flag_wait( "road_rocket_guys" );

		if ( !littlebird_alive() )
			return;

		level.heli endon( "death" );

		guy = undefined;
		spawner_arr = SortByDistance( spawner_arr, level.player.origin );
		for( i=spawner_arr.size; i>0; i-- )
		{
			spawner = spawner_arr[i-1];
			spawner.count++;
			guy = spawner spawn_ai();
			if( !spawn_failed( guy ) )
				break;
		}

		if ( distance( level.player.origin, guy.origin ) > 800 )
			guy.ignoreme = true;

		guy.rocket_target = level.heli;
		guy thread road_rocket_guys_clear();

		flag_clear( "road_rocket_guys" );
	}
}

flyby_c130()
{
	array_thread( getentarray( "rocket_start", "targetname" ), ::flyby_magic_rocket, 2 );

	flag_wait( "flyby_c130" );	
	spawner = getent( "flyby_c130_spawner", "targetname" );
	c130 = spawner spawn_vehicle();
	c130 thread maps\_vehicle::gopath();

	c130 playsound( "veh_c130_flyby" );

	level.player thread flyby_rumble();

	flag_wait( "flyby_angel_flare" );
	c130 thread angel_flare_burst( 10 );

	wait 11;
	c130 thread angel_flare_burst( 5 );
}

start_flyby()
{
	level.player start_at( GetEnt( "start_flyby_player", "targetname" ) );

	path_ent = getent( "littlebird_flyby_start", "targetname" );
	heli_spawner = getent( "littlebird", "targetname" );
	level.heli = heli_spawner move_spawn_and_go( path_ent );
}

flyby()
{
	level thread flyby_dialogue();

	// fewer enemies
	level.ai_cap[ "axis" ] = 10;
	level.ai_cap[ "team3" ] = 10;

	getent( "flyby_suburban", "script_noteworthy" ) add_spawn_function( ::flyby_suburban );

	flag_wait( "flyby_rockets" );
	level thread flyby_littlebird();

	flag_wait( "flyby_c130" );

//	SetCullDist( 12000 );

	flag_set( "music_boneyard_flyby" );
	activate_trigger_with_targetname( "flyby_area_trigger" );

	level thread flyby_advance();

	flag_wait( "flyby_vision_change" );
	level thread maps\_utility::vision_set_fog_changes( "boneyard", 10 );

	flag_wait( "higround_ascend" );
	SetCullDist( 0 );
}

flyby_advance()
{
	// this should happen after the drop dow
	flag_wait( "flyby_vision_change" );

	axis = get_ai_group_ai( "flyby_axis" );
	team3 = get_ai_group_ai( "flyby_team3" );

	if ( axis.size < 5 && team3.size < 5 )
	{
		// move enemies and start the suv going.
		activate_trigger_with_noteworthy( "flyby_advance_color_trigger" );
		flag_set( "flyby_minigun_move" );
	}
}

flyby_dialogue()
{
	level endon( "higround_ascend" );

	flag_wait( "flyby_c130" );

	flag_waitopen( "makarov_dialogue" );

	// Price, I am approaching the boneyard. I see you do not have situation under control.
	// Very unsafe to land. It looks like when I was in Afghanistan with the Soviets!
	radio_dialogue( "byard_nkl_unsafetoland" );
	// Nikolai! Shut up and just land the bloody plane! We're on our way!
	radio_dialogue( "byard_pri_landtheplane" );

	// This is such bullshit! I'm not getting paid nearly enough for these missions!
	// These flares are expensive!! FUCK!!!
	 radio_dialogue( "byard_nkl_paidenough" );

	flag_wait( "flyby_minigun_move" );	
	wait 7;
	// Soap! Hurry! We've got to get to Nikolai's plane! Keep moving north!
	radio_dialogue( "byard_pri_gettoplane" );
}

flyby_suburban()
{
	self endon( "death" );
	level.flyby_suburban = self;

	flag_wait( "flyby_suburban_go" ); // wait till the minigun vehicle has passed.

	path_start = getvehiclenode( "flyby_retreat_path","targetname" );
	self new_vehicle_path( path_start );

	flag_wait( "flyby_suburban_kill" );

	self VehPhys_launch( (-450,50,100), true );
	self maps\_vehicle::godoff();
	self maps\_vehicle::force_kill();
}

start_higround()
{
	flag_set( "music_boneyard_intro" );
	flag_set( "music_boneyard_flyby" );
	
	
	objective_number = 0;
	obj_position = getent( "rallypoint", "targetname" );
	objective_add( objective_number, "current", &"BONEYARD_OBJ_RALLYPOINT", obj_position.origin );

	level.player start_at( GetEnt( "start_higround_player", "targetname" ) );

	vnode = getvehiclenode( "higround_minigun_suburban_start", "script_noteworthy" );
	suburban_spawner = getent( "higround_minigun_suburban", "script_noteworthy" );
	vehicle = suburban_spawner move_spawn_and_go( vnode );

	vnode = getvehiclenode( "higround_btr80_start", "script_noteworthy" );
	btr80_spawner = getent( "higround_btr80", "script_noteworthy" );
	vehicle = btr80_spawner move_spawn_and_go( vnode );
	flag_set( "flyby_suburban_go" );

	/#
	// debug shit
	ent = getent( "higround_heli_path", "script_noteworthy" );
	thread mark_heli_path( ent );
	#/

	trigger = getent( "higround_start_trigger_off", "script_noteworthy" );
	trigger trigger_off();

	activate_trigger_with_targetname( "higround_start_color_trigger" );
	activate_trigger_with_noteworthy( "higround_start_ai_trigger" );

	flag_wait_or_timeout( "higround_ascend", 3 );
	activate_trigger_with_targetname( "higround_start_color_trigger_2" );

}

higround()
{
	getent( "higround_btr80", "script_noteworthy" ) add_spawn_function( ::higround_btr80 );
	getent( "higround_minigun_suburban", "script_noteworthy" ) add_spawn_function( ::higround_minigun_suburban );
	getent( "higround_littlebird", "targetname" ) add_spawn_function( ::littlebird_init );
	getent( "higround_littlebird", "targetname" ) add_spawn_function( ::higround_littlebird );
	array_spawn_function_noteworthy( "higround_guy", ::higround_guy );

	level thread higround_dialogue();

	flag_wait( "flyby_suburban_go" );
	SetThreatBias( "allies", "team3", 0 );	// team3 find the player to be normal threat for when they are crossing the road.

	level thread higround_second_save();

	// start the ride once living higround guys are 4 or less and the btr80 died or reached it's final destination.
	level thread higround_ride_force_start( 4 );
}

higround_ride_force_start( living )
{
	flag_wait( "higround_2" );
	flag_wait_either( "btr80_at_end", "btr80_destroyed" );

	while( level.higround_guy > living )
		wait 0.5;

	activate_trigger_with_noteworthy( "ride_start_trigger" );
}

higround_guy()
{
	level endon( "ride_uaz_arriving" );

	if ( !isdefined( level.higround_guy ) )
		level.higround_guy = 0;

	level.higround_guy++;

	self waittill_either( "death", "pain_death" );
	level.higround_guy--;
}

higround_second_save()
{
	// save halfway through the higround when atleast 30 seconds has passed.
	level endon( "ride_uaz_arriving" );

	flag_wait( "higround_ascend" );

	start_time = gettime();
	flag_wait( "higround_2" );

	wait_for_buffer_time_to_pass( start_time, 30 );

	autosave_by_name( "higround_second_save" );
}

higround_dialogue()
{
	level endon( "higround_2" );

	flag_wait( "higround_ascend" );	

	flag_waitopen( "makarov_dialogue" );

	// Soap! I'm going to get some transport! Make your way north towards the runway!
	radio_dialogue( "byard_pri_gettransport" );

	starttime = gettime();
	flag_wait( "higround_1" );
	wait_for_buffer_time_to_pass( starttime, 15 );

	// Soap! I've found some transport! Keep moving north! I'll meet you en route!
	radio_dialogue( "byard_pri_foudntransport" );
}

higround_littlebird()
{
	self endon( "death" );
	level.btr80 endon( "death" );
	level endon( "obj_ride" );

	self thread higround_littlebird_ondeath();
	self thread higround_littlebird_onkill();

	flag_wait( "hunt_btr80" );

	self SetMaxPitchRoll( 25, 25 );
	self SetYawSpeed( 90, 45, 22.5, 0 );

	self thread higround_littlebird_hunt_btr80( "hunt_btr80" );
	self higround_littlebird_aligned( "higround_2" );
	if ( !flag( "btr80_at_end" ) )
	{
		flag_clear( "no_align" );

		// this will fire but miss.
		self higround_littlebird_failed_attack();
		self notify( "stop_hunt" );
		self ClearLookAtEnt();
		self ClearTurretTarget();

		flag_set( "btr80_target_littlebird" );

		self maps\_vehicle::godon();

		self Vehicle_SetSpeed( 70, 35, 10 );
		self SetNearGoalNotifyDist( 512 );
		self SetVehGoalPos( level.player.origin + ( 0,0,768 ) );

		self waittill_any( "goal", "near_goal" );
		flag_clear_delayed( "btr80_target_littlebird", 3 );
		self delaythread( 4, maps\_vehicle::godoff );
	}

	self notify( "stop_hunt" ); // stops the first hunt
	self thread higround_littlebird_hunt_btr80( "hunt_btr80_final" );
	self higround_littlebird_aligned();
	self notify( "stop_hunt" ); // stops the hunt just above.

	// might kill the btr80 or it might not.
	if ( cointoss() )
	{
		target_arr = [];
		target_arr[0] = level.btr80;
		self thread fire_missile( target_arr, 3 );
	}
	else
	{
		self higround_littlebird_failed_attack();
		thread flag_set_delayed( "btr80_target_littlebird", 3 );
		self.fake_target delayCall( randomfloatrange( 4, 8 ), ::delete );
	}

	level.heli notify( "missed_final" );

	self ClearLookAtEnt();
	self ClearTurretTarget();

	start_path = getent( "higround_strafe_path_first", "targetname" );
	level.heli thread maps\_vehicle::vehicle_paths( start_path );

	flag_clear( "littlebird_react" );
	level.heli thread littlebird_reaction( "higround_strafe_path" );
}

higround_littlebird_onkill()
{
	level endon( "obj_ride" );
	level.heli endon( "death" );
	level.heli endon( "missed_final" );

	level.btr80 waittill( "death" );

	self ClearLookAtEnt();
	self ClearTurretTarget();

	start_path = getent( "higround_strafe_path_first", "targetname" );
	level.heli thread maps\_vehicle::vehicle_paths( start_path );

	flag_clear( "littlebird_react" );
	level.heli thread littlebird_reaction( "higround_strafe_path" );
}

higround_littlebird_ondeath()
{
	level endon( "obj_ride" );
	level.btr80 endon( "death" );

	level.heli waittill( "death" );
	level.btr80.main_turret_enemies = array_remove( level.btr80.main_turret_enemies, level.heli );
}

higround_btr80()
{
	self endon( "death" );
	level.btr80 = self;
	self.dontunloadonend = true;

	self thread higround_btr80_on_death();

	flag_set( "suburban_target_btr80" );

	vehicle_set_health( 500 );
	self main_turret_init();

//	self thread makesentient( self.script_team );

	flag_wait( "flyby_suburban_go" );

	if ( isalive( level.flyby_suburban ) )
	{
		wait 2;
		self main_turret_attack( level.flyby_suburban, ( 0,0,30 ), true, 10 );
	}

	mg = self.mgturret[0];
	mg SetTopArc( 10 );

	self main_turret_aim_straight();
	wait 5;
	self ent_flag_clear( "hold_fire" );

	self thread main_turret_think();

	SetThreatBias( "allies", "team3", 1000 );	// team3 find the player to be less of a threat again.

	self higround_btr80_target_littlebird();

	wait 2;
	self notify( "clear_turret_target" );
	flag_set( "higround_2" );
}

higround_btr80_target_littlebird()
{
	self endon( "death" );

	while( true )
	{
		flag_wait( "btr80_target_littlebird" );
		
		if ( !isdefined( level.heli ) )
			return;
		
		level.heli endon( "death" );
		
		// addes the heli as a target.
		if ( self.main_turret_enemies.size == 0 )
			self.main_turret_enemies = array_add( self.main_turret_enemies, level.heli );
		else
			self.main_turret_enemies = array_insert( self.main_turret_enemies, level.heli, 0 );
		
		self notify( "clear_turret_target" );
		
		flag_waitopen( "btr80_target_littlebird" );
		
		self.main_turret_enemies = array_remove( self.main_turret_enemies, level.heli );
	}
}

higround_btr80_on_death()
{
	self waittill( "death" );
	flag_set( "btr80_destroyed" );
}

higround_minigun_suburban()
{
	self endon( "death" );

	level.minigun_suburban = self;
//	self.dontUnloadOnEnd = true;

	turret = self.mgturret[0];
	turret waittill( "turret_ready" );
	mg_guy = turret getturretowner();

	flag_wait( "suburban_target_btr80" );

	turret = self.mgturret[0];
	turret animscripts\hummer_turret\common::set_manual_target( level.btr80, 4, 5 );

	flag_wait( "higround_ascend" );
	self vehicle_set_health( 200 );

	flag_wait( "btr80_target_suburban" );
	level.btr80.main_turret_enemies = array_add( level.btr80.main_turret_enemies, self );
}

start_ride()
{
	flag_set( "music_boneyard_intro" );
	flag_set( "music_boneyard_flyby" );
	
	level.player start_at( GetEnt( "start_ride_player", "targetname" ) );

	heli_spawner = getent( "littlebird", "targetname" );
	heli_spawner add_spawn_function( ::littlebird_init );
}

ride()
{
	ride_vehicle_spawners = getentarray( "ride_vehicle", "script_noteworthy" );
	array_thread( ride_vehicle_spawners, ::add_spawn_function, ::ride_vehicle );
	getent( "ride_uaz", "script_noteworthy" ) add_spawn_function( ::ride_uaz );

	spawner = getent( "runway_suburban", "targetname" );
	spawner add_spawn_function( ::ride_runway_suburban );

	array_spawn_function_noteworthy( "price", ::ride_uaz_price );
	array_spawn_function_noteworthy( "uaz_driver", ::ride_uaz_driver );
	array_spawn_function_noteworthy( "ride_minigunner", ::ride_minigunner );

	level thread ride_c130();
	level thread ride_c130_sound();
	level thread ride_tanker_blow();
	level thread collapse_wing();
	level thread ride_dialogue();
	level thread ride_zfar();
	level thread ride_littlebird();
	level thread suburban_ride_deathfx();

	flag_wait( "ride_uaz_arriving" );

	autosave_by_name( "ride_arriving_save" );
	level thread ramp_sunsample_over_time( .65, 3 );

	flag_wait( "ride_enemy_vehicles_spawn" );

	// pickup trucks blow up and switch model after in 1 second instead of the default 2.
	level.vttype = "truck_physics";
	level.vtmodel = "vehicle_pickup_roobars";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.9, true );
	maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			1, true );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			1.01, true );
	maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			1.01, true );
	level.vehicle_deathmodel_delay[ level.vtmodel ] = 1;

	// spawn vehicles
	activate_trigger_with_targetname( "ride_initiate" );

	// add ammo to current weapons for the ride.
	weaponlist = level.player GetWeaponsListPrimaries();

	foreach( weapon in weaponlist )
	{
		if ( IsSubStr( tolower( weapon ) , "rpg" ) )
			continue;
		if ( level.player GetFractionMaxAmmo( weapon ) > 0.5 )
			continue;

		level.player GiveStartAmmo( weapon );
	}

	flag_wait( "uaz_mounted" );
	set_custom_gameskill_func( ::boneyard_gameskill_ride_settings );

	flag_wait( "blow_wing" );
	autosave_by_name( "ride2" );

	flag_wait( "c130_hatch_open" );
	autosave_now(); // should always be safe

	flag_wait( "ride_driver_death" );
	flag_set( "uaz_driver_dialogue" );	

	level thread ride_uaz_player_viewkick();

	wait 2;
	level.player DisableOffhandWeapons();
	wait 1;

	flag_set( "uaz_player_control" );
}

suburban_ride_deathfx()
{
	flag_wait( "ride_uaz_arriving" );

	// change sound to scn_boneyard_sub_explode
	level.vttype = "suburban";
	level.vtmodel = "vehicle_suburban";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", undefined, "scn_boneyard_sub_explode" );

	flag_wait( "uaz_mounted" );

	level.vttype = "suburban";
	level.vtmodel = "vehicle_suburban";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", undefined, "car_explode" );

}

ride_zfar()
{
	flag_wait( "uaz_mounted" );
	wait 0.5; //8
	SetCullDist( 10000 );
	wait 11; //20
	SetCullDist( 13000 );
	wait 7; //27
	SetCullDist( 15500 );
	wait 20; //47
	SetCullDist( 20000 );
}

ride_dialogue()
{
	flag_wait( "ride_uaz_arriving" );	

	flag_waitopen( "makarov_dialogue" );
	level thread ride_uaz_nag();

	if ( !flag( "uaz_driver_mount" ) )
	{
		// Captain Price, I'm taking off in one minute! You better hurry if you want a ride out of here!
		radio_dialogue( "byard_nkl_oneminute" );
		// Soap! We don't have much time! Nikolai's not going to wait around for us! Hurry!
		radio_dialogue( "byard_pri_muchtime" );
	}

	flag_wait( "uaz_driver_mount" );
	if ( !flag( "uaz_mounted" ) )
	{
		if ( flag( "uaz_nag" ) )
		{
			// Soap! Get in the jeep!
			level.price dialogue_queue( "byard_pri_getinjeep" );
		}
		else
		{
			// Soap! We are leaving!!! Get in the jeep!
			level.price dialogue_queue( "byard_pri_weareleaving" );
		}
	}

	flag_wait( "uaz_driver_dialogue" );	
	sniper_origin = level.player.origin + (0,0,64);

	wait 0.8;
	flag_set( "uaz_driver_dead" );
	wait 1;
	// Soap! Rook is down! Take the wheel!!!
	level.price dialogue_queue( "byard_pri_takewheel" );

	level.price endon( "death" );

	flag_wait( "uaz_player_in_control" );	
	wait 3;
	// Aim for the ramp!!!
	level.price dialogue_queue( "byard_pri_aimforramp" );
	
}

ride_uaz_nag()
{
	level.price endon( "death" );
	level endon( "uaz_driver_mount" );

	wait 20;
	// Soap! Get in the jeep!
	level.price dialogue_queue( "byard_pri_getinjeep" );

	wait 30;
	// Soap! We are leaving!!! Get in the jeep!
	level.price dialogue_queue( "byard_pri_weareleaving" );
	flag_set( "uaz_nag" );
}

ride_uaz_player_viewkick()
{
	wait 1.3;
	level.player ViewKick( 256, level.rook geteye() );
}

ride_uaz_price()
{
	level.price = self;
	self.name = "Captain Price";
	self.animname = "price";

	flag_wait( "uaz_player_in_control" );
	self thread ride_uaz_fake_price_fire();
}

ride_vehicle()
{
	self thread vehicle_player_induced_death();
	self thread vehicle_event_handler();
	self VehPhys_DisableCrashing();
	array_thread( self.riders, ::ride_rider );

	// vehicles damage and death gets handles by level script.
	self maps\_vehicle::godon();
}

ride_runway_suburban()
{
	level.runway_suburban = self;

	self hidepart( "TAG_GLASS_RIGHT_BACK" );
	self hidepart( "TAG_GLASS_LEFT_BACK" );
	self hidepart( "TAG_GLASS_RIGHT_FRONT" );
}

ride_rider()
{
	// little less easy to kill when on harder difficulties.
	// if this is "bad" we need some way to reinforce the riders.
	// don't do minigun guys since they get their health raised elsewhere.

	difficulty = level.gameskill;
	if ( difficulty == 0 )
		difficulty = 1;

	self.health *= difficulty;
}

ride_minigunner()
{
	self endon( "death" );

	level.ride_minigunner = self;

	self add_func( ::waittill_msg, "death" );
	self add_func( ::flag_set, "ride_minigun_gunner_dead" );
	self thread do_funcs();

	wait 1;

	turret = self GetTurret();
	assert( isdefined( turret ) );

	turret SetAISpread( 4 );
	flag_wait( "uaz_mount_end" );

	while( true )
	{
		self.ignoreall = false;
		wait 0.65;
//		wait randomfloatrange( 0.25, 0.75 );

		self.ignoreall = true;
		wait 1.75;
//		wait randomfloatrange( 1.5, 2 );
	}
}

ride_c130()
{
	level.c130 = assemble_c130();
	level endon( "uaz_park_crash" );

	flag_wait( "uaz_mounted" );

	// allow saves.
	flag_set( "can_save" );
	autosave_by_name( "ride" );

	spawner = getent( "ride_c130_spawner", "targetname" );
	c130_ent = spawner spawn_vehicle();
	c130_ent hide();
	wait 1;
	c130_ent maps\_vehicle::lights_off( "running" );

	level.c130 linkto( c130_ent, "tag_origin", (0,0,0), (0,0,0) );
	flag_set( "obj_ride_c130" );

	c130_ent thread maps\_vehicle::gopath();
	
	flag_wait( "uaz_driver_dead" );
	c130_ent thread add_player_tractor_beam();

	// failsafe in case some other vehicle drivs into the trigger.
	while( true )
	{
		level.c130.ramp_trigger waittill( "trigger", vehicle );
		if ( vehicle == level.uaz )
			break;
	}
	
	flag_set( "uaz_park" );
	wait( 0.15 );
	Earthquake( 0.35, 0.50, level.player.origin, 5000 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	SetBlur( 4, 0 );
	wait( 0.15 );
	setblur( 0, 0.4 );
	
}

add_player_tractor_beam()
{
	if ( !isdefined( level.uaz ) )
		return;

	self endon( "death" );
	level.uaz endon( "death" );

	back_dist = -260;
	enter_dist = 1524;

	for ( ;; )
	{
		forward = anglestoforward( self.angles );
		org = self.origin + forward * back_dist;
		
		if ( distance( self.origin, level.uaz.origin ) < enter_dist )
			break;
		
		wait( 0.05 );
	}
	
	flag_set( "player_loses_control_of_uaz" );
	level.control_loss_time = gettime();
}



ride_c130_sound()
{
	flag_wait( "c130_takeoff" );
	
	left = getent( "sound_engine_left", "script_noteworthy" );
	right = getent( "sound_engine_right", "script_noteworthy" );
	center = getent( "sound_c130_center", "script_noteworthy" );

	left PlayLoopSound( "veh_c130_left_engine_loop" );
	right PlayLoopSound( "veh_c130_right_engine_loop" );
	center PlayLoopSound( "veh_c130_main_loop" );
}

ride_littlebird()
{
	flag_wait( "obj_ride" );

	if ( littlebird_alive() )
	{
		level.heli notify( "reaction_end" );
		level.heli notify( "stop_hunt" );

		level.heli ClearLookAtEnt();
		level.heli ClearTurretTarget();

		path = getent( "littlebird_ride_start", "targetname" );
		level.heli Vehicle_SetSpeed( 40, 25, 25 );
		level.heli thread maps\_vehicle::vehicle_paths( path );
	}

	flag_wait( "littlebird_stage1" );
	if ( !littlebird_alive() )
	{
		// if dead respawn
		path_ent = getent( "littlebird_ride_respawn", "targetname" );
		heli_spawner = getent( "littlebird", "targetname" );
		level.heli = heli_spawner move_spawn_and_go( path_ent );
	}

	level.heli maps\_vehicle::godon();

	repulsor = Missile_CreateRepulsorEnt( level.heli, 5000, 1000 );

	path = getent( "littlebird_ride_stage1", "targetname" );
	level.heli Vehicle_SetSpeed( 65, 25, 25 );
	level.heli SetMaxPitchRoll( 25, 25 );
	level.heli thread new_vehicle_path( path );

	flag_wait( "blow_tanker_second" );
	target_arr = getentarray( "tanker_rocket_target", "targetname" );
	target_arr = array_index_by_script_index( target_arr );
	level.heli thread fire_missile( target_arr, target_arr.size );

	flag_wait( "blow_wing" );
	target_arr = getentarray( "tanker_rocket_target_2", "targetname" );
	target_arr = array_index_by_script_index( target_arr );
	level.heli thread fire_missile( target_arr, target_arr.size );
}

ride_track_health()
{
	level endon( "ride_uaz_nodeath" );

	self.damage_taken = 0;
	while ( true )
	{
		self waittill( "damage", damage, attacker );

		if ( !isdefined( level.ride_minigunner ) || attacker != level.ride_minigunner )
			continue;

		self.damage_taken += damage;
		println( "DAMAGE: " + self.damage_taken );
		if ( self.damage_taken > 37000 )
			break;
	}

	self maps\_vehicle::godoff();
	self maps\_vehicle::force_kill();

	wait 1;

	level.player kill();
//	missionfailedwrapper();
}

ride_uaz()
{
	flag_set( "ride_uaz_arriving" );

	self thread ride_track_health();

	level.uaz = self;
	self HidePart( "tag_blood" );

	self thread uaz_control();
	self thread ride_uaz_mount();
	self thread ride_uaz_failed_mount();
	self thread ride_uaz_player_crash();
	self thread ride_uaz_takeoff_missed();

	self VehPhys_DisableCrashing();

	self.dontunloadonend = true;

	// hack to get AI to fire when the vehicle is stationary
	// needs to be fixed so that unload doesn't force people into idle.
	flag_wait( "wait_for_player" );
	self Maps\_vehicle::vehicle_ai_event( "hide_attack_forward" );

	flag_wait( "uaz_drive" );

	self thread ride_bump();
	flag_set( "littlebird_stage1" );

	flag_wait( "uaz_mounted" );

	wait 2;
	level thread lerp_fov_overtime( 5, 80 );
	level thread maps\_utility::vision_set_fog_changes( "boneyard_ride", 5 );

	flag_wait( "uaz_player_in_control" );

	level thread maps\_utility::vision_set_fog_changes( "boneyard_steer", 2 );
	self VehPhys_EnableCrashing();
}

ride_uaz_failed_mount()
{
	level endon( "uaz_mounted" );
	flag_wait( "uaz_mount_end" );

	setDvar( "ui_deadquote", &"BONEYARD_DEADQUOTE_MOUNT" );
	missionfailedwrapper();
}

ride_uaz_player_crash()
{
	level endon( "uaz_park" );
	level endon( "uaz_park_crash" );

	flag_wait( "uaz_player_in_control" );

	self thread ride_uaz_player_force_crash();

	if ( isdefined( level.use_ent ) )
		level.use_ent delete();

	crash_limit = 15000;

	while( true )
	{
		self waittill( "veh_jolt", vector );
		force = abs( vector[0] ) + abs( vector[1] ) + abs( vector[2] );
		if ( force > crash_limit )
			break;
	}

	ride_uaz_player_launch();
	self maps\_vehicle::godoff();
	self maps\_vehicle::force_kill();
	wait 1;

	level.player kill();
//	missionfailedwrapper();
}

ride_uaz_player_force_crash()
{
	flag_wait( "uaz_force_crash" );

	ride_uaz_player_launch();

	self maps\_vehicle::godoff();
	self maps\_vehicle::force_kill();

	level.player kill();
}

ride_uaz_takeoff_missed()
{
	level endon( "uaz_park" );
	level endon( "uaz_park_crash" );

	flag_wait( "c130_takeoff_missed" );

	setDvar( "ui_deadquote", &"BONEYARD_DEADQUOTE_TAKEOFF" );
	missionfailedwrapper();
}

ride_uaz_driver()
{
	self endon( "death" );

	level.rook = self;
	self.name = "Rook";

	self disable_pain();
	self magic_bullet_shield();
	self.animname = "rook";

	self thread ride_uaz_driver_attack();

	flag_wait( "uaz_driver_mount" );

	// stop any save at this point.
	flag_clear( "can_save" );

	flag_wait( "ride_littlebird_dodge" );

	level.uaz thread guy_runtovehicle_load( self, level.uaz );

	self waittill( "boarding_vehicle" );

	self gun_remove();

	self stop_magic_bullet_shield();
	flag_set_delayed( "ride_enemy_vehicles_spawn", 1 );

	flag_wait( "uaz_driver_dead" );
	
	self playsound( "scn_bone_headshot" );

	playfxontag( getfx( "blood" ), self, "J_Head" );
	playfxontag( getfx( "blood_dashboard_splatter" ), self, "J_Head" );

	level.uaz ShowPart( "tag_blood" );
	self thread ride_uaz_driver_death();
}

ride_uaz_driver_death()
{
	self notify( "newanim" );
	self anim_stopanimscripted();

	// remove rook from riders array so that he never starts a new idle anim.
	level.uaz.riders = array_remove( level.uaz.riders, self );
	
	org = level.uaz GetTagOrigin( "tag_driver" );
	angles = level.uaz GetTagAngles( "tag_driver" );
	level.uaz thread anim_single_solo( self, "boneyard_driver_death", "tag_driver" );

	animation = self getanim( "boneyard_driver_death" );
	anim_time = GetAnimLength( animation );
	wait ( anim_time - 0.15 );
	self SetAnim( animation, 1, 0, 0 );
}

ride_uaz_driver_attack()
{
	flag_wait( "obj_ride" );
	wait 1;

	self waittill( "jumpedout" );
	flag_set( "ride_littlebird_dodge" );

	if ( isdefined( level.btr80 ) && isalive( level.btr80 ) )
	{
		etarget = spawn( "script_origin", level.btr80.origin + (0,0,128) );
		etarget linkto( level.btr80 );

		self SetEntityTarget( etarget, 1 );

		attractor = Missile_CreateAttractorEnt( level.btr80, 20000, 512 );

		if ( !flag( "uaz_driver_mount" ) )
			self waittill( "missile_fire" );
		self clearentitytarget();
	}

	if ( littlebird_alive() )
	{
		etarget = spawn( "script_origin", level.heli.origin + (0,0,-128) );
		etarget linkto( level.heli );

		self SetEntityTarget( etarget, 1 );

		if ( !flag( "uaz_driver_mount" ) )
			self waittill( "missile_fire" );
		self clearentitytarget();
	}

	self.a.rockets = 0;
}

ride_tanker_blow()
{
	tanker = get_tanker( "tanker_first", true );

	flag_wait( "blow_tanker_first" );
	wait 0.4;
	rocket_source = getent( "blow_tanker_first_rocket", "targetname" );
	rocket_target = getent( rocket_source.target, "targetname" );
	rocket = MagicBullet( "rpg_straight", rocket_source.origin, rocket_target.origin );

	damage_types = [];
	damage_types[ tolower( "MOD_PROJECTILE_SPLASH" ) ] = true; 
	damage_types[ tolower( "MOD_PROJECTILE" ) ] = true;

	tanker waittill_damage( damage_types );
	level.player EnableInvulnerability();
	tanker thread destructible_force_explosion();
	tanker waittill( "destroyed" );
	level.player DisableInvulnerability();

	tanker = get_tanker( "tanker_second", true );
	tanker waittill_damage( damage_types );
	tanker thread destructible_force_Explosion();
}

get_tanker( tanker_name, disable_explosion )
{
	tanker_arr = getentarray( tanker_name, "script_noteworthy" );
	tanker = undefined;
	foreach( tanker in tanker_arr )
	{
		if ( tanker.classname == "script_model" )
			break;
	}
	if ( isdefined( disable_explosion ) )
		tanker destructible_disable_explosion();

	return tanker;
}

start_ride_end()
{
	ride_vehicle_spawners = getentarray( "ride_vehicle", "script_noteworthy" );
	array_thread( ride_vehicle_spawners, ::add_spawn_function, ::ride_vehicle );

	vnode = getvehiclenode( "ride_end_start", "script_noteworthy" );
	spawner = getent( "ride_uaz", "script_noteworthy" );

	level.uaz = spawner move_spawn_and_go( vnode );

	vnode = getvehiclenode( "ride_end_pickup_start", "targetname" );
	spawner = getent( "runway_pickup", "targetname" );
	spawner move_spawn_and_go( vnode );

	vnode = getvehiclenode( "ride_end_suburban_start", "script_noteworthy" );
	spawner = getent( "runway_suburban", "targetname" );
	spawner move_spawn_and_go( vnode );

	flag_set( "uaz_mounted" );
	lerp_fov_overtime( 0.1, 80 );

	level.use_ent delete();

	flag_wait( "uaz_driver_dead" );
}