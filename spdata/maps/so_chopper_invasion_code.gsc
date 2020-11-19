#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\so_chopper_invasion;

init_dialogue()
{
	// "Gunslinger One  to ground, primary LZ is too hot! We've got ten-plus hostiles in our immediate AO and cannot remain on the ground, over!"
	level.scr_radio[ "lift_off" ] = "so_chop_inv_hp1_lz2hot";

	// "Ground forces, we're going to link up at the secondary extraction point. Head for the roof of Nate's Sports Bar, to the East."
	level.scr_radio[ "objective" ] = "so_chop_inv_hp1_enghost";

	// "Gunner, you are cleared to engage hostiles. Watch out for friendlies on the ground, over."
	level.scr_radio[ "objective2" ] = "so_chop_inv_hp1_gunner";

	// "Gunslinger-One to ground forces, find some cover! We are tracking a platoon-sized group of hostiles behind that barricade at the end of the street, over!"
	level.scr_radio[ "drive_by" ] = "so_chop_inv_hp1_findcover";

	// "Danger close ground forces, we're comin' in hot! Gunner, you are cleared to engage hostiles by the barricade."
	level.scr_radio[ "start_drive_by" ] = "so_chop_inv_hp1_by_barricade";

	// "Good effect on target, Gunner - whoa, hang on!"
	level.scr_radio[ "evade_rpgs" ] = "so_chop_inv_hp1_goodeffect";

	// "Ground forces be advised, we've got RPGs in the area, over.  We’re coming back around for a strafing run here in a second."
	level.scr_radio[ "evade_extra" ] = "so_chop_inv_hp1_rpgs";

	// "Gunslinger-One to ground, we are starting our strafing run, over. Gunner, light 'em up."
	level.scr_radio[ "drive_by_payback" ] = "so_chop_inv_hp1_lightemup";

	// "Guns guns guns!"
	level.scr_radio[ "drive_by_guns_guns_guns" ] = "so_chop_inv_hp1_guns";

	// "Gunslinger-One to ground, repositioning to your location, over."
	level.scr_radio[ "back_to_squad" ] = "so_chop_inv_hp1_reposition";

	// "Gunslinger-One to ground, be advised, we are tracking a convoy of enemy trucks movin' in from the southeast, recommend you let us handle those, over."
	level.scr_radio[ "convoy" ] = "so_chop_inv_hp1_ba_trucks";

	// "Gunslinger-One to ground, we see you! Maintain your location on the roof, we're en route!"
	level.scr_radio[ "on_the_roof" ] = "so_chop_inv_hp1_weseeyou";

	// "Ground forces, let's go let's go! We are at the roof and ready to link up for extraction!"
	level.scr_radio[ "end_reminder_1" ] = "so_chop_inv_hp1_letsgo";

	// "Ground forces, pick up the pace, we're sitting ducks up here!"
	level.scr_radio[ "end_reminder_2" ] = "so_chop_inv_hp1_pace";

	// "Jump! You'll make it!"
	level.scr_radio[ "jump" ] = "so_chop_inv_hp1_jump";

	// "Ground forces, link up on the roof of Nate's Sports Bar!"
	level.scr_radio[ "objective_reminder_1" ] = "so_chop_inv_hp1_linkup";

	// "Gunslinger One to ground, meet us up on the roof of Nate's Sports Bar!"
	level.scr_radio[ "objective_reminder_2" ] = "so_chop_inv_hp1_meetus";

	// "Ground forces, get to the roof of Nate's Sports Bar!"
	level.scr_radio[ "objective_reminder_3" ] = "so_chop_inv_hp1_gettoroof";

	// "Gunner, watch your fire - that's a friendly!"
	level.scr_radio[ "friendlyfire_1" ] = "so_chop_inv_hp1_friendly_01";

	// "Gunner, that is friendly fire! Check your aim!"
	level.scr_radio[ "friendlyfire_2" ] = "so_chop_inv_hp1_friendly_02";

	// "That's a friendly down there, Gunner! Focus up!"
	level.scr_radio[ "friendlyfire_3" ] = "so_chop_inv_hp1_friendly_03";
}

so_chopper_invasion_fx()
{
	level._effect[ "chopper_minigun_shells" ] = LoadFX( "shellejects/20mm_cargoship" );
}

chopper_minigun_shells()
{
	fx = getfx( "chopper_minigun_shells" );
	tag = "tag_turret";

	while ( 1 )
	{
		if ( self AttackButtonPressed() )
		{
			PlayFXOnTag( fx, level.chopper, tag );
		}

		wait( 0.05 );
	}
}

so_chopper_invasion_enemy_setup()
{
	level.enemies = [];

	allspawners = GetSpawnerTeamArray( "axis" );
	array_thread( allspawners, ::add_spawn_function, ::so_chopper_invasion_enemy_spawnfunc );
}

so_chopper_invasion_enemy_spawnfunc()
{
	self pathrandompercent_set( 800 );

	if ( IsSubStr( self.code_classname, "juggernaut" ) )
	{
		self thread so_chopper_invasion_juggernaut_init();
	}

	level.activeEnemies[ level.enemies.size ] = self;
	self thread so_chopper_invasion_enemy_deathcleanup();
}

so_chopper_invasion_juggernaut_init()
{
	self SetThreatBiasGroup( "juggernauts" );
	//self thread juggernaut_hud_box();
}

/*
juggernaut_hud_box()
{
	offset = ( 0, 0, 32 );
	Target_Set( self, offset );
	
	self waittill( "death" );
	Target_Remove( self );
}
*/

so_chopper_invasion_enemy_deathcleanup()
{
	self waittill( "death" );
	level.activeEnemies = array_remove( level.enemies, self );
}

// TODO maybe genericize this
get_targeted_line_array( start )
{
	arr = [];
	arr[ 0 ] = start;
	point = start;

	while ( IsDefined( point.target ) )
	{
		nextpoint = getstruct( point.target, "targetname" );

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = GetEnt( point.target, "targetname" );
		}

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = GetNode( point.target, "targetname" );
		}

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = GetVehicleNode( point.target, "targetname" );
		}

		if ( IsDefined( nextpoint ) )
		{
			arr[ arr.size ] = nextpoint;
		}
		else
		{
			break;
		}

		point = nextpoint;
	}

	return arr;
}

milliseconds( seconds )
{
	return seconds * 1000;
}

seconds( milliseconds )
{
	return milliseconds / 1000;
}

// AI Section ---------------------------------------------
ai_post_spawn()
{
	self endon( "death" );

	if ( !IsDefined( self.target ) )
	{
		return;
	}

	points = getstructarray( self.target, "targetname" );
	while ( 1 )
	{
		if ( points.size == 0 )
		{
			return;
		}

		point = points[ 0 ];
		if ( points.size > 1 )
		{
			point = points[ RandomInt( points.size ) ];
		}

		if ( IsDefined( point.radius ) )
		{
			self.goalradius = point.radius;
		}

		self SetGoalPos( point.origin );
		self waittill( "goal" );

		if ( IsDefined( point.script_noteworthy ) )
		{
			if ( point.script_noteworthy == "so_shoot_rpg" )
			{
				self.a.rockets = 1;
//				target = GetEnt( "so_rpg_target", "targetname" );
				self SetEntityTarget( level.chopper );

				self.ignoreall = false;
				level notify( "so_rpgs_shot" );
			}
		}

		if ( IsDefined( point.script_flag_wait ) )
		{
			flag_wait( point.script_flag_wait );

			if ( IsDefined( point.script_noteworthy ) )
			{
				if ( point.script_noteworthy == "so_shoot_rpg" )
				{
					self SetCanDamage( true );
				}
			}
		}

		point script_delay();

		if ( IsDefined( point.script_noteworthy ) )
		{
			if ( point.script_noteworthy == "so_shoot_rpg" )
			{
				self ClearEntityTarget();
			}
		}

		if ( !IsDefined( point.target ) )
		{
			break;
		}

		points = getstructarray( point.target, "targetname" );
	}


	self.goalradius = level.default_goalradius;
}

so_rpg_post_spawn()
{
	self SetCanDamage( false );
}

friendlyfire()
{
	next_time = 0;
	duration = 3000;

	while ( 1 )
	{
		level.groundplayer waittill( "damage", dmg, attacker );

		if ( attacker == level.chopper )
		{
			if ( GetTime() > next_time )
			{
				next_time = GetTime() + duration;
				chopper_dialog( "friendlyfire" );
			}
		}
	}
}

// ---------------------
// --- CHOPPER STUFF ---
// ---------------------
#using_animtree( "vehicles" );
build_chopper()
{
	maps\_blackhawk_minigun::main( "vehicle_blackhawk_minigun_hero", "blackhawk_minigun_so" );
}

chopper_defaults()
{
	self ClearGoalYaw();
	self.speed_setting = "none";
	self chopper_default_speed();
	self SetHoverParams( 50, 10, 3 );
	self chopper_default_pitch_roll();
	self SetNearGoalNotifyDist( 200 );
}

chopper_default_pitch_roll()
{
	self SetMaxPitchRoll( 0, 0 );
}

chopper_default_speed()
{
	if ( self.speed_setting == "default" )
	{
		return;
	}

	self.speed_setting = "default";
//	self Vehicle_SetSpeed( 15, 7.5 );
//	self Vehicle_SetSpeed( 20, 10, 10 ); 
	self Vehicle_SetSpeed( 20, 20, 20 );
}

chopper_slow_speed()
{
	if ( self.speed_setting == "slow" && self.speed_setting != "force_default" )
	{
		return;
	}

	self.speed_setting = "slow";
	self Vehicle_SetSpeed( 10, 20, 20 );
}

chopper_high_speed()
{
	if ( self.speed_setting == "high" )
	{
		return;
	}

	self.speed_setting = "high";
	self Vehicle_SetSpeed( 30, 20, 20 );
}

// Mouns the player to the chopper
chopper_playermount( player )
{
	player AllowCrouch( false );
	player AllowProne( false );
	player AllowSprint( false );
	player AllowJump( false );

	self maps\_blackhawk_minigun::player_mount_blackhawk_gun( true, player, false );
	self chopper_defaults();
}

chopper_dialog( alias )
{
	if ( flag( "special_op_terminated" ) )
	{
		return;
	}

	aliases = [];
	switch( alias )
	{
		case "end_reminder":
			aliases[ 0 ] = "end_reminder_1";
			aliases[ 1 ] = "end_reminder_2";
			break;

		case "objective_reminder":
			aliases[ 0 ] = "objective_reminder_1";
			aliases[ 1 ] = "objective_reminder_2";
			aliases[ 2 ] = "objective_reminder_3";
			break;

		case "friendlyfire":
			aliases[ 0 ] = "friendlyfire_1";
			aliases[ 1 ] = "friendlyfire_2";
			aliases[ 2 ] = "friendlyfire_3";
			break;

		default:
			break;
	}

	if ( aliases.size > 0 )
	{
		alias = aliases[ RandomInt( aliases.size ) ];
	}

	thread radio_dialogue( alias );
}

// Kicks off the chopper threads
chopper_think()
{
//	draw_high_obstacles();

	self SetMaxPitchRoll( 30, 30 );

	level.chopper_segment_points 	 = 15;
	level.chopper_range_from_point 	 = 1300;

	level.chopper_base_elevation 	 = 3100;
	level.chopper_lookat_point 		 = level.groundplayer.origin;

	chopper_dialog( "lift_off" );

	// initial getting into the air
	liftoffPath = get_targeted_line_array( self.start );

	for ( i = 1; i < liftoffPath.size; i++ )
	{
		if ( i == 1 )
		{
			self Vehicle_SetSpeed( 20, 6, 6 );
		}
		else
		{
			self chopper_default_speed();
		}

		node = liftoffPath[ i ];

		self SetGoalYaw( node.angles[ 1 ] );
		self SetVehGoalPos( node.origin, 0 );
		self waittill_either( "near_goal", "goal" );
	}

	chopper_dialog( "objective" );
	chopper_dialog( "objective2" );

	self chopper_defaults();

	level.chopperhint_time = GetTime();
	level.chopperplayer thread display_hint_timeout( "ads_slowdown", 5 );

	self thread chopper_gun_face_entity( level.groundplayer );
	self thread chopper_move_with_player();
//	self thread chopper_target();

	self thread debug_chopper_base_path();
}

so_ads_slowdown_hint()
{
	if ( GetTime() > level.chopperhint_time + 2000 )
	{
		if ( chopperplayer_pressing_slowdown() )
		{
			return true;
		}
	}

	return false;
}

so_fake_choppergunner()
{
	spawner = GetEnt( "so_choppergunner_spawner", "targetname" );
	drone = maps\_spawner::spawner_dronespawn( spawner );

	drone LinkTo( level.chopper, "tag_player" );
}

test_chopper_paths()
{
	level.chopper chopper_follow_path( "so_chopper_driveby", false );

	level.chopper notify( "stop_chopper_gun_face_entity" );
	level.chopper chopper_defaults();
	level.chopper SetHoverParams( 10, 2, 1 );
	level.chopper ClearLookAtEnt();
	level.chopper thread chopper_gun_face_entity( getstruct( "so_chopper_gasstation_lookat", "targetname" ) );

	wait( 1 );

	struct = getstruct( "so_last_driveby_point", "script_noteworthy" );
	level.chopper SetVehGoalPos( struct.origin, 1 );
	level.chopper SetHoverParams( 10, 2, 1 );
	level.chopper Vehicle_SetSpeed( 5, 1, 1 );
	level.chopper thread chopper_fake_hover( struct.origin );

	level waittill( "never" );
}

chopper_fake_hover( origin, dist, use_goal )
{
	self endon( "stop_chopper_fake_hover" );

	if ( !IsDefined( dist ) )
	{
		dist = 100;
	}

	while ( 1 )
	{
		x = RandomFloatRange( dist * -1, dist );
		y = RandomFloatRange( dist * -1, dist );
		z = RandomFloatRange( dist * -1, dist );

		self SetVehGoalPos( origin + ( x, y, z ), 1 );

		if ( IsDefined( use_goal ) && use_goal )
		{
			self Vehicle_SetSpeed( 5 + RandomInt( 10 ), 3, 3 );
			self waittill( "goal" );
		}
		else
		{
			wait( RandomFloatRange( 3, 5 ) );
		}
	}
}

//chopper_target()
//{
//	while ( 1 )
//	{
//		wait( 0.5 );
//		foreach ( ai in GetAIArray( "axis" ) )
//		{
//			if ( !IsDefined( ai.showing_as_target ) && IsAlive( ai ) && !( IsDefined( ai.a.special ) && ai.a.special == "none" ) )
//			{
//				ai.showing_as_target = true;
//				Target_Set( ai, ( 0, 0, 32 ) );
//				Target_SetShader( ai, "remotemissile_infantry_target" );
//				Target_ShowToPlayer( ai, level.chopperplayer );
//			}
//		}
//	}
//}

// Handles the chopper orientation with the ground player
chopper_gun_face_entity( ent, wait_for_goal, delay )
{
	self notify( "stop_chopper_gun_face_entity" );
	self endon( "stop_chopper_gun_face_entity" );

	if ( !IsDefined( level.chopper_gun_ground_entity ) )
	{
		level.chopper_gun_ground_entity = Spawn( "script_origin", self.origin );
	}

	if ( IsDefined( wait_for_goal ) && wait_for_goal )
	{
		self SetMaxPitchRoll( 20, 20 );
//		self waittill_either( "near_goal", "goal" );
		self waittill( "chopper_near_goal" );

		self chopper_default_pitch_roll();
	}

	if ( !IsDefined( delay ) )
	{
		delay = 1;
	}

	self delayCall( delay, ::SetLookAtEnt, level.chopper_gun_ground_entity );

	while ( 1 )
	{
		if ( ent == level.groundplayer )
		{
			lookat_origin = level.chopper_lookat_point;
		}
		else
		{
			lookat_origin = ent.origin;
		}

		// "forward" = vector from the chopper to the groundplayer
		forwardvec = VectorNormalize( lookat_origin - self.origin );
		forwardangles = VectorToAngles( forwardvec );
		rightvec = AnglesToRight( forwardangles );
		backvec = rightvec * -1;
		neworigin = self.origin + ( backvec * 100 );

		level.chopper_gun_ground_entity.origin = neworigin;
		wait( 0.05 );
	}
}

// Overall chopper movement thread
chopper_move_with_player( player )
{
	thread debug_player_pos();
	self.chopper_pathpoint = chopper_get_closest_pathpoint( 3 );
	self.no_bline_to_goal = true;
	just_started = true;

//	update_direction_duration = 5000;
//	next_update_direction = GetTime() + update_direction_duration;

	self chopper_reset_range_points();
	self.slowdown_points = [];

	while ( 1 )
	{
		if ( self ent_flag( "manual_control" ) )
		{
			wait( 0.1 );
			continue;
		}

		self SetNearGoalNotifyDist( 200 );

		chopper_move_till_goal();

		self.chopper_pathpoint = chopper_get_next_pathpoint( self.chopper_pathpoint[ "index" ] );

		if ( just_started )
		{
			just_started = false;
			self.no_bline_to_goal = false;
		}

//		if ( GetTime() > next_update_direction )
//		{
//			next_update_direction = GetTime() + update_direction_duration;
//			chopper_update_enemy_direction();
//		}
	}
}

//chopper_update_enemy_direction()
//{
//	enemies = GetAiArray( "axis" );
//
//	self.slowdown_points = [];
//
//	if ( GetDvarInt( "test_chopper_path" ) < 1 )
//	{
//		return;
//	}
//
//	if ( enemies.size == 0 )
//	{
//		return;
//	}
//
//	origins = ( 0, 0, 0 );
//	foreach ( enemy in enemies )
//	{
//		origins += enemy.origin;
//	}
//
//	avg_origin = ( origins[ 0 ] / enemies.size, origins[ 1 ] / enemies.size, origins[ 2 ] / enemies.size );
//	angles = VectorToAngles( avg_origin - level.groundplayer.origin );
//	angles = ( AngleClamp( angles[ 0 ] ), AngleClamp( angles[ 1 ] ), AngleClamp( angles[ 2 ] ) );
//
//	// Figure out what points along the chopper points for the angles
//	y = AngleClamp( angles[ 1 ] + 180 );
//
//	within = 60;
//
//
//	for ( i = 0; i < level.chopper_segment_points; i++ )
//	{
//		temp = AngleClamp( ( ( 360 / level.chopper_segment_points ) * -1 ) * i );//* - 1 to have the reverse effect of movement( forward )
//		if ( temp <= ( y + within ) && temp >= ( y - within ) )
//		{
//			self.slowdown_points[ i ] = true;
//		}
//		else
//		{
//			self.slowdown_points[ i ] = false;
//		}
//	}
//
//	level thread debug_draw_enemy_direction( angles, "update_enemy_direction" );
//}

// Keeps updating the choppers goal, incase the ground player moves, will end once the chopper
// reaches it's goal.
chopper_move_till_goal()
{
	self endon( "chopper_near_goal" );
	self endon( "manual_control" );

	self thread chopper_notify_near_goal();
	is_far = false;

	while ( 1 )
	{
		pos = chopper_get_pathpoint( self.chopper_pathpoint[ "index" ] );

		level thread debug_draw_chopper_line( pos, "final_destination", ( 0, 1, 0 ) );

		// If the chopper is too far away from it's goal, figure out a b-line path to the closest
		// Assume that we need to get back on track...
		if ( !self.no_bline_to_goal && distance2d_squared( pos, self.origin ) > 1000 * 1000 )
		{
			// Stop the endon until we are close enough
			is_far = true;
			self notify( "stop_chopper_notify_near_goal" );
			info = chopper_get_closest_pathpoint();

			pos = info[ "point" ];
			self.chopper_pathpoint = info;

			level thread debug_draw_chopper_line( pos, "final_destination", ( 0, 1, 0 ) );

			pos = chopper_get_bline_path_point( pos );

			level thread debug_draw_chopper_line( pos, "closer_point" );

			if ( self ent_flag( "manual_control" ) )
			{
				return;
			}

			self SetVehGoalPos( pos );
			self waittill_either( "near_goal", "goal" );
			continue;
		}
		else
		{
			if ( is_far )
			{
				// Reinitiate the chopper_notify_near_goal since we stopped it before
				self thread chopper_notify_near_goal();
			}

			is_far = false;
		}

		if ( self ent_flag( "manual_control" ) )
		{
			return;
		}

		chopper_slow_down();

//		Line( pos, pos + ( 0, 0, 2000 ), ( 1, 1, 0 ), 2 );

		level thread debug_draw_chopper_line( pos, "closer_point" );
		self SetVehGoalPos( pos );
		wait( 0.1 );
	}
}

chopperplayer_pressing_slowdown()
{
	if ( level.chopperplayer AdsButtonPressed() || level.chopperplayer UseButtonPressed() )
	{
		return true;
	}

	return false;
}

chopper_slow_down()
{
//	if ( GetDvarInt( "test_chopper_slowdown" ) == 1 )
//	{
		if ( chopperplayer_pressing_slowdown() )
		{
			chopper_slow_speed();
		}
		else
		{
			chopper_default_speed();
		}
//	}
}

chopper_notify_near_goal()
{
	self notify( "stop_chopper_notify_near_goal" );
	self endon( "stop_chopper_notify_near_goal" );

	self waittill_either( "near_goal", "goal" );
	self notify( "chopper_near_goal" );
}

// Returns the 1 chopper flight path, depending on the num passed in
chopper_get_pathpoint( num )
{
	add_angles = ( 360 / level.chopper_segment_points ) * -1;//* - 1 to have the reverse effect of movement( forward )

	angles = ( 0, add_angles * num, 0 );
	forward = AnglesToForward( angles );
//	point = level.groundplayer.origin + vector_multiply( forward, level.chopper_range_from_point );

	if ( is_player_in_parking_lot() )
	{
		level.chopper_lookat_point = get_parkinglot_point();
		point = level.chopper_lookat_point + vector_multiply( forward, level.chopper_range_from_point );
	}
	else
	{
		level.chopper_lookat_point = get_closest_point_on_base_path();
		point = level.chopper_lookat_point + vector_multiply( forward, level.chopper_range_from_point );
	}

	point = chopper_get_pointheight( point );

	return point;
}

chopper_get_bline_path_point( pos )
{
	angles = VectorToAngles( pos - level.chopper.origin );
	forward = AnglesToForward( angles );
	point = level.chopper.origin + vector_multiply( forward, 500 );

	point = chopper_get_pointheight( point );

	return point;
}

// Returns all of the choppers flight path points
chopper_get_pathpoints()
{
	points = [];

	for ( i = 0; i < level.chopper_segment_points; i++ )
	{
		points[ i ] = chopper_get_pathpoint( i );
	}

	return points;
}

// Takes the given point and adjusts it's Z coordinate depending on the obstacles.
chopper_get_pointheight( point )
{
	base = level.chopper_base_elevation;
	height = base;

	info = chopper_get_closest_obstacle_info( point );

	if( IsDefined( info[ "struct" ] ) )
	{
		if ( info[ "dist" ] < info[ "min_radius" ] )
		{
			height =  info[ "struct" ].origin[ 2 ];
		}
		else
		{
//			height = level.chopper_base_elevation + ( ( info[ "struct" ].origin[ 2 ] - level.chopper_base_elevation ) * ( info[ "dist" ] / ( info[ "max_radius" ] - info[ "min_radius" ] ) ) );
			height_diff = info[ "struct" ].origin[ 2 ] - level.chopper_base_elevation;
			height_perc = info[ "dist" ] / ( info[ "max_radius" ] - info[ "min_radius" ] );
			height = base + ( height_diff * height_perc );
		}

		if( height < base )
		{
			height = base;
		}
	}

	point = ( point[ 0 ], point[ 1 ], height );

	return point;
}

// Return the closest and highest struct
chopper_get_closest_obstacle_info( point )
{
	structs = getstructarray( "high_obstacle", "targetname" );

	// First find all of the structs the point within it's radius.
	close_structs = [];
	dist_array = [];
	min_radius_array = [];
	max_radius_array = [];
	foreach ( struct in structs )
	{
		max_radius = 600;
		if ( IsDefined( struct.radius ) )
		{
			max_radius = struct.radius;
		}

		min_radius = max_radius * 0.5;

		test_dist = Distance2D( point, struct.origin );
		if ( test_dist < max_radius )
		{
			close_structs[ close_structs.size ] 		= struct;
			dist_array[ dist_array.size ] 				= test_dist;
			min_radius_array[ min_radius_array.size ] 	= min_radius;
			max_radius_array[ max_radius_array.size ] 	= max_radius;
		}
	}

	// Now filter out the highest struct and return it
	highest_struct = undefined;
	dist = undefined;
	min_radius = undefined;
	max_radius = undefined;
	if ( close_structs.size > 0 )
	{
		highest_struct 	= close_structs[ 0 ];
		dist 			= dist_array[ 0 ];
		min_radius 		= min_radius_array[ 0 ];
		max_radius 		= max_radius_array[ 0 ];

		for ( i = 1; i < close_structs.size; i++ )
		{
			if ( close_structs[ i ].origin[ 2 ] > highest_struct.origin [ 2 ] )
			{
				highest_struct 	= close_structs[ i ];
				dist 			= dist_array[ i ];
				min_radius 		= min_radius_array[ i ];
				max_radius 		= max_radius_array[ i ];
			}
		}
	}

	info = [];
	info[ "struct" ] 	 	= highest_struct;
	info[ "dist" ] 		 	= dist;
	info[ "min_radius" ] 	= min_radius;
	info[ "max_radius" ]	= max_radius;

	return info;
}

// 0 = along the X
chopper_set_range_points( min_num, max_num )
{
	self.min_point_on_pathpoints = min_num;
	self.max_point_on_pathpoints = max_num;
}

chopper_reset_range_points()
{
	self.min_point_on_pathpoints = 0;
	self.max_point_on_pathpoints = 0;
	self.hover_direction = 1;
}

// Returns the next point (in array form for extra info) on the path
chopper_get_next_pathpoint( num )
{
	points = chopper_get_pathpoints();

	min_point = self.min_point_on_pathpoints;
	max_point = self.max_point_on_pathpoints;

	// if not 0 and 0, then stay within the range
	if ( min_point - max_point != 0 )
	{
		if ( num == min_point )
		{
			self.hover_direction = 1;
		}
		else if ( num == max_point )
		{
			self.hover_direction = -1;
		}

		num = num + self.hover_direction;
	}
	else
	{	
		self.hover_direction = 1;
		num++;
	}

	if ( num < 0 )
	{
		num = level.chopper_segment_points - 1;
	}

	if ( num >= points.size )
	{
		num = 0;
	}

	info = [];
	info[ "point" ] = points[ num ];
	info[ "index" ] = num;

	// Slow down section
//	if ( GetDvarInt( "test_chopper_path" ) > 0 )
//	{
//		if ( self.slowdown_points.size > 0 )
//		{
//			if ( self.slowdown_points[ num ] )
//			{
//				info[ "enemydir" ] = true;
//			}
//		}
//	}

	return info;
}

// Returns the closest point (in array form for extra info) on the path
chopper_get_closest_pathpoint( add_index )
{
	points = chopper_get_pathpoints();

	dist = DistanceSquared( points[ 0 ], level.chopper.origin );
	closest = points[ 0 ];
	index = 0;

	foreach ( i, point in points )
	{
		test = DistanceSquared( point, level.chopper.origin );
		if ( test < dist )
		{
			closest = point;
			index = i;
			dist = test;
		}
	}

	info = [];
	if ( IsDefined( add_index ) )
	{
		index = index + add_index;

		if ( index > level.chopper_segment_points )
		{
			index = index - level.chopper_segment_points;
		}

		info[ "point" ] = chopper_get_pathpoint( index );
		info[ "index" ] = index;		
	}
	else
	{
		info[ "point" ] = closest;
		info[ "index" ] = index;
	}

	return info;
}

chopper_follow_path( path_targetname, follow_player_when_done, dialog, safe_flight )
{
	self notify( "stop_chopper_fake_hover" );
	self notify( "stop_chopper_gun_face_entity" );
	self ClearLookAtEnt();
	self.speed_setting = "none";

	self ent_flag_set( "manual_control" );

	if ( !IsDefined( safe_flight ) )
	{
		safe_flight = false;
	}

	path_start = getstruct( path_targetname, "targetname" );
	path_point = path_start;
	going_to_start = true;

	while ( IsDefined( path_point ) )
	{
		if ( IsDefined( path_point.speed ) )
		{
			speed = path_point.speed;

			accel = 20;
			decel = 10;

			if ( IsDefined( path_point.script_accel ) )
			{
				accel = path_point.script_accel;
			}

			if ( IsDefined( path_point.script_decel ) )
			{
				decel = path_point.script_decel;
			}

			self Vehicle_SetSpeed( path_point.speed, accel, decel );
		}
		
		if ( IsDefined( path_point.script_speed ) )
		{
			speed = path_point.script_speed;

			accel = 20;
			decel = 10;

			if ( IsDefined( path_point.script_accel ) )
			{
				accel = path_point.script_accel;
			}

			if ( IsDefined( path_point.script_decel ) )
			{
				decel = path_point.script_decel;
			}

			self Vehicle_SetSpeedImmediate( path_point.script_speed, accel, decel );
		}

		if ( IsDefined( path_point.radius ) )
		{
			self SetNearGoalNotifyDist( path_point.radius );
		}

		stop_at_goal = false;
		if ( IsDefined( path_point.script_stopnode ) && path_point.script_stopnode )
		{
			stop_at_goal = true;
		}

		self SetGoalYaw( path_point.angles[ 1 ] );

		// If the chopper is too far away from it's goal, figure out a b-line path
		if ( going_to_start && safe_flight )
		{
			while ( distance2d_squared( path_point.origin, self.origin ) > 1000 * 1000 )
			{
				point = chopper_get_bline_path_point( path_point.origin );
				self SetVehGoalPos( point, stop_at_goal );
				self waittill_either( "near_goal", "goal" );
			}
		}

		self SetVehGoalPos( path_point.origin, stop_at_goal );
		self waittill_either( "near_goal", "goal" );

		if ( IsDefined( path_point.script_flag_set ) )
		{
			flag_set( path_point.script_flag_set );
		}

		going_to_start = false;

		if ( IsDefined( path_point.script_noteworthy ) )
		{
			[[ level.chopper_funcs[ path_point.script_noteworthy ]]]();
		}

		path_point script_delay();

		if ( !IsDefined( path_point.target ) )
		{
			break;
		}

		path_point = getstruct( path_point.target, "targetname" );
	}

	self notify( "follow_path_done" );
	
	if ( IsDefined( follow_player_when_done ) && follow_player_when_done )
	{
		self chopper_defaults();
		self.chopper_pathpoint = chopper_get_closest_pathpoint();
		self ent_flag_clear( "manual_control" );
		self thread chopper_gun_face_entity( level.groundplayer, true );
	}

	if ( IsDefined( dialog ) )
	{
		chopper_dialog( dialog );
	}
}

get_parkinglot_point()
{
	point = level.groundplayer.origin;

	point = ( clamp( point[ 0 ], -2400, 3100 ), clamp( point[ 1 ], -5300, -700 ), point[ 2 ] );

	return point;
}

get_closest_point_on_base_path()
{
	paths = [];
	struct_array = getstructarray( "base_player_path", "targetname" );

	foreach ( struct in struct_array )
	{
		paths[ paths.size ] = get_targeted_line_array( struct );
	}

	points = [];
	foreach ( path in paths )
	{
		for ( i = 0; i < path.size - 1; i++ )
		{
			points[ points.size ] = PointOnSegmentNearestToPoint( path[ i ].origin, path[ i + 1 ].origin, level.groundplayer.origin );
		}
	}

	dist = DistanceSquared( points[ 0 ], level.groundplayer.origin );
	closest_point = points[ 0 ];

	foreach ( point in points )
	{
		test_dist = DistanceSquared( point, level.groundplayer.origin );
		if ( test_dist < dist )
		{
			closest_point = point;
			dist = test_dist;
		}
	}

	// Let's not go more than 200 units off the base path
	if ( distance2d_squared( closest_point, level.groundplayer.origin ) > 200 * 200 )
	{
		angles = VectorToAngles( level.groundplayer.origin - closest_point );
		forward = AnglesToForward( angles );
		closest_point = closest_point + vector_multiply( forward, 200 );
	}
	else
	{
		closest_point = level.groundplayer.origin;
	}
	

	return closest_point;
}

distance2d_squared( pos1, pos2 )
{
	pos1 = ( pos1[ 0 ], pos1[ 1 ], 0 );
	pos2 = ( pos2[ 0 ], pos2[ 1 ], 0 );

	return DistanceSquared( pos1, pos2 );
}

is_player_in_parking_lot()
{
	return level.groundplayer IsTouching( GetEnt( "so_parkinglot", "targetname" ) );
}

// TRUCK Section ------------------------------------------
truck_init()
{
	level.truck_spawner = GetEnt( "gas_station_truck", "targetname" );
	level.truck_ai_spawners = GetEntArray( "so_truck_ai_spawner", "targetname" );
}

spawn_truck( targetname )
{
	spawner = level.truck_spawner;
	ai_spawners = level.truck_ai_spawners;

	spawner.script_startinghealth = 5000;

	spawner.targetname = "so_truck";
	spawner.target = targetname;
	foreach ( ai_spawner in ai_spawners )
	{
		ai_spawner.targetname = targetname;
	}

	truck = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "so_truck" );
	truck thread truck_brakes();

	// So the corpse of the truck cannot be moved
	truck.free_on_death = true;
}

truck_brakes()
{
	self waittill( "unloading" );
	self set_brakes( 0.5 );
}

// FX -----------------------------------------------------
smoke_mover()
{
	ent = Spawn( "script_model", ( 600, -4525, 2610 ) );
	ent.angles = ( 357, 179, 177 );
	ent SetModel( "tag_origin" );
	PlayFxOnTag( level._effect[ "objective_smoke" ], ent, "tag_origin" );
 	ent thread smoke_mover_thread();
}

// Will need a new FX to finish this off.
smoke_mover_thread()
{
	spawn_angles = self.angles;
	full_pitch = 60;
	range = 1500;
	while ( 1 )
	{
		wait( 1 );
		dist = Distance2D( level.chopper.origin, self.origin );

		percent = dist / range;

		if ( percent < 1 )
		{
			percent = 1 - percent;

			angles = VectorToAngles( vector2d( level.player.origin ) - vector2d( self.origin ) );
			angles = ( angles[ 0 ] + ( full_pitch * percent ), angles[ 1 ], angles[ 2 ] );

			self RotateTo( spawn_angles + angles, 0.5 );
		}
		else
		{
			self RotateTo( spawn_angles, 0.5 );
		}
	}
}

vector2d( vec )
{
	return ( vec[ 0 ], vec[ 1 ], 0 );
}

// Exploders ----------------------------------------------
do_exploder_custom( current, option )
{
	while( 1 )
	{
		exploder_stripped( current.script_prefab_exploder, option );
		if( !isdefined( current.target ) )
		{
			break;
		}

		next = GetEnt( current.target, "targetname" );

		if( !isdefined( next ) )
		{
			break;
		}
		current = next;
	}
}

exploder_stripped( num, option )
{
	num += "";

	//here's a hook so you can know when a certain number of an exploder is going off
	level notify( "exploding_" + num );

	for ( i = 0;i < level.createFXent.size;i++ )
	{
		ent = level.createFXent[ i ];

		if ( !isdefined( ent ) )
		{
			continue;
		}

		if ( ent.v[ "type" ] != "exploder" )
		{
			continue;
		}

		// make the exploder actually removed the array instead?
		if ( !isdefined( ent.v[ "exploder" ] ) )
		{
			continue;
		}

		if ( ent.v[ "exploder" ] + "" != num )
		{
			continue;
		}

		ent.v[ "soundalias" ] = undefined;
		ent.v[ "loopsound" ] = undefined;
		ent.v[ "damage" ] = undefined;
		ent.v[ "delay" ] = 0;
		ent.v[ "delay_min" ] = undefined;
		ent.v[ "delay_max" ] = undefined;
		ent.v[ "earthquake" ] = undefined;

		if ( IsDefined( option ) && option == "just_swap" )
		{
			ent.v[ "firefx" ] = undefined;
			ent.v[ "fxid" ] = undefined;
		}

		ent activate_individual_exploder();
	}
}

// DEBUG Section ------------------------------------------
debug_chopper_base_path()
{
/#
	if ( !debug_chopper_enabled() )
	{
		return;
	}

	while ( 1 )
	{
		wait( 0.05 );

		if ( is_player_in_parking_lot() )
		{
			continue;
		}

		closest_point = get_closest_point_on_base_path();

//		level thread draw_linesegment_point( closest_point );
		Line( closest_point, closest_point + ( 0, 0, 1000 ), ( 1, 0.5, 0 ) );
		Line( closest_point, level.groundplayer.origin, ( 1, 1, 1 ) );
	}
#/
}

// Draw the player's location with chopper flight path
// Dvar debug_follow + number will have the fake ground player move along a path
// If not using debug_follow, the player can hit use to update the fake ground player's origin 
// to whatever the chopper player is aiming at.
debug_player_pos()
{
/#
	if ( !debug_chopper_enabled() )
	{
		return;
	}

	level.groundplayer.origin = ( 84, 4450, 2260 );
	thread draw_player_pos();
	thread draw_chopper_path();

	if ( GetDvarInt( "debug_follow" ) != 0 )
	{
		num = GetDvarInt( "debug_follow" );
		start = getstruct( "follow_player_path_start" + num, "targetname" );
		struct = start;
		speed = 200;

		debug_trigger_everything();
		while ( 1 )
		{
			dist = Distance( level.groundplayer.origin, struct.origin );
			time = dist / speed;

			level.groundplayer MoveTo( struct.origin, time, 0, 0 );
			level.groundplayer waittill( "movedone" );

			struct script_delay();

			if( IsDefined( struct.target ) )
			{
				struct = getstruct( struct.target, "targetname" );
			}
			else
			{
				struct = start;
				debug_trigger_everything();
				so_chopper_invasion_moments();
				debug_kill_ai();
			}
		}
	}
	else
	{
		while ( 1 )
		{
			wait( 0.05 );
	
			if ( level.player UseButtonPressed() )
			{
				eye = level.player GetEye();
				forward = AnglesToForward( level.player GetPlayerAngles() );
				forward_origin = eye + vector_multiply( forward, 10000 );
				trace = BulletTrace( level.player GetEye(), forward_origin, false, self );
	
				level.groundplayer.origin = trace[ "position" ];
			}
		}
	}
#/
}

debug_trigger_everything()
{
/#
	foreach ( trigger in GetEntArray( "trigger_multiple_spawn", "classname" ) )
	{
		trigger thread debug_trigger_everything_think();
	}
#/
}

debug_trigger_everything_think()
{
/#
	self notify( "stop_debug_trigger_everything_think" );
	self endon( "stop_debug_trigger_everything_think" );

	if ( !IsDefined( self.spawners ) )
	{
		self.spawners = GetEntArray( self.target, "targetname" );
		foreach ( spawner in self.spawners )
		{
			spawner.old_count = spawner.count;
		}
	}
	else
	{
		foreach ( spawner in self.spawners )
		{
			spawner.count = spawner.old_count;
		}
	}

	while ( 1 )
	{
		wait( 0.05 );
		if ( level.groundplayer IsTouching( self ) )
		{
			break;
		}
	}

	self notify( "trigger" );
#/
}

// Draws the chopper flight path
draw_chopper_path()
{
/#
	while ( 1 )
	{
		wait( 0.05 );

		points = chopper_get_pathpoints();

		for ( i = 0; i < points.size; i++ )
		{
			next = i + 1;

			if ( next == points.size )
			{
				next = 0;
			}

			color = ( 1, 1, 0.3 );

//			if ( GetDvarInt( "test_chopper_path" ) > 0 )
//			{
//				if ( self.slowdown_points.size > 0 )
//				{
//					if ( self.slowdown_points[ i ] )
//					{
//						color = ( 0.3, 1, 0.3 );
//					}
//				}
//			}

			Line( points[ i ], points[ next ], color );
		}
	}
#/
}

draw_linesegment_point( pos )
{
/#
	level notify( "stop_draw_linesegment_point" );
	level endon( "stop_draw_linesegment_point" );	

	while ( 1 )
	{
		Line( pos, pos + ( 0, 0, 1000 ), ( 1, 1, 0.1 ) );
		wait( 0.05 );
	}
#/
}

// Draws the ground player's position
draw_player_pos( pos )
{
/#
	while ( 1 )
	{
		wait( 0.05 );
		Line( level.groundplayer.origin, level.groundplayer.origin + ( 0, 0, 1000 ), ( 0.3, 1, 0.3 ) );
	}
#/
}

// Draws all of the high objstacle points
draw_high_obstacles()
{
/#
	structs = getstructarray( "high_obstacle", "targetname" );
	foreach ( struct in structs )
	{
		struct thread draw_high_obstacle();
	}
#/
}

draw_high_obstacle()
{
/#
	while ( 1 )
	{
		wait( 0.05 );
		Line( self.origin, self.origin + ( 0, 0, -5000 ), ( 1, 1, 1 ) );
	}
#/
}

debug_kill_ai()
{
/#
	foreach ( ai in GetAIArray( "axis" ) )
	{
		ai Kill();
	}
#/
}

debug_chopper_enabled()
{
/#
	return GetDvarInt( "debug_chopper" ) == 1;
#/
}

debug_draw_chopper_line( pos, note, color )
{
/#
	level notify( note );
	level endon( note );

	if ( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	if ( !debug_chopper_enabled() )
	{
		return;
	}

	while ( 1 )
	{
		wait( 0.05 );
		Line( pos, level.chopper.origin, color );
	}
#/
}

debug_draw_enemy_direction( angle, note )
{
/#
	level notify( note );
	level endon( note );

	color = ( 1, 1, 1 );

	if ( !debug_chopper_enabled() )
	{
		return;
	}

	while ( 1 )
	{
		wait( 0.05 );
		pos = level.groundplayer.origin + vector_multiply( AnglesToForward( angle ), 1000 );
		Line( pos, level.groundplayer.origin, color );
	}
#/
}