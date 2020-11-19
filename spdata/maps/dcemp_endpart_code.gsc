#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_weather;

#include maps\dcemp_code;

#using_animtree( "generic_human" );

whitehouse_spotlight()
{
	level endon( "kill_spotlight" );
	spotlight_origin = getstruct( "whitehouse_spotlight", "targetname");

	spotlight = SpawnTurret( "misc_turret", spotlight_origin.origin, "heli_spotlight" ); // "heli_spotlight"
	spotlight.angles = spotlight_origin.angles;
	spotlight setmodel( "cod3mg42" );
	spotlight SetTurretTeam( "axis" );
	spotlight setmode( "manual" );
	spotlight SetConvergenceTime( 1, "yaw" );
	spotlight SetConvergenceTime( 1, "pitch" );

	spotlight endon( "death" );

	target_struct = getstruct( spotlight_origin.target, "targetname" );
	target_struct.ent = spawn( "script_origin", target_struct.origin );

	spotlight settargetentity( target_struct.ent );
	spotlight waittill( "turret_on_target" );

	spotlight thread whitehouse_spotlight_flicker();
	spotlight thread whitehouse_spotlight_damage();

	spotlight whitehouse_spotlight_pathing( target_struct );
	spotlight thread whitehouse_spotlight_targeting();

	flag_wait( "whitehouse_breached" );

	StopFXOnTag( level._effect[ "_attack_heli_spotlight" ], spotlight, "tag_flash" );
	spotlight notify( "death" );
}

whitehouse_spotlight_pathing( target_struct )
{
	self endon( "death" );
	target_ent = target_struct.ent;

	while( true )
	{
		if ( isdefined( target_struct.script_speed ) )
		{
			time = target_struct.script_speed/1000; // hacky use of speed to set the convergence time.
			self SetConvergenceTime( time, "yaw" );
			self SetConvergenceTime( time, "pitch" );
		}

		target_ent delete();
		target_ent = spawn( "script_origin", target_struct.origin );
		self settargetentity( target_ent );
		self waittill( "turret_on_target" );

		if ( isdefined( target_struct.script_flag_set ) )
			flag_set( target_struct.script_flag_set );

		target_struct script_delay();
		if ( isdefined( target_struct.script_flag_wait ) )
			flag_wait( target_struct.script_flag_wait );

		if ( !isdefined( target_struct.target ) )
			break;

		target_struct = getstruct( target_struct.target, "targetname" );
	}
}

whitehouse_spotlight_targeting()
{
	self endon( "death" );
	volume = getent( "entrance_stage_area", "targetname" );

	self SetConvergenceTime( 5, "yaw" );
	self SetConvergenceTime( 5, "pitch" );

	while( true )
	{
		ai_arr = getaiarray( "allies" );
		target_arr = [];
		foreach( ai in ai_arr )
		{
			if ( ai istouching( volume ) && !ai is_hero() )
				target_arr[ target_arr.size ] = ai;
		}

		if ( target_arr.size == 0 )
		{
			wait 1;
			continue;
		}

		target_ent = random( target_arr );
		self settargetentity( target_ent );

		self waittill( "turret_on_target" );
		wait randomfloatrange( 0.5, 1.5 );
	}
}

whitehouse_spotlight_flicker()
{
	self endon( "death" );

	flickers = randomintrange( 3, 5 );

	for ( i=0; i<flickers; i++ )
	{
		PlayFXOnTag( level._effect[ "_attack_heli_spotlight" ], self, "tag_flash" );
		wait randomfloatrange( 0.05, 0.15 );
		waittillframeend;
		StopFXOnTag( level._effect[ "_attack_heli_spotlight" ], self, "tag_flash" );
		wait randomfloatrange( 0.05, 0.15 );
		waittillframeend;
	}
	wait .1;
	PlayFXOnTag( level._effect[ "_attack_heli_spotlight" ], self, "tag_flash" );
}

whitehouse_spotlight_damage()
{
	self endon( "death" );

	trigger = getent( "spotlight_damage_trigger", "targetname" );

	total_damage = 0;

	damage = trigger waittill_player_damage( 400 );
	total_damage += damage;
	exploder( "spotlight_exploder" );

	StopFXOnTag( level._effect[ "_attack_heli_spotlight" ], self, "tag_flash" );
	self notify( "death" );
}

manual_mg_init( delay )
{
	self endon( "death" );

	if( isdefined( delay ) )
		wait randomint( 3 );

	self thread manual_mg_drone();

	self setmode( "auto_nonai" );
	self setturretteam( "axis" );
	self setbottomarc( 35 );
	self setleftarc( 90 );
	self setrightarc( 90 );

	self thread manual_mg_fire();

	if ( isdefined( self.target ) )
		self thread manual_mg_path();

	if ( isdefined( self.script_group ) )
	{
		level waittill( "sandbag_group_" + self.script_group );
		self thread manual_mg_stop();
	}
}

manual_mg_drone()
{
	self endon( "death" );

	drone_spawner = self get_linked_ent();
	self.drone = drone_spawner spawn_ai( true );
	self.drone.health = 250;

	self.drone waittill( "death" );

	level notify( "sandbag_group_" + self.script_group );
}

manual_mg_fire()
{
	self endon( "stop_firing" );
	while( true )
	{
		timer = randomfloatrange( 1, 2.5 ) * 20;
		for ( i = 0; i < timer; i++ )
		{
			self shootturret();
			wait( 0.05 );
		}
		wait randomfloatrange( 1, 3);
	}
}

manual_mg_path( start_target, noloop )
{
	self endon( "stop_path" );

	self SetConvergenceTime( 4, "yaw" );
	self SetConvergenceTime( 2, "pitch" );
	self SetAISpread( 0.4 );
	self SetMode( "manual" );

	if ( isdefined( start_target ) )
		self.current_target = start_target;
	else
		self.current_target = getstruct( self.target, "targetname" );

	target_ent = spawn( "script_origin", self.current_target.origin );

	while( true )
	{
		if ( isdefined( self.current_target.script_speed ) )
		{
			time = self.current_target.script_speed/1000; // hacky use of speed to set the convergence time.
			self SetConvergenceTime( time, "yaw" );
			self SetConvergenceTime( time, "pitch" );
		}

		target_ent delete();
		target_ent = spawn( "script_origin", self.current_target.origin );

		self settargetentity( target_ent );

		self turret_on_target( self.current_target );
//		self waittill( "turret_on_target" );
//		wait 0.5;

		if ( isdefined( self.current_target.target ) )
			self.current_target = getstruct( self.current_target.target, "targetname" );
		else if ( isdefined( self.target ) )
			self.current_target = getstruct( self.target, "targetname" );
		else
			break;
	}

	target_ent delete();
}

manual_mg_stop( delay )
{
	if ( isdefined( delay ) )
	{
		delay = delay * 3;
		wait randomfloatrange( delay, delay+2 );
	}

	if ( isdefined( self ) )
	{
		self notify( "stop_path" );
		self notify( "stop_firing" );
	}
	self delete();
	if ( isalive( self.drone ) )
		self.drone kill();
}

manual_mg_threat_trigger( turret )
{
	self waittill( "trigger" );
	if ( flag( "mg_threat" ) )
		return;

	turret setmode( "manual" );
	turret setturretteam( "axis" );
	turret setbottomarc( 45 );

	turret SetConvergenceTime( 0.25, "yaw" );
	turret SetConvergenceTime( 0.25, "pitch" );

	flag_set( "mg_threat" );
	start_target = getstruct( self.target, "targetname" );
	target_ent = spawn( "script_origin", start_target.origin );

	turret settargetentity( target_ent );
	turret waittill( "turret_on_target" );

	turret thread manual_mg_fire();
	turret manual_mg_path( start_target );

	turret notify( "stop_firing" );

	flag_clear( "mg_threat" );
}

magic_rpg_setup()
{
	trigger_arr = getentarray( "magic_rpg_trigger", "targetname" );
	array_thread( trigger_arr, ::magic_rpg_trigger );
}

magic_rpg_trigger()
{
	self waittill( "trigger" );

	source_arr = getstructarray( self.target, "targetname" );
	foreach( source in source_arr )
	{
		target_arr = getstructarray( source.target, "targetname" );
		array_thread( target_arr, ::magic_rpg, source );
	}
}

magic_rpg( source )
{
	self script_delay();
	rocket = MagicBullet( "rpg_straight", source.origin, self.origin );
}

sandbag_group_setup( str_targetname )
{
	sandbag_group_create_models( str_targetname );

	sandbag_array = getentarray( str_targetname, "targetname" );
	group_array = [];
	foreach( sandbag in sandbag_array  )
	{
		group_id = sandbag.script_group;
		if ( !isdefined( group_array[ group_id ] ) )
			group_array[ group_id ] = [];

		index = group_array[ group_id ].size;
		group_array[ group_id ][ index ] = sandbag;
	}

	foreach( group in group_array )
	{
		level thread sandbag_group( group );
	}
}

sandbag_group_create_models( str_targetname )
{
	struct_arr = getstructarray( str_targetname, "targetname" );
	foreach( struct in struct_arr )
	{
		model = spawn( "script_model", struct.origin );
		model.angles = struct.angles;
		model setmodel( struct.script_modelname );
		model.script_group = struct.script_group;
		model.script_index = struct.script_index;
		model.script_parameters = struct.script_parameters;
		model.targetname = struct.targetname;
		struct = undefined;
	}
}

sandbag_group( sandbag_array )
{
	group_struct = SpawnStruct();
	group_struct.hit_count = 0;
	array_thread( sandbag_array, ::sandbag_damage, group_struct );

	// vector hardcoded since that works for me in DCemp.
	vector = anglestoforward( (345, 180, 0) );
	force = vector * 3000;

	while( sandbag_array.size )
	{
		group_struct waittill( "damage", damaged_ent, damage );

		// lets all damaged bags report in.
		waittillframeend;

		if ( damage > 500 )
		{
			group_struct.hit_count = max( group_struct.hit_count, int( sandbag_array.size * 0.75 ) );
			level notify( "sandbag_group_" + damaged_ent.script_group );
		}

		for ( i = 0; i < group_struct.hit_count; i++ )
		{
			if ( i==0 )
			{
				bag = find_lowest_indexed_ent( sandbag_array, damaged_ent );
				if ( isdefined( bag.script_parameters ) )
				{
					group_struct.hit_count = sandbag_array.size;
					level notify( "sandbag_group_" + bag.script_group );
				}
			}
			else
				bag = find_lowest_indexed_ent( sandbag_array );

			bag notify( "thrown" );
			sandbag_array = array_remove( sandbag_array, bag );

			bag PhysicsLaunchClient( bag.origin, force );
		}

		group_struct.hit_count = 0;
		group_struct notify( "throw_done" );
	}
}

find_lowest_indexed_ent( ent_array, damaged_ent )
{
	current_index = 1000000;
	final_ent = undefined;
	foreach( ent in ent_array )
	{
		if ( ent.script_index > current_index )
			continue;
		current_index = ent.script_index;
		final_ent = ent;
	}

	if ( isdefined( damaged_ent ) && final_ent.script_index == damaged_ent.script_index )
		return damaged_ent;

	return final_ent;
}

sandbag_damage( group_struct )
{
	self endon( "thrown" );
	self.health = 10000;

	self SetCanDamage( true );

	while( true )
	{
		damage = self waittill_player_damage( 100 );
		group_struct.hit_count++;
		group_struct notify( "damage", self, damage );
		group_struct waittill( "throw_done" );
	}
}

whitehouse_cleanup_approach()
{
	// kill east side enemies and friendly mg guys
	allied_mg = get_ai_group_ai( "allied_mg" );
	foreach( ai in allied_mg )
		ai kill();

	enemies = get_ai_group_ai( "whitehouse_approach_enemies" );
	delay = 0;
	foreach( ai in enemies )
	{
		ai thread random_delayed_kill( delay );
		delay += 1;
	}

	flag_wait( "whitehouse_breached" );

	// stop enemy MGs
	mg_array = getentarray( "manual_mg", "script_noteworthy" );
	mg_array = array_add( mg_array, getent( "west_side_mg", "script_noteworthy" ) );

	for( i=0; i<mg_array.size; i++ )
		mg_array[i] thread manual_mg_stop( i+1 );

	// kill remaining exterior enemies
	axis_arr = getaiarray( "axis" );
	array_call( axis_arr, ::kill );

	// delete exterior allies
	ai_arr = getaiarray( "allies" );
	foreach( ai in ai_arr )
	{
		if ( ai is_hero() )
			continue;

		ai kill();
	}
}

whitehouse_mg_setup()
{
	mg_array = getentarray( "manual_mg", "script_noteworthy" );
	array_thread( mg_array, ::manual_mg_init, true );

	// trigger that activates the turret to fire infront of the player.
	turret = getent( "threat_mg", "targetname" );
	trigger_array = getentarray( "mg_threat_trigger", "targetname" );
	array_thread( trigger_array, ::manual_mg_threat_trigger, turret );
}

whitehouse_drone_slaughter()
{
	flag_wait( "whitehouse_silhouette_ready");

	rocket_source_arr = getentarray( "drone_rocket_source", "targetname" );
	drones = array_removeDead( level.whitehouse_drone_array );

	index = 0;
	while( drones.size )
	{
		source = rocket_source_arr[ index % rocket_source_arr.size ];
		MagicBullet( "rpg_straight", source.origin, random( drones ).origin );
		wait randomfloat( 2 );
		drones = array_removeDead( level.whitehouse_drone_array );
		index++;
	}

	flag_set( "whitehouse_silhouette_over");
}

whitehouse_rappel_setup()
{
	array_spawn_function_noteworthy( "whitehouse_rappel_ai", ::whitehouse_rappel );
}

whitehouse_rappel( data_struct )
{
	self endon( "death" );
	anim_ent = getent( self.target, "targetname" );

	rope = spawn_anim_model( "rope", anim_ent.origin );

	ents = [];
	ents[0] = self;
	ents[1] = rope;

	index = randomintrange( 1, 3 );

	self.animname = "rappel_guy";
	self.allowdeath = true;

	anim_ent thread anim_loop( ents , "rappel_stand_idle_" + index, "stop_loop" );

	flag_wait( "whitehouse_rappel" );
	anim_ent script_delay();

	anim_ent anim_stopanimscripted();

	rope delayCall( 9, ::delete );

	anim_ent anim_single( ents , "rappel_drop" , undefined, 4.3 );

	ent = getent( "rappel_goal", "targetname" );
	self setgoalpos( ent.origin );
	self.goalradius = 1024;
	self.goalheight = 128;
}

fake_flare( delay, tag, origin_offset, angles_offset )
{
	wait delay;

	flare = spawn( "script_model", (0,0,0) );
	flare setmodel( "mil_emergency_flare" );
	flare LinkTo( self, tag, origin_offset, angles_offset );
	PlayFXOnTag( level._effect[ "green_flare" ] , flare, "tag_fire_fx" );
	wait 12;
	StopFXOnTag( level._effect[ "green_flare" ] , flare, "tag_fire_fx" );
	wait 0.5;
	flare delete();
}

foley_flare_fx_start( guy )
{
	flare = spawn( "script_model", (0,0,0) );
	flare setmodel( "mil_emergency_flare" );
	flare LinkTo( guy, "tag_weapon_left", (0,0,0), (0,0,0) );

	flare_fx = getfx( "green_flare" );

	PlayFXOnTag( flare_fx , flare, "tag_fire_fx" );
	PlayFXOnTag( flare_fx , guy, "tag_fire_fx" );

	guy waittill( "remove_flare" );

	StopFXOnTag( flare_fx , flare, "tag_fire_fx" );
	StopFXOnTag( flare_fx , guy, "tag_fire_fx" );

	flare unlink();
	flare delete();
	guy Detach( "mil_emergency_flare", "tag_inhand" );
}

player_flare()
{
	level.player.flare = spawn( "script_model", (0,0,0) );
	level.player.flare setmodel( "mil_emergency_flare" );
	level.player.flare LinkTo( self, "tag_weapon_right", (0,0,0), (0,0,0) );
	level.player.flare endon( "death" );

	flag_wait( "flare_start_fx" );

	PlayFXOnTag( level._effect[ "green_flare" ] , level.player.flare, "tag_fire_fx" );
	level.player.flare PlayLoopSound( "emt_road_flare_burn" );

	flag_wait( "flare_end_fx" );

	start = level.player.flare.origin;
	end = start + (0,0,-64);

	ground = PhysicsTrace( start, end );
	level.player.flare.origin = ground + (0,0,1);
	level.player.flare.angles = ( 0, level.player.flare.angles[1], 0 );
}

door_open_kick()
{
	wait( 0.4 );

	self PlaySound( "door_wood_double_kick" );

	self ConnectPaths();
	self RotateTo( self.angles + ( 0, 90, 0 ), .5, .1, 0 );
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, -10, 0 ), .3, 0, .3 );
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 5, 0 ), .3, 0.15, 0.15 );
}

waittill_player_damage( damage_limit )
{

//	lets not wait for death anymore
//	self endon( "death" );

	if ( !isdefined( damage_limit ) ) 
		damage_limit = 0;

	state = false;
	total_damage = 0;

	while ( !state )
	{
		self waittill( "damage", damage, attacker );

		if ( attacker == level.player )
			total_damage += damage;

		state = ( total_damage > damage_limit );
	}

	return total_damage;
}

turret_on_target( target_ent )
{
	self waittill( "turret_on_target" );
	while( true )
	{
		aim_vector = anglestoforward( self gettagangles( "tag_flash" ) );
		target_vector = vectornormalize( target_ent.origin - self.origin );

		dot = vectordot( aim_vector, target_vector );
		if ( dot > 0.9999 )
			return;
		wait 0.05;
	}
}

random_delayed_kill( delay )
{
	self endon( "death" );
	wait randomfloatrange( delay, delay + 2 );

	self kill();
}

hero_dynamic_speed()
{
	// not used at this point

	self endon( "death" );
	self endon( "stop_dynamic_speed" );

	while( true )
	{
		if ( within_fov( level.player.origin, level.player.angles, self.origin, level.cosine[ "60" ] ) )
			self.moveplaybackrate = 1.0;
		else
			self.moveplaybackrate = 2.5;
		wait 0.05;
	}
}

chandelier_setup()
{
	chandelier_arr = getentarray( "chandelier", "targetname" );
	array_thread( chandelier_arr, ::chandelier );
}

chandelier()
{
	// get all parts
	parts = getentarray( self.target, "targetname" );

	self.wire = parts[0];
	self.light = parts[1];
	if ( parts[0].classname != "script_model" )
	{
		self.wire = parts[1];
		self.light = parts[0];
	}

	if ( isdefined( self.wire.target ) )
	{
		ceiling_struct = getstruct( self.wire.target, "targetname" );
		ceiling = ceiling_struct.origin;
	}
	else
		ceiling = PhysicsTrace( self.origin, self.origin + ( 0,0,80 ) );

	self.swing_origin = spawn( "script_origin", ceiling );
	self.swing = false;

	// connect all parts
	self linkto( self.swing_origin );
	self.wire linkto( self.swing_origin );
	self thread chandelier_link_light();

	// turn light on
	self.light SetLightIntensity( 1.5 );

	self thread chandelier_react();
}

chandelier_react()
{
	self endon( "chandelier_fall" );

	self SetCanDamage( true );
	self SetCanRadiusDamage( true );

	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type );

		if ( common_scripts\_destructible::getDamageType( type ) != "splash" )
			continue;

		self thread chandelier_swing( damage, direction_vec );
		self thread chandelier_flicker();
		if ( isdefined( self.script_parameters ) )
			self thread chandelier_fall();
	}
}

chandelier_swing( damage, direction_vec )
{
	self.swing = true;
	self notify( "chandelier_swing" );
	self endon( "chandelier_swing" );

	damage = clamp( damage, 0, 80 );
	multiplier = damage / 100;
	angle = 75 * multiplier;
	swing_speed = 0.4;

	weight_vector = vectornormalize( ( direction_vec[0] * -1, direction_vec[1], 0 ) );
	rotation = ( angle * weight_vector[0], 0, angle * weight_vector[1]);

	// first fast rotation from explosion
	self.swing_origin rotateto( rotation, swing_speed, 0, swing_speed );
	self.swing_origin waittill( "rotatedone" );

	while( abs( angle ) > 2 )
	{
		angle *= -0.75;
		rotation = ( angle*weight_vector[0], 0, angle*weight_vector[1] );

		self.swing_origin rotateto( rotation, swing_speed * 2, swing_speed, swing_speed );
		self.swing_origin waittill( "rotatedone" );
		self notify( "chandelier_turn" );
	}

	self.swing_origin rotateto( ( 0,0,0 ), swing_speed * 2, swing_speed, swing_speed );
	self.swing_origin waittill( "rotatedone" );
	self.swing = false;
	self notify( "chandelier_turn" );
}

chandelier_flicker()
{
	self endon( "chandelier_fall" );
	self endon( "chandelier_swing" );

	wait .5; // total wait ~5.4 sec.

	for( i=0; i<14; i++ )
	{
		self.light SetLightIntensity( 0 );
		self setmodel( "furniture_chandelier1_off" );
		wait randomfloatrange( 0.05, 0.2 ); // ~0.125
		self.light SetLightIntensity( randomfloatrange( 0.5, 1.5 ) );
		self setmodel( "furniture_chandelier1" );
		wait randomfloatrange( 0.15, 0.3 ); // ~0.225
	}
	self.light SetLightIntensity( 1.5 );
}

chandelier_fall()
{
	self endon( "chandelier_swing" );

	center_origin = self.light_origin.origin;
	wait randomfloatrange( 1, 4 );
	self notify( "chandelier_fall" );

	self.light SetLightIntensity( 4 );
	self setmodel( "furniture_chandelier1" );
	wait 0.05;
	self.light SetLightIntensity( 0 );
	self setmodel( "furniture_chandelier1_off" );

	PlayFX( level._effect[ "wire_spark" ], self.origin );

	if ( self.swing )
		self waittill( "chandelier_turn" );

	self unlink();

	vector = center_origin - self.light_origin.origin;
	self physicslaunchclient( self.light_origin.origin, vector * 2);
}

chandelier_link_light()
{
	self endon( "chandelier_fall" );

	self.light_origin = spawn( "script_origin", self.light.origin );
	self.light_origin linkto( self );

	while( true )
	{
		self waittill( "chandelier_swing" );
		while( self.swing )
		{
			self.light.origin = self.light_origin.origin;
			wait 0.05;
		}
	}
}

chandelier_get( noteworthy )
{
	ent_arr = getentarray( noteworthy, "script_noteworthy");
	chandelier = undefined;
	foreach( chandelier in ent_arr )
	{
		if ( chandelier.targetname == "chandelier" )
			break;
	}
	return chandelier;
}

chandelier_force_swing( damage, direction_vec )
{
	if ( !isdefined( direction_vec ) )
		direction_vec = (10,10,0);

	self notify( "damage", damage, undefined, direction_vec, undefined, "mod_grenade_splash" );
}

player_attached_use( hintstring )
{
	ent = Spawn( "script_origin", level.player.origin + (0,0,32) );
	ent makeusable();
	ent sethintstring( hintstring );
	ent linkto( level.player );

	level thread set_flag_on_trigger( ent, "remove_use_hint" );
	flag_wait( "remove_use_hint" );

	ent delete();
}

elapsed_time( start_time )
{
	return int( ( gettime() - start_time ) / 1000 );
}

rotate_vector( vector, rotation )
{
	right = anglestoright( rotation ) * -1;
	forward = anglestoforward( rotation );
	up = anglestoup( rotation );
	new_vector = forward * vector[ 0 ] + right * vector[ 1 ] + up * vector[ 2 ];
	return new_vector;
}

simple_drone_init()
{
	self useAnimTree( #animtree );
	self setCanDamage( true );
}

tunnels_teleport()
{
	trigger = getent( "tunnels_teleport_trigger", "targetname" );
	trigger waittill( "trigger" );

	flag_set( "tunnels_teleport" );

	fx_rain_pause();
	fx_rain_pause2();

	while( !level.player IsOnGround() )
		wait 0.05;
	
	flag_set( "end_fx" );
	
	// teleport player
	start_ent = getent( trigger.target, "targetname" );
	target_ent = getent( start_ent.target, "targetname" );

	angles_rotation = target_ent.angles - start_ent.angles;
	origin_offset = level.player.origin - start_ent.origin;
	origin_offset = rotate_vector( origin_offset, angles_rotation );
	player_angles_offset = level.player getplayerangles() - start_ent.angles;

	destination_origin = target_ent.origin + origin_offset;
	destination_angles = target_ent.angles + player_angles_offset;

	level.player SetOrigin( destination_origin );
	level.player setplayerangles( destination_angles );

	SetNorthYaw( 0.0 );

	// teleport ai
	volume = getent( "tunnels_teleport_volume", "targetname" );
	dest_arr = getstructarray( "tunnels_teleport_struct", "targetname" );
	index = 0;

	angles_rotation = target_ent.angles - start_ent.angles;
	foreach( ai in level.team ) 
	{
		origin_offset = ai.origin - start_ent.origin;
		origin_offset = rotate_vector( origin_offset, angles_rotation );
		ai_angles_offset = ai.angles - start_ent.angles;

		destination_origin = target_ent.origin + origin_offset;
		destination_angles = target_ent.angles + ai_angles_offset;

/*
		if ( !goal_in_volume( destination_origin, volume ) )
		{
			destination_origin = dest_arr[ index ].origin;
			destination_angles = dest_arr[ index ].angles;
			index++;
		}
*/
		ai ForceTeleport( destination_origin, destination_angles );
	}

	flag_set( "tunnels_teleport_done" );
}

goal_in_volume( origin, volume )
{
	ent = spawn( "script_model", origin );
	state = ent IsTouching( volume );
	ent delete();
	return state;
}

remove_drone_weapon()
{
	size = self GetAttachSize();
	for ( i=0; i<size; i++ )
	{
		model_name = self GetAttachModelName( i );
		tag_name = self GetAttachTagName( i );
		if ( IsSubStr( model_name, "weapon" ) )
			self detach( model_name, tag_name );
	}
}

force_flash_setup()
{
	array = getentarray( "force_flash", "targetname" );
	array_thread( array, ::force_flash );
}

force_flash()
{
	self waittill( "trigger" );
	thread maps\_weather::lightningFlash( maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );
}

