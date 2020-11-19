#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

UPDATE_TIME = 0.05;		// Time between player input checks.
BLEND_TIME = 0.5;		// Blend time for lean animations.
STEER_MIN = -1.0;
STEER_MAX = 1.0;
TURN_ANIM_RATE_MULTIPLIER = 0.5;
CONST_MPHCONVERSION = 17.6;

SHOOT_BLEND_TIME = 0.1;
SHOOT_ARM_UP_DELAY = 1.0;
SHOOT_FIRE_TIME = 0.05;
SHOOT_AMMO_COUNT = 32;

SLEEVE_FLAP_SPEED = 65.0;
SLEEVE_FLAP_MAX_RATE = 1.5;
SLEEVE_FLAP_MIN_RATE = 0.75;
SLEEVE_FLAP_MAX_WEIGHT = 1.0;
SLEEVE_FLAP_MIN_WEIGHT = 0.1;

TACH_BLEND_UP = 0.2;
TACH_BLEND_DOWN = 1.3;
TACH_RAND_UP = 0.3;
TACH_RAND_DOWN = 0.8;
SPEEDOMETER_MAX_SPEED = 180.0;
SPEEDOMETER_BLEND_TIME = 0.1;
THROTTLE_BLEND_TIME = 0.08;
STEERING_BLEND_TIME = 0.08;


snowmobile_preLoad( playerHandModel, playerSnowmobileModel )
{
	flag_init( "player_can_die_on_snowmobile" );
	flag_set( "player_can_die_on_snowmobile" );

	// set player hand model
	if ( !isdefined( playerHandModel ) )
		level.snowmobile_playerHandModel = "ch_viewhands_player_gk_ar15";
	else
		level.snowmobile_playerHandModel = playerHandModel;

	// set player snowmobile model
	if ( !isdefined( playerSnowmobileModel ) )
		level.snowmobile_playerSnowmobileModel = "vehicle_snowmobile_player";
	else
		level.snowmobile_playerSnowmobileModel = playerSnowmobileModel;

	// set gun
	if ( !isdefined( level.snowmobile_gunModel ) )
		level.snowmobile_gunModel = "viewmodel_glock";
	level.snowmobile_gun = "snowmobile_glock";

	// precahe models and itmes
	PreCacheModel( level.snowmobile_playerHandModel );
	PreCacheModel( level.snowmobile_playerSnowmobileModel );
	PreCacheModel( level.snowmobile_gunModel );
	PreCacheItem( level.snowmobile_gun );
	PreCacheRumble( "pistol_fire_auto" );

	// load gun effects
	level.snowmobile_gunFlashFx = LoadFX( "muzzleflashes/uzi_flash_view" );
	level.snowmobile_gunShellFx = LoadFX( "shellejects/pistol_view" );

	snowmobile_anims();

	// Hold ^3[{+speed_throw}]^7 to shoot.
	add_hint_string( "snowmobile_attack_player1", &"SCRIPT_PLATFORM_SNOWMOBILE_ATTACK", ::should_stop_snowmobile_attack_hint_player1 );
	add_hint_string( "snowmobile_attack_player2", &"SCRIPT_PLATFORM_SNOWMOBILE_ATTACK", ::should_stop_snowmobile_attack_hint_player2 );
	// Hold ^3[{+attack}]^7 to drive.
	add_hint_string( "snowmobile_drive_player1", &"SCRIPT_PLATFORM_SNOWMOBILE_DRIVE", ::should_stop_snowmobile_drive_hint_player1 );
	add_hint_string( "snowmobile_drive_player2", &"SCRIPT_PLATFORM_SNOWMOBILE_DRIVE", ::should_stop_snowmobile_drive_hint_player2 );
	// Press ^3[{+stance}]^7 to go in reverse.
	add_hint_string( "snowmobile_reverse_player1", &"SCRIPT_PLATFORM_SNOWMOBILE_REVERSE", ::should_stop_snowmobile_reverse_hint_player1 );
	add_hint_string( "snowmobile_reverse_player2", &"SCRIPT_PLATFORM_SNOWMOBILE_REVERSE", ::should_stop_snowmobile_reverse_hint_player2 );
}

drive_vehicle()
{
	Assert( self.code_classname == "script_vehicle" );
	vehicle = self;
	vehicle MakeUsable();

	self waittill( "vehicle_mount", player );
	Assert( IsDefined( player ) );
	Assert( player.classname == "player" );
	
	if ( !player ent_flag_exist( "player_shot_on_snowmobile" ) )
		player ent_flag_init( "player_shot_on_snowmobile" );
	
	attack_hint_string = "snowmobile_attack_player1";
	drive_hint_string = "snowmobile_drive_player1";
	if ( player != level.player )
	{
		assert( is_in_array( level.players, player ) );
		attack_hint_string = "snowmobile_attack_player2";
		drive_hint_string = "snowmobile_drive_player2";
	}
	player delayThread( 20, ::display_hint, attack_hint_string );
	player delayThread( 3, ::display_hint, drive_hint_string );

	delayThread( 3, ::add_snowmobile_autosave_checks );

	vehicle.player = player;
	player.vehicle = vehicle;
	
	vehicle thread add_rumble_for_notify( "veh_landed", "damage_heavy", player );
	vehicle thread add_rumble_for_notify( "veh_jolt", "damage_light", player );

	vehicle.snowmobile_3rdPersonModel = vehicle.model;
	vehicle.snowmobileAmmoCount = SHOOT_AMMO_COUNT;

	vehicle.animname = "snowmobile_player";
	vehicle assign_animtree();

	vehicle MakeUnusable();
	vehicle DontCastShadows();

	player thread reverse_hint( vehicle );
	player thread drive_target_enemy( vehicle );
	player thread drive_crash_detection( vehicle );
	player thread drive_camera( vehicle );

	player thread drive_notetrack_sounds( vehicle, "pullout_anim" );
	player thread drive_notetrack_sounds( vehicle, "fire_anim" );
	player thread drive_notetrack_sounds( vehicle, "reload_anim" );
	player thread drive_notetrack_sounds( vehicle, "putaway_anim" );

	if ( is_coop() )
		player thread make_coop_vehicle( vehicle );
	if ( is_specialop() )
		vehicle thread handle_riders( player );

	player drive_switch_to_1st_person( vehicle );
	vehicle waittill_either( "vehicle_dismount", "death" );
	player drive_switch_to_3rd_person( vehicle );

	remove_extra_autosave_check( "snowmobile_speed" );
	remove_extra_autosave_check( "snowmobile_fov" );
	player.vehicle = undefined;
}

add_rumble_for_notify( message, rumble, player )
{
	self endon( "vehicle_dismount" );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( message );
		player playrumbleonentity( rumble );
	}
}

handle_riders( player )
{
	wait 0.05;
	if ( !isdefined( self ) )
		return;
	if ( !isalive( player ) )
		return;
	
	array_call( self.riders, ::hideOnClient, player );
	
	foreach( rider in self.riders )
	{
		rider hideOnClient( player );
		rider place_weapon_on( "usp", "left" );
		rider.primaryweapon = "usp";
	}
	
	if ( is_coop() )
	{
		array_thread( self.riders, ::set_ignoreall, true );
		array_thread( self.riders, ::magic_bullet_shield );
	}
	else
	{
		array_call( self.riders, ::Delete );
	}
}

add_snowmobile_autosave_checks()
{
	add_extra_autosave_check( "snowmobile_speed", ::snowmobile_autosave_check, "^3Player was riding too slow" );
	if ( IsDefined( level.snowmobile_path ) )
		add_extra_autosave_check( "snowmobile_fov", ::snowmobile_fov_check, "Player was pointed the wrong way" );
}

reverse_hint( vehicle )
{
	self endon( "death" );
	vehicle endon( "vehicle_dismount" );
	vehicle endon( "death" );

	vehicle wait_for_vehicle_to_move();

	vehicle.hint_brake_count = 0;
	for ( ;; )
	{
		if ( abs( vehicle.veh_speed ) < 5 )
		{
			vehicle.hint_brake_count++;
			if ( vehicle.hint_brake_count >= 3 )
			{
				reverse_hint_string = "snowmobile_reverse_player1";
				if ( vehicle.player != level.player )
				{
					assert( is_in_array( level.players, vehicle.player ) );
					reverse_hint_string = "snowmobile_reverse_player2";
				}
				vehicle.player.reverse_hint_string = true;
				vehicle.player display_hint( reverse_hint_string );
			}
		}
		else
		{
			vehicle.hint_brake_count = 0;
		}
		wait( 1 );
	}
}

should_stop_snowmobile_reverse_hint_player1()
{
	return level.player should_stop_snowmobile_reverse_hint();
}

should_stop_snowmobile_reverse_hint_player2()
{
	return level.player2 should_stop_snowmobile_reverse_hint();
}

should_stop_snowmobile_reverse_hint()
{
	if ( !isdefined( self.vehicle ) )
		retVal = true;
	else
	if ( !isdefined( self.vehicle.hint_brake_count ) )
		retVal = true;
	else
	if ( self ent_flag_exist( "finish_line" ) && self ent_flag( "finish_line" ) )
		retVal = true;
	else
		retVal = self.vehicle.hint_brake_count < 3;
	
	if ( retVal )
		self.reverse_hint_string = undefined;
	
	return retVal;
}

wait_for_vehicle_to_move()
{
	for ( ;; )
	{
		if ( self.veh_speed > 10 )
			return;
		wait( 1 );
	}
}

make_coop_vehicle( vehicle )
{
	clientOther = level.player2;
	if ( self != level.player )
		clientOther = level.player;
	
	// hide arms and player model from other players
	self hideOnClient( clientOther );
	//vehicle hideOnClient( clientOther );
	
	// use full snowmobile model with high res cockpit for coop
	//wait 0.05;
	//vehicle setModel( "vehicle_snowmobile_co_op" );
}

snowmobile_fov_check()
{
	AssertEx( IsDefined( level.player.targ ), "Tried to do autosave snowmobile fov check with no player targ." );
	player_angles = level.player.vehicle.angles;
	player_angles = ( 0, player_angles[ 1 ], 0 );
	player_forward = AnglesToForward( player_angles );

	node = level.player.targ;
	node_angles = VectorToAngles( node.next_node.origin - node.origin );
	node_angles = ( 0, node_angles[ 1 ], 0 );
	node_forward = AnglesToForward( node_angles );

	dot = VectorDot( player_forward, node_forward );
	return dot > 0.7;
}

snowmobile_autosave_check()
{
	AssertEx( IsDefined( level.player.vehicle ), "Player has no vehicle but tried to do snowmobile autosave" );
	return level.player.vehicle Vehicle_GetSpeed() > 60;
}

drive_target_enemy( vehicle )
{
	vehicle endon( "vehicle_dismount" );
	vehicle endon( "death" );

	for ( ;; )
	{
		ai = GetAIArray( "bad_guys" );
		highest_fov = 0.94;
		enemy = undefined;
		my_org = set_z( self.origin, 0 );

		foreach ( guy in ai )
		{
			his_org = set_z( guy.origin, 0 );
			if ( Distance( his_org, my_org ) > 750 )
				continue;

			fov = get_dot( my_org, self.angles, his_org );
			if ( fov > highest_fov )
			{
				highest_fov = fov;
				enemy = guy;
			}
		}

		self.snowmobile_enemy = enemy;
		wait( 0.2 );
	}
}


drive_crash_detection( vehicle )
{
	vehicle endon( "vehicle_dismount" );
	vehicle endon( "death" );
	level endon( "avalanche_begins" );

	vehicle waittill_vehicle_crashes();

	yaw_velocity = vehicle Vehicle_GetSpeed();
	yaw_velocity *= CONST_MPHCONVERSION;
	velocity = ( 0, yaw_velocity, 64 );

	if ( IsDefined( level.vehicle_crash_func ) )
		self thread [[ level.vehicle_crash_func ]]( vehicle );

	self thread drive_crash_slide( vehicle, velocity );
	self player_dismount_vehicle();
}

waittill_vehicle_crashes()
{
	if ( !is_specialop() )
		level endon( "player_crashes" );// from triggers in the map
	else
		thread waittill_vehicle_falling_so();
		
	self waittill_any( "veh_collision", "veh_falling" );
}

// This could be done cleaner for both SO and SP, but avoiding making changes to Cliffhanger.
waittill_vehicle_falling_so()
{
	trigger_ent = GetEnt( "player_crashes_trigger", "script_noteworthy" );
	while( 1 )
	{
		trigger_ent waittill( "trigger", player );
		if ( !isdefined( player ) || !isplayer( player ) )
			continue;
		if ( player.snowmobile == self )
		{
			self notify( "veh_falling" );
			return;
		}
	}
}


drive_crash_slide( vehicle, velocity )
{
	vehicle waittill( "vehicle_dismount" );

	self BeginSliding( velocity );

	if ( flag( "player_can_die_on_snowmobile" ) )
	{
		if ( isalive( self ) )
			self kill_wrapper();
	}

	wait( 1.0 );

	//self EndSliding();
}


drive_camera( vehicle )
{
	vehicle endon( "vehicle_dismount" );
	vehicle endon( "death" );

	for ( ;; )
	{
		vehicle waittill( "third_person" );
		self drive_switch_to_3rd_person( vehicle );

		vehicle waittill( "first_person" );
		self drive_switch_to_1st_person( vehicle );
	}
}


drive_notetrack_sounds( vehicle, animflag )
{
	vehicle endon( "vehicle_dismount" );
	vehicle endon( "death" );

	for ( ;; )
	{
		vehicle waittill( animflag, notetrack );

		prefix = GetSubStr( notetrack, 0, 3 );

		if ( prefix == "ps_" )
		{
			alias = GetSubStr( notetrack, 3 );
			vehicle PlaySound( alias );
			continue;
		}
	}
}


drive_switch_to_1st_person( vehicle )
{
	if ( IsDefined( vehicle.firstPerson ) )
		return;

	vehicle SetModel( level.snowmobile_playerSnowmobileModel );
	vehicle Attach( level.snowmobile_playerHandModel, "tag_player" );
	vehicle ClearAnim( vehicle getanim( "root" ), 0 );

	vehicle.firstPerson = true;

	self thread drive_firstperson_anims( vehicle );
}


drive_switch_to_3rd_person( vehicle )
{
	if ( !isDefined( vehicle.firstPerson ) )
		return;

	if ( IsDefined( vehicle.gun_attached ) )
	{
		vehicle Detach( level.snowmobile_gunModel, "tag_weapon_left" );
		vehicle.gun_attached = undefined;
	}

	vehicle Detach( level.snowmobile_playerHandModel, "tag_player" );
	vehicle SetModel( vehicle.snowmobile_3rdPersonModel );
	vehicle ClearAnim( vehicle getanim( "root" ), 0 );

	vehicle.firstPerson = undefined;

	vehicle notify( "kill_anims" );
}


drive_firstperson_anims( vehicle )
{
	vehicle endon( "vehicle_dismount" );
	vehicle endon( "death" );
	vehicle endon( "kill_anims" );

	self childthread drive_turning_anims( vehicle );
	self childthread drive_shooting_anims( vehicle );
	self childthread drive_sleeve_anims( vehicle );
	self childthread drive_speedometer_anims( vehicle );
	self childthread drive_tachometer_anims( vehicle );
	self childthread drive_throttle_anims( vehicle );
}


drive_turning_anims( vehicle )
{
	lastDirection = 1;
	movement = 0;

	oldAnim = "turn_right2left_";
	newAnim = "turn_left2right_";
	curAnim = newAnim;

	animLength[ newAnim ][ "L" ] = GetAnimLength( vehicle getanim( newAnim + "L" ) );
	animLength[ newAnim ][ "R" ] = GetAnimLength( vehicle getanim( newAnim + "R" ) );

	animLength[ oldAnim ][ "L" ] = GetAnimLength( vehicle getanim( oldAnim + "L" ) );
	animLength[ oldAnim ][ "R" ] = GetAnimLength( vehicle getanim( oldAnim + "R" ) );

	vehicle SetAnim( vehicle getanim( "left_arm" ), 1.0, 0.0, 1.0 );
	vehicle SetAnim( vehicle getanim( "right_arm" ), 1.0, 0.0, 1.0 );

	vehicle SetAnimLimited( vehicle getanim( curAnim + "L" ), 1.0, BLEND_TIME, 0.0 );
	vehicle SetAnimLimited( vehicle getanim( curAnim + "R" ), 1.0, BLEND_TIME, 0.0 );

	vehicle SetAnimTime( vehicle getanim( curAnim + "L" ), 0.5 );
	vehicle SetAnimTime( vehicle getanim( curAnim + "R" ), 0.5 );

	for ( ;; )
	{
		//-------------------------------------------------------
		// Steer the handlebars based on the player's input
		//-------------------------------------------------------
		movement_last = movement;
		movement = vehicle Vehicle_GetSteering() * -1.0;
		movementChange = movement - movement_last;
		steerValue = movement;
		steerValue = clamp( steerValue, STEER_MIN, STEER_MAX );
		
		//-------------------------------------------------------
		// Blend turn anims on the vehicle with the right weights
		//-------------------------------------------------------

		newDirection = false;
		
		if ( movementChange < 0 )
		{
			// change to turn left anims
			if ( lastDirection != -1 )
				newDirection = true;
			lastDirection = -1;

			oldAnim = "turn_left2right_";
			newAnim = "turn_right2left_";
		}
		if ( movementChange > 0 )
		{
			// change to turn right anims
			if ( lastDirection != 1 )
				newDirection = true;
			lastDirection = 1;

			oldAnim = "turn_right2left_";
			newAnim = "turn_left2right_";
		}
		
		//---------------------------
		// Animate the bars and hands
		//---------------------------

		// See where the opposite animation needs to start so that it matches the previous animations position
		newAnimStartTime[ "L" ] = vehicle GetAnimTime( vehicle getanim( curAnim + "L" ) );
		newAnimStartTime[ "R" ] = vehicle GetAnimTime( vehicle getanim( curAnim + "R" ) );
		
		if ( newDirection )
		{
			newAnimStartTime[ "L" ] = abs( 1 - newAnimStartTime[ "L" ] );
			newAnimStartTime[ "R" ] = abs( 1 - newAnimStartTime[ "R" ] );
		}

		// See what the new animation needs to be to match the player's input
		animTimeGoal = abs( ( steerValue - STEER_MIN ) / ( STEER_MIN - STEER_MAX ) );
		if ( newAnim == "turn_right2left_" )
			animTimeGoal = 1.0 - animTimeGoal;
		animTimeGoal = cap_value( animTimeGoal, 0.0, 1.0 );
		
		if ( animTimeGoal < newAnimStartTime[ "L" ] )
		{
			newAnimStartTime[ "L" ] = animTimeGoal;
		}
		
		// Fix for bug where handlebars would sometimes get stuck left or right when there is no stick movement.
		// Happens when stick goes from one side to the other very quickly within 0.05 server framerate.
		// Just setting newDirection fixes this because it causes it to animate back to where it should be instead of overshooting it's goal time.
		if( newAnimStartTime[ "L" ] > animTimeGoal )
		{
			newDirection = true;
		}
		
		// See how far the new animation needs to travel
		amountChange[ "L" ] = abs( animTimeGoal - newAnimStartTime[ "L" ] );
		amountChange[ "R" ] = abs( animTimeGoal - newAnimStartTime[ "R" ] );

		// See what animrate we should play the animation at so that it reaches the animGoalTime over UPDATE_TIME time.
		if ( movementChange == 0 )
		{
			estimatedAnimRate[ "L" ] = 0;
			estimatedAnimRate[ "R" ] = 0;
		}
		else
		{
			estimatedAnimRate[ "L" ] = abs( ( animLength[ newAnim ][ "L" ] / UPDATE_TIME ) * amountChange[ "L" ] ) * TURN_ANIM_RATE_MULTIPLIER;
			estimatedAnimRate[ "R" ] = abs( ( animLength[ newAnim ][ "R" ] / UPDATE_TIME ) * amountChange[ "R" ] ) * TURN_ANIM_RATE_MULTIPLIER;
		}

		if ( newDirection )
		{
			// clear the anim from the other direction
			vehicle ClearAnim( vehicle getanim( oldAnim + "L" ), 0 );
			vehicle ClearAnim( vehicle getanim( oldAnim + "R" ), 0 );

			// set the time on the new direction anim so it doesn't start animating from the beginning,
			// since the previous anim probably wasn't at the end
			vehicle SetAnimLimited( vehicle getanim( newAnim + "L" ), 1, BLEND_TIME, estimatedAnimRate[ "L" ] );
			vehicle SetAnimLimited( vehicle getanim( newAnim + "R" ), 1, BLEND_TIME, estimatedAnimRate[ "R" ] );

			vehicle SetAnimTime( vehicle getanim( newAnim + "L" ), newAnimStartTime[ "L" ] );
			vehicle SetAnimTime( vehicle getanim( newAnim + "R" ), newAnimStartTime[ "R" ] );
		}
		else
		{
			vehicle SetAnimLimited( vehicle getanim( newAnim + "L" ), 1, BLEND_TIME, estimatedAnimRate[ "L" ] );
			vehicle SetAnimLimited( vehicle getanim( newAnim + "R" ), 1, BLEND_TIME, estimatedAnimRate[ "R" ] );
		}

		curAnim = newAnim;

		wait UPDATE_TIME;
	}
}


drive_magic_bullet( vehicle )
{
	start = vehicle GetTagOrigin( "tag_flash" );

	if ( IsAlive( self.snowmobile_enemy ) )
	{
		end = self.snowmobile_enemy GetEye();
	}
	else
	{
		angles = vehicle GetTagAngles( "tag_flash" );
		forward = AnglesToForward( angles );
		end = start + forward * 1500;
	}

	self PlayRumbleOnEntity( "pistol_fire_auto" );
	MagicBullet( level.snowmobile_gun, start, end, self );

	PlayFXOnTag( level.snowmobile_gunFlashFx, vehicle, "tag_flash" );
	PlayFXOnTag( level.snowmobile_gunShellFx, vehicle, "tag_brass" );
}


drive_blend_anims_with_steering( vehicle, animflag, endNotify, leftAnim, centerAnim, rightAnim )
{
	vehicle endon( endNotify );

	vehicle SetFlaggedAnimRestart( animflag, vehicle getanim( leftAnim ), 0.001, STEERING_BLEND_TIME, 1.0 );
	vehicle SetFlaggedAnimRestart( animflag, vehicle getanim( centerAnim ), 0.001, STEERING_BLEND_TIME, 1.0 );
	vehicle SetFlaggedAnimRestart( animflag, vehicle getanim( rightAnim ), 0.001, STEERING_BLEND_TIME, 1.0 );

	for ( ;; )
	{
		steerValue = vehicle Vehicle_GetSteering() * -1.0;
		steerValue = clamp( steerValue, STEER_MIN, STEER_MAX );

		// never set a weight to zero so that all the anims continue to play
		if ( steerValue >= 0.0 )
		{
			leftWeight = 0.001;
			centerWeight = -0.999 * steerValue + 1.0;
			rightWeight = 0.999 * steerValue + 0.001;
		}
		else
		{
			leftWeight = -0.999 * steerValue + 0.001;
			centerWeight = 0.999 * steerValue + 1.0;
			rightWeight = 0.001;
		}

		vehicle SetFlaggedAnim( animflag, vehicle getanim( leftAnim ), leftWeight, STEERING_BLEND_TIME, 1.0 );
		vehicle SetFlaggedAnim( animflag, vehicle getanim( centerAnim ), centerWeight, STEERING_BLEND_TIME, 1.0 );
		vehicle SetFlaggedAnim( animflag, vehicle getanim( rightAnim ), rightWeight, STEERING_BLEND_TIME, 1.0 );

		wait UPDATE_TIME;
	}
}

is_shoot_button_pressed()
{
	// pc
	return self AttackButtonPressed();
}


drive_shooting_update_anims( vehicle )
{
	// start pull out anim
	vehicle SetAnimKnobLimited( vehicle getanim( "gun_pullout_root" ), 1.0, 0.0, 1.0 );
	self childthread drive_blend_anims_with_steering( vehicle, "pullout_anim", "pullout_done", "gun_pullout_L", "gun_pullout", "gun_pullout_R" );

	// attach the gun
	vehicle waittillmatch( "pullout_anim", "attach_gun" );
	vehicle Attach( level.snowmobile_gunModel, "tag_weapon_left" );
	hideParts = [];
	hideParts[ "TAG_EOTECH" ] = true;
	hideParts[ "TAG_RAIL" ] = true;
	hideParts[ "TAG_RED_DOT" ] = true;
	hideParts[ "TAG_SILENCER" ] = true;

	foreach ( part, _ in hideParts )
	{
		vehicle HidePart( part );
	}



	vehicle.gun_attached = true;

	vehicle waittillmatch( "pullout_anim", "end" );
	vehicle notify( "pullout_done" );

	// start gun anim
	vehicle SetAnim( vehicle getanim( "glock" ), 1.0, 0.0, 1.0 );

	// start idle
	vehicle SetAnimKnobLimited( vehicle getanim( "gun_idle" ), 1.0, 0.0, 1.0 );

	vehicle.snowmobileShootTimer = SHOOT_ARM_UP_DELAY;

	for ( ;; )
	{
		if ( vehicle.snowmobileShootTimer <= 0.0 )
			break;

		shootButtonPressed = is_shoot_button_pressed();

		if ( shootButtonPressed && ( vehicle.snowmobileAmmoCount > 0 ) )
		{
			assert( isplayer( self ) );
			self ent_flag_set( "player_shot_on_snowmobile" );
			// play gun fire anims
			vehicle SetFlaggedAnimKnobLimitedRestart( "fire_anim", vehicle getanim( "gun_fire" ), 1.0, 0.0, 1.0 );

			if ( vehicle.snowmobileAmmoCount == 1 )
				vehicle SetAnimKnobLimitedRestart( vehicle getanim( "glock_last_fire" ), 1.0, 0.0, 1.0 );
			else
				vehicle SetAnimKnobLimitedRestart( vehicle getanim( "glock_fire" ), 1.0, 0.0, 1.0 );

			// fire bullet
			self drive_magic_bullet( vehicle );

			wait( SHOOT_FIRE_TIME );

			vehicle.snowmobileAmmoCount -= 1;
			vehicle.snowmobileShootTimer = SHOOT_ARM_UP_DELAY;
		}
		else if ( vehicle.snowmobileAmmoCount <= 0 )
		{
			// play reload anims
			vehicle SetFlaggedAnimKnobLimitedRestart( "reload_anim", vehicle getanim( "gun_reload" ), 1.0, 0.0, 1.0 );
			vehicle SetAnimKnobLimitedRestart( vehicle getanim( "glock_reload" ), 1.0, 0.0, 1.0 );

			vehicle waittillmatch( "reload_anim", "end" );

			vehicle.snowmobileAmmoCount = SHOOT_AMMO_COUNT;
			vehicle.snowmobileShootTimer = SHOOT_ARM_UP_DELAY;
		}
		else
		{
			// play idle
			vehicle SetAnimKnobLimited( vehicle getanim( "gun_idle" ), 1.0, 0.0, 1.0 );
			vehicle.snowmobileShootTimer -= UPDATE_TIME;
		}

		wait UPDATE_TIME;
	}

	// start put away anim
	vehicle SetAnimKnobLimited( vehicle getanim( "gun_putaway_root" ), 1.0, 0.0, 1.0 );
	self childthread drive_blend_anims_with_steering( vehicle, "putaway_anim", "putaway_done", "gun_putaway_L", "gun_putaway", "gun_putaway_R" );

	// detach the gun
	vehicle waittillmatch( "putaway_anim", "detach_gun" );
	vehicle Detach( level.snowmobile_gunModel, "tag_weapon_left" );
	vehicle.gun_attached = undefined;

	vehicle waittillmatch( "putaway_anim", "end" );
	vehicle notify( "putaway_done" );
	vehicle notify( "drive_shooting_done" );
}


drive_shooting_anims( vehicle )
{
	vehicle SetAnim( vehicle getanim( "drive_left_arm" ), 1.0, SHOOT_BLEND_TIME, 1.0 );
	vehicle SetAnim( vehicle getanim( "shoot_left_arm" ), 0.0, SHOOT_BLEND_TIME, 1.0 );

	for ( ;; )
	{
		shootButtonPressed = is_shoot_button_pressed();
		
		if ( shootButtonPressed )
		{
			vehicle SetAnim( vehicle getanim( "drive_left_arm" ), 0.001, SHOOT_BLEND_TIME, 1.0 );
			vehicle SetAnim( vehicle getanim( "shoot_left_arm" ), 1.0, SHOOT_BLEND_TIME, 1.0 );

			self childthread drive_shooting_update_anims( vehicle );

			vehicle waittill( "drive_shooting_done" );
		}

		vehicle SetAnim( vehicle getanim( "drive_left_arm" ), 1.0, SHOOT_BLEND_TIME, 1.0 );
		vehicle SetAnim( vehicle getanim( "shoot_left_arm" ), 0.0, SHOOT_BLEND_TIME, 1.0 );

		wait UPDATE_TIME;
	}
}


drive_sleeve_anims( vehicle )
{
	for ( ;; )
	{
		speed = vehicle Vehicle_GetSpeed();

		// Animate sleeve flapping based on speed
		speedLerp = speed / SLEEVE_FLAP_SPEED;
		if ( speedLerp > 1.0 )
			speedLerp = 1.0;

		rate = ( SLEEVE_FLAP_MAX_RATE - SLEEVE_FLAP_MIN_RATE ) * speedLerp + SLEEVE_FLAP_MIN_RATE;
		weight = ( SLEEVE_FLAP_MAX_WEIGHT - SLEEVE_FLAP_MIN_WEIGHT ) * speedLerp + SLEEVE_FLAP_MIN_WEIGHT;

		vehicle SetAnim( vehicle getanim( "sleeve_pose" ), ( 1.0 - weight ), BLEND_TIME, rate );
		vehicle SetAnim( vehicle getanim( "sleeve_flapping" ), weight, BLEND_TIME, rate );

		wait UPDATE_TIME;
	}
}


drive_speedometer_anims( vehicle )
{
	for ( ;; )
	{
		speed = vehicle Vehicle_GetSpeed();
		speedLerp = speed / SPEEDOMETER_MAX_SPEED;

		if ( speedLerp > 1.0 )
			speedLerp = 1.0;

		if ( speedLerp < 0.5 )
		{
			weight = speedLerp / 0.5;
			vehicle SetAnim( vehicle getanim( "speedometer_0" ), ( 1.0 - weight ), SPEEDOMETER_BLEND_TIME, 1.0 );
			vehicle SetAnim( vehicle getanim( "speedometer_90" ), weight, SPEEDOMETER_BLEND_TIME, 1.0 );
			vehicle SetAnim( vehicle getanim( "speedometer_180" ), 0.0, SPEEDOMETER_BLEND_TIME, 1.0 );
		}
		else
		{
			weight = ( speedLerp - 0.5 ) / 0.5;
			vehicle SetAnim( vehicle getanim( "speedometer_0" ), 0.0, SPEEDOMETER_BLEND_TIME, 1.0 );
			vehicle SetAnim( vehicle getanim( "speedometer_90" ), ( 1.0 - weight ), SPEEDOMETER_BLEND_TIME, 1.0 );
			vehicle SetAnim( vehicle getanim( "speedometer_180" ), weight, SPEEDOMETER_BLEND_TIME, 1.0 );
		}

		wait UPDATE_TIME;
	}
}


drive_tachometer_anims( vehicle )
{
	throttle = 0;

	for ( ;; )
	{
		throttle_last = throttle;
		throttle = vehicle Vehicle_GetThrottle();

		if ( ( throttle > throttle_last ) || ( throttle == 1.0 ) )
		{
			blend = TACH_BLEND_UP;
			weight = ( throttle - TACH_RAND_UP ) + RandomFloat( TACH_RAND_UP * 2.0 );
		}
		else
		{
			blend = TACH_BLEND_DOWN;
			weight = ( throttle - TACH_RAND_DOWN ) + RandomFloat( TACH_RAND_DOWN * 2.0 );
		}

		if ( weight < 0.0 )
			weight = 0.0;
		else if ( weight > 1.0 )
			weight = 1.0;

		vehicle SetAnim( vehicle getanim( "rpm_min" ), ( 1.0 - weight ), blend, 1.0 );
		vehicle SetAnim( vehicle getanim( "rpm_max" ), weight, blend, 1.0 );

		wait UPDATE_TIME;
	}
}


drive_throttle_anims( vehicle )
{
	vehicle SetAnim( vehicle getanim( "throttle" ), 1.0, 0.0, 1.0 );
	vehicle SetAnim( vehicle getanim( "throttle_left" ), 1.0, 0.0, 1.0 );
	vehicle SetAnim( vehicle getanim( "throttle_right" ), 1.0, 0.0, 1.0 );

	for ( ;; )
	{
		throttle = vehicle Vehicle_GetThrottle();
		steerValue = vehicle Vehicle_GetSteering() * -1.0;
		steerValue = clamp( steerValue, STEER_MIN, STEER_MAX );
		
		if ( steerValue >= 0.0 )
		{
			throttleWeight = throttle * ( 1.0 - steerValue );
			throttleLeftWeight = 0.0;
			throttleRightWeight = throttle * steerValue;
		}
		else
		{
			throttleWeight = throttle * ( 1.0 + steerValue );
			throttleLeftWeight = throttle * steerValue * -1.0;
			throttleRightWeight = 0.0;
		}

		vehicle SetAnim( vehicle getanim( "throttle_add" ), throttleWeight, THROTTLE_BLEND_TIME, 1.0 );
		vehicle SetAnim( vehicle getanim( "throttle_add_left" ), throttleLeftWeight, THROTTLE_BLEND_TIME, 1.0 );
		vehicle SetAnim( vehicle getanim( "throttle_add_right" ), throttleRightWeight, THROTTLE_BLEND_TIME, 1.0 );

		wait UPDATE_TIME;
	}
}


#using_animtree( "vehicles" );
snowmobile_anims()
{
	level.scr_animtree[ "snowmobile_player" ]	 = #animtree;
	level.scr_model[ "snowmobile_player" ]		 = level.snowmobile_playerHandModel;

	level.scr_anim[ "snowmobile_player" ][ "root" ]	 = %root;

	level.scr_anim[ "snowmobile_player" ][ "left_arm" ]				 = %player_snowmobile_left_arm;
	level.scr_anim[ "snowmobile_player" ][ "drive_left_arm" ]		 = %player_snowmobile_drive_left_arm;
	level.scr_anim[ "snowmobile_player" ][ "turn_left2right_L" ]	 = %player_snowmobile_drive_turn_left2right_L;
	level.scr_anim[ "snowmobile_player" ][ "turn_right2left_L" ]	 = %player_snowmobile_drive_turn_right2left_L;
	level.scr_anim[ "snowmobile_player" ][ "shoot_left_arm" ]		 = %player_snowmobile_shoot_left_arm;
	level.scr_anim[ "snowmobile_player" ][ "gun_fire" ]				 = %player_snowmobile_gun_fire;
	level.scr_anim[ "snowmobile_player" ][ "gun_idle" ]				 = %player_snowmobile_gun_idle;
	level.scr_anim[ "snowmobile_player" ][ "gun_pullout_root" ]		 = %player_snowmobile_gun_pullout_root;
	level.scr_anim[ "snowmobile_player" ][ "gun_pullout_L" ]		 = %player_snowmobile_gun_pullout_L;
	level.scr_anim[ "snowmobile_player" ][ "gun_pullout" ]			 = %player_snowmobile_gun_pullout;
	level.scr_anim[ "snowmobile_player" ][ "gun_pullout_R" ]		 = %player_snowmobile_gun_pullout_R;
	level.scr_anim[ "snowmobile_player" ][ "gun_putaway_root" ]		 = %player_snowmobile_gun_putaway_root;
	level.scr_anim[ "snowmobile_player" ][ "gun_putaway_L" ]		 = %player_snowmobile_gun_putaway_L;
	level.scr_anim[ "snowmobile_player" ][ "gun_putaway" ]			 = %player_snowmobile_gun_putaway;
	level.scr_anim[ "snowmobile_player" ][ "gun_putaway_R" ]		 = %player_snowmobile_gun_putaway_R;
	level.scr_anim[ "snowmobile_player" ][ "gun_reload" ]			 = %player_snowmobile_gun_reload;

	level.scr_anim[ "snowmobile_player" ][ "right_arm" ]			 = %player_snowmobile_right_arm;
	level.scr_anim[ "snowmobile_player" ][ "turn_left2right_R" ]	 = %player_snowmobile_drive_turn_left2right_R;
	level.scr_anim[ "snowmobile_player" ][ "turn_right2left_R" ]	 = %player_snowmobile_drive_turn_right2left_R;

	level.scr_anim[ "snowmobile_player" ][ "glock" ]			 = %snowmobile_glock;
	level.scr_anim[ "snowmobile_player" ][ "glock_fire" ]		 = %snowmobile_glock_fire;
	level.scr_anim[ "snowmobile_player" ][ "glock_last_fire" ]	 = %snowmobile_glock_last_fire;
	level.scr_anim[ "snowmobile_player" ][ "glock_reload" ]		 = %snowmobile_glock_reload;

	level.scr_anim[ "snowmobile_player" ][ "rpm_min" ]	 = %player_snowmobile_drive_rpm_min;
	level.scr_anim[ "snowmobile_player" ][ "rpm_max" ]	 = %player_snowmobile_drive_rpm_max;

	level.scr_anim[ "snowmobile_player" ][ "speedometer_0" ]	 = %player_snowmobile_drive_speedometer_0;
	level.scr_anim[ "snowmobile_player" ][ "speedometer_90" ]	 = %player_snowmobile_drive_speedometer_90;
	level.scr_anim[ "snowmobile_player" ][ "speedometer_180" ]	 = %player_snowmobile_drive_speedometer_180;

	level.scr_anim[ "snowmobile_player" ][ "throttle_add" ]	 = %player_snowmobile_drive_throttle_add;
	level.scr_anim[ "snowmobile_player" ][ "throttle" ]		 = %player_snowmobile_drive_throttle;

	level.scr_anim[ "snowmobile_player" ][ "throttle_add_left" ]	 = %player_snowmobile_drive_throttle_add_left;
	level.scr_anim[ "snowmobile_player" ][ "throttle_left" ]		 = %player_snowmobile_drive_throttle_left;

	level.scr_anim[ "snowmobile_player" ][ "throttle_add_right" ]	 = %player_snowmobile_drive_throttle_add_right;
	level.scr_anim[ "snowmobile_player" ][ "throttle_right" ]		 = %player_snowmobile_drive_throttle_right;

	level.scr_anim[ "snowmobile_player" ][ "sleeve_pose" ]		 = %player_sleeve_pose;
	level.scr_anim[ "snowmobile_player" ][ "sleeve_flapping" ]	 = %player_sleeve_flapping;
}

should_stop_snowmobile_attack_hint_player1()
{
	return level.player should_stop_snowmobile_attack_hint();
}

should_stop_snowmobile_attack_hint_player2()
{
	return level.player2 should_stop_snowmobile_attack_hint();
}

should_stop_snowmobile_attack_hint()
{
	if ( isdefined( self.reverse_hint_string ) )
		return true;
	
	if ( isDefined( level.no_snowmobile_attack_hint ) )
		return true;
	
	if ( !isdefined( self.vehicle ) )
		return true;
	
	if ( self ent_flag_exist( "finish_line" ) && self ent_flag( "finish_line" ) )
		return true;
	
	return self ent_flag( "player_shot_on_snowmobile" );
}

should_stop_snowmobile_drive_hint_player1()
{
	return level.player should_stop_snowmobile_drive_hint();
}

should_stop_snowmobile_drive_hint_player2()
{
	return level.player2 should_stop_snowmobile_drive_hint();
}

should_stop_snowmobile_drive_hint()
{
	if ( !isdefined( self.vehicle ) )
		return true;
	
	return self.vehicle.veh_speed > 10;
}

