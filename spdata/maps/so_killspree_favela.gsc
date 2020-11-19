#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_killspree_favela_code;
#include maps\favela_code;

main()
{
	level.so_compass_zoom = "close";

	default_start( ::start_so_favela );
	add_start( "so_killspree", ::start_so_favela );
	
	maps\favela_precache::main();
	maps\favela_fx::main();
	maps\createart\favela_art::main();
	animscripts\dog\dog_init::initDogAnimations();
	maps\_hiding_door_anims::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_tf141" );	
	maps\_load::main();
	maps\favela_anim::main();
	thread maps\favela_amb::main();

	add_hint_string( "leaving_warning", &"SO_KILLSPREE_FAVELA_MISSION_FAILED_LEAVING_WARNING" );
	add_hint_string( "harmed_civilian", &"SO_KILLSPREE_FAVELA_DONT_HARM_CIVILIAN" );
	add_hint_string( "harmed_civilian_final", &"SO_KILLSPREE_FAVELA_DONT_HARM_CIVILIAN_FINAL" );
	
	flag_init( "challenge_success" );
	flag_init( "favela_enemies_spawned" );
	flag_init( "enemy_population_info_available" );
	flag_init( "detailed_enemy_population_info_available" );
	flag_init( "start_so_killspree_favela" );

	level.custom_eog_no_kills = true;
	level.custom_eog_no_partner = true;
	level.eog_summary_callback = ::custom_eog_summary;

	level.current_enemy_population 	= 0;
	level.civilian_killed = 0;
	foreach ( player in level.players )
	{
		player.civilians_killed = 0;
		player.dogs_killed = 0;
	}

	//thread random_favela_background_runners();
	
	maps\_compass::setupMiniMap( "compass_map_favela" );
}

delete_on_veteran()
{
	assert ( isdefined( level.gameskill ) );
	if ( level.gameskill != 3 )
		return;
		
	delete_ents = getentarray( "delete_on_veteran", "script_noteworthy" );
	foreach ( ent in delete_ents )
		ent delete();	
}

so_favela_setup_regular()
{
	level.challenge_objective = &"SO_KILLSPREE_FAVELA_OBJ_REGULAR";
	level.points_counter = 30;
	
	level.min_enemy_population		= 14;	// min enemies in level, refills a wave if drops below this number
	level.max_enemy_population		= 22;	// max enemies in level, before deleting
	level.max_dogs_at_once			= 0;	// max number of dogs alive at a time
	level.enemy_ambush_wave_size	= 6;	// ambush spawn wave size
	level.enemy_seek_wave_size		= 4;	// seek player spawn wave size
	level.civilian_kill_fail		= 6;	// civilian casualties allowed before failing mission
	
	level.ambush_to_seeker_delay	= 45;	// x + randomeint(x) seconds until ambushers seek out player
}

so_favela_setup_hardened()
{
	level.challenge_objective = &"SO_KILLSPREE_FAVELA_OBJ_HARDENED";
	level.points_counter = 40;
	
	level.min_enemy_population		= 14;	// min enemies in level, refills a wave if drops below this number
	level.max_enemy_population		= 22;	// max enemies in level, before deleting
	level.max_dogs_at_once			= 2;	// max number of dogs alive at a time
	level.enemy_ambush_wave_size	= 6;	// secondary spawn wave size
	level.enemy_seek_wave_size		= 4;	// seek player spawn wave size
	level.civilian_kill_fail		= 4;	// civilian casualties allowed before failing mission
	
	level.ambush_to_seeker_delay	= 40;	// x + randomeint(x) seconds until ambushers seek out player
}

so_favela_setup_veteran()
{
	delete_on_veteran();
		
	level.challenge_objective = &"SO_KILLSPREE_FAVELA_OBJ_VETERAN";
	level.points_counter = 50;
	
	level.min_enemy_population		= 12;	// min enemies in level, refills a wave if drops below this number
	level.max_enemy_population		= 20;	// max enemies in level, before deleting
	level.max_dogs_at_once			= 2;	// max number of dogs alive at a time
	level.enemy_ambush_wave_size	= 6;	// secondary spawn wave size, -1 unchanged
	level.enemy_seek_wave_size		= 4;	// seek player spawn wave size
	level.civilian_kill_fail		= 3;	// civilian casualties allowed before failing mission
	
	level.ambush_to_seeker_delay	= 40;	// x + randomeint(x) seconds until ambushers seek out player
}

so_favela_init()
{
	activate_trigger( "vision_shanty", "script_noteworthy" );
	
	// Remove unwanted weapons
	sentries = getentarray( "misc_turret", "classname" );
	foreach ( sentry in sentries )
		sentry Delete();
	stingers = getentarray( "weapon_stinger", "classname" );
	foreach ( stinger in stingers )
		stinger Delete();

	assert( isdefined( level.gameskill ) );

	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_favela_setup_Regular();	break;	// Regular
		case 2:	so_favela_setup_hardened();	break;	// Hardened
		case 3:	so_favela_setup_veteran();	break;	// Veteran
	}

	level.points_target = level.points_counter;
	
	thread music_loop( "so_killspree_favela_music", 274 );

	Objective_Add( 1, "current", level.challenge_objective );

	hunter_enemies_level_init();

	// add spawn func for enemy monitors
	add_global_spawn_function( "axis", ::hunter_init );
	level thread hunter_register_death();
	//add_global_spawn_function( "axis", ::ambush_to_seek );


	array_spawn_function( getSpawnerTeamArray( "neutral" ), ::civilian_register_death );
	
	// favela's original AI managment in shanty town
	array_spawn_function_noteworthy( "ignore_and_delete_on_goal", ::ignore_and_delete_on_goal );
	array_spawn_function_noteworthy( "delete_at_path_end", ::delete_ai_at_path_end );
	array_spawn_function_noteworthy( "delete_at_path_end_no_choke", ::delete_ai_at_path_end_no_choke );
	array_spawn_function_noteworthy( "seek_player", ::enemy_seek_player, 512 );
	array_spawn_function_noteworthy( "dog_seek_player", ::dog_seek_player );
	array_spawn_function_noteworthy( "delete_at_goal", ::delete_ai_at_goal );
//	array_spawn_function_noteworthy( "dont_see_player_no_choke", ::dont_see_player );
	array_spawn_function_noteworthy( "ignore_and_delete_on_goal", ::ignore_and_delete_on_goal );
	array_spawn_function_noteworthy( "window_smasher", ::window_smasher );
	array_spawn_function_noteworthy( "ignored_until_goal", ::ignored_until_goal );
	array_spawn_function_noteworthy( "desert_eagle_guy", ::desert_eagle_guy );
	array_spawn_function_noteworthy( "faust", ::faust_spawn_func );
	//array_thread( getentarray( "curtain_pulldown", "script_noteworthy" ), ::curtain_pulldown );
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_favela()
{
	so_favela_init();

	thread enable_escape_warning();
	thread enable_escape_failure();
	enable_challenge_timer( "start_so_killspree_favela", "challenge_success" );

	array_thread( level.players, ::hud_create_kill_counter );
	array_thread( level.players, ::hud_create_civ_counter );
	thread fade_challenge_in();
	thread fade_challenge_out( "challenge_success" );

	flag_wait( "start_so_killspree_favela" );
	wait 1;
	flag_set( "favela_enemies_spawned" );
	
	// set off favela enemy AIs
	original_roof_spawn_trig 	= getent( "favela_spawn_trigger", "script_noteworthy" );
	seeker_spawn_trig 			= getent( "so_favela_spawn_trigger", "script_noteworthy" );
	
	first_wave_trigs 			= [];
	first_wave_trigs[ 0 ] 		= seeker_spawn_trig;
	
	if( randomint( 100 ) > 66 )
		first_wave_trigs[ 1 ] 	= original_roof_spawn_trig;
	
	favela_spawn_ambush_trigger = getent( "so_favela_ambush_spawn_trigger", "script_noteworthy" );

	spawn_enemy_secondary_wave( favela_spawn_ambush_trigger, int( level.enemy_ambush_wave_size ) );
	spawn_enemy_secondary_wave( first_wave_trigs, int( level.enemy_seek_wave_size ) );
	

	wait 2;

	//thread enemy_population_watch( 0.5, 5 );	// ( delay, sampling interval in seconds, sampling buffer duration in seconds )
	/#
	thread enemy_type_monitor();
	#/
	
	thread release_doggy();
	thread doggy_attack();
	thread enemy_refill( 10, seeker_spawn_trig, favela_spawn_ambush_trigger );
	thread enemy_remove_when_max( 10 );
	thread battlechatter_on( "axis" );
}

// takes both array of triggers or just one
spawn_wave_by_trigger( trigger )
{
	foreach ( trig in trigger )
		trig notify( "trigger" );
}

spawn_enemy_secondary_wave( trigger, max_spawned )
{
	spawn_trig = [];
	if ( !isArray( trigger ) )
		spawn_trig[0] = trigger;
	else
		spawn_trig = trigger;

	if ( !isdefined( max_spawned ) || max_spawned < 0 )
	{
		spawn_wave_by_trigger( spawn_trig );
		return;
	}
		
	already_spawned = 0;
	spawn_trig = array_randomize( spawn_trig );
	
	foreach ( trig in spawn_trig )
	{
		spawner_targetname = trig.target;
		enemy_spawners 	= getentarray( spawner_targetname, "targetname" );
		enemy_spawners 	= array_randomize( enemy_spawners );

		foreach ( spawner in enemy_spawners )
		{
			if ( already_spawned <= max_spawned )
			{
				spawner.count = 1;
				guy = spawner spawn_ai();
				
				if ( !spawn_failed( guy ) )
					already_spawned++;
			}
		}
	}
}

enemy_refill( delay, seek_trigger, ambush_trigger )
{
	level endon( "special_op_terminated" );
	
	flag_wait( "enemy_population_info_available" );
	wait delay;

	while( 1 )
	{
		population_min_delta = level.min_enemy_population - level.current_enemy_population;
		
		if ( population_min_delta > 0 )
		{
			spawn_enemy_secondary_wave( ambush_trigger, int( population_min_delta ) );
			
			/*
			spawn_enemy_secondary_wave( seek_trigger, int( population_min_delta/2 ) );
			spawn_enemy_secondary_wave( ambush_trigger, int( population_min_delta/2 ) );
			*/
			wait 5;	
		}
		wait 0.05;
	}
}

enemy_remove_when_max( delay )
{
	level endon( "special_op_terminated" );

	flag_wait( "enemy_population_info_available" );
		
	while( 1 )
	{
		level waittill( "enemy_number_changed" );
		population_max_delta = level.max_enemy_population - level.current_enemy_population;
		
		if ( population_max_delta < 0 )
		{
			// delay to make sure AI count is not temp high
			wait delay;
			population_max_delta = level.max_enemy_population - level.current_enemy_population;
		}
		
		if ( population_max_delta < 0 )
		{
			enemies 	= getaiarray( "axis" );
			guys 		= [];
			
			for( i=0; i<abs( population_max_delta ); i++ )
			{
				idx = randomint( enemies.size );
				guys[ i ] = enemies[ idx ];
				enemies = array_remove_index( enemies, idx );
			}
			
			level thread AI_delete_when_out_of_sight( guys, 512 );
		}

	}	
}

/*	
enemy_population_watch( delay, sample_duration )
{
	population_data = [];
	// interval and sample_duration in seconds
	
	repeat = int( sample_duration / interval );
	
	while( 1 )
	{
		population_data[ population_data.size ] = getAiArray( "axis" ).size;
		
		while( population_data.size > repeat )
			population_data = queue_push( population_data );
		
		level.population_data = population_data;
		
		// avg population over duration
		sum = 0;
		foreach ( data in population_data )
			sum += data;

		level.current_enemy_population = int( sum/population_data.size );
		flag_set( "enemy_population_info_available" );
		
		wait interval;
	}
	
}*/

queue_push( array )
{
	newArray = [];
	for ( i = 1; i < ( array.size - 1 ); i++ )
		newArray[ newArray.size ] = array[ i ];
	
	return newArray;
}

doggy_attack()
{
	if ( level.max_dogs_at_once <= 0 )
		return;
		
	level endon( "special_op_terminated" );

	flag_wait( "enemy_population_info_available" );
	
	while ( 1 )
	{
		level waittill( "enemy_downed" );
		if ( should_release_dog() )
			level notify( "who_let_the_dogs_out" );
	}
}

should_release_dog()
{
	return ( ( level.points_counter % 10 ) == 0 );	// Every 10 kills let some puppies loose.
}

random_favela_background_runners()
{
	level endon( "special_op_terminated" );
	
	spawners = getentarray( "random_favela_background_runner", "targetname" );
	
	flag_wait( "favela_enemies_spawned" );
	
	for(;;)
	{
		spawners = array_randomize( spawners );
		foreach ( spawner in spawners )
		{
			spawner.count = 1;
			spawner thread spawn_ai( true );
			
			wait randomintrange( 4, 8 );
		}
	}
}

custom_eog_summary()
{
	foreach ( player in level.players )
	{
		player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", player.stats[ "kills" ] - player.dogs_killed );
		player add_custom_eog_summary_line( "@SO_KILLSPREE_FAVELA_KILLS_CIVILIANS", player.civilians_killed );
		if ( level.max_dogs_at_once > 0 )
			player add_custom_eog_summary_line( "@SO_KILLSPREE_FAVELA_KILLS_DOGS", player.dogs_killed );
			
		if ( is_coop_online() )
		{
			other_player = get_other_player( player );
			if ( level.max_dogs_at_once <= 0 )
				player maps\_endmission::use_custom_eog_default_difficulty( other_player );
			player maps\_endmission::use_custom_eog_default_kills( other_player );
		}
	}
}