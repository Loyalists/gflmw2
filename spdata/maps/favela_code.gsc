#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_anim;
#using_animtree( "generic_human" );

ENEMY_BASE_ACCURACY = 0.6;

//########################################
// VISION SETS
//########################################

vision_chase()
{
	flag_wait( "visionset_chase" );
		
	time = 6;
	maps\_utility::set_vision_set( "favela_chase", time );
	//setExpFog( 708.893, 5902.43, 0.402663, 0.456692, 0.520202, 0.721229, 0, 0.562109, 0.600449, 0.678415, (0.89008, -0.302316, -0.341119), 0, 51.1533, 1.80097 );
}

vision_torture()
{
	flag_wait( "visionset_torture" );
		
	time = 1;
	maps\_utility::set_vision_set( "favela_torture", time );
	//setExpFog( 708.893, 5902.43, 0.402663, 0.456692, 0.520202, 0.721229, 0, 0.562109, 0.600449, 0.678415, (0.89008, -0.302316, -0.341119), 0, 51.1533, 1.80097 );
}

//########################################
//########################################

movePlayerToStartPoint( sTargetname )
{
	assert( isdefined( sTargetname ) );
	start = getent( sTargetname, "targetname" );
	level.player SetOrigin( start.origin );
	
	lookat = undefined;
	if ( isdefined( start.target ) )
	{
		lookat = getent( start.target, "targetname" );
		assert( isdefined( lookat ) );
	}
	
	if ( isdefined( lookat ) )
		level.player setPlayerAngles( vectorToAngles( lookat.origin - start.origin ) );
	else
		level.player setPlayerAngles( start.angles );
}

modify_battlechatter_times()
{
	MULT = 0.25;
	
	// delay to make sure these get set at the level load first
	wait 0.1;
	
	// "contact to the north!" etc.
	anim.eventActionMinWait[ "threat" ][ "self" ] *= MULT;			// 14000
	anim.eventActionMinWait[ "threat" ][ "squad" ] *= MULT;			// 10000
	
	// "cover me!" / "suppressing fire!" / "let's go!" etc.
	anim.eventActionMinWait[ "order" ][ "self" ] *= MULT;				// 8000;
	anim.eventActionMinWait[ "order" ][ "squad" ] *= MULT;			// 10000;
	
	// "reloading!" / "grenade out!"
	anim.eventActionMinWait[ "inform" ][ "self" ] *= MULT;			// 6000;
	anim.eventActionMinWait[ "inform" ][ "squad" ] *= MULT;			// 8000;
	
	// specific categories of the above
	anim.eventTypeMinWait[ "inform" ][ "reloading" ] *= MULT;		// 20000;
	anim.eventTypeMinWait[ "inform" ][ "killfirm" ] *= MULT;		// 15000;
	
	// "Man down!"
	anim.eventTypeMinWait[ "reaction" ][ "casualty" ] *= MULT;	// 14000;
	
	// this is the one that I think might make a big difference as long as these enemies have "hostile bursts"
	anim.eventTypeMinWait[ "reaction" ][ "taunt" ] *= MULT;			// 30000;
}

adjustAccuracy()
{
	self endon( "death" );
	wait 0.2;
	self.baseaccuracy = ENEMY_BASE_ACCURACY;
}

start_traffic_group( delay, targetname1, targetname2, targetname3 )
{
	level endon( "stop_street_traffic" );
	
	assert( isdefined( delay ) );
	assert( isdefined( targetname1 ) );
	
	carTargetNames[ 0 ] = targetname1;
	if ( isdefined( targetname2 ) )
		carTargetNames[ 1 ] = targetname2;
	if ( isdefined( targetname3 ) )
		carTargetNames[ 2 ] = targetname3;
	
	for(;;)
	{
		thread traffic_car_go( carTargetNames[ randomint( carTargetNames.size ) ] );
		wait delay;
	}
}

stop_traffic()
{
	level notify( "stop_street_traffic" );
	thread delete_cars_far_away();
}

delete_cars_far_away()
{
	cars = getentarray( "script_vehicle", "code_classname" );
	foreach( car in cars )
	{
		if ( !car ent_flag_exist( "dont_delete_me" ) )
			continue;
		if ( car ent_flag( "dont_delete_me" ) )
			continue;
		car delete();
	}
}

traffic_car_go( sTargetname )
{
	assert( isdefined( sTargetname ) );
	car = spawn_vehicle_from_targetname_and_drive( sTargetname );
	assert( isdefined( car ) );
	car ent_flag_init( "dont_delete_me" );
	car waittill( "reached_end_node" );
	car delete();
}

delete_ai_at_path_end()
{
	self endon( "death" );
	self waittill( "reached_path_end" );
	delete_ai( self );
}

delete_ai( ai )
{
	guys[ 0 ] = ai;
	level thread AI_delete_when_out_of_sight( guys, 512 );
}

delete_ai_at_path_end_no_choke()
{
	self.usechokepoints = false;
	self thread delete_ai_at_path_end();
}

delete_ai_at_goal( ignoreCanSeeChecks )
{
	self endon( "death" );
	self waittill( "goal" );
	if ( isdefined( ignoreCanSeeChecks ) && ignoreCanSeeChecks )
	{
		if ( isdefined( self.magic_bullet_shield ) )
			self stop_magic_bullet_shield();
		self delete();
	}
	else
		delete_ai( self );
}

dog_seek_player()
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );

	self setgoalentity( level.player );
	self.goalradius = 300;
}

seek_player()
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );

	self setgoalentity( level.player );
	self.goalradius = 1000;
}

gag_fence_dog()
{
	trigger_wait( "fence_dog_gag", "targetname" );
	
	// spawn the dog
	spawner = getent( "fence_dog_spawner", "targetname" );
	dog = spawner stalingradSpawn();
	spawn_failed( dog );
	dog endon( "death" );
	
	dog.animname = "dog";
	old_maxsightdistsqrd = dog.maxsightdistsqrd;
	dog.maxsightdistsqrd = 0;
	dog set_ignoreall( true );
	animNode = getent( "fence_dog_node", "targetname" );
	
	dog setlookatEntity( level.player );
	animNode anim_reach_solo( dog, "fence_attack" );
	dog.allowdeath = true;
	animNode anim_single_solo( dog, "fence_attack" );
	
	dog.maxsightdistsqrd = old_maxsightdistsqrd;
	dog set_ignoreall( false );
	
	dog thread dog_seek_player();
	
	wait 1;
	dog setlookatEntity();
}

dont_see_player()
{
	self endon( "death" );
	
	self addAIEventListener( "bulletwhizby" );
	
	self.usechokepoints = false;
	self.interval = 0;
	self.fovcosine = 0.7;
	self.pathenemyfightdist = 512;
	
	self waittill_either( "damage", "bulletwhizby" );
	self.goalradius = level.default_goalradius;
	self setgoalpos( self.origin );
}

window_smasher()
{
	self endon( "death" );
	
	self.dontevershoot = true;
	
	// get nearest window_smash ent
	window = self getWindowParts();
	
	// wait until AI is at the window node
	windowNode = self getWindowNode();
	self.goalradius = 16;
	self setGoalNode( windowNode );
	
	// play melee anim
	windowNode thread anim_generic( self, "window_smash" );
	thread open_window( window, 0.1 );
	
	wait 0.3;
	
	self stopAnimScripted();
	
	wait 0.3;
	
	self.dontevershoot = undefined;
	
	wait 1.0;
	
	self.goalradius = 75;
}

getWindowNode()
{
	nodes = getnodearray( "window_smash_node", "targetname" );
	index = get_closest_index( self.origin, nodes );
	return nodes[ index ];
}

getWindowParts()
{
	windows = getentarray( "window_smash", "targetname" );
	index = get_closest_index( self.origin + ( 0, 0, 48 ), windows );
	windowEnt = windows[ index ];
	windowParts = getentarray( windowEnt.target, "targetname" );
	assert( windowParts.size == 2 );
	leftWindow = undefined;
	rightWindow = undefined;
	foreach( part in windowParts )
	{
		if ( part.script_noteworthy == "left" )
			leftWindow = part;
		else if ( part.script_noteworthy == "right" )
			rightWindow = part;
	}
	assert( isdefined( leftWindow ) );
	assert( isdefined( rightWindow ) );
	
	ents = [];
	ents[ "left" ] = leftWindow;
	ents[ "right" ] = rightWindow;
	return ents;
}

open_window( window, delay )
{
	if ( isdefined( delay ) )
		wait delay;
	
	thread play_sound_in_space( "scn_favela_npc_open_shutters", window[ "left" ].origin );
	
	window[ "left" ] rotateYaw( 155, 0.5, 0.0 );
	window[ "right" ] rotateYaw( -155, 0.4, 0.0 );
	wait 0.5;
	window[ "left" ] rotateYaw( -15, 1.0, 1.0 );
	window[ "left" ] rotateYaw( 15, 1.0, 1.0 );
}

play_sound_trigger()
{
	assert( isdefined( self.script_noteworthy ) );
	assert( isdefined( self.target ) );
	soundEnt = getent( self.target, "targetname" );
	assert( isdefined( soundEnt ) );
	
	self waittill( "trigger" );
	
	thread play_sound_in_space( self.script_noteworthy, soundEnt.origin );
}

gag_civilian_window_1()
{
	trigger_wait( "gag_civilian_window_1", "targetname" );
	
	// spawn character
	spawner = getent( "window_civilian_spawner_1", "targetname" );
	guy = spawner spawn_ai( true );
	guy endon( "death" );
	
	// play anim
	windowNode = getent( "civilian_window_node1", "targetname" );
	windowNode anim_generic( guy, "civilian_window_1" );
	
	// run away and delete
	runawayNode = getnode( "window_civilian_spawner_runto_node", "targetname" );
	guy.goalradius = 16;
	guy setGoalNode( runawayNode );
	
	delete_ai( self );
	
	guy thread delete_ai_at_goal();
}

ignored_until_goal()
{
	// AI is ignored by enemy AI until he gets to his goal
	self endon( "death" );
	self.ignoreme = true;
	self waittill( "goal" );
	wait randomfloatrange( 1.0, 2.0 );
	self.ignoreme = false;
}

ignore_and_delete_on_goal( ignoreCanSeeChecks )
{
	self thread set_ignoreme( true );
	self thread set_ignoreall( true );
	self thread delete_ai_at_goal( ignoreCanSeeChecks );
}

faust_spawn_func()
{
	if ( isdefined( level.faust ) )
	{
		if ( isdefined( level.faust.magic_bullet_shield ) )
		{
			level.faust stop_magic_bullet_shield();
			wait 0.05;
		}
		level.faust delete();
		level.faust = undefined;
	}
	level.faust = self;
	
	// he runs his path. When he gets to the end of his path he gets deleted
	level.faust endon( "death" );
	
	level.faust set_ignoreall( true );
	level.faust set_ignoreme( true );
	
	level.faust thread magic_bullet_shield();
	level.faust thread faust_spills_money();
	level.faust thread faust_mission_fail();
	
	level.faust waittill( "reached_path_end" );
	
	if ( isdefined( level.faust.magic_bullet_shield ) )
		level.faust stop_magic_bullet_shield();
	wait 0.05;
	level.faust delete();
	level.faust = undefined;
}

faust_spills_money()
{
	self endon( "death" );
	
	for(;;)
	{
		playfxontag( getfx( "cash_trail" ), self, "J_Hip_LE" );
		wait randomfloatrange( 0.2, .5);
	}	
}

faust_mission_fail()
{
	self endon( "reached_path_end" );
	for(;;)
	{
		self waittill( "damage", damage, attacker );
		
		if ( !isdefined( attacker ) )
			continue;
		
		if ( attacker != level.player )
			continue;
		
		if ( damage <= 1 )
			continue;
		
		break;
	}
	
	self stop_magic_bullet_shield();
	wait 0.05;
	self kill( self.origin, level.player );
	
	setdvar( "ui_deadquote", "@FAVELA_ROJAS_KILLED" );
	maps\_utility::missionFailedWrapper();
}

trigger_spawn_chance()
{
	spawners = getentarray( self.target, "targetname" );
	assert( spawners.size > 0 );
	
	self waittill( "trigger" );
	
	chance_percent = 25;
	if ( isdefined( self.script_noteworthy ) )
		chance_percent = int( self.script_noteworthy );
	
	if ( randomint( 100 ) > chance_percent )
		return;
	
	spawners = array_removeundefined( spawners );
	array_thread( spawners, ::spawn_ai );
}

desert_eagle_guy()
{
	self endon( "death" );
	
	self forceUseWeapon( "deserteagle", "sidearm" );
	
	anim.shootEnemyWrapper_func = animscripts\utility::ShootEnemyWrapper_shootNotify;
	
	self.weapon = self.sidearm;
	self.favoriteenemy = level.player;
	self.disablearrivals = true;
	self.disableexits = true;
	self.animname = "desert_eagle_guy";
	self.baseaccuracy = 1;
	self.noAttackerAccuracyMod = true;
	self.accuracy = 1;
	self.goalradius = 16;
	self thread delayThread( 3.0, ::set_goalradius, 300 );
	self thread delayThread( 3.0, ::set_goal_player );
	
	self playsound( "generic_meleecharge_russian_" + randomintrange( 1, 8 ) );
	
	while ( level.player.health > 0 )
	{
		level waittill( "an_enemy_shot", guy );
		
		if ( guy != self )
			continue;
		
		num = 1;
		while ( num )
		{
			wait .25;
			self shoot();
			num -- ;
		}
	}
	
	self.ignoreme = true;
}

set_goal_player()
{
	if ( !isAlive( self ) )
		return;
	if ( !isAlive( level.player ) )
		return;
	self setGoalPos( level.player.origin );
}

process_ai_script_parameters()
{
	if ( !isdefined( self.script_parameters ) )
		return;
	
	parms = strtok( self.script_parameters, ":;, " );
	
	foreach( parm in parms )
	{
		parm = tolower( parm );
		
		if ( parm == "balcony" )
			self.deathFunction = ::try_balcony_death;
	}
}

try_balcony_death()
{
	// always return false in this function because we want the death
	// animscript to continue after this function no matter what
	
	if ( !isdefined( self ) )
		return false;
	
	if ( self.a.pose == "prone" )	// allow crouch
		return false;
	
	if ( !isdefined( self.prevnode ) )
		return false;
	
	if ( !isdefined( self.prevnode.script_balcony ) )
		return false;
	
	angleAI = self.angles[ 1 ];
	angleNode = self.prevnode.angles[ 1 ];
	angleDiff = abs( angleAI - angleNode );
	if ( angleDiff > 15 )
		return false;
	
	d = distance( self.origin, self.prevnode.origin );
	if ( d > 16 )
		return false;
	
	if ( !isdefined( level.last_balcony_death ) )
		level.last_balcony_death = getTime();
	elapsedTime = getTime() - level.last_balcony_death;
	
	// if one just happened within 5 seconds dont do it
	if ( elapsedTime < 5 * 1000 )
		return false;
	
	deathAnims = [];
	deathAnims[0] = %death_rooftop_A;
	deathAnims[1] = %death_rooftop_B;
	deathAnims[2] = %death_rooftop_D;
	deathAnims[3] = %bog_b_rpg_fall_death;
	self.deathanim = deathAnims[ randomint( deathAnims.size ) ];
	
	return false;
}

control_run_speed()
{
	level endon( "runner_shot" );
	self endon( "death" );
	
	// speed and slows runner's run speed so the player can't catch him but also doesn't get left too far behind
	
	targetSpeed = undefined;
	//self.moveplaybackrate = 1.2;
	//self.sprint = true;
	
	flag_wait( "soap_control_run_speed" );
	/*
	for(;;)
	{
		targetSpeed = self get_best_run_speed();
		self thread set_run_speed( targetSpeed );
		wait 0.2;
	}
	*/
}

get_best_run_speed()
{
	ai_dist = distance( self.origin, self.last_set_goalnode.origin );
	player_dist = distance( level.player.origin, self.last_set_goalnode.origin );
	offset = ai_dist - player_dist;
	
	RATE_MIN = 1.0;
	RATE_MAX = 1.5;
	
	DISTANCE_MIN = -450;
	DISTANCE_MAX = 0;
	
	offset = cap_value( offset, DISTANCE_MIN, DISTANCE_MAX );
	
	// player is far behind, normal run speed
	if ( offset < DISTANCE_MIN )
		return RATE_MIN;
	
	// player is ahead of AI, max run speed
	if ( offset >= DISTANCE_MAX )
		return RATE_MAX;
	
	// player is close behind the AI, control run speed to make sure AI stays ahead
	fraction = get_fraction( offset, DISTANCE_MIN, DISTANCE_MAX );
	targetSpeed = RATE_MAX - ( ( RATE_MAX - RATE_MIN ) * fraction );
	assert( targetSpeed > 0 );
	
	return targetSpeed;
}

set_run_speed( targetSpeed )
{
	assert( isdefined( targetSpeed ) );
	self.moveplaybackrate = targetSpeed;
}

get_fraction( value, min, max )
{
	fraction = abs( ( value - min ) / ( min - max ) );
	fraction = abs( 1 - fraction );
	fraction = cap_value( fraction, 0.0, 1.0 );
	return fraction;
}

physics_drop()
{
	assert( isdefined( self.target ) );
	orgs = getentarray( self.target, "targetname" );
	assert( orgs.size > 0 );
	
	self waittill( "trigger" );
	
	array_thread( orgs, ::physics_drop_model );
}

physics_drop_model()
{
	model = spawn( "script_model", self.origin );
	model setModel( level.physics_drop_models[ randomint( level.physics_drop_models.size ) ] );
	
	vec = anglesToForward( self.angles );
	vec *= 2000;
	
	model PhysicsLaunchClient( model.origin + ( 0, 0, 0 ), vec );
}

forklift_blocker()
{
	forklift_before = getentarray( "forklift_before", "targetname" );
	forklift_before_clip = getent( "forklift_before_clip", "targetname" );
	
	forklift_after = getentarray( "forklift_after", "targetname" );
	forklift_after_clip = getent( "forklift_after_clip", "targetname" );
	
	// hide after
	array_call( forklift_after, ::hide );
	forklift_after_clip notsolid();
	
	flag_wait( "block_alley" );
	
	// show after, hide before
	array_call( forklift_after, ::show );
	forklift_after_clip solid();
	
	array_call( forklift_before, ::delete );
	forklift_before_clip delete();
}

car_anims()
{
	// attach hula girl
	tag = "tag_hulagirl_attach";
	level.hula_girl = spawn_anim_model( "hula_girl", self getTagOrigin( tag ) );
	level.hula_girl.angles = self getTagAngles( tag );
	level.hula_girl linkTo( self, tag );
	level.hula_girl setAnim( level.scr_anim[ "hula_girl" ][ "bobble" ] );
	
	self setAnim( level.scr_anim[ "car" ][ "driving" ] );
	self waittill( "reached_end_node" );
	self clearAnim( level.scr_anim[ "car" ][ "driving" ], 1.0 );
	level.hula_girl clearAnim( level.scr_anim[ "hula_girl" ][ "bobble" ], 1.0 );
	level.hula_girl setAnim( level.scr_anim[ "hula_girl" ][ "bobble_stop" ] );
	wait 1.55;
	level.hula_girl clearAnim( level.scr_anim[ "hula_girl" ][ "bobble_stop" ], 1.0 );
	
	// opens the door when soap exists the vehicle
	flag_wait( "soap_exits_car" );
	self setAnim( level.scr_anim[ "car" ][ "run_and_wave" ] );
	
	self waittill( "door_open" );
	self thread play_sound_on_entity( "scn_favela_player_door_open" );
	self setAnim( level.scr_anim[ "car" ][ "door_open" ] );
}

car_driver_anims()
{
	driver = make_car_driver();
	assert( isdefined( driver ) );
	
	driver linkTo( self, "tag_driver" );
	
	self thread anim_loop_solo( driver, "idle", "stop_drive_idle", "tag_driver" );
	
	wait 13;
	
	self notify( "stop_drive_idle" );
	
	self setanimknob( level.scr_anim[ "car" ][ "center2right" ], 1, 0, 1 );
	self anim_single_solo( driver, "center2right", "tag_driver" );
	wait 1;
	self clearAnim( level.scr_anim[ "car" ][ "center2right" ], 0 );
	self setanimknob( level.scr_anim[ "car" ][ "right2center" ], 1, 0, 1 );
	self anim_single_solo( driver, "right2center", "tag_driver" );
	self clearAnim( level.scr_anim[ "car" ][ "right2center" ], 0 );
	
	self thread anim_loop_solo( driver, "idle", "stop_drive_idle", "tag_driver" );
	
	flag_wait( "opening_scene_started" );
	
	self thread play_sound_on_entity( "scn_favela_driver_killed" );
	self anim_single_solo( driver, "react", "tag_driver" );
}

make_car_driver()
{
	guy = spawn_targetname( "car_driver" );
	
	model = spawn( "script_model", guy.origin );
	model.angles = guy.angles;
	model setmodel( guy.model );

	numAttached = guy getattachsize();
	for ( i = 0; i < numAttached; i++ )
	{
		modelname 	 = guy getattachmodelname( i );
		tagname 	 = guy getattachtagname( i );
		model attach( modelname, tagname, true );
	}
	
	model.animname = "driver";
	model UseAnimTree( #animtree );
	
	guy delete();
	
	return model;
}

trigger_cleanup()
{
	assert( isdefined( self.target ) );
	areas = getentarray( self.target, "targetname" );
	assert( areas.size > 0 );
	
	self waittill( "trigger" );
	
	foreach( area in areas )
	{
		array_thread( area get_ai_touching_volume( "axis" ), ::delete_ai_not_bullet_shielded );
	}
}

delete_ai_not_bullet_shielded()
{
	if ( isdefined( self.magic_bullet_shield ) )
		return;
	self delete();
}

bike_rider( pathTargetname )
{
	bike_path_start = getent( pathTargetname, "targetname" );
	bike_path_end = getent( bike_path_start.target, "targetname" );
	
	bike = spawn( "script_model", bike_path_start.origin );
	bike setModel( "com_bike_animated" );
	bike useAnimTree( level.scr_animtree[ "bike" ] );
	
	rider = spawn( "script_model", bike.origin );
	rider useAnimTree( #animtree );
	
	if ( !isdefined( level.spawned_bike_rider ) )
	{
		level.spawned_bike_rider = true;
		rider character\character_civilian_slum_male_aa::main();
	}
	else
	{
		rider character\character_civilian_slum_male_ab::main();
	}
	
	rider.origin = bike getTagOrigin( "j_frame" );
	rider.origin += ( -12, 0, -30 );
	rider.angles = bike getTagAngles( "j_frame" );
	rider.angles += ( 0, 180, 0 );
	rider linkTo( bike, "j_frame" );
	
	ang = vectorToAngles( bike_path_start.origin - bike_path_end.origin );
	bike.angles = ( 0, ang[ 1 ], 0 );
	
	bike setanim( level.scr_anim[ "bike" ][ "pedal" ] );
	rider setanim( level.scr_anim[ "generic" ][ "bike_rider" ] );
	
	moveTime = 10;
	bike MoveTo( bike_path_end.origin, moveTime, 0, 0 );
	
	wait moveTime;
	
	rider delete();
	bike delete();
}

potted_plant()
{
	forward = anglesToForward( self.angles );
	up = anglesToUp( self.angles );
	pos = self.origin;
	
	trig = undefined;
	if ( isdefined( self.target ) )
		trig = getent( self.target, "targetname" );
	
	self thread potted_plant_damage();
	if ( isdefined( trig ) )
		self thread potted_plant_triggered( trig );
	
	self waittill( "fall" );
	
	fx = undefined;
	switch( self.model )
	{
		case "com_potted_plant_small":
			fx = getfx( "plant_small_thrower" );
			break;
		case "com_potted_plant_medium":
			fx = getfx( "plant_medium_thrower" );
			break;
		case "com_potted_plant_large":
			fx = getfx( "plant_large_thrower" );
			break;
	}
	assert( isdefined( fx ) );
	
	self delete();
	playFX( fx, pos, forward, up );
}

potted_plant_damage()
{
	self endon( "fall" );
	self setCanDamage( true );
	self waittill( "damage" );
	self notify( "fall" );
}

potted_plant_triggered( trig )
{
	self endon( "fall" );
	trig waittill( "trigger" );
	wait randomfloatrange( 0.0, 0.2 );
	self notify( "fall" );
}

play_fx_trig()
{
	assert( isdefined( self.script_noteworthy ) );
	fx = self.script_noteworthy;
	assert( isdefined( level._effect[ fx ] ) );
	assert( isdefined( self.target ) );
	fxEnt = getent( self.target, "targetname" );
	fxID = getfx( fx );
	for(;;)
	{
		self waittill( "trigger" );
		playFX( fxID, fxEnt.origin );
		wait 1.0;
	}
}

civilian_flee_walla()
{
	self endon( "death" );
	
	// civillians don't do wallas until you're in the favela
	if ( !flag( "civilians_walla" ) )
		return;
	
	wait 0.05;
	
	while( self.alertLevelInt <= 1 )
		wait 0.05;
	
	if ( !isdefined( level.nextWallaIndex ) )
		level.nextWallaIndex = 0;
	
	elapsedTime = getTime() - level.lastWallaTime;
	if ( elapsedTime < 5000 )
		return;
	level.lastWallaTime = getTime();
	
	// walla
	animScene = level.fleeing_civilian_wallas[ level.nextWallaIndex ];
	self.allowdeath = true;
	self thread anim_generic( self, animScene );
	
	level.nextWallaIndex++;
	if ( level.nextWallaIndex >= level.fleeing_civilian_wallas.size )
		nextWallaIndex = 0;
}

ending_car_fx( vehicle )
{
	exploder ( "car_crush_cash" );
	wait 0.1;
	
	exploder ( "car_crush" ); 
	playfxontag( getFX( "car_crush_glass_med" ), vehicle, "tag_window_left_glass_fx" );
	playfxontag( getFX( "car_crush_glass_med" ), vehicle, "tag_window_right_glass_fx" );
	playfxontag( getFX( "car_crush_glass_large" ), vehicle, "tag_windshield_back_glass_fx" );
	playfxontag( getFX( "car_crush_glass_large" ), vehicle, "tag_windshield_front_glass_fx" );
}

dive_through_glass( guy )
{
	PlayFXOnTag( getFX( "glass_dust_trail" ), guy, "J_SpineLower" );
	guy thread maps\favela::ending_sequence_slowmo();
}

delete_ai_during_blackscreen()
{
	ai = getAIArray();
	foreach( guy in ai )
	{
		if ( isdefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
		guy notify( "deleted" );
	}
	array_call( getAIArray(), ::delete );
}

curtain_pulldown( bWaitForPlayer )
{
	if ( !isdefined( bWaitForPlayer ) )
		bWaitForPlayer = false;
	
	assert( isdefined( self.target ) );
	node = self curtain_pulldown_getnode();
	assert( isdefined( node ) );
	
	curtain = spawn_anim_model( "curtain" );
	
	node thread anim_first_frame_solo( curtain, "pulldown" );
	
	self waittill( "spawned", guy );
	if ( spawn_failed( guy ) )
		return;
	
	guy endon( "death" );
	
	guy.animname = "curtain_pull";
	guy.disablepain = true;
	guy set_ignoreme( true );
	guy.usechokepoints = false;
	
	wait 0.05;
	
	guy_and_curtain[ 0 ] = guy;
	guy_and_curtain[ 1 ] = curtain;
	
	node anim_reach_solo( guy, "pulldown" );
	
	if ( bWaitForPlayer )
	{
		node anim_first_frame_solo( guy, "pulldown" );
		waittill_player_lookat( 0.9, undefined, true, 5.0 );
	}
	
	// Don't allow guy to die until 1.5 seconds in so the curtain doesn't fall on it's own
	guy.allowdeath = false;
	guy thread allow_death_delayed( 1.5 );
	
	node anim_single( guy_and_curtain, "pulldown" );
	
	guy endon( "death" );
	
	guy set_ignoreme( false );
	guy.goalradius = 1000;
	guy setGoalPos( guy.origin );
	guy.usechokepoints = true;
}

allow_death_delayed( delay )
{
	wait delay;
	if ( isdefined( self ) )
		self.allowdeath = true;
}

curtain_pulldown_getnode()
{
	nodes = getentarray( self.target, "targetname" );
	foreach( node in nodes )
	{
		if ( node.classname == "script_origin" )
			return node;
	}
	assertMsg( "curtain pulldown guy doesn't target a script_origin" );
}

car_screech_node()
{	
	self waittill( "trigger", vehicle );
	assert( isdefined( vehicle ) );
	
	sound[ 0 ] = "scn_favela_car_traffic_skid1";
	sound[ 1 ] = "scn_favela_car_traffic_skid2";
	sound[ 2 ] = "scn_favela_car_traffic_skid3";
	
	if ( !isdefined( level.next_skid_sound ) )
		level.next_skid_sound = 0;
	
	vehicle playSound( sound[ level.next_skid_sound ] );
	
	level.next_skid_sound++;
	if ( level.next_skid_sound >= sound.size )
		level.next_skid_sound = 0;
}

retreat_trigger()
{
	assert( isdefined( self.target ) );
	node = getnode( self.target, "targetname" );
	assert( isdefined( node ) );
	assert( isdefined( node.radius ) );
	volume = getent( self.target, "targetname" );
	assert( isdefined( volume ) );
	
	self waittill( "trigger" );
	
	// get all AI in the volume
	ai = volume get_ai_touching_volume( "axis" );
	
	// make all ai touching the volume go to the specified node with it's radius
	foreach( guy in ai )
	{
		guy.goalradius = node.radius;
		guy set_goal_node( node );
	}
}

timed_favela_autosaves()
{
	flag_wait( "player_entered_favela" );
	
	while( !flag( "cleared_favela" ) )
	{
		wait 60;
		if ( flag( "cleared_favela" ) )
			return;
		thread autosave_by_name( "lower_favela" );
	}
}

civilian_driver()
{
	self.disablepain = true;
	self.a.nodeath = true;
	self.health = 10000000000;
}

faust_assistant_kill_player_monitor()
{
	self endon( "death" );
	distSq = 400 * 400;
	cos90 = cos( 90 );
	
	for(;;)
	{
		wait 0.05;
		
		// player must be within range of Faust's assistant
		d = DistanceSquared( self.origin, level.player.origin );
		if ( d > distSq )
			continue;
		
		// player must be in front of Faust's assistant
		FOV = within_fov( self.origin, self.angles, level.player.origin, cos90 );
		if ( !FOV )
			continue;
		
		// Faust's assisstant should now kill the player for getting in front of him
		self thread faust_assistant_kill_player();
		return;
	}
}

faust_assistant_kill_player()
{
	self endon( "death" );
	level.player endon( "death" );
	
	// kill the player
	
	createThreatBiasGroup( "player" );
	createThreatBiasGroup( "makarov" );
	level.player setThreatBiasGroup( "player" );
	self setThreatBiasGroup( "makarov" );
	setThreatBias( "makarov", "player", 100000 );
	self.maxsightdistsqrd = 8000 * 8000;
	self set_ignoreall( false );
	self set_ignoreme( true );
	
	self.goalradius = 16;
	self setGoalPos( self.origin );
	
	level.player.health = 1;
	
	self waittill( "shooting" );
	
	wait 0.05;
	
	if ( isalive( level.player ) )
		level.player kill();
}