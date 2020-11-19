#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\arcadia;
#include maps\arcadia_stryker;

FAKE_CHOPPER_SPEED = 1200;
MORTAR_TIME_MIN = 0.5;
MORTAR_TIME_MAX = 2.5;
GOLF_COURSE_FAKE_CHOPPER_SPACING_MIN = 0.5;
GOLF_COURSE_FAKE_CHOPPER_SPACING_MAX = 1.5;
GOLF_COURSE_FAKE_CHOPPER_COUNT_MIN = 8;
GOLF_COURSE_FAKE_CHOPPER_COUNT_MAX = 16;
GOLF_COURSE_FAKE_CHOPPER_PAUSE_MIN = 10.0;
GOLF_COURSE_FAKE_CHOPPER_PAUSE_MAX = 20.0;

movePlayerToStartPoint( sTargetname )
{
	assert( isdefined( sTargetname ) );
	start = getent( sTargetname, "targetname" );
	level.player SetOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
}

laser_hint_print()
{
	if ( flag( "used_laser" ) )
		return;
	
	if( flag( "laser_hint_print" ) )
		return;
	
	flag_set( "laser_hint_print" );
	thread display_hint( "use_laser" );
}

laser_golf_hint_print()
{
	flag_wait( "laser_golf_hint_print" );
	
	wait 10;
	
	if ( flag( "used_laser_golf" ) )
		return;
	
	thread display_hint( "use_laser_golf" );
}

stryker_dialog()
{
	self thread stryker_moving_up_dialog();
	self thread stryker_holding_position_dialog();
}

stryker_moving_up_dialog()
{
	level endon( "golf_course_mansion" );
	self endon( "death" );
	
	dialog = [];
	dialog[ dialog.size ] = "arcadia_str_wererollin";		// Stand clear, we're rollin'.
	dialog[ dialog.size ] = "arcadia_str_standclear";		// Be advised, we're movin' up. Stand clear.
	dialog[ dialog.size ] = "arcadia_str_oscarmike";		// All ground units, stand clear. Badger One is oscar mike.
	
	for(;;)
	{
		self waittill( "resuming speed" );
		
		if ( randomint( 100 ) < 25 )
		{
			if ( !flag( "disable_stryker_dialog" ) )
				thread radio_dialogue( dialog[ randomint( dialog.size ) ] );
		}
	}
}

stryker_holding_position_dialog()
{
	level endon( "golf_course_mansion" );
	self endon( "death" );
	
	dialog = [];
	dialog[ dialog.size ] = "arcadia_str_holdingposition";		// Badger One holding position.
	
	for(;;)
	{
		self waittill( "wait for gate" );
		
		if ( randomint( 100 ) < 25 )
		{
			if ( !flag( "disable_stryker_dialog" ) )
				thread radio_dialogue( dialog[ randomint( dialog.size ) ] );
		}
	}
}

process_ai_script_parameters()
{
	if ( !isdefined( self.script_parameters ) )
		return;
	
	parms = strtok( self.script_parameters, ":;, " );
	
	foreach( parm in parms )
	{
		parm = tolower( parm );
		
		if ( parm == "playerseek" )
		{
			self thread ai_playerseek();
			continue;
		}
		
		if ( parm == "ignoreme" )
		{
			self set_ignoreme( true );
			continue;
		}
		
		if ( parm == "rpg_enemy" )
		{
			self thread rpg_enemy_shoot_stryker();
			continue;
		}
	}
}

ignore_until_unload()
{
	self waittill( "spawned", guy );
	
	if ( !isalive( guy ) )
		return;
	
	guy endon( "death" );
	
	guy set_ignoreme( true );
	guy waittill( "jumpedout" );
	guy set_ignoreme( false );
}

rpg_enemy_shoot_stryker()
{
	if ( !isAlive( level.stryker ) )
		return;
	
	self endon( "death" );
	self set_ignoreme( true );
	
	wait 0.05;
	
	self.goalheight = 64;
	self.goalradius = 64;
	
	// when this guy spawns he tries to shoot the stryker with his RPG
	self waittill( "goal" );
	
	if ( !isAlive( level.stryker ) )
	{
		self set_ignoreme( false );
		return;
	}
	
	self setentitytarget( level.stryker );
	self delayThread( 3.0, ::set_ignoreme, false );
	self delayCall( 15.0, ::clearEnemy );
}

ai_playerseek()
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );
	
	self setgoalentity( level.player );
	self.goalradius = 2000;
}

drop_plane()
{
	self ent_flag_init( "start_drop" );
	
	self ent_flag_wait( "start_drop" );
	
	while( self ent_flag( "start_drop" ) )
	{
		guy1 = spawn_targetname( "paradrop_left" );
		guy1 thread paradropper( self, "distant_parachute_left" );
		
		guy2 = spawn_targetname( "paradrop_right" );
		guy2 thread paradropper( self, "distant_parachute_right" );
		
		wait ( randomfloatrange( .4, .8 ) );
	}
}

paradropper( plane, animName )
{
	self.animname = animName + "_guy";
	self assign_animtree();
	
	chute = spawn_anim_model( animName );
	self linkto( plane );
	chute linkto( plane );
	
	ents = [];
	ents[ ents.size ] = self;
	ents[ ents.size ] = chute;
	
	anime = "drop1";
	if( cointoss() )
		anime = "drop2";
	
	plane anim_single( ents, anime );
	
	chute delete();
	if( isalive ( self ) )
		self delete();
}

sentry_activate_trigger()
{
	sentry = self get_linked_ent();
	
	sentry common_scripts\_sentry::SentryPowerOff();
	
	self waittill( "trigger" );
	
	if ( !isalive( sentry ) )
		return;
	sentry common_scripts\_sentry::SentryPowerOn();
	
	sentry endon( "death" );
	
	wait 5;
	
	// Squad, take out the sentry guns!
	level.foley thread dialogue_queue( "arcadia_fly_sentryguns" );
	
	wait 15;
	
	// Take out that sentry gun!
	level.foley thread dialogue_queue( "arcadia_fly_takeoutsgun" );
}

fake_checkpoint_choppers()
{
	choppers = getentarray( "checkpoint_fake_chopper", "targetname" );
	array_call( choppers, ::hide );
	
	flag_wait( "checkpoint_fake_choppers" );
	
	if ( getdvarint( "r_arcadia_culldist" ) == 1 )
		return;
	
	array_thread( choppers, ::fake_chopper );
}

fake_creek_choppers()
{
	choppers = getentarray( "fake_creek_chopper", "targetname" );
	array_call( choppers, ::hide );
	
	trigger_wait_targetname( "fake_creek_choppers_start" );
	
	array_thread( choppers, ::fake_chopper );
}

fake_chopper()
{
	assert( isdefined( self.target ) );
	target = getstruct( self.target, "targetname" );
	assert( isdefined( target ) );
	destination = target.origin;
	
	d = distance( self.origin, destination );
	moveTime = d / FAKE_CHOPPER_SPEED;
	
	for(;;)
	{
		self thread fake_chopper_create_and_move( moveTime, destination );
		
		if ( !isdefined( self.script_count ) )
			break;
		
		self.script_count--;
		
		if ( self.script_count <= 0 )
			break;
		
		wait randomfloatrange( 3.0, 5.0 );
	}
	
	// delete the fake chopper when it's not going to spawn any more choppers
	self delete();
}

#using_animtree( "vehicles" );
fake_chopper_create_and_move( moveTime, destination )
{	
	assert( isdefined( moveTime ) );
	assert( moveTime > 0 );
	assert( isdefined( destination ) );
	
	chopper = spawn( "script_model", self.origin );
	
	chopper thread delete_fake_chopper_wait();
	chopper endon( "delete" );
	
	chopper.angles = self.angles;
	
	chopperModel[ 0 ] = "vehicle_blackhawk_low";
	chopperModel[ 1 ] = "vehicle_pavelow_low";
	chopper setModel( chopperModel[ randomint( chopperModel.size ) ] );
	
	chopper useAnimTree( #animtree );
	chopper setanim( %bh_rotors, 1, .2, 1 );
	
	// some play a sound effect
	if ( randomint( 2 ) == 0 )
		chopper playLoopSound( "veh_helicopter_loop" );
	
	chopper moveto( destination, moveTime, 0, 0 );
	wait moveTime;
	chopper delete();
}

delete_fake_chopper_wait()
{
	level waittill( "delete_all_fake_choppers" );
	if ( !isdefined( self ) )
		return;
	self notify( "delete" );
	self delete();
}

laser_targeting_device( player )
{
	player endon( "remove_laser_targeting_device" );
	
	player.lastUsedWeapon = undefined;
	player.laserForceOn = false;
	player setWeaponHudIconOverride( "actionslot4", "dpad_laser_designator" );
	
	player notifyOnPlayerCommand( "use_laser", "+actionslot 4" );
	player notifyOnPlayerCommand( "fired_laser", "+attack" );

	if ( !player ent_flag_exist( "disable_stryker_laser" ) )
	{
		player ent_flag_init( "disable_stryker_laser" );
	}
	
	for ( ;; )
	{
		player waittill( "use_laser" );
		
		if ( player.laserForceOn )
		{
			player notify( "cancel_laser" );
			player laserForceOff();
			player.laserForceOn = false;
			wait 0.2;
			player allowFire( true );
		}
		else
		{
			player laserForceOn();
			player allowFire( false );
			player.laserForceOn = true;		
			player thread laser_designate_target();
		}
		
		wait 0.05;
	}
}

get_laser_designation_context( viewpoint, entity )
{
	// Check for volumes
	volumes = getentarray( "stryker_target_location", "targetname" );
	dummyEnt = spawn( "script_origin", viewpoint );
	foreach( volume in volumes )
	{
		assert( isdefined( volume.script_noteworthy ) );
		if ( !dummyEnt isTouching( volume ) )
			continue;
		
		dummyEnt delete();
		return volume.script_noteworthy;
	}
	dummyEnt delete();
	
	// Check target entity
	if ( isdefined( entity ) )
	{
		// target a vehicle?
		if ( isdefined( entity.vehicletype ) || isdefined( entity.destuctableinfo ) )
		{
			if ( isdefined( entity.vehicletype ) && entity.vehicletype == "mi17" )
				return "chopper";
			else
				return "vehicle";
		}
		if ( isAI( entity ) )
			return "ai";
	}
	
	return "generic";
}

laser_designate_dialog( inRange, viewpoint, entity )
{
	dialog = [];
	if ( inRange )
	{
		flag_set( "used_laser" );
		
		context = get_laser_designation_context( viewpoint, entity );
		assert( isdefined( context ) );
		
		switch( context )
		{
			case "house":
				dialog[ dialog.size ] = "arcadia_str_havealock"; 		// Roger, we have a lock. Engaging house.
				dialog[ dialog.size ] = "arcadia_str_badgeronecopies"; 	// Badger One copies, engaging house.
				break;
			case "yellowhouse":
				dialog[ dialog.size ] = "arcadia_str_engyellowhouse"; 	// Badger One engaging enemies at the yellow house
				break;
			case "greyhouse":
				dialog[ dialog.size ] = "arcadia_str_targgreyhouse"; 	// Copy. Targeting enemies at the grey house
				break;
			case "firetruck":
				dialog[ dialog.size ] = "arcadia_str_engfiretruck"; 	// Roger, engaging targets near the fire truck
				break;
			case "policecar":
				dialog[ dialog.size ] = "arcadia_str_confpolicecar"; 	// Confirmed, suppressing enemies near the police car
				break;
			case "apartment_office":
				dialog[ dialog.size ] = "arcadia_str_apartmentoffice"; 	// Badger One copies, engaging enemies at apartment office.
				break;
			case "security_station":
				dialog[ dialog.size ] = "arcadia_str_securitystation"; 	// Roger, attacking targets at security station.
				break;
			case "checkpoint":
				dialog[ dialog.size ] = "arcadia_str_checkpoint"; 		// Confirmed, engaging enemies at checkpoint.
				break;
			case "vehicle":
				dialog[ dialog.size ] = "arcadia_str_attackingvehicle"; // Roger, attacking vehicle.
				dialog[ dialog.size ] = "arcadia_str_engagingvehicle"; 	// Solid copy. Engaging vehicle.
				break;
			case "chopper":
				dialog[ dialog.size ] = "arcadia_str_engchopper";		// Roger. Engaging enemy chopper
				break;
			case "ai":
				dialog[ dialog.size ] = "arcadia_str_engaginginfantry"; // Solid copy. Engaging infantry.
				break;
			case "generic":
				dialog[ dialog.size ] = "arcadia_str_wehavelock";		// Roger, we have a lock. Engaging target.
				dialog[ dialog.size ] = "arcadia_str_engaging"; 		// Badger One copies, engaging your target.
				dialog[ dialog.size ] = "arcadia_str_attacking"; 		// Roger, attacking your target.
				dialog[ dialog.size ] = "arcadia_str_solidcopyeng"; 	// Solid copy. Engaging target.
				break;
			default:
				assertMsg( "Unhandled stryker context location dialog " + context );
				break;
		}
	}
	else
	{
		dialog[ dialog.size ] = "arcadia_str_uhnegative";		// Uh, negative, that target is out of range, over.
		dialog[ dialog.size ] = "arcadia_str_invalidtarget";	// Negative, that's an invalid target over.
		dialog[ dialog.size ] = "arcadia_str_outtarange";		// Negative, that target's outta range!
		dialog[ dialog.size ] = "arcadia_str_outofrange";		// Target is out of range.
	}
	
	if ( flag( "disable_stryker_dialog" ) )
		return;
	
	thread radio_dialogue( dialog[ randomint( dialog.size ) ] );
}

laser_designate_target()
{
	self endon( "cancel_laser" );
	
	self waittill( "fired_laser" );
	
	trace = self get_laser_designated_trace();
	viewpoint = trace[ "position" ];
	entity = trace[ "entity" ];
	
	level notify( "laser_coordinates_received" );
	
	/#
	if ( getdvar( "arcadia_debug_stryker" ) == "1" )
		thread draw_line_for_time( viewpoint, viewpoint + ( 0, 0, 100 ), 1, 0, 0, 20 );
	#/
	
	// Check if we are supposed to be targeting for artillery now
	artilleryTarget = undefined;
	if ( flag( "golf_course_mansion" ) )
		artilleryTarget = laser_origin_within_golf_vehicles( viewpoint );		
	
	if ( isdefined( artilleryTarget ) )
	{
		thread laser_artillery( artilleryTarget );
	}
	else
	{
		if ( !flag( "disable_stryker_laser" ) && !self ent_flag( "disable_stryker_laser" ) )
		{
			// check if target is in range
			if( isAlive( level.stryker ) )
			{
				d = distance( level.stryker.origin, viewpoint );
				inRange = ( d >= 200 && d <= 3500 );
				thread laser_designate_dialog( inRange, viewpoint, entity );
				if ( inRange )
					level.stryker thread stryker_setmode_manual( viewpoint );
			}
		}
	}
	
	wait 0.5;
	
	// take away laser
	self notify( "use_laser" );
}

laser_origin_within_golf_vehicles( viewpoint )
{
	triggers = getentarray( "stealth_laser_zone", "targetname" );
	foreach( trigger in triggers )
	{
		assert( isdefined( trigger.script_group ) );
		assert( isdefined( level.stealth_bombed_target[ trigger.script_group ] ) );
		if ( level.stealth_bombed_target[ trigger.script_group ] )
			continue;
		d = distance( viewpoint, trigger.origin );
		if ( d <= trigger.radius )
			return trigger.script_group;
	}
	return undefined;
}

get_laser_designated_trace()
{
	eye = self geteye();
	angles = self getplayerangles();
	
	forward = anglestoforward( angles );
	end = eye + vector_multiply( forward, 7000 );
	trace = bullettrace( eye, end, true, self );
	
	//thread draw_line_for_time( eye, end, 1, 1, 1, 10 );
	//thread draw_line_for_time( eye, trace[ "position" ], 1, 0, 0, 10 );
	
	entity = trace[ "entity" ];
	if ( isdefined( entity ) )
		trace[ "position" ] = entity.origin;
	
	return trace;
}

should_stop_laser_hint()
{
	return flag( "used_laser" );
}

should_stop_laser_golf_hint()
{
	return flag( "used_laser_golf" );
}

get_golf_geo( targetname, groupNum )
{
	ents = getentarray( targetname, "targetname" );
	returnedEnts = [];
	foreach( ent in ents )
	{
		if ( ent.script_group == groupNum )
			returnedEnts[ returnedEnts.size ] = ent;
	}
	return returnedEnts;
}

laser_artillery( groupNum, forced )
{
	if ( !isdefined( forced ) )
		forced = false;
	
	flag_set( "used_laser_golf" );
	flavorbursts_off( "allies" );
	
	assert( isdefined( level.stealth_bombed_target[ groupNum ] ) );
	level.stealth_bombed_target[ groupNum ] = true;
	
	soundEnt = undefined;
	if ( groupNum == 0 )
	{
		flag_set( "lazed_targets_0" );
		soundEnt = getent( "artillery_soundent_0", "targetname" );
		if ( !forced )
			thread radio_dialogue( "arcadia_art_missionrec" );	// Fire mission received, artillery inbound.
	}
	if ( groupNum == 1 )
	{
		flag_set( "lazed_targets_1" );
		soundEnt = getent( "artillery_soundent_1", "targetname" );
		if ( !forced )
			thread radio_dialogue( "arcadia_art_confirmed" );	// Coordinates confirmed. Firing!
	}
	assert( isdefined( soundEnt ) );
	
	if ( flag( "lazed_targets_0" ) && flag( "lazed_targets_1" ) )
		level notify( "stop_laze_golf_course_dialog" );
	
	// blow everything up
	delay[ 0 ] = 4;
	delay[ 1 ] = 4;
	assert( isdefined( delay[ groupNum ] ) );
	if ( !forced )
	{
		wait delay[ groupNum ];
		wait 3;
	}
	exploder( groupNum );
	wait 1;
	
	// rumble
	playRumbleOnPosition( "arcadia_artillery_rumble", soundEnt.origin );
	
	// explosion sounds
	soundEnt delayThread( 0.0, ::play_sound_in_space, "mortar_explosion_dirt" );
	soundEnt delayThread( 0.7, ::play_sound_in_space, "mortar_explosion_dirt" );
	soundEnt delayThread( 1.8, ::play_sound_in_space, "mortar_explosion_dirt" );
	
	// swap the geo
	before = get_golf_geo( "golf_before", groupNum );
	assert( before.size > 0 );
	array_call( before, ::hide );
	after = get_golf_geo( "golf_after", groupNum );
	assert( after.size > 0 );
	array_call( after, ::show );
	
	if ( groupNum == 0 )
	{
		flag_set( "stealth_bombed_0" );
		objective_additionalposition( 0, 0, ( 0, 0, 0 ) );
	}
	if ( groupNum == 1 )
	{
		flag_set( "stealth_bombed_1" );
		objective_additionalposition( 0, 1, ( 0, 0, 0 ) );
	}
}

golf_course_battle()
{
	thread golf_course_vehicles();
	
	flag_wait( "golf_course_battle" );
	
	// delete stryker when the player goes through the house
	level.stryker connectPaths();
	level.stryker delete();
	
	thread objective_laze_golfcourse();
	thread laze_golf_course_dialog();
	
	level.player thread waterfx();
	
	array_thread( getentarray( "golf_course_enemy_spawner", "targetname" ), ::golf_course_battle_enemy_think );
}

laze_golf_course_dialog()
{
	level endon( "second_bridge" );
	level endon( "stop_laze_golf_course_dialog" );
	
	while( 1 )
	{
		// Ramirez, use your laser designator to call in artillery on those vehicles!
		level.foley dialogue_queue( "arcadia_fly_laserdes" );
		
		wait 20;
		
		// Ramirez, call artrillery on the enemy vehicles! Use your laser designator!
		level.foley dialogue_queue( "arcadia_fly_callartillery" );
		
		wait 20;
	}
}

golf_course_vehicles()
{
	flag_wait( "golf_course_vehicles" );
	
	vehicle_spawners = getvehiclespawnerarray( "golf_course_vehicle" );
	
	foreach( spawner in vehicle_spawners )
	{
		vehicle = spawner spawn_vehicle();
		vehicle.targets = spawner get_linked_ents();
		
		if ( vehicle.vehicleType == "bmp" )
			vehicle thread golf_course_bmp_think();
		
		vehicle thread golf_course_vehicle_kill_on_artillery();
	}
	
	array_thread( getentarray( "golf_course_zpu", "targetname" ), ::golf_course_zpu );
}

golf_course_vehicle_kill_on_artillery()
{
	assert( isdefined( self.script_group ) );
	
	killflag = "stealth_bombed_" + self.script_group;
	flag_wait( killflag );
	wait 1;
	
	if ( isalive( self ) )
		self kill();
	if ( isdefined( self ) )
		self notify( "death" );
}

golf_course_fake_choppers()
{
	spawners = getentarray( "fake_golf_course_chopper", "targetname" );
	foreach( spawner in spawners )
		spawner hide();
	
	flag_wait( "golf_course_vehicles" );
	thread golf_course_fake_choppers_stop();
	
	moveTime = 65000 / FAKE_CHOPPER_SPEED;
	
	level endon( "delete_all_fake_choppers" );
	
	count = 0;
	numBeforePause = randomintrange( GOLF_COURSE_FAKE_CHOPPER_COUNT_MIN, GOLF_COURSE_FAKE_CHOPPER_COUNT_MAX );
	for(;;)
	{
		spawners = array_randomize( spawners );
		foreach( spawner in spawners )
		{
			target = getstruct( spawner.target, "targetname" );
			spawner thread fake_chopper_create_and_move( moveTime, target.origin );
			count++;
			if ( count >= numBeforePause )
			{
				count = 0;
				numBeforePause = randomintrange( GOLF_COURSE_FAKE_CHOPPER_COUNT_MIN, GOLF_COURSE_FAKE_CHOPPER_COUNT_MAX );
				wait randomfloatrange( GOLF_COURSE_FAKE_CHOPPER_PAUSE_MIN, GOLF_COURSE_FAKE_CHOPPER_PAUSE_MAX );
			}
			else
				wait randomfloatrange( GOLF_COURSE_FAKE_CHOPPER_SPACING_MIN, GOLF_COURSE_FAKE_CHOPPER_SPACING_MAX );
		}
	}
}

golf_course_fake_choppers_stop()
{
	flag_wait( "golf_course_vehicles_stop" );
	level notify( "delete_all_fake_choppers" );
}

golf_course_zpu()
{
	assert( isdefined( self.script_group ) );
	group = self.script_group;
	
	spawner = undefined;
	trigger = undefined;
	
	targets = getentarray( self.target, "targetname" );
	foreach( target in targets )
	{
		if ( issubstr( target.classname, "actor" ) )
			spawner = target;
		else if ( issubstr( target.classname, "trigger" ) )
			trigger = target;
	}
	assert( isdefined( spawner ) );
	assert( isspawner( spawner ) );
	
	gunner = spawner spawn_ai();
	gunner.animname = "zpu_gunner";
	assert( isalive( gunner ) );
	
	zpu = spawn_anim_model( "zpu_turret", self.origin );
	zpu.angles = self.angles;
	zpu.script_group = group;
	self delete();
	
	gunner linkTo( zpu, "tag_driver" );
	
	thread zpu_death( zpu, gunner, trigger );
	thread zpu_death_gunner( zpu, gunner, trigger );
	if ( isdefined( trigger ) )
		thread zpu_gunner_dismount( zpu, gunner, trigger );
	
	zpu thread golf_course_vehicle_kill_on_artillery();
	
	zpu endon( "death" );
	gunner endon( "death" );
	
	zpu endon( "stop_shooting" );
	gunner endon( "stop_shooting" );
	
	for(;;)
	{
		anime = "fire_a";
		sound = "weap_zpu_fire_anim_a";
		if ( cointoss() )
		{
			anime = "fire_b";
			sound = "weap_zpu_fire_anim_b";
		}
		zpu thread play_sound_on_entity( sound );
		zpu thread anim_single_solo( gunner, anime , "tag_driver" );
		zpu anim_single_solo( zpu, anime );
	}
}

zpu_death( zpu, gunner, trigger )
{
	zpu waittill( "death" );
	
	zpu_stop_shooting( zpu, gunner );
	
	playFX( getfx( "zpu_explode" ), zpu.origin );
	thread play_sound_in_space( "exp_armor_vehicle", zpu.origin );
	zpu setmodel( "vehicle_zpu4_burn" );
}

zpu_death_gunner( zpu, gunner, trigger )
{
	gunner endon( "dismount" );
	
	gunner waittill( "damage_notdone" );
	
	zpu_stop_shooting( zpu, gunner );
	
	zpu anim_single_solo( gunner, "gunnerdeath", "tag_driver" );
	zpu thread anim_loop_solo( gunner, "death_idle", "stop_death_loop", "tag_driver" );
}

zpu_gunner_dismount( zpu, gunner, trigger )
{
	zpu endon( "death" );
	gunner endon( "death" );
	
	trigger waittill( "trigger" );
	
	gunner notify( "dismount" );
	
	zpu_stop_shooting( zpu, gunner );
	gunner.allowdeath = true;
	gunner.noragdoll = true;
	gunner unlink();
	zpu anim_single_solo( gunner, "dismount" , "tag_driver" );	
}

zpu_stop_shooting( zpu, gunner )
{
	zpu notify( "stop_shooting" );
	zpu anim_stopanimscripted();
	zpu StopSounds();
	if ( isalive( gunner ) )
	{
		gunner notify( "stop_shooting" );
		gunner anim_stopanimscripted();
	}
	zpu setAnim( level.scr_anim[ zpu.animname ][ "idle" ], 1.0, 0, 1 );
}

zpu_shoot1( gun )
{
	playfxontag( getfx( "zpu_muzzle" ), gun, "tag_flash" );
	playfxontag( getfx( "zpu_muzzle" ), gun, "tag_flash2" );
}

zpu_shoot2( gun )
{
	playfxontag( getfx( "zpu_muzzle" ), gun, "tag_flash1" );
	playfxontag( getfx( "zpu_muzzle" ), gun, "tag_flash3" );
}

golf_course_bmp_think()
{
	if ( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "bmp" ) )
		level.bmp = self;
	
	assert( isdefined( self.targets ) );
	
	self endon( "death" );
	self endon( "attacking_player" );
	
	for(;;)
	{
		self SetTurretTargetVec( self.targets[ randomint( self.targets.size ) ].origin );
		wait randomfloatrange( 0.5, 1.5 );
		shots = randomintrange( 2, 7 );
		for( i = 0 ; i < shots ; i++ )
		{
			self FireWeapon();
			wait 0.3;
		}
	}
}

golf_course_battle_enemy_think()
{
	guy = self spawn_ai( true );
	assert( isalive( guy ) );
	guy.goalradius = 16;
	
	guy endon( "death" );
	
	assert( isdefined( self.target ) );
	node = getNode( self.target, "targetname" );
	assert( isdefined( node ) );
	
	guy setGoalNode( node );
	
	// make AI shoot down range at fake targets
	targets = getentarray( "golf_enemy_target", "targetname" );
	guy setEntityTarget( targets[ randomint( targets.size ) ] );
	
	if ( !isdefined( node.target ) )
		return;
	nextNode = getnode( node.target, "targetname" );
	assert( isdefined( nextNode ) );
	
	wait randomfloatrange( 9.0, 11.0 );
	
	guy setGoalNode( nextNode );
}
/*
golf_course_mortars()
{
	mortars = getentarray( "golf_course_mortar", "targetname" );
	
	for(;;)
	{
		mortars = array_randomize( mortars );
		
		foreach( mortar in mortars )
		{	
			assert( isdefined( mortar.script_noteworthy ) );
			surface = mortar.script_noteworthy;
			mortarID = "mortar_" + surface;
			assert( isdefined( level._effect[ mortarID ] ) );
			
			fx = level._effect[ mortarID ];
			assert( isdefined( level.scr_sound[ mortarID ] ) );
			sound = level.scr_sound[ mortarID ];
			
			mortar play_sound_in_space( level.scr_sound[ "mortar_incomming" ], mortar.origin );
			playFX( fx, mortar.origin );
			mortar thread play_sound_in_space( level.scr_sound[ mortarID ], mortar.origin );
			
			wait randomfloatrange( MORTAR_TIME_MIN, MORTAR_TIME_MAX );
		}
	}
}
*/

crashing_c130()
{
	flag_wait( "crashing_c130" );
	
	c130 = spawn_vehicle_from_targetname_and_drive( "c130_spawner" );
	pos = c130.origin;
	c130 thread play_sound_on_entity( "scn_arcadia_c130_goingdown" );
	
	exploder( "tanker_explosion_tall" );
	thread sun_blocker();
	
	thread crashing_c130_secondary_explosions( c130 );
	while( isdefined( c130 ) )
	{
		pos = c130.origin;
		playFXOnTag( getfx( "jet_engine_crashing" ), c130, "tag_prop_l_1" );
		playFXOnTag( getfx( "jet_engine_crashing" ), c130, "tag_prop_r_2" );
		wait 0.1;
	}
}

crashing_c130_secondary_explosions( vehicle )
{
	wait 6.5;
	if ( isdefined( vehicle ) )
	{
		playFXOnTag( getfx( "c130_engine_secondary_exp" ), vehicle, "tag_prop_l_1" );
		vehicle thread play_sound_on_entity( "scn_arcadia_c130_explosions" );
	}
	
	wait 1.5;
	if ( isdefined( vehicle ) )
	{
		playFXOnTag( getfx( "c130_engine_secondary_exp" ), vehicle, "tag_prop_l_1" );
		vehicle thread play_sound_on_entity( "scn_arcadia_c130_explosions" );
	}
	
	wait 2.0;
	if ( isdefined( vehicle ) )
	{
		playFXOnTag( getfx( "c130_engine_secondary_exp" ), vehicle, "tag_prop_l_1" );
		vehicle thread play_sound_on_entity( "scn_arcadia_c130_explosions" );
	}
}

sun_blocker()
{
	fx_origin = ( 13635.8, -6606.73, 2825.83 );
	fx_angles = ( 270, 114.597, 5.40301 );
	fx_id = "airplane_crash_smoke_sun_blocker";
	
	wait 4;
	
	for(;;)
	{
		// cover the sun
		ent = spawn( "script_model", fx_origin );
		ent.angles = fx_angles;
		ent setmodel( "tag_origin" );
		PlayFXOnTag( getfx( fx_id ), ent, "tag_origin" );
		
		// wait till we are to the side
		flag_wait( "remove_sun_blocker" );
		
		// don't block the sun when we're here
		ent delete();
		
		// once we go back out to the main area block the sun again
		flag_waitopen( "remove_sun_blocker" );
	}
	
	
}

harriers()
{
	flag_wait( "harriers_spawn" );
	
	harriers = spawn_vehicles_from_targetname( "harrier" );
	foreach( harrier in harriers )
	{
		harrier SetGoalYaw( harrier.angles[ 1 ] );
		harrier SetVehGoalPos( harrier.origin, true );
		harrier godon();
		harrier setHoverParams( randomintrange( 80, 120 ), randomintrange( 50, 80 ), randomintrange( 10, 20 ) ); //<radius>, <speed>, <accel>
	}
	
	flag_wait( "harriers_move" );
	
	foreach( i, harrier in harriers )
	{
		thread gopath( harrier );
		harrier thread harrier_fire_missiles( i + 2 );
		wait 2.0;
	}
}

harrier_fire_missiles( num )
{
	wait 15;
	if ( !isalive( self ) )
		return;
	
	self setVehWeapon( "harrier_FFAR" );
	
	tag[ 0 ] = "tag_right_alamo_missile";
	tag[ 1 ] = "tag_left_alamo_missile";
	nextTag = 0;
	
	for( i = 0 ; i < num ; i++ )
	{
		self fireWeapon( tag[ nextTag ], undefined, (0,0,-250) );
		
		nextTag++;
		if ( nextTag >= tag.size )
			nextTag = 0;
		
		wait 0.4;
	}
}

vehicle_path_disconnector()
{
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	zone notsolid();
	zone.origin -= ( 0, 0, 1024 );
	badplaceName = "vehicle_bad_place_brush_" + zone getEntityNumber();

	for ( ;; )
	{
		self waittill( "trigger", vehicle );
		
		if ( !isalive( level.stryker ) )
			return;
		
		if ( !isdefined( vehicle ) )
			continue;
		
		if ( vehicle != level.stryker )
			continue;
		
		if ( vehicle vehicle_getspeed() == 0 )
		{
			prof_end( "vehicle_path_disconnect" );
			continue;
		}

		if ( !isdefined( zone.pathsDisconnected ) )
		{
			zone solid();

			badplace_brush( badplaceName, 0, zone, "allies", "axis" );

			zone notsolid();
			zone.pathsDisconnected = true;
		}

		thread vehicle_reconnects_paths( zone, badplaceName );
	}
}

vehicle_reconnects_paths( zone, badplaceName )
{
	assert( isdefined( zone ) );
	assert( isdefined( badplaceName ) );
	zone notify( "waiting_for_path_reconnection" );
	zone endon( "waiting_for_path_reconnection" );
	wait 0.5;

	zone solid();
	badplace_delete( badplaceName );
	zone notsolid();
	zone.pathsDisconnected = undefined;
}

evac_chopper_1()
{
	self endon( "death" );
	
	wait 7;
	
	rpg = getent( "evac_chopper_1_rpg", "targetname" );
	d = distance( rpg.origin, self.origin );
	d *= 1.2;
	missile_CreateAttractorEnt( self, 100000, d );
	magicBullet( "rpg_straight", rpg.origin, self.origin );
	
	self waittill( "damage" );
	
	if ( isalive( self ) )
		self kill();
}

civilian_car()
{
	flag_wait( "civilian_car" );
	
	car = spawn_vehicle_from_targetname_and_drive( "civilian_car" );
	assert( isdefined( car ) );
	car endon( "death" );
	
	car thread civilian_car_luggage();
	
	clip = getent( "civilian_car_clip", "targetname" );
	badplace_brush( "civilian_car_badplace", 12, clip, "allies", "axis" );
	
	car waittill( "reached_end_node" );
	car doDamage( 500000, car.origin, level.player );
}

civilian_car_luggage()
{
	civilian_car_dummy = getent( "civilian_car_dummy", "targetname" );
	civilian_car_dummy_direction_vec = getent( civilian_car_dummy.target, "targetname" );
	civilian_car_dummy_direction_vec linkto( civilian_car_dummy );
	
	civilian_car_luggage[ 0 ] = getent( "civilian_car_luggage_1", "targetname" );
	civilian_car_luggage[ 1 ] = getent( "civilian_car_luggage_2", "targetname" );
	civilian_car_luggage[ 2 ] = getent( "civilian_car_luggage_3", "targetname" );
	civilian_car_luggage[ 3 ] = getent( "civilian_car_luggage_4", "targetname" );
	civilian_car_luggage[ 4 ] = getent( "civilian_car_luggage_5", "targetname" );
	civilian_car_luggage[ 5 ] = getent( "civilian_car_luggage_6", "targetname" );
	
	foreach( piece in civilian_car_luggage )
		piece LinkTo( civilian_car_dummy );
	
	civilian_car_dummy.origin = self.origin;
	civilian_car_dummy.angles = self.angles;
	civilian_car_dummy LinkTo( self );
	
	wait 6.5;
	
	// Do physics on the models
	vec = vectorNormalize( civilian_car_dummy_direction_vec.origin - civilian_car_dummy.origin );
	foreach( piece in civilian_car_luggage )
	{
		wait randomfloatrange( 0.05, 0.15 );
		piece unlink();
		scale = randomfloatrange( 9000, 10000 );
		piece PhysicsLaunchClient( piece.origin, vec * scale );
		//thread draw_line_for_time( piece.origin, piece.origin + ( vec * scale ), 1, 1, 1, 5.0 );
	}
	
	civilian_car_dummy delete();
	civilian_car_dummy_direction_vec delete();
}

stryker_damage_monitor()
{
	fullHealth = self.health - self.healthbuffer;
	
	SMOKE_1 = fullHealth * 0.75;
	SMOKE_2 = fullHealth * 0.60;
	SMOKE_3 = fullHealth * 0.45;
	
	self endon( "death" );
	
	self ent_flag_init( "smoke1" );
	self ent_flag_init( "smoke2" );
	self ent_flag_init( "smoke3" );
	
	for(;;)
	{
		self waittill( "damage" );
		
		health = self.health - self.healthbuffer;
		
		if ( ( health <= SMOKE_1 ) && ( !self ent_flag( "smoke1" ) ) )
		{
			self ent_flag_set( "smoke1" );
			thread stryker_damage_smoke( "tag_cargofire" );
		}
		
		if ( ( health <= SMOKE_2 ) && ( !self ent_flag( "smoke2" ) ) )
		{
			self ent_flag_set( "smoke2" );
			thread stryker_damage_smoke( "tag_turret" );
		}
		
		if ( ( health <= SMOKE_3 ) && ( !self ent_flag( "smoke3" ) ) )
		{
			self ent_flag_set( "smoke3" );
			thread stryker_damage_smoke( "tag_cargofire" );
		}
		
		wait 0.05;
	}
}

stryker_damage_smoke( tagName )
{
	self endon( "death" );
	
	fx = getfx( "stryker_smoke" );
	for(;;)
	{
		playFXOnTag( fx, self, tagName );
		wait 0.1;
	}
}

delete_ai_trigger()
{
	self waittill( "trigger" );
	
	assert( isdefined( self.target ) );
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	
	enemies = getaiarray( "axis" );
	enemies_to_kill = [];
	foreach( enemy in enemies )
	{
		if ( !enemy isTouching( zone ) )
			continue;
		enemies_to_kill[ enemies_to_kill.size ] = enemy;
	}
	
	if ( enemies_to_kill.size == 0 )
		return;
	
	array_thread( enemies_to_kill, ::delete_ai_after_delay );
}

delete_ai_after_delay()
{
	self endon( "death" );
	
	wait randomfloatrange( 0, 1.0 );
	
	if ( isalive( self ) )
		self delete();
}

opening_rpgs()
{
	nextOrg = undefined;
	
	if ( issubstr( self.classname, "trigger" ) )
	{
		assert( isdefined( self.target ) );
		self waittill( "trigger" );
		nextOrg = getent( self.target, "targetname" );
	}
	else
	{
		wait 6;
		nextOrg = self;
	}
	
	for(;;)
	{
		assert( isdefined( nextOrg ) );
		
		magicBullet( "rpg_straight", nextOrg.origin, level.stryker.origin + ( 0, 0, 60 ) );
		
		if ( !isdefined( nextOrg.target ) )
			return;
		nextOrg = getent( nextOrg.target, "targetname" );
		
		wait randomfloatrange( 1.0, 2.0 );
	}
}

ai_avoid_stryker()
{
	self notify( "ai_avoid_stryker" );
	self endon( "ai_avoid_stryker" );
	
	self endon( "death" );
	
	fov = cos( 90 );
	maxdist = 400 * 400;
	
	while( 1 )
	{
		wait 0.2;
		
		if ( !isalive( level.stryker ) )
			break;
		
		if ( flag( "disable_friendly_move_checks" ) )
			break;
		
		withinDist = ( distanceSquared( self.origin, level.stryker.origin ) <= maxdist );
		withinFOV = within_fov( self.origin, self.angles, level.stryker.origin, fov );
		
		//self.cqbwalking
		if ( withinDist && withinFOV )
			self cqb_walk( "on" );
		else
			self cqb_walk( "off" );
	}
	
	self cqb_walk( "off" );
}

pool()
{
	trigger = getent( "pool", "targetname" );
	
	while( 1 )
	{
		trigger waittill( "trigger", player );
		if ( !isplayer( player ) )
			continue;
		
		while( player isTouching( trigger ) )
		{
			player setMoveSpeedScale( 0.3 );
			player allowStand( true );
			player allowCrouch( false );
			player allowProne( false );
			wait 0.1;
		}
		
		player setMoveSpeedScale( 1 );
		player allowStand( true );
		player allowCrouch( true );
		player allowProne( true );
	}
}

all_enemies_low_health()
{
	wait 0.05;
	flag_wait( "all_enemies_low_health" );
	axis = getaiarray( "axis" );
	foreach( guy in axis )
	{
		if ( isalive( guy ) )
			guy.health = 1;
	}
}

foley_leads_through_mansion()
{
	flag_wait( "foley_purple" );
	level.foley thread set_force_color( "p" );
	
	flag_waitopen( "foley_purple" );
	level.foley thread set_force_color( "g" );
}

stryker_run_over_player_monitor()
{
	level.stryker endon( "death" );
	fov = cos( 35 );
	dialogIndex = 0;
	
	while( isalive( level.stryker ) )
	{
		wait 0.1;
		
		// check to see if stryker is moving
		speed = level.stryker vehicle_GetSpeed();
		if ( speed <= 1 )
			continue;
		
		if ( flag( "disable_stryker_dialog" ) )
			continue;
		
		// is player nearby?
		d = distance( level.player.origin, level.stryker.origin );
		if ( d > 450 )
			continue;
		
		// is player in front of the vehicle and about to get ran over?
		withinFOV = within_fov( level.stryker.origin, level.stryker.angles, level.player.origin, fov );
		if ( !withinFOV )
			continue;
		
		if ( dialogIndex == 0 )
		{
			dialogIndex = 1;
			// Ramirez! You're gonna get run over! Get outta their way!
			level.foley dialogue_queue( "arcadia_fly_getrunover" );
		}
		else
		{
			dialogIndex = 0;
			// Ramirez! Honey Badger's moving! Get outta their way!
			level.dunn dialogue_queue( "arcadia_cpd_getoutta" );
		}
		
		wait 3;
	}
}

force_trigger_on_flag( flagString )
{
	self endon( "trigger" );
	flag_wait( flagString );
	self thread activate_trigger_process( level.player );
}

block_progression_until_artillery()
{
	trigger_off( "friendly_trigger_at_artillery", "script_noteworthy" );
	flag_wait( "stealth_bombed_1" );
	trigger_on( "friendly_trigger_at_artillery", "script_noteworthy" );
}

bmps_kill_player_before_artillery()
{
	level endon( "stealth_bombed_1" );
	
	flag_wait( "bmp_kills_player" );
	
	if ( !isdefined( level.bmp ) )
		return;
	
	// stop shooting random targets
	level.bmp endon( "death" );
	level.bmp notify( "attacking_player" );
	
	// shoot at the player
	for(;;)
	{
		level.bmp SetTurretTargetEnt( level.player, ( 0, 0, 20 ) );
		wait randomfloatrange( 0.5, 1.5 );
		shots = randomintrange( 8, 15 );
		for( i = 0 ; i < shots ; i++ )
		{
			level.bmp FireWeapon();
			wait 0.2;
		}
	}
}

bmps_force_kill_player()
{
	level endon( "stealth_bombed_1" );
	
	flag_wait( "bmp_force_kills_player" );
	
	level.player kill();
}

force_artillery_if_player_bypasses()
{
	level endon( "stealth_bombed_0" );
	flag_wait( "force_artillery_0" );
	
	thread laser_artillery( 0, true );
}

stryker_threats_eliminated_dialog_1()
{
	flag_wait( "honey_badger_threats_dead_1" );
	
	if ( flag( "disable_stryker_dialog" ) )
		return;
	
	// Thanks for the assist, Hunter Two-One.
	thread radio_dialogue( "arcadia_str_thanks" );
}

stryker_threats_eliminated_dialog_2()
{
	flag_wait( "honey_badger_threats_dead_2" );
	
	if ( flag( "disable_stryker_dialog" ) )
		return;
	
	// Nice work, Hunter Two-One. Thanks for the assist.
	thread radio_dialogue( "arcadia_str_nicework" );
}

set_cull_dist( dist )
{
	assert( isdefined( dist ) );
	
	if ( getdvarint( "r_arcadia_culldist" ) == 0 )
		return;
	
	setCullDist( dist );
}