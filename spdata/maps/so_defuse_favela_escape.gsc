#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\favela_escape_code;
#include maps\_specialops;
#include maps\_specialops_code;

#using_animtree( "generic_human" );

main()
{
	level.friendlyfire_warnings = true;

	so_delete_all_by_type( ::type_spawn_trigger, ::type_spawners );

	base_map_assets();
	precacheItem( "briefcase_bomb_defuse_sp" );
	precacheModel( "prop_suitcase_bomb" );

	precachestring( &"SO_DEFUSE_FAVELA_ESCAPE_DEFUSING" );

	level._effect[ "light_c4_blink_nodlight" ] 			= loadfx( "misc/light_c4_blink_nodlight" );
	level.cosine[ "60" ] = cos( 60 );

	maps\_load::main();
	maps\_compass::setupMiniMap("compass_map_favela_escape");
	thread maps\favela_escape_amb::main();

	defuse_setup();
}

base_map_assets()
{
	maps\createart\favela_escape_art::main();
	maps\createfx\favela_escape_fx::main();
	maps\favela_escape_precache::main();
	maps\favela_escape_fx::main();
	maps\_hiding_door_anims::main();
}

defuse_setup()
{
	airliner_delete();

	clean_up_setup();

	// 5 minutes in all.
	level.challenge_time_limit = 300;

	flag_init( "defuse_update_score" );

	array_spawn_function_targetname( "civilian", ::civilian );
//	add_global_spawn_function( "axis", ::ai_on_death );
//	array_thread ( level.players, ::player_defuse_kill_clear );

	// delete some spawners if not coop
	if ( !is_coop() )
	{
		spawners = getentarray( "coop_only", "script_noteworthy" );
		array_call( spawners, ::delete );
	}

	level thread enable_escape_warning();
	level thread enable_escape_failure();

	level thread open_door( "sbmodel_market_door_1" );
	level thread open_door( "sbmodel_vista1_door1" );

	change_combatmode_setup();

	thread fade_challenge_in();
	music_loop( "so_defuse_favela_escape_music", 99 );

	level thread enable_challenge_timer( "defuse_start", "defuse_complete" );
	level thread fade_challenge_out( "defuse_complete" );

	level thread defuse_objectives();
}

defuse_objectives()
{
	level endon( "special_op_terminated" );

	level.defuse_count = 0;

	// each index corresponds to a script_index key on the bomb in radiant.
	level.objective_arr = [];
	level.objective_arr[0] = &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_BOMB_MARKET";
	level.objective_arr[1] = &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_BOMB_APARTMENT";
	level.objective_arr[2] = &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_BOMB_STORE";

	defuse_location_arr = getentarray( "defuse_briefcase", "targetname" );
	array_thread( defuse_location_arr, ::defuse_location_handler );

	foreach( location in defuse_location_arr )
	{
		obj_id = location.script_index;
		Objective_Add( location.script_index, "current", level.objective_arr[ obj_id ], location.origin + (0,0,24) );
		location thread obj_switch_text( 400, obj_id );
	}

	while( level.defuse_count != 0 )
	{
		obj_id = flag_wait( "defuse_update_score" ); // obj_id passed from ::briefcase_defuse( ... )
		flag_clear( "defuse_update_score" );

		if ( isdefined( obj_id ) )
			objective_state( obj_id, "done" );
	}

	flag_set( "defuse_complete" );
}

obj_switch_text( dist, obj_id )
{
	// stop switching text once the bomb is defused
	self endon( "briefcase_bomb_defused" );

	while( true )
	{
		wait 0.05;

		close = false;
		foreach( player in level.players )
		{
			if ( squared( dist ) > distancesquared( self.origin, player.origin ) )
			{
				close = true;
				break;
			}
		}

		if ( close )
		{
			Objective_SetPointerTextOverride( obj_id, &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_TEXT" );
			dist = 800;
		}
		else
		{
			Objective_SetPointerTextOverride( obj_id, "" );
			dist = 400;
		}
	}
}

open_door( door_name )
{
	door = getent( door_name, "targetname" );
	linker = GetEnt( door.target, "targetname" );
	door LinkTo( linker );
	door ConnectPaths();
	linker RotateTo( linker.script_angles, .5 );
	linker waittill( "rotatedone" );
	door Unlink();
}

defuse_location_handler()
{
	self ent_flag_init( "briefcase_bomb_defused" );

	level.defuse_count++;

	bomb_array = getentarray( self.target, "targetname" );
	array_thread( bomb_array, ::defuse_c4_light, self );

	while( !self ent_flag( "briefcase_bomb_defused" ) )
	{
		self makeusable();
		self sethintstring( &"SO_DEFUSE_FAVELA_ESCAPE_DEFUSE_HINT" );

		self waittill( "trigger", player );
		self MakeUnusable();
		player briefcase_defuse( self );
	}
}

defuse_c4_light( briefcase )
{
	if ( self.model == "weapon_c4" )
	{
		wait randomfloat( 0.5 );
		fx = PlayLoopedFX( getfx( "light_c4_blink_nodlight" ), 1, self gettagorigin( "tag_fx" ) );
		briefcase ent_flag_wait( "briefcase_bomb_defused" );
		fx delete();
	}
}

change_combatmode_setup()
{
	array = getstructarray( "change_combatmode_node", "script_noteworthy" );
	array_thread( array, ::change_combatmode_node );

	array = getentarray( "change_combatmode_trigger", "targetname" );
	array_thread( array, ::change_combatmode_trigger );
}

change_combatmode_trigger()
{
	origin_ent = getent( self.target, "targetname" );

	dist_sqrd = origin_ent.radius * origin_ent.radius;

	while( true )
	{
		self waittill( "trigger", player );
		assert( isplayer( player ) );

		ai_array = getaiarray( "axis" );
		foreach( ai in ai_array )
		{
			if ( distancesquared( ai.origin, origin_ent.origin ) > dist_sqrd )
				continue;

			ai notify( "stop_going_to_node" );
			ai.combatMode = "cover";
			ai.goalradius = 640;
			ai setgoalentity( player );
		}
		wait 10;
	}
}

change_combatmode_node()
{
	assert( isdefined( self.script_combatmode ) );

	while( true )
	{
		self waittill( "trigger", ai );
		assert( isai( ai ) );
		ai.combatMode = self.script_combatmode;
	}
}

clean_up_setup()
{
	add_global_spawn_function( "axis", ::clean_up_spawnfunc );

	array = getentarray( "clean_up_volume", "targetname" );
	array_thread( array, ::clean_up_volume );

	array = getentarray( "clean_up_respawn_trigger", "script_noteworthy" );
	array_thread( array, ::clean_up_respawn_trigger );

}

clean_up_volume()
{
	assert( isdefined( self.script_group ) );

	volume = self;

	while( true )
	{
		wait 1;
		player_in_volume = false;
		foreach( player in level.players )
		{
			if ( player istouching( volume ) )
			{
				player_in_volume = true;
				break;
			}
		}

		if ( !player_in_volume )
			level notify( "clean_up", volume.script_group );
	}
}

clean_up_spawnfunc()
{
	self endon( "death" );

	if ( !isdefined( self.script_group ) )
		return;

	spawner = self.spawner;

	while( true )
	{
		level waittill( "clean_up", script_group );
		if ( self.script_group != script_group )
			continue;

		// to avoid multiple traces on the same frame
		wait randomfloat( .3 );

		can_be_seen = false;
		foreach( player in level.players )
		{
			if ( self SightConeTrace( player geteye(), player ) )
			{
				can_be_seen = true;
				break;
			}
		}

		if ( !can_be_seen )
		{
			spawner.count++;
			self delete();
		}
	}
}

clean_up_respawn_trigger()
{
	assert( isdefined( self.script_group ) );

	while( true )
	{
		self waittill( "trigger" );
		while( true )
		{
			level waittill( "clean_up", script_group );

			if ( self.script_group != script_group )
				continue;

			self thread maps\_spawner::trigger_spawner( self );
			break;
		}
	}
}

civilian()
{
	self endon( "death" );

	self thread civilian_death();

	self waittill( "reached_path_end" );

	timer = 0;
	dist = 2000 * 2000;

	while( timer < 10 )
	{
		is_safe = true;
		foreach( player in level.players )
		{
			if ( DistanceSquared( self.origin, player.origin ) < dist )
			{
				is_safe = false;
				break;
			}

			if ( within_fov( player.origin, player.angles, self.origin, level.cosine[ "60" ] ) )
			{
				is_safe = false;
				break;
			}			
		}

		if ( is_safe )
		{
			timer++;
		}
		else
		{
			timer = 0;
		}

		wait 0.5;
	}

	self delete();
}

civilian_death()
{
	level endon( "defuse_complete" );
	level endon( "missionfailed" );
	level endon( "special_op_terminated" );

	self waittill( "death", killer, type );
	
	if ( !isplayer( killer ) )
		return;

	so_force_deadquote( "@SO_DEFUSE_FAVELA_ESCAPE_MISSION_FAILED_CIVILIAN" );
	thread missionfailedwrapper();
}

ai_on_death()
{
	self waittill( "death", attacker, cause );

	if ( !isplayer( attacker ) )
		return;

	attacker.defuse_kills++;
	if ( self isFlashed() )
		attacker.defuse_flashed_kills++;
	if ( common_scripts\_destructible::getDamageType( cause ) == "splash" )	
		attacker.defuse_frag_kills++;
	if ( common_scripts\_destructible::getDamageType( cause ) == "melee" )	
		attacker.defuse_knife_kills++;

	flag_set( "defuse_update_score" );
}

player_defuse_kill_clear()
{
	self.defuse_kills = 0;
	self.defuse_flashed_kills = 0;
	self.defuse_frag_kills = 0;
	self.defuse_knife_kills = 0;
}

briefcase_defuse( briefcase )
{
	// link player
	self playerLinkTo( briefcase );
	self PlayerLinkedOffsetEnable();

	// get current weapon?
	lastWeapon = self getCurrentWeapon();

	// give briefcase weapon
	self giveWeapon( "briefcase_bomb_defuse_sp" );
	self setWeaponAmmoStock( "briefcase_bomb_defuse_sp", 0 );
	self setWeaponAmmoClip( "briefcase_bomb_defuse_sp", 0 );
	self switchToWeapon( "briefcase_bomb_defuse_sp" );
	self DisableWeaponSwitch();
	self DisableOffhandWeapons();
	self AllowMelee( false );

	briefcase hide();

	self thread downed_while_defusing( lastWeapon, briefcase );

	self waittill_either( "coop_downed", "weapon_change" );

	if ( !self ent_flag_exist( "coop_downed" ) || !self ent_flag( "coop_downed" ) )
	{
		// Add 3D Person Briefcase
		self attach_briefcase_model();

		if ( !self ent_flag_exist( "coop_downed" ) || !self ent_flag( "coop_downed" ) )
		{
			// display usebar
			if ( self defuse_use_bar( 4.5, briefcase ) )
			{
				briefcase ent_flag_set( "briefcase_bomb_defused" );
				level.defuse_count--;
				flag_set( "defuse_update_score", briefcase.script_index );
			}
		}

		// remove 3d person briefcase
		self detach_briefcase_model();
	}

	briefcase show();

	primary_weapons = self GetWeaponsListPrimaries();
	assert( primary_weapons.size > 0 );

	// defensive, I don't know that I'll always save a valid primary weapon.
	if ( !is_in_array( self GetWeaponsListPrimaries(), lastWeapon ) )
	{
		lastWeapon = primary_weapons[0];
	}

	// switch back to lastWeapon
	self switchToWeapon( lastWeapon );
	self unlink();
	self waittill( "weapon_change" );

	wait .5; // buffer time between tries.

	self AllowMelee( true );
	self EnableOffhandWeapons();
	self EnableWeaponSwitch();		
}

downed_while_defusing( lastWeapon, briefcase )
{
	if ( self ent_flag_exist( "coop_downed" ) )
	{
		briefcase endon( "briefcase_bomb_defused" );
		self ent_flag_wait( "coop_downed" );

		self SwitchToWeaponImmediate( lastWeapon );
	}
}

defuse_use_bar( fill_time, briefcase )
{
	briefcase.defuse_time = 0;

	buttonTime = briefcase.defuse_time;
	totalTime = fill_time;
	bar = self createClientProgressBar( self, 57 );

    text = self createClientFontString( "default", 1.2 );
    text setPoint( "CENTER", undefined, 0, 45 ); // old 20
	text settext( &"SO_DEFUSE_FAVELA_ESCAPE_DEFUSING" );

	while ( self use_active() )
	{
		bar updateBar( buttonTime / totalTime );
		wait( 0.05 );
		buttonTime += 0.05;
		if ( buttonTime > totalTime )
		{
			self notify_area_clear();
			text destroyElem();
			bar destroyElem();
			return true;
		}
	}

	briefcase.defuse_time = buttonTime;
	text destroyElem();
	bar destroyElem();

	return false;
}

notify_area_clear()
{
	if ( isdefined( level.area_clear_time ) )
	{
		if ( ( level.area_clear_time + 5000 ) > gettime() )
			return;
	}

	level.area_clear_time = gettime();
	self notify( "so_bcs_area_secure" );
}

use_active()
{
	if ( !self UseButtonPressed() )
		return false;
	if ( flag( "special_op_failed" ) )
		return false;
	if ( self ent_flag_exist( "coop_downed" ) && self ent_flag( "coop_downed" ) )
		return false;

	return true;
}

attach_briefcase_model()
{
	wait ( 0.6 );
	self attach( "prop_suitcase_bomb", "tag_inhand", true );
}


detach_briefcase_model()
{
	wait ( 0.5 );
	self detach( "prop_suitcase_bomb", "tag_inhand", true );
}

airliner_delete()
{
	ents = GetEntArray( "sbmodel_airliner_flyby", "targetname" );
	array_call( ents, ::delete );
}
