#include maps\_utility;
#include maps\_vehicle;
#include maps\_vehicle_spline;
#include maps\_anim;
#include maps\_hud_util;
#include maps\_riotshield;
#include common_scripts\utility;

spawn_player_heli()
{
	level.player_repulsor = Missile_CreateRepulsorEnt( level.player, 10000, 800 );

	// looker guy rides next to you, he looks around
	looker_guy = GetEnt( "looker_guy", "script_noteworthy" );
	looker_guy add_spawn_function( ::looker_guy );

	level.heli_time_tracker = [];

//	level.player TakeAllWeapons();
	level.player.IgnoreRandomBulletDamage = true;
	player_cant_be_shot();
	level.player_heli = spawn_vehicle_from_targetname_and_drive( "heli_intro_player" );
	level.player_heli thread player_heli_stabilizes();
	level.player_heli SetMaxPitchRoll( 10, 10 );
	level.player_heli thread track_heli_times();

   	level.player AllowProne( false );
   	level.player AllowCrouch( false );
   	level.player AllowSprint( false );
   	level.player AllowJump( false );

	//level.player_heli thread show_color();
	level.player_heli thread handle_landing();

	thread casual_heli_guy();

//	level.player_heli.custom_landing = "hover_then_land";

	level.player_heli thread godon();
	level.player_heli thread modify_player_heli_yaw_over_time();


	//level.player_heli thread maps\_debug::drawTagForever( "tag_guy1", (1,1,0) );
	//level.player_heli thread maps\_debug::drawTagForever( "tag_guy2", (1,1,0) );
	//level.player_heli thread maps\_debug::drawTagForever( "tag_guy3", (1,1,0) );
	//level.player_heli thread maps\_debug::drawTagForever( "tag_guy4", (1,1,0) );
	player_view_controller = get_player_view_controller( level.player_heli, "tag_guy2", ( 0, 0, -8 ) );

	tag_origin = spawn_tag_origin();
//	tag_origin LinkTo( player_view_controller, "tag_aim", (0,0,0),(0,0,0) );
	tag_origin LinkTo( level.player_heli, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.ground_ref = tag_origin;

	level.player PlayerSetGroundReferenceEnt( tag_origin );

	gulag_center = GetEnt( "gulag_center", "targetname" );
	level.view_org = Spawn( "script_origin", ( 0, 0, 0 ) );
	level.view_org.origin = gulag_center.origin;

	level.gulag_center_org = gulag_center.origin;
	level.player_view_controller = player_view_controller;

	player_view_controller SetTargetEntity( level.view_org );
	viewPercentFrac = 1;
	arcRight = 0;
	arcLeft = 95;
	arcTop = 7;
	arcBottom = 30;

	start_org = level.player_heli GetTagOrigin( "tag_guy2" );
	level.player SetOrigin( start_org );

	wait( 0.1 );
	level.player SetPlayerAngles( ( -15, -115, 0 ) );


	level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, -35, 40, -35, 40, true );

	wait( 3 );
//	level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );
	level.player LerpViewAngleClamp( 1, 0.25, 0.25, arcRight, arcLeft, arcTop, arcBottom );




	flag_wait( "approach_dialogue" );
	arcRight = 45;
	arcLeft = 45;
	arcTop = 15;
	arcBottom = 45;
//	level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );
	level.player LerpViewAngleClamp( 1, 0.25, 0.25, arcRight, arcLeft, arcTop, arcBottom );

	flag_wait( "player_goes_in_for_landing" );

	//level.player PlayerSetGroundReferenceEnt( undefined );
	player_view_controller ClearTargetEntity();
	player_view_controller SetTargetEntity( gulag_center );
//	time = 2;
//	level.player PlayerLinkToBlend( player_view_controller, "TAG_aim", time, time * 0.5, time * 0.5 );
//	wait( time );

	//level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );

	flag_wait( "player_goes_in_for_landing" );

	arcRight = 45;
	arcLeft = 45;
	arcTop = 15;
	arcBottom = 45;
	/*
	time = 1;
	level.player PlayerLinkToBlend( player_view_controller, "TAG_aim", time, time * 0.5, time * 0.5 );
	wait( time );
	//level.player PlayerSetGroundReferenceEnt( undefined );
	*/
	level.player LerpViewAngleClamp( 1, 0.25, 0.25, 25, 25, 15, 25 );
	wait( 1 );
	level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );

	/*
	if ( !flag( "slamraam_gets_players_attention" ) )
	{
		flag_wait( "slamraam_gets_players_attention" );
		wait( 2 );
		time = 2;
		level.player PlayerLinkToBlend( player_view_controller, "TAG_aim", time, time * 0.5, time * 0.5 );
		wait( time );
		arcRight = 45;
		arcLeft = 45;
		arcTop = 10;
		arcBottom = 10;
		level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );
	}

	if ( !flag( "heli_roller_coaster_prep" ) )
	{
		flag_wait( "heli_roller_coaster_prep" );
		time = 1;
		level.player PlayerLinkToBlend( player_view_controller, "TAG_aim", time, time * 0.5, time * 0.5 );
		wait( time );
		arcRight = 45;
		arcLeft = 45;
		arcTop = 10;
		arcBottom = 10;
		level.player PlayerLinkToDelta( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );
	}
	*/
}

player_blends_to_tag_origin( tag_origin )
{
	arcRight = 45;
	arcLeft = 45;
	arcTop = 15;
	arcBottom = 45;

	time = 2;
	//level.player PlayerLinkToBlend( tag_origin, "tag_origin", time, time * 0.5, time * 0.5 );
	//wait( time );
	level.player PlayerLinkToDelta( tag_origin, "tag_origin", 1, arcRight, arcLeft, arcTop, arcBottom, true );
}

/*
recenter_player_view_target( ent )
{
	level notify( "stop_moving_gulag_center" );
	gulag_center = GetEnt( "gulag_center", "targetname" );
	time = 2;
	waittillframeend;
	wait( 0.05 ); // for the linked entitied to get its origin
	gulag_center MoveTo( ent.origin, time, 0, time );
	wait( time );

	gulag_center LinkTo( ent );
}
*/

draw_ent_line( ent )
{
	for ( ;; )
	{
		//line( ent.origin, level.player_heli.origin, (1,0,1) );
		wait( 0.05 );
	}
}


player_view_blends_to_heli_tag()
{

	ent = spawn_tag_origin();
	ent LinkTo( level.player_heli, "tag_guy2", ( 0, 0, -16 ), ( 0, 90, 0 ) );
//	ent thread maps\_debug::drawTagForever( "tag_origin", (1,0.5,0) );

	level.player LerpViewAngleClamp( 1, 0.25, 0.25, 25, 25, 15, 25 );
	wait( 1 );

	viewPercentFrac = 1;
	arcRight = 45;
	arcLeft = 45;
	arcTop = 15;
	arcBottom = 45;
	level.player PlayerLinkToDelta( ent, "tag_origin", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );
}

/*
explosion_knocks_player_heli_out_of_control()
{
	level.player_heli notify( "newpath" );

	ent = spawn_tag_origin();
	ent LinkTo( level.player_heli, "tag_origin", (333,1000,-100), (0,0,0) );
	//thread draw_ent_line( ent );
//	level.player PlayerSetGroundReferenceEnt( ent );
	
//	center = GetEnt( "gulag_center", "targetname" );
//	center.origin = center.original_org;
	thread recenter_player_view_target( ent );

	tag_origin = spawn_tag_origin();
	tag_origin LinkTo( level.player_heli, "tag_guy2", (0,0,-16), (0,90,0) );
	//tag_origin thread maps\_debug::drawTagForever( "tag_origin", (1,0.5,0) );

	//thread player_blends_to_tag_origin( tag_origin );	
	thread player_view_blends_to_heli_tag();
	
	//path_boom = GetVehicleNode( "path_boom", "targetname" );
	//yaw = path_boom.angles[ 1 ];
	
	path = GetVehicleNode( "path_test", "targetname" );
	level.player_heli Vehicle_SetSpeedImmediate( 1, 1, 1 );
	level.player_heli ClearLookAtEnt();
	level.player_heli ClearGoalYaw();
	level.player_heli ClearTargetYaw();
	level.player_heli SetGoalYaw( 199 );
//	level.player_heli AttachPath( path );
//	level.player_heli StartPath( path );
//	level.player_heli ResumeSpeed( 75 );
//	level.player_heli ClearTargetYaw();

	flag_set( "stabilize" );
	flag_set( "new_friendly_helis_spawn" );
	delayThread( 0.25, ::flag_set, "pre_boats_attack" );

	flag_wait( "player_heli_backs_up" );
	path = GetVehicleNode( "path_boom", "targetname" );
	level.player_heli AttachPath( path );
	
	level.player_heli StartPath();
	level.player_heli ResumeSpeed( 75 );
	
	flag_wait( "player_heli_slowdown" );
	level.player_heli Vehicle_SetSpeed( 2, 5, 5 );
	level.player_heli waittill( "reached_end_node" );
	player_landing_path = getstruct( "player_landing_path", "targetname" );
	level.player_heli Vehicle_SetSpeed( 15, 3, 3 );
	flag_set( "player_goes_in_for_landing" );
	
	// move the focal point for player and heli back to the center
	gulag_center = GetEnt( "gulag_center", "targetname" );
	gulag_center Unlink();
	gulag_center MoveTo( level.gulag_center_org, 2.5, 1, 1 );
	
	level.player_heli thread player_heli_rotates_properly_around_gulag();

	tag_origin Delete();
	level.player_heli thread vehicle_paths( player_landing_path );
	wait( 4 );
	flag_set( "stop_rotating_around_gulag" );
}
*/

spawn_friendly_helis( heli_spawners )
{
	foreach ( heli_spawner in heli_spawners )
	{
		ai_spawners = GetEntArray( heli_spawner.target, "targetname" );
		foreach ( ai_spawner in ai_spawners )
		{
			ai_spawner.count = 1;
		}
	}

	friendly_helis = [];
	foreach ( spawner in heli_spawners )
	{
		heli = spawner spawn_vehicle();
		heli thread gopath();
		//heli thread intro_heli_treadfx();
		friendly_helis[ friendly_helis.size ] = heli;
	}

	array_thread( friendly_helis, ::godon );
	array_thread( friendly_helis, ::pitch_modifier );

	foreach ( heli in friendly_helis )
	{
		heli thread handle_landing();
		heli thread heli_manual_fire();

		//heli SetAirResistance( 1500 );
		//heli thread show_color();
		//heli thread track_heli_times();
		if ( !issubstr( heli.classname, "armed" ) )
			continue;

		level.heli_armed = heli;
	}
	level.friendly_helis = friendly_helis;
}

controller_view_line()
{
	for ( ;; )
	{
	//	Line( self.origin, level.player.origin, ( 1, 0.7, 0 ) );
		wait( 0.05 );
	}
}

remove_ignore_random_bd()
{
	self endon( "death" );
	wait( 10 );
	self.IgnoreRandomBulletDamage = false;
}

doomed_just_doomed_think()
{
	// these guys are just.. doomed. To free up AI slots some friendlies must die.
	self endon( "death" );
	self waittill( "unload" );
	waittillframeend;// overwrite whatever happens in the main ai gulag logic
	wait( 60 );
	self.IgnoreRandomBulletDamage = false;
	self.attackeraccuracy = 1.0;
	self.health = 50;
	self.threatbias = 200;
	for ( ;; )
	{
		wait( 3 );
		self.attackeraccuracy += 0.2;
		self.threatbias += 40;
	}

}


/*
dying_buddy_makes_me_stronger()
{
	self endon( "stop_adding_mbs" );
	self waittill( "death" );
	allies = GetAIArray( "allies" );
	if ( allies.size >= 5 )
		return;

	// make 3 guys MBS	
	for ( i = 0; i < 3; i++ )
	{
		allies[ i ] thread magic_bullet_shield();
	}

	array_thread( allies, ::send_notify, "stop_adding_mbs" );
}
*/

friendlies_gulag_exterior_logic( ent )
{
	self endon( "death" );
	self endon( "new_color_being_set" );// got turned into a color guy again
	self.qSetGoalPos = false;
	//self.fixednode = 0;
	if ( !isdefined( self.magic_bullet_shield ) )
		self.health = 280;

	self.baseaccuracy = 2;
	//self enable_heat_behavior();
	self.attackeraccuracy = 0.0;
	self.IgnoreRandomBulletDamage = true;

	self waittill( "unload" );

	self.attackeraccuracy = 0.1;

//	thread remove_ignore_random_bd();
//
//	if ( ent.leader == self )
//		return;
//
//	if ( self == level.soap )
//		return;
//		
//	// let's play follow the leader
//	self disable_ai_color();
//	self.goalradius = 150;
//	
//	for ( ;; )
//	{
//		wait( 1 );
//		if ( IsAlive( ent.leader ) )
//		{
//			self SetGoalPos( ent.leader.origin );
//			continue;
//		}
//
//		// I must take on the mantle
//		ent.leader = self;
//		self enable_ai_color();
//		return;
//	}
//	
}



handle_landing()
{
	self ent_flag_wait( "prep_unload" );
	flag_set( "a_heli_landed" );
	waittillframeend;// wait until the vehicle script can turn the riders into real ai

	ent = SpawnStruct();
	ent.leader = undefined;

	foreach ( rider in self.riders )
	{
		if ( IsAI( rider ) )
		{
			if ( !isdefined( ent.leader ) && rider != level.soap )
				ent.leader = rider;

			rider thread friendlies_gulag_exterior_logic( ent );
		}
	}
}

friendlies_traverse_gulag_exterior()
{
	//flag_wait( "player_lands" );
	//activate_trigger_with_targetname( "friendlies_arrive_at_courtyard" );
	//flag_wait_or_timeout( "friendlies_leave_courtyard", 15 );
	level endon( "player_progresses_passed_ext_area" );

	activate_trigger_with_targetname( "friendlies_leave_courtyard" );


	for ( i = 1; i <= 5; i++ )
	{
		// "ext_progress_1", "ext_progress_2", "ext_progress_3", "ext_progress_4"
		msg = "ext_progress_" + i;
		trigger = GetEnt( msg, "targetname" );
		if ( flag_exist( msg ) )
			flag_wait( msg );

		volume = trigger get_color_volume_from_trigger();
		//if ( IsDefined( volume ) )
			volume waittill_volume_dead_or_dying();

		if ( msg == "ext_progress_5" )
		{
			wait( 0.7 );
			// The entrance is up ahead, keep moving!	
			level.soap thread dialogue_queue( "gulag_cmt_upahead" );
			wait( 0.6 );
		}
		trigger activate_trigger();
	}
}

friendlies_traverse_showers()
{
	if ( flag( "leaving_bathroom_vol2" ) )
		return;
	level endon( "leaving_bathroom_vol2" );

	for ( i = 1; i <= 5; i++ )
	{
		// "ext_progress_1", "ext_progress_2", "ext_progress_3", "ext_progress_4"
		msg = "bathroom_int" + i;
		trigger = GetEnt( msg, "targetname" );
		flag_wait( msg );
		volume = trigger get_color_volume_from_trigger();
		if ( IsDefined( volume ) )
			volume waittill_volume_dead_or_dying();
		trigger activate_trigger();
	}
}


track_heli_times()
{
	level.heli_time_tracker[ self.target ] = [];

	start_time = GetTime();
	for ( ;; )
	{
		last_time = GetTime();
		self waittill( "reached_current_node", nextpoint, theFlag );
		array = [];
		array[ "name" ] = nextpoint.targetname;
		array[ "time" ] = ( GetTime() - last_time ) * 0.001;
		array[ "total_time" ] = ( GetTime() - start_time ) * 0.001;
		array[ "flag" ] = theFlag;

		level.heli_time_tracker[ self.target ][ level.heli_time_tracker[ self.target ].size ] = array;
	}
}

debug_heli_times()
{
	PrintLn( "debugging flight times" );
	foreach ( name, time_array in level.heli_time_tracker )
	{
		PrintLn( "Heli " + name + ":" );
		foreach ( index, array in time_array )
		{
			if ( IsDefined( array[ "flag" ] ) )
				PrintLn( array[ "name" ] + " " + array[ "total_time" ] + " " + array[ "flag" ] );
			else
				PrintLn( array[ "name" ] + " " + array[ "total_time" ] );
		}
		PrintLn( " " );
	}
}

rotate_test()
{
	wait( 2 ) ;
	level.player PlayerLinkToBlend( level.player_heli_tag, "tag_origin", 2, 0, 0 );
}

heli_manual_fire()
{
	thread heli_force_fire();
	self ent_flag_init( "start_attack_run" );
	self ent_flag_wait( "start_attack_run" );
	self ent_flag_set( "unlock_pitch" );
	/*
	fly_in_attack_org = GetEnt( "fly_in_attack_org", "targetname" );
	self maps\_attack_heli::turret_minigun_fire( fly_in_attack_org, 3.5, 0 );
	wait( 4 );
	*/
	self mgon();
	self ent_flag_clear( "unlock_pitch" );
}

casual_heli_guy()
{
	waittillframeend;// let the ai on my vehicle spawn
	level.player_heli thread vehicle_ai_event( "idle_alert_to_casual" );
}


bhd_force_fire()
{
	self endon( "death" );
	self ent_flag_init( "force_fire" );
	self ent_flag_wait( "force_fire" );

	node = self.currentNode;
	delay = node.script_forcefire_delay;
	duration = node.script_forcefire_duration;
	duration = 10;
	turrets = self.mgturret;

	for ( ;; )
	{
		if ( IsDefined( delay ) )
			wait( delay );
//		
		self mgon();
		/*
		foreach ( turret in turrets )
		{
			turret StartFiring();
		}
		*/

		wait( duration );
		self ent_flag_clear( "force_fire" );

		/*
		foreach ( turret in turrets )
		{
			turret StopFiring();
		}
		*/
		self mgoff();

		self ent_flag_wait( "force_fire" );
	}
}

heli_force_fire()
{
	self endon( "death" );
	self ent_flag_init( "force_fire" );

	for ( ;; )
	{
		self ent_flag_wait( "force_fire" );
		fire_until_flag_clears();
		self.turretTarget Delete();
	}
}

fire_until_flag_clears()
{
	self endon( "force_fire" );
	turrets = self.turrets;
	if ( !isdefined( turrets ) )
		turrets = self.mgturret;
	node = self.currentNode;

	if ( IsDefined( node.script_forcefire_delay ) )
		wait( node.script_forcefire_delay );

	AssertEx( IsDefined( node.script_forcefire_duration ), "forcefire duration not set on node at " + self.origin );
	self delayThread( node.script_forcefire_duration, ::ent_flag_clear, "force_fire" );

	// force the turrets to fire straight
	target = Spawn( "script_origin", ( 0, 0, 0 ) );
	forward = AnglesToForward( self.angles );
	up = AnglesToUp( self.angles );
	target.origin = self.origin + forward * 400 + up * -400;
	target LinkTo( self );
	self.turretTarget = target;

	foreach ( turret in turrets )
	{
		turret SetTargetEntity( target );
	}

	for ( ;; )
	{
		foreach ( turret in turrets )
		{
			turret Show();
			if ( !turret IsFiringTurret() )
				turret ShootTurret();
		}

		wait 0.1;
	}
}

show_color()
{
	self endon( "death" );

	last_pos = self.origin;
	for ( ;; )
	{
		Line( self.origin, last_pos, self.start_color, 1, 1, 500 );
		last_pos = self.origin;

		wait( 0.05 );
	}
}

pitch_modifier()
{
	self endon( "death" );
	self ent_flag_init( "unlock_pitch" );
	self ent_flag_init( "lock_pitch" );
	self ent_flag_set( "lock_pitch" );

	pitch = 10;
	roll = 60;
	self SetMaxPitchRoll( pitch, roll );
	for ( ;; )
	{
		if ( self ent_flag( "lock_pitch" ) )
		{
			self SetMaxPitchRoll( 5, 60 );
		}
		else
		if ( self ent_flag( "unlock_pitch" ) )
		{
			self SetMaxPitchRoll( 100, 100 );
		}
		else
		{
			self SetMaxPitchRoll( pitch, roll );
		}

		self waittill_either( "unlock_pitch", "lock_pitch" );
	}
}



remap_targets( ent_targetname, new_targetname )
{
	// remap them so the guys riding in the heli come along too
	ents = GetEntArray( ent_targetname, "targetname" );
	foreach ( ent in ents )
	{
		ent.targetname = new_targetname;
	}
}



player_heli_stabilizes()
{
	for ( ;; )
	{
		self SetHoverParams( 50, 1, 0.5 );
		flag_wait( "stabilize" );
		self SetHoverParams( 0, 0, 0 );
		flag_waitopen( "stabilize" );
	}

}



destroy_close_missiles()
{
	fx = getfx( "missile_explosion" );
	self endon( "death" );

	for ( ;; )
	{
		rockets = GetEntArray( "rocket", "classname" );
		foreach ( rocket in rockets )
		{
			if ( rocket.model != "projectile_stinger_missile" )
				continue;

			if ( Distance( self.origin, rocket.origin ) < 100 )
			{
				flag_set( "aa_hit" );
				PlayFX( fx, rocket.origin );
				rocket Delete();
			}
		}
		wait( 0.05 );
	}
}

modify_player_heli_yaw_over_time()
{
	level endon( "player_heli_uses_modified_yaw" );
	if ( flag( "player_heli_uses_modified_yaw" ) )
		return;

	// the player's heli rotates slowly over time to give a better viwe
	yaw_progress_ent = getstruct( "yaw_progress_ent", "targetname" );
	yaw_progress_ent_target = getstruct( yaw_progress_ent.target, "targetname" );

	pitch_target_org = getstruct( "pitch_target", "targetname" );
	pitch_target = Spawn( "script_origin", pitch_target_org.origin );
	self SetLookAtEnt( pitch_target );

	fly_in_progress = getstruct( "fly_in_progress", "targetname" );
	fly_in_progress_target = getstruct( fly_in_progress.target, "targetname" );
	fly_in_progress_dist = Distance( fly_in_progress.origin, fly_in_progress_target.origin );

	for ( ;; )
	{
		progress_array = get_progression_between_points( self.origin, fly_in_progress.origin, fly_in_progress_target.origin );
		progress = progress_array[ "progress" ];

		progress_percent = progress / fly_in_progress_dist;
		if ( progress_percent < 0 )
			progress_percent = 0;
		if ( progress_percent > 1 )
			progress_percent = 1;
		level.progress = progress_percent;

		pitch_target.origin = yaw_progress_ent.origin * ( 1 - progress_percent ) + yaw_progress_ent_target.origin * ( progress_percent );
		wait( 0.05 );
	}
}


modify_speed_to_match_player_heli( fly_in_progress_dist )
{
	max_speed = 80;
	min_speed = 70;
	min_units = -125;
	max_units = 125;

	range_speed = max_speed - min_speed;
	range_units = max_units - min_units;

	waittillframeend;// wait for all progressess to get set once at least

	start_dif = self.progress - level.player_heli.progress;
	start_dif *= 5;
	self.start_dif = start_dif;

	for ( ;; )
	{
		my_progress = self.progress - start_dif;
		my_progress -= 50;
		// dif is the difference in units of progress between player and me
		dif = level.player_heli.progress - my_progress;

		if ( dif < min_units )
			dif = min_units;
		else
		if ( dif > max_units )
			dif = max_units;

		dif += min_units * -1;

		speed = dif * range_speed / range_units;
		speed += min_speed;
		speed += RandomFloat( 4 ) - 2;
		//assert( speed <= max_speed && speed >= min_speed );
//		our_units	x
//		range_units	range_speed

		self Vehicle_SetSpeed( speed, 15, 15 );
		wait( 0.05 );
	}
}

track_fly_in_progress( fly_in_progress, fly_in_progress_target, fly_in_progress_dist )
{

	if ( self != level.player_heli )
	{
		thread modify_speed_to_match_player_heli( fly_in_progress_dist );
	}

	self.start_dif = 0;
	for ( ;; )
	{
		progress_array = get_progression_between_points( self.origin, fly_in_progress.origin, fly_in_progress_target.origin );
		self.progress = progress_array[ "progress" ];
		//Print3d( self.origin + (0,0,32), self.progress + " " + self.start_dif, (1,0.5,1), 1, 2 );
		wait( 0.05 );
	}
}


/* --------------
   TV MOVIES
---------------*/
init_tv_movies()
{
	wait( 1 );
	SetSavedDvar( "cg_cinematicFullScreen", "0" );

	while ( 1 )
	{
		flag_wait( "player_near_tv" );
		CinematicInGameLoopResident( "gulag_securitycam" );

		flag_waitopen( "player_near_tv" );
		tv_movies_stop();
	}
}

tv_movies_stop()
{
	StopCinematicInGame();
	level notify( "stop_tv_loop" );

	/*
	videos = GetEntArray( "interactive_tv", "targetname" );

	foreach ( video in videos )
	{
		if ( IsSubStr( video.model, "tv1_cinematic" ) )
		{
			video SetModel( "com_tv1_testpattern" );
		}
	}
	*/
}

armed_heli_fires_turrets()
{
	heli = level.heli_armed;

	armed_target_1 = GetEnt( "armed_target_1", "targetname" );

	foreach ( turret in heli.mgturret )
	{
		turret SetTargetEntity( armed_target_1 );
	}

}

glassy_pain()
{
	glass = getfx( "glassy_pain" );
	self waittill( "death" );
	if ( !isdefined( self ) )
		return;
	angles = VectorToAngles( randomvector( 10 ) );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );
	PlayFX( glass, self.origin + ( 0, 0, 40 ), forward, up );
}

player_heli_rotates_properly_around_gulag()
{
	level endon( "stop_moving_gulag_center" );
	gulag_center = GetEnt( "gulag_center", "targetname" );
	org = gulag_center.origin;
	follow_ent = Spawn( "script_origin", ( 0, 0, 0 ) );

	self SetLookAtEnt( follow_ent );
	thread player_heli_processess_rotation( gulag_center, follow_ent );
	flag_wait( "stab2_clear" );

	targ = GetEnt( gulag_center.target, "targetname" );
	targ2 = GetEnt( targ.target, "targetname" );
	level.view_org MoveTo( targ.origin, 4, 1, 1 );

	level.player.ignoreme = true;
	level.soap.ignoreme = true;

	flag_wait( "f15_gulag_explosion" );


	//thread f15_explosion_causes_heli_to_look_away( gulag_center, follow_ent );
//	level notify( "stop_rotating_around_gulag_break" );
	//thread player_heli_processess_rotation( gulag_center, follow_ent );


	flag_set( "clear_dof" );



	level.player.ignoreme = false;
	level.soap.ignoreme = false;

	delayThread( 2.5, ::exploder, 93 );
	delayThread( 3, ::kill_deathflag, "final_tower_died" );

	player_heli_landing_path = getstruct( "player_heli_landing_path", "targetname" );

	// change path for explosion
	level.player_heli delayThread( 1.5, ::vehicle_paths, player_heli_landing_path );

	wait( 1.5 );

	wait( 1 );

	gulag_center MoveTo( targ2.origin, 2, 1, 1 );
	level.view_org MoveTo( targ2.origin, 1.5, 0.5, 0.5 );

	level.player_heli delayThread( 2.7, ::play_sound_on_entity, "scn_gulag_heli_atlitude_alarm" );
	level.player delayThread( 2.7, ::play_sound_on_entity, "scn_gulag_heli_shakes" );

	//Earthquake( scale, duration, source, radius );
	noself_delayCall( 0.5, ::Earthquake, 0.25, 2.5, level.player.origin, 5000 );
	noself_delayCall( 2.0, ::Earthquake, 0.35, 2.5, level.player.origin, 5000 );
	noself_delayCall( 2.35, ::Earthquake, 0.2, 1, level.player.origin, 5000 );
	noself_delayCall( 2.75, ::Earthquake, 0.4, 4.5, level.player.origin, 5000 );

	level delayThread( 1.8, ::send_notify, "f15_smoke" );
	level delayThread( 2.1, ::send_notify, "afterburner" );


	arcRight = 2;
	arcLeft = 2;
	arcTop = 2;
	arcBottom = 2;

	level.player LerpViewAngleClamp( 1.8, 0.25, 0.75, arcRight, arcLeft, arcTop, arcBottom );
	wait( 1 );
	wait( 1 );

	delayThread( 2, ::helis_respawn_to_land );
	arcRight = 45;
	arcLeft = 45;
	arcTop = 15;
	arcBottom = 45;
	level.player LerpViewAngleClamp( 3, 0.25, 0.25, arcRight, arcLeft, arcTop, arcBottom );

	thread ground_ref_freaks_out();

	ent = GetEnt( "f15_hli_target_ent", "targetname" );
	gulag_center MoveTo( ent.origin, 3, 0.5, 0.5 );
	level.view_org MoveTo( ent.origin, 3, 0.5, 0.5 );

	delayThread( 3.5, ::flag_clear, "clear_dof" );

	/*
	foreach ( heli in level.friendly_helis )
	{
		heli ent_flag_wait( "ready_for_landing" );
	}	
	*/
	wait( 5 );
	gulag_center MoveTo( org, 3, 0.5, 0.5 );
	level.view_org MoveTo( org, 3, 0.5, 0.5 );


	//wait( 4 );
	flag_wait( "stop_rotating_around_gulag" );
	level notify( "stop_rotating_around_gulag_break" );



	//	self ClearLookAtEnt();
	fly_in_lookat_ent = GetEnt( "fly_in_lookat_ent", "targetname" );
	self SetLookAtEnt( fly_in_lookat_ent );

	flag_wait( "player_lands" );
	flag_set( "clear_dof" );

	//self waittill( "reached_dynamic_path_end" );
	/*
	wait( 9 );
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay FadeOverTime( 1 );
	black_overlay.alpha = 1;
	wait( 2 );
	nextmission();
	*/	
}

f15_explosion_causes_heli_to_look_away( gulag_center, follow_ent )
{
	wait( 4.9 );
	ent = GetEnt( "f15_hli_target_ent", "targetname" );

	old_org = gulag_center.origin;
	old_view_org = level.view_org.origin;

	gulag_center MoveTo( ent.origin, 2, 1, 1 );
	level.view_org MoveTo( ent.origin, 2, 1, 1 );

//	level notify( "stop_rotating_around_gulag_break" );
//	self SetLookAtEnt( ent );

//	level.player_view_controller SetTargetEntity( ent );
	wait( 3 );
//	level.player_view_controller SetTargetEntity( gulag_center );
//	thread player_heli_processess_rotation( gulag_center, follow_ent );

	gulag_center MoveTo( old_org, 2, 1, 1 );
	level.view_org MoveTo( old_view_org, 2, 1, 1 );
	wait( 2 );
	gulag_center.origin = old_org;
	level.view_org.origin = old_view_org;
}

ground_ref_freaks_out()
{
	tag_origin = level.ground_ref;
	tag_origin Unlink();
	mult = 4;

	model = spawn_tag_origin();
	model.angles = tag_origin.angles;
	model AddPitch( 15 * mult );
	model AddRoll( 25 * mult );

	tag_origin RotateTo( model.angles, 1, 0.4, 0.4 );
	wait( 1.5 );

	model AddPitch( -35 * mult );
	model AddRoll( -55 * mult );

	tag_origin RotateTo( model.angles, 1, 0.4, 0.4 );
	wait( 1 );

	//tag_origin LinkToBlendToTag( level.player_heli, "tag_origin" );
	tag_origin RotateTo( level.player_heli.angles, 1, 0.4, 0.4 );
//	tag_origin linktoblend
//	
	wait( 1 );
	tag_origin LinkTo( level.player_heli, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

player_heli_processess_rotation( gulag_center, follow_ent )
{
	level endon( "stop_rotating_around_gulag_break" );
	for ( ;; )
	{
		angles = VectorToAngles( self.origin - gulag_center.origin );
		right = AnglesToRight( angles );

		dist = Distance( gulag_center.origin, self.origin );
		right *= dist * level.stabilize_offset * -1;

		follow_ent.origin = gulag_center.origin + right;
		//Print3d( follow_ent.origin, "x", ( 1, 0, 0 ), 1, 10 );
		wait( 0.05 );
	}
}

toggle_f15_viewing( dvar_val )
{
	//hide/show models and f15 for zach
	self endon( "death" );
	old_dvar = -1;
	for ( ;; )
	{
		dvar = GetDvarInt( "f15" );
		if ( dvar != old_dvar )
		{
			if ( dvar == dvar_val || dvar == 2 )
				self Show();
			else
				self Hide();
		}
		old_dvar = dvar;
		wait( 0.05 );
	}
}

spawn_intro_plane( scene, looker )
{

	spawner = GetEnt( scene + "_f15", "targetname" );
	plane = spawner spawn_vehicle();
	waittillframeend;// wait for the default vehicle stuff to happen
	plane.animname = "f15";
	plane assign_animtree();
	plane ent_flag_clear( "contrails" );
	plane.scene = scene;

	if ( looker )
	{
		level.looker_f15 = plane;
	}

	level.intro_plane[ scene ] = plane;
	org = GetEnt( "plane_org", "targetname" );

	org thread anim_single_solo( plane, scene );
	missile1 = spawn_anim_model( scene + "_missile" );
	missile2 = spawn_anim_model( scene + "_missile" );

	missiles = [];
	missiles[ 0 ] = missile1;
	missiles[ 1 ] = missile2;

	plane.missiles = missiles;

	foreach ( missile in missiles )
	{
		missile Hide();
	}

	org thread anim_single_solo( missile1, "missile_fire_a" );
	org thread anim_single_solo( missile2, "missile_fire_b" );


	plane thread delete_on_animend();
	missile1 thread delete_on_animend();
	missile2 thread delete_on_animend();


	pilot = Spawn( "script_model", ( 0, 0, 0 ) );
	pilot.origin = plane.origin;
	pilot.angles = plane.angles;
	pilot.animname = "pilot";
	pilot assign_animtree();
	pilot character\character_sp_pilot_zack_woodland::main();
	pilot LinkTo( plane, "tag_body", ( 0, 0, 0 ), ( 0, 0, 0 ) );


	plane thread anim_loop_solo( pilot, "idle", "stop_idle", "tag_body" );
	plane waittill( "death" );
	pilot Delete();


//	model thread toggle_f15_viewing( 1 );

	/*
	model thread maps\_f15::playConTrail();
	afterburners = getfx( "afterburner" );
	PlayFXOnTag( afterburners, model, "tag_engine_right" );
	PlayFXOnTag( afterburners, model, "tag_engine_left" );	
	*/

}

delete_on_animend()
{
	self waittillmatch( "single anim", "end" );
	self Delete();
}

spawn_intro_missile( name )
{
	model = spawn_anim_model( name );
	org = GetEnt( "plane_org", "targetname" );


	org thread anim_single_solo( model, "intro" );
	//model maps\_debug::drawTagForever( "tag_weapon" );
}

spawn_f15s()
{
	flag_set( "f15s_spawn" );
	level.intro_plane = [];
	thread spawn_intro_plane( "intro_1", true );
	thread spawn_intro_plane( "intro_2", false );
	delayThread( 20.6, ::exploder, 20 );
	delayThread( 21.2, ::exploder, 21 );
	delayThread( 24.0, ::exploder, 22 );
}

gulag_become_ghost()
{
	level.ghost = self;
	self.animname = "ghost";
	self magic_bullet_shield();
	self make_hero();
}

looker_guy()
{
	self endon( "death" );
	level endon( "player_lands" );
	self.baseaccuracy = 60;
	self.accuracy = 60;
	gulag_become_soap();


	if ( is_default_start() )
	{
		self forceUseWeapon( "m14_scoped_arctic", "primary" );
		/*
		pitch_target = GetEnt( "pitch_target", "targetname" );
		self SetLookAtEntity( level.friendly_helis[ 0 ] );
		flag_wait( "f15s_spawn" );
		wait( 0.5 );
		*/
		wait( 0.05 );
		ent = spawn_tag_origin();
		ent LinkTo( level.looker_f15, "tag_origin", ( 0, 0, 250 ), ( 0, 0, 0 ) );
		self SetLookAtEntity( ent );
		level waittill( "switch_look" );
		ent Delete();
		self SetLookAtEntity( level.looker_f15 );
		level.looker_f15 waittill( "death" );
		/*
		flag_wait( "aa_hit" );
		wait( 1 );
		self SetLookAtEntity( level.player );
		wait( 0.8 );
		self SetLookAtEntity( pitch_target );
		flag_wait( "approach_dialogue" );
		*/
		self SetLookAtEntity();
	}
	else
	if ( level.start_point == "approach" )
	{
		self forceUseWeapon( "m14_scoped_arctic", "primary" );
	}

	gulag_center = GetEnt( "gulag_center", "targetname" );
	gulag_center_above = spawn_tag_origin();
	gulag_center_above.origin = gulag_center.origin + ( 0, 0, 1000 );
	level.gulag_center_above = gulag_center_above;
	self SetLookAtEntity( gulag_center_above );

//	gulag_center_above.origin = level.player.origin;
//	gulag_center_above LinkTo( level.player );

	soap_looks_at_targets();
	wait( 1.1 );

	tower_ent = GetEnt( "soap_tower_lookat", "targetname" );
	self SetLookAtEntity( tower_ent );
	gulag_center_above Delete();

	flag_wait( "final_tower_died" );
	wait( 1.2 );
	self SetLookAtEntity( level.plane_buzzes_gulag );
	wait( 3 );
	self SetLookAtEntity();
//	self SetLookAtEntity( level.looker_f15 );
//	wait( 4 );
//	self StopLookAt();
}

soap_looks_at_targets()
{
	level endon( "gulag_perimeter" );
	if ( flag( "gulag_perimeter" ) )
		return;

	for ( ;; )
	{
		flag_wait( "soap_snipes_tower" );
		looker_attacks_ground();
		flag_waitopen( "soap_snipes_tower" );
		self SetLookAtEntity( level.gulag_center_above );
	}
}

looker_attacks_ground()
{
	level endon( "soap_snipes_tower" );
	wait( 4.4 );
	for ( ;; )
	{
		if ( IsAlive( self.enemy ) )
		{
			self SetLookAtEntity( self.enemy );
			self Shoot();
			wait( 0.05 );
//			if ( IsAlive( self.enemy ) )
//				self.enemy Kill();
			wait( RandomFloatRange( 2.5, 3 ) );
		}
		wait( 0.1 );
	}
}


tarp_pull_org_think()
{
	self.operational = true;
	launcher = Spawn( "script_model", ( 0, 0, 0 ) );
	launcher SetModel( "vehicle_slamraam_launcher_no_spike" );
	launcher.origin = self.origin;
	launcher.angles = self.angles;

	all_missiles_model = Spawn( "script_model", ( 0, 0, 0 ) );
	all_missiles_model SetModel( "vehicle_slamraam_missiles" );
	all_missiles_model.origin = self.origin;
	all_missiles_model.angles = self.angles;
	self.all_missiles_model = all_missiles_model;
	self.launcher = launcher;

	self.angles += ( 0, 90, 0 );
	self.guys = [];
	tarp = spawn_anim_model( "tarp" );
	self anim_first_frame_solo( tarp, "pulldown" );
	self.tarp = tarp;

}

slamraam_tracks_player()
{
	self endon( "stop_tracking" );
	self endon( "death" );
	delayThread( 12, ::Send_notify, "stop_tracking" );

	first_rotate = true;
	for ( ;; )
	{
		angles = VectorToAngles( level.player.origin - self.origin );
		yaw = angles[ 1 ];
		current_yaw = self.angles[ 1 ];

		forward1 = AnglesToForward( ( 0, yaw, 0 ) );
		forward2 = AnglesToForward( ( 0, current_yaw, 0 ) );
		dot = VectorDot( forward1, forward2 );

		//yaw_dif = abs( current_yaw - yaw );
		yaw_dif = 0;
		if ( dot < 1 )
			yaw_dif = ACos( dot );

		//println( "yaw " + yaw + " new_yaw " + current_yaw + " dif " + yaw_dif );

		time = yaw_dif * 0.025;
		if ( time > 0.05 || first_rotate )
		{
			if ( first_rotate )
			{
				time = yaw_dif * 0.011;
				first_rotate = false;
				self RotateTo( ( 0, yaw, 0 ), time, time * 0.25, time * 0.25 );
			}
			else
			{
				self RotateTo( ( 0, yaw, 0 ), time, 0, 0 );
			}
			wait( time );
		}
		else
		{
			self.angles = ( 0, yaw, 0 );
			wait( 0.05 );
		}
	}
}

slamraam_attacks( fire_delay, between_sets_delay )
{

	tags = [];
	tags[ tags.size ] = "tag_missle1";
	tags[ tags.size ] = "tag_missle2";
	tags[ tags.size ] = "tag_missle3";
	tags[ tags.size ] = "tag_missle4";
	tags[ tags.size ] = "tag_missle5";
	tags[ tags.size ] = "tag_missle6";
	tags[ tags.size ] = "tag_missle7";
	tags[ tags.size ] = "tag_missle8";

	missiles = [];
	launcher = self.launcher;
	launcher thread slamraam_tracks_player();


	self.all_missiles_model LinkTo( launcher );

	self endon( "lose_operation" );
	// wait until the turret is on target
	for ( ;; )
	{
		if ( within_fov_2d( launcher.origin, launcher.angles, level.player.origin, 0.96 ) )
			break;
		wait( 0.05 );
	}

	if ( IsDefined( fire_delay ) )
	{
		// fire_delay exists so the turret can track before it fires
		wait( fire_delay );
	}


	// spawn single missiles for each missile spot
	foreach ( index, tag in tags )
	{
		model = Spawn( "script_model", ( 0, 0, 0 ) );
		model.origin = launcher GetTagOrigin( tag );
		model.angles = launcher GetTagAngles( tag );
		model SetModel( "projectile_slamraam_missile" );
		model LinkTo( launcher );
		missiles[ index ] = model;
	}

//	if ( flag( "gulag_perimeter" ) )
//		thread heli_player_dies();

	// delete the model that has all 8 missiles in it
	self.all_missiles_model Delete();

	// launch missiles from all the spots
	for ( index = 0; index < 4; index++ )
	{
		tag = tags[ index ];
		launcher slamraam_fires_missile( tag, missiles[ index ] );
	}

	if ( IsDefined( between_sets_delay ) )
		wait( between_sets_delay );

	// launch missiles from all the spots
	for ( index = 4; index < tags.size; index++ )
	{
		tag = tags[ index ];
		launcher slamraam_fires_missile( tag, missiles[ index ] );
	}
}

slamraam_fires_missile( tag, missile )
{
	org = self GetTagOrigin( tag );
	angles = self GetTagAngles( tag );
	forward = AnglesToForward( angles );
	MagicBullet( level.slamraam_missile, org, org + forward * 5000 );
	wait( 0.05 );
	missile Delete();
	wait( 0.20 );
}

tarp_spawner_think()
{
	// each spawner runs this func and they're stored in a global array. The first one early outs, the second executes
	// the scripted sequence. If you were to spawn two sets at once, you could get some badness.

	// the animname is on the spawner
	self.animname = self.script_parameters;
	AssertEx( IsDefined( self.animname ), "No animname?! But why." );

	org = self.origin;
	if ( IsDefined( self.target ) )
	{
		ent = get_target_ent();
		org = ent.origin;
	}
	// the tarp ents are in a prefab and the geo is locked so just find the nearest
	tarp_ents = GetEntArray( "tarp_pull_org", "targetname" );
	node = getClosest( org, tarp_ents, 1000 );
	AssertEx( IsDefined( node ), "Tarp guy couldn't find a tarp to pull within 1000 units of his .target origin." );
	node.guys[ node.guys.size ] = self;

	// when they spawn they get put into node.guys
	if ( node.guys.size == 1 )
	{
		// early out if I'm the first guy
		return;
	}

	// badness!
	AssertEx( node.guys.size == 2, "Tried to make more than 2 guys go to one tarp, BZZZZT!" );

	tarp_guys = node.guys;

	tarp_gets_pulled( node, tarp_guys );
}

tarp_gets_pulled( node, tarp_guys )
{
	foreach ( guy in tarp_guys )
	{
		guy.allowdeath = 1;
		guy.goalradius = 16;
		guy.ignoreme = true;
		guy.allowdeath = true;
		guy.health = 5;
	}

	node anim_reach( tarp_guys, "pulldown" );

	if ( !node.operational )
		return false;

	tarp_guys = remove_dead_from_array( tarp_guys );
	tarp_guys[ tarp_guys.size ] = node.tarp;

	if ( IsDefined( node.tarp_needs_living_ai_to_get_pulled ) )
	{
		living_guys = 0;
		foreach ( guy in tarp_guys )
		{
			if ( IsAlive( guy ) )
				living_guys++;
		}

		if ( !living_guys )
			return false;
	}

	level notify( "tarp_activate" );
	node delayThread( 3.15, ::send_notify, "tarp_activate" );


	time = anim_get_shortest_animation_time( tarp_guys, "pulldown" );
	AssertEx( !isdefined( node.tarp.tarp_fell ), "Tarp fell twice!" );
	node.tarp.tarp_fell = true;
	AssertEx( node.operational, "The node was not operational." );
	node thread anim_single_run( tarp_guys, "pulldown" );
	wait( time );
	tarp_guys = remove_dead_from_array( tarp_guys );
	if ( tarp_guys.size )
		thread tarp_guys_idle_and_recover( node, tarp_guys );

	return true;
}

anim_get_shortest_animation_time( guys, scene )
{
	time = 999999;
	foreach ( guy in guys )
	{
		animation = guy getanim( scene );
		new_time = GetAnimLength( animation );
		if ( new_time < time )
			time = new_time;
	}

	AssertEx( time < 999999, "Tried to anim_get_shortest_animation_time but there was no guys with scenes" );
	return time;
}

tarp_guys_idle_and_recover( node, tarp_guys )
{
	idler = undefined;

	tarp_guys = remove_dead_from_array( tarp_guys );
	foreach ( guy in tarp_guys )
	{
		if ( IsAlive( guy ) )
			guy SetGoalPos( guy.origin );

		if ( guy.animname == "operator" )
		{
			// operator has an idle
			idler = guy;
		}
	}

	if ( IsDefined( idler ) )
	{
		node thread anim_loop_solo( idler, "idle" );
	}

	wait( 3 );

	tarp_guys = remove_dead_from_array( tarp_guys );
	foreach ( guy in tarp_guys )
	{
		guy.ignoreme = false;
		guy.goalradius = 750;
	}
}

rotate_until_f15_dies( model )
{
	model thread toggle_f15_viewing( 0 );
	self endon( "death" );

	min_rotate = 1.0;
	max_rotate = 2.0;
	rotate_time = 1;
	rotate_range = max_rotate - min_rotate;

	rotate_frames = rotate_time * 20;
	sinner = 0;
	base = 0.35;

	for ( i = 0; i < rotate_frames; i++ )
	{
		rotate_rate = min_rotate + ( i * rotate_range / rotate_frames );
		model SetAnim( level.rotate_anims_vehicle[ "x_right" ], 1, 10, rotate_rate );

		wait( 0.05 );
	}
	wait( 10 );
/*	
	//model SetAnim( level.rotate_anims_vehicle[ "x_left" ], 1, 10, 0.7 );
	wait( 0.5 );
	model SetAnim( level.rotate_anims_vehicle[ "x_right" ], 1, 10, 0.2 );
	wait( 1.5 );
	
	for ( i = 0; i < rotate_frames; i++ )
	{
		sinner += 18;
		//rotate_rate = min_rotate + ( i * rotate_range / rotate_frames );
		rotate_rate = base + Sin( sinner ) * 0.1;
		base += 0.005;
		//println( rotate_rate );
		model SetAnim( level.rotate_anims_vehicle[ "x_right" ], 1, 10, rotate_rate );
	
		wait( 0.05 );
	}
*/
	/*
	i					0
	rotate_frames		rotate_range
	*/

}

gulag_top_drones()
{
	//if ( 1 ) return;
	level.total_drones = 0;
	// drones that swarm the top of the gulag
	level.droneCallbackThread = ::drone_think;

	flag_wait( "approach_dialogue" );

	// we'll do something better with the gates.
	gulag_top_gates = GetEntArray( "gulag_top_gate", "targetname" );
	array_call( gulag_top_gates, ::NotSolid );
	array_call( gulag_top_gates, ::Hide );

	gulag_ring_drones = GetEntArray( "gulag_ring_drone", "targetname" );
	array_thread( gulag_ring_drones, ::gulag_ring_drone_think );

	gulag_top_drones = GetEntArray( "gulag_top_drone", "targetname" );
	array_thread( gulag_top_drones, ::gulag_top_drone_think );

//	gulag_drone_triggers = GetEntArray( "gulag_drone_trigger", "targetname" );
//	array_thread( gulag_drone_triggers, ::gulag_drone_trigger_think );
}

gulag_drone_trigger_think()
{
	spawner = GetEnt( self.target, "targetname" );
	self waittill( "trigger" );

	spawner spawn_a_drone();
	wait( 0.3 );
	spawner spawn_a_drone();
	wait( 0.2 );
	spawner spawn_a_drone();
	wait( 0.4 );
	spawner spawn_a_drone();
	wait( 0.1 );
	spawner spawn_a_drone();
	wait( 0.2 );
	spawner spawn_a_drone();
}

spawn_a_drone()
{
	max_drones = 75;
	if ( getdvarint( "r_gulag_lessdrones" ) )
	{
		max_drones = 10;
	}
	
	if ( level.total_drones >= max_drones )
		return;

	self.count = 1;
	self spawn_ai();
}

drone_think()
{
	level.total_drones++;
	kill_on_goal();
	level.total_drones--;
}

kill_on_goal()
{
	self waittill( "goal" );
	self Delete();
}

gulag_ring_drone_think()
{
	spawn_drones_forever( 3, 5 );
}

gulag_top_drone_think()
{
	spawn_drones_forever( 2, 3 );
}

gulag_drone_think()
{
	self endon( "death" );
	level waittill( "stop_gulag_drones" );
	wait( RandomFloatRange( 1, 6 ) );
	self Kill();
}

spawn_drones_forever( min, max )
{
	self add_spawn_function( ::gulag_drone_think );
	level endon( "stop_gulag_drones" );
	for ( ;; )
	{
		count = RandomIntRange( min, max );
		for ( i = 0; i < count; i++ )
		{
			self spawn_a_drone();
			wait( RandomFloatRange( 0.4, 0.7 ) );
		}
		wait RandomFloatRange( 2, 3.5 );
	}
}

blend_in_gulag_dof( time )
{
	start = level.dofDefault;
	end[ "nearStart" ] = 1;
	end[ "nearEnd" ] = 1;
	end[ "nearBlur" ] = 4;

	end[ "farStart" ] = 5000;
	end[ "farEnd" ] = 10000;
	end[ "farBlur" ] = 2;

	for ( ;; )
	{
		blend_dof( start, end, time );

		flag_wait( "clear_dof" );

		blend_dof( end, start, 1 );

		flag_waitopen( "clear_dof" );
	}
}



blow_up_first_tower_soon()
{
	flag_wait( "blow_up_first_tower_soon" );
	wait( 1.5 );
	exploder( "tower_explosion_fx" );
	wait( 0.15 );
	exploder( "tower_explosion" );
	wait( .15 );
	exploder( "tower_explosion_fx" );

}

remove_rpgs()
{
	// when the first heli lands, all the AI have to reload (so RPG guys lose their rpg).
	flag_wait( "remove_rpgs" );

	tower_height_ent = GetEnt( "tower_height_ent", "targetname" );

	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		guy.bulletsinclip = 0;
		guy.a.rockets = 0;

		// kill left over tower guys
		if ( guy.origin[ 2 ] > tower_height_ent.origin[ 2 ] )
			guy Kill();
	}
}


GetNodeChain( name, type )
{
	control_room_chain = GetNode( name, type );
	nodes = [];
	for ( ;; )
	{
		nodes[ nodes.size ] = control_room_chain;
		if ( !isdefined( control_room_chain.target ) )
			break;
		control_room_chain = GetNode( control_room_chain.target, type );
	}
	return nodes;
}

friendlies_postup_at_chain( ai, name )
{
	level notify( "new_ai_move_command" );
	level endon( "new_ai_move_command" );
	nodes = GetNodeChain( name, "targetname" );
	for ( i = 0; i < ai.size; i++ )
	{
		if ( i >= nodes.size )
			break;
		guy = ai[ i ];
		node = nodes[ i ];
		if ( !isalive( guy ) )
			continue;

		guy SetGoalNode( node );
		guy.goalradius = 64;
		wait( RandomFloatRange( 0.1, 0.25 ) );
	}
}

gulag_cellblock_friendlies_postup_at_chain( name )
{
	ai = get_cellblock_friendlies();
	friendlies_postup_at_chain( ai, name );
}

gulag_cellblocks_friendlies_go_to_control_room()
{
	level notify( "new_ai_move_command" );

	friendly_respawn_trigger = GetEnt( "friendly_reinforcement_trigger", "targetname" );
	friendly_respawn_trigger thread reinforcement_friendlies();

	// friendlies run into the control room at specific positions from a chain of nodes
	nodes = GetNodeChain( "control_room_chain", "targetname" );

	level.control_room_nodes = nodes;

	ai = GetAIArray( "allies" );

	// some of the friendlies will stay at their node
	for ( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		node.filled = false;
		if ( i >= 1 && i <= 4 )
			node.stays_in_control_room = true;
	}

	for ( i = 0; i < ai.size; i++ )
	{
		node = nodes[ i ];
		AssertEx( IsDefined( node ), "Too many friendlies!" );
		node.filled = true;

		ai[ i ] thread ai_goes_to_control_room_node( node );
	}
}

ai_goes_to_control_room_node( node )
{
	node.filled = true;
	self SetGoalNode( node );
	self ClearGoalVolume();
	self.goalradius = 64;
	self.fixednode = true;
	self.stays_in_control_room = node.stays_in_control_room;
	if ( IsDefined( self.stays_in_control_room ) )
	{
		self endon( "death" );
		self waittill( "goal" );
		self.ignoreme = true;
		self.dontEverShoot = true;
	}
}

get_cellblock_mbs()
{
	ai = get_cellblock_friendlies();
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
			return guy;
	}
}

get_mbs( ai )
{
	guys = [];
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
			guys[ guys.size ] = guy;
	}
	return guys;
}

gulag_cellblocks_friendlies_go_to_goalvolume( goalvolNum )
{
	level notify( "new_ai_move_command" );

	if ( !isdefined( goalvolNum ) )
		goalvolNum = level.last_cellblock_vol;

	AssertEx( IsDefined( goalvolNum ), "Must have volnum!" );
	level.last_cellblock_vol = goalvolNum;
	nodes = GetNodeArray( "cell_goalnode", "targetname" );

	node = undefined;
	foreach ( node in nodes )
	{
		if ( node.script_goalvolume == goalvolNum )
			break;
	}
	AssertEx( node.script_goalvolume  == goalvolNum, "Didnt find cell_goalnode with vol " + goalvolNum );

	volume = GetEnt( node.target, "targetname" );

	ai = get_cellblock_friendlies();
	foreach ( guy in ai )
	{
		guy SetGoalNode( node );
		guy.fixednode = false;
		guy.goalradius = node.radius;
		guy SetGoalVolume( volume );
	}
}

reinforcement_friendlies()
{
	self waittill( "trigger" );

	// these guys fill in for any dead
	/# flag_assert( "control_room" ); #/

	ai = GetAIArray( "allies" );
	spawners = GetEntArray( self.target, "targetname" );

	count = 0;
	for ( i = ai.size; i < 7; i++ )
	{
		spawner = spawners[ count ];
		spawner spawn_ai();
		count++;

		if ( count >= spawners.size )
			return;
	}
}

setup_celldoor( targetname )
{
	door_ents = GetEntArray( targetname, "targetname" );

	door = undefined;
	org = undefined;
	models = [];
	foreach ( ent in door_ents )
	{
		if ( ent.code_classname == "script_brushmodel" )
		{
			door = ent;
		}
		else
		if ( ent.code_classname == "script_model" )
		{
			models[ models.size ] = ent;
		}
		else
		if ( ent.code_classname == "script_origin" )
		{
			org = ent;
		}
	}

	AssertEx( IsDefined( door ), "Found no script_brushmodel for " + targetname );

	model_storage = [];
	foreach ( index, model in models )
	{
		array = [];
		array[ "origin" ] = model.origin;
		array[ "angles" ] = model.angles;
		array[ "model" ] = model.model;

		model_storage[ index ] = array;

		model Delete();
	}

	flag_wait( "gulag_cell_doors_enabled" );

	foreach ( array in model_storage )
	{
		if ( array[ "model" ] != "metal_prison_door" )
			continue;

		model = Spawn( "script_model", ( 0, 0, 0 ) );
		model.origin = array[ "origin" ];
		model.angles = array[ "angles" ];
		model SetModel( array[ "model" ] );
		model LinkTo( door );
	}

	door.org = org;

	lights = GetEntArray( "door_light", "targetname" );
	closest_lights = get_array_of_closest( door.origin, lights, undefined, 2, 100 );

	door.lights = [];

	for ( i = 0; i < closest_lights.size; i++ )
	{
		light = closest_lights[ i ];
		AssertEx( IsDefined( light ), "Ran out of lights!" );
		door.lights[ door.lights.size ] = light;
		light.targetname = undefined;// so future doors don't grab this one
	}

	door thread door_logic();
}

play_dlight( color )
{
	if ( !self.lights.size )
		return;

	self notify( "stop_dyn" );
	self endon( "stop_dyn" );
	if ( IsDefined( self.fx ) )
		self.fx Delete();

	fx = getfx( "dlight_" + color );

	col = ( 0, 0.5, 1 );
	if ( color == "red" )
		col = ( 1, 0, 0 );

	if ( IsDefined( self.looper ) )
		self.looper Delete();
	self.looper = PlayLoopedFX( fx, 50, self.dlight_origin, 2000 );
}

ghost_tries_to_open_door()
{

	ents = getentarray( "cell_door_weapons", "targetname" );
	loc = ents[0].origin;
	thread play_sound_in_space( "scn_gulag_jail_door_buzzer", loc );
	wait( 1.2 );
	thread play_sound_in_space( "scn_gulag_jail_door_unlock", loc );
	thread play_sound_in_space( "scn_gulag_armory_door_open", loc );

	delaythread( 1.8, ::flag_set, "open_cell_door_weapons" );
	wait( 2.9 );
	thread play_sound_in_space( "scn_gulag_jail_door_unlock", loc );
	thread play_sound_in_space( "scn_gulag_armory_door_open", loc );

	/*
	ents = getentarray( "cell_door_weapons", "targetname" );
	loc = ents[0].origin;
	
	thread play_sound_in_space( "scn_gulag_jail_door_buzzer", loc );
	wait( 1.2 );
	thread play_sound_in_space( "scn_gulag_jail_door_unlock", loc );
	wait( 2 );
	thread play_sound_in_space( "scn_gulag_armory_door_open", loc );

	wait( 2 );

	thread play_sound_in_space( "scn_gulag_armory_door_open", loc );
	wait( 0.5 );
	thread play_sound_in_space( "scn_gulag_armory_door_open", loc );
	
	wait( 1 );

	thread play_sound_in_space( "scn_gulag_armory_door_open", loc );
	*/
}

armory_attack_sounds( dist )
{
	flag_set( "armory_attack_sounds" );
	thread play_sound_in_space( "scn_gulag_jail_door_buzzer", level.player.origin + (0,dist,500) );
	wait( 1.2 );
	thread play_sound_in_space( "scn_gulag_jail_door_unlock", level.player.origin + (0,dist,500) );
	thread play_sound_in_space( "scn_gulag_armory_door_open", level.player.origin + (0,dist,500) );

	wait( 2.0 );
	thread play_sound_in_space( "scn_gulag_jail_door_unlock", level.player.origin + (0,dist,500) );
	thread play_sound_in_space( "scn_gulag_armory_door_open", level.player.origin + (0,dist,500) );
}

door_logic()
{
	flag_init( "open_" + self.targetname );
	self.closed = true;
	self.start_pos = self.origin;
	forward = AnglesToForward( self.org.angles );
	right = AnglesToRight( self.org.angles );

	movetime = 3;
	move_in = 0.5;
	move_out = 0.2;

	// closed
	if ( self.lights.size )
	{
		dlight_origin = ( 0, 0, 0 );
		foreach ( light in self.lights )
		{
			dlight_origin += light.origin;
		}
		dlight_origin /= self.lights.size;
		dlight_origin += ( 0, 0, -40 );
		self.dlight_origin = dlight_origin;

		foreach ( light in self.lights )
		{
			up = AnglesToUp( light.angles );
			light.fx_org = light.origin + up * 8;
		}
	}

	foreach ( light in self.lights )
	{
		light SetModel( "com_emergencylightcase" );
		fx = get_global_fx( "light_red_steady_FX_origin" );
		light.looper = PlayLoopedFX( fx, 50, light.fx_org, 2500 );
	}

	self thread play_dlight( "red" );

	self DisconnectPaths();

	buzz_sound_org = self.origin + right * 128 + forward * -64 + ( 0, 0, 32 );

	for ( ;; )
	{
		// "open_cell_door_weapons"
		flag_wait( "open_" + self.targetname );

//		Print3d( buzz_sound_org, "buzz", (1,1,0), 1, 1, 40 );
		thread play_sound_in_space( "scn_gulag_jail_door_buzzer", buzz_sound_org );
		delayThread( 1.2, ::play_sound_in_space, "scn_gulag_jail_door_unlock", self.origin );



		// opened
		foreach ( light in self.lights )
		{
			light SetModel( "com_emergencylightcase_blue" );
			fx = get_global_fx( "light_blue_steady_FX_origin" );
			light.looper Delete();
			light.looper = PlayLoopedFX( fx, 50, light.fx_org, 2500 );
		}
		self thread play_dlight( "blue" );

		wait( 2 );

		if ( self.targetname == "cell_door_weapons" )
		{
			self PlaySound( "scn_gulag_armory_door_open" );
			// special slow open
			self MoveTo( self.start_pos + forward * 16, movetime * 0.25, move_in, 0 );

			wait( movetime * 0.25 );
			self PlaySound( "door_bounce" );
			exploder( "door_dies" );// sparks
			delayThread( 1, ::exploder, "door_dies" );// sparks
			delayThread( 1.3, ::exploder, "door_dies" );// sparks
			delayThread( 2, ::exploder, "door_dies" );// sparks
			foreach ( light in self.lights )
			{
				light SetModel( "com_emergencylightcase_blue_off" );
				light.looper Delete();
			}
			self.looper Delete();

			wait( 1 );

			foreach ( light in self.lights )
			{
				light thread blue_light_flickers();
			}

			delayThread( 1, ::exploder, "door_dies" );// sparks
			delayThread( 1.3, ::exploder, "door_dies" );// sparks
			delayThread( 2, ::exploder, "door_dies" );// sparks


			level waittill( "force_door_open" );

			foreach ( light in self.lights )
			{
				light notify( "stop_flickering" );
				light SetModel( "com_emergencylightcase_blue" );
				if ( IsDefined( light.looper ) )
					light.looper Delete();

				fx = get_global_fx( "light_blue_steady_FX_origin" );
				light.looper = PlayLoopedFX( fx, 50, light.fx_org, 2500 );
			}

			self PlaySound( "scn_gulag_armory_door_open2" );
			// special slow open
			self MoveTo( self.start_pos + forward * 48, movetime * 0.75, move_in, 0 );
			wait( movetime * 0.75 );
		}
		else
		{
			self PlaySound( "scn_gulag_jail_door_open" );
			// normal
			self MoveTo( self.start_pos + forward * 64, movetime, move_in, move_out );
			wait( movetime );
		}

		self ConnectPaths();
		level notify( "opened_" + self.targetname );
		level notify( "cell_door_opens" );

		flag_waitopen( "open_" + self.targetname );

		// closed
		foreach ( light in self.lights )
		{
			light SetModel( "com_emergencylightcase" );
			fx = get_global_fx( "light_red_steady_FX_origin" );
			light.looper Delete();
			light.looper = PlayLoopedFX( fx, 50, light.fx_org, 2500 );
		}

		self thread play_dlight( "red" );

		wait( 0.5 );

		self MoveTo( self.start_pos, movetime, move_in, move_out );
		wait( movetime );
		self DisconnectPaths();
	}
}


blue_flicker_model_for_time( time )
{

	time = 0.5;
	frames = time * 20;
	for ( i = 0; i < frames; i++ )
	{
		self SetModel( "com_emergencylightcase_blue" );
		wait( 0.055 );
		self SetModel( "com_emergencylightcase_blue_off" );
		wait( 0.095 );
		if ( RandomInt( 100 ) > 75 )
			exploder( "door_dies" );
	}
}

blue_light_flickers()
{
	self endon( "stop_flickering" );
	fx = getfx( "dlight_blue_flicker" );

	for ( ;; )
	{
		self.looper = PlayLoopedFX( fx, 150, self.fx_org, 2500 );
		blue_flicker_model_for_time( 0.5 );
		self.looper Delete();
		wait( 1.3 );


		self.looper = PlayLoopedFX( fx, 150, self.fx_org, 2500 );
		blue_flicker_model_for_time( 0.35 );
		self.looper Delete();
		wait( 0.7 );


		self.looper = PlayLoopedFX( fx, 150, self.fx_org, 2500 );
		blue_flicker_model_for_time( 1.1 );
		self.looper Delete();
		wait( 1.4 );

		self.looper = PlayLoopedFX( fx, 150, self.fx_org, 2500 );
		blue_flicker_model_for_time( 0.5 );
		self.looper Delete();
		wait( 0.9 );
	}

}

friendly_cellblock_respawner()
{
	level endon( "stop_cellblock_respawn" );
	// respawns buddies
	level.cellblock_spawner = GetEnt( "friendly_cellblock_spawner", "targetname" );

	for ( ;; )
	{
		flag_wait( "cellblock_respawn" );

		for ( ;; )
		{
			wait( 1 );
			if ( !flag( "cellblock_respawn" ) )
				break;

			if ( GetAIArray( "allies" ).size >= 7 )
				continue;

			spawner = level.cellblock_spawner;
			spawner.count = 1;
			spawner spawn_ai();

			// makes them go to the current friendlygoal
			//[[ level.friendly_respawn_start_func ]]();
		}
	}
}

fake_celldoor( name )
{
	door_ents = GetEntArray( name, "targetname" );

	door = undefined;
	org = undefined;
	models = [];
	foreach ( ent in door_ents )
	{
		if ( ent.code_classname == "script_brushmodel" )
		{
			door = ent;
		}
		else
		if ( ent.code_classname == "script_model" )
		{
			models[ models.size ] = ent;
		}
		else
		if ( ent.code_classname == "script_origin" )
		{
			org = ent;
		}
	}

	AssertEx( IsDefined( door ), "Found no script_brushmodel for " + name );

	foreach ( model in models )
	{
		model LinkTo( door );
	}

	door LinkTo( org );
	org RotateYaw( -115, 5, 0, 3 );
}

get_cellblock_friendlies()
{
	ai = GetAIArray( "allies" );

	guys = [];
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.stays_in_control_room ) )
			continue;

		guys[ guys.size ] = guy;
	}

	return guys;
}

friendlies_ignore_grenades_for_awhile ()
{
	ai = get_cellblock_friendlies();
//	array_thread( ai, ::go_to_rappel_room );

	foreach ( guy in ai )
	{
		guy.grenadeawareness = 0;
	}

	wait( 3 );
	ai = get_cellblock_friendlies();
	foreach ( guy in ai )
	{
		guy.grenadeawareness = 0.9;
	}
}

go_to_rappel_room()
{
	/*		
	if ( !isdefined( self.magic_bullet_shield ) )
	{
		self.health = 1;
		self.threatbias = 500;
		self.attackeraccuracy = 5;
	}
	*/

	rappel_room_node = GetNode( "rappel_room_node", "targetname" );
	self ClearGoalVolume();
	self SetGoalNode( rappel_room_node );
	self.goalradius = rappel_room_node.radius;
	self.fixednode = false;
}


kill_all_axis()
{
	ai = GetAIArray( "axis" );
	if ( ai.size )
	{
		foreach ( guy in ai )
		{
			time = RandomFloat( 4 );
			guy delayCall( time, ::Kill );
		}
		wait( 4 );
	}
}

hero_rappels()
{
	ent = GetEnt( "rappel_ent_int", "targetname" );

	//guy thread animscripts\riotshield\riotshield::riotshield_turn_into_regular_ai();
	self.fixednode = true;

	clear_rioter();

	ent anim_generic_reach( self, "rappel_start" );
	self.rappelling = true;
	self delayThread( 10.6, ::anim_stopanimscripted );
	self delayThread( 10.6, ::clear_rappelling );
	ent thread anim_single_solo( level.cellblock_rope_ai, "rappel_start" );
	ent anim_generic( self, "rappel_start" );

//	ent thread anim_generic( self, "rappel_end" );
//	ent thread anim_single_solo( level.cellblock_rope_ai, "rappel_end" );

	self set_force_color( "green" );
	self enable_ai_color();
	self.rappelling = undefined;
}

cellblock_rappel_player()
{
	ent = SpawnStruct();
	ent.rope_obj = level.cellblock_rope_player_obj;
	ent.rope = level.cellblock_rope_player;
	ent.flag_name = "player_rappels";
	ent.rope_obj Show();
	ent.rope_ent = GetEnt( "rappel_player_ent", "targetname" );
	ent.scene = "rappel_start";
	ent.unlink_time = 5.35;
	player_rappels( ent );
	flag_set( "cellblock_player_starts_rappel" );
	
	wait( 1.8 );
	// Captain MacTavish, last floor clear. We'll link up with you at the bottom.		
	radio_dialogue( "gulag_tf1_captainlastfloor" );	

}

player_rappels( ent )
{
	trigger_ent = GetEnt( "rappel_trigger", "script_noteworthy" );

	// Press and hold^3 &&1 ^7to rappel.
	trigger_ent SetHintString( &"GULAG_HOLD_1_TO_RAPPEL" );
	flag_wait( ent.flag_name );
	trigger_ent Delete();

	if ( level.player GetStance() != "stand" )
	{
		level.player SetStance( "stand" );
		wait( 0.4 );
	}
	if ( IsDefined( ent.rope_obj ) )
		ent.rope_obj Delete();

	// player rappels
	player_rig = spawn_anim_model( "player_rappel", ent.rope_ent.origin );
//	player_rig Hide();
	scene = [];
	scene[ 0 ] = ent.rope;
	scene[ 1 ] = player_rig;

	level.raptime = GetTime();
	ent.rope_ent thread anim_single( scene, ent.scene );
	level.player delayCall( ent.unlink_time, ::Unlink );
	level.player delayCall( ent.unlink_time - 0.35, ::EnableWeapons );
	level.player delayCall( ent.unlink_time - 0.35, ::allowcrouch, true );
	level.player delayCall( ent.unlink_time - 0.35, ::allowprone, true );

	player_rig delayCall( ent.unlink_time, ::Delete );


//	if ( level.player GetCurrentWeapon() == "riotshield" )
//		level.player delayThread( ent.unlink_time - 0.30, ::switch_to_other_primary );
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player DisableWeapons();
	//level.player TakeWeapon( "riotshield" );
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.5, 0.2, 0.2 );
}

switch_to_other_primary()
{
	weapons = self GetWeaponsListPrimaries();
	foreach ( weapon in weapons )
	{
		self SwitchToWeapon( weapon );
		break;
	}
}

spawn_rappel_rope()
{
	ent = GetEnt( "rappel_ent_int", "targetname" );
	level.cellblock_rope_ai = spawn_anim_model( "ai_rope" );
	rope = [];
	rope[ 0 ] = level.cellblock_rope_ai;
	ent anim_first_frame( rope, "rappel_start" );


	ent = GetEnt( "rappel_player_ent", "targetname" );

	level.cellblock_rope_player = spawn_anim_model( "player_rope" );
	level.cellblock_rope_player_obj = spawn_anim_model( "player_rope_obj" );
	level.cellblock_rope_player_obj Hide();

	rope = [];
	rope[ 0 ] = level.cellblock_rope_player;
	rope[ 1 ] = level.cellblock_rope_player_obj;

	ent anim_first_frame( rope, "rappel_start" );
}

gulag_player_loadout()
{
	if ( is_specialop() )
		return;

	level.player GiveWeapon( "m14_scoped_arctic" );
	level.player GiveWeapon( "fraggrenade" );
	level.player SetOffhandSecondaryClass( "flash" );
	level.player GiveWeapon( "flash_grenade" );
	level.player SetViewModel( "ch_viewhands_gk_ar15" );


	if ( is_default_start() || level.start_point == "approach" )
	{
		level.player SwitchToWeapon( "m14_scoped_arctic" );
		return;
	}

	if ( level.start_point == "perimeter" )
	{
		level.player GiveWeapon( "m4m203_reflex_arctic" );
		level.player SwitchToWeapon( "m4m203_reflex_arctic" );
		return;
	}

	level.player SetActionSlot( 1, "nightvision" );
	level.player GiveWeapon( "claymore" );
	level.player SetActionSlot( 4, "weapon", "claymore" );
	level.player GiveMaxAmmo( "claymore" );

	level.player GiveWeapon( "m4m203_reflex_arctic" );
	level.player SwitchToWeapon( "m4m203_reflex_arctic" );
}

bhd_set_off_nearby_exploders( exploders, org )
{
	//Print3d( org, "x", (1,0,0), 1, 1.5, 60 );

	ents = get_array_of_closest( org, exploders, undefined, 3, 750 );
	foreach ( ent in ents )
	{
		ent thread activate_individual_exploder();
		wait( 0.05 );
	}
}

overlook_spawner_think()
{
	// no endon death cause we return if dead
	thread overlook_gets_more_threat_for_bhd();
	// if the player shoots one of these guys, then start the heli automatically

	self.IgnoreRandomBulletDamage = true;
	self.suppressionwait = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );

		if ( !isalive( attacker ) )
			continue;

		if ( attacker == level.player )
		{
			flag_set( "force_bhd_start" );
		}

		if ( !isalive( self ) )
			return;
	}

//	wait( 5 );
}

overlook_gets_more_threat_for_bhd()
{
	self endon( "death" );
	flag_wait( "overlook_attack" );
	self.threatbias = 1500;
}

bhd_heli_attack_setup()
{
	flag_wait( "force_bhd_start" );
	thread bhd_dialogue_and_m203_hint();
	wait( 3 );
	spawn_vehicles_from_targetname_and_drive( "bhd_spawner" );
}


bhd_heli_rotates_left_and_right()
{
	if ( flag( "overlook_cleared" ) )
		return;

	self SetYawSpeed( 80, 60, 60, 0 );
	self SetTurningAbility( 1 );
	ent = getstruct( "bhd_heli_rotate_node", "script_noteworthy" );

	yaw = ent.angles[ 1 ];

	wait( 3 );
	exploders = get_exploder_array( "110" );
	foreach ( ent in exploders )
	{
		ent.origin = ent.v[ "origin" ];
	}

	thread bhd_heli_attacks_overlook_guys( self );

	delayThread( 6, ::kill_deathflag, "overlook_cleared", 2 );
	thread rotate_relative_to_overlook_guys( yaw );
	wait( 8 );
	flag_set( "stop_shooting_right_side" );

	self SetGoalYaw( yaw + 30 );

	ai = GetAIArray( "axis" );
	dot = 1;
	lowest_dot_guy = undefined;
	foreach ( guy in ai )
	{
		newdot = get_dot( self.origin, ( 0, yaw + 30, 0 ), guy.origin );
		if ( newdot >= dot )
			continue;
		dot = newdot;
		lowest_dot_guy = guy;
	}
	if ( IsDefined( lowest_dot_guy ) )
	{
		foreach ( turret in self.mgturret )
		{
			turret SetTargetEntity( lowest_dot_guy );
			//Line( turret.origin, lowest_dot_guy.origin, (1,0,1), 1, 1, 250 );
		}
	}

	wait( 4 );

	foreach ( turret in self.mgturret )
	{
		turret SetMode( "auto_nonai" );
	}

	thread rotate_relative_to_left_guys( yaw + 40 );
	wait( 9 );

	self.threatbias = 0;

	flag_set( "bhd_heli_flies_off" );
}

rotate_relative_to_overlook_guys( yaw )
{
	level endon( "stop_shooting_right_side" );
	if ( flag( "stop_shooting_right_side" ) )
		return;
	rotate_relative_to_yaw( yaw );
}

rotate_relative_to_left_guys( yaw )
{
	level endon( "bhd_heli_flies_off" );
	if ( flag( "bhd_heli_flies_off" ) )
		return;
	rotate_relative_to_yaw( yaw );
}

rotate_relative_to_yaw( yaw )
{
	range = 12;
	for ( ;; )
	{
		self SetGoalYaw( yaw - range );
		wait( 1.5 );
		self SetGoalYaw( yaw + range );
		wait( 1.5 );
	}
}

bhd_heli_attacks_overlook_guys( heli )
{
	structs  = getstructarray( "heli_grenade_struct", "targetname" );
	foreach ( struct in structs )
	{
		struct.time = 0;
	}

	thread bhd_physics_explosion_from_turrets();

	odd = true;
	foreach ( turret in self.mgturret )
	{
		turret thread bhd_turrets_kill_overlook_guys( heli, odd );
		odd = !odd;
	}
}

bhd_physics_explosion_from_turrets()
{
	self endon( "death" );
	for ( ;; )
	{
		level waittill( "physics_jump", origin );
		//vec = randomvector( 8 );
		vec = ( 30, -30, 160 );
		PhysicsJolt( origin, 256, 256, vec );
		wait( 1.0 );
	}
}

set_off_overlook_grenades()
{
	structs  = getstructarray( "heli_grenade_struct", "targetname" );
	fx = getfx( "grenade_wood" );

	for ( ;; )
	{
		wait( 0.05 );
		if ( flag( "stop_shooting_right_side" ) )
			break;

		if ( self IsFiringTurret() )
		{
			struct = get_highest_dot( self.origin, self.origin + self.forward, structs );

			if ( struct.time > GetTime() )
				continue;

			//dont fire this one again for 300ms
			struct.time = GetTime() + 250;
			vec = randomvector( 8 );
			z = abs( vec[ 2 ] ) * -1;
			vec = ( vec[ 0 ], vec[ 1 ], z );
			//MagicGrenadeManual( "fraggrenade", struct.origin, vec, 0.2 );
			PlayFX( fx, struct.origin );
			play_sound_in_space( "grenade_explode_wood", struct.origin );


			//PhysicsExplosionSphere( struct.origin, 350, 350, 3 );

			level notify( "physics_jump", struct.origin );
			wait( 0.25 );
		}
	}
}

bhd_turrets_kill_overlook_guys( heli, odd )
{
	self SetMode( "manual" );

	// for offset based on the way the enemies are killed, so we kill 2 out of 3 frames instead of 1 out of every 3.
	if ( odd )
		wait( 0.05 );

	targ_ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	targ_ent.script_ghettotag = true;// keep these even through world cleanse
	self StartFiring();
	exploders = get_exploder_array( "110" );
	self SetTargetEntity( targ_ent );

	self.forward = ( 0, 0, 0 );
	thread set_off_overlook_grenades();

	for ( ;; )
	{
		if ( flag( "stop_shooting_right_side" ) )
			break;

		angles = heli.angles;
		forward = AnglesToForward( heli.angles );
		self.forward = forward;
		ent = get_highest_dot( self.origin, self.origin + forward, exploders );
		targ_ent.origin = ent.origin;

		ai = level.deathflags[ "overlook_cleared" ][ "ai" ];
		foreach ( guy in ai )
		{
			if ( within_fov( self.origin, heli.angles, guy.origin, 0.98 ) )
			{
				guy Kill();
			}
		}

		bhd_set_off_nearby_exploders( exploders, ent.origin );
		wait( 0.2 );
	}

	targ_ent Delete();
	self StopFiring();
	self notify( "stop_setting_off_exploders" );
//	self SetMode( "auto_nonai" );
}

bhd_dialogue_and_m203_hint()
{

	kill_deathflag( "first_second_story_guys_dead", 4 );

	// Two-One is in position for gun run.	
	radio_dialogue( "gulag_lbp1_gunrun" );

	// Copy Two-One, lasing target on the second floor!	
	level.soap dialogue_queue( "gulag_cmt_lasingtarget" );

	// Two-One copies, got a tally on 6 tangos, inbound hot.	
	radio_dialogue( "gulag_lbp1_gotatally" );

	// wait till the player shoots these guys again
	flag_clear( "player_shot_at_m203_guys" );
	flag_wait( "player_shot_at_m203_guys" );

	if ( should_break_m203_hint() )
		return;

	// Roach! Hostiles on the third floor, use your M203!	
	level.soap dialogue_queue( "gulag_cmt_usem203" );

	display_hint_timeout( "grenade_launcher", 5 );
	kill_deathflag( "upper_balcony_deathflag", 12 );
}

turret_rains_down_shells()
{
	self endon( "death" );
	fx = getfx( "minigun_shell_eject" );
	self.last_casing_impact_sound_time = 0;
	for ( ;; )
	{
		if ( self IsFiringTurret() )
		{
			// spinup
			wait( 2 );

			for ( ;; )
			{
				if ( !self IsFiringTurret() )
					break;

				PlayFXOnTag( fx, self, "tag_flash" );
				thread shell_casing_impact_sound();
				wait( 0.05 );
			}

			// spin
			wait( 0.75 );
			continue;
		}

		wait( 0.05 );
	}
}

shell_casing_impact_sound()
{
	// dont play the sound TOO often
	if ( GetTime() < self.last_casing_impact_sound_time + 2500 )
		return;

	self.last_casing_impact_sound_time = GetTime();

	// let's call this a quick trace to the ground
	org = self.origin;
	org = set_z( org, level.soap.origin[ 2 ] );

	play_sound_in_space( "scn_gulag_gattling_shells", org );
}

bhd_heli_flies_off()
{
	wait( 2 );
	flag_wait( "overlook_cleared" );

	flag_set( "overlook_cleared_with_safe_time" );
}

bhd_heli_think()
{
	array_thread( self.mgturret, ::turret_rains_down_shells );
	//self thread bhd_force_fire();
	//self ent_flag_wait( "force_fire" );
	flag_wait( "bhd_attack" );

	ai = level.deathflags[ "overlook_cleared" ][ "ai" ];
	guy = undefined;

	// get the first thing it finds in the array
	foreach ( guy in ai )
	{
		break;
	}


	foreach ( turret in self.mgturret )
	{
		turret SetMode( "manual" );
		if ( IsAlive( guy ) )
		{
			turret SetTargetEntity( guy );
		}
	}


	wait( 1.5 );

	self MakeEntitySentient( "allies" );
	self.threatbias = 1500;
	self.attackeraccuracy = 5;

	flag_wait( "overlook_heli_rotates" );
	self thread bhd_heli_rotates_left_and_right();

	flag_wait( "overlook_attack" );
	thread bhd_heli_flies_off();

	wait( 3 );
	maps\_spawner::killspawner( 0 );
	wait( 15 );

	bhd_kill_trigger = GetEnt( "bhd_kill_trigger", "targetname" );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( guy IsTouching( bhd_kill_trigger ) )
			guy Kill();
	}


	/*
	if ( 1 ) return;

	maps\_spawner::killspawner( 0 );
	exploder( 110 );
	wait( 1 );

	// failsafe
	bhd_kill_trigger = GetEnt( "bhd_kill_trigger", "targetname" );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( guy IsTouching( bhd_kill_trigger ) )
			guy Kill();
	}
	*/
}

test_bhd()
{
	activate_trigger( "bhd_scene", "targetname" );
	bhd_scene = GetEnt( "bhd_scene", "targetname" );
	bhd_scene Delete();
	activate_trigger( "bhd_spawner_trigger", "script_noteworthy" );
}

iprint( msg )
{
	//iprintlnbold( msg );
}

pow_org()
{
	return GetEnt( "find_pow_org", "targetname" ).origin;
}

control_room_org()
{
	return GetEnt( "control_room_org", "targetname" ).origin;
}

cellblock_sweep_org()
{
	return GetEnt( "cellblock_sweep_org", "targetname" ).origin;
}

breach_org()
{
	return GetEnt( "pipe_breach_org", "targetname" ).origin;
}

breach_rescue_org()
{
	return GetEnt( "breach_rescue_org", "targetname" ).origin;
}

evac_obj_org()
{
//	return (0,0,0);
	return getstruct( "false_objective", "script_noteworthy" ).origin + ( 0, 0, 180 );
}

evac_obj_org_end()
{
	return GetEnt( "evac_obj_org", "targetname" ).origin;
}

hallway_runner_spawner_think()
{
	self endon( "death" );
	self.disableexits = true;
	self.attackeraccuracy = 0;
	self.IgnoreRandomBulletDamage = true;

	wait( 1 );
	self.disableexits = false;
	add_wait( ::_wait, 8 );
	add_wait( ::waittill_msg, "damage" );
	do_wait_any();

	self.attackeraccuracy = 1;
	self.IgnoreRandomBulletDamage = false;
}

die_on_ragdoll()
{
	self endon( "death" );
	self gun_remove();
	self.a.disablePain = true;
	self.health = 5000;
	self waittillmatch( "single anim", "start_ragdoll" );
	wait( 0.1 );
	waittillframeend;
	self.a.nodeath = true;
	self Kill();
}

riot_shield_guy()
{
	self endon( "death" );
	self riotshield_sprint_on();
	wait( RandomFloatRange( 1.8, 2.2 ) );
//	self waittill( "goal" );
	self riotshield_sprint_off();
}

guy_gets_riotshield()
{
	if ( self.primaryweapon != "mp5" || self.weapon != self.primaryweapon )
	{
		// looks bad with bigger weapons
		self forceUseWeapon( "mp5", "primary" );
	}

	self.rioter = true;
	self.threatbias += level.rioter_threat;
	self animscripts\init::initWeapon( "riotshield" );
	self.secondaryweapon = "riotshield";
	self maps\_riotshield::subclass_riotshield();

	self.goalradius = 128;


	self.grenadeawareness = 0;

	friendly_riotshields = GetEntArray( "friendly_riotshield", "targetname" );
	friendly_riotshields = remove_undefined_from_array( friendly_riotshields );
	shield = getClosest( self.origin, friendly_riotshields, 64 );
	if ( !isdefined( shield ) )
		return;
	shield Delete();
}

friendly_hole_rappel()
{
	flag_init( "hole_rappel_failsafe" );// needed in case ai hits the wrong trigger
	ai_hole_rappel_triggers = GetEntArray( "ai_hole_rappel_trigger", "targetname" );
	array_thread( ai_hole_rappel_triggers, ::ai_hole_rappel_trigger_think );
	flag_wait( "hole_rappel_failsafe" );
	wait( 4 );

	ai_hole_rappel_triggers = GetEntArray( "ai_hole_rappel_trigger", "targetname" );
	if ( !ai_hole_rappel_triggers.size )
		return;
	AssertEx( ai_hole_rappel_triggers.size == 1, "Impossible size!" );

	ai = GetAIArray( "allies" );
	guy = undefined;
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.hole_rappel ) )
			continue;
		break;
	}

	if ( !isalive( guy ) )
		return;

	// force this guy to rappel
	ai_hole_rappel_triggers[ 0 ] notify( "trigger", guy );
}

ai_hole_rappel_trigger_think()
{
	guy = undefined;
	index = self.script_index;

	for ( ;; )
	{
		self waittill( "trigger", guy );
		if ( !isalive( guy ) )
			continue;
		if ( guy.team != "allies" )
			continue;

		break;
	}

	flag_set( "hole_rappel_failsafe" );
	guy.hole_rappel = true;

	self Delete();// failsafe will search for triggers that still remain

	guy endon( "death" );

	ent = GetEnt( "bathroom_rappel_" + index, "targetname" );
	ent anim_generic_reach( guy, "hole_rappel_start" + index );
	guy.rappelling = true;
	guy delayThread( 6.3, ::anim_stopanimscripted );
	guy delayThread( 6.3, ::clear_rappelling );
	level.htime[ index ] = GetTime();

	rope = level.bathroom_rope_ai[ index ];
	ent thread anim_single_solo( rope, "hole_rappel_start" );
	ent anim_generic( guy, "hole_rappel_start" + index );

	ent thread anim_single_solo( rope, "hole_rappel" );
	ent anim_generic( guy, "hole_rappel" + index );
	guy enable_ai_color();
	guy.rappelling = undefined;
}

clear_rappelling()
{
	self.rappelling = undefined;
}

bathroom_spawn_rappel_rope()
{
	level.bathroom_rope_ai = [];
	level.bathroom_rope_ai[ 1 ] = spawn_anim_model( "ai_rope1" );
	level.bathroom_rope_ai[ 2 ] = spawn_anim_model( "ai_rope2" );
	/*
	level.bathroom_rope_player = spawn_anim_model( "player_rope" );
	level.bathroom_rope_player_obj = spawn_anim_model( "player_rope_obj" );
	level.bathroom_rope_player_obj Hide();
	*/

	ent = GetEnt( "bathroom_rappel_2", "targetname" );
	ent anim_first_frame_solo( level.bathroom_rope_ai2, "hole_rappel_start" );

	ent = GetEnt( "bathroom_rappel_1", "targetname" );
	ent anim_first_frame_solo( level.bathroom_rope_ai1, "hole_rappel_start" );

/*
	ent = GetEnt( "bathroom_rappel_player", "targetname" );
	player_ropes = [];
	player_ropes[ 0 ] = level.bathroom_rope_player;
	player_ropes[ 1 ] = level.bathroom_rope_player_obj;

	ent anim_first_frame( player_ropes, "hole_rappel_start" );
	*/
}

bathroom_rappel_player()
{
	ent = SpawnStruct();
	ent.rope = level.bathroom_rope_player;
	ent.rope_obj = level.bathroom_rope_player_obj;
	ent.flag_name = "player_hole_rappel";
	ent.rope_obj Show();
	ent.rope_ent = GetEnt( "bathroom_rappel_player", "targetname" );
	ent.scene = "hole_rappel_start";
	ent.unlink_time = 1.55;
	player_rappels( ent );

	flag_set( "player_exited_bathroom" );
}

price_spawn_think()
{
	level.price = self;
	self.animname = "price";
	self.attackeraccuracy = 0;
	self.IgnoreRandomBulletDamage = true;
	self.health = 200;
	self waittill_any_timeout( 5, "death" );

	if ( !isalive( self ) )
	{
		// the pow was killed
		SetDvar( "ui_deadquote", "@GULAG_PRICE_KILLED" );
		//maps\_utility::missionFailedWrapper();
		return;
	}

	self notify( "saved" );
	self magic_bullet_shield();
}

earthquakes()
{
	level endon( "lift_off" );
	for ( ;; )
	{
		Earthquake( 0.2, 4, level.player.origin + randomvector( 1000 ), 5000 );
		wait( RandomFloatRange( 6, 8 ) );
	}
}

ending_rope()
{
	ending_start = level.start_point == "ending";

	rope = GetEnt( "hookup_rope_ent", "targetname" );
	rope.origin += ( 0, 0, 12 );
	rope Hide();
	level.ending_rope = rope;

	org = rope.origin;
	rope.origin += ( 0, 0, 600 );

	if ( !ending_start )
		flag_wait( "rope_drops_now" );

	rope Show();
	rope MoveTo( org, 1, 1, 0 );
	wait( 1.1 );
	rope MakeUsable();
	rope glow();

	trigger_ent = getEntWithFlag( "player_ropes" );
	// Press and hold^3 &&1 ^7to rappel.
	trigger_ent SetHintString( &"GULAG_HOLD_1_TO_RAPPEL" );

	escape_lift = spawn_vehicle_from_targetname( "escape_lift" );
	escape_lift_ent = spawn_tag_origin();
	escape_lift_ent LinkTo( escape_lift, "tag_origin", ( 0, 0, 0 ), ( 0, 180, 0 ) );
//	level.player PlayerLinkToBlend( escape_lift_ent, "tag_origin", 0.5, 0.2, 0.2 );

	look_ent = GetEnt( "evac_obj_org", "targetname" );

	player_view_controller = get_player_view_controller( escape_lift, "tag_origin", ( 0, 0, -16 ) );
	player_view_controller SetTargetEntity( look_ent );
	//thread liner( player_view_controller, look_ent );

	viewPercentFrac = 1.0;
	arcRight = 10;
	arcLeft = 10;
	arcTop = 10;
	arcBottom = 10;

	flag_wait( "player_ropes" );
	level.player DisableWeapons();

	escape_lift StartPath();
	level.player PlayerLinkToBlend( escape_lift_ent, "tag_origin", 2, 1.5, 0 );
//	( player_view_controller, "TAG_aim", viewPercentFrac, arcRight, arcLeft, arcTop, arcBottom, true );
	//level.player SetPlayerAngles( ( 5, -180, 0 ) );


}


gulag_become_soap()
{
	AssertEx( !isdefined( level.soap ), "Too much soap!" );
	level.soap = self;
	self.animname = "soap";
	if ( !isdefined( self.magic_bullet_shield ) )
		self thread magic_bullet_shield();
	self make_hero();


}

going_in_hot()
{
	fly_in_attack_org = GetEnt( "fly_in_attack_org", "targetname" );
	foreach ( turret in self.mgturret )
	{
		turret SetMode( "manual" );
		turret SetTargetEntity( fly_in_attack_org );
		//turret StartFiring();
	}

	flag_wait( "going_in_hot" );
	wait( 4.85 );

	//mgon();

	foreach ( turret in self.mgturret )
	{
		turret SetTargetEntity( fly_in_attack_org );
		turret SetMode( "manual" );
		turret StartFiring();
	}

	wait( 4.8 );
	mgoff();
	foreach ( turret in self.mgturret )
	{
		turret StopFiring();
	}

}


handle_gulag_world_fx()
{
	volnames = [];

	volnames[ volnames.size ] = "gulag_exterior_fx_vol";
	volnames[ volnames.size ] = "gulag_interior_fx_vol";

	volumes = [];
	fx_collection = [];

	// this one is first
	endlog_volume = GetEnt( "gulag_endlog_destructibles", "script_noteworthy" );
	endlog_volume_name = endlog_volume.targetname;
	volumes[ endlog_volume_name ] = endlog_volume;
	fx_collection[ endlog_volume_name ] = [];

	foreach ( volname in volnames )
	{
		volumes[ volname ] = GetEnt( volname, "targetname" );
		fx_collection[ volname ] = [];
	}

	fx_collection[ "outside" ] = [];

	dummy = Spawn( "script_origin", ( 0, 0, 0 ) );

	volname_list = [];
	volname_list[ 0 ] = endlog_volume_name;
	foreach ( volname in volnames )
	{
		if ( volname == volname_list[ 0 ] )
			continue;

		volname_list[ volname_list.size ] = volname;
	}


	foreach ( entFx in level.createfxent )
	{
		touched = false;
		dummy.origin = EntFx.v[ "origin" ];

		for ( i = 0; i < volname_list.size; i++ )
		{
			name = volname_list[ i ];
			volume = volumes[ name ];

			if ( dummy IsTouching( volume ) )
			{
				fx_collection[ volume.targetname ][ fx_collection[ volume.targetname ].size ] = entFx;
				touched = true;
				break;
			}
		}

		if ( !touched )
			fx_collection[ "outside" ][ fx_collection[ "outside" ].size ] = entFx;
	}
	dummy Delete();

	foreach ( volume in volumes )
	{
		if ( volume != endlog_volume )
			volume Delete();
	}

	wait( 0.05 );
/*	
	foreach ( index, collection in fx_collection )
	{
		foreach ( fx in collection )
		{
			Print3d( fx.v["origin"], index, (1,1,1), 1, 1, 30 );
		}
	}
*/

	thread handle_exterior_fx( fx_collection[ "gulag_exterior_fx_vol" ], fx_collection[ "outside" ] );
	thread handle_interior_fx( fx_collection[ "gulag_interior_fx_vol" ] );
	thread handle_endlog_fx( fx_collection[ endlog_volume_name ] );

	flag_wait( "player_lands" );
	array_thread( fx_collection[ "outside" ], ::pauseEffect );


//	disable_exterior_fx
}

cleanse_the_world()
{
	if ( IsDefined( level.intel_items ) )
	{
		intel_items = GetEntArray( "intelligence_item", "targetname" );
		foreach ( trig in intel_items )
		{
			trig.script_ghettotag = 1;
			trig.item.script_ghettotag = 1;
		}
	}

	volume = GetEnt( "interior_entity_volume", "targetname" );

	entities = GetEntArray();

	ignore_classnames = [];
	ignore_classnames[ "script_model" ] = true;
	ignore_classnames[ "script_brushmodel" ] = true;
	ignore_classnames[ "choose_light" ] = true;
	ignore_classnames[ "script_vehicle_collmap" ] = true;
	ignore_classnames[ "info_volume_breachroom" ] = true;
	ignore_classnames[ "actor_ally_hero_soap_udt" ] = true;
	ignore_classnames[ "stage" ] = true;


	foreach ( ent in entities )
	{
		if ( IsAlive( ent ) )
			continue;

		// keep these
		if ( IsDefined( ent.script_ghettotag ) )
			continue;

		if ( ent.origin[ 2 ] < 1850 )
			continue;

		if ( !isdefined( ent.classname ) )
		{
			if ( !ent IsTouching( volume ) )
			{
				// looper that should be off anyway
				ent Delete();
			}

			continue;
		}

		if ( IsDefined( ignore_classnames[ ent.classname ] ) )
			continue;

		if ( IsDefined( ignore_classnames[ ent.code_classname ] ) )
			continue;

		if ( ent needs_ent_testing() )
		{
			// triggers must have their center in the vol to survive
			org = Spawn( "script_origin", ent.origin );
			if ( !org IsTouching( volume ) )
			{
				ent Delete();
			}
			org Delete();

			continue;
		}

		if ( !ent IsTouching( volume ) )
			ent Delete();
	}

	// update bcs array
	locs = [];
	foreach ( loc in anim.bcs_locations )
	{
		if ( !isdefined( loc ) )
			continue;
		locs[ locs.size ] = loc;
	}
	anim.bcs_locations = locs;
}

needs_ent_testing()
{
	if ( IsSubStr( self.code_classname, "trigger" ) )
		return true;
	return self.code_classname == "info_volume";
}

handle_exterior_fx( array, outside_array )
{
	first = true;
	for ( ;; )
	{
		flag_wait( "disable_exterior_fx" );

		if ( first )
		{
			first = false;
			foreach ( fx in outside_array )
			{
				// stop the clouds forever
				fx pauseEffect();
			}

			outside_array = [];


			// cleanse the outside world of non visual entities
			cleanse_the_world();

		}


		EnableForcedNoSunShadows();

		count = 0;
		foreach ( fx in array )
		{
			fx pauseEffect();
			count++;
			if ( count > 5 )
			{
				count = 0;
				wait( 0.05 );
			}
		}

		flag_waitopen( "disable_exterior_fx" );

		DisableForcedSunShadows();

		count = 0;
		foreach ( fx in array )
		{
			fx restartEffect();
			count++;
			if ( count > 5 )
			{
				count = 0;
				wait( 0.05 );
			}
		}
	}
}

handle_interior_fx( array )
{
	for ( ;; )
	{
		count = 0;
		foreach ( fx in array )
		{
			fx pauseEffect();
			count++;
			if ( count > 20 )
			{
				count = 0;
				wait( 0.05 );
			}
		}

		flag_wait( "enable_interior_fx" );

		count = 0;
		foreach ( fx in array )
		{
			fx restartEffect();
			count++;
			if ( count > 20 )
			{
				count = 0;
				wait( 0.05 );
			}
		}

		flag_waitopen( "enable_interior_fx" );
	}
}

handle_endlog_fx( array )
{
	for ( ;; )
	{
		count = 0;
		foreach ( fx in array )
		{
			fx pauseEffect();
			count++;
			if ( count > 20 )
			{
				count = 0;
				wait( 0.05 );
			}
		}

		flag_wait( "enable_endlog_fx" );

		count = 0;
		foreach ( fx in array )
		{
			fx restartEffect();
			count++;
			if ( count > 20 )
			{
				count = 0;
				wait( 0.05 );
			}
		}

		flag_waitopen( "enable_endlog_fx" );
	}
}

dont_use_the_door()
{
	level endon( "player_enters_bathroom" );
	level endon( "breaching" );

	for ( ;; )
	{
		flag_wait( "player_tries_door_that_cant_open" );

		// Roach - not the door! Plant the breaching charge on the wall over here!	
		level.soap dialogue_queue( "gulag_cmt_hurryup" );

		wait( 6 );

		flag_wait( "player_tries_door_that_cant_open" );

		// Roach - forget that door! Plant the breaching charge on the wall, we're taking a shortcut!	
		level.soap dialogue_queue( "gulag_cmt_forgetthatdoor" );

		wait( 6 );
	}
}


wait_until_player_breaches_bathroom()
{
	level endon( "breaching" );
	if ( flag( "player_enters_bathroom" ) )
		return;
	level endon( "player_enters_bathroom" );

	flag_wait( "tunnel_guys_die" );

	thread dont_use_the_door();

	for ( ;; )
	{
		// Roach - plant the breaching charge on the wall!	
		level.soap dialogue_queue( "gulag_cmt_plantbreach" );

		wait( 20 );
	}
}

cellblock_spawn_lots_of_grenades()
{
//	armory_grenade_spawners = getstructarray( "armory_grenade_spawner", "targetname" );
//	array_thread( armory_grenade_spawners, ::armory_grenade_think );
	ai = GetAIArray( "axis" );
	array_thread( ai, ::throw_crazy_grenades );
}

throw_crazy_grenades()
{
	self endon( "death" );
	self.grenadeweapon = "armory_grenade";
	for ( ;; )
	{
		anim.grenadeTimers[ "AI_armory_grenade" ] = 0;
		level.player.grenadeTimers[ "armory_grenade" ] = 0;
		self.grenadeammo = 5;
		//anim.throwGrenadeAtPlayerASAP = true;
		self ThrowGrenadeAtPlayerASAP();
		wait( 0.05 );
	}
}

armory_grenade_think()
{
	if ( RandomInt( 100 ) > 60 )
		return;
	wait( RandomFloat( 3 ) );

	targ = getstruct( self.target, "targetname" );
	timer = RandomFloatRange( 11.5, 13.5 );
	MagicGrenade( "fraggrenade", self.origin, targ.origin, timer );
}

wait_while_enemy_near_player()
{
	if ( flag( "player_nears_cell_door1" ) )
		return;
	level endon( "player_nears_cell_door1" );

	for ( ;; )
	{
		ai = GetAIArray( "axis" );
		found_ai = false;
		foreach ( guy in ai )
		{
			if ( Distance( guy.origin, level.player.origin ) > 600 )
				continue;
			found_ai = true;
			break;
		}

		if ( !found_ai )
			return;

		wait( 1 );
	}
}

close_fighter_think()
{
	self SetEngagementMinDist( 0, 0 );
	self SetEngagementMaxDist( 400, 800 );

}

heli_strike()
{
	flag_wait( "heli_strike" );
	activate_trigger_with_targetname( "heli_strike_badguy_trigger" );
	heli = spawn_vehicle_from_targetname_and_drive( "heli_strike_heli" );
	foreach ( turret in heli.mgturret )
	{
		turret StartFiring();
	}

	wait( 2.6 );
	exploder( 110 );
}

die_soon()
{
	self endon( "death" );
	wait( RandomFloat( 3 ) );
	self.diequietly = true;
	self Kill();
}

use_choke_points()
{
	self.useChokePoints = true;
}

armory_laser_ambush()
{
	self endon( "death" );
	//enable_dontevershoot();

	level.armory_laser_index += 0.35;
	if ( level.armory_laser_index > 1.5 )
		level.armory_laser_index = 1.5;
	wait( level.armory_laser_index );
	thread enable_lasers();// maps\_spawner::ai_lasers();
	wait( RandomFloatRange( 2, 2.5 ) );
	//disable_dontevershoot();
}

enable_lasers()
{
	if ( self.health <= 1 )// dying soon
		return;

	self.combatMode = "no_cover";
	self.has_no_ir = undefined;
	self.custom_laser_function = ::updateLaserStatus_forced;
	updateLaserStatus_forced();
}

disable_lasers()
{
	if ( self.health <= 1 )// dying soon
		return;

	self.combatMode = "cover";
	self.has_no_ir = true;
	self.custom_laser_function = undefined;
	self LaserForceOff();
}

updateLaserStatus_forced()
{
	// we have no weapon so there's no laser to turn off or on
	if ( self.a.weaponPos[ "right" ] == "none" )
		return;

	if ( animscripts\shared::canUseLaser() )
		self LaserForceOn();
	else
		self LaserForceOff();
}



gulag_cellblock_smoke()
{
	cellblock_smoke_grenade_orgs = GetEntArray( "cellblock_smoke_grenade_org", "targetname" );
	foreach ( ent in cellblock_smoke_grenade_orgs )
	{
		MagicGrenadeManual( "smoke_grenade_american", ent.origin, ent.origin + ( 0, 0, 20 ), 0 );
	}
}

flee_armory_think()
{
	self endon( "death" );
	flag_wait( "open_cell_door_weapons" );
	armory_flee_node = GetNode( "armory_flee_node", "targetname" );
	self SetGoalNode( armory_flee_node );
	self.goalradius = armory_flee_node.radius;
}

ambush_behavior()
{
	// drone?
	if ( !issentient( self ) )
		return;

	if ( self.subclass == "riotshield" )
		return;

	self.combatMode = "ambush";
}

ending_flee_spawner_think()
{
	level.ending_flee_guys++;
	if ( level.ending_flee_max < level.ending_flee_guys )
		level.ending_flee_max = level.ending_flee_guys;

	thread ending_flee_behavior();
	self waittill( "death" );
	level.ending_flee_guys--;
	level notify( "ending_flee_death" );
}

ending_flee_behavior()
{
	self endon( "death" );
	level waittill( "ending_flee_death" );
	waittillframeend;// in case multiple die during the frame

	flee_chance = 1 - level.ending_flee_guys / level.ending_flee_max;
	flee_chance += 0.2;

	if ( RandomFloat( 1 ) > flee_chance )
		return;

	ending_flee_node = GetNode( "ending_flee_node", "targetname" );

	self SetGoalNode( ending_flee_node );
	self.goalradius = ending_flee_node.radius;
}

nodes_are_periodically_bad()
{
	if ( flag( "nvg_leave_cellarea" ) )
		return;
	level endon( "nvg_leave_cellarea" );

	if ( flag( "checking_to_sweep_cells" ) )
		return;
	level endon( "checking_to_sweep_cells" );

	wait( 5 );

	for ( ;; )
	{
		timer = RandomFloatRange( 3, 7 );
		wait( timer );
		BadPlace_Cylinder( "", 2, self.origin, 16, 64, "axis" );
		//BadPlace_Cylinder( name, duration, origin, radius, height, team, team... );

	}
}

bathroom_balcony_spawner()
{
	self.team = "team3";
	self SetThreatBiasGroup( "team3" );
}

bathroom_periodic_autosave()
{
	if ( flag( "player_exited_bathroom" ) )
		return;
	level endon( "player_exited_bathroom" );

	if ( flag( "bathroom_room2_enemies_dead" ) )
		return;
	level endon( "bathroom_room2_enemies_dead" );

	for ( ;; )
	{
		wait( 45 );
		autosave_by_name( "bathroom_autosave" );
	}
}

riot_escort_spawner()
{
	self endon( "death" );
	waittillframeend;// want to be sure the guy we're supposed to escort could have spawned
	self waittill( "goal" );
	ents = GetEntArray( self.script_linkto, "script_linkname" );
	escort = undefined;
	foreach ( ent in ents )
	{
		if ( !isalive( ent ) )
			continue;

		escort = ent;
		break;
	}

	if ( !isalive( escort ) )
		return;

	self.goalradius = 128;

	for ( ;; )
	{
		if ( !isalive( escort ) )
			break;

		self SetGoalPos( escort.origin );
		wait( 1 );
	}

	AssertEx( IsDefined( self GetGoalVolume() ), "Riot escort has no goalvolume" );
	self SetGoalVolumeAuto( self GetGoalVolume() );
}

bathroom_second_wave()
{
	if ( flag( "bathroom_second_wave_trigger" ) )
		return;

	flag_set( "bathroom_second_wave_trigger" );

	delay = 8;

	delayThread( delay, ::activate_trigger_with_targetname, "bathroom_balcony_room2_trigger" );
	activate_trigger_with_targetname( "bathroom_second_wave_trigger" );
}

debug_center( ent )
{
	for ( ;; )
	{
		//line( level.player.origin, ent.origin );
		wait( 0.05 );
	}
}

gulag_center_shifts_as_we_move_in()
{
	level endon( "stop_moving_gulag_center" );
	waits = [];

	//0 heli swerves out of the way of SAM site.
	array = [];
	array[ "time" ] = 2;
	array[ "in" ] = 0.2;
	array[ "out" ] = 0.2;
	array[ "delay" ] = 7;
	waits[ waits.size ] = array;

	//1 strafe the SAM as we climb above gulag
	array = [];
	array[ "pre_delay" ] = 4;
	array[ "time" ] = 11;
	array[ "in" ] = 0.2;
	array[ "out" ] = 0.2;
	waits[ waits.size ] = array;

	//2 As we reach the edge of the parapat, swivel the target to the center
	array = [];
	array[ "flag" ] = "heli_rotates_to_face_center";
	array[ "time" ] = 4.8;
	array[ "in" ] = 2;
	array[ "out" ] = 2;
	waits[ waits.size ] = array;

	//3 As we go to the target, do a bit of a rollercoaster tilt
	array = [];
//	array[ "pre_delay" ] = 4.7;
	array[ "flag" ] = "heli_roller_coaster";
	array[ "time" ] = 1.8;
	array[ "in" ] = array[ "time" ] - 0.5;
	array[ "out" ] = 0.5;
	array[ "delay" ] = array[ "time" ];
	waits[ waits.size ] = array;

	//4 the view shifts to the 3 final SAMs we need to take out.
	array = [];
	array[ "time" ] = 2.6;
	array[ "in" ] = array[ "time" ] * 0.5;
	array[ "out" ] = array[ "time" ] * 0.5;
	array[ "delay" ] = array[ "time" ];
	waits[ waits.size ] = array;

	//5 a little extra view shift to the left
	array = [];
	array[ "time" ] = 1.5;
	array[ "in" ] = array[ "time" ] * 0.5;
	array[ "out" ] = array[ "time" ] * 0.5;
	array[ "delay" ] = array[ "time" ];
	waits[ waits.size ] = array;

	//6 
	array = [];
	array[ "pre_delay" ] = 3;
	array[ "flag" ] = "slamraam_killed_0";
	array[ "time" ] = 3;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	waits[ waits.size ] = array;

	//7
	array = [];
	array[ "flag" ] = "slamraam_killed_1";
	array[ "time" ] = 3;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	waits[ waits.size ] = array;

	//8 // out to sea
	array = [];
	array[ "flag" ] = "slamraam_killed_2";
	array[ "time" ] = 3;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	waits[ waits.size ] = array;

	/*
	//9 heli spins out of control
	array = [];
	array[ "flag" ] = "player_heli_backs_up";
	array[ "time" ] = 1.8;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	array[ "delay" ] = array[ "time" ];
	waits[ waits.size ] = array;

	//10 heli spins out of control
	array = [];
	array[ "time" ] = 1.8;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	array[ "delay" ] = array[ "time" ];
	waits[ waits.size ] = array;
	
	//11 back to above center
	array = [];
//	array[ "pre_delay" ] = 5;
	array[ "time" ] = 4;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	array[ "delay" ] = array[ "time" ] + 2;
	waits[ waits.size ] = array;
	
	//12 to center
	array = [];
	array[ "time" ] = 4;
	array[ "in" ] = array[ "time" ] * 0.25;
	array[ "out" ] = array[ "time" ] * 0.25;
	array[ "delay" ] = array[ "time" ];
	waits[ waits.size ] = array;
	*/


	flag_wait( "slamraam_gets_players_attention" );

	center = GetEnt( "gulag_center", "targetname" );
	ent = center;

	//thread debug_center( center );

	// for starts
	if ( !isdefined( level.player_view_controller ) )
		return;

	level.player_view_controller ClearTargetEntity();
	level.player_view_controller SetTargetEntity( center );

	level.times = [];
	index = 0;

	if ( level.start_point == "perimeter" )
	{
		waits[ 1 ][ "time" ] = 1;
		next_ent = GetEnt( center.target, "targetname" );
		ent = next_ent;
		center.origin = ent.origin;
		index = 1;
	}

	for ( ;; )
	{
		level.times[ index ] = GetTime();
		next_ent = GetEnt( ent.target, "targetname" );

		array = waits[ index ];

		if ( IsDefined( array[ "flag" ] ) )
		{
			flag_wait( array[ "flag" ] );
		}
		if ( IsDefined( array[ "pre_delay" ] ) )
		{
			wait( array[ "pre_delay" ] );
		}

		center MoveTo( next_ent.origin, array[ "time" ], array[ "in" ], array[ "out" ] );
		/#
		center thread ent_debug_print( index );
		#/
		if ( IsDefined( array[ "delay" ] ) )
			wait( array[ "delay" ] );


		ent = next_ent;
		index++;
		if ( index >= waits.size )
			break;
		if ( !isdefined( ent.target ) )
			break;
	}
}

ent_debug_print( index )
{
	self notify( "new_debug_print" );
	self endon( "new_debug_print" );
	for ( ;; )
	{
		//Print3d( self.origin, index, (0,1,1), 1, 6 );
		wait( 0.05 );
	}
}

second_tower_stabilize_dialogue()
{
	if ( flag( "second_tower_clear" ) )
		return;
	level endon( "second_tower_clear" );

	wait( 2.5 );
	// Stabilize.	
	radio_dialogue( "gulag_rpt_stabilize2" );

	// Ready.	
	radio_dialogue( "gulag_lbp1_ready" );

	// On target.	
	radio_dialogue( "gulag_wrm_ontarget" );
}

spawn_perimeter_tarp_guys()
{
	level.perimeter_tarp_guys = [];
	perimeter_tarp_spawners = GetEntArray( "perimeter_tarp_spawner", "targetname" );
	array_spawn_function( perimeter_tarp_spawners, ::perimeter_tarp_spawner_think );
	array_thread( perimeter_tarp_spawners, ::spawn_ai );
}

perimeter_tarp_spawner_think()
{
	level.perimeter_tarp_guys[ level.perimeter_tarp_guys.size ] = self;
}


should_break_m203_hint( nothing )
{
	player = get_player_from_self();
	Assert( IsPlayer( player ) );

	// am I using my m203 weapon?
	weapon = player GetCurrentWeapon();
	prefix = GetSubStr( weapon, 0, 4 );
	if ( prefix == "m203" )
		return true;

	// do I have any m203 ammo to switch to?
	heldweapons = player GetWeaponsListAll();
	foreach ( weapon in heldweapons )
	{
		ammo = player GetWeaponAmmoClip( weapon );
		if ( !issubstr( weapon, "m203" ) )
			continue;
		if ( ammo > 0 )
			return false;
	}

	return true;
}

prepare_perimeter_slamraam_attack()
{
	// spawn the perimeter AI and start up the tarp stuff, and spawn the friendly helicopters that fly by

	flag_wait( "new_friendly_helis_spawn" );
	//wait( 1 );
	level.slamraam_missile = "slamraam_missile";
	thread perimeter_slamraams_defend();
	delayThread( 7, ::spawn_perimeter_tarp_guys );
	wait( 3.70 );

	spawners = GetEntArray( "intro_heli_1", "targetname" );
	orgs = getstructarray( "heli_restart_path", "script_noteworthy" );

	foreach ( spawner in spawners )
	{
		old_origin = spawner.origin;
		foreach ( org in orgs )
		{
			if ( org.script_parameters != spawner.script_parameters )
				continue;

			// move the helis to the origins
			remap_targets( spawner.target, org.targetname );
			spawner.target = org.targetname;
			spawner.origin = org.origin;
			break;
		}

		AssertEx( old_origin != spawner.origin, "Spawner didn't move!" );
	}

	spawners = GetEntArray( "intro_heli_1", "targetname" );
	thread spawn_friendly_helis( spawners );
}

perimeter_slamraams_defend()
{
	perimeter_slamraams = GetEntArray( "perimeter_slamraam", "script_noteworthy" );
	slamraams = array_index_by_parameters( perimeter_slamraams );

	base = 20;
	slamraams[ "0" ] thread slamraam_gets_pulled_by_nearby_AI( base );
	slamraams[ "1" ] thread slamraam_gets_pulled_by_nearby_AI( base + 5 );
	slamraams[ "2" ] thread slamraam_gets_pulled_by_nearby_AI( base + 7 );
}

slamraam_gets_pulled_by_nearby_AI( delay )
{
	self.tarp_needs_living_ai_to_get_pulled = true;
	self.all_missiles_model thread all_missiles_model_can_die( self );
	self.operational = true;
	wait( delay );

	// these guys only spawn once as a big group
	perimeter_guys = array_removeDead( level.perimeter_tarp_guys );
	foreach ( index, guy in perimeter_guys )
	{
		// this guy is already pulling a tarp?
		if ( IsDefined( guy.pulling_tarp ) )
			perimeter_guys[ index ] = undefined;
	}

	for ( ;; )
	{
		perimeter_guys = array_removeDead( perimeter_guys );
		if ( !perimeter_guys.size )
			return;

		guys = get_array_of_closest( self.origin, perimeter_guys, undefined, 2, 1000, 0 );
		if ( guys.size != 2 )
			return;

		foreach ( guy in guys )
		{
			guy.pulling_tarp = true;
		}
		guys[ 0 ].animname = "puller";
		guys[ 1 ].animname = "operator";

		if ( tarp_gets_pulled( self, guys ) )
		{
			if ( !self.operational )
				return;

			self thread slamraam_attacks( 1.2, 0.5 );
			break;
		}
		wait( 1 );
	}
}

all_missiles_model_can_die( slamraam )
{
	self SetCanDamage( true );
	self.health = 250;
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( IsAlive( attacker ) && IsPlayer( attacker ) )
		{
			if ( self.health <= 0 )
			{
				// slamraam_killed_0 slamraam_killed_1 slamraam_killed_2
				flag_set( "slamraam_killed_" + slamraam.script_parameters );
				slamraam.operational = false;
				PlayFX( getfx( "slamraam_explosion" ), slamraam.origin );
				slamraam notify( "lose_operation" );
				slamraam.launcher Delete();

				slamraam thread slamraam_tarp_falls();
				self Delete();
			}
		}

		if ( !isdefined( self ) || self.health <= 0 )
			return;
	}
}

slamraam_tarp_falls()
{
	progress = 0.5;
	animation = self.tarp getanim( "pulldown" );
	if ( IsDefined( self.tarp.tarp_fell ) )
	{
		// has it already passed the progress point?
		if ( self.tarp GetAnimTime( animation ) >= progress )
			return;
	}
	else
	{
		// tarp hasn't fallen so pull it down
		self.tarp.tarp_fell = true;
		self thread anim_single_solo( self.tarp, "pulldown" );
		wait( 0.05 );
	}

	// jump it to 50% mark cause it starts late waiting for guys to give it a tug
	self.tarp SetAnimTime( animation, progress );
}

gulag_boats()
{
	later_boats = GetEntArray( "later_boats", "targetname" );
	array_call( later_boats, ::Hide );

	flag_wait( "new_friendly_helis_spawn" );

	early_boats = GetEntArray( "early_boats", "targetname" );
	array_call( early_boats, ::Delete );
	array_call( later_boats, ::Show );

	flag_wait( "pre_boats_attack" );
	boat_artillerys = getstructarray( "boat_artillery", "targetname" );
	array_thread( boat_artillerys, ::boat_artillery_think );

	delayThread( 10.5, ::flag_set, "red_goes_in_for_early_landing" );
	wait( 1.8 );
	exploder( "boat_attack1" );
	wait( 1 );
	flag_set( "player_heli_backs_up" );
	exploder( "boat_attack_tracers" );
	exploder( "boat_attack" );

	wait( 1 );

	wait( 1.15 );
	exploder( "93" );// building gets hit
	//flag_set( "heli_evades_boat_attack" );

	flag_wait( "player_lands" );
	array_call( later_boats, ::Delete );
}

boat_artillery_think()
{
	wait( RandomFloat( 1.3 ) );
	angles = VectorToAngles( level.player.origin - self.origin );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );
	fx = getfx( "0_boat_artillery" );
	PlayFX( fx, self.origin, forward, up );
}

heli_smoke_trigger_think()
{
	if ( !isdefined( level.heli_smoke_touched ) )
		level.heli_smoke_touched = [];

	for ( ;; )
	{
		self waittill( "trigger", other );
		msg = other.unique_id;
		if ( IsDefined( level.heli_smoke_touched[ msg ] ) )
			continue;
		level.heli_smoke_touched[ msg ] = true;
		other thread make_heli_smoke();
	}
}

make_heli_smoke()
{
	fx = getfx( "smoke_swirl_runner_dual" );

	PlayFXOnTag( fx, self, "tag_origin" );
	//Print3d( self.origin, "X", (1,0,0), 1, 5, 100 );
}

f15_missile_spawner_think()
{
	fx = getfx( "f15_missile" );
	PlayFXOnTag( fx, self, "tag_origin" );
	self PlaySound( "scn_gulag_f15_missile_fire3" );
}

f15_gulag_attack()
{
	flag_wait( "f15_gulag_attack" );
	f15_gulag_attacks = GetEntArray( "f15_gulag_attack", "targetname" );

	f15_missile_spawners = GetEntArray( "f15_missile_spawner", "targetname" );
	array_thread( f15_missile_spawners, ::add_spawn_function, ::f15_missile_spawner_think );

	spawn_vehicles_from_targetname_and_drive( "f15_missile_spawner" );

	plane = spawn_vehicle_from_targetname_and_drive( "f15_gulag_attack" );
	plane.animname = "f15";
	plane PlaySound( "scn_gulag_f15_overhead" );
	level.plane_buzzes_gulag = plane;
	animation = plane getanim( "landing_gear" );

	plane SetAnim( animation, 1, 0, 1 );

	level waittill( "f15_smoke" );
	//plane thread make_heli_smoke();
	level waittill( "afterburner" );
	plane thread f15_gets_afterburner();
}

f15_gets_afterburner()
{
	maps\gulag_anim::f15_afterburner( self );
}


helis_respawn_to_land()
{
	// don't need these extra guys for the actual landing
	extra_flyin_spawners = GetEntArray( "extra_flyin_spawner", "script_noteworthy" );
	array_thread( extra_flyin_spawners, ::self_delete );

	spawners = GetEntArray( "heli_respawn_spawner", "script_noteworthy" );
	orgs = getstructarray( "heli_landing_org", "script_noteworthy" );

	real_spawners = [];
	foreach ( spawner in spawners )
	{
		if ( IsAlive( spawner ) )
			continue;
		old_origin = spawner.origin;
		foreach ( org in orgs )
		{
			if ( org.script_parameters != spawner.script_parameters )
				continue;

			// move the helis to the origins
			remap_targets( spawner.target, org.targetname );
			parm = org.script_parameters;
			/*
			if ( parm == "purple" || parm == "green" )
				org.speed = 40;
			*/
			spawner.target = org.targetname;
			spawner.origin = org.origin;
			spawner.angles = org.angles;
			real_spawners[ real_spawners.size ] = spawner;
			break;
		}

		AssertEx( old_origin != spawner.origin, "Spawner didn't move!" );
	}

	thread spawn_friendly_helis( real_spawners );
}

delete_on_player_land()
{
	self endon( "death" );
	flag_wait( "player_lands" );
	wait( 4 );
	self Delete();
}

control_room_destructibles_turn_on()
{
	flag_wait( "enable_interior_fx" );
	volume = GetEnt( "gulag_cellblock_destructibles", "script_noteworthy" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();
}

damage_targ_trigger_think()
{
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( !isalive( attacker ) )
			continue;
//		if ( attacker != level.player )
//			continue;
		if ( Distance( attacker.origin, self.origin ) > 940 )
			continue;
		break;
	}

	targ = getstruct( self.target, "targetname" );
	RadiusDamage( targ.origin, 80, 5000, 5000 );
	self Delete();
}

allies_have_low_attacker_accuracy()
{
	self.attackeraccuracy = 0.25;
}

ally_gets_missed_trigger_think()
{
	AssertEx( self.spawnflags & 8, "Incorrect spawnflags, must check notplayer" );

	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		other.attackeraccuracy = 0;
		other.IgnoreRandomBulletDamage = true;
	}
}

ally_can_get_hit_trigger_think()
{
	AssertEx( self.spawnflags & 8, "Incorrect spawnflags, must check notplayer" );

	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		other.attackeraccuracy = 1;
		other.IgnoreRandomBulletDamage = false;
	}
}

ally_in_armory_think()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		other.armory = true;
	}
}


friendlies_ditch_riot_shields_trigger_think()
{
	stopped = [];

	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( IsDefined( stopped[ other.unique_id ] ) )
			continue;

		stopped[ other.unique_id ] = true;
		other.grenadeawareness = 0.9;
		other delayThread( 4, ::disable_dontevershoot );

		//other.ignoreall = false;
		//other delayThread( 3, animscripts\riotshield\riotshield::riotshield_turn_into_regular_ai );
	}
}

update_soap_spawner( spawners )
{
	soap_spawner = GetEnt( "endlog_soap_spawner", "targetname" );
	soap_spawner.origin = spawners[ 0 ].origin;
	spawners[ 0 ] Delete();
	spawners[ 0 ] = soap_spawner;
	return spawners;
}

hallway_collapse_light_think()
{
	PlayFX( getfx( "sparks_e_sound" ), self.origin );
	self SetLightIntensity( 0 );
}

hallway_collapse_dyn_think()
{
	self PhysicsLaunchClient( self.origin + ( 0, 0, 5 ), ( 0, 0, -5 ) );
}

drop_riotshield()
{
	if ( level.player GetCurrentWeapon() != "riotshield" )
		return;

	level.player TakeWeapon( "riotshield" );
	
	primaries = level.player GetWeaponsListPrimaries();
	foreach ( weapon in primaries )
	{
		level.player SwitchToWeapon( weapon );
		break;		
	}
	
	org = level.player.origin + ( 0, 0, 64 );
	Spawn( "weapon_riotshield", org );
	shields = GetEntArray( "weapon_riotshield", "code_classname" );
	wait( 0.05 );
	shield = getClosest( level.player.origin, shields );
	for ( i = 0; i < 100; i++ )
	{
		if ( !isdefined( shield ) )
			return;
		shield.angles = ( 270, 180, 0 );
		wait( 0.05 );
	}
}


soap_is_angry_about_attack()
{
	// Quarterback, what the hell was that? Call off the barrage!	
	// Sheppard, what the hell was that? Get those ships to cease fire!	
	level.soap dialogue_queue( "gulag_cmt_calloff" );

	wait( 1 );
	// We�re working on it. The Russian Navy isn't exactly cooperating right now.  Keep moving. Out.	
	// I'm working on it buddy. The Navy isn't in a talking mood right now. Standby.	
	radio_dialogue( "gulag_hqr_working" );

	// Bravo Six - they've agreed to stop firing for now. Keep going, I�ll keep you posted. Out.	
	// Quarterback to Task Force - Admiral Tarkovsky's a real loose cannon, but he�s agreed to stop firing for now. Keep going, we�ll keep you posted. Out.	
	delayThread( 3, ::radio_dialogue, "gulag_hqr_loosecannon" );


}

gulag_cellblocks_spotlight()
{
	SetSavedDvar( "r_spotlightbrightness", 3.5 );
	SetSavedDvar( "r_spotlightfovinnerfraction", "0.9" );

	turret = GetEnt( "gulag_spotlight", "targetname" );
	turret SetMode( "manual" );
	ent = Spawn( "script_origin", ( 0, 0, 0 ) );

	turret SetTargetEntity( ent );

	fx = getfx( "_attack_heli_spotlight" );
	//PlayFXOnTag( fx, turret, "tag_aim" );

	fx_tag = "tag_light";
	add_wait( ::flag_wait, "spotlight_turns_on" );
	add_noself_call( ::PlayFXOnTag, fx, turret, fx_tag );
	add_func( ::play_sound_in_space, "scn_gulag_spotlight_on", turret.origin, true );


	thread do_wait();

	gulag_spotlight_searches( ent, turret );
	wait( 2.5 );
	ent Delete();
	StopFXOnTag( fx, turret, fx_tag );

}

gulag_spotlight_searches( ent, turret )
{
	level endon( "rappel_time" );

	forward = AnglesToForward( turret.angles );
	ent.origin = turret.origin + forward * 500 + ( 0, 0, -500 );

	units_per_second = 200;
	//ent thread print3dforever();

	for ( ;; )
	{
		ai = GetAIArray( "axis" );

		guys = [];
		foreach ( guy in ai )
		{
			z_offset = abs( guy.origin[ 2 ] - level.player.origin[ 2 ] );
			if ( z_offset > 64 )
				continue;
			guys[ guys.size ] = guy;
		}

		guy = getClosest( level.player.origin, guys );
		if ( !isalive( guy ) )
		{
			wait( 0.2 );
			continue;
		}

		dist = Distance( guy.origin, ent.origin );

		vec = randomvector( 25 );
		extra_z = RandomFloatRange( -16, 16 );
		vec += ( 0, 0, extra_z );
		time = dist / units_per_second;
		random_min = RandomFloatRange( 0.7, 1.3 );
		if ( time < random_min )
			time = random_min;

		spotlight_org = guy.origin + ( 0, 0, 40 ) + vec;
		if ( IsDefined( level.spotlight_override_pos ) )
		{
			spotlight_org = level.spotlight_override_pos;
		}

		ent MoveTo( spotlight_org, time, time * 0.4, time * 0.4 );
		wait( time );
	}
}

print3dforever()
{
	for ( ;; )
	{
		Print3d( self.origin, ".", ( 0, 1, 0 ), 1, 1, 20 );
		wait( 0.05 );
	}
}

catwalk_spawner()
{
	self.attackeraccuracy = 0;
	volume = GetEnt( "armory_clear_enemy_volume", "targetname" );

	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( guy == self )
			continue;
		if ( !guy IsTouching( volume ) )
			continue;

		time = RandomFloatRange( 0.5, 1.5 );
		guy delayCall( time, ::Kill );
	}
}

get_global_fx( name )
{
	fxName = level.global_fx[ name ];
	return level._effect[ fxName ];
}

insure_player_has_enemies_to_fight_for_door_sequence()
{
	/#
	flag_assert( "open_cell_door2" );
	#/

	level endon( "open_cell_door2" );
	spawners = GetEntArray( "close_fighter_spawner", "targetname" );
	vol = GetEnt( "door_guys_fight_vol", "targetname" );

	vol waittill_volume_dead();

	foreach ( spawner in spawners )
	{
		spawner.count = 1;
	}
	array_thread( spawners, ::spawn_ai );

	wait( 3 );

	foreach ( spawner in spawners )
	{
		spawner.count = 1;
	}
	array_thread( spawners, ::spawn_ai );
}


enemies_retreat_and_delete()
{
	// spotlight points at this flag
	ent = getEntWithFlag( "player_approaches_armory" );
	level.spotlight_override_pos = ent.origin;


	node = GetNode( "cellblock_delete_node", "targetname" );
	ai = GetAIArray( "axis" );
	array_thread( ai, ::go_to_node_and_delete, node );
}

lower_cellblock_enemies_retreat_and_delete()
{
	// spotlight points at this flag again!
	ent = getEntWithFlag( "player_approaches_armory" );
	level.spotlight_override_pos = ent.origin;

	node = GetNode( "cells_last_flee_node", "targetname" );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( !isdefined( guy.script_goalvolume ) )
			continue;
		if ( guy.script_goalvolume == "cells_north" )
			guy thread go_to_node_and_delete( node );
	}
}

go_to_node_and_delete( node )
{
	self endon( "death" );
	time = RandomFloat( 6 );
	wait( time );
	self SetGoalNode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	self Delete();
}

player_riotshield_threatbias()
{
	level.player endon( "death" );
	bias = level.player.threatbias;

	thread modulate_player_attacker_accuracy_for_armory();

	for ( ;; )
	{
		if ( level.player GetCurrentWeapon() == "riotshield" )
		{
			level.player.threatbias = bias + 1000;
			thread accurate_vs_nearest_baddie();
		}
		else
		{
			level.player.threatbias = bias;
		}

		level.player waittill( "weapon_change" );
	}
}

accurate_vs_nearest_baddie()
{
	level.player endon( "weapon_change" );
	for ( ;; )
	{
		ai = GetAIArray( "axis" );
		guy = getClosest( level.player.origin, ai, 700 );
		if ( IsAlive( guy ) )
			guy thread high_attacker_accuracy();
		wait( 1 );
	}
}

high_attacker_accuracy()
{
	self endon( "death" );
	self.attackeraccuracy = 10;
	self.threatbias = 1000;
	wait( 1 );
	self.attackeraccuracy = 1;
	self.threatbias = 0;
}


modulate_player_attacker_accuracy_for_armory()
{
	change_accuracy_while_in_armory();

	// reset attackeraccuracy
	maps\_gameskill::updateAllDifficulty();
	anim.shootEnemyWrapper_func = animscripts\utility::shootEnemyWrapper_shootNotify;

	// reset the accuracy of the AI
	axis = GetAIArray( "axis" );
	foreach ( guy in axis )
	{
		guy.baseaccuracy = 1;
	}
}

change_accuracy_while_in_armory()
{
	level endon( "run_from_armory" );
	if ( flag( "run_from_armory" ) )
		return;

	for ( ;; )
	{
		level.player waittill( "weapon_change" );

		if ( level.player GetCurrentWeapon() != "riotshield" )
			continue;

		anim.shootEnemyWrapper_func = ::shootWrapper_playerRiotshield;

//		set_player_attacker_accuracy( 0 );
		level.player waittill( "weapon_change" );

		AssertEx( level.player GetCurrentWeapon() != "riotshield", "Changed from riotshield to riotshield??" );

		// reset attackeraccuracy
		maps\_gameskill::updateAllDifficulty();
		anim.shootEnemyWrapper_func = animscripts\utility::shootEnemyWrapper_shootNotify;
	}
}

shootWrapper_playerRiotshield()
{
	if ( !isalive( self.enemy ) )
		return;
	if ( !isalive( level.player ) )
		return;
		
	dotrange = [];
	dotrange[ 0 ] = 0.85;
	dotrange[ 1 ] = 0.85;
	dotrange[ 2 ] = 0.83;
	dotrange[ 3 ] = 0.81;
	dot_limit = dotrange[ level.gameskill ];

	if ( self.enemy == level.player )
	{
		angles = level.player GetPlayerAngles();
		forward = AnglesToForward( angles );
		vec = VectorToAngles( self.origin - level.player.origin );
		vec_forward = AnglesToForward( vec );

		if ( VectorDot( forward, vec_forward ) >= dot_limit )
		{
			// guys in front of you get full accuracy but hit the shield
			self.baseaccuracy = 5000;
		}
		else
		{
			// guys on the side miss
			self.baseaccuracy = 0;
		}
	}

	animscripts\utility::shootEnemyWrapper_shootNotify();
}

clear_rioter()
{
	if ( !isdefined( self.rioter ) )
		return;

	self.disableBulletWhizbyReaction = false;

	self.rioter = undefined;
	self.threatbias -= level.rioter_threat;
	self.dropShieldInPlace = true;
	self.allowpain = false;
	self delaythread( 8, ::recover_from_riotshield );
	self AnimCustom( animscripts\riotshield\riotshield::riotshield_flee_and_drop_shield );
	self.fixednode = true;
}

recover_from_riotshield()
{
	self.minpaindamage = 0;
	enable_pain();
}

hallway_hider_spawner()
{
	self endon( "death" );
	wait( 0.05 );
	self.baseaccuracy = 5000;// they dont miss much

	level.hallway_hiders[ level.hallway_hiders.size ] = self;

	// these guys hide!
	radius = self.radius;
	self.hallway_hider = true;
	self.goalradius = 16;
	self.grenadeammo = 0;
	self.combatMode = "ambush";
	self SetGoalPos( self.origin );
	self ClearGoalVolume();
//	Print3d( self.origin, "x", (1,0,0), 1, 1, 5000 );

	self.saw_player = false;
	self.stays_alive = false;
	
	self set_battlechatter( false );


	wait_for_player_sweeps_cells();

	if ( !self.saw_player && !self.stays_alive )
		self Delete();

	self.goalradius = radius;// move to node
}

wait_for_player_sweeps_cells()
{
	level endon( "lets_sweep_the_nvg_cells" );
	if ( flag( "lets_sweep_the_nvg_cells" ) )
		return;

	for ( ;; )
	{
		if ( self CanSee( level.player ) )
			break;
		wait( 0.05 );
	}
	self.saw_player = true;
}


friendlies_move_up_through_cells()
{
	allies = GetAIArray( "allies" );
	foreach ( guy in allies )
	{
		guy.attackeraccuracy = 0.1;
		guy.maxvisibledist = 100;
	}

	friendlies_check_each_cell();
	
	// get guys off the cellblock node chain
	level notify( "stop_following_node_chain" );

	allies = GetAIArray( "allies" );
	foreach ( guy in allies )
	{
		guy enable_ai_color();
		guy.attackeraccuracy = 1;
		guy.maxvisibledist = 8192;
	}

	activate_trigger_with_targetname( "nvg_hallway_fightnodes" );
}

friendlies_check_each_cell()
{
	if ( flag( "nvg_leave_cellarea" ) )
		return;
	level endon( "nvg_leave_cellarea" );

	level.nvg_hall_flags = [];
	level.clear_callout_index = 0;
	run_thread_on_targetname( "friendly_clears_cell_trigger", ::friendly_clears_cell_trigger );

	struct = spawnstruct();
	struct.index = 1;
	struct thread constantly_activates_trigger();
	
	for ( ;; )
	{
		// struct activates the trigger constantly so that friendlies fill in the holes
		
		flag_wait( "nvg_moveup" + struct.index );
		struct.index++;
		if ( struct.index > 4 )
		{
			struct notify( "stop" );
			return;
		}
	}
}

constantly_activates_trigger()
{
	level endon( "nvg_leave_cellarea" );
	self endon( "stop" );
	for ( ;; )
	{
		activate_trigger_with_targetname( "friendly_nvg_cell_hall_moveup" + self.index );
		wait( 0.5 );
	}	
}

guy_follows_nvg_node_chain( node )
{
	self endon( "death" );
	level endon( "stop_following_node_chain" );

	if ( flag( "nvg_leave_cellarea" ) )
		return;
	level endon( "nvg_leave_cellarea" );
	

	self disable_ai_color();
	for ( ;; )
	{
		self setgoalnode( node );
		flag_wait( node.script_flag );
		if ( !isdefined( node.target ) )
			return;
			
		node = getnode( node.target, "targetname" );
	}
}

friendly_clears_cell_trigger()
{
	if ( flag( "nvg_leave_cellarea" ) )
		return;
	level endon( "nvg_leave_cellarea" );
	
	// friendly touches a trigger then clears the bad guy in the volume and yells "clear" then sets a flag to move up
	// if multiple triggers share the same flag, both must be cleared before moving up

	myFlag = self.script_flag;
	if ( !isdefined( level.nvg_hall_flags[ myFlag ] ) )
		level.nvg_hall_flags[ myFlag ] = 0;

	level.nvg_hall_flags[ myFlag ]++;
	volume = GetEnt( self.target, "targetname" );
	node = getnode( self.target, "targetname" );
	
	found_enemy = undefined;
	
	for ( ;; )
	{
		self waittill( "trigger", other );
		
		if ( isdefined( node ) )
		{
			other thread guy_follows_nvg_node_chain( node );
		}
		
		if ( isdefined( other.node ) && isdefined( other.node.radius ) )
		{
			// low visibility so we dont get shot by the wrong guys
			other.maxvisibledist = other.node.radius;
		}
		
		found_enemy = volume waittill_volume_dead_or_dying();

		if ( IsAlive( other ) && other IsTouching( self ) )
			break;
	}

	clear_callouts = [];
	// This one's empty.		
	clear_callouts[ clear_callouts.size ] = "gulag_tf2_onesempty";
	// This one's empty too.		
	clear_callouts[ clear_callouts.size ] = "gulag_tf3_emptytoo";
	// Clear.		
	clear_callouts[ clear_callouts.size ] = "gulag_tf2_clear";
	// Clear.		
	clear_callouts[ clear_callouts.size ] = "gulag_tf3_clear";

	callout = clear_callouts[ level.clear_callout_index ];
	
	if ( found_enemy )
	{
		callout = "gulag_tf3_clear";
		wait( 0.9 );
	}
	else
	{
		level.clear_callout_index++;
		level.clear_callout_index %= clear_callouts.size;
	}
	
	thread radio_dialogue( callout );

	// other says "CLEAR!"
	level.nvg_hall_flags[ myFlag ]--;
	if ( !level.nvg_hall_flags[ myFlag ] )
	{
		// if both sides are cleared, we can move up now
		// nvg_moveup1, nvg_moveup2, nvg_moveup3, nvg_moveup4 
		flag_set( myFlag );
	}
}

nvg_hallway_fight()
{
	flag_wait( "nvg_hallway_fight" );

	level.hallway_hiders = [];

	// these guys hide, some get deleted when its time for the player to sweep the cells.
	array_spawn_function_noteworthy( "hallway_hider_spawner", ::hallway_hider_spawner );
	array_spawn_noteworthy( "hallway_hider_spawner" );


	flag_wait( "nvg_enemy_flag" );
	wait( 1.5 );
	vol = GetEnt( "nvg_vol", "targetname" );
	for ( ;; )
	{
		vol waittill_volume_dead_or_dying();
		wait( 2.8 );

		// make sure no bad guys have yelled recently
		wait_for_buffer_time_to_pass( anim.lastTeamSpeakTime[ "axis" ], 2.5 );

		hostiles = vol get_ai_touching_volume( "axis" );
		if ( !hostiles.size )
			break;
	}

	flag_set( "checking_to_sweep_cells" );
	axis = GetAIArray( "axis" );
	remaining_guys = [];
	foreach ( guy in axis )
	{
		if ( IsDefined( guy.hallway_hider ) )
			continue;
		guy ClearGoalVolume();
		guy SetGoalPos( level.soap.origin );
		guy.combatmode = "no_cover";
		guy set_battlechatter( false );
		guy.grenadeammo = 0;
		guy.goalradius = 500;
		remaining_guys[ remaining_guys.size ] = guy;
	}
	
	is_remaining_guys = remaining_guys.size;
	// remaining guys rush
	waittill_dead_or_dying( remaining_guys, 0, 6 );
	
	if ( is_remaining_guys )
	{
		wait( 1.4 );
	}
	

	// Of the 5 possible cell guys, remove a few based on difficulty
	hider_count = 1;
//	if ( level.gameskill >= 2 )
//		hider_count++;

	level.hallway_hiders = array_randomize( level.hallway_hiders );

	foreach ( guy in level.hallway_hiders )
	{
		if ( !isalive( guy ) )
			continue;

		// some guys are randomly assigned to stay alive
		guy.stays_alive = true;
		hider_count--;
		if ( !hider_count )
			break;
	}


	delaythread( 1.5, ::flag_set, "lets_sweep_the_nvg_cells" );
	if ( !flag( "nvg_moveup1" ) )
	{
		// Roach, check the cells for stragglers.	
		level.soap thread dialogue_queue( "gulag_cmt_stragglers" );
	}
}

kill_all_axis_now()
{
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		guy.diequietly = true;
		guy Kill();
	}
}

riot_shield_detector_think()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;

		if ( IsSubStr( other.classname, "riot" ) )
			break;
	}

	wait( 2.5 );
	// Heavy assault troops up ahead! Don't attack them head on! Move quickly and hit them from the side!	
	level.soap dialogue_queue( "gulag_cmt_hitfromside" );

	// Cook your grenades to detonate behind them!	
	level.soap dialogue_queue( "gulag_cmt_cookgrenades" );

}

player_gets_hud_back()
{
	SetSavedDvar( "compass", "1" );
	SetSavedDvar( "hud_showStance", 1 );
	SetSavedDvar( "ammoCounterHide", 0 );
	SetSavedDvar( "hud_drawhud", 1 );
}

gulag_player_snipes()
{
	level.player EnableWeapons();
	SetSavedDvar( "ammoCounterHide", 0 );
	SetSavedDvar( "hud_drawhud", 1 );
}

gulag_landing_update_entities()
{
	flag_wait( "player_lands" );
	gulag_top_gates = GetEntArray( "gulag_top_gate", "targetname" );
	array_call( gulag_top_gates, ::Solid );
	array_call( gulag_top_gates, ::Show );

	delayThread( 6, ::player_gets_hud_back );

	delayThread( 6, ::player_can_be_shot );

	//delaythread( 6, ::kill_all_axis_now );

	landing_death_volume = GetEnt( "landing_death_volume", "targetname" );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( guy IsTouching( landing_death_volume ) )
		{
			guy.diequietly = true;
			guy Kill();
		}
	}
	landing_death_volume Delete();


	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		if ( guy.baseaccuracy > 2 )
			guy.baseaccuracy = 2;
	}
}

soap_paths_to_node_then_leads()
{
	node = GetNode( "soap_heli_node", "targetname" );

	level.soap disable_ai_color();
	level.soap SetGoalNode( node );
	level.soap.goalradius = node.radius;
	level.soap waittill( "goal" );
	level.soap set_force_color( "g" );
}

price_breach_dof()
{
	wait( 3.75 );
	start = level.dofDefault;

	dof_see_my_gun = [];
	dof_see_my_gun[ "nearStart" ] = 5;
	dof_see_my_gun[ "nearEnd" ] = 10;
	dof_see_my_gun[ "nearBlur" ] = 10;
	dof_see_my_gun[ "farStart" ] = 25;
	dof_see_my_gun[ "farEnd" ] = 30;
	dof_see_my_gun[ "farBlur" ] = 10;

	dof_see_gun = [];
	dof_see_gun[ "nearStart" ] = 2;
	dof_see_gun[ "nearEnd" ] = 17;
	dof_see_gun[ "nearBlur" ] = 7;
	dof_see_gun[ "farStart" ] = 25;
	dof_see_gun[ "farEnd" ] = 30;
	dof_see_gun[ "farBlur" ] = 7;
	
	dof_see_price = [];
	dof_see_price[ "nearStart" ] = 30;
	dof_see_price[ "nearEnd" ] = 36;
	dof_see_price[ "nearBlur" ] = 7;
	dof_see_price[ "farStart" ] = 100;
	dof_see_price[ "farEnd" ] = 120;
	dof_see_price[ "farBlur" ] = 7;

	dof_see_soap = [];
	dof_see_soap[ "nearStart" ] = 24;
	dof_see_soap[ "nearEnd" ] = 28;
	dof_see_soap[ "nearBlur" ] = 4;
	dof_see_soap[ "farStart" ] = 140;
	dof_see_soap[ "farEnd" ] = 180;
	dof_see_soap[ "farBlur" ] = 4;


	// control our blend with this origin;
	ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	ent.origin = ( 65, 0, 0 );
	ent thread set_fov_from_x();

	queue_time = level.queue_time;
	blend_dof( start, dof_see_my_gun, 0.25 );

	offset = 0.85;

	wait_for_buffer_time_to_pass( queue_time, 5.0 );

	blend_dof( dof_see_my_gun, dof_see_gun, 0.5 );

	ent delayCall( 0.0, ::moveto, ( 45, 0, 0 ), 0.8, 0.4, 0.4 );

	wait_for_buffer_time_to_pass( queue_time, 5.85 + offset );

//	ent delayCall( 1.4, ::moveto, (45,0,0), 0.8, 0.4, 0.4 );
	noself_delayCall( 2.0, ::setsaveddvar, "g_friendlynamedist", 196 );

//	blend = level create_blend( ::blend_fov, 65, 45 );
//	blend.time = 1;

	blend_dof( dof_see_gun, dof_see_price, 1.0 );


	wait_for_buffer_time_to_pass( queue_time, 7.5 + offset + 2 );

//	thread blend_fov_out();
//	ent delayCall( 1.4, ::moveto, (58,0,0), 1.8, 0.8, 0.8 );

	ent thread ent_blends_out_fov();

	blend_dof( dof_see_price, dof_see_soap, 2 );

//	wait_for_buffer_time_to_pass( queue_time, 12 + offset  );
	flag_wait( "background_explosion" );

	blend_dof( dof_see_soap, start, 1 );

}

ent_blends_out_fov()
{
	//wait( 5.5 );
	level waittill( "background_explosion" );
	wait( 0.15 );
	blend_out_fov_time = 0.6;

	self MoveTo( ( 65, 0, 0 ), blend_out_fov_time, blend_out_fov_time * 0.5, blend_out_fov_time * 0.5 );
	wait( blend_out_fov_time );
	wait( 0.1 );
	self Delete();
}

set_fov_from_x()
{
	self endon( "death" );
	for ( ;; )
	{
		SetSavedDvar( "cg_fov", self.origin[ 0 ] );
		wait( 0.05 );
	}
}

/*
blend_fov_out()
{
	//wait( 2 );
	blend = level create_blend( ::blend_fov, 45, 65 );
	blend.time = 2;
}


blend_fov( progress, start, end )
{
	SetSavedDvar( "cg_fov", start * ( 1 - progress ) + end * progress );
}
*/

sewer_slide_trigger()
{
	targets = getstructarray( self.target, "targetname" );
	targets = array_index_by_script_index( targets );
	index = 0;
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;

		if ( !first_touch( other ) )
			continue;

		org = targets[ index ];
		index++;
		index %= targets.size;
		other thread guy_does_sewer_slide( org );
	}
}

guy_does_sewer_slide( org )
{
	self endon( "death" );
	org anim_generic_reach( self, "sewer_slide" );
	self delayThread( 2, ::enable_ai_color );
	org anim_generic_run( self, "sewer_slide" );
}

ai_field_blocker()
{
	flag_wait( "a_heli_landed" );
	// makes the friendlies go the right way
	ai_field_blocker = GetEnt( "ai_field_blocker", "targetname" );
	ai_field_blocker Solid();
	ai_field_blocker DisconnectPaths();
}

lasers_scan_armory()
{
	model = Spawn( "script_model", ( 0, 0, 0 ) );
	model.origin = self.origin;
	model SetModel( "tag_laser" );
	model thread laser_scans_armory( self.target );
}

laser_scans_armory( target )
{
	dest = Spawn( "script_origin", ( 0, 0, 0 ) );
	thread draw_laser_line( dest );

	dest thread laser_jitters();
	wait( 1 );
	dest notify( "stop_jitter" );

	targ = getstruct( target, "targetname" );
	dest MoveTo( targ.origin, 3, 1, 2 );
	wait( 3 );
	targ = getstruct( targ.target, "targetname" );
	dest MoveTo( targ.origin, 1.5, 0.5, 0.7 );
	wait( 1.5 );
	self notify( "stop_line" );
	self Delete();
	dest Delete();
}

laser_jitters()
{
	self endon( "stop_jitter" );
	org = self.origin;

	for ( ;; )
	{
		neworg = org + randomvector( 30 );
		movetime = RandomFloatRange( 0.5, 0.75 );
		self MoveTo( neworg, movetime );
		wait( movetime );
	}
}

draw_laser_line( dest )
{
	self endon( "stop_line" );
	//self LaserOn();
	self LaserForceOn();

	wait( 0.05 );
	self.angles = VectorToAngles( dest.origin - self.origin );
	wait( 0.05 );
	for ( ;; )
	{
		self RotateTo( VectorToAngles( dest.origin - self.origin ), 0.1 );
//		Line( self.origin, dest.origin, (0,1,0) );

		wait( 0.1 );
	}
}

higher_max_facedist()
{
	self.maxfaceenemydist = 3048;
}

modify_sm_samplesize_on_flyin()
{
	fly_in_samplesize = 0.8;
	switch( level.start_point )
	{
		case "intro":
			SetSavedDvar( "sm_sunSampleSizeNear", 0.25 );
			wait( 27 );
			maps\_introscreen::ramp_out_sunsample_over_time( 2, fly_in_samplesize );
		case "approach":
		case "f15":
		case "unload":
			SetSavedDvar( "sm_sunSampleSizeNear", fly_in_samplesize );
			flag_wait( "player_lands" );
			maps\_introscreen::ramp_out_sunsample_over_time( 1.5 );

		default:
			SetSavedDvar( "sm_sunSampleSizeNear", 0.25 );
			break;
	}
}

intro_heli_treadfx()
{
	start_time = GetTime();
	self endon( "death" );
	level endon( "stop_special_treadfx" );
	if ( !isdefined( level.skip_treadfx ) )
		return;

	fx = level._vehicle_effect[ self.vehicletype ][ "water" ];

	for ( ;; )
	{
		//angles = self.angles;
		//angles = ( 0, angles[1], 0 );
		//forward = AnglesToForward( self.angles );
		//up = AnglesToUp( self.angles );
		//start = self.origin + forward * 500 + up * -500;
		//end = self.origin + forward * 7000 + up * -3000;
		start = self.origin + ( 0, 0, -500 );
		end = self.origin + ( 0, 0, -5000 );
		trace = BulletTrace( start, end, false, self );
		//Line( start, end );

		pos = trace[ "position" ];

		if ( IsDefined( pos ) )
		{
			trace_dist = Distance( start, pos );
			if ( trace_dist < 1200 )
			{
				PlayFX( fx, pos );
				printpos( trace[ "surfacetype" ], pos, start_time );
			}
		}
		wait( 0.05 );
	}
}

printpos( surface, pos, start_time )
{
	if ( !isdefined( surface ) )
		return;
	if ( surface != "water" && surface != "ice" )
		return;

	time = GetTime() * 0.001;
	PrintLn( "	add_waterfx( " + time + ", " + pos + " );" );
	Print3d( pos, "x", ( 1, 0, 0 ), 1, 5, 100 );
}

add_waterfx( time, pos )
{
	time -= 1.3;// 5 seconds early

	time *= 1000;

	remainder = time - GetTime();
	if ( remainder > 0 )
		wait( remainder * 0.001 );

	PlayFX( level.special_water_fx, pos );
	//Print3d( pos, "x", (1,0,0), 1, 5, 100 );
}

draw_waterfx()
{
	level.special_water_fx = level._vehicle_effect[ "littlebird" ][ "water" ];
	maps\gulag_water_fx::load_waterfx();

}

kill_slide_trigger()
{
	flag_wait( "kill_slide_trigger" );
	wait( 1 );
	trigger = getEntWithFlag( "kill_slide_trigger" );
	slide_trigger = GetEnt( trigger.target, "targetname" );
	slide_trigger trigger_off();
}

low_health_destructible()
{
	if ( self.code_classname != "script_model" )
		return;
	thread part_blows_up_early();
}

part_blows_up_early()
{
	self waittill( "damage" );
	count = 0;
	for ( ;; )
	{
		if ( !isdefined( self.destructible_parts ) )
			return;
		self DoDamage( 500, self.origin, level.player );
		//self.destructible_parts[0].v["health"] = 1;
		waittillframeend;
		count++;
		if ( count >= 10 )
		{
			count = 0;
			wait( 0.05 );
		}
	}
}

flyby_earthquake()
{

}

landing_blocker_think()
{
	landing_blockers = GetEntArray( "landing_blocker", "targetname" );
	foreach ( blocker in landing_blockers )
	{
		blocker ConnectPaths();
		blocker NotSolid();
	}

	flag_wait( "player_lands" );

	foreach ( blocker in landing_blockers )
	{
		blocker Solid();
		blocker DisconnectPaths();
	}
}

ghost_uses_laptop()
{
	AssertEx( IsAlive( level.ghost ), "No ghost!" );
	level.ghost endon( "death" );

	flag_wait( "ghost_goes_to_laptop" );
	struct = getstruct( "ghost_laptop_struct", "targetname" );


	chair = spawn_anim_model( "folding_chair" );

	struct thread anim_first_frame_solo( chair, "laptop_approach" );
	struct thread anim_reach_solo( level.ghost, "laptop_approach" );
	level.ghost waittill( "goal" );
	flag_set( "ghost_uses_laptop" );

	guys = [];
	guys[ "ghost" ] = level.ghost;
	guys[ "chair" ] = chair;

	struct anim_single( guys, "laptop_approach" );
	struct anim_loop_solo( level.ghost, "laptop_idle" );
}

teleport_ghost_to_laptop_if_possible()
{
	if ( flag( "ghost_uses_laptop" ) )
		return;
	level endon( "ghost_uses_laptop" );

	struct = getstruct( "ghost_teleport_look_target_struct", "targetname" );

	for ( ;; )
	{
		if ( !player_looking_at( struct.origin, 0.7, true ) )
			break;

		wait( 0.05 );
	}

	AssertEx( IsDefined( level.ghost.goalpos ), "no ghost goalpos" );
	level.ghost Teleport( level.ghost.goalpos );
}

ignore_then_dies_fast_to_explosive()
{
	self endon( "death" );
	self add_damage_function( ::die_fast_to_explosive_damage );

	self.disablearrivals = true;
	self.ignoreall = true;
	self waittill( "goal" );
	wait( 1.2 );
	self.disablearrivals = false;
	self.ignoreall = false;	
}

dies_fast_to_explosive()
{
	self add_damage_function( ::die_fast_to_explosive_damage );
}

die_fast_to_explosive_damage( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	if ( !isdefined( type ) )
		return;
	if ( type != "MOD_TRIGGER_HURT" )
		return;
	self DoDamage( 50, point, attacker, attacker );
}

bloody_pain( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	angles = direction_vec;// + ( 0, 180, 0 );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	fx = getfx( "headshot" );
	PlayFX( fx, point, forward, up );
//	Line( point, point + forward * 500, (1,0,0), 1, 1, 5000 );
}

friendlies_traverse_bathroom()
{
	if ( flag( "player_exited_bathroom" ) )
		return;
	if ( flag( "leaving_bathroom_vol2" ) )
		return;

	level endon( "player_exited_bathroom" );
	level endon( "leaving_bathroom_vol2" );

	level.old_bathroom_index = -1;

	volumes = GetEntArray( "bathroom_enemy_volume", "targetname" );
	volumes = array_index_by_script_index( volumes );
	foreach ( volume in volumes )
	{
		volume.friendly_trigger = GetEnt( volume.target, "targetname" );
	}

	for ( ;; )
	{
		axis = GetAIArray( "axis" );
		for ( i = 0; i < volumes.size; i++ )
		{
			volume = volumes[ i ];
			if ( volume array_member_touches( axis ) )
			{
				if ( volume.script_index != level.old_bathroom_index )
				{
					level.old_bathroom_index = volume.script_index;
					//iprintlnbold( "^3Moved to index " + volume.script_index );
				}
				volume.friendly_trigger activate_trigger();
				wait( 1 );
				break;
			}
			else
			{
				wait( 0.1 );
			}
		}
	}
}

array_member_touches( array )
{
	parms = IsDefined( self.script_parameters );

	foreach ( member in array )
	{
		if ( !isalive( member ) )
			continue;
		if ( member doingLongDeath() )
			continue;
		if ( parms )
		{
			// if the volume has parameters, the member's classname must have the parms as a substr
			// so we'll flee riotshield guys
			if ( !issubstr( member.classname, self.script_parameters ) )
				continue;
		}
		if ( member IsTouching( self ) )
			return true;
	}
	return false;
}

enemies_attack_friendlies_in_armory_first_wave()
{
	// spotlight points at baddies again
	level.spotlight_override_pos = undefined;

	// bunch of baddies spawn in and laser you
	//activate_trigger_with_targetname( "cellblock_armory_attackers_trigger" );
	array_spawn_targetname( "cellblock_armory_first_wave_spawner" );

	wait( 3 );

	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy.disableBulletWhizbyReaction = true;
		guy disable_dontevershoot();
	}
}

enemies_attack_friendlies_in_armory_second_wave()
{
	array_spawn_targetname( "cellblock_armory_second_wave_spawner" );

	cellblock_armory_attacker_spawners = GetEntArray( "cellblock_armory_attacker_spawner", "targetname" );
	array_thread( cellblock_armory_attacker_spawners, ::spawn_ai );
}

friendlies_grab_riotshields()
{
	level.riotshield_friendlies = [];
	ai = GetAIArray();
	foreach ( guy in ai )
	{
		if ( !isdefined( guy.armory ) )
			continue;

		guy thread guy_gets_riotshield();
		level.riotshield_friendlies[ level.riotshield_friendlies.size ] = guy;
	}
}

wait_until_first_wave_ends()
{
	if ( flag( "cellblock_first_wave" ) )
		return;
	level endon( "cellblock_first_wave" );
	
	ent = spawnstruct();
	ent delaythread( 35, ::send_notify, "stop" );
	ent endon ( "stop" );
	
	
	ai = getaiarray( "axis" );
	foreach ( guy in ai )
	{
		guy disable_long_death();
	}
	
	for ( ;; )
	{
		ai = getaiarray( "axis" );
		if ( ai.size <= 2 )
		{
			return;
		}
		wait( 0.05 );
	}
}

player_riotshield_nag()
{
	lines = [];
	// Roach, pick up one of those riot shields!		
	lines[ lines.size ] = "gulag_cmt_pickupone";
	// Grab a riot shield!	
	lines[ lines.size ] = "gulag_cmt_riotshield";

	index = 0;
	
	for ( ;; )
	{
		if ( player_has_weapon( "riotshield" ) )
			return;

		msg = lines[ index ];
		index++;
			
		level.soap thread dialogue_queue( msg );

		if ( index >= lines.size )
			return;
		
		timer = randomfloatrange( 4, 5 );
		wait( timer );
	}
}


armory_roach_is_down()
{
	if ( !isalive( level.player ) )
		return;
	if ( !isalive( level.soap ) )
		return;

	level.soap endon( "death" );		
	lines = [];
	// roach!!
	lines[ 0 ] = "gulag_cmt_roach";
	// roach is down!
	lines[ 1 ] = "gulag_cmt_roachisdown";
	
	level.player waittill( "death" );
	msg = random( lines );
	level.soap function_stack( ::_wait, 0.4 );
	level.soap thread dialogue_queue( msg );
	level.soap function_stack( ::_wait, 5000 );
}

player_riotshield_bash_hint()
{
	flag_init( "player_learned_melee_bash" );
	notifyOnCommand( "player_did_melee", "+melee" );
	
	thread detect_draw_hint();
	for ( ;; )
	{
		level.player waittill( "player_did_melee" );
		if ( player_current_weapon( "riotshield" ) )
			flag_set( "player_learned_melee_bash" );
	}
}

detect_draw_hint()
{
	for ( ;; )
	{
		if ( player_current_weapon( "riotshield" ) )
		{
			ai = getaiarray( "axis" );
			foreach ( guy in ai )
			{
				if ( !isalive( guy ) )
					continue;
					
				if ( distance( guy.origin, level.player.origin ) < 250 )
				{
					display_hint( "riot_bash" );
					return;
				}
				wait( 0.05 );
			}
		}
		wait( 0.05 );
	}
}

stop_bash_hint()
{
	if ( !player_current_weapon( "riotshield" ) )
		return true;
		
	return flag( "player_learned_melee_bash" );	
}

player_current_weapon( weapon )
{
	return level.player GetCurrentWeapon() == weapon;
}

player_loses_ads_briefly()
{
	wait( 1 );
	level.player AllowAds( false );
	wait( 2.5 );
	level.player AllowAds( true );
}

throw_flash_trigger()
{
	throw_flash_trigger = getent( "throw_flash_trigger", "targetname" );
	node = getnode( throw_flash_trigger.target, "targetname" );
	
	throw_flash_trigger waittill( "trigger", other );
	if ( !isalive( other ) )
		return;
	other endon( "death" );
	wait( 2 );
	for ( ;; )
	{
		dist = distance( other.origin, node.origin );
		if ( dist < 8 )
			break;
		if ( dist > 250 )
			return;
		wait( 0.05 );			
	}
	
	ai = getaiarray( "axis" );
	volume = GetEnt( "tunnel_pre_hallway_volume", "targetname" );
	if ( !volume array_touches_self( ai ) )
		return;

	other.allowdeath = true;
	struct = spawnstruct();
	struct.origin = node.origin;
	struct.angles = node.angles + (0,-90,0);
	struct anim_generic( other, "grenade_throw" );

	level notify( "flashed_room" );
}
	
	
array_touches_self( array )
{
	foreach ( guy in array )
	{
		if ( guy istouching( self ) )
			return true;			
	}
	
	return false;
}

move_on_pipe()
{
	self endon( "death" );
	if ( isdefined( self.node ) )
		self.node script_delay();
		
	self.fixednode = false;
	self anim_stopanimscripted();
	wait( 2 );
	self.fixednode = true;	
}

old_soap()
{
	if ( !getdvarint( "soap" ) )
		return;

	wait( 2.7 );
		
	spawner = GetEnt( "endlog_soap_spawner", "targetname" );
	spawner.spawn_functions = [];
	spawner.origin = (0,0,0);
	spawner.count = 1;
	spawner.script_forcespawn = 1;
	guy = spawner spawn_ai();
	guy gun_remove();
	guy.animname = "old_soap";
	self anim_single_solo( guy, "price_rescue" );
	guy delete();
}

no_grenades()
{
	self.grenadeammo = 0;
}

remove_nearby_origins( orgs, min_dist )
{
	for ( i = 0; i < orgs.size; i++ )
	{
		if ( !isdefined( orgs[ i ] ) )
			continue;
			
		origin = orgs[ i ];
		
		for ( p = 0; p < orgs.size; p++ )
		{
			if ( !isdefined( orgs[ p ] ) )
				continue;
			other_origin = orgs[ p ];
			
			if ( origin == other_origin )
			{
				assertex( i == p, "Two speakers in the same place!" );
				continue;
			}
			
			dist = distance( origin, other_origin );
			if ( dist < min_dist )
			{
				orgs[ p ] = undefined;
			}
		}
	}
	
	return orgs;
}

pa_system()
{
	// run before _load so minimum extra entity overhead in case of entity limit
	orgs = [];
	speakers = getentarray( "pa_speaker", "targetname" );

	// only need the origin, so delete the ent
	foreach ( speaker in speakers )
	{
		orgs[ orgs.size ] = speaker.origin;
		speaker delete();
	}
	
	level.pa_broadcast_orgs = remove_nearby_origins( orgs, 64 );
	waittillframeend;

	switch ( level.start_point )
	{
		case "default":
		case "intro":
		case "approach":
			flag_wait( "stab1_clear" );
			wait( 3 );
			// Attention! The west tower has been destroyed! Enemy special forces troops are sniping at our air defense teams on the west wall from their helicopters! Shoot them down before they do any more damage!	
			pa_broadcast( "gulag_rpa_ext_1" );
		
			wait( 8 );	
			// They have destroyed all surface-to-air missile batteries along the peninsula - activate local air defense system and engage at will!		
			pa_broadcast( "gulag_rpa_ext_2" );
		
			flag_wait( "f15_gulag_explosion" );
			wait( 12 );	
			
			// Enemy helicopters are attacking from the west! I repeat, enemy helicopters are attacking from the west!		
			pa_broadcast( "gulag_rpa_ext_3" );
		
		case "unload":
		case "f15":
			flag_wait( "stop_rotating_around_gulag" );
			// We are under attack! They are attempting to land troops via helicopter in the prison grounds!		
			pa_broadcast( "gulag_rpa_ext_4" );
		
			wait( 7 );	
			
			// Attention! Attention! Reinforcements are on the way from Petropavlovsk Naval Base! They will arrive in thirty minutes!		
			pa_broadcast( "gulag_rpa_ext_5" );
		
			flag_wait( "player_lands" );
			wait( 10 );
			// Enemy forces have infiltrated the base! They are moving from the helipad towards the southwest gate!		
			pa_broadcast( "gulag_rpa_ext_6" );
		
			wait( 12 );
			// Enemy special forces troops have landed! They are on the ground, I repeat, they are on the ground and moving towards the southwest gate!		
			pa_broadcast( "gulag_rpa_ext_7" );
			wait( 12 );
			// The southwest gate is taking heavy fire from enemy troops! Reinforce the southwest gate!		
			pa_broadcast( "gulag_rpa_ext_8" );

		case "control_room":
		
			
			flag_wait( "postup_outside_gulag" );
			wait( 5 );
			// They are attacking the command center! I repeat, they are attacking the command center! Send reinforcements!!		
			pa_broadcast( "gulag_rpa_int_1" );
		
			flag_wait( "cell_duty" );	
			wait( 4 );
			// They've taken the main control room and are moving through the central cellblock section!		
			pa_broadcast( "gulag_rpa_int_2" );
			
			wait( 3 );
			// They've taken out the main generator! We are switching to auxiliary power!		
			pa_broadcast( "gulag_rpa_int_3" );
			
			wait( 10 );
			// Send reinforcements to levels one and two of the main cellblock! Divert two teams to level three as a backup! Reinforcements from Petropavlovsk will arrive in twenty-five minutes!		
			pa_broadcast( "gulag_rpa_int_4" );

		case "armory":
		
			flag_wait( "armory_attack_sounds" );	
			// Enemy is approaching the armory on level two, repeat, the enemy is approaching the armory on level two!		
			pa_broadcast( "gulag_rpa_int_5" );

		case "rappel":
		case "tunnel":
		case "bathroom":
		case "rescue":
		case "ending":
		case "run":
		case "cafe":
		case "evac":
			break;
		default:
			AssertMsg( "No objectives set for this start point" );
	}
}

pa_broadcast( alias )
{
	eyepos = level.player geteye();

	dist = 500000;	
	org = undefined;
	foreach ( origin in level.pa_broadcast_orgs )
	{
		newdist = Distance( origin, eyepos );
		if ( newdist >= dist )
			continue;

		dist = newdist;
		org = origin;
	}
	
	assertex( isdefined( org ), "no org!" );	
	play_sound_in_space( alias, org );
}

track_spawn_time()
{
	self.spawn_time = gettime();
}

push_friendlies_forward_on_flag()
{
	flag_wait( "player_nears_cell_door1" );
	activate_trigger_with_targetname( "first_cell_postup" );
}

ghost_line( msg )
{
	if ( isalive( level.ghost ) )
	{
		level.ghost dialogue_queue( msg + "_ghost" );
		return;
	}
	
	radio_dialogue( msg );
}