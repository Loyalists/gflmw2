#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\utility;
#include maps\_vehicle_spline_zodiac;
#include maps\_vehicle;

trigger_multiple_speed_think()
{
	speed = self.script_speed;
	AssertEx( IsDefined( speed ), "Trigger at " + self.origin + " has no script_speed" );

	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isdefined( other.vehicle ) )
			continue;
		other.vehicle.veh_topspeed = speed;
	}
}

//hmmmmmmmm

/*QUAKED trigger_multiple_speed (0.12 0.23 1.0) ? AI_AXIS AI_ALLIES AI_NEUTRAL NOTPLAYER VEHICLE TRIGGER_SPAWN TOUCH_ONCE
defaulttexture="trigger"
Set the player vehicle maxspeed with script_speed.*/

ZODIAC_TREADFX_MOVETIME = .2;
ZODIAC_TREADFX_MOVETIMEFRACTION = 1 / ( ZODIAC_TREADFX_MOVETIME + .05 );
ZODIAC_TREADFX_HEIGHTOFFSET = ( 0, 0, 16 );

zodiac_treadfx_chaser( chaseobj )
{
	// self here is the invisible boat for playing leveled wake fx.
	PlayFXOnTag( getfx( "zodiac_wake_geotrail" ), self, "tag_origin" );
	self NotSolid();
	self Hide();
	self endon( "death" );
	chaseobj endon( "death" );

	// needs to be it's own thread so can cleanup after the thing dies.
	thread zodiac_treadfx_chaser_death( chaseobj );

	chaseobj ent_flag_init( "in_air" );

	childthread zodiac_treadfx_stop_notify( chaseobj );
	childthread zodiac_treadfx_toggle( chaseobj );

	while ( IsAlive( chaseobj ) )
	{
//		self DontInterpolate();
		self MoveTo( chaseobj GetTagOrigin( "tag_origin" ) + ZODIAC_TREADFX_HEIGHTOFFSET + ( chaseobj Vehicle_GetVelocity() / ZODIAC_TREADFX_MOVETIMEFRACTION ), ZODIAC_TREADFX_MOVETIME );
		self RotateTo( ( 0, chaseobj.angles[ 1 ], 0 ), ZODIAC_TREADFX_MOVETIME ) ;
		wait ZODIAC_TREADFX_MOVETIME + .05;// + .05 to get rid of silly jiggle at the end when issueing back to back moveto's. Code bug I believe.
		waittillframeend;
	}
	self Delete();
}

zodiac_treadfx_toggle( chaseobj )
{
	while ( 1 )
	{
		msg = chaseobj waittill_any_return( "zodiac_treadfx_stop", "veh_leftground" );
		if ( msg == "veh_leftground" )
			chaseobj ent_flag_set( "in_air" );

		StopFXOnTag( getfx( "zodiac_wake_geotrail" ), self, "tag_origin" );

		msg = chaseobj waittill_any_return( "zodiac_treadfx_go", "veh_landed" );
		if ( msg == "veh_landed" )
			chaseobj ent_flag_clear( "in_air" );

		PlayFXOnTag( getfx( "zodiac_wake_geotrail" ), self, "tag_origin" );
	}
}

zodiac_treadfx_stop_notify( chaseobj )
{
	while ( 1 )
	{
		if ( chaseobj Vehicle_GetSpeed() < 4 )
			chaseobj notify( "zodiac_treadfx_stop" );
		else if ( ! chaseobj ent_flag( "in_air" ) )
			chaseobj notify( "zodiac_treadfx_go" );
		wait .05;
	}
}

zodiac_treadfx_chaser_death( chaseobj )
{
	chaseobj waittill_any( "stop_bike", "death", "kill_treadfx" );
	self Delete();
}

zodiac_treadfx()
{
	chaser = Spawn( "script_model", self.origin );
	chaser SetModel( self.model );
	chaser.angles = ( 0, self.angles[ 1 ], 0 );
	chaser thread zodiac_treadfx_chaser( self );
}

enemy_chase_boat_breadcrumb()
{
	struct = SpawnStruct();
	struct.origin = self.origin;
	struct.angles = flat_angle( self.angles );
	struct.spawn_time = GetTime();
	level.breadcrumb[ level.breadcrumb.size ] = struct;
}

vehicle_dump()
{
	predumpvehicles = GetEntArray( "script_vehicle", "code_classname" );
	vehicles = [];

	// dumping can jump a frame in which the information could be altered, this stores the necessary info real quick
	foreach ( vehicle in predumpvehicles )
	{
		if ( IsSpawner( vehicle ) )
			continue;
		struct = SpawnStruct();
		struct.classname = vehicle.classname;
		struct.origin = vehicle.origin;
		struct.angles = vehicle.angles;
//		struct.spawner_id = vehicle.spawner_id;
		struct.speedbeforepause = vehicle Vehicle_GetSpeed();
		struct.script_VehicleSpawngroup = vehicle.script_vehiclespawngroup;
		struct.script_VehicleStartMove = vehicle.script_vehiclestartmove;
		struct.model = vehicle.model;
		struct.angles = vehicle.angles;
		if ( IsDefined( level.playersride ) && vehicle == level.playersride )
			struct.playersride = true;
		vehicles[ vehicles.size ] = struct;
	}

	fileprint_launcher_start_file();
	fileprint_map_start();

	foreach ( i, vehicle in vehicles )
	{
		origin = fileprint_radiant_vec( vehicle.origin );// convert these vectors to mapfile keypair format
		angles = fileprint_radiant_vec( vehicle.angles );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "classname", "script_struct" );
			fileprint_map_keypairprint( "model", vehicle.model );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "angles", angles );
			if ( IsDefined( vehicle.speedbeforepause ) )
				fileprint_map_keypairprint( "current_speed", vehicle.speedbeforepause );
			if ( IsDefined( vehicle.script_VehicleSpawngroup ) )
				fileprint_map_keypairprint( "script_vehiclespawngroup", vehicle.script_VehicleSpawngroup );
			if ( IsDefined( vehicle.script_VehicleStartMove ) )
				fileprint_map_keypairprint( "script_vehiclestartmove", vehicle.script_VehicleStartMove );
		fileprint_map_entity_end();
	}
	map_name = level.script + "_veh_ref.map";
	fileprint_launcher_end_file( "/map_source/" + map_name );
	launcher_write_clipboard( map_name );
}

draw_crumb( crumb, lastcrumb, fraction )
{
	if ( !flag( "debug_crumbs" ) )
		return;
	left_spot = crumb.origin + AnglesToRight( crumb.angles ) * -1000 ;
	right_spot = crumb.origin + AnglesToRight( crumb.angles ) * 1000 ;
	color = ( fraction, 1 - fraction, 0 );

	Line( left_spot, right_spot, color );

	if ( !isdefined( lastcrumb ) )
		return;

	left_spot_last = lastcrumb.origin + AnglesToRight( lastcrumb.angles ) * -1000 ;
	right_spot_last = lastcrumb.origin + AnglesToRight( lastcrumb.angles ) * 1000 ;
	Line( left_spot, left_spot_last, color );
	Line( right_spot, right_spot_last, color );
}

zodiac_physics()
{
	self.bigjump_timedelta = 500;
	self.event_time = -1;
	self.event = [];
	self.event[ "jump" ] = [];
	self.event[ "jump" ][ "driver" ] = false;
	self.event[ "jump" ][ "passenger" ] = false;
	self.event[ "bump" ] = [];
	self.event[ "bump" ][ "driver" ] = false;
	self.event[ "bump" ][ "passenger" ] = false;
	self.event[ "bump_big" ] = [];
	self.event[ "bump_big" ][ "driver" ] = false;
	self.event[ "bump_big" ][ "passenger" ] = false;
	self.event[ "sway_left" ] = [];
	self.event[ "sway_left" ][ "driver" ] = false;
	self.event[ "sway_left" ][ "passenger" ] = false;
	self.event[ "sway_right" ] = [];
	self.event[ "sway_right" ][ "driver" ] = false;
	self.event[ "sway_right" ][ "passenger" ] = false;
	self childthread watchVelocity();
	self childthread listen_leftground();
	self childthread listen_landed();
	self childthread listen_jolt();
	self childthread listen_bounce();
	self childthread listen_turn_spray();
//	self thread listen_collision();
}

zodiac_fx( fxName )
{
	tag = "tag_origin";

	if ( IsDefined( level._effect_tag[ fxName ] ) )
		tag = level._effect_tag[ fxName ];

	if ( IsDefined( level._effect[ fxName ] ) )
		PlayFXOnTag( level._effect[ fxName ], self, tag );
		//iprintlnbold( fxName );
	if ( IsDefined( level.zodiac_fx_sound[ fxname ] ) )
		thread play_sound_on_entity( level.zodiac_fx_sound[ fxname ] );
		//println( fxName );
}

listen_leftground()
{
	self endon( "death" );
	flag_wait( "player_on_boat" );
	for ( ;; )
	{
		self waittill( "veh_leftground" );
		self.event_time = GetTime();
		self.event[ "jump" ][ "driver" ] = true;
		self.event[ "jump" ][ "passenger" ] = true;

		zodiac_fx( "zodiac_leftground" );
	}
}

listen_landed()
{
	self endon( "death" );
	wait 2; // no ignore the land that happens when they spawn above the water.
	flag_wait( "player_on_boat" );
	for ( ;; )
	{
		self waittill( "veh_landed" );
		if ( self.event_time + self.bigjump_timedelta < GetTime() )
		{
			self.event[ "bump_big" ][ "driver" ] = true;
			self.event[ "bump_big" ][ "passenger" ] = true;
			if ( ! flag( "player_in_sight_of_boarding" ) )
				thread water_bump( "bump_big" );
			if ( self == level.players_boat )
				zodiac_fx( "player_zodiac_bumpbig" );
			else
				zodiac_fx( "zodiac_bumpbig" );


		}
		else
		{
			self.event[ "bump" ][ "driver" ] = true;
			self.event[ "bump" ][ "passenger" ] = true;
			if ( ! flag( "player_in_sight_of_boarding" ) )
				thread water_bump( "bump" );
			if ( self == level.players_boat )
				zodiac_fx( "player_zodiac_bump" );
			else
				zodiac_fx( "zodiac_bump" );
		}
	}
}

trigger_set_water_sheating_time( bump_small, bump_big )
{
	self waittill( "trigger" );
	set_water_sheating_time( bump_small, bump_big );
}

set_water_sheating_time( bump_small, bump_big )
{
	// duplicated in af_chase_knife_fight_code
	level.water_sheating_time[ "bump" ] = level.water_sheating_time[ bump_small ];
	level.water_sheating_time[ "bump_big" ] = level.water_sheating_time[ bump_big ];
}

water_bump( bumptype )
{
	if ( !isdefined( level.players_boat ) ||  self != level.players_boat )
		return;
	level endon( "missionfailed" );
	if ( flag( "missionfailed" ) )
		return;

	if ( bumptype == "bump_big" )
		level.player PlayRumbleOnEntity( "damage_heavy" );
	else
		level.player PlayRumbleOnEntity( "damage_light" );

	if ( !flag( "no_more_physics_effects" ) )
		level.player SetWaterSheeting( 1, level.water_sheating_time[ bumptype ] );
}

listen_jolt()
{
	self endon( "death" );
	flag_wait( "player_on_boat" );
	for ( ;; )
	{
		self waittill( "veh_jolt", jolt );
		if ( jolt[ 1 ] >= 0 )
		{
			self.event[ "sway_left" ][ "driver" ] = true;
			self.event[ "sway_left" ][ "passenger" ] = true;

			zodiac_fx( "zodiac_sway_left" );
		}
		else
		{
			self.event[ "sway_right" ][ "driver" ] = true;
			self.event[ "sway_right" ][ "passenger" ] = true;

			zodiac_fx( "zodiac_sway_right" );
		}
	}
}

listen_bounce()
{
	self endon( "death" );
	flag_wait( "player_on_boat" );

	for ( ;; )
	{
		self waittill( "veh_boatbounce", force );

//		if ( self == level.players_boat )
//			IPrintLnBold( force );

		if ( force < 50.0 )
		{
			//PlayFXOnTag( getfx( "zodiac_bounce_small_left" ), self, "TAG_FX_LF" );
			//PlayFXOnTag( getfx( "zodiac_bounce_small_left" ), self, "TAG_FX_RF" );
			zodiac_fx( "zodiac_bounce_small_left" );
			zodiac_fx( "zodiac_bounce_small_right" );
		}
		else
		{
			//PlayFXOnTag( getfx( "zodiac_bounce_large_left" ), self, "TAG_FX_LF" );
			//PlayFXOnTag( getfx( "zodiac_bounce_large_left" ), self, "TAG_FX_RF" );
			zodiac_fx( "zodiac_bounce_large_left" );
			zodiac_fx( "zodiac_bounce_large_right" );
		}
	}
}

listen_turn_spray()
{
    self endon( "death" );
    while ( 1 )
    {
        velocity = self Vehicle_GetBodyVelocity();

        if ( self Vehicle_GetSpeed() > 40 )
        {
            if ( velocity[ 1 ] < -150.0 )
                zodiac_fx( "zodiac_sway_right" );
            else if ( velocity[ 1 ] > 150.0 )
                zodiac_fx( "zodiac_sway_left" );
        }
        else if ( self Vehicle_GetSpeed() > 10 )
        {
            if ( velocity[ 1 ] < -30.0 )
                zodiac_fx( "zodiac_sway_right_light" );
            else if ( velocity[ 1 ] > 30.0 )
                zodiac_fx( "zodiac_sway_left_light" );
        }
        wait .05;
    }
}

listen_collision()
{
	self endon( "death" );

	for ( ;; )
	{
		self waittill( "veh_collision", collision, start_vel );

		foreach ( rider in self.riders )
		{
			if ( IsAlive( rider ) && !isdefined( rider.magic_bullet_shield ) )
			{
//				rider.specialDeathFunc = animscripts\snowmobile::snowmobile_collide_death;
				rider Kill();
			}
		}
		zodiac_fx( "zodiac_collision" );
	}
}

watchVelocity()
{
	self endon( "death" );
	vel = self Vehicle_GetVelocity();
	for ( ;; )
	{
		self.prevFrameVelocity = vel;
		vel = self Vehicle_GetVelocity();
		wait .05;
	}
}

autosave_boat_chase()
{
	// I should just replace these with real autosave triggers.
	self waittill( "trigger" );

	if ( IsDefined( self.targetname ) )
		autosave_by_name( self.targetname );
	else
		autosave_by_name( "boat_chase" );
}

autosave_boat_check_trailing()
{
	return bread_crumb_get_player_trailing_fraction() < .5;
}

autosave_boat_check_player_speeding_along()
{
	return level.players_boat Vehicle_GetSpeed() > 20;
}

bread_crumb_get_player_trailing_fraction()
{
	if ( ! level.breadcrumb.size )
		return 0;
	crumb = level.breadcrumb[ 0 ];
	time = ( GetTime() - crumb.spawn_time ) / 1000;
	return time / level.breadcrumb_settings.fail_time;
}

bread_crumb_chase()
{
	/#
	SetDvarIfUninitialized( "scr_debug_breadcrumbs", 1 );
	#/

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/

	currenttime = GetTime();
	lastcrumb = undefined;
	test_array = [];
	count = 0;

	foreach ( crumb in level.breadcrumb )
	{
		time = ( currenttime - crumb.spawn_time ) / 1000;
		trailing_fraction = time / level.breadcrumb_settings.fail_time;

		if ( trailing_fraction > 1 )
			bread_crumb_fail();

		if ( ! count )
			breadcrumb_docatchup( trailing_fraction );

		if ( count < level.breadcrumb_settings.checkdepth )
			test_array[ count ] = crumb;

		if ( is_breadcrumb_debug() )
			draw_crumb( crumb, lastcrumb, trailing_fraction );

		lastcrumb = crumb;
		count++;
	}

//	skipped = false;
	foreach ( crumb in test_array )
	{
		vec = AnglesToForward( crumb.angles );
		vec2 = VectorNormalize( ( level.player.origin - crumb.origin ) );
		vecdot = VectorDot( vec, vec2 );
		if ( vecdot > 0 )
			level.breadcrumb = array_remove( level.breadcrumb, crumb );
	}
}

breadcrumb_docatchup( trailing_fraction )
{
	if ( trailing_fraction < .25 )
		flag_set( "zodiac_catchup" );
	else
		flag_clear( "zodiac_catchup" );
}

bread_crumb_fail()
{
	if ( !isalive( level.player ) )
		return;

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/

	// Shepherd got away.
	level notify ( "stop_deadquote_for_gettingout_of_bounds" );
	SetDvar( "ui_deadquote", &"AF_CHASE_MISSION_FAILED_KEEP_UP" );
	if ( level.start_point != "test_boat_current" )
		missionFailedWrapper();
}

is_breadcrumb_debug()
{
	return GetDvarInt( "scr_debug_breadcrumbs" );
}

zodiac_monitor_player_trailing_time()
{
	self endon( "death" );
	flag_wait( "player_on_boat" );
	while ( 1 )
	{
		level waittill( "zodiac_catchup" );

		if ( flag( "zodiac_boarding" ) )
			return;

		if ( flag( "zodiac_catchup" ) )
		{
			player_boat_speed_plus = level.players_boat Vehicle_GetSpeed() + 5;
			if ( self Vehicle_GetSpeed() < player_boat_speed_plus )
				self Vehicle_SetSpeed( player_boat_speed_plus, 15, 15 );
			player_boat_speed_plus = undefined;
		}
		else
			self ResumeSpeed( 15 );
	}
}

zodiac_catchup()
{
	player_speed_plus = level.players_boat Vehicle_GetSpeed() + 5;
	if ( self Vehicle_GetSpeed() < player_speed_plus )
		self Vehicle_SetSpeed( player_speed_plus, 15, 15 );
}

is_main_enemy_boat()
{
	if ( !isdefined( self.targetname ) )
		return false;
	return self.targetname == "enemy_chase_boat";
}

zodiac_boat_ai( boat )
{
// kill _vehicle_anim stuff. not completely just gets them out of idle loop
	if ( !isai( self ) )
		return;
	self notify( "newanim" );

	//make them crouch
	self.desired_anim_pose = "crouch";
	self AllowedStances( "crouch" );
	self thread animscripts\utility::UpdateAnimPose();
	self AllowedStances( "crouch" );

	self.baseaccuracy = 0;// don't get accurate untill they are in range.
	self.accuracystationarymod = .5;
}

heli_attack_player_idle()
{
	self waittill( "trigger", heli );

	level.players_boat endon( "death" );
	heli thread mgoff();

	heli endon( "death" );

	heli thread handle_fire_missiles();

	while ( Distance( level.player.origin, self.origin ) > 8500 )
		wait .05;

	heli thread mgon();
	foreach ( turret in heli.mgturret )
	{
		turret SetAISpread( 2 );
		turret SetConvergenceTime( 5 );
		turret.accuracy = .5;
	}

	if ( ! flag( "rapids_trigger" ) )// don't care about this particular dialog after the rapids.
		level notify( "dialog_helicopter_ahead" );

	heli SetLookAtEnt( level.player );


	while ( in_front( level.players_boat, heli ) )
		wait .05;

	if ( ! flag( "rapids_trigger" ) )// don't care about this particular dialog after the rapids.
		level notify( "dialog_helicopter_six" );


	foreach ( turret in heli.mgturret )
	{
		turret SetAISpread( 20 );
		turret SetConvergenceTime( 7 );
		turret.accuracy = 0;
	}

	wait 3;// let it try to converge then turn it off.

	heli thread mgoff();

}

rumble_with_throttle()
{
	rumble_ent = get_rumble_ent();

	throttle_leveling_time = 3.4;

	level_throttle = .01;

	full_throttled_time = 0;

	rumble_fraction = .13;

	while ( 1 )
	{
		throttle = self Vehicle_GetThrottle();

		full_throttled_time += .05;

		if ( throttle < .5 )
		{
			full_throttled_time = 0;
			throttle_level_fraction = 1;
		}
		else
		{
			throttle_level_fraction = 1 - ( full_throttled_time / throttle_leveling_time );
		}

		rumble_ent.intensity = ( throttle * rumble_fraction * throttle_level_fraction );

		if ( full_throttled_time > throttle_leveling_time || self Vehicle_GetSpeed() > 43 )
		{
			full_throttled_time = throttle_leveling_time;// probably not necessary. just keeping the number from going really high.
			rumble_ent.intensity = 0;
		}

		wait .05;
		if ( flag( "player_in_sight_of_boarding" ) )
			break;
	}
	rumble_ent Delete();
}

kill_ai_in_volume()
{
	volume = GetEnt( self.target, "targetname" );
	Assert( IsDefined( volume ) );

	self waittill( "trigger" );
	ai = GetAIArray();

	foreach ( guy in ai )
		if ( guy IsTouching( volume ) && !guy is_hero() )
			guy Delete();

	//hack.. shortcutting adding another volume. want to delete these fx forever.
	tester = Spawn( "script_origin", ( 0, 0, 0 ) );

	inc = 0;
	foreach ( createfxent in level.createfxent )
	{
		inc++;
		if ( IsDefined( createfxent.looper ) )
		{
			level.createfxent = array_remove( level.createfxent, createfxent );
			tester.origin = createfxent.v[ "origin" ];
			if ( tester IsTouching( volume ) )
				createfxent.looper Delete();
		}
		if ( inc > 3 )
		{
			inc = 0;
			wait .05;
		}
	}
	tester Delete();
}

kill_all_the_ai_and_fx_from_boatride()
{
	kill_ai_in_volume = GetEntArray( "kill_ai_in_volume", "targetname" );
	foreach ( trigger in kill_ai_in_volume )
	{
		wait( 0.1 );
		trigger notify( "trigger", level.player );
	}
}

kill_destructibles_and_barrels_in_volume()
{
	volume = GetEnt( self.target, "targetname" );
	Assert( IsDefined( volume ) );

	self waittill( "trigger" );

	shootable_stuff = GetEntArray( "destructible_toy", "targetname" );

	inc = 0;
	foreach ( thing in shootable_stuff )
	{
		thing delete_shootable_stuff_in_volume( volume );
		inc++;
		if ( inc > 3 )
		{
			inc = 0;
			wait .05;
		}
	}

 	//dupping script for speed.
	shootable_stuff = GetEntArray( "explodable_barrel", "targetname" );
	foreach ( thing in shootable_stuff )
	{
		thing delete_shootable_stuff_in_volume( volume );
		inc++;
		if ( inc > 3 )
		{
			inc = 0;
			wait .05;
		}
	}

}

delete_shootable_stuff_in_volume( volume )
{
	if ( ! self IsTouching( volume ) )
		return;

	self notify( "delete_destructible" );// kill the effects looping first.
	self Delete();
}

disable_origin_offset()
{
	// I need this for more precise hovering with the ramp in the water.
	self.originheightoffset = undefined;

}


destructible_fake()
{
	self waittill( "trigger" );
	destructible_org = GetEnt( self.target, "targetname" );

	radius = 600;
	if ( IsDefined( destructible_org.radius ) )
		radius = destructible_org.radius;

	count = 3;

	destructible_damage_count_in_radius( count, radius, destructible_org.origin );

}

destructible_damage_count_in_radius( count, radius, origin )
{
	destructible_toys = get_array_of_closest( origin, GetEntArray( "destructible_toy", "targetname" ), undefined, count, radius, 0 )  ;
	foreach ( toy in destructible_toys )
	{
		wait RandomFloatRange( .1, .4 );
//		toy thread common_scripts\_destructible::force_explosion();
		thread destroy_fast( toy );
	}
}

destroy_fast( toy )
{
	for ( i = 0; i < 5; i++ )
	{
		toy notify( "damage", 160, level.player, self.origin, toy.origin, "MOD_PISTOL_BULLET", "", "" );
		wait RandomFloatRange( .1, .2 );
	}

}

raise_attacker_accuracy_on_nearby_boats()
{
	flag_wait( "player_on_boat" );

	level.players_boat endon( "death" );
	while ( 1 )
	{
		attack_boats_in_range_in_front();
		wait .05;
	}
}

SQRT_BOATS_IN_RANGE = 1400 * 1400;
SQRT_BOATS_IN_RANGE_BEHIND = 50 * 50;

attack_boats_in_range_in_front( range, backrange )
{
	boats = GetEntArray( "script_vehicle_zodiac_physics", "classname" );

	return_boats = [];
	foreach ( boat in boats )
	{
		if ( boat  == level.players_boat )
			continue;
		if ( IsSpawner( boat ) )
			continue;
		if ( ! boat_in_range_in_front( boat ) )
			continue;

		boat thread raise_attacker_accuracy_while_in_range();
	}
	return return_boats;
}

raise_attacker_accuracy_while_in_range()
{
	self notify( "raise_attacker_accuracy_while_in_range" );
	self endon( "raise_attacker_accuracy_while_in_range" );
	self endon( "death" );

	foreach ( rider in self.riders )
	{
		rider.baseaccuracy = 6;
//		rider.baseaccuracy = 10;
		rider.suppressionwait = 1000;
	}

	while ( boat_in_range_in_front( self ) )
		wait .05;

	foreach ( rider in self.riders )
	{
		rider.baseaccuracy = 0;
//		rider.ignoreSuppression = false;
	}
}

boat_in_range_in_front( boat )
{
	if ( flag( "player_in_open" ) )
		return true;
	if ( DistanceSquared( boat.origin, level.players_boat.origin ) > SQRT_BOATS_IN_RANGE )
		return false;
	dot = get_dot( level.players_boat.origin, level.players_boat.angles, boat.origin );
//	if ( dot < 0 && DistanceSquared( boat.origin, level.players_boat.origin ) > SQRT_BOATS_IN_RANGE_BEHIND )
	if ( dot < 0.642787 )// ~50
		return false;
	return true;
}

conveyerbelt_speed( yaw, speed, rate )
{
	level.VehPhys_SetConveyorBelt_yaw = yaw;

	speeddiff = speed - level.VehPhys_SetConveyorBelt_speed;

	if ( speeddiff == 0 )
		return;

	time = abs( speeddiff / rate );

	level notify( "conveyerbelt_speed" );
	level endon( "conveyerbelt_speed" );

	iterations = Int( time / .05 ) ;

	speedinc = 0;
	if ( iterations != 0 )
		speedinc = speeddiff / iterations;
	else
		return;

	for ( i = 0; i < iterations; i++ )
	{
		wait .05;
		level.VehPhys_SetConveyorBelt_speed += speedinc;
	}

	level.VehPhys_SetConveyorBelt_speed = speed;

}

CONVEYERBELT_PLAYER_MAX_SPEED = 40;
CONVEYERBELT_PLAYER_MIN_SPEED = 20;

conveyerbelt_player_speed_mod()
{
	mod = 1;
	dif = CONVEYERBELT_PLAYER_MAX_SPEED - CONVEYERBELT_PLAYER_MIN_SPEED;

	velocity =  level.players_boat Vehicle_GetVelocity();
	speed = Distance( velocity, ( 0, 0, 0 ) ) / 17.6;

	velocity = flat_origin( velocity );

	normal = VectorNormalize( velocity );
	forward = AnglesToForward( ( 0, level.VehPhys_SetConveyorBelt_yaw, 0 ) );
	dot = VectorDot( forward, normal );

//	speed = level.players_boat Vehicle_GetSpeed();

	if ( flag( "enemy_heli_takes_off" ) )
		mod = 1;
	if ( speed > CONVEYERBELT_PLAYER_MAX_SPEED )
		mod = 0;
	else if ( speed < CONVEYERBELT_PLAYER_MIN_SPEED )
		mod = 1;
	else
	{
		players_dif = speed - CONVEYERBELT_PLAYER_MIN_SPEED;
		mod = 1 - ( players_dif / dif );
	}
	level.conveyerbelt_player_speed_mod = level.VehPhys_SetConveyorBelt_speed * mod;// for debugging

	level.conveyerbelt_player_speed_mod *= level.VehPhys_SetConveyorBelt_speed_fraction;

	self VehPhys_SetConveyorBelt( level.VehPhys_SetConveyorBelt_yaw, level.conveyerbelt_player_speed_mod );
}

conveyerbelt_set_speed_fraction( dest_fraction, time )
{
	level notify( "conveyerbelt_set_speed_fraction" );
	level endon( "conveyerbelt_set_speed_fraction" );

	if ( time == 0 )
	{
		level.VehPhys_SetConveyorBelt_speed_fraction = dest_fraction;
		return;
	}

	current_fraction = level.VehPhys_SetConveyorBelt_speed_fraction;
	incs = Int( time * 20 );
	fraction_increment = ( dest_fraction - current_fraction ) / incs;

	for ( i = 0; i < incs; i++ )
	{
		level.VehPhys_SetConveyorBelt_speed_fraction += fraction_increment;
		wait .05;
	}

	level.VehPhys_SetConveyorBelt_speed_fraction = dest_fraction;
}

conveyerbelt_clear_speed_fraction()
{
	conveyerbelt_set_speed_fraction( 1 );
}

set_fixed_node_after_seeing_player_spawn_func()
{
	self endon( "death" );

	if ( IsSubStr( self.classname, "shepherd" ) )
		return;

	while ( !self CanSee( level.player ) && Distance( self.origin, level.player.origin ) > 3500 )
		wait .1;
	self.fixednode = true;

	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
}

CONVEYER_RATE = 4;
river_current( noteworthy )
{
	level notify( "new_river_current" );
	level endon( "new_river_current" );

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/

	current_node = getstruct( noteworthy, "script_noteworthy" );
	next_node = getstruct( current_node.target, "targetname" );

	maxdropspeed_cos = Cos( 35 );
	maxdropspeed = 45;
	maxdropspeed_lower_cap = maxdropspeed;
	mindropspeed_cos = Cos( 3 );
	mindropspeed = 10;

	if ( IsDefined( current_node.script_speed ) )
		mindropspeed = current_node.script_speed;

	next_angle = get_next_angle( next_node );

	level.VehPhys_SetConveyorBelt_speed = 4;

	flag_wait( "player_on_boat" );

	level.players_boat endon( "death" );

	level endon( "player_over_the_waterfall" );
	level endon( "water_cliff_jump_splash_sequence" );

	childthread river_current_apply();

	flat_angle = ( 0, 0, 0 );

	while ( 1 )
	{
		dot = get_dot( next_node.origin, next_angle, level.players_boat.origin );
		if ( dot < 0 )
		{
//			draw_arrow( current_node.origin , next_node.origin, (0,1,0) );

			dot = get_dot( current_node.origin, flat_angle( VectorToAngles( next_node.origin - current_node.origin ) ), level.players_boat.origin );
			if ( dot > 0 )
			{
				wait .05;
				continue;
			}
			else
			{
				current_node = getstruct( current_node.targetname, "target" );
				if ( !isdefined( current_node ) )
				{
					current_node = getstruct( next_node.targetname, "target" );// reset to the first node..
					level.players_boat thread conveyerbelt_speed( flat_angle[ 1 ], 0, CONVEYER_RATE );
				}
			}
		}
		else
		{
			current_node = next_node;
		}

		if ( IsDefined( current_node.script_speed ) )
			mindropspeed = current_node.script_speed;
		if ( !isdefined( current_node.target ) )
			break;

		if ( mindropspeed > maxdropspeed_lower_cap )
			maxdropspeed = mindropspeed + 20;
		else
			maxdropspeed = maxdropspeed_lower_cap;
		next_node = getstruct( current_node.target, "targetname" );
		if ( !isdefined( next_node ) )
		{
			next_node = current_node;
			current_node = getstruct( next_node.targetname, "target" );// keep cycling the last section in this case.
			wait .05;
			continue;
		}

		if ( IsDefined( next_node.target ) )
			next_angle = get_next_angle( next_node );

		speed = mindropspeed;
		flat_angle =  flat_angle( VectorToAngles( next_node.origin - current_node.origin ) );

		dot = get_dot( current_node.origin, flat_angle, next_node.origin );
		dot = abs( dot );

		if ( dot > mindropspeed_cos )
			speed = mindropspeed;
		else if ( dot < maxdropspeed_cos )
			speed = maxdropspeed;
		else
			speed = maxdropspeed_cos / dot * maxdropspeed;

		level.boatdropspeed = speed;
		level.players_boat childthread conveyerbelt_speed( flat_angle[ 1 ], speed, CONVEYER_RATE );

		wait .05;
	}
	level.players_boat childthread conveyerbelt_speed( 0, 0, CONVEYER_RATE );
}

river_current_apply()
{

	if ( !isdefined( level.VehPhys_SetConveyorBelt_speed_fraction ) )
		level.VehPhys_SetConveyorBelt_speed_fraction = 1;

	while ( !isdefined( level.vehphys_setconveyorbelt_yaw ) )
		wait .05;

	level.players_boat endon( "death" );

	while ( 1 )
	{
		level.players_boat conveyerbelt_player_speed_mod();
		wait .05;
	}
}

get_next_angle( current_node, currentangles )
{
	next_node = getstruct( current_node.target, "targetname" );
	Assert( IsDefined( next_node ) );
	return VectorToAngles( next_node.origin - current_node.origin );
}

enable_bread_crumb_chase()
{
	s = SpawnStruct();
	s.checkdepth = 3;// how far up the chain do I crawl to see if we're caught up.
	s.fail_time = 10;// how far behind the player is allowed to trail..

	level endon( "quit_bread_crumb" );

	level.breadcrumb_settings = s;

	level.breadcrumb = [];

//	thread bread_crumb_button();

	while ( 1 )
	{
		bread_crumb_chase();
		wait .05;
	}
}

set_breadcrumb_fail_time( fail_time, transition_time )
{
	if ( !isdefined( transition_time ) )
	{
		level.breadcrumb_settings.fail_time = fail_time;
		return;
	}

	level notify( "set_breadcrumb_fail_time" );
	level endon( "set_breadcrumb_fail_time" );

	last_time = level.breadcrumb_settings.fail_time;
	increase_time_by = fail_time - last_time;
	increments = transition_time * 20;
	inc_step = increase_time_by / increments;

	for ( i = 0; i < increments; i++ )
	{
		level.breadcrumb_settings.fail_time += inc_step;
		wait .05;
	}

	level.breadcrumb_settings.fail_time = fail_time;

}

bread_crumb_button()
{
	while ( 1 )
	{
		while ( !level.player ButtonPressed( "BUTTON_Y" ) )
			wait .05;
		if ( flag( "debug_crumbs" ) )
			flag_clear( "debug_crumbs" );
		else
			flag_set( "debug_crumbs" );
		while ( level.player ButtonPressed( "BUTTON_Y" ) )
			wait .05;
	}
}

test_m203()
{
	level.price endon( "death" );
	effect = LoadFX( "muzzleflashes/m203_flshview" );
	while ( ! flag( "exit_caves" ) )
	{
		start = level.price GetTagOrigin( "tag_flash" );
		angles = level.price GetTagAngles( "tag_flash" );
		if ( level.price has_good_enemy_for_grenade_launcher( start, angles ) )
		{
			 PlayFXOnTag( effect, level.price, "tag_flash" );
			shootpos = level.price.enemy GetShootAtPos() + ( 0, 0, 150 );
			if ( Distance( level.price.origin, level.price.enemy.origin ) > 1700 )
				shootpos += ( 0, 0, 150 );// I'm just guessing here.  magical numbers make grenads go farther..
			MagicBullet( "m203", start, shootpos );
			wait 2.5;
		}
		wait .05;
	}
}

test_m203_again()
{
	level.price endon( "death" );
	effect = LoadFX( "muzzleflashes/m203_flshview" );
	while ( 1 )
	{
		start = level.price GetTagOrigin( "tag_flash" );
		angles = level.price GetTagAngles( "tag_flash" );
		if ( level.price has_good_enemy_for_grenade_launcher( start, angles ) )
		{
			 PlayFXOnTag( effect, level.price, "tag_flash" );
			shootpos = level.price.enemy GetShootAtPos() + ( 0, 0, 190 );
			if ( Distance( level.price.origin, level.price.enemy.origin ) > 1700 )
				shootpos += ( 0, 0, 120 );// I'm just guessing here.  magical numbers make grenads go farther..
			MagicBullet( "m203", start, shootpos );
			wait 2.5;
		}
		wait .05;
	}
}

FOV_M203 = 0.965925;// Cos( 15 )
DIST_M203_SQRD = 650 * 650;

//good_spot_for_grenade_launcher

has_good_enemy_for_grenade_launcher( start, angles )
{
	if ( !isdefined( self.enemy ) )
		return false;
	if ( ! DistanceSquared( start, self.enemy.origin ) > DIST_M203_SQRD )
		return false;
	if ( ! within_fov( start, angles, self.enemy GetShootAtPos(), FOV_M203 ) )
		return false;

	good_spot_for_grenade_launcher = getstructarray( "good_spot_for_grenade_launcher", "targetname" );
	foreach ( spot in good_spot_for_grenade_launcher )
	{
		Assert( IsDefined( spot.radius ) );
		if ( Distance( spot.origin, self.enemy.origin ) < spot.radius )
			if ( ! burning_barrel_in_spots_radius( spot ) )
				return true;
	}

	return false;
}

burning_barrel_in_spots_radius( spot )
{
	barrels = GetEntArray( "explodable_barrel", "targetname" );
	squaredist = spot.radius * spot.radius;
	foreach ( barrel in barrels )
	{
		if ( DistanceSquared( spot.origin, barrel.origin ) > squaredist )
			continue;
		if ( barrel.damagetaken )
			return true;
	}
	return false;
}

price_position_switch()
{
	Assert( IsDefined( self.script_noteworthy ) );

	self waittill( "trigger" );

	level.price.scripted_boat_pose = self.script_noteworthy;
}

bobbing_boat_spawn()
{
	self VehPhys_Crash();
}

in_front( ent1, ent2 )
{
	return get_dot( ent1.origin, ent1.angles, ent2.origin ) > 0 ;
}

in_front_by_velocity( ent1, ent2 )
{
	return get_dot( ent1.origin, VectorToAngles( ent1 Vehicle_GetVelocity() ), ent2.origin ) > 0 ;
}

delete_when_not_in_view()
{
	cosa = Cos( 55 );
	while ( within_fov_of_players( self.origin, cosa ) )
		wait .05;
	self Delete();
}

//movewithrate( dest, destang, moverate, endrate, gravity, accelfraction, decelfraction )
movewithrate( dest, moverate, accelfraction, decelfraction )
{
	self notify( "newmove" );
	self endon( "newmove" );

	if ( !isdefined( accelfraction ) )
		accelfraction = 0;
	if ( !isdefined( decelfraction ) )
		decelfraction = 0;
	self.movefinished = false;
	// moverate = units / persecond
	if ( !isdefined( moverate ) )
		moverate = 200;

	dist = Distance( self.origin, dest );
	movetime = dist / moverate;
	movevec = VectorNormalize( dest - self.origin );

	accel = 0;
	decel = 0;

	if ( accelfraction > 0 )
		accel = movetime * accelfraction;
	if ( decelfraction > 0 )
		decel = movetime * decelfraction;

	self MoveTo( dest, movetime, accel, decel );
//	self RotateTo( destang, movetime, accel, decel );
	wait movetime;

	if ( !isdefined( self ) )
		return;
	self.velocity = movevec * ( dist / movetime );
	self.movefinished = true;
}

price_anim_single_on_boat( anim_scene, relink )
{
	self endon( "death" );
	if ( !isdefined( relink ) )
		relink  = true;

	level.price notify( "new_price_anim_single_on_boat" );
	level.price endon( "new_price_anim_single_on_boat" );

	flag_set( "price_anim_on_boat" );

	level.price radio_dialogue_stop();
	level.price LinkTo( level.players_boat, "tag_guy2" );
	level.players_boat anim_generic_queue( level.price, anim_scene, "tag_guy2" );

	if ( ! relink )
		return;// assuming a looped anim call follows

	price_link_and_think();

	flag_clear( "price_anim_on_boat" );
}

price_anim_loop_on_boat( anim_scene, notify_str, relink )
{
	if ( !isdefined( relink ) )
		relink  = true;

	level.price notify( "new_price_anim_single_on_boat" );
	level.price endon( "new_price_anim_single_on_boat" );

	level.players_boat thread anim_generic_loop( level.price, anim_scene, notify_str, "tag_guy2" );

	level.players_boat waittill( notify_str );

	if ( relink )
		price_link_and_think();

	flag_clear( "price_anim_on_boat" );
}


boatrider_link( vehicle )
{
	self LinkToBlendToTag( vehicle, "tag_guy2", false );

}


boatrider_think( vehicle )
{
	boatrider_link( vehicle );

	self AllowedStances( "crouch" );
	self.vehicle = vehicle;
	self.force_canAttackEnemyNode = true;

	self thread boatrider_targets();
	self.fullAutoRangeSq = 2000 * 2000;

	// make Price know about all enemies (helps enemy selection when moving fast)
	self.highlyAwareRadius = 2048;

	self AnimCustom( maps\_zodiac_ai::think );
}


boatrider_targets()
{
	level.price endon( "stop_boatrider_targets" );
	level.price endon( "death" );
	while ( 1 )
	{
		wait .05;
		end = level.price maps\_zodiac_drive::drive_magic_bullet_get_end( level.players_boat, level.player GetEye(), true );// piggyback this functionality. Price finds the same targets interesting.

		if ( !isdefined( end.obj ) )
		{
			level.price ClearEntityTarget();
			continue;
		}
		if ( !isai( end.obj ) )
		{
			level.price SetEntityTarget( end.obj );
			level.price.favoriteenemy = undefined;
			if ( IsDefined( end.shootable_driver ) )
				end.obj thread enable_shoot_driver();
		}
		else
		{
			level.price ClearEntityTarget();
			level.price.favoriteenemy = end.obj;
		}
	}
}


enable_shoot_driver()
{
	self notify( "enable_shoot_driver" );
	self endon( "enable_shoot_driver" );

	self.allowdeath = 1;
	self SetCanDamage( true );

	self waittill( "damage" );
	maps\_zodiac_drive::driver_death( self );
}



price_link_and_think()
{
	level.price boatrider_link( level.players_boat );
	level.price AnimCustom( maps\_zodiac_ai::think );
}

player_lerplink_fov( opts )
{
	time = opts.time;
	ent = opts.ent;
	tag = opts.tag;
	base_fov = opts.base_fov;
	dest_fov = opts.dest_fov;

	level.player FreezeControls( true );
	// this is ghetto hack..
	Assert( time > 0.0 );
	timeincs = time * 20;
	current_fov = base_fov;
	fov_dif = dest_fov - base_fov;
	fov_inc = fov_dif / timeincs;
	timeincs = Int( timeincs );

	for ( i = 0; i < timeincs; i++ )
	{
		current_fov += fov_inc;
		level.player PlayerLinkToDelta( ent, tag, 1, current_fov, current_fov, current_fov, current_fov );
		wait .05;
	}
	level.player FreezeControls( false );
}

trigger_thread_the_needle()
{
	targetent = getstruct( self.target, "targetname" );
	Assert( IsDefined( targetent ) );

	self waittill( "trigger" );

	normal = VectorNormalize( self.origin - targetent.origin );
	forward = VectorNormalize( level.players_boat Vehicle_GetVelocity() );
	dot = VectorDot( forward, normal );

	if ( dot > 0.984807 )// cos 10
		level.price radio_dialogue( "afchase_pri_threadtheneedle", 1 );
}

_objective_onentity( id, ent )
{
	Objective_OnEntity( id, ent, ( 0, 0, 80 ) );
	ent waittill( "death" );
	Objective_Position( id, ( 0, 0, 0 ) );

	/*
	ent endon( "death" );
	while ( 1 )
	{
		eye_pos = level.player GetEye();
		Objective_Position( id, (ent.origin[0],ent.origin[1],eye_pos[2]) );
		wait .05;
	}
	*/
}

crashable_whizby_boats()
{
	self.veh_pathtype = "follow";
	self VehPhys_EnableCrashing();
	while ( 1 )
	{
		self waittill( "veh_jolt" );// veh_collision wasn't working, just make it crash when it jolts around the player that should do.
		if ( Distance( self.origin, level.player.origin ) < 512 )
			break;
	}
	self VehPhys_Crash();
}

get_farthest_struct( org, array )
{
	if ( array.size < 1 )
		return;

	dist = DistanceSquared( array[ 0 ].origin, org );
	ent = array[ 0 ];
	for ( i = 0; i < array.size; i++ )
	{
		newdist = DistanceSquared( array[ i ].origin, org );
		if ( newdist < dist )
			continue;
		dist = newdist;
		ent = array[ i ];
	}
	return ent;
}

ignoreall_till_not_touch( guy )
{
	prevteam = guy.team;
	guy endon( "death" );
	guy.ignoreall = true;
	while ( guy IsTouching( self ) )// teehee
		wait .05;
	guy.ignoreall = false;
}

dump_on_command()
{
	while ( 1 )
	{
		while ( ! level.player ButtonPressed( "BUTTON_B" ) )
			wait .05;
		vehicle_dump();
		while ( level.player ButtonPressed( "BUTTON_B" ) )
			wait .05;

	}
}

set_lerp_opts( time, ent, tag, base_fov, dest_fov )
{
	opts = SpawnStruct();
	opts.time = time;
	opts.ent = ent;
	opts.tag = tag;
	opts.base_fov = base_fov;
	opts.dest_fov = dest_fov;
	return opts;
}

player_full_heath()
{
	return level.player.health / level.player.maxhealth == 1;
}

trigger_neutral_enemies()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;

		if ( !first_touch( other ) )
			continue;

		thread ignoreall_till_not_touch( other );
	}
}

draw_arrow_forward()
{
	self endon( "death" );
	while ( 1 )
	{
		draw_arrow( self.origin, self.origin + AnglesToForward( self.angles ) * 200, ( 0, 0, 1 ) );
		wait .05;
	}
}

dvar_warn()
{
	if ( ! GetDvarInt( "scr_zodiac_test" ) )
		return;
	wait 3;
	IPrintLnBold( "you will need to reset scr_zodiac_test to play the level normally again ( restart the game )" );
}

get_boat_rider( num )
{
	if ( !isdefined( level.boatrider ) )
		level.boatrider = [];
	else
	if ( IsDefined( level.boatrider[ num ] ) )
		return level.boatrider[ num ];

	level.boatrider[ num ] = spawn_targetname( num, true );
	level.boatrider[ num ] magic_bullet_shield();
	level.boatrider[ num ] disable_pain();
	level.boatrider[ num ].ignoreSuppression = true;
	level.boatrider[ num ] set_battlechatter( false );  // got enough chatter on the boat.
	return level.boatrider[ num ];
}





set_price_auto_switch_pose()
{
	level.price.scripted_boat_pose = undefined;
	level.price.use_auto_pose = true;
}

ZODIAC_DIALOGUE_RANGE = 3000 * 3000;
zodiac_enemy_setup()
{
	self.dontunloadonend = true;
//	self thread zodiac_monitor_player_trailing_time();
	foreach ( rider in self.riders )
	{
		rider thread zodiac_boat_ai( self );
	}
	flag_wait( "player_on_boat" );

	self endon( "death" );
	level.players_boat endon( "death" );


	while ( 1 )
	{
		start_origin = level.players_boat.origin;
		end_origin = self.origin;
//		normal = VectorNormalize( end_origin - start_origin );
//		forward = AnglesToRight( level.players_boat.angles );
//		dot = VectorDot( forward, normal );

		if ( DistanceSquared( self.origin, level.players_boat.origin ) > ZODIAC_DIALOGUE_RANGE )
		{
			wait .05;
			continue;
		}

		level.dialog_dir = animscripts\battlechatter::getDirectionFacingClock( level.players_boat.angles, start_origin, end_origin );
		level notify( "dialog_direction" );
		wait .05;
	}
}

exp_fade_overlay( target_alpha, fade_time )
{
	self notify( "exp_fade_overlay" );
	self endon( "exp_fade_overlay" );

	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i = 0; i < fade_steps; i++ )
	{
		current_angle += step_angle;

		self FadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - Cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = Sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}


handle_fire_missiles()
{
	self endon( "death" );
	level.players_boat endon( "death" );

	while ( 1 )
	{
		dofire = true;
		predictorg = fire_volley_of_missiles_predict( level.players_boat Vehicle_GetVelocity() );
//		draw_arrow( self.origin, predictorg, (1,0,0) );
		if ( !within_fov_2d( self.origin, self.angles, predictorg, 0.984807753 ) )
			dofire = false;
		if ( Distance( self.origin, predictorg ) < 2000 )
			dofire = false;
		if ( Distance( self.origin, predictorg ) > 5000 )
			dofire = false;
		if ( ! player_full_heath() )
			dofire = false;

		if ( dofire )
		{
			thread fire_volley_of_missiles_at_player();
			flag_waitopen( "heli_firing" );
			wait RandomFloatRange( 1.2, 2.4 );
		}
		wait .05;
	}
}

fire_volley_of_missiles_predict( velocity )
{
	return level.players_boat.origin + ( velocity * 1.50 );// guessing
}

dialog_fire_volley_of_missiles_at_player( base_origin )
{
	if ( flag( "rapids_trigger" ) )
		return;
	normal = VectorNormalize( base_origin - level.players_boat.origin );
	forward = AnglesToRight( level.players_boat.angles );
	dot = VectorDot( forward, normal );
	if ( dot < 0 )
	{
		if ( cointoss() )
			level.price thread generic_dialogue_queue( "afchase_pri_rightright", .5 );
		else
			level.price thread generic_dialogue_queue( "afchase_pri_right", .5 );

	}
	else
	{
		if ( cointoss() )
			level.price thread generic_dialogue_queue( "afchase_pri_leftleft", .5 );
		else
			level.price thread generic_dialogue_queue( "afchase_pri_left", .5 );
	}

}

fire_volley_of_missiles_at_player()
{
	if ( !isalive( self ) )
		return;

	if ( flag( "heli_firing" ) )
		return;
	flag_set( "heli_firing" );

	timer = GetTime() + 3000;

	if ( !isalive( self ) )
	{
			flag_clear( "heli_firing" );
			return;
	}

	number_of_shots = RandomIntRange( 4, 5 );
	velocity = level.players_boat Vehicle_GetVelocity();
	base_origin = fire_volley_of_missiles_predict( velocity );
	base_origin += flat_origin( randomvectorrange( -120, 120 ) );

	dialog_fire_volley_of_missiles_at_player( base_origin );


//	base_origin += ( 0, 0, 24 );
	shot_origin = base_origin;

	shotorgs = [];

	linkorg = Spawn( "script_origin", level.players_boat.origin );
	linkorg thread linkorg( level.players_boat );

//	if( IsDefined( level.players_boat ) )
//		thread draw_line_from_ent_to_ent_until_notify( linkorg , level.players_boat , 0 , 1 , 0 , linkorg , "balls" );

	for ( i = 0; i < number_of_shots; i++ )
	{
			shotorgs[ i ] = Spawn( "script_origin", shot_origin );
			shotorgs[ i ] LinkTo( linkorg );
			shot_origin += velocity * .1;
//			thread draw_line_from_ent_to_ent_until_notify( linkorg , shotorgs[i] , 1 , 0 , 1 , linkorg , "balls" );
	}

	tags = [];
	tags[ 0 ] = "tag_missile_right";
	tags[ 1 ] = "tag_missile_left";
	ents = [];


	for ( i = 0; i < number_of_shots; i++ )
	{
		if ( !isalive( self ) )
			break;
		self SetVehWeapon( "littlebird_FFAR" );
		self SetTurretTargetEnt( shotorgs[ i ] );
		missile = self FireWeapon( tags[ i % tags.size ], shotorgs[ i ], ( 0, 0, 0 ) );
		missile Missile_SetFlightmodeDirect();
		missile Missile_SetTargetEnt( shotorgs[ i ] );
		missile thread kill_rpg_shot_behind_player();
//		missile delayCall( 2.51, ::Missile_ClearTarget );
		wait RandomFloatRange( 0.2, 0.3 );
	}
	linkorg notify( "balls" );
	flag_clear( "heli_firing" );
	wait 15;
	foreach ( ent in shotorgs )
		ent Delete();
	linkorg Delete();
}

linkorg( linkent )
{
	self endon( "death" );
	linkent endon( "death" );
	offset = self.origin - linkent.origin;
	while ( 1 )
	{
		self MoveTo( linkent.origin + offset, .05, 0, 0 );
//		self.origin = linkent.origin + offset;
		wait .05;
	}
}


get_generic_anim( anime )
{
	return level.scr_anim[ "generic" ][ anime ];
}

cleanup_stuff_on_players_boat()
{
	level.players_boat notify( "cleanup" );
	if ( IsDefined( level.players_boat.gun_attached ) )
	{
		level.players_boat Detach( level.zodiac_gunModel, "tag_weapon_left" );
		level.players_boat.gun_attached = undefined;
	}
	level.players_boat Detach( level.zodiac_playerHandModel, "tag_player" );
}



TEST_FLIP = false;

flip_when_player_dies()
{
	level endon( "water_cliff_jump_splash_sequence" );

	if ( !TEST_FLIP )
		level.player waittill( "death" );

	if ( TEST_FLIP )
	{
		while ( ! level.player ButtonPressed( "BUTTON_B" ) )
			wait .05;
	}

	thread radio_dialogue_stop();

	set_water_sheating_time( "bump_small_player_dies", "bump_big_player_dies" );

	cleanup_stuff_on_players_boat();


	linkobj = Spawn( "script_model", level.player.origin );
	linkobj.angles = level.player.angles;
	linkobj Hide();
	linkobj SetModel( "zodiac_head_roller" );
	linkobj LinkTo( self, "tag_player", ( 0, 0, 60 ), ( 0, 0, 0 ) );

	offset_obj = Spawn( "script_model", level.player.origin );
	offset_obj SetModel( "zodiac_head_roller" );
	offset_obj LinkTo( linkobj, "tag_player", ( 0, 0, -60 ), ( 0, 0, 0 ) );
	offset_obj.angles = level.player.angles;
	offset_obj Hide();


	blend_time = 1;

	if ( TEST_FLIP )
	{
		level.player DismountVehicle();
		level.player.drivingVehicle = level.players_boat;

	}

	wait .1;

//	level.player PlayerLinkWeaponViewToDelta( linkobj, "tag_player", 1.0 );
	level.player PlayerLinkToDelta( offset_obj, "tag_player", 1.0, 0, 0, 0, 0 );
	level.player PlayerSetGroundReferenceEnt( offset_obj );


	boatvelocity = self Vehicle_GetVelocity();

	foreach ( rider in 	level.boatrider )
	{
		rider stop_magic_bullet_shield();
		rider Unlink();

		if ( IsDefined( rider.function_stack ) )
			rider function_stack_clear();
		rider Kill();
	}

//	if ( self Vehicle_GetSpeed() > 50 )
//		self VehPhys_Crash( true );
//	else if ( self Vehicle_GetSpeed() > 30 )
	self delayCall( .75, ::VehPhys_Crash );

//	wait 0.75;

	oldorg = self.origin;
	wait .1;
	linkobj Unlink();

	offset_vec = oldorg - self.origin;
	offset_launchpoint = ( 0, 0, 0 );
	//for spin
	offset_launchpoint = ( offset_vec[ 0 ] * 100, offset_vec[ 1 ] * 100, 0 );

	linkobj PhysicsLaunchServer( linkobj.origin + offset_launchpoint, 8 * boatvelocity + ( 0, 0, 500 ) );

	lastorg = ( 0, 0, 0 );

	while ( lastorg != linkobj.origin )
	{
		lastorg = linkobj.origin;
		wait .05;
	}
}


node_can_reach_spot_infront_of_player( basenode )
{
	//might check basenode moveability
	nodearray = GetNodesInRadius( level.player.origin, 800, 500, 1000, "path" );
	forward = AnglesToForward( level.player.angles );
	foreach ( node in nodearray )
	{
		normal = VectorNormalize( node.origin - level.player.origin );
		dot = VectorDot( forward, normal );
		if ( dot > Cos( 15 ) )
		{
			level.node_to_reach = node;// in a spawn function
			return true;
		}
	}
	return false;
}


find_good_node_for_price_to_spawn_at()
{
	nodearray = GetNodesInRadius( level.player.origin, 230, 100, 1000, "path" );
	forward = AnglesToForward( level.player.angles );
	foreach ( node in nodearray )
	{
		normal = VectorNormalize( node.origin - level.player.origin );
		dot = VectorDot( forward, normal );
		//should spawn on the periphery
		if ( dot < Cos( 45 ) && dot > 0 && node_can_reach_spot_infront_of_player( node ) )
			return node;
	}
}

lower_accuracy_behind_player()
{
	self endon( "death" );
	originalbaseaccuracy = self.baseaccuracy;
	wait .1;// just in case I'm first.
	if ( !isdefined( level.players_boat ) )
		return;// craziness keeps goiing.
	level.players_boat endon( "death" );

	if ( IsDefined( self.ridingVehicle ) && IsSubStr( self.ridingvehicle.classname, "zodiac" ) )
		return;
	if ( IsSubStr( self.classname, "shepherd" ) )
		return;

	while ( 1 )
	{
		while ( boat_in_range_in_front( self ) )
			wait .05;
		self.baseaccuracy = 0;
		self.ignoreSuppression = false;
		while ( ! boat_in_range_in_front( self ) )
			wait .05;
		self.baseaccuracy = originalbaseaccuracy;
	}
}

/*
point_end( shepherd )
{
	Shepherd notify( "point_end" );
	controller = Shepherd getanim( "ending_additive_controller" );
	Shepherd ClearAnim( controller, 0.2 );
	shepherd SetLookAtEntity( level.player );
	//( position, turn acceleration );
}
*/


setup_boat_for_drive()
{
	self Vehicle_TurnEngineOff();
	self maps\_vehicle::godon();
	self MakeUnusable();
	level.players_boat = self;

	level.players_boat StartUsingHeroOnlyLighting();

	self SetModel( "vehicle_zodiac" );

	self waittill( "vehicle_mount", player );


	level.dofDefault[ "nearStart" ] = 10;
	level.dofDefault[ "nearEnd" ] = 20;

//	thread missile_repulser();

	level.price.orgmodel = level.price.model;
	
		
//	level.price SetModel( "body_desert_tf141_zodiac" );
	hideTagList = GetWeaponHideTags( level.price.weapon );
	for ( i = 0; i < hideTagList.size; i++ )
		level.price HidePart( hideTagList[ i ], "weapon_m4" );

	self SetModel( "vehicle_zodiac_viewmodel" );

	self Vehicle_TurnEngineOn();

	flag_set( "player_on_boat" );

	thread autosave_by_name_silent( "mount_boat" );

	delayThread( 4, ::add_extra_autosave_check, "boat_check_player_speeding_along", ::autosave_boat_check_player_speeding_along, "players boat not moving fast enough!" );


	level.player ent_flag_clear( "near_death_vision_enabled" );

	thread dialog_boat_nag();

	thread dialog_boat_direction_nag();

	thread raise_attacker_accuracy_on_nearby_boats();

	thread rumble_with_throttle();

	thread flip_when_player_dies();

	thread zodiac_treadfx();

	boatrider = get_boat_rider( "boatrider0" );

	if ( ! boatrider ent_flag_exist( "price_animated_into_boat" ) )
		boatrider thread boatrider_think( self );
	else
	{
		boatrider ent_flag_wait( "price_animated_into_boat" );
		level notify( "stop_animate_price_into_boat" );
		level.price StopAnimScripted();
		level.price thread boatrider_think( level.players_boat );
	}
}

price_ai_mods( price )
{
	price.attackeraccuracy = 0;
	price.baseaccuracy = .1;
	price.ignoreSuppression = true;
	price.dontavoidplayer = true;
	price.takedamage = false;
	price.suppressionwait = 0;
	price.pathrandompercent = 0;
	price.ignoreExplosionEvents = true;
	price disable_surprise();
	price.grenadeawareness = 0;
	price.ignoreme = true;
	price.IgnoreRandomBulletDamage = true;
	price.disableBulletWhizbyReaction = true;
	flag_wait( "player_on_boat" );
	price.baseaccuracy = 25;
}

players_boat()
{

}



change_target_on_vehicle_spawner( boat_targetname, boat_destination_node )
{
	boat = GetEnt( boat_targetname, "targetname" );
	destnode = GetVehicleNode( boat_destination_node, "targetname" );
	boat.target = destnode.targetname;
}

change_target_ent_on_vehicle_spawner( heli_targetname, boat_destination_node )
{
	boat = GetEnt( heli_targetname, "targetname" );
	destnode = GetEnt( boat_destination_node, "targetname" );
	boat.target = destnode.targetname;

	//this stuff should probably be in another function
	boat.origin = destnode.origin;
	boat.angles = destnode.angles;
	boat.speed = destnode.speed;
}

enemy_chase_boat()
{
	level.breadcrumb = [];
	level.enemy_boat = self;
	self endon( "death" );
	self VehPhys_DisableCrashing();
	self.veh_pathtype = "constrained";
	self thread zodiac_monitor_player_trailing_time();

	foreach ( rider in self.riders )
	{
		if ( IsDefined( rider.magic_bullet_shield ) && rider.magic_bullet_shield )
			continue;
		rider thread magic_bullet_shield();
	}

//	self.veh_pathtype = "follow";
	while ( 1 )
	{
		wait .25;
		enemy_chase_boat_breadcrumb();
	}
}

boat_common()
{
	if( ! is_default_start() )
		maps\_friendlyfire::TurnOff();
	boatrider = get_boat_rider( "boatrider0" );
	level.price = boatrider;
	thread price_ai_mods( boatrider );
	thread test_m203();

	kill_ai_in_volume = GetEntArray( "kill_ai_in_volume", "targetname" );
	array_thread( kill_ai_in_volume, ::kill_ai_in_volume );
}

rpg_bridge_guy()
{
	trigger = Spawn( "trigger_radius", self.origin + ( 0, 0, -2000 ), 0, 4500, 2000 );
	trigger waittill( "trigger" );
	level notify( "dialog_rpg_bridge_guy" );
}

rpg_bridge_guy_target()
{
	target_ent = Spawn( "script_origin", level.players_boat.origin );
	self ent_flag_init( "first_player_sighting" );
	self disable_long_death();
	self SetEntityTarget( target_ent );
	self.favoriteenemy = target_ent;
	self.ignoreall = true;
	self.rpg_setup_time = GetTime() + RandomIntRange( 1000, 2000 );// "reaction time so they don't instantly shoot when you round a corner.

	random_vec = flat_origin( randomvectorrange( -64, 64 ) );
	firing_range = 3000;
	while ( IsAlive( self ) )
	{
		velocity_offset = level.players_boat Vehicle_GetVelocity() * 1.4 ;

//		target_ent.origin = level.players_boat.origin +( level.players_boat Vehicle_GetVelocity() * 1.89 );

		forward_origin = level.players_boat.origin + velocity_offset;
		forward_origin = set_z( forward_origin, level.players_boat.origin[ 2 ] + 24 );

//		Line( forward_origin, level.players_boat.origin, (0,1,0) );


		//when the player is headed towards something use the spline direction to influence the shot. otherwise fire away in the direct forward path.
		if ( ! BulletTracePassed( level.player GetEye() + ( 0, 0, 16 ), forward_origin, false, self ) )
		{
			offset = Distance( ( 0, 0, 0 ), velocity_offset );
			target_ent.origin = get_position_from_spline_unlimited( level.player.targ, level.player.progress + offset - level.POS_LOOKAHEAD_DIST, level.player.offset );
			target_ent.origin = set_z( target_ent.origin, level.players_boat.origin[ 2 ] + 24 );
//			Line( target_ent.origin, level.players_boat.origin, (0,0,1) );
			target_ent.origin = ( target_ent.origin + forward_origin ) / 2;
		}
		else
		{
			target_ent.origin = forward_origin;
		}

//		Line( target_ent.origin, level.players_boat.origin, (1,0,0) );
		self OrientMode( "face point", target_ent.origin ) ;

		bullettraced_to_player = false;
		if ( BulletTracePassed( self GetTagOrigin( "tag_flash" ), level.player GetEye(), false, self ) )
		{
			bullettraced_to_player = true;
			if ( ! ent_flag( "first_player_sighting" ) )
				ent_flag_set( "first_player_sighting" );
		}

		if ( ! ent_flag( "first_player_sighting" ) )
			self.rpg_setup_time = GetTime() + RandomIntRange( 1000, 2000 );// "reaction time so they don't instantly shoot when you round a corner.

		if ( GetTime() > self.rpg_setup_time )
			if ( bullettraced_to_player )
				if ( BulletTracePassed( self GetTagOrigin( "tag_flash" ), target_ent.origin + random_vec, false, self ) )
					if ( Distance( self.origin, level.player.origin ) < firing_range )
						if ( GetTime() > level.next_rpg_firetime )
							break;

		wait .05;
	}

	ammo = "rpg_straight_af_chase";
//	if( cointoss() )
//		ammo = "rpg";

	if ( IsDefined( self ) && IsDefined( self GetTagOrigin( "tag_flash" ) ) )// Tried isalive . debugger is broken today = ( .
	{
		rpg_shot = MagicBullet( ammo, self GetTagOrigin( "tag_flash" ), target_ent.origin + random_vec );
		rpg_shot thread kill_rpg_shot_behind_player();
	}
	level.next_rpg_firetime = GetTime() + RandomIntRange( 300, 500 );// stagger time between multiple guys
	target_ent Delete();
}

kill_rpg_shot_behind_player()
{
	level.players_boat endon( "death" );
	self endon( "death" );
	while ( in_front( level.player, self ) )
		wait .05;
	thread play_sound_in_space( "rocket_explode_water" );
	self Delete();
}



set_price_autoswitch_after_caves()
{
	flag_wait( "exit_caves" );
	set_price_auto_switch_pose();
}


teleport_price_on_mount( node )
{
	level endon( "end_teleport_price_on_mount" );
	level.players_boat waittill( "vehicle_mount" );
	level.price teleport_ai_here( node );
}

teleport_ai_here( eNode )
{
	AssertEx( IsAI( self ), "Function teleport_ai can only be called on an AI entity" );
	AssertEx( IsDefined( eNode ), "Need to pass a node entity to function teleport_ai" );
	self ForceTeleport( eNode.origin, eNode.angles );
	self SetGoalPos( self.origin );
}



dialog_boat_battlechatter()
{

	dialog_direction = [];
	dialog_direction = array_add( dialog_direction, "TF_pri_callout_targetclock_" );

	dialog_helicopter_six = [];
	dialog_helicopter_six = array_add( dialog_helicopter_six, "afchase_pri_evasive" );
	dialog_helicopter_six = array_add( dialog_helicopter_six, "afchase_pri_shakeemoff" );
	dialog_helicopter_six = array_add( dialog_helicopter_six, "afchase_pri_miniguns" );

	dialog_helicopter_ahead = [];
	dialog_helicopter_ahead = array_add( dialog_helicopter_ahead, "afchase_pri_dodgeheli" );
	dialog_helicopter_ahead = array_add( dialog_helicopter_ahead, "afchase_pri_gunsspinup" );
	dialog_helicopter_ahead = array_add( dialog_helicopter_ahead, "afchase_pri_steerclear" );

	dialog_rpg_bridge_guy = [];
	dialog_rpg_bridge_guy = array_add( dialog_rpg_bridge_guy, "afchase_pri_rpgsonbridge" );

	dialog = [];
	dialog[ "dialog_direction" ] = 	dialog_direction;
	dialog[ "dialog_helicopter_six" ] = 	dialog_helicopter_six;
	dialog[ "dialog_helicopter_ahead" ] = 	dialog_helicopter_ahead;
	dialog[ "dialog_rpg_bridge_guy" ] = 	dialog_rpg_bridge_guy;

	timeout[ "dialog_direction" ] = .5;
	timeout[ "dialog_helicopter_six" ] = 1;
	timeout[ "dialog_helicopter_ahead" ] = 1;
	timeout[ "dialog_rpg_bridge_guy" ] = .7;

	nagtime[ "dialog_direction" ] = 5500;
	nagtime[ "dialog_helicopter_six" ] = 9300;
	nagtime[ "dialog_helicopter_ahead" ] = 2000;
	nagtime[ "dialog_rpg_bridge_guy" ] = 10000;

	last_nagtime[ "dialog_direction" ] = GetTime();
	last_nagtime[ "dialog_helicopter_six" ] = GetTime();
	last_nagtime[ "dialog_helicopter_ahead" ] = GetTime();
	last_nagtime[ "dialog_rpg_bridge_guy" ] = GetTime();

	unused_dialog = dialog;

	picked = undefined;

	wait 1;// let enemy boat get defined..

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/
	
	level endon( "price_stops_talking_about_helicopters" );

	level.player endon( "death" );
	self endon( "death" );
	flag_wait( "exit_caves" );
	while ( 1 )
	{
		type = level waittill_any_return( "dialog_direction", "dialog_helicopter_six", "dialog_helicopter_ahead", "dialog_rpg_bridge_guy" );
		if ( flag( "price_anim_on_boat" ) )
			continue;
		if ( flag( "rapids_head_bobbing" ) )
			continue;
		picked = random( unused_dialog[ type ] );

		if ( GetTime() - last_nagtime[ type ] < nagtime[ type ] )
			continue;

		last_nagtime[ type ] = GetTime();

		if ( type == "dialog_direction" )
			level.price thread generic_dialogue_queue( picked + level.dialog_dir, timeout[ type ] );
		else
			level.price thread generic_dialogue_queue( picked, timeout[ type ] );


		unused_dialog[ type ] = array_remove( unused_dialog[ type ], picked );
		if ( !unused_dialog[ type ].size )
			unused_dialog[ type ] = dialog[ type ];
		wait .05;
		if ( flag( "player_in_sight_of_boarding" ) )
			return;
	}
}

dialog_boat_nag()
{
	nagtime = 8000;
	next_nag = GetTime() + nagtime;

	dialog = [];
	dialog = array_add( dialog, "afchase_pri_gettingaway" );
	dialog = array_add( dialog, "afchase_pri_gogogo" );
	dialog = array_add( dialog, "afchase_pri_cantlet" );
	dialog = array_add( dialog, "afchase_pri_losinghim" );
	dialog = array_add( dialog, "afchase_pri_drivingtheboat" );
	dialog = array_add( dialog, "afchase_pri_fullpower" );

	unused_dialog = dialog;

	picked = undefined;

	self endon( "death" );
	level.price endon( "death" );
	

	while ( 1 )
	{
		if ( bread_crumb_get_player_trailing_fraction() > .5 && next_nag < GetTime() && ! level.price ent_flag( "transitioning_positions" ) )
		{
			picked = random( unused_dialog );
//			level.price thread radio_dialogue( picked );
			side = level.price.a.boat_pose;
			Assert( IsDefined( side ) && ( side == "left" || side == "right" ) );

			doradio = false;

			if ( level.price.a.lastShootTime > GetTime() - 2000 && ! player_full_heath() )
				doradio = true;
			if ( flag( "rapids_head_bobbing" ) )
			{
				wait .05;
				continue;
			}

			if ( doradio )
				level.price thread generic_dialogue_queue( picked, 1 );
			else
				level.price thread price_anim_single_on_boat( side + "_" + picked );

			unused_dialog = array_remove( unused_dialog, picked );
			next_nag = GetTime() + nagtime;
			if ( !unused_dialog.size )
				unused_dialog = dialog;
		}
		wait .05;
		if ( flag( "stop_boat_dialogue" ) )
			return;
	}
}


dialog_cave()
{
	level.player endon( "death" );
	self waittill( "trigger" );
	level.price generic_dialogue_queue( "afchase_pri_thrucave" );
}



dialog_start()
{
//	thread add_dialogue_line( "Price", "They're just around the corner, come on." );
	level.price thread generic_dialogue_queue( "afchase_pri_aroundcorner" );
	wait 4;
//	thread add_dialogue_line( "Price", "We need to get on that boat. " );
	level.price thread generic_dialogue_queue( "afchase_pri_getonboat" );

	wait 2;
}

dialog_boat_direction_nag()
{
	nagtime = 4000;
	next_nag = GetTime() + nagtime;
	wrong_way_time = 2;
	wrong_way_time_count = 0;

	dialog = [];
	dialog = array_add( dialog, "afchase_pri_wrongway" );
	dialog = array_add( dialog, "afchase_pri_turntoobjective" );
	dialog = array_add( dialog, "afchase_pri_wheregoing" );

	unused_dialog = dialog;

	picked = undefined;

	wait 1;// let enemy boat get defined..

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/

	self endon( "death" );
	level.enemy_boat endon( "death" );
	level.player endon( "death" );
	
	while ( 1 )
	{
		if ( !in_front_by_velocity( level.players_boat, level.enemy_boat ) && next_nag < GetTime() )
			wrong_way_time_count += .05;
		else
			wrong_way_time_count = 0;

		if ( flag( "price_anim_on_boat" ) )
		{
			wait .05;
			continue;
		}

		if ( wrong_way_time_count > wrong_way_time )
		{
			picked = random( unused_dialog );
			level.price thread generic_dialogue_queue( picked );
			unused_dialog = array_remove( unused_dialog, picked );
			next_nag = GetTime() + nagtime;
			if ( !unused_dialog.size )
				unused_dialog = dialog;
		}

		wait .05;
		if ( flag( "stop_boat_dialogue" ) )
			return;
	}
}



animate_price_into_boat()
{
	level endon( "stop_animate_price_into_boat" );
	waittillframeend;// let players boat get spawned and defined
	pathnode = GetNode( self.target, "targetname" );
	node = Spawn( "script_origin", pathnode.origin );
	node.angles = pathnode.angles + ( 0, -90, 0 );
	level.price ent_flag_init( "price_animated_into_boat" );

	//make the scene stick to boat should player start to drive
	node delayCall( 2, ::linkto, level.players_boat );// give it time to settle before linking

	thread teleport_price_on_mount( node );
	node anim_generic_reach( level.price, "price_into_boat" );
	level notify( "end_teleport_price_on_mount" );
	level.price LinkTo( node );

	level.price delayThread( 1.5, ::ent_flag_set, "price_animated_into_boat" );// I timed this as a good cutoff point for when the player jumps in first.
	level.players_boat delayCall( 1, ::JoltBody, level.price.origin, .15 );
	level.players_boat delayThread( 1, ::play_sound_in_space, "water_boat_splash_small", level.players_boat.origin );

	node anim_generic( level.price, "price_into_boat" );
	level.price thread boatrider_think( level.players_boat );
}

search_the_scrash_site()
{
	GetEnt( "damaged_pavelow", "targetname" ) Hide();

	flag_wait( "end_heli_crashed" );
	exploder( "heli_fire" );
	damaged_heli = GetEnt( "damaged_pavelow", "targetname" );
	wait .5;
	damaged_heli Show();
	trigger = Spawn( "trigger_radius", damaged_heli.origin + ( 0, 0, -100 ), 0, 670, 600 );
	trigger waittill( "trigger" );
}



trigger_out_of_caves()
{
	self waittill( "trigger" );
	level.price thread generic_dialogue_queue( "afchase_pri_openareas" );
}

trigger_boat_mount()
{
	self waittill( "trigger" );

	if ( flag( "player_on_boat" ) )
		return;

	origin = level.players_boat GetTagOrigin( "tag_player" );
	angles = level.players_boat GetTagAngles( "tag_player" );
	level.player SwitchToWeapon( "uzi" );
	level.player FreezeControls( true );
	level.player PlayerLinkToBlend( level.players_boat, "tag_player", .35, .2, .1 );
	wait .35;
	level.player FreezeControls( false );
//	level.price ent_flag_wait( "price_animated_into_boat" );
	level.players_boat MakeUsable();
	level.players_boat UseBy( level.player );
	level.player.drivingVehicle = level.players_boat;
}




trigger_price_tells_player_go_right()
{
	self.origin += ( 0, 0, -50 );
	self waittill( "trigger" );
	level.price thread generic_dialogue_queue( "afchase_pri_right" );

}

hint_test()
{
	return player_steadies_boat();
}


trigger_end_caves()
{
	self waittill( "trigger" );
	flag_set( "exit_caves" );
	wait 1.1;

	thread maps\_utility::set_ambient( "af_chase_exit" );
	wait 3;
	SetSavedDvar( "sm_sunSampleSizeNear", "2" );
	if ( IsDefined( level.price ) )
			level.price DontCastShadows();

}

rope_splashers()
{
	self endon( "death" );
	wait .5;
	org_z = self.origin[ 2 ];

	while ( self.origin[ 2 ] == org_z )
		wait .1;

	self Kill();

//this might be cool if I could do client ragdoll..

//self waittill ( "death" );
//self endon ("death");
//
//ent = SpawnStruct();
//ent endon( "complete" );
//ent delayThread( 5, ::send_notify, "complete" );

//  while( self.origin[2] > 48 )
//  	wait .05;
//
//  PlayFX( getfx("body_falls_from_ropes_splash") , set_z( self.origin,48 ) );
// StartRagdoll();
}


trigger_set_max_zodiacs( value )
{
	self waittill( "trigger" );
	level.enemy_snowmobiles_max = value;
}

trigger_rapids()
{
	level.player endon( "death" );
	self waittill( "trigger" );
	flag_set( "rapids_trigger" );
	thread maps\_utility::set_ambient( "af_chase_rapids" );
	level.player.nooffset = true;// makes enemy boats spawn exactly behind the player.

	level.enemy_snowmobiles_max = 1;

	flag_set( "rapids_head_bobbing" );
//	price_anim_single_on_boat( "rapids_in", false );
	level.price generic_dialogue_queue( "afchase_pri_rapidsahead" );
	thread price_anim_loop_on_boat( "rapids_loop", "end_the_rapids_loop" );

	end_price_crazy = GetEnt( "end_price_crazy", "targetname" );
	end_price_crazy waittill( "trigger" );
	flag_clear( "rapids_head_bobbing" );

	level.players_boat notify( "end_the_rapids_loop" );
	level.enemy_snowmobiles_max = 2;

	wait 1;
	set_price_auto_switch_pose();

	// they get really bogged in so reduce them after a bit.
	wait 9;
	level.enemy_snowmobiles_max = 1;
}

trigger_on_river()
{
	self waittill( "trigger" );
	thread maps\_utility::set_ambient( "af_chase_river" );
	flag_set( "on_river" );
}


trigger_open_area()
{
	flag_wait( "exit_caves" );
	level endon ( "stop_deadquote_for_gettingout_of_bounds" );
	level.player endon( "death" );
	nagtime = GetTime() + 30000;
	while ( 1 )
	{
		SetDvar( "ui_deadquote", "" );
		level thread maps\_quotes::setDeadQuote();

		flag_clear( "player_in_open" );
		self waittill( "trigger" );
		while ( level.player IsTouching( self ) )
		{
			if ( GetTime() > nagtime )
			{
				nagtime = GetTime() + RandomFloatRange( 20000, 22000 );

				//Price: Stay clear of open areas as much as possible!
				level.price thread generic_dialogue_queue( "afchase_pri_openareas" );
			}
			flag_set( "player_in_open" );// done every frame to support overlap.
			level notify( "new_quote_string" );
			// Stay clear of open areas as much as possible!
			SetDvar( "ui_deadquote", &"AF_CHASE_MISSION_FAILED_IN_THE_OPEN" );
			wait .05;
		}
	}
}

/*
setDeadQuote()
{
	level endon( "mine death" );

	// kill any deadquotes already running
	level notify( "new_quote_string" );
	level endon( "new_quote_string" );

*/

sentry_technical_think()
{
	wait .5;
	turret = self.mgturret[ 0 ];
	turret SetMode( "manual_ai" );
	turret SetTargetEntity( level.player );

	foreach ( rider in self.riders )
	{
		rider.favoriteenemy = level.player;
		rider.maxsightdistsqrd = 20000 * 20000;
	}
}

sunsample_after_caves()
{
	flag_wait( "exit_caves" );
	SetSavedDvar( "sm_sunSampleSizeNear", "2" );
}


boatsquish()
{
	if ( IsDefined( level.noTankSquish ) )
	{
		AssertEx( level.noTankSquish, "level.noTankSquish must be true or undefined" );
		return;
	}

	if ( IsDefined( level.levelHasVehicles ) && !level.levelHasVehicles )
		return;
	self add_damage_function( ::boatsquish_damage_check );
	self remove_damage_function( maps\_spawner::tanksquish_damage_check );
}

boatsquish_damage_check( amt, who, force, b, c, d, e )
{
	if ( !isdefined( self ) )
	{
		return;
	}
	if ( IsAlive( self ) )
		return;

	if ( !isalive( who ) )
		return;
	if ( !isdefined( who.vehicletype ) )
		return;

	if ( who maps\_vehicle::ishelicopter() )
		return;

	if ( abs( self.origin[ 2 ] - level.players_boat.origin[ 2 ] ) > 64 )
	{
		self Delete();// these guys are getting  hit by the players tall boat collision.. just delete them so they don't fly over.
	}

	self thread boat_squish_ragdoll_or_bust();

	if ( !isdefined( self ) )
	{
		return;
	}
	self remove_damage_function( ::boatsquish_damage_check );

//		self PlaySound( "human_crunch" );
}

boat_squish_ragdoll_or_bust()
{
	make_room_for_priority_squished_guy_corpse();
	timer = GetTime() + 500;
	while ( GetTime() < timer )
	{
		if ( !isdefined( self ) )
			return;
		if ( self IsRagdoll() )
			return;
		self StartRagdoll();
		wait .05;
	}
	self Delete();
}

make_room_for_priority_squished_guy_corpse()
{
	corpses = GetCorpseArray();
	foreach ( corpse in corpses )
		if ( Distance( corpse.origin, level.player GetEye() ) > 600 )
			corpse Delete();

}


explode_barrels_in_radius_think()
{
	assert( isdefined( self.radius ) );

	shootable_stuff = GetEntArray( "explodable_barrel", "targetname" );
	flat_org = flat_origin ( self.origin );
	
	my_barrels = [];
	foreach ( thing in shootable_stuff )
	{
		if( distance( flat_org, flat_origin( thing.origin) ) < self.radius )
			my_barrels[ my_barrels.size ] = thing;
	}

	self waittill ( "trigger" );

	for ( i = 0; i < 10; i++ )
	{
		foreach( barrel in my_barrels )
			barrel notify( "damage", 50, level.player, (0,0,0), barrel.origin, "MOD_EXPLOSIVE" );
		wait .05;
		
	}
}

player_steadies_boat()
{
	return level.player ButtonPressed( "BUTTON_B" ) || 1;
}

remove_global_spawn_funcs()
{
	flag_wait( "water_cliff_jump_splash_sequence" );

	remove_global_spawn_function( "axis", ::lower_accuracy_behind_player );
	remove_global_spawn_function( "axis", ::set_fixed_node_after_seeing_player_spawn_func );
}