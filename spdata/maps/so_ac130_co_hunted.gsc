#include common_scripts\utility;
#include maps\_utility;
#include maps\_ac130;
#include maps\co_ac130_code;
#include maps\_hud_util;
#include maps\_specialops;

CONST_specop_difficulty		= 50; // % of enemies seeking player's location, increased difficulty for spec op mission
CONST_laser_hint_timeout	= 25; // seconds

main()
{
	level.so_compass_zoom = "far";
	
	set_custom_gameskill_func( maps\_gameskill::solo_player_in_coop_gameskill_settings );
	
	// special ops character selection using dvar "start"
	level.specops_character_selector = "";
	if ( IsSplitScreen() || ( GetDvar( "coop" ) == "1" ) )
	{	
		level.specops_character_selector = getdvar( "coop_start" );
	}
	
	default_start( ::start_specop );
	set_default_start( "so" );
	add_start( "so",	::start_specop, 	"[so] -> spec op gameplay" );
	
	level.default_goalradius = 2048;
	level.default_goalheight = 512;

	setDvarIfUninitialized( "no_respawn", "1" );
	setDvarIfUninitialized( "do_saves", "0" );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	// lets the ac130 specific friendly fire warnings play uninterrupted .
	friendlyfire_warnings_off();

	precacheLevelStuff();
	vehicleScripts();

	if ( level.console )
		level.hint_text_size = 1.6;
	else
		level.hint_text_size = 1.2;

	precacheShader( "dpad_laser_designator" );

	precacheShader( "waypoint_targetneutral" );
	precacheShader( "waypoint_checkpoint_neutral_a" );
	precacheShader( "waypoint_checkpoint_neutral_b" );
	precacheShader( "waypoint_checkpoint_neutral_c" );
	precacheShader( "waypoint_checkpoint_neutral_d" );
	precacheShader( "waypoint_checkpoint_neutral_e" );
	// Checkpoint A: 
	precachestring( &"CO_HUNTED_TIME_TILL_CHECKPOINT_A" );
	// Checkpoint B: 
	precachestring( &"CO_HUNTED_TIME_TILL_CHECKPOINT_B" );
	// Checkpoint C: 
	precachestring( &"CO_HUNTED_TIME_TILL_CHECKPOINT_C" );
	// Checkpoint D: 
	precachestring( &"CO_HUNTED_TIME_TILL_CHECKPOINT_D" );
	// Reach targe in:
	precachestring( &"SO_AC130_HUNTED_SPECOP_TIMER" );
	// Cross the bridge in: 
	precachestring( &"CO_HUNTED_TIME_TILL_EXPLOSION" );
	// Mission failed. Enemy destroyed the bridge.
	precachestring( &"CO_HUNTED_TIMER_EXPIRED" );
	// Mission failed. You ran out of time.
	precachestring( &"SO_AC130_CO_HUNTED_TIMER_EXPIRED_SPECOP" );
	// Cross the bridge to safety before it is destroyed.
	precachestring( &"CO_HUNTED_OBJ_CROSS_BRIDGE" );
	// Reach the checkpoint at the barn.
	precachestring( &"CO_HUNTED_OBJ_REACH_BARN" );	
	// Checkpoint A time expired.
	precachestring( &"CO_HUNTED_MISSED_CHECKPOINT_A" );
	// Checkpoint B time expired.
	precachestring( &"CO_HUNTED_MISSED_CHECKPOINT_B" );
	// Checkpoint C time expired.
	precachestring( &"CO_HUNTED_MISSED_CHECKPOINT_C" );
	// Checkpoint D time expired.
	precachestring( &"CO_HUNTED_MISSED_CHECKPOINT_D" );
	// Press ^3[{weapnext}]^7 to cycle through weapons.
	precachestring( &"AC130_HINT_CYCLE_WEAPONS" );
	// Press ^3[{+actionslot 4}]^7 to use toggle laser targeting device.
	precachestring( &"CO_HUNTED_HINT_LASER" );
	
	maps\_truck::main( "vehicle_pickup_roobars" );
	level.weaponClipModels = [];
	level.weaponClipModels[ 0 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 1 ] = "weapon_m16_clip";
	
	// player 1 is ac130 gunner in coop games
	//level.ac130gunner = level.player;
	maps\co_hunted_fx::main();
	maps\co_hunted_precache::main();
	maps\_load::main();
	maps\_compass::setupMiniMap( "compass_map_hunted" );

	array_thread( getentarray( "noprone", "targetname" ), ::noprone );

	// Press ^3[{weapnext}]^7 to cycle through weapons.
	add_hint_string( "ac130_changed_weapons", &"AC130_HINT_CYCLE_WEAPONS", ::ShouldBreakAC130HintPrint );
	
	// Press ^3[{+actionslot 4}]^7 to use toggle laser targeting device.
	add_hint_string( "laser_hint", &"CO_HUNTED_HINT_LASER", ::ShouldBreakLaserHintPrint );
}

gameplay_logic( gametype )
{	
	if( !isdefined( gametype ) )
		gametype = "default";
	
	flag_init( "timer_expired" );
	flag_init( "specop_challenge_completed" );

	thread fade_challenge_in();

	array_call( GetSpawnerTeamArray( "allies" ), ::delete );
	array_call( GetAIArray("allies"), ::delete );	
	
	enemies = getspawnerteamarray( "axis" );
	array_thread( enemies, ::add_spawn_function, ::set_thermal_LOD );
	array_thread( enemies, ::add_spawn_function, ::kill_after_time, 60 );

	maps\co_ac130_anim::main();
	maps\co_ac130_snd::main();

	level.ac130_flood_respawn = true;
	maps\_nightvision::main( level.players );
	maps\_ac130::init();// pops up the menu and sets who level.ac130gunner is
	thread maps\co_hunted_amb::main();

	if ( level.player == level.ac130gunner )
		level.ground_player = level.player2;
	else
		level.ground_player = level.player;

	level.ground_player thread add_beacon_effect();
	level.ground_player thread hint_timeout();
	level.ground_player ent_flag_init( "player_used_laser" );
	level thread laser_targeting_device( level.ground_player );
	level.ground_player thread display_hint( "laser_hint" );

	// this removes the green arrow pointing to the ac130.
	level.ground_player.noFriendlyHudIcon = true;	
	
	level.ground_player set_vision_set_player( "hunted", 0 );

	move_ac130 = getentarray( "move_ac130", "targetname" );
	array_thread( move_ac130, ::move_ac130_think );

	level.ac130gunner laserForceOn();
	thread ac130_change_weapon_hint();

	wait 0.1;
	flag_clear( "coop_revive" );
	flag_set( "clear_to_engage" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	music_loop( "so_ac130_co_hunted_music", 167 );
	
	// Start
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );

	thread open_all_doors();
	thread enemy_monitor();
	
	thread timer_start();
		
	thread objective( gametype );

	delete_vehicle_nodes = getentarray( "delete_vehicle", "script_noteworthy" );
	array_thread( delete_vehicle_nodes, ::delete_vehicle_think );

	thread move_enemies_to_closest_goal_radius( gametype );
	thread initial_ac130_move();

}
//	****** Starts ****** //
start_ac130()
{
	thread gameplay_logic( "default" );
}

start_specop()
{	
	thread gameplay_logic( "specop" );

	flag_wait( "leaving_crash_site" );

	// These enable the dialogue for the AC130 to begin
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
}

initial_ac130_move()
{
	level endon( "ac130_reposition" );
	wait 5;
	ent = getent( "initial_ac130_location", "targetname" );
	thread movePlaneToPoint( ent.origin );
}

move_enemies_to_closest_goal_radius( gametype )
{
	level endon( "specop_challenge_completed" );
	
	goals = getentarray( "enemy_goal_radius", "targetname" );
	level.current_goal = getclosest( level.ground_player.origin, goals );

	level.hunter_enemies = [];
	spawners = getspawnerarray();
	array_thread( spawners, ::add_spawn_function, ::create_hunter_enemy );

	if ( gametype == "specop" )
		move_deadlier_hunters_to_new_goal( level.current_goal );
	else
		move_hunters_to_new_goal( level.current_goal );

	while ( 1 )
	{
		closest_goal = getclosest( level.ground_player.origin, goals );
		//only goal enemies to one of the players and assume they stay together
		if ( level.current_goal != closest_goal )
		{
			level.current_goal = closest_goal;
			
			if ( gametype == "specop" )
				move_deadlier_hunters_to_new_goal( closest_goal );
			else
				move_hunters_to_new_goal( closest_goal );
		}
		wait 1;
	}
}

create_hunter_enemy()
{
	if ( self.team != "axis" )
		return;
	level.hunter_enemies[ self.unique_id ] = self;
	self setgoalpos( level.current_goal.origin );

	self waittill( "death" );

	level.hunter_enemies[ self.unique_id ] = undefined;
}

move_hunters_to_new_goal( closest_goal )
{
	waittillframeend;
	//waittillframeend because you may be in the part of the frame that is before 
	//the script has received the "death" notify but after the AI has died.

	foreach ( enemy in level.hunter_enemies )
		enemy setgoalpos( closest_goal.origin );
}

move_deadlier_hunters_to_new_goal( closest_goal )
{
	waittillframeend;
	//Sent half the enemies to player, and the other half to set goal, 

	foreach ( enemy in level.hunter_enemies )
	{
		if ( RandomInt( 100 ) < CONST_specop_difficulty ) 
			enemy setgoalpos( closest_goal.origin );
		else
			enemy setgoalentity( level.ground_player );
	}
}

ShouldBreakAC130HintPrint()
{
	return flag( "player_changed_weapons" );
}

hint_timeout()
{
	//self is ground player
	self.hint_timeout = CONST_laser_hint_timeout; // seconds
	while ( self.hint_timeout > -1 )
	{
		self.hint_timeout--;
		wait 1;
	}
}

ShouldBreakLaserHintPrint()
{	
	if( !isdefined( level.ground_player ) )
		return false;
	else if( isdefined( level.ground_player.hint_timeout ) && level.ground_player.hint_timeout <= 0 )
		return true;
	else
		return level.ground_player ent_flag( "player_used_laser" );
}

ac130_change_weapon_hint()
{
	wait 12;
	if ( !flag( "player_changed_weapons" ) )
		level.ac130gunner thread display_hint( "ac130_changed_weapons" );
		// Press ^3[{weapnext}]^7 to cycle through weapons.
		//hintPrint_coop( &"AC130_HINT_CYCLE_WEAPONS" );
}


hintPrint_coop( string )
{
	hint = hint_create( string, true, 0.8 );
	wait 5;
	hint hint_delete();
}

delete_vehicle_think()
{
	while ( true )
	{
		self waittill( "trigger", vehicle );
		vehicle delete();
	}
}

move_ac130_think()
{
	self waittill( "trigger" );

	point = ( getent( self.target, "targetname" ) ).origin;

	thread movePlaneToPoint( point );
}


open_all_doors()
{
	array_thread( getentarray( "doorknob", "targetname" ), ::doorknob );

	door = getent( "farmer_front_door", "targetname" );
	door rotateyaw( 95, 0.7, 0.5, 0.2 );
	door connectpaths();

	gate = getent( "creek_gate", "targetname" );
	gate hunted_style_door_open( "door_gate_chainlink_slow_open" );
}

doorknob()
{
	ent = getent( self.target, "targetname" );
	self linkto( ent );
}

enemy_monitor()
{
	flag_wait( "leaving_crash_site" );

	level.enemy_force = [];
	level.enemy_force[ 0 ] = spawnstruct();
	level.enemy_force[ 0 ].name = "lone_barn_spawners";
	level.enemy_force[ 0 ].type = "spawners";

	level.enemy_force[ 1 ] = spawnstruct();
	level.enemy_force[ 1 ].name = "down_road_spawners";
	level.enemy_force[ 1 ].type = "spawners";

	level.enemy_force[ 2 ] = spawnstruct();
	level.enemy_force[ 2 ].name = "first_field_heli_drop";
	level.enemy_force[ 2 ].type = "multi_use_vehicle";

	level.enemy_force[ 3 ] = spawnstruct();
	level.enemy_force[ 3 ].name = "second_field_heli_drop";
	level.enemy_force[ 3 ].type = "multi_use_vehicle";
	
	level.enemy_force[ 4 ] = spawnstruct();
	level.enemy_force[ 4 ].name = "pickup_rightside_bridge";
	level.enemy_force[ 4 ].type = "one_use_vehicle";
	level.enemy_force[ 4 ].drove = false;

	level.enemy_force[ 5 ] = spawnstruct();
	level.enemy_force[ 5 ].name = "pickup_leftside_starting_bridge";
	level.enemy_force[ 5 ].type = "one_use_vehicle";
	level.enemy_force[ 5 ].drove = false;

	//respawns
	level.enemy_force[ 6 ] = spawnstruct();
	level.enemy_force[ 6 ].name = "farmers_house_spawners";
	level.enemy_force[ 6 ].type = "spawners";

	level.enemy_force = array_randomize( level.enemy_force );

	// make sure farmers_house guys always spawn in first.
	farmers_house_struct = spawnstruct();
	farmers_house_struct.name = "farmers_house_spawners";
	farmers_house_struct.type = "spawners";
	level.enemy_force = array_insert( level.enemy_force, farmers_house_struct ,0 );

	level.selection = 0;

	thread enemy_monitor_loop();

	flag_wait( "leaving_creek" );

	level.enemy_force = [];

	level.enemy_force[ 0 ] = spawnstruct();
	level.enemy_force[ 0 ].name = "back_left_side_spawners";
	level.enemy_force[ 0 ].type = "spawners";

	level.enemy_force[ 1 ] = spawnstruct();
	level.enemy_force[ 1 ].name = "front_left_side_spawners";
	level.enemy_force[ 1 ].type = "spawners";

	level.enemy_force[ 2 ] = spawnstruct();
	level.enemy_force[ 2 ].name = "pickup_leftside_fields";
	level.enemy_force[ 2 ].type = "one_use_vehicle";
	level.enemy_force[ 2 ].drove = false;

	level.enemy_force[ 3 ] = spawnstruct();
	level.enemy_force[ 3 ].name = "cellar_field_heli_drop";
	level.enemy_force[ 3 ].type = "multi_use_vehicle";

	level.enemy_force = array_randomize( level.enemy_force );

	// make sure cellar guys always spawn in first.
	cellar_struct = spawnstruct();
	cellar_struct.name = "cellar_house_spawners";
	cellar_struct.type = "spawners";
	level.enemy_force = array_insert( level.enemy_force, cellar_struct ,0 );

	level.selection = 0;

	flag_wait( "at_cellar" );

	level.enemy_force = [];
	level.enemy_force[ 0 ] = spawnstruct();
	level.enemy_force[ 0 ].name = "work_shop_spawners";
	level.enemy_force[ 0 ].type = "spawners";

	level.enemy_force[ 1 ] = spawnstruct();
	level.enemy_force[ 1 ].name = "garage_spawners";
	level.enemy_force[ 1 ].type = "spawners";

	level.enemy_force[ 2 ] = spawnstruct();
	level.enemy_force[ 2 ].name = "shed_spawners";
	level.enemy_force[ 2 ].type = "spawners";

	level.enemy_force[ 3 ] = spawnstruct();
	level.enemy_force[ 3 ].name = "over_creek_heli_drop";
	level.enemy_force[ 3 ].type = "multi_use_vehicle";

	level.enemy_force = array_randomize( level.enemy_force );
	level.selection = 0;

	spawn_enemy_group();
	spawn_enemy_group();

	flag_wait( "exit_work_shops" );

	level.enemy_force = [];
	level.enemy_force[ 0 ] = spawnstruct();
	level.enemy_force[ 0 ].name = "pickup_leftside_greenhouses";
	level.enemy_force[ 0 ].type = "one_use_vehicle";
	level.enemy_force[ 0 ].drove = false;

	level.enemy_force[ 1 ] = spawnstruct();
	level.enemy_force[ 1 ].name = "windmill_field_heli_drop";
	level.enemy_force[ 1 ].type = "multi_use_vehicle";

	level.enemy_force[ 2 ] = spawnstruct();
	level.enemy_force[ 2 ].name = "white_fence_heli_drop";
	level.enemy_force[ 2 ].type = "multi_use_vehicle";

	level.enemy_force[ 3 ] = spawnstruct();
	level.enemy_force[ 3 ].name = "barn_spawners";
	level.enemy_force[ 3 ].type = "spawners";

	level.enemy_force[ 4 ] = spawnstruct();
	level.enemy_force[ 4 ].name = "pickup_leftside_bridge";
	level.enemy_force[ 4 ].type = "one_use_vehicle";
	level.enemy_force[ 4 ].drove = false;

	level.enemy_force[ 5 ] = spawnstruct();
	level.enemy_force[ 5 ].name = "pickup_from_barn";
	level.enemy_force[ 5 ].type = "one_use_vehicle";
	level.enemy_force[ 5 ].drove = false;

	level.enemy_force = array_randomize( level.enemy_force );
	level.selection = 0;

	spawn_enemy_group();
	spawn_enemy_group();

	flag_wait( "mid_wind_mill_field" );

	level.enemy_force = [];
	level.enemy_force[ 0 ] = spawnstruct();
	level.enemy_force[ 0 ].name = "green_house_heli_drop";
	level.enemy_force[ 0 ].type = "one_use_vehicle";
	level.enemy_force[ 0 ].drove = false;

	level.enemy_force[ 1 ] = spawnstruct();
	level.enemy_force[ 1 ].name = "silo_spawners";
	level.enemy_force[ 1 ].type = "spawners";

	level.enemy_force[ 2 ] = spawnstruct();
	level.enemy_force[ 2 ].name = "barn_spawners";
	level.enemy_force[ 2 ].type = "spawners";

	level.enemy_force[ 3 ] = spawnstruct();
	level.enemy_force[ 3 ].name = "gas_station_spawners";
	level.enemy_force[ 3 ].type = "spawners";

	level.enemy_force = array_randomize( level.enemy_force );
	level.selection = 0;

	spawn_enemy_group();
	spawn_enemy_group();
}


spawn_enemy_group()
{
	if ( level.selection >= level.enemy_force.size )
	{
		if ( getdvar( "no_respawn", 1 ) == "1" )
			return;
		else
			level.selection = 0;
	}
	s_name = level.enemy_force[ level.selection ].name;
	s_number = level.selection;
	level.selection++ ;


	if ( level.enemy_force[ s_number ].type == "one_use_vehicle" )
	{
		if ( level.enemy_force[ s_number ].drove )
			return;
		vehicle = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( s_name );
		level.enemy_force[ s_number ].drove = true;
		return;
	}

	if ( level.enemy_force[ s_number ].type == "multi_use_vehicle" )
	{
		vehicle = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( s_name );
		return;
	}

	enemy_spawners = getentarray( s_name, "targetname" );
	for ( i = 0 ; i < enemy_spawners.size ; i++ )
		guy = enemy_spawners[ i ] spawn_ai();

	wait 1;// make sure the spawning is done before checking to see how many are spawned
}



enemy_monitor_loop()
{
	while ( true )
	{
		enemies = getaiarray( "axis" );
		total = enemies.size;
		roaming = total;

		for ( i = 0 ; i < enemies.size ; i++ )
			if ( isdefined( enemies[ i ].script_noteworthy ) )
				if ( enemies[ i ].script_noteworthy == "defender" )
					roaming -- ;

		println( "                roaming/total: " + roaming + "/" + total );
		if ( roaming < 13 )
			spawn_enemy_group();
		wait 1;
	}
}

timer_start( gametype )
{
	dialogue_line = undefined;
	iSeconds = undefined;

	switch( level.gameSkill )
	{
		case 0:// easy
		case 1:// regular
			level.challenge_time_limit = 210; //3:30 min
			break;
		case 2:// hardened
			level.challenge_time_limit = 300; //5:00 min
			break;
		case 3:// veteran
			level.challenge_time_limit = 420; //7:00 min
			break;
	}
	assert( isdefined( level.challenge_time_limit ) );

	// Causes the player monitor to short circuit and not allow them to toggle them on and off.
	foreach ( player in level.players )
		player.so_infohud_toggle_state = "none";
	enable_challenge_timer(  "leaving_crash_site", "specop_challenge_completed" );

	// Offset the time so it doesn't interfere with the ac130 hud
	level.ac130player.hud_so_timer_msg.x -= 50;
	level.ac130player.hud_so_timer_time.x -= 50;

	if ( IsSplitScreen() )
	{
		level.ac130player.hud_so_timer_msg.y = 0;
		level.ac130player.hud_so_timer_time.y = 0;
	}
}

player_death_effect()
{
	player = level.player;
	playfx( level._effect[ "player_death_explosion" ], player.origin );

	earthquake( 1, 1, level.player.origin, 100 );
}

objective( gametype )
{
	level endon( "special_op_terminated" );

	assert( gametype == "specop" && is_coop() );

	checkpoint_ent = undefined;
	flag_name = undefined;
	volume = undefined;

	switch( level.gameskill )
	{
		case 2:
			objective_add( 1, "current", &"SO_AC130_CO_HUNTED_OBJ_HARDENED" );
			checkpoint_ent = getent( "checkpoint_c", "targetname" );
			flag_name = "checkpoint_c";
			break;
		case 3:
			objective_add( 1, "current", &"SO_AC130_CO_HUNTED_OBJ_VETERAN" );
			checkpoint_ent = getent( "checkpoint_barn", "targetname" );
			flag_name = "checkpoint_barn";
			break;
		default:
			objective_add( 1, "current", &"SO_AC130_CO_HUNTED_OBJ_REGULAR" );
			checkpoint_ent = getent( "checkpoint_b", "targetname" );
			flag_name = "checkpoint_b";
			break;
	}

	objective_position( 1, checkpoint_ent.origin );

	flag_wait( flag_name );

	objective_state( 1, "done" );

	level notify( "specop_challenge_completed" );
	flag_set( "specop_challenge_completed" );
	array_call( GetAIArray(), ::delete );

	flag_clear( "allow_context_sensative_dialog" );

	thread fade_challenge_out();
}

threeD_objective_hint( shader, destroyer_msg )
{
	self.icon = NewHudElem();
	//self.icon SetShader( "waypoint_targetneutral", 1, 1 );
	self.icon SetShader( shader, 1, 1 );
	self.icon.alpha = .5;
	self.icon.color = ( 1, 1, 1 );
	//comm_center.icon SetTargetEnt( comm_center );
	origin = self getOrigin();
	self.icon.x = origin[ 0 ];
	self.icon.y = origin[ 1 ];
	self.icon.z = origin[ 2 ];
	self.icon SetWayPoint( false, true );

	if ( isdefined( destroyer_msg ) )
	{
		level waittill( destroyer_msg );

		self.icon destroy();
	}
}

kill_after_time( time )
{
	wait( time );
	if ( isalive( self ) )
		self kill();
}

set_thermal_LOD()
{
	self ThermalDrawEnable();
}

draw_ground_player_facing()
{
	color = ( 1, 1, 1 );

	while ( 1 )
	{
		forward = AnglesToForward( level.ground_player.angles );
		forwardfar = vector_multiply( forward, 200 );
		forwardclose = vector_multiply( forward, 100 );
		start = forwardclose + level.ground_player.origin;
		end = forwardfar + level.ground_player.origin;
		draw_arrow_ac130( start, end, color );
		wait .05;
	}
}


draw_arrow_ac130( start, end, color )
{
	pts = [];
	angles = vectortoangles( start - end );
	right = anglestoright( angles );
	forward = anglestoforward( angles );

	dist = distance( start, end );
	arrow = [];
	range = 0.5;
	arrow[ 0 ] =  start;
	arrow[ 1 ] =  start + vector_multiply( right, dist * ( range ) ) + vector_multiply( forward, dist * - 0.2 );
	arrow[ 2 ] =  end;
	arrow[ 3 ] =  start + vector_multiply( right, dist * ( -1 * range ) ) + vector_multiply( forward, dist * - 0.2 );

	line( arrow[ 0 ], arrow[ 2 ], color, 1.0 );
	line( arrow[ 2 ], arrow[ 1 ], color, 1.0 );
	line( arrow[ 2 ], arrow[ 3 ], color, 1.0 );

}

noprone()
{
	while ( true )
	{
		self waittill( "trigger", player );

		if ( !isdefined( player ) )
			continue;

		if ( !isplayer( player ) )
			continue;
	
		while ( player IsTouching( self ) )
		{
			player AllowProne( false );
			wait( 0.05 );
		}
		player AllowProne( true );
	}
}