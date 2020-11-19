#include common_scripts\utility;
#include maps\_utility;
#include maps\airport_code;

spawn_smoke( smoke_tag, smoke_trigger, smoke_pause )
{
	trigger_wait( smoke_trigger, "targetname" );

	if ( !isdefined( smoke_pause ) )
		smoke_pause = 1.0;
	
	smoke_spots = getstructarray( smoke_tag, "targetname" );
	foreach ( spot in smoke_spots )
		MagicGrenadeManual( "smoke_grenade_american", spot.origin, (0,0,-1), randomfloat( smoke_pause ) );
}

shoot_out_glass()
{
	trigger_wait( "shoot_out_glass", "targetname" );
	
	activate_trigger( "enemy_dining_area_riot_movein_trig" , "targetname" );

	start = getstruct( "shoot_out_glass_start", "script_noteworthy" );
	ends = getstructarray( "shoot_out_glass_end", "script_noteworthy" );
	combat_start = undefined;
	foreach( end in ends )
	{
		shots = randomintrange( 5, 8 );
		for ( j = 0; j < shots; j++ )
		{
			BulletTracer( start.origin, end.origin, true );
			MagicBullet( "m240", start.origin, end.origin );
			wait randomfloatrange( 0.05, 0.1 );
		}
		wait 1;
	}
}

enemy_register()
{
	thread enemy_override_bc();
}

enemy_override_bc()
{
	while ( !isdefined( self.chatinitialized ) && !self.chatinitialized )
		wait 0.05;
	
	self.countryid = "RU";
}

enemy_ignore_cover()
{
	self.combatmode = "no_cover";
}

enemy_seek_player( goalradius, delay )
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	// accuracy tweak
//	self.baseaccuracy *= level.seeker_accuracy_nerf;
	
	if ( isdefined( delay ) )
		wait delay;
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );
	
	enemy_update_target( get_closest_player_healthy( self.origin ) );
	self.goalradius = goalradius;
	self.goalheight = 256;	// Force them to stay on the same level as the player.
	
	if ( is_coop() )
		thread enemy_evaluate_goal();
}

enemy_evaluate_goal()
{
	level endon( "special_op_terminated" );
	self endon( "death" );

	while ( 1 )
	{
		wait 0.5;
		
		// If our guy is down, automatically go after the other player.
		if ( self.current_goal_player isplayerdown() )
		{
			enemy_update_target( get_other_player( self.current_goal_player ) );
			continue;
		}

		wait 5;

		// See if someone else is closer now...
		closest_player = get_closest_player_healthy( self.origin );
		if ( closest_player == self.current_goal_player )
			continue;
			
		// Only update if they are far enough apart to matter.			
		player_dist = distance( closest_player.origin, self.current_goal_player.origin );
		if ( player_dist < 256 )
			continue;

		enemy_update_target( closest_player );
	}
}

enemy_update_target( new_target )
{
	self.current_goal_player = new_target;
	self setgoalentity( new_target );
}

enemy_move_to_struct( trig, seek_goal_radius, stay, duration )
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "woken_up" );

	self.baseaccuracy = 1.0;
	self setgoalpos( self.origin );
	self.goalradius = 16;
	self disable_exits();
	self.ignoreall = true;

	trigger_name = undefined;
	if ( isdefined( trig ) )
		trigger_name = trig + "_movein_trig";
			
	// wait till player hits move in trigger or takes damage
	thread enemy_move_to_struct_detect_damage( seek_goal_radius, stay, duration, trigger_name );
	
	if( isdefined( trigger_name ) )
		trigger_wait( trigger_name, "targetname" );

	thread enemy_move_to_struct_wakeup( seek_goal_radius, stay, duration );	
}

enemy_move_to_struct_detect_damage( seek_goal_radius, stay, duration, trigger_name )
{
	level endon( "special_op_terminated" );
//	self endon( "death" );
	self endon( "woken_up" );

	self waittill_any( "damage", "death" );

	if ( isdefined( trigger_name ) )
		activate_trigger( trigger_name, "targetname" );
		
	if ( isalive( self ) )
		thread enemy_move_to_struct_wakeup( seek_goal_radius, stay, duration );
}

enemy_move_to_struct_wakeup( seek_goal_radius, stay, duration )
{
	self notify( "woken_up" );

	self.ignoreall = false;
	node = getnode( self.target, "targetname" );
	if( !isdefined( node ) )
		node = getstruct( self.target, "targetname" );
	
	goal_type = undefined;
	//only nodes and structs dont have classnames - ents do
	if ( !isdefined( node.classname ) )
	{
		//only structs don't have types, nodes do
		if ( !isdefined( node.type ) )
			goal_type = "struct";
		else
			goal_type = "node";
	}
	else
	{
		goal_type = "origin";
	}

	//calling this because i DO want the radius to explode	
	require_player_dist = 300;
	self thread maps\_spawner::go_to_node( node, goal_type, undefined, require_player_dist );
	
	wait 1;
	self enable_exits();
	
	if( isdefined( stay ) && stay && isdefined( duration ) )
		thread enemy_seek_player( seek_goal_radius, duration );
	else
		thread enemy_seek_player( seek_goal_radius );
}

enemy_prone_to_stand( trig, seek_goal_radius, stay, duration )
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "woken_up" );
	
	self.ignoreall = true;
	self setgoalpos( self.origin );
	self.goalradius = 16;
	self disable_exits();

	wait 0.05;
	self allowedstances( "prone" );
	self thread maps\_anim::anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );

	trigger_name = undefined;
	if ( isdefined( trig ) )
		trigger_name = trig + "_movein_trig";
			
	// wait till player hits move in trigger or takes damage
	thread enemy_prone_to_stand_detect_damage( seek_goal_radius, stay, duration, trigger_name );
	if( isdefined( trigger_name ) )
		trigger_wait( trigger_name, "targetname" );

	thread enemy_prone_to_stand_wakeup( seek_goal_radius, stay, duration );
}


enemy_prone_to_stand_detect_damage( seek_goal_radius, stay, duration, trigger_name )
{
	level endon( "special_op_terminated" );
//	self endon( "death" );
	self endon( "woken_up" );
	
	self waittill_any( "damage", "death" );

	if ( isdefined( trigger_name ) )
		activate_trigger( trigger_name, "targetname" );

	if ( isalive( self ) )		
		thread enemy_prone_to_stand_wakeup( seek_goal_radius, stay, duration );
}

enemy_prone_to_stand_wakeup( seek_goal_radius, stay, duration )
{
	self notify( "woken_up" );
	
	self.ignoreall = false;
	self allowedstances( "stand", "crouch", "prone" );
	self enable_exits();
	
	if( isdefined( stay ) && stay && isdefined( duration ) )
		thread enemy_seek_player( seek_goal_radius, duration );
	else
		thread enemy_seek_player( seek_goal_radius );
}

past_enemy_remove( enemy_group, num )
{
	flag_wait( enemy_group + "_kill" );

	enemy_array = getaiarray( "axis" );
	guys_to_delete = [];
	foreach ( guy in enemy_array )
		if ( isdefined( guy.script_noteworthy ) && guy.script_noteworthy == enemy_group )
			guys_to_delete[ guys_to_delete.size ] = guy;	
	
	if( isdefined( num ) && ( num > 0 ) && ( num < guys_to_delete.size ) )
	{
		random_guys_to_delete = array_randomize( guys_to_delete );	
		guys_to_delete = [];
		
		for( i = 0; i < num; i++ )
			guys_to_delete[ guys_to_delete.size ] = random_guys_to_delete[ i ];
	}

	thread AI_delete_when_out_of_sight( guys_to_delete, 512 );
}

type_script_model_civilian()
{
	if ( !isdefined( self.code_classname ) )
		return false;
	
	if ( !isdefined( self.model ) )
		return false;
	
	if ( self.code_classname == "script_model" && self.model == "body_complete_civilian_suit_male_1" )
		return true;
		
	return false;
}

hide_destroyed_parts()
{
	poles = getentarray( "massacre_post_post_exp", "targetname" );
	foreach( pole in poles )
	{
		pieces = getentarray( pole.target, "targetname" );
		
		foreach( piece in pieces )
			piece hide();
			
		pole hide();
	}
}

sign_departure_status_eratic()
{
	level endon( "special_op_terminated" );
	
	statuses = [];
	statuses[ statuses.size ] = "arriving";
	statuses[ statuses.size ] = "ontime";
	statuses[ statuses.size ] = "boarding";
	statuses[ statuses.size ] = "delayed";
	
	wait 1;
	
	while( !flag( "stop_board_flipping" ) )
	{
		snds = getentarray( "snd_departure_board", "targetname" );
		foreach( member in snds )
			member playsound( member.script_soundalias );
		
		array = array_randomize( level.departure_status_array );
		spintime = 0;
		foreach( index, value in array )
		{
			spintime = index * .1;
			value delaythread( spintime, ::sign_departure_status_flip_to, statuses[ randomint( statuses.size ) ] );
		}
		
		wait spintime;
		if ( cointoss() )
			wait randomfloatrange( 0.5, 6.0 );
	}
}

crash_elevator()
{	
	level endon( "special_op_terminated" );
	
	trigger_wait( "enemy_waiting_area_above_movein_trig", "targetname" );

	elevator = massacre_elevator_get();
	level.massacre_elevator = elevator;
	
	elevator.e[ "housing" ][ "mainframe" ][ 0 ] playsound( "elevator_shake_groan" );
	
	wait .05;
	exploder( 1 );
	struct = getstruct( "elevator_pick", "targetname" );
	array = getentarray( "elevator_casing_glass", "targetname" );
	glass = getclosest( struct.origin, array );
	glass delete();
	array = getentarray( "elevator_housing_glass", "script_noteworthy" );
	glass = getclosest( struct.origin, array );
	glass delete();
	magicgrenademanual( "fraggrenade", struct.origin, ( 0, 0, 0 ), 0.05 );	
	
	wait .5;
	//elevator.e[ "housing" ][ "mainframe" ][ 0 ] playsound( "elavator_rumble" );
	
	velF = (0,0,1000);
	velR = (0,0,-1000);
	
	elevator delaythread( .95, ::elevator_animated_down_fast, elevator.cable, elevator.e[ "housing" ][ "mainframe" ][ 0 ], 1.05, velF, velR );
	wait 1;
	
	left_door = elevator common_scripts\_elevator::get_outer_leftdoor( 0 );	
	right_door = elevator common_scripts\_elevator::get_outer_rightdoor( 0 );
	
	level.elevators = array_remove( level.elevators, elevator );
	
	delaythread( .1, ::massacre_set_elevator_const, 80 );
	delaythread( .6, ::massacre_set_elevator_const, 70 );
	delaythread( .75, ::massacre_set_elevator_const, 60 );
	
	elevator.e[ "housing" ][ "inside_trigger" ] delete();
	elevator.e[ "housing" ][ "mainframe" ][ 0 ] MoveGravity( (0,0,0), 1 );
		
	wait 1;
	elevator.e[ "housing" ][ "mainframe" ][ 0 ] playsound( "elevator_crash" );
	exploder( 2 );
	//temp
	left_door delete();
	right_door delete();
	wait .5;
	elevator notify( "elevator_moved" );
}

objective_breadcrumb()
{
	flag_init( "obj_shopping" );
	flag_init( "obj_escalators_end" );
	flag_init( "obj_finish" );
	
	obj_origin = getstruct( "obj_escalator_top", "script_noteworthy" ).origin;
	Objective_Add( 1, "current", level.challenge_objective, obj_origin );
	
	flag_wait( "obj_shopping" );
	
	obj_origin = getstruct( "obj_shopping", "script_noteworthy" ).origin;
	Objective_Position( 1, obj_origin );
	
	flag_wait( "obj_escalators_end" );

	obj_origin = getstruct( "obj_escalators_end", "script_noteworthy" ).origin;
	Objective_Position( 1, obj_origin );

	flag_wait( "obj_finish" );

	obj_origin = getstruct( "obj_finish", "script_noteworthy" ).origin;
	Objective_Position( 1, obj_origin );
}