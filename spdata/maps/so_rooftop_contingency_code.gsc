#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_vehicle;

get_wave_count()
{
	return level.wave_spawn_structs.size;
}

get_wave_ai_count( wave_num )
{
	return level.wave_spawn_structs[ wave_num ].hostile_count;
}

get_wave_vehicles( wave_num )
{
	return level.wave_spawn_structs[ wave_num ].vehicles;
}

get_vehicle_type_count( wave_num, type )
{
	count = 0;

	vehicles = get_wave_vehicles( wave_num );
	foreach ( vehicle in vehicles )
	{
		if ( vehicle.type == type )
		{
			count++;
		}
	}

	return count;
}


// UAV Section ---------------------------------------------- //
uav_pickup_setup()
{
	uav_pickup = GetEnt( "uav_controller", "targetname" );
	AssertEx( IsDefined( uav_pickup ), "Missing UAV controller pickup objective model in level." );

	uav_pickup Hide();

	wait_to_pickup_uav();

	thread pickup_uav_reminder();

	wait( 1 );

	while ( 1 )
	{
		//level waittill( "new_wave_started" );
		wait( 2 );
		uav_pickup Show();

		uav_pickup MakeUsable();
		uav_pickup SetCursorHint( "HINT_NOICON" );
		// Hold &&1 to pick up
		uav_pickup SetHintString( &"SO_ROOFTOP_CONTINGENCY_DRONE_PICKUP" );
		uav_pickup waittill( "trigger", player );

		uav_pickup PlaySound( "detpack_pickup" );

		level.so_uav_picked_up = true;
		level.so_uav_player = player;

		flag_set( "uav_in_use" );

		player maps\_remotemissile::give_remotemissile_weapon( level.remote_detonator_weapon );

		// If wave 2 has not started yet, disable the uav.
		if ( level.gameskill > 1 && !flag( "wave_2_started" ) || !flag( "wave_1_started" ) )
		{
			level.so_uav_player maps\_remotemissile::disable_uav( false, true );
		}

		uav_pickup MakeUnusable();
		uav_pickup Hide();

		if ( !isdefined( player.already_displayed_hint ) )
		{
			// If the wave 2 hasn't already started, then hold on displaying hint until it actually does.
			if ( level.gameskill > 1 && !flag( "wave_2_started" ) )
			{
				flag_wait( "wave_2_started" );
			}
			else if ( !flag( "wave_1_started" ) )
			{
				flag_wait( "wave_1_started" );
			}

			player.already_displayed_hint = 1;

			if ( IsDefined( player.remotemissile_actionslot ) )
			{
				player display_hint( "use_uav_" + player.remotemissile_actionslot );
			}
			else
			{
				player display_hint( "use_uav_4" );
			}
		}

		if ( !level.UAV_pickup_respawn )
		{
			return;
		}

		flag_waitopen( "uav_in_use" );
		wait level.uav_spawn_delay;// delay between uav spawns
	}
}

pickup_uav_reminder()
{
	level endon( "uav_in_use" );

	while ( 1 )
	{
		wait( RandomFloatRange( 15, 20 ) );

		if ( flag( "special_op_terminated" ) )
		{
			return;
		}

		radio_dialogue( "so_pickup_uav_reminder" );
	}
}

wait_to_pickup_uav()
{
	wait_to_pickup = true;

/#
	if ( GetDvarInt( "uav_now" ) > 0 )
	{
		wait_to_pickup = false;
	}
#/

	if ( level.gameSkill < 2 )
	{
		wait_to_pickup = false;
	}

	if ( wait_to_pickup )
	{
		// Just wait for the first wave to be wiped out
		flag_wait( "wave_wiped_out" );
	}
	else
	{
		// Wait for the first round to start
		flag_wait( "start_countdown" );
	}
}

uav()
{
	wait_to_pickup_uav();

	thread dialog_uav();

	level.uav = spawn_vehicle_from_targetname_and_drive( "second_uav" );

	level.uav PlayLoopSound( "uav_engine_loop" );
	level.uavRig = Spawn( "script_model", level.uav.origin );
	level.uavRig SetModel( "tag_origin" );
	thread uav_rig_aiming();
}

dialog_uav()
{
	//The UAV is almost in position.	
	radio_dialogue( "cont_cmt_almostinpos" );
}

uav_rig_aiming()
{
	if ( !isalive( level.uav ) )
	{
		return;
	}

	if ( IsDefined( level.uav_is_destroyed ) )
	{
		return;
	}

	focus_points = GetEntArray( "uav_focus_point", "targetname" );

	level endon( "uav_destroyed" );
	level.uav endon( "death" );
	for ( ;; )
	{
		closest_focus = getClosest( level.player.origin, focus_points );
		targetPos = closest_focus.origin;
		angles = VectorToAngles( targetPos - level.uav.origin );
		level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
		level.uavRig RotateTo( ANGLES, 0.10, 0, 0 );
		wait( 0.05 );
	}
}

// Vehicles -----------------------------------------------

setup_base_vehicles()
{
	self endon( "death" );

	self thread maps\_remotemissile::setup_remote_missile_target();

//	self thread update_badplace();
	self thread unload_when_stuck();
//	self thread custom_connectpaths_ondeath();
	self thread vehicle_death_paths();
	self waittill( "unloaded" );

    if ( IsDefined( self.has_target_shader ) )
    {
		self.has_target_shader = undefined;
		Target_Remove( self );
    }

	level.remote_missile_targets = array_remove( level.remote_missile_targets, self );
}


vehicle_death_paths()
{
	self endon( "delete" );

	// Notify from _vehicle::vehicle_kill, after the phys vehicle is blown up and disconnectpaths
	self waittill( "kill_badplace_forever" );

	min_dist = 50 * 50;
	death_origin = self.origin;
	
	while ( IsDefined( self ) )
	{
		if ( DistanceSquared( self.origin, death_origin ) > min_dist )
		{
			death_origin = self.origin;

			// Connect the paths before we get to far away from the death_origin
			self ConnectPaths();

			// Don't disconnectpaths until we're done moving.
			while ( 1 )
			{
				wait( 0.05 );
				if ( !IsDefined( self ) )
				{
					return;
				}

				if ( DistanceSquared( self.origin, death_origin ) < 1 )
				{
					break;
				}

				death_origin = self.origin;
			}

			// Now disconnectpaths after we have settled
			self DisconnectPaths();
		}

		wait( 0.05 );
	}
}

// We need this to reconnect the paths after _vehicle::vehicle_kill disconnects them.
//custom_connectpaths_ondeath()
//{
//	self waittill( "kill_badplace_forever" );
//
//	wait( 0.1 );
//	self ConnectPaths();
//}
//
//update_badplace()
//{
//	self endon( "delete" );
//
//	duration = 0.5;
//
//	radius = 100;
//	if ( self.vehicletype == "bm21_troops" )
//	{
//		radius = 176;
//	}
//	else if( self.vehicletype == "uaz_physics" )
//	{
//		radius = 90;
//	}
//
//	height = 300;
//
//	while ( 1 )
//	{
//		speed = self Vehicle_GetSpeed();
//		if ( !IsAlive( self ) || speed < 0.2 )
//		{
//			BadPlace_Cylinder( self.unique_id + "cyl_bp", duration, self.origin, radius, height, "axis", "team3", "allies" );
//		}
//		
//		wait( duration + 0.05 );
//	}
//}

unload_when_stuck()
{
	self endon( "unloaded" );
	self endon( "unloading" );

	self endon( "death" );
	while ( 1 )
	{
		wait( 2 );
		if ( self Vehicle_GetSpeed() < 2 )
		{
			self Vehicle_SetSpeed( 0, 15 );
			self thread maps\_vehicle::vehicle_unload();
			self notify( "kill_badplace_forever" );
			return;
		}
	}
}

spawn_vehicle_and_go( struct )
{
	spawner = struct.ent;

	if ( IsDefined( struct.delay ) )
	{
		wait( struct.delay );
	}

	if ( IsDefined( struct.alt_node ) )
	{
		targetname = struct.alt_node.targetname;

		spawner.target = targetname;
	}

	vehicle = spawner spawn_vehicle();

	// So the corpse of the vehicle cannot be moved
//	vehicle.free_on_death = true;

//	vehicle thread vehicle_becomes_crashable();
//	vehicle.dontDisconnectPaths = true;

	vehicle StartPath();
//	vehicle thread force_unload( spawner.target + "_end" );

	/#
	so_debug_print( "vehicle[" + spawner.targetname + "] spawned" );
	vehicle waittill( "unloading" );
	so_debug_print( "vehicle[" + spawner.targetname + "] unloading guys" );
	vehicle waittill( "unloaded" );
	so_debug_print( "vehicle[" + spawner.targetname + "] unloading complete" );
	#/
}

//force_unload( end_name )
//{
////	end_node = get_last_ent_in_chain( sEntityType );
//
//	end_node = GetVehicleNode( end_name, "targetname" );
//	end_node waittill( "trigger" );
//
//	self Vehicle_SetSpeed( 0, 15 );
//	wait 1;
//	self maps\_vehicle::vehicle_unload();
//}

// HUD ----------------------------------------------------
hud_wave_num()
{
	while ( 1 )
	{
		level waittill( "new_wave_started" );

		// Little delay so the "Wave Starting in..." can be removed
		wait( 1 );

		hud_count = undefined;
		if ( level.current_wave < get_wave_count() )
		{
			hud = so_create_hud_item( 0, so_hud_ypos(), &"SPECIAL_OPS_WAVENUM", self );
			hud_count = so_create_hud_item( 0, so_hud_ypos(), undefined, self );
			hud_count.alignx = "left";

			hud_count SetValue( level.current_wave );
		}
		else
		{
			hud = so_create_hud_item( 0, so_hud_ypos(), &"SPECIAL_OPS_WAVEFINAL", self );
			hud.alignx = "center";
		}

		music_loop( "so_rooftop_contingency_music", 291 );

		flag_wait( "wave_wiped_out" );

		music_stop( 1 );
		
		hud thread so_remove_hud_item( true );

		if ( IsDefined( hud_count ) )
		{
			hud_count thread so_remove_hud_item( true );
		}
	}
}

hud_hostile_count()
{
	// Hostiles:
	hudelem_title = so_create_hud_item( 2, so_hud_ypos(), &"SO_ROOFTOP_CONTINGENCY_HOSTILES", self );
	hudelem_count = so_create_hud_item( 2, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH", self );
	hudelem_count.alignx = "left";

	flag_wait( "waves_start" );

/*	thread info_hud_handle_fade( hudelem_title, "stop_fading_count" );
	thread info_hud_handle_fade( hudelem_count, "stop_fading_count" );*/

	max_count = level.hostile_count;
	
	while ( !flag( "challenge_success" ) || !flag( "special_op_terminated" ) )
	{
		// Be sure to only play the dialog once.
		if ( self == level.player )
		{
			thread so_dialog_counter_update( level.hostile_count, max_count );
		}
		
		curr_count = level.hostile_count;
		hudelem_count.label = "";
		hudelem_count Setvalue( level.hostile_count );

		if ( curr_count <= 0 )
		{
			hudelem_count so_remove_hud_item( true );
			hudelem_count = so_create_hud_item( 2, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH", self );
			hudelem_count.alignx = "left";

			hudelem_title thread so_hud_pulse_success();
			hudelem_count thread so_hud_pulse_success();
		}
		else if ( curr_count <= 5 )
		{
			hudelem_title thread so_hud_pulse_close();
			hudelem_count thread so_hud_pulse_close();
		}

		while ( !flag( "challenge_success" ) && ( curr_count == level.hostile_count ) )
		{
			wait( 0.05 );
			// This indicates a new wave has started...
			if ( level.hostile_count > curr_count )
			{
				max_count = level.hostile_count;
				level.so_progress_goal_status = "none";
				hudelem_title thread so_hud_pulse_default();
				hudelem_count thread so_hud_pulse_default();
			}
		}
	}

	hudelem_count so_remove_hud_item( true );
	hudelem_count = so_create_hud_item( 2, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH", self );
	hudelem_count.alignx = "left";

	hudelem_title thread so_remove_hud_item();
	hudelem_count thread so_remove_hud_item();

	level notify( "stop_fading_count" );
}

hud_new_wave()
{
	current_wave = level.current_wave + 1;

	if ( current_wave > get_wave_count() )
	{
		return;
	}

	// Next Wave in: 
	wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_STARTS";
	wave_delay = 0.75;
	if ( current_wave == get_wave_count() )
	{
		// Final Wave in: 
		wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_FINAL_STARTS";
	}
	else
	{
		if ( current_wave == 2 )
		{
			// Second Wave in: 
			wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_SECOND_STARTS";
		}

		if ( current_wave == 3 )
		{
			// Third Wave in: 
			wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_THIRD_STARTS";
		}

		if ( current_wave == 4 )
		{
			// Fourth Wave in: 
			wave_msg = &"SO_ROOFTOP_CONTINGENCY_WAVE_FOURTH_STARTS";
		}
	}

	thread enable_countdown_timer( level.wave_delay, false, wave_msg, wave_delay );
	wait 2;
	hud_wave_splash( current_wave, level.wave_delay - 2 );

/*
	hudelem = so_create_hud_item( 0, so_hud_ypos(), wave_msg );
	hudelem SetPulseFX( 50, level.wave_delay * 1000, 500 );

	hudelem_time = so_create_hud_item( 0, so_hud_ypos(), "" );
	hudelem_time.alignX = "left";
	hudelem_time SetTenthsTimer( level.wave_delay );
	hudelem_time SetPulseFX( 50, level.wave_delay * 1000, 500 );

	wait( level.wave_delay );*/
}

// Returns structs...
hud_get_wave_list( wave_num )
{
	list = [];

	list[ 0 ] = SpawnStruct();

	if ( wave_num < get_wave_count() )
	{
		list[ 0 ].text = &"SPECIAL_OPS_INTERMISSION_WAVENUM";
		list[ 0 ].count = wave_num;
	}
	else
	{
		list[ 0 ].text = &"SPECIAL_OPS_INTERMISSION_WAVEFINAL";		
	}

//	switch( wave_num )
//	{
//		case 1:
//			// - Wave 1 -
//			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE1";
//			break;
//
//		case 2:
//			// - Wave 2 -
//			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE2";
//			break;
//
//		case 3:
//			// - Wave 3 -
//			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE3";
//			break;
//
//		case 4:
//			// - Wave 4 -
//			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE4";
//			break;
//
//		case 5:
//			// - Wave 5 -
//			list[ 0 ].text = &"SO_ROOFTOP_CONTINGENCY_WAVE5";
//			break;
//
//		default:
//			AssertMsg( "Wrong wave_num passed in" );
//			break;
//	}

	list[ 1 ] = SpawnStruct();
	// &&1 Hostiles
	list[ 1 ].text = &"SO_ROOFTOP_CONTINGENCY_HOSTILES_COUNT";
	list[ 1 ].count = get_wave_ai_count( wave_num );

	index = 2;

	// Figure out vehicles
	uaz_count = get_vehicle_type_count( wave_num, "uaz" );

	// Add each UAZ to the total hostiles
	list[ 1 ].count += ( uaz_count * 4 );
 
	if ( uaz_count > 0 )
	{
		if ( uaz_count == 1 )
		{
			// &&1 UAZ Vehicle
			str = &"SO_ROOFTOP_CONTINGENCY_UAZ_COUNT_SINGLE";
		}
		else
		{
			// &&1 UAZ Vehicles
			str = &"SO_ROOFTOP_CONTINGENCY_UAZ_COUNT";
		}

		list[ index ] = SpawnStruct();
		list[ index ].text = str;
		list[ index ].count = uaz_count;
		index++;
	}

	bm21_count = get_vehicle_type_count( wave_num, "bm21" );

	// Add each BM21 to the total hostiles
	list[ 1 ].count += ( bm21_count * 6 );

	if ( bm21_count > 0 )
	{
		if ( bm21_count == 1 )
		{
			// &&1 BM21 Troop Carrier
			str = &"SO_ROOFTOP_CONTINGENCY_BM21_COUNT_SINGLE";
		}
		else
		{
			// &&1 BM21 Troop Carriers
			str = &"SO_ROOFTOP_CONTINGENCY_BM21_COUNT";
		}

		list[ index ] = SpawnStruct();
		list[ index ].text = str;
		list[ index ].count = bm21_count;
	}

	return list;
}

hud_create_wave_splash( yLine, message )
{
	hudelem = so_create_hud_item( yLine, 0, message );
	hudelem.alignX = "center";
	hudelem.horzAlign = "center";

	return hudelem;
}

hud_wave_splash( wave_num, timer )
{
	hudelems = [];
	list = hud_get_wave_list( wave_num );
	for ( i = 0; i < list.size; i++ )
	{
		hudelems[ i ] = hud_create_wave_splash( i, list[ i ].text );

		if ( IsDefined( list[ i ].count ) )
		{
			hudelems[ i ] SetValue( list[ i ].count );
		}

		hudelems[ i ] SetPulseFX( 60, ( ( timer - 1 ) * 1000 ) - ( i * 1000 ), 1000 );

		wait( 1 );
	}

	wait( timer - ( list.size * 1 ) );

	foreach ( hudelem in hudelems )
	{
		hudelem Destroy();
	}
}

// DEBUG ---------------------------------------------------
so_debug_print( msg, delay )
{
	message = "> " + msg;

	if ( IsDefined( delay ) )
	{
		wait delay;
		message = "+>" + message;
	}
	else
	{
		message = ">>" + message;
	}

	if ( GetDvar( "specialops_debug" ) == "1" )
		IPrintLn( message );
}

distance2d_squared( pos1, pos2 )
{
	pos1 = ( pos1[ 0 ], pos1[ 1 ], 0 );
	pos2 = ( pos2[ 0 ], pos2[ 1 ], 0 );

	return DistanceSquared( pos1, pos2 );
}

//player_input()
//{
//	while( 1 )
//	{
//		eye_pos = level.player GetEye();
//		forward = AnglesToForward( level.player GetPlayerAngles() );
//		forward_pos = eye_pos + vector_multiply( forward, 2000 );
//		trace = BulletTrace( eye_pos, forward_pos, false, undefined );
//		pos = trace[ "position" ];
//		draw_circle( pos, 32 );
//
//		if ( level.player UseButtonPressed() )
//		{
//			missile = MagicBullet( "remote_missile_snow", pos + ( 0, 0, 200 ), pos, level.player );
//			thread do_physics_impact_on_explosion( level.player );
//			wait( 0.5 );
//		}
//
//		wait( 0.05 );
//	}
//}
//
//do_physics_impact_on_explosion( player )
//{
//	player waittill( "projectile_impact", weaponName, position, radius );
//
//	level.uavTargetPos = position;
//
//	physicsSphereRadius = 1000;
//	physicsSphereForce = 6.0;
////	Earthquake( .3, 1.4, position, 8000 );
//
//	wait 0.1;
//	PhysicsExplosionSphere( position, physicsSphereRadius, physicsSphereRadius / 2, physicsSphereForce );
//}
//
//
//draw_circle( center, radius )
//{
//	circle_sides = 16;
//
//	angleFrac = 360 / circle_sides;
//
//	// Z circle
//	circlepoints = [];
//	for ( i = 0; i < circle_sides; i++ )
//	{
//		angle = ( angleFrac * i );
//		xAdd = Cos( angle ) * radius;
//		yAdd = Sin( angle ) * radius;
//		x = center[ 0 ] + xAdd;
//		y = center[ 1 ] + yAdd;
//		z = center[ 2 ];
//		circlepoints[ circlepoints.size ] = ( x, y, z );
//	}
//
//	thread draw_circlepoints( circlepoints );
//}
//
//draw_circlepoints( circlepoints )
//{
//	color = ( 0.8, 0, 0 );
//
//	for ( i = 0; i < circlepoints.size; i++ )
//	{
//		start = circlepoints[ i ];
//		if ( i + 1 >= circlepoints.size )
//		{
//			end = circlepoints[ 0 ];
//		}
//		else
//		{
//			end = circlepoints[ i + 1 ];
//		}
//
//		line( start, end, color );
//	}
//}