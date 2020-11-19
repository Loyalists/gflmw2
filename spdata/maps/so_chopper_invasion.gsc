#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\so_chopper_invasion_code;

main()
{
	set_custom_gameskill_func( maps\_gameskill::solo_player_in_coop_gameskill_settings );

	// special ops character selection using dvar "start"
	level.specops_character_selector = "";

	so_player_selection();

	so_chopper_invasion_init_flags();
	so_chopper_invasion_precache();

	add_hint_string( "ads_slowdown", &"SO_CHOPPER_INVASION_HINT_ADS_SLOWDOWN", ::so_ads_slowdown_hint );

	so_delete_all_by_type( ::type_spawn_trigger, ::type_spawners, ::type_killspawner_trigger, ::type_goalvolume, ::custom_flag_trigger );
	delete_turrets();

	maps\invasion_precache::main();
	maps\invasion_fx::main();
	thread so_fx_handler();

	maps\createart\invasion_art::main();

	maps\_juggernaut::main();
	maps\_blackhawk_minigun::main( "vehicle_blackhawk_minigun_hero" );
	maps\_minigun::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );

	thread build_chopper();

	// juggernauts shouldn't try to playerseek to the player in the chopper
	CreateThreatBiasGroup( "juggernauts" );
	CreateThreatBiasGroup( "chopperplayer" );
	SetIgnoreMeGroup( "chopperplayer", "juggernauts" );

	default_start( ::start_so_chopper_invasion );
	add_start( "so_chopper", ::start_so_chopper_invasion );

	so_chopper_invasion_fx();
	init_dialogue();
	init_fx();
	maps\createfx\so_chopper_invasion_fx::main();

	maps\_load::main();

	maps\_compass::setupMiniMap( "compass_map_invasion" );

	thread maps\invasion_amb::main();
	thread so_chopper_invasion_enemy_setup();

	so_chopper_invasion_spawner_functions();

	//thread maps\_debug::debug_character_count();

	thread so_level_cleanup();

}

precache_strings()
{
	PrecacheString( &"SO_CHOPPER_INVASION_OBJ_REGULAR" );
	PrecacheString( &"SO_CHOPPER_INVASION_OBJ_FINAL" );
	PrecacheString( &"SO_CHOPPER_INVASION_HINT_ADS_SLOWDOWN" );
	PrecacheString( &"SO_CHOPPER_INVASION_DEADQUOTE_HINT1" );
	PrecacheString( &"SO_CHOPPER_INVASION_DEADQUOTE_HINT2" );

	quotes = [];
	quotes[ quotes.size ] = &"SO_CHOPPER_INVASION_DEADQUOTE_HINT1";
	quotes[ quotes.size ] = &"SO_CHOPPER_INVASION_DEADQUOTE_HINT2";
	so_include_deadquote_array( quotes );
}

// Removes FX
so_fx_handler()
{
	array = [];
	array[ array.size ] = "bird_seagull_flock_large";
	array[ array.size ] = "antiair_runner";

	if ( IsSplitscreen() )
	{
		array[ array.size ] = "heli_crash_fire";	
	}

	foreach ( i, struct in level.createFXent )
	{
		foreach ( str in array )
		{
			if ( struct.v[ "fxid" ] == str )
			{
				level.createFXent[ i ] = undefined;
				struct.v = undefined;
				break;
			}
		}
	}

	level.createFXent = array_removeUndefined( level.createFXent );
}

custom_flag_trigger()
{
	if ( IsDefined( self.script_specialops ) || !IsDefined( self.classname ) )
	{
		return false;
	}
		
	array = [];
	array[ "trigger_multiple_flag_set" ]			= 1;
	array[ "trigger_multiple_flag_set_touching" ]	= 1;
	array[ "trigger_multiple_flag_clear" ]			= 1;
	array[ "trigger_multiple_flag_looking" ]		= 1;
	array[ "trigger_multiple_flag_lookat" ]			= 1;
	
	return IsDefined( array[ self.classname ] );
}

// Clean up the level
so_level_cleanup()
{
	// Remove the Predator Control Unit
	ent = GetEnt( "predator_drone_control", "targetname" );
	ent Delete();

	// Wait a bit so initFX() can do it's thing
	wait( 0.1 );

	// Remove the exploders on nate's bar
	thread do_exploder_custom( getent( "north_side_low", "targetname" ), "just_swap" );
	thread do_exploder_custom( getent( "north_side_high", "targetname" ), "just_swap" );
	thread do_exploder_custom( getent( "west_side", "targetname" ), "just_swap" );

	// Remove ladder clips that are there to help the player in SP.
	ladder = getent( "nates_kitchen_ladder_clip", "targetname" );
	ladder Delete();
	ladder = getent( "bt_ktichen_ladder_clip", "targetname" );
	ladder Delete();

	// Tree on street
//	exploder_stripped( 4, "no_sound" );
//	maps\invasion_anim::script_models();
//	thread maps\invasion_anim::animate_burning_tree();
//	thread maps\invasion_fx::tree_fire_light();
//	level thread smoke_mover();
}

init_fx()
{
	level._effect[ "objective_smoke" ]	 = loadfx( "smoke/signal_smoke_green" );
}

so_player_selection()
{
	if ( IsSplitScreen() || GetDvar( "coop" ) == "1" )
	{
		level.specops_character_selector = GetDvar( "coop_start" );
	}

///#
//	// Map Restart support. Restores the start dvar on map_restart since it gets reused.
//	if ( GetDvar( "start_backup" ) != "" )
//	{
//		SetDvar( "start", GetDvar( "start_backup" ) );
//	}
//
//	start_dvar = GetDvar( "start" );
//
//	if ( start_dvar == "test_chopper" )
//	{
//		level.specops_character_selector = start_dvar;
//		SetDvar( "start_backup", level.specops_character_selector );
//	}
//
//	if ( GetDvar( "debug_follow" ) == "" )
//	{
//		SetDvar( "debug_follow", "0" );
//	}
//#/

}

delete_turrets()
{
	foreach ( turret in GetEntArray( "misc_turret", "classname" ) )
	{
		turret Delete();
	}
}

so_chopper_invasion_spawner_functions()
{
	add_global_spawn_function( "axis", ::ai_post_spawn );
	array_thread( GetEntArray( "so_rpg_guys", "targetname" ), ::add_spawn_function, ::so_rpg_post_spawn );
}

so_chopper_invasion_init_flags()
{
	flag_init( "challenge_start" );
	flag_init( "challenge_end" );

	flag_init( "player_on_minigun" );

	flag_init( "so_rpg_run_away" );
	flag_init( "so_driveby_done" );
	flag_init( "so_start_end_path" );
}

so_chopper_invasion_precache()
{
	PreCacheItem( "mp5" );
	PreCacheModel( "vehicle_blackhawk_minigun_hero" );
	PrecacheVehicle( "blackhawk_minigun" );
	PreCacheShader( "hud_fofbox_self" );

	PrecacheVehicle( "blackhawk_minigun_so" );
	PrecacheShader( "remotemissile_infantry_target" );
}

start_so_chopper_invasion()
{
	// Don't unlink the players when mission is over. _specialops_code::specialops_mission_over_setup()
	flag_set( "special_op_no_unlink" );

	// Removes the ability to bleed out
	flag_clear( "coop_revive" );

	thread enable_escape_warning();
	thread enable_escape_failure();

	chopper_init();
	truck_init();

	// get level ready for play
	music_loop( "so_chopper_invasion_music", 140 );

	array_call( level.players, ::FreezeControls, true );
	thread fade_challenge_in( 2, false );
	wait( 2 );
	array_call( level.players, ::FreezeControls, false );

	// Time limit
	switch ( level.gameskill )
	{
		case 2:
			level.challenge_time_limit = 420;
			break;
		case 3:
			level.challenge_time_limit = 600;
			break;
		default:
			level.challenge_time_limit = 360;
			break;
	}

	thread enable_challenge_timer( "challenge_start", "challenge_end" );

	thread so_chopper_invasion_objectives();

	so_init_players();

	level thread friendlyfire();

	level.chopper thread chopper_think();
	level thread so_chopper_invasion_moments();

	flag_wait( "so_start" );
	flag_set( "challenge_start" );
}

so_chopper_invasion_moments()
{
	level thread chopper_driveby_trigger();
	level thread end();
	level thread parkinglot_trucks();
}

so_init_players()
{
	AssertEx( IsDefined( level.specops_character_selector ), "Failed to select character" );

	// test_chopper is intended to be used when in SP and testing only the CHOPPER
	if ( level.specops_character_selector == "test_chopper" )
	{
		level.chopperplayer = level.player;
		level.groundplayer 	= Spawn( "script_model", ( 0, 0, 0 ) );
		level.groundplayer SetModel( "tag_origin" );
	}
	else
	{
		AssertEx( IsDefined( level.players[ 1 ] ), "Second player does not exist, this level requires two players" );

		if ( level.specops_character_selector == "so_char_host" )
		{
			level.chopperplayer = level.players[ 0 ];
			level.groundplayer 	 = level.players[ 1 ];
		}
		else
		{
			level.groundplayer 	 = level.players[ 0 ];
			level.chopperplayer = level.players[ 1 ];
		}
	}

	level.chopper 		thread chopper_playermount( level.chopperplayer );

	// Don't show shells if in splitscreen
	if ( !IsSplitscreen() )
	{
		level.chopperplayer thread chopper_minigun_shells();
	}

	level.chopperplayer SetThreatBiasGroup( "chopperplayer" );
	level.chopperplayer.ignoreme = true;
	level.chopperplayer EnableDeathShield( true );

	foreach ( player in level.players )
	{
		if ( level.specops_character_selector != "test_chopper" )
		{
			player.coop.bleedout_time_default = 1.1; // guy on ground is an insta - kill
		}
	}
}

so_chopper_invasion_objectives()
{
	ref = getstruct( "so_end_of_level", "targetname" );
	// Link up with your partner at the extraction point.
	Objective_Add( 0, "current", &"SO_CHOPPER_INVASION_OBJ_REGULAR", groundpos( ref.origin ) );
}

empty()
{
}

chopper_init()
{
	level.chopper_funcs = [];
	level.chopper_funcs[ "so_start_driveby" ] 			= ::chopper_start_driveby;
	level.chopper_funcs[ "so_driveby_hover" ] 			= ::chopper_driveby_hover;
	level.chopper_funcs[ "so_end_lookat" ] 				= ::end_lookat;
	level.chopper_funcs[ "so_end_pickup" ] 				= ::end_pickup;
	level.chopper_funcs[ "so_end_fade" ] 				= ::end_fade;
	level.chopper_funcs[ "so_never_end" ] 				= ::never_end;
	level.chopper_funcs[ "so_gas_station_truck" ]		= ::gas_station_truck;
	level.chopper_funcs[ "so_gas_station_lookat" ]		= ::gas_station_lookat;
	level.chopper_funcs[ "so_guys_in_buildings" ]		= ::chopper_driveby_guys_in_buildings;
	level.chopper_funcs[ "so_less_roll" ]				= ::chopper_less_roll;
	level.chopper_funcs[ "so_guns_guns_guns" ]			= ::chopper_guns_guns_guns;
	level.chopper_funcs[ "so_last_driveby_point" ]		= ::empty;

	start = getstruct( "chopper_start", "targetname" );

	// NEW CHOPPER
	if ( 1 )
	{
		// remove the old
		chopper_spawner = GetEnt( "chopper", "targetname" );
		chopper_spawner.vehicletype = "blackhawk_minigun_so";
		chopper_spawner Delete();

		// Spawn in the new	
		chopper = SpawnVehicle( "vehicle_blackhawk_minigun_hero", "chopper", "blackhawk_minigun_so", start.origin, start.angles );
		chopper.vehicletype = "blackhawk_minigun_so";
	
		level thread maps\_vehicle::vehicle_init( chopper );
	}
	else
	{
		chopper = maps\_vehicle::spawn_vehicle_from_targetname( "chopper" );
		chopper Vehicle_Teleport( start.origin, start.angles );
	}

//	chopper Vehicle_Teleport( start.origin, start.angles );
	chopper.start = start;

	chopper maps\_vehicle::godon();
	chopper.defaultNearGoalNotifyDist = 400;

	chopper ent_flag_init( "manual_control" );

	chopper.repulsor = Missile_CreateRepulsorEnt( chopper, 10000, 1000 );

	level.chopper = chopper;
}

chopper_driveby_trigger()
{
	trigger_wait_targetname( "so_start_chopper_driveby" );

	chopper_dialog( "drive_by" );
	wait( 2 );

	level.chopper SetMaxPitchRoll( 20, 20 );
	level.chopper chopper_follow_path( "so_chopper_driveby", false );

	level.chopper chopper_defaults();
	level.chopper SetHoverParams( 10, 2, 1 );
	
	wait( 1 );

	struct = getstruct( "so_last_driveby_point", "script_noteworthy" );
	level.chopper SetVehGoalPOs( struct.origin, 1 );
	level.chopper SetHoverParams( 10, 2, 1 );
	level.chopper Vehicle_SetSpeed( 10, 2, 2 );
	level.chopper.speed_setting = "none";
	level.chopper thread chopper_fake_hover( struct.origin, 50 );

	flag_set( "so_driveby_done" );
//	level.chopper chopper_set_range_points( 14, 1 );
}

chopper_start_driveby()
{
	chopper_dialog( "start_drive_by" );
}

chopper_driveby_hover()
{
	self notify( "stop_chopper_gun_face_entity" );
	self ClearLookAtEnt();
	self thread chopper_gun_face_entity( getstruct( "chopper_driveby_start_target", "targetname" ) );

	self chopper_default_pitch_roll();
	self SetHoverParams( 10, 2, 1 );
//	wait( 10 );

	level thread chopper_driveby_rpg_guys();
	level waittill( "so_rpgs_shot" );
	chopper_dialog( "evade_rpgs" );
	wait( 1.5 );

	self notify( "stop_chopper_gun_face_entity" );
	self ClearLookAtEnt();
	self SetMaxPitchRoll( 20, 20 );
}

chopper_less_roll()
{
	chopper_dialog( "evade_extra" );
	level.chopper SetMaxPitchRoll( 10, 10 );
}

chopper_driveby_rpg_guys()
{
	array_spawn( GetEntArray( "so_rpg_guys", "targetname" ), true );
}

chopper_driveby_guys_in_buildings()
{
	chopper_dialog( "drive_by_payback" );

	if ( flag( "so_parkinglot_trucks" ) )
	{
		return;
	}

	thread array_spawn( GetEntArray( "so_guys_in_buildings", "targetname" ), true );
}

chopper_guns_guns_guns()
{
	chopper_dialog( "drive_by_guns_guns_guns" );
}

gas_station_truck()
{
	spawn_truck( "so_gas_station_truck" );
}

gas_station_lookat()
{
	self thread chopper_gun_face_entity( getstruct( "so_chopper_gasstation_lookat", "targetname" ) );
}

parkinglot_chopper()
{
	flag_wait( "so_driveby_done" );

	level.chopper notify( "stop_chopper_gun_face_entity" );
	level.chopper ClearLookAtEnt();
	level.chopper notify( "stop_chopper_fake_hover" );

	level.chopper.speed_setting = "force_default";
	level.chopper chopper_defaults();
	level.chopper.chopper_pathpoint = chopper_get_closest_pathpoint( 5 );

	if ( !flag( "so_start_end_path" ) )
	{
		level.chopper ent_flag_clear( "manual_control" );
	}

//	pos = chopper_get_pathpoint( level.chopper.chopper_pathpoint[ "index" ] );
//	angles = VectorToAngles( pos - level.chopper.origin );
//	level.chopper SetGoalYaw( angles[ 1 ] );

	level.chopper thread chopper_gun_face_entity( level.groundplayer, false, 2 );

	wait( 3 );
	level.chopper waittill( "chopper_near_goal" );
	level.chopper.speed_setting = "none";
}

parkinglot_trucks()
{
	flag_wait( "so_parkinglot_trucks" );
	level thread parkinglot_chopper();
	
	// Remove all of the AI that are really far away
	ais = GetAiArray( "axis" );
	killed_guys = [];
	foreach ( ai in ais )
	{
		if ( ai.origin[ 1 ] > 0 && IsAlive( ai ) )
		{
			killed_guys[ killed_guys.size ] = ai;
			ai Kill();
		}
	}

	wait( 2 );

	// Make sure they are removed
	foreach ( ai in killed_guys )
	{
		if ( IsDefined( ai ) )
		{
			ai Delete();
		}
	}

	spawn_truck( "so_parklinglot_truck1" );
	wait( 1 );
	chopper_dialog( "convoy" );

	level.chopper chopper_reset_range_points();

	spawn_truck( "so_parklinglot_truck2" );

	wait( 0.5 );
	// Guys behind Taco Togo
	thread array_spawn( GetEntArray( "so_post_gas_station_guys", "targetname" ) );

	wait( 3.5 );
	spawn_truck( "so_parklinglot_truck4" );

	chopper_dialog( "objective_reminder" );
}

end()
{
	trigger_wait_targetname( "so_prep_diner" );
	level thread end_go_to_diner();

	trigger_wait_targetname( "so_outside_diner" );
	chopper_dialog( "objective_reminder" );

	trigger_wait_targetname( "so_roof_ladder" );
	level thread end_spawners();

	flag_wait( "so_driveby_done" );

	chopper_dialog( "on_the_roof" );

	level.chopper SetMaxPitchRoll( 20, 20 );
	level.chopper SetHoverParams( 20, 2, 3 );

	// Figure out which point is closer along so_chopper_end_path, then follow it
	point = getstruct( "so_chopper_end_path", "targetname" );
	dist = DistanceSquared( level.chopper.origin, point.origin );
	closest = point;
	while ( IsDefined( point.target ) )
	{
		new_point = getstruct( point.target, "targetname" );
		new_dist = DistanceSquared( level.chopper.origin, new_point.origin );

		if ( new_dist < dist )
		{
			dist = new_dist;
			closest = new_point;
		}

		if ( IsDefined( new_point.script_noteworthy ) && new_point.script_noteworthy == "so_end_lookat" )
		{
			break;
		}

		point = new_point;
	}	

	// Now get the next on on the chain and make that the goal
	if ( IsDefined( closest.script_noteworthy ) && closest.script_noteworthy == "so_end_lookat" )
	{
		point = getstruct( closest.targetname, "targetname" );
	}
	else // The last point on the chain got selected
	{
		point = getstruct( closest.target, "targetname" );
	}

	flag_set( "so_start_end_path" );

	level.chopper thread chopper_follow_path( point.targetname, false, undefined, true );
	wait( 0.1 );
	level.chopper ClearLookAtEnt();
	level.chopper chopper_gun_face_entity( getstruct( "chopper_end_lookat", "targetname" ) );
}

end_spawners()
{
//	trigger_wait_targetname( "so_roof" );
	flag_wait( "so_roof" );
	level thread maps\_spawner::flood_spawner_scripted( GetEntArray( "so_end_spawners", "targetname" ) );

	// Wait for the guys_in_buildings to spawn in, then set their goals.
	wait( 0.1 );

	structs = getstructarray( "so_end_ai_points", "script_noteworthy" );
	foreach ( ai in GetAiArray( "axis" ) )
	{
		ai.target = structs[ RandomInt( structs.size ) ].targetname;
		ai thread ai_post_spawn();
	}
}

end_reminder()
{
	level endon( "challenge_end" );

	wait( 3 );

	trigger = GetEnt( "so_roof_check", "targetname" );
	while ( 1 )
	{
		if ( level.groundplayer IsTouching( trigger ) )
		{
			chopper_dialog( "end_reminder" );
		}

		wait( RandomFloatRange( 7, 10 ) );
	}
}

end_go_to_diner()
{
	// Tell everyone to go into the nate's diner
	ais = GetAiArray( "axis" );
	foreach ( ai in ais )
	{
		if ( !IsDefined( ai ) )
		{
			continue;
		}

		if ( !IsAlive( ai ) )
		{
			continue;
		}

		if ( IsDefined( ai.script_noteworthy ) && ai.script_noteworthy == "so_post_gas_station_guy" )
		{
			continue;
		}

		if ( IsDefined( ai.a.special ) && ai.a.special != "none" )
		{
			continue;
		}

		ai thread end_go_to_diner_thread();
	}
}

end_go_to_diner_thread()
{
	self endon( "death" );

	point = getstruct( "so_nates_diner_point", "targetname" );
	if ( DistanceSquared( point.origin, self.origin ) > 1500 * 1500 )
	{
		wait( RandomFloatRange( 0.1, 5 ) );
	}

	self ClearGoalVolume();
	self.goalradius = 600;
	self SetGoalPos( point.origin );

	flag_wait( "so_roof" );

	wait( RandomFloat( 1 ) );

	spots = getstructarray( "so_roof_spot", "targetname" );
	self SetGoalPos( spots[ RandomInt( spots.size ) ].origin );

	wait( 3 + RandomFloat( 5 ) );
	self.goalradius = 200;
}

end_lookat()
{
	level.chopper chopper_default_pitch_roll();
	Objective_String( 0, &"SO_CHOPPER_INVASION_OBJ_FINAL" );
	Objective_OnEntity( 0, level.chopper );

	// This is done when put on the path
//	self ClearLookAtEnt();
//	self thread chopper_gun_face_entity( getstruct( "chopper_end_lookat", "targetname" ) );
}

end_pickup()
{
	level thread end_reminder();
	level thread end_ai_monitor();

//	trigger_wait_targetname( "so_roof2" );
	struct = getstruct( "so_end_pickup", "script_noteworthy" );
	level.chopper thread chopper_fake_hover( struct.origin, 10, true );

	trigger = GetEnt( "so_end_jump_trigger", "targetname" );
	while ( !level.groundplayer IsTouching( trigger ) )
	{
		wait( 0.05 );
	}

	level.chopper notify( "stop_chopper_fake_hover" );

	if ( flag( "special_op_terminated" ) || flag( "challenge_timer_expired" ) || flag( "challenge_end" ) )
	{
		return;
	}

	end_challenge();

	maps\_spawner::killspawner( 901 );

	foreach ( player in level.players )
	{
		player EnableInvulnerability();
	}

	temp_tag = Spawn( "script_model", ( 0, 0, 0 ) );
	temp_tag SetModel( "tag_origin" );

//	// Fake Jump
//	tag_org = self GetTagOrigin( "tag_player" );
//	tag_angles = self GetTagAngles( "tag_origin" );
//	forward = AnglesToForward( tag_angles );
//	tag_org = tag_org + vector_multiply( forward, 40 );
//
//	angles = VectorToAngles( tag_org - level.groundplayer.origin );
//	forward = AnglesToForward( angles );
//	dist = Distance( tag_org, level.groundplayer.origin );
//	step_dist = dist / 5;
//	z = [];
//	z[ 0 ] = 2656;
//	z[ 1 ] = 2658;
//	z[ 2 ] = 2660;
//	z[ 3 ] = 2658;
//
//	speed = 230;
//	prev_vec = level.groundplayer.origin;
//
//	temp_tag.origin = level.groundplayer.origin;
//	level.groundplayer PlayerLinkTo( temp_tag, "tag_origin", 1 );
//	time = Distance( level.groundplayer.origin, tag_org ) / speed; 
//	temp_tag RotateTo( self GetTagAngles( "tag_player" ) + ( 0, -90, 0 ), time );
//
//	for ( i = 0; i < 4; i++ )
//	{
//		vec = level.groundplayer.origin + vector_multiply( forward, step_dist );
//		vec = ( vec[ 0 ], vec[ 1 ], z[ i ] );
//		time = Distance( prev_vec, vec ) / speed;
//		prev_vec = vec;
//
//		temp_tag MoveTo( vec, time );
//		wait( time - 0.05 );
//	}
//
//	tag_org = self GetTagOrigin( "tag_player" );
//	tag_angles = self GetTagAngles( "tag_origin" );
//	forward = AnglesToForward( tag_angles );
//
//	tag_org = tag_org + vector_multiply( forward, 40 );
//	time = Distance( tag_org, level.groundplayer.origin ) / speed;
//
//	temp_tag MoveTo( tag_org, time );
//	wait( time );
//	temp_tag LinkTo( self );

	// End Jump


//	temp_tag lerp_player_view_to_tag( level.groundplayer, "tag_origin", time, 1, 45, 45, 30, 30 );
	tag_org = self GetTagOrigin( "tag_player" );
	tag_angles = self GetTagAngles( "tag_origin" );
	forward = AnglesToForward( tag_angles );

	tag_org = tag_org + vector_multiply( forward, 40 );
	temp_tag.origin = tag_org;
	temp_tag.angles = tag_angles + ( 0, -90, 0 );
	temp_tag LinkTo( self );
	
	level.groundplayer PlayerLinkTo( temp_tag, "tag_origin", 1, 20, 45, 30, 30 );

	self SetMaxPitchRoll( 0, 0 );
	self notify( "stop_chopper_gun_face_entity" );
	self ClearLookAtEnt();

	wait( 1 );
}

end_ai_monitor()
{
	trigger = GetEnt( "so_roof_check", "targetname" );

	while( 1 )
	{
		wait( 0.5 );
		ais = GetAiArray( "axis" );

		alive_count = 0;
		foreach ( ai in ais )
		{
			if ( !IsAlive( ai ) )
			{
				continue;
			}

			if ( IsDefined( ai.a.special ) && ai.a.special == "dying_crawl" )
			{
				continue;
			}

			if ( !trigger IsTouching( ai ) )
			{
				continue;
			}
	
			alive_count++;
		}

		if ( alive_count == 0 && trigger IsTouching( level.groundplayer ) )
		{
			break;
		}
	}

	end_challenge( true );
}

end_fade()
{
	foreach ( player in level.players )
	{
		player.ignoreme = true;
	}

	if ( flag( "special_op_terminated" ) )
	{
		return;
	}

	thread fade_challenge_out();
}

end_challenge( finish_now )
{
	if ( flag( "challenge_end" ) || flag( "challenge_timer_expired" ) )
	{
		return;
	}

	level.challenge_end_time = GetTime();
	flag_set( "challenge_end" );
	objective_complete( 0 );

	if ( IsDefined( finish_now ) )
	{
		end_fade();
	}
}

never_end()
{
	level waittill( "never_end" );
}
