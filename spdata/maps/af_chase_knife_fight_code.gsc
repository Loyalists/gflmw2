#include maps\_utility;
#include common_scripts\utility;
#include animscripts\utility;
#include maps\_anim;
#include maps\_vehicle;
//#include maps\af_chase_code;
//#include maps\af_chase_zodiac;
#include maps\_hud_util;

ENDING_MOVE_SPEED = 0.45;

ending_common_speed()
{
	if ( level.start_point == "turnbuckle" )
	{
		level.player blend_movespeedscale( ENDING_MOVE_SPEED, 0.1 );
	}
	else
	{
		level.player blend_movespeedscale( 0.25, 0.1 );
		level.player delayThread( 3, ::blend_movespeedscale, ENDING_MOVE_SPEED, 10 );
	}
}

fade_in_from_crash()
{
	black_overlay = get_black_overlay();
	black_overlay.alpha = 1;
	fade_in_time = 4;
	wait( 2 );
	black_overlay FadeOverTime( fade_in_time );
	black_overlay.alpha = 0;

	level.player SetWaterSheeting( 1, 5 );
}

crawling_guy_crawls()
{
	self.health = 1;
	self.ignoreExplosionEvents = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.IgnoreRandomBulletDamage = true;
	self.grenadeawareness = 0;
	self.no_pain_sound = true;
	self.DropWeapon = false;
	self.skipBloodPool = true;
	self disable_surprise();
	self animscripts\shared::DropAllAIWeapons();

	self ForceTeleport( ( 27115.7, 32538.7, -9883.9 ), ( 0, 273.875, 0 ) );

	self.a.pose = "prone";

	self endon( "death" );
	self allowedstances( "prone" );


	angles = self.angles;
	angles = set_y( (0,0,0), angles[1] + 10 );
	forward = anglestoforward( angles );
	pos = self.origin + forward * 200;
	//Line( self.origin, pos, (1,0,0), 1, 0, 5000 );
	
	self Teleport( pos, angles );
	level.crawler = self;
	thread hint_melee();

	self anim_generic_first_frame( self, "civilian_crawl_1" );
	self force_crawling_death( self.angles[ 1 ] + 10, 7, level.scr_anim[ "crawl_death_1" ], 1 );
	
	childthread crawler_sound_notetracks();
	
	// skip ahead to better frame
	animation = getanim_generic( "civilian_crawl_1" );
	wait( 0.05 );
	self SetAnimTime( animation, 0.4 );

	flag_wait( "crawling_guy_starts" );
	
	
	angles = vectortoangles( level.player.origin - self.origin );
	angles = set_y( (0,0,0), angles[1] );
	
	add_damage_function( ::crawler_deathsound );

	self Teleport( self.origin, angles );
	self.a.force_crawl_angle = angles[1];
	
	self pain_smear_teleport_forward( 470 );

	//animscripts\pain::crawlingPistol();

	self DoDamage( 1, level.player.origin );
	self.noragdoll = 1;

	wait( 1 );
	self.diequietly = true;
}

crawler_deathsound( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	if ( !isdefined( self ) )
		return;
	if ( !isalive( attacker ) )
		return;
	if ( attacker != level.player )
		return;
		
	self play_sound_in_space( "scn_afchase_crawling_guy_death", self.origin );
}

crawler_sound_notetracks()
{
	
	for ( ;; )
	{
		self waittill( "crawling", notetrack );
		if ( notetrack == "scn_afchase_dying_crawl" )
			self playsound( "scn_afchase_dying_crawl" );
	}
}



pain_smear_teleport_forward( teleport_dist )
{
	smear_dist = teleport_dist;
	smear_dist += 44;

	splatter_dist = 12;
	move_time = 2;

	splatter_time = ( splatter_dist / smear_dist ) * move_time;

	pain_smear_ent = Spawn( "script_origin", self.origin );

	pain_smear_ent.angles = self.angles;

	forward = AnglesToForward( self.angles );
	forward = VectorNormalize( forward ) * smear_dist;

	teleport_forward = VectorNormalize( forward ) * teleport_dist;

	destination = self.origin + forward;
	teleport_destination = self.origin + teleport_forward;

	pain_smear_ent MoveTo( destination, move_time );
	pain_smear_ent thread pain_smear_for_time( splatter_time );
	pain_smear_ent delayCall( move_time, ::Delete );

	self.a.crawl_fx_rate = .3;// thin out blood cause it starts to pull the other blood out.

	self ForceTeleport( drop_to_ground( teleport_destination ), self.angles );

}

pain_smear_for_time( fx_rate )
{
	fx = level._effect[ "crawling_death_blood_smear" ];

	self endon( "death" );

	last_org = self.origin;

	while ( fx_rate )
	{
		randomoffset = flat_origin( randomvectorrange( -10, 10 ) );
		org = self.origin + randomoffset;
		org = drop_to_ground( org ) + ( 0, 0, 5 );
		angles = VectorToAngles( self.origin - last_org );
		forward = AnglesToRight( angles );
		up = AnglesToForward( ( 270, 0, 0 ) );
//		Line( org, level.player.origin,(0,0,0),1,false,40 );
		PlayFX( fx, org, up, forward );
		wait( fx_rate );
	}
}

fade_out( fade_out_time )
{
	black_overlay = get_black_overlay();
	if ( fade_out_time )
		black_overlay FadeOverTime( fade_out_time );

	black_overlay.alpha = 1;
	thread eq_changes( 0.5, fade_out_time );
}

eq_changes( val, fade_time )
{
	if ( IsDefined( level.override_eq ) )
		return;
	if ( !isdefined( level.eq_ent ) )
	{
		waittillframeend;// so e~q_ent will be defined
		waittillframeend; // if came from a start_ function
	}
		
	if ( fade_time )
		level.eq_ent MoveTo( ( val, 0, 0 ), fade_time );
	else
		level.eq_ent.origin = ( val, 0, 0 );
}

fade_in( fade_time )
{
	if ( level.MissionFailed )
		return;
	level notify( "now_fade_in" );
		
	black_overlay = get_black_overlay();
	if ( fade_time )
		black_overlay FadeOverTime( fade_time );

	black_overlay.alpha = 0;

	thread eq_changes( 0.0, fade_time );
}

get_anim_node()
{
	if ( !isdefined( level.knife_fight_animnode ) )
	{
		level.knife_fight_animnode = Spawn( "script_origin", ( 0, 0, 0 ) );
		anim_node = getstruct( "end_scene_org", "targetname" );
		level.knife_fight_animnode.origin = anim_node.origin;
		level.knife_fight_animnode.angles = anim_node.angles;
	}

	return level.knife_fight_animnode;
}

get_anim_node_rotated()
{
	if ( 1 ) return get_anim_node();

	return getstruct( "end_scene_org_new", "targetname" );
}

spawn_price()
{
	spawner = GetEnt( "boatrider0", "targetname" );
	spawner.count = 1;

	guy = spawner spawn_ai( true );
	Assert( IsDefined( guy ) );
	guy gun_remove();

	level.price  = maps\_vehicle_aianim::convert_guy_to_drone( guy );// cause I don't want to add _drone::init..bleh

	level.price.animname = "price";
//	level.price.ignoreall = true;
//	level.price.ignoreme = true;
//	level.price make_hero();
//	level.price standby();
}

spawn_nikolai()
{
	Assert( !isdefined( level.nikolai ) );
	spawner = GetEnt( "nikolai", "targetname" );
	spawner.count = 1;
	level.nikolai = spawner spawn_ai( true );
	Assert( IsDefined( level.nikolai ) );
	level.nikolai.animname = "nikolai";
	level.nikolai.ignoreall = true;
	level.nikolai.ignoreme = true;
	level.nikolai make_hero();
}

link_player_to_arms()
{
	player_rig = get_player_rig();
	player_rig Show();
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
}

blend_player_to_turn_buckle()
{
	player_rig = get_player_rig();



	last_melee_difference = GetTime() - level.melee_button_pressed_last;
	if ( last_melee_difference > 0 )
		last_melee_difference = last_melee_difference / 1000;
	stab_time = .4 - last_melee_difference;

	if ( flag( "player_touched_shepherd" ) )
		stab_time = .4;

	level.player PlayerLinkToBlend( player_rig, "tag_player", stab_time, 0, 0 );
	thread kill_shepherds_melee_sounds_for_time( stab_time + .4 );
	wait stab_time;
	level.player TakeAllWeapons();
	player_rig Show();
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
}

kill_shepherds_melee_sounds_for_time( time )
{
	incs = time / .05; 
	for ( i = 0; i < incs; i++ )
	{
		// I have no idea when the code melee hit happens so keep stopping sounds!
		level.shepherd stopsounds();
		wait .05;
	}
}

ending_common_wounded()
{
	level.player AllowStand( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
}

blend_player_to_crawl()
{
	player_rig = get_player_rig();
	blend_time = .3;

	ending_common_wounded();

	level.player PlayerLinkToBlend( player_rig, "tag_player", blend_time, 0, 0 );
	wait blend_time;
	level.player TakeAllWeapons();
	player_rig Show();
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 5, 5, 5, 5, true );
}

blend_player_to_walk_off()
{
	player_rig = get_player_rig();

	transitiontime = .4;
	level.player AllowStand( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player PlayerLinkToBlend( player_rig, "tag_player", transitiontime, 0, 0 );
	wait transitiontime;
	level.player TakeAllWeapons();
	player_rig Show();
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 10, 10, 10, 10, true );
}


give_knife_fight_weapon()
{
	weapon = "ending_knife";
	level.player GiveWeapon( weapon );
	level.player SetWeaponAmmoStock( weapon, 0 );
	level.player SetWeaponAmmoClip( weapon, 0 );
	level.player SwitchToWeapon( weapon );
	level.player FreezeControls( false );
}

spawn_fake_wrestlers()
{
	wait 0.05;// delay cause if we spawn on first frame it'll fail because it'll be two spawns from one spawner in a single frame
	spawners = [];
	spawners[ "shepherd" ] 		 = GetEnt( "shepard", "targetname" );
	spawners[ "price" ] 		 = GetEnt( "boatrider0", "targetname" );

	guys = [];

	foreach ( name, spawner in spawners )
	{
		spawner.count = 1;
		guy = spawner StalingradSpawn();
		if ( spawn_failed( guy ) )
			return;
		guys[ name ] = guy;
	}

	level.fake_wrestlers = guys;

	foreach ( name, guy in guys )
	{
		guy gun_remove();
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy hide_notsolid();
		guy.animname = name;
	}

	scene = 	"fight_D3_swapped";
	tag_origin = spawn_tag_origin();
	struct = getstruct( "endorg_new_fight", "targetname" );
	tag_origin.origin = struct.origin;
	tag_origin.angles = struct.angles;

	struct thread anim_first_frame( guys, scene );
//	wait 0.05;
//	
//	start_percent = 0.08;
//	
	foreach ( guy in guys )
	{
		guy LinkTo( tag_origin );

//		animation = guy getanim( scene );
//		guy SetAnim( animation, 1, 0, 0 ); // pause the anim
//		guy SetAnimTime( animation, start_percent );
	}

	flag_wait( "price_shepherd_fight_e_flag" );

	player_eye = level.player GetEye();
	price_eye = guys[ "price" ] GetEye();
	angles = VectorToAngles( player_eye - price_eye );
	right = AnglesToRight( angles );
	forward = AnglesToForward( angles );
	
	//Line( player_eye, player_eye + forward * 500, (1,1,0), 1, 0, 5000 );

	tag_origin.origin += right * 15 + forward * -50;
	//Line( struct.origin, tag_origin.origin, (1,1,0), 1, 0, 5000 );

//	flag_wait( "player_uses_knife" );

//	wait 2.1;

	
	blend_to_blurry_fake_wrestlers_dof( 1.2 );
	wait 0.05;

	/*
	fighters = [];
	fighters[ "shepherd" ] = level.shepherd;
	fighters[ "price" ] = level.price;

	struct = getstruct( "endorg_new_fight", "targetname" );
	struct thread anim_single( fighters, "fight_D3_swapped" );
	wait( 1.2 );

	blend_to_knife_dof( 1.2 );
	
	*/


	time = 1.2;
	tag_origin MoveTo( struct.origin, time, 0, time );
//	SetBlur( 15, time );
	//Earthquake( 0.5, 1.2, level.player.origin, 5000 );

	new_origin = spawn_tag_origin();
	level.price LinkTo( new_origin );
	level.shepherd LinkTo( new_origin );
	new_org = new_origin.origin + right * 15 + forward * -50;
	new_origin MoveTo( new_org, time, time, 0 );

	foreach ( guy in guys )
	{
		guy show_solid();
//		animation = guy getanim( scene );
//		guy SetAnim( animation, 1, 0, 1 );// unpause the anim
	}
	
	level.price stopsounds();
	level.shepherd stopsounds();
	
	tag_origin thread anim_single( guys, scene );
	maps\af_chase_anim::remove_fighte_animsounds();

	wait 1.2;
//	SetBlur( 0, 0.5 );

	blend_to_knife_dof( 1.2 );

	level.price hide_notsolid();
	level.shepherd hide_notsolid();

//	flag_wait( "two_hand_pull_begins" );
	level waittill( "knife_pulled_out" );
//	wait 3;
	wait 1.2;
	foreach ( guy in guys )
	{
		guy Delete();
	}
}

spawn_shepherd()
{
	shepherd_spawner = GetEnt( "shepard", "targetname" );
	shepherd = shepherd_spawner StalingradSpawn( 0, "spawned_shepherd" );
	spawn_fail = spawn_failed( shepherd );

	level.shepherd = shepherd;
	Assert( !spawn_fail );

//	shepherd SetModel( "body_vil_shepherd_no_gun" );

	flag_set( "shepherd_spawned" );
	shepherd magic_bullet_shield();
	shepherd.ignoreme = true;
	shepherd.ignoreall = true;
	shepherd.fixednode = 0;
	shepherd.animname = "shepherd";
	shepherd gun_remove();
	shepherd disable_surprise();
	shepherd disable_arrivals();
	shepherd disable_exits();
	shepherd set_battlechatter( false );
	shepherd make_hero();
	shepherd set_goal_pos( shepherd.origin );
}

get_player_rig()
{
	if ( !isdefined( level.player_rig ) )
		level.player_rig = spawn_anim_model( "player_rig" );

	if ( flag( "bloody_player_rig" ) )
		level.player_rig setmodel ( "ch_viewhands_player_gk_m4_sopmod_ii" );

	return level.player_rig;
}

get_player_body()
{
	if ( !isdefined( level.player_body ) )
		level.player_body = spawn_anim_model( "player_body" );
	return level.player_body;
}

get_gun_model()
{
	if ( !isdefined( level.gun_model ) )
		level.gun_model = spawn_anim_model( "gun_model" );

	return level.gun_model;
}

shepherd_stumbles_out_of_helicopter()
{
	/*
	level endon( "never_shepherd_stumble" );
	thread recover_objective_if_player_skips_scene();
	//flag_wait( "shepherd_stumbles_by" );

	wait 2;
	thread play_helicopter_exit_sound();

	struct = getstruct( "shepherd_spawncheck_struct", "targetname" );
	*/

	spawner = GetEnt( "shepherd_stumble_spawner", "targetname" );
	spawner add_spawn_function( ::shepherd_stumbles );
	spawner spawn_ai();
}

play_helicopter_exit_sound()
{
	if ( flag( "helicopter_sound_played" ) )
		return;

	spawner = GetEnt( "shepherd_stumble_spawner", "targetname" );
	flag_set( "helicopter_sound_played" );
	thread play_sound_in_space( "helicopter_door_slams", spawner.origin );
}

shep_trace_passed()
{
	start = level.player.origin + ( 0, 0, 32 );

	offset = 0;
	for ( i = 0; i <= 3; i++ )
	{
		end = self GetEye() + ( 0, 0, offset );
		offset += 16;
		trace = BulletTrace( start, end, false, undefined );
		if ( trace[ "fraction" ] >= 1 )
			return true;
		if ( trace[ "surfacetype" ] == "none" )
			return true;
	}
	return false;
}

compass_onscreen_updater()
{
	SetSavedDvar( "objectiveFadeTooFar", 100 );
	SetSavedDvar( "objectiveHideIcon", 1 );
	level.compass_ent = self;
	for ( ;; )
	{
		if ( isdefined( level.ground_ref_ent ) )
			break;
		wait 0.05;
	}

	flag_wait( "player_standing" );

	update_compass_until_shepherd_runs();
	SetSavedDvar( "compass", 1 );

//	Objective_Position( obj( "get_shepherd" ), (0,0,0) );
//	wait 0.5;
//	Objective_OnEntity( obj( "get_shepherd" ), self, (0,0,90) );
//	SetSavedDvar( "objectiveFadeTimeWaitOn", 0.5 );
//	SetSavedDvar( "objectiveFadeTimeWaitOff", 0.1 );
//	SetSavedDvar( "objectiveFadeTooFar", 30 );
//	SetSavedDvar( "objectiveHideIcon", 0 );
}	

update_compass_until_shepherd_runs()
{
	level endon( "shepherd_runs" );
	
	for ( ;; )
	{
		//angles = level.ground_ref_ent.angles;
//		show_compass = !level.player WorldPointInReticle_Circle( level.compass_ent.origin, 65, 400 );
		eyepos = level.player geteye();
		angles = level.player getplayerangles();
		
		forward = anglestoforward( angles );
		start = eyepos + forward * 100 + (0,0,-16);
		end = eyepos + forward * 100 + (0,0,16);
		//Line( start, end, (1,1,1), 1, 1, 3 );
		
		show_compass = !within_fov( eyepos, angles, level.compass_ent.origin, 0.35 );
		setsaveddvar( "compass", show_compass );
		wait 0.05;
	}		
}

shepherd_stumbles()
{
	thread compass_onscreen_updater();
	// Kill
	Objective_SetPointerTextOverride( obj( "get_shepherd" ), &"SCRIPT_WAYPOINT_SHEPHERD" );
	Objective_OnEntity( obj( "get_shepherd" ), self, (0,0,90) );
	self.animname = "shepherd";
	self thread scale_player_if_close_to_shepherd();
	self SetContents( 0 );
	self.ignoreall = true;
	self gun_remove();
	self.health = 5000;
	self.allowPain = false;
	self set_run_anim( "run" );
	self disable_arrivals();
	self set_battlechatter( false );
	level.shepherd hide();
//	SetSavedDvar( "compass", 1 );
	
	level.shepherd_stumble = self;
	struct = getstruct( "shepherd_spawncheck_struct", "targetname" );

	scene = "flee";
	prone_anim = "prone_stand";


	self AllowedStances( "prone" );
	self Teleport( self.origin, ( 0, 50, 0 ) );

	self.prone_anim_override = self getanim( "prone_stand" );
	self.prone_rate_override = 2;

	for ( ;; )
	{
		trace_passed = shep_trace_passed();

		if ( flag( "never_shepherd_stumble" ) )
			break;

		if ( trace_passed && flag( "shepherd_can_run" ) )// && see_moment_spot )// && !flag( "dont_spawn_shepherd_stumble" ) )
			break;

		wait 0.05;
	}

	level notify( "run_shep_run" );

	self AllowedStances( "stand" );
//	self thread anim_custom_animmode_solo( self, "gravity", "prone_stand" );
//	wait 50;
////	wait 0.05;
//	animation = self getanim( "prone_stand" );
//	self SetAnim( animation, 1, 0, 2 );
//	wait 1.2;
//	self notify( "stopanimscripted" );


	thread play_helicopter_exit_sound();


	struct = getstruct( self.target, "targetname" );
	struct anim_reach_solo( self, "flee" );


	level notify( "shepherd_runs" );
	//SetSavedDvar( "compass", 1 );
	goal_struct = getstruct( "start_player_turnbuckle", "targetname" );
	self SetGoalPos( goal_struct.origin );
	thread make_clouds_near_goal_struct( goal_struct );

	delayThread( 3, ::flag_set, "fog_out_stumble_shepherd" );

	animation = self getanim( "flee" );
	time = GetAnimLength( animation );
	start_time = GetTime();
	struct thread anim_custom_animmode_solo( self, "gravity", "flee" );
	self playsound( "scn_afchase_shepherd_runoff" );

	wait_for_buffer_time_to_pass( start_time, time - 2.4 );

	wait_for_buffer_time_to_pass( start_time, time - 2.0 );

	stumble_path = getstruct( "stumble_path", "targetname" );
	self thread maps\_spawner::go_to_node( stumble_path, "struct" );
	
	// safer than changing the map at this point
	path = stumble_path;
	for ( ;; )
	{
		if ( !isdefined( path.target ) )
			break;
		path = getstruct( path.target, "targetname" );
	}
	path.radius = 86.7;


	wait_for_buffer_time_to_pass( start_time, time - 0.8 );
	self notify( "stop_animmode" );
	self anim_stopanimscripted();

	level notify( "stop_random_breathing_sounds" );

	flag_set( "stop_being_stunned" );
	
	self waittill( "reached_path_end" );
	/*
	self.goalradius = 600;
	self waittill( "goal" );	// need nodes first

	self.goalradius = 64;
	self waittill( "goal" );	// need nodes first
	*/
//	level.sandstorm_min_dist = 2500;
	
	animation = level.scr_anim[ "shepherd" ][ "turn_buckle_idle" ][ 0 ];
	
	self SetAnimKnobAll( animation, level.ai_root_anim, 1, 0.8, 1 );
	self animcustom( ::forever );

	ent = spawn_tag_origin();
	ent.origin = self.origin;
	ent.angles = self.angles;

	self LinkTo( ent );
	time = 1.1;
	ent MoveTo( level.shepherd.origin, time, 0, time );
	wait time;
	Objective_OnEntity( obj( "get_shepherd" ), level.shepherd );
	level.compass_ent = level.shepherd;

	level.shepherd show();
	ent Delete();
	self Delete();
}

forever()
{
	self endon( "death" );
	wait 0.75;
	self OrientMode( "face angle", level.shepherd.angles[1] );
	wait 5000;
}

scale_player_if_close_to_shepherd()
{
	self endon( "death" );

	dist_1 = 250;
	dist_2 = 700;
	speed_1 = 0.05;
	speed_2 = 0.6;
	limped = false;

	for ( ;; )
	{
		dist = Distance( level.player.origin, self.origin );

		if ( !limped && dist < 300 )
		{
			level.player StunPlayer( 1.5 );
			level.player PlayRumbleOnEntity( "damage_light" );
			level.player thread play_sound_on_entity( "breathing_hurt" );
			noself_delayCall( 0.5, ::setblur, 4, 0.25 );
			noself_delayCall( 1.2, ::setblur, 0, 1 );
			
			limped = true;
		}

		speed = graph_position( dist, dist_1, speed_1, dist_2, speed_2 );
		level.player.movespeedscale = clamp( speed, speed_1, speed_2 );

		wait 0.05;
	}
}

make_clouds_near_goal_struct( goal_struct )
{
	for ( ;; )
	{
		if ( Distance( self.origin, goal_struct.origin ) < 700 )
			break;
		wait( 0.05 );
	}

	self thread make_clouds();
}

make_clouds()
{
	count = 3.5;
	org = self.origin;
	
	min_timer = 0.05;
//	if ( level.console && level.ps3 )
//		min_timer = 0.3;
		
	SetHalfResParticles( true );

	for ( ;; )
	{
		if ( IsAlive( self ) )
			org = self.origin;

		PlayFX( level._effect[ "sand_storm_player" ], org + ( 0, 0, 100 ) );

		if ( IsAlive( self ) )
			count = count - 0.3;
		else
			count = count + 0.6;
		if ( count >= 6 )
			break;

		if ( count <= 1.75 )
			count = 1.75;

		timer =  count * 0.05;
		timer = clamp( timer, min_timer, 100 );
		//iprintlnbold( timer );
		wait( timer );
	}
	
	wait 3;
	SetHalfResParticles( false );
}

more_dust_as_shepherd_nears()
{
	for ( ;; )
	{
		wait( 0.05 );
		if ( !isalive( level.shepherd ) )
			continue;

		if ( Distance( level.player.origin, level.shepherd.origin ) > 650 )
			continue;

		maps\af_chase_fx::sandstorm_fx_increase();
		return;
	}
}

get_black_overlay()
{
	if ( !isdefined( level.black_overlay ) )
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	level.black_overlay.sort = -1;
	level.black_overlay.foreground = false;
	return level.black_overlay;
}

get_white_overlay()
{
	if ( !isdefined( level.white_overlay ) )
		level.white_overlay = create_client_overlay( "white", 0, level.player );

	level.white_overlay.sort = -1;
	return level.white_overlay;
}


player_touches_shepherd( dist_to_shepherd )
{
	if ( dist_to_shepherd >= 40 )
		return false;

	flag_set( "player_touched_shepherd" );

	return true;

}

player_melees_shepherd( dist_to_shepherd )
{
	if ( dist_to_shepherd >= 100 )
		return false;

	angles = level.player GetPlayerAngles();
	eyepos = level.shepherd GetTagOrigin( "tag_eye" );
	fov = 0.6428;// cos 50

	player_looking_at_shepherd = within_fov_2d( level.player.origin, angles, eyepos, fov );
	if ( !player_looking_at_shepherd )
		return false;

	dot = get_dot( level.shepherd.origin, level.shepherd.angles, level.player.origin );
	if ( dot < -0.173648 )
		return false;

	meleepressed = GetTime() - level.melee_button_pressed_last <= 50;

	return meleepressed;
//	return level.player MeleeButtonPressed();
}

knife_in_player( guy )
{
	level notify( "knife_in_player" );
	knife = maps\af_chase_knife_fight_code::get_knife();
	knife thread play_sound_on_entity( "scn_afchase_tbuckle_stab_front" );
	wait .1;
	level.heartbeat_blood_func = maps\af_chase_fx::blood_pulse;
	level.player_heartrate = 1.4;
	level.player DoDamage( 50 / level.player.damageMultiplier, level.player.origin );
}

get_knife()
{
	if ( !isdefined( level.knife ) )
		level.knife = spawn_anim_model( "knife" );

	return level.knife;
}

get_dof_targetEnt()
{

	if ( !IsDefined( level.dof_targetent ) )
		level.dof_targetent = create_dof_targetent();

	level.dof_targetent Unlink();
	return level.dof_targetent;
}


create_dof_targetent()
{

	level notify( "new_dof_targetent" );
	level endon( "new_dof_targetent" );
	level endon( "kill_dof_management" );
	ent = Spawn( "script_origin", level.player.origin );
	ent endon( "death" );
	level.dof_targetent = ent;
	childthread dof_target_manager( ent );
	return ent;
}

dof_target_manager( ent )
{
	// childthread acquires endons
	ent.near_range = 64;
	ent.far_range = 64;
	ent.near_blur = 4.5;
	ent.far_blur = 1.05;

	level.dof_normal = [];
	foreach ( index, value in level.dofdefault )
	{
		level.dof_normal [ index ] = value;
	}

	while ( 1 )
	{
		distance_to_target = Distance( level.player GetEye(), ent.origin );

		level.dofDefault[ "nearStart" ] = distance_to_target - ent.near_range;
		if ( level.dofDefault[ "nearStart" ] <= 0 )
			level.dofDefault[ "nearStart" ] = 1;
		level.dofDefault[ "nearEnd" ] = distance_to_target;
		level.dofDefault[ "farStart" ] = distance_to_target;
		level.dofDefault[ "farEnd" ] = distance_to_target + ent.far_range;
		level.dofDefault[ "nearBlur" ] = ent.near_blur;
		level.dofDefault[ "farBlur" ] = ent.far_blur;
//		Line( ent.origin, level.player.origin );
		wait .05;
	}
}

restore_dof()
{
	// no lerping. just meant ot turn it off at the end since we have harsh sky edges that it doesn't do well.
	level notify( "kill_dof_management" );
	foreach ( index, value in level.dof_normal )
		level.dofdefault [ index ] = value;
}

standby()
{
	if ( !isdefined( level.standby_node ) )
		level.standby_node = Spawn( "script_origin", ( 29142.2, 36233.9, -9973.2 ) );
	node = level.standby_node;
	node thread anim_generic_first_frame( self, "standby" );
}


set_default_hud_stuff()
{
//	MYFADEINTIME = 2.0;
//	MYFLASHTIME = 0.75;
//	MYALPHAHIGH = 0.95;
//	MYALPHALOW = 0.4;


	self.alignx = "center";
	self.aligny = "middle";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	//self.foreground = false;
	self.hidewhendead = true;
	self.hidewheninmenu = true;

	self.sort = 205;
	self.foreground = true;

	self.alpha = 0;
//	self FadeOverTime( MYFADEINTIME );
//	self.alpha = MYALPHAHIGH;

}

blend_to_knife_dof( time )
{
	level notify( "kill_dof_management" );
	level endon( "kill_dof_management" );
	start = level.dofDefault;

	dof_see_knife = [];
	dof_see_knife[ "nearStart" ] = 1;
	dof_see_knife[ "nearEnd" ] = 1;
	dof_see_knife[ "nearBlur" ] = 6;
	dof_see_knife[ "farStart" ] = 40;
	dof_see_knife[ "farEnd" ] = 70;
	dof_see_knife[ "farBlur" ] = 6;

	blend_dof( start, dof_see_knife, time );
}

blend_to_blurry_fake_wrestlers_dof( time )
{
	level notify( "kill_dof_management" );
	level endon( "kill_dof_management" );
	start = level.dofDefault;

	dof_see_knife = [];
	dof_see_knife[ "nearStart" ] = 1;
	dof_see_knife[ "nearEnd" ] = 1;
	dof_see_knife[ "nearBlur" ] = 10;
	dof_see_knife[ "farStart" ] = 40;
	dof_see_knife[ "farEnd" ] = 70;
	dof_see_knife[ "farBlur" ] = 10;

	blend_dof( start, dof_see_knife, time );
}


blend_to_shepherd_dof( time )
{
	level notify( "kill_dof_management" );
	level endon( "kill_dof_management" );
	start = level.dofDefault;

	dof_see_shepherd = [];
	dof_see_shepherd[ "nearStart" ] = 60;
	dof_see_shepherd[ "nearEnd" ] = 130;
	dof_see_shepherd[ "nearBlur" ] = 6;
	dof_see_shepherd[ "farStart" ] = 200;
	dof_see_shepherd[ "farEnd" ] = 300;
	dof_see_shepherd[ "farBlur" ] = 6;

	blend_dof( start, dof_see_shepherd, time );
}

blend_to_kill_dof( time )
{
	level notify( "kill_dof_management" );
	level endon( "kill_dof_management" );
	start = level.dofDefault;

	dof_see_shepherd = [];
	dof_see_shepherd[ "nearStart" ] = 60;
	dof_see_shepherd[ "nearEnd" ] = 130;
	dof_see_shepherd[ "nearBlur" ] = 4;
	dof_see_shepherd[ "farStart" ] = 1400;
	dof_see_shepherd[ "farEnd" ] = 1600;
	dof_see_shepherd[ "farBlur" ] = 4;

	blend_dof( start, dof_see_shepherd, time );
}

blend_to_ending_dof( time )
{
	level notify( "kill_dof_management" );
	level endon( "kill_dof_management" );
	start = level.dofDefault;

	dof_see_shepherd = [];
	dof_see_shepherd[ "nearStart" ] = 13;
	dof_see_shepherd[ "nearEnd" ] = 23;
	dof_see_shepherd[ "nearBlur" ] = 4;
	dof_see_shepherd[ "farStart" ] = 600;
	dof_see_shepherd[ "farEnd" ] = 3000;
	dof_see_shepherd[ "farBlur" ] = 4;

	blend_dof( start, dof_see_shepherd, time );
}

blend_to_price_healing_dof( time )
{
	level notify( "kill_dof_management" );
	level endon( "kill_dof_management" );
	start = level.dofDefault;

	dof_see_shepherd = [];
	dof_see_shepherd[ "nearStart" ] = 5;
	dof_see_shepherd[ "nearEnd" ] = 15;
	dof_see_shepherd[ "nearBlur" ] = 6;
	dof_see_shepherd[ "farStart" ] = 600;
	dof_see_shepherd[ "farEnd" ] = 3000;
	dof_see_shepherd[ "farBlur" ] = 6;

	blend_dof( start, dof_see_shepherd, time );
}



knife_hint_visible()
{
	if ( !isdefined( level.knife_hint ) )
		return false;

	foreach ( elem in level.knife_hint )
	{
		return elem.alpha > 0.8;
	}

	return false;
}

fade_in_knife_hint( time )
{
	if ( !isdefined( time ) )
		time = 1.5;

	if ( !isdefined( level.knife_hint ) )
		draw_knife_hint();

	foreach ( elem in level.knife_hint )
	{
		elem FadeOverTime( time );
		elem.alpha = 0.95;
	}
}

get_knife_reticle()
{
	if ( !isdefined( level.knife_reticle ) )
	{
		knife_reticle = createIcon( "reticle_center_throwingknife", 32, 32 );
		knife_reticle.x = 0;
		knife_reticle.y = 0;
		knife_reticle set_default_hud_stuff();
	
		level.knife_reticle = knife_reticle;
	}

	return level.knife_reticle;
}

draw_knife_hint()
{
	y_offset = 90;
	x_offset = 35;


	knife_text = level.player createClientFontString( "default", 2 );
	knife_text.x = x_offset * -1;
	knife_text.y = y_offset;
	knife_text.horzAlign = "right";
	knife_text.alignX = "right";
	knife_text set_default_hud_stuff();
	// ^3[{+usereload}]^7
	knife_text SetText( &"AF_CHASE_PRESS_USE" );
	//knife_text SetPulseFX( 100, 5000, 1000 );

	knife_icon = createIcon( "hud_icon_commando_knife", 64, 32 );
	knife_icon.x = x_offset;
	knife_icon.y = y_offset;
	knife_icon set_default_hud_stuff();


	elements = [];
	elements[ "text" ] = knife_text;
	elements[ "icon" ] = knife_icon;

	level.knife_hint = elements;
}

knife_hint_blinks()
{
	level notify( "fade_out_knife_hint" );
	level endon( "fade_out_knife_hint" );

	if ( !isdefined( level.knife_hint ) )
		draw_knife_hint();

	fade_time = 0.10;
	hold_time = 0.20;

	foreach ( elem in level.knife_hint )
	{
		elem FadeOverTime( 0.1 );
		elem.alpha = 0.95;
	}

	wait 0.1;

	hud_button = level.knife_hint[ "text" ];

	for ( ;; )
	{
		level.knife_hint[ "icon" ].alpha = 0.95;

		hud_button FadeOverTime( 0.01 );
		hud_button.alpha = 0.95;
		hud_button ChangeFontScaleOverTime( 0.01 );
		hud_button.fontScale = 2;

		wait 0.1;

		hud_button FadeOverTime( fade_time );
		hud_button.alpha = 0.0;
		hud_button ChangeFontScaleOverTime( fade_time );
		hud_button.fontScale = 0.25;

		wait hold_time;

		hide_hint_presses = 6;

		while ( IsDefined( level.occumulator ) )
		{
			if ( level.occumulator.presses.size < hide_hint_presses )
				break;

			foreach ( elem in level.knife_hint )
			{
				elem.alpha = 0;
			}
			wait 0.05;
		}
	}
}

fade_out_knife_hint( time )
{
	level notify( "fade_out_knife_hint" );
	if ( !isdefined( time ) )
		time = 1.5;

	if ( !isdefined( level.knife_hint ) )
		draw_knife_hint();

	foreach ( elem in level.knife_hint )
	{
		elem FadeOverTime( time );
		elem.alpha = 0;
	}
}

use_pressed()
{
	return level.player UseButtonPressed();
}


impaled_guy()
{
	array_spawn_function_targetname( "impaled_spawner", ::impaled_spawner );
	array_spawn_targetname( "impaled_spawner" );
}

impaled_spawner()
{
	level.impaled = self;

	self endon( "death" );
	self.clicks = 0;
	self.animname = "impaled";
	self set_deathanim( "death" );
	self.health = 5;
	self.diequietly = true;
	self.noragdoll = true;
	self.allowdeath = true;
	self.DropWeapon = false;


	//animscripts\shared::placeWeaponOn( self.sidearm, "right" );
	//self.bulletsinclip = 0;
	//self notify( "weapon_switch_done" );

	self gun_remove();


	glock = Spawn( "weapon_glock", ( 0, 0, 0 ), 1 );
	level.glock = glock;
	glock ItemWeaponSetAmmo( 0, 0 );

	// origin and angles for the gun on the ground
	glock.origin = ( 27195.4, 32486, -9922.01 );
	glock.angles = ( 14.9096, 214.163, -108.396 );

	thread impaled_died();
	struct = getstruct( "impaled_guy", "targetname" );

	struct thread anim_loop_solo( self, "idle" );
	glock LinkTo( self, "tag_sync", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	glock Unlink();
	wait_until_time_to_twitch();
	struct notify( "stop_loop" );
	self SetLookAtEntity( level.player );

	struct anim_single_solo( self, "react" );
	
	//scene = "react_loop";
	//animation = self getanim( scene )[ 0 ];
	//startorg = GetStartOrigin( struct.origin, struct.angles, animation );
	//startang = GetStartAngles( struct.origin, struct.angles, animation );
	//anim_string = "looping anim";
	//self AnimScripted( anim_string, startorg, startang, animation );
	//thread start_notetrack_wait( self, anim_string, scene, self.animname );
	//thread animscriptDoNoteTracksThread( self, anim_string );
	
	//guys = [];
	//guys[0] = self;
	//struct thread anim_custom_animmode_loop( guys, "gravity", "react_loop" );
	
	
	struct thread anim_loop_solo( self, "react_loop" );
	//wait 0.5;
	//scene = "react_loop";
	//animation = self getanim( scene )[ 0 ];
	//self SetFlaggedAnim( "looping anim", animation, 1, 0, 1 );
	//self animcustom( animscripts\nothing::main );
	
	add_damage_function( ::impaled_guy_deathsound );

	wait_until_time_to_die();
	wait 5;

//	wait( 5 );
//	self SetAnim( animation, 1, 0, 0 );
//	wait( 5000 );

//	wait_for_buffer_time_to_pass( start_time, time - 2.0 );
	self SetLookAtEntity();
//		wait_for_buffer_time_to_pass( start_time, time - 0.2 );
//	self StartRagdoll();

	self notify( "auto" );
//	self notify( "stop_aim" );
	self.a.nodeath = true;
	self.team = "neutral";

	animation = self getanim( "react_death" );
	time = GetAnimLength( animation );
	struct thread anim_single_solo( self, "react_death" );
	wait( time - 0.2 );

	self SetContents( 0 );
	self SetAnim( animation, 1, 0, 0 );


	// causes stumbling shepherd
	impaled_guy_died();
//	self Kill();
//	Print3d( self GetEye(), "AUTO_DEATH", (1,0,0), 1, 1, 500 );
}

impaled_guy_deathsound( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	if ( !isdefined( self ) )
		return;
	if ( !isalive( attacker ) )
		return;
	if ( attacker != level.player )
		return;
		
	self play_sound_in_space( "scn_afchase_dryfire_guy_death", self.origin );
}


wait_until_time_to_twitch()
{
	if ( flag( "impaled_guy_twitches" ) )
		return;
	level endon( "impaled_guy_twitches" );
	level endon( "run_shep_run" );
	for ( ;; )
	{
		if ( Distance( level.player.origin, self.origin ) < 480 )
			break;
		wait( 0.05 );
	}
}

wait_until_time_to_die()
{
	struct = spawnstruct();
	struct delaythread( 100, ::send_notify, "stop" );
	struct endon( "stop" );
	
	for ( ;; )
	{
		if ( Distance( level.player.origin, self.origin ) < 300 )
			break;
		wait( 0.05 );
	}

	struct delaythread( 5, ::send_notify, "stop" );
	for ( ;; )
	{
		if ( Distance( level.player.origin, self.origin ) < 140 )
			break;
		wait( 0.05 );
	}
}


impaled_died()
{
	self endon( "auto" );
	self waittill( "death" );
	if ( !isdefined( self ) )
		return;
		
	self SetLookAtEntity();

	// causes stumbling shepherd
	impaled_guy_died();
//	Print3d( self GetEye(), "KILLED", (1,0,0), 1, 1, 500 );
}

impaled_guy_died()
{
	wait( 1.5 );
	play_helicopter_exit_sound();
	wait( 2.0 );
	//flag_set( "impaled_died" );
}

stop_pressing_use()
{
	return 0;
}

wait_until_player_looks_at_knife()
{
	player_rig = get_player_rig();
	/*
	timeout = SpawnStruct();
	timeout endon( "timeout" );
	timeout delayThread( 7, ::send_notify, "timeout" );
	*/


	count = 0;
	cap = 40;
	for ( ;; )
	{

		base_angles = player_rig GetTagAngles( "tag_player" );
		angles = level.player GetPlayerAngles();
		angles = ( 0, angles[ 1 ] + 8.9, 0 );
		forward = AnglesToForward( angles );
		base_angles = ( 0, base_angles[ 1 ], 0 );

		base_forward = AnglesToForward( base_angles );
		base_right = AnglesToRight( base_angles );
		start = player_rig GetTagOrigin( "tag_player" );
	//	pos = start + forward * 100 + right * 32 + ( 0, 0, 32 );
		pos = start + base_forward * 100 + base_right * 8;

		vec = VectorToAngles( pos - start );
		vec_forward = AnglesToForward( vec );

	//dof_target_ent = get_dof_targetEnt();
	//dof_target_ent.origin = start + forward * 250 + right * -75;

	//	if ( level.player WorldPointInReticle_Circle( pos, 65, 100 ) )
		dot = VectorDot( forward, vec_forward );
		//level.d = dot;
		//end1 = start + forward * 50;
		//end2 = start + vec_forward * 50;
		//Line( start, end1, (1,0,0) );
		//Line( start, end2, (1,1,0) );
		//
		//Line( end1, end1 + (0,0,200), (1,0,0) );
		//Line( end2, end2 + (0,0,200), (1,1,0) );

		if ( dot > 0.991 )
		{
			count += 2;
		}
		else
		{
			if ( GetDvarInt( "x" ) )
				Print3d( pos + ( 0, 0, 32 ), "x", ( 1, 0, 0 ) );
			count -= 1;
		}

		if ( count >= cap )
			break;

		count = clamp( count, 0, cap );

		wait( 0.05 );
	}
}

flag_if_player_aims_at_shepherd( player_rig )
{
	//timeout = SpawnStruct();
	//timeout endon( "timeout" );
	//timeout delayThread( 7, ::send_notify, "timeout" );	
	level.shepherd endon( "death" );

	angles = player_rig GetTagAngles( "tag_player" );
	forward = AnglesToForward( angles );
	right = AnglesToRight( angles );
	start = player_rig GetTagOrigin( "tag_player" );
//	pos = start + forward * 100 + right * 32 + ( 0, 0, 32 );
	pos = start + forward * 100 + right * -40 + ( 0, 0, 32 );

	for ( ;; )
	{
		pos = level.shepherd GetTagOrigin( "tag_eye" );
		if ( level.player WorldPointInReticle_Circle( pos, 45, 120 ) )
		{
			flag_set( "player_aims_knife_at_shepherd" );
		}
		else
		{
			if ( GetDvarInt( "x" ) )
				Print3d( pos, "x", ( 1, 0, 0 ) );
			flag_clear( "player_aims_knife_at_shepherd" );
		}
		wait( 0.05 );
	}
}

hurt_player( num, anim_time )
{
	if ( !isdefined( anim_time ) )
		anim_time = 0.5;

	fx = getfx( "no_effect" );

	if ( IsDefined( self.hurt_player_fx ) )
		fx = getfx( self.hurt_player_fx );

	knife = maps\af_chase_knife_fight_code::get_knife();
	PlayFXOnTag( fx, knife, "TAG_FX" );

	level notify( "new_hurt" );
	level endon( "new_hurt" );
	if ( IsDefined( self.override_anim_time ) )
		anim_time = self.override_anim_time;



	//level.player SetNormalHealth( 1 );
	pos = level.player.origin + randomvector( 1000 );
//	level.player DoDamage( num / level.player.damagemultiplier, pos );

	blur = num * 2.9;
	time = num * 0.25;
	SetBlur( blur, 0 );
	SetBlur( 0, time );

	quake_time = num * 0.05;
	quake_time = clamp( quake_time, 0, 0.4 );
	quake = num * 0.02;
	quake = clamp( quake, 0, 0.25 );

	duration = clamp( num, 0, 0.85 );
//	Earthquake( quake, duration, level.player.origin, 5000 );

	min_time = 0.2;
	max_time = 1.5;
	time_range = abs( min_time - max_time );
	anim_range = 1 - anim_time;

	vision_blend_time = anim_range * time_range + min_time;
	halt_time = anim_time * 2;
	halt_time = clamp( halt_time, 0.5, 2.0 );
	recover_time = RandomFloatRange( 0.2, 0.6 );

	vision_set = "aftermath_hurt";
	if ( halt_time > 1.35 )
		vision_set = "aftermath_dying";
	set_vision_set( vision_set, vision_blend_time );

	if ( RandomInt( 100 ) > 70 )
	{
		// sometimes do quick recover
		wait( 0.15 );
		recover_time = RandomFloatRange( 0.16, 0.22 );
		set_vision_set( "aftermath_walking", recover_time );
	}
	wait halt_time;
	set_vision_set( "aftermath_walking", recover_time );
}

new_pull_earthquake( anim_time )
{
	if ( IsDefined( self.override_anim_time ) )
		anim_time = self.override_anim_time;

	eq = anim_time + 0.37;
	eq *= 0.22;
	Earthquake( eq, 5, level.player.origin, 5000 );
}

player_fails_if_does_not_throw()
{
	level endon( "player_throws_knife" );

	flag_wait_or_timeout( "player_aims_knife_at_shepherd", 8 );
	wait 3;
	fade_time = 6;
	overlay = get_black_overlay();
	overlay FadeOverTime( fade_time );
	overlay.alpha = 0;
	wait fade_time;
	missionFailedWrapper();
}

player_fails_if_does_not_occumulate()
{
	level.occumulator endon( "stop" );

	wait( 3 );// some time to learn

	overlay = get_black_overlay();

	fail_count = 0;

	deathcount = -80;

	for ( ;; )
	{
		pressed_enough = level.occumulator.presses.size >= 2;
		if ( pressed_enough )
			fail_count += 2;
		else
			fail_count -= 1;

		if ( fail_count <= deathcount )
			break;

		fail_count = clamp( fail_count, deathcount, 20 );

		alpha = fail_count;
		alpha /= deathcount;
//		alpha *= -1;
		alpha = clamp( alpha, 0, 1 );

		overlay FadeOverTime( 0.2 );
		overlay.alpha = alpha;
		wait( 0.05 );
	}

	overlay FadeOverTime( 0.2 );
	overlay.alpha = 1;
	wait( 0.2 );
	missionFailedWrapper();
}

player_pulls_out_knife( animation_name )
{
	player_rig = get_player_rig();
	knife = get_knife();

	guys = [];
	guys[ "knife" ] = knife;
	guys[ "player_rig" ] = player_rig;

	player_rig = get_player_rig();
	was_pressed = use_pressed();
	//was_pressed = 0;

	last_press = 0;
	rate = 0;

	occumulator = SpawnStruct();
	occumulator thread occumulate_player_use_presses( self );
	level.occumulator = occumulator;

	thread player_fails_if_does_not_occumulate();

	//max_press_time = 5000;

	next_pain = 0;

	max_time = 500;
	min_time = 0;
	time_range = abs( max_time - min_time );

	struct = SpawnStruct();

	damage_min = 2;
	damage_max = 5;

	//last_pain = 0;
	//last_held = 0;

	weaken_time = 0;

	animation = player_rig getanim( animation_name );

	old_percent = 0;
	anim_time = 0;
	playing_rumble = false;

	for ( ;; )
	{
		is_pressed = use_pressed();

		new_press = false;
		rate = 0;

		if ( is_pressed && !was_pressed )
		{
			if ( !playing_rumble )
			{
				playing_rumble = true;
				level.player PlayRumbleLoopOnEntity( self.rumble_loop );
			}
			
			if ( randomint( 100 ) > self.min_heavy )
			{
				level.player PlayRumbleOnEntity( "damage_heavy" );
			}
			else
			if ( randomint( 100 ) > self.min_light )
			{
				level.player PlayRumbleOnEntity( "damage_light" );
			}
			
			occumulator.presses[ occumulator.presses.size ] = GetTime();
			//fade_out_knife_hint( 0.1 );

			//elapsed_time = GetTime() - last_press;
			//scale = ( ( max_time - elapsed_time ) / time_range );
			//scale = clamp( scale, 0.15, 1 );
			//level.last_scale = scale; // for debugger

			last_press = GetTime();
			//rate = RandomFloatRange( min_rate_per_press, max_rate_per_press );

			rate = ( Sin( GetTime() * 0.2 ) + 1 ) * 0.5;
			rate *= self.range;
			rate += self.rate;

			new_press = true;

			if ( player_rig GetAnimTime( animation ) > 0.05 )
			{
				if ( self.takes_pain && GetTime() > next_pain )
				{
					next_pain = GetTime() + RandomIntRange( 450, 850 );
					amount = RandomFloatRange( damage_min, damage_max );
					amount = clamp( amount, 1, 50 );
					damage_min *= 1.15;
					damage_max *= 1.15;
					if ( IsDefined( self.override_damage ) )
						amount = self.override_damage;

					thread hurt_player( amount, anim_time );
					//if ( GetTime() > last_pain + 2500 )
					//	level.player thread play_sound_on_entity( "breathing_hurt" );
				}
			}
		}
		
		if ( playing_rumble && gettime() > last_press + 300 )
		{
			playing_rumble = false;
			level.player StopRumble( self.rumble_loop );
		}

		/*		
		if ( is_pressed )
		{
			fade_out_knife_hint( 0.5 );
			if ( !was_pressed )
			{
				last_press = GetTime();
			}
			last_held = GetTime();
			
			pressed_time = GetTime() - last_press;
			pressed_scale = pressed_time / max_press_time;
			pressed_scale = clamp( pressed_scale, 0.2, 1 );
			
			weaken_scale = 1; // lose pulling strength as you lapse into unconsciousness
			if ( self.faded_out )
			{
				weaken_time = GetTime() - weaken_time;
				weaken_scale = 1 - ( weaken_time / 5000 );
				weaken_scale = clamp( weaken_scale, 0, 1 );
			}
			
			new_press = true;
			rate = ( Sin( GetTime() * self.sin_scale ) + 1 ) * 0.06 + 0.05;
			rate *= pressed_scale * weaken_scale * self.pull_scale;
		}
			
		if ( new_press )
		{
			
			// sometimes it hurts to pull
			animation = player_rig getanim( animation_name );
			
			if ( player_rig GetAnimTime( animation ) > 0.25 )
			{
				if ( !self.faded_out )
				{
					self.faded_out = true;
					weaken_time = GetTime();
            
					fade_time = 15;
					struct endon( "stop" );
					struct delayThread( fade_time, ::send_notify, "stop" );
					fade_out( fade_time );
				}
			}
		}
		*/

		if ( GetTime() > last_press + 1000 && !knife_hint_visible() && !self.faded_out )
		{
//			thread knife_hint_blinks();
		}

		was_pressed = is_pressed;

		anim_finished = false;
		anim_time = undefined;
		foreach ( guy in guys )
		{
			animation = guy getanim( animation_name );
			guy SetAnim( animation, 1, 0, rate );
			anim_time = guy GetAnimTime( animation );
			if ( anim_time >= 0.95 )
				anim_finished = true;
		}

		if ( IsDefined( self.set_pull_weight ) )
		{
			level.additive_pull_weight = anim_time;
		}

		if ( IsDefined( self.auto_occumulator_base ) )
		{
			occumulator.occumulator_base = 1 - anim_time;
			occumulator.occumulator_base *= 7;
			occumulator.occumulator_base = clamp( occumulator.occumulator_base, 7, 1 );
		}

		percent_dif = abs( old_percent - anim_time );
		if ( percent_dif > 0.05 )
		{
			new_pull_earthquake( anim_time );
			old_percent = anim_time;
		}


		if ( anim_finished )
			break;

//		rate -= 0.05;
//		rate = clamp( rate, 0, 1 );
		wait( 0.05 );
	}

	level notify( "new_hurt" );
	occumulator notify( "stop" );
	level.occumulator = undefined;
	fade_in( 1 );// failure screen darkens

	if ( playing_rumble )
	{
		level.player StopRumble( self.rumble_loop );
	}


	foreach ( guy in guys )
	{
		animation = guy getanim( animation_name );
		guy SetAnim( animation, 1, 0, 0.06 );
	}
}


hands_do_pull_additive( player_rig )
{
	level endon( "knife_pulled_out" );
	//animation = player_rig getanim( animation_name );
	//weight = player_rig GetAnimTime( animation );
	was_pressed = use_pressed();

	root_anim = player_rig getanim( "pull_additive_root" );
	pull_anim = player_rig getanim( "pull_additive" );
	time = GetAnimLength( pull_anim );

	player_rig SetAnimRestart( pull_anim, 1, 0, 1 );

	for ( ;; )
	{
		is_pressed = use_pressed();
		if ( is_pressed && !was_pressed )
		{
			weight = level.additive_pull_weight;
			//weight = level.occumulator.presses.size / 6;
			weight *= 2.5;
			weight = clamp( weight, 0.0, 6.5 );

			player_rig SetAnim( root_anim, weight, 0.1, 1 );
			player_rig SetAnim( pull_anim, weight, 0, 1 );
			thread blend_out_pull_additive( root_anim, player_rig, time );
			//player_rig ClearAnim( root_anim, 0.2 );
		}

		was_pressed = is_pressed;

		wait 0.05;
	}
}

blend_out_pull_additive( root_anim, player_rig, time )
{
	level notify( "new_blend_out_pull_additive" );
	level endon( "new_blend_out_pull_additive" );
	wait( time );
	player_rig SetAnim( root_anim, 0, 0.2, 1 );
}

move_dof_target_away( player_rig )
{
	angles = player_rig GetTagAngles( "tag_player" );
	forward = AnglesToForward( angles );
	right = AnglesToRight( angles );
	start = player_rig GetTagOrigin( "tag_player" );
	pos = start + forward * 100 + right * 32 + ( 0, 0, 32 );

	dof_target_ent = get_dof_targetEnt();
	dof_target_ent.origin = start + forward * 250 + right * -75;
}

track_melee()
{
	level endon( "stop_track_melee" );
	level.melee_button_pressed_last = GetTime();
	while ( 1 )
	{
		if ( level.player IsMeleeing() )
		{
			level.melee_button_pressed_last = GetTime();
			while ( level.player IsMeleeing() )
				wait .05;
		}
		else
		{
			wait .05;
		}
	}
}


wait_for_player_to_melee_shepherd()
{
	time_until_first_comment = 13;
	min_time_for_followup_comment = 10;
	max_time_for_followup_comment = 14;
	
	// what are you waiting for mactavish
	inc = 0;
	//queue = array( "afchase_shp_waitingfor", "afchase_shp_digtwograves", "afchase_shp_goahead", "afchase_shp_couldntdoit", "afchase_shp_extrastep" );
	queue = [];
	
	// You know what they say about revenge�you better be ready to dig two graves�	
	queue[ queue.size ] = "afchase_shp_digtwograves";
	// Go ahead and end it. It won't change anything.		
	queue[ queue.size ] = "afchase_shp_goahead";
	// Hmph. I knew you couldn't do it�		
	queue[ queue.size ] = "afchase_shp_couldntdoit";
	// You're a good warrior�		
	queue[ queue.size ] = "afchase_shp_goodwarrior";
	// �but you could never take that extra step�		
	queue[ queue.size ] = "afchase_shp_extrastep";
	// �to do what was absolutely necessary.		
	queue[ queue.size ] = "afchase_shp_necessary";

	
	timer = GetTime() + 11000;

	cough_timer = GetTime() + 4000;

	thread track_melee();

	last_weapon = "ending_knife";

	while ( 1 )
	{
		dist_to_shepherd = Distance( level.player.origin, level.shepherd.origin );

		if ( dist_to_shepherd < 120 && last_weapon != "ending_knife_silent" )
		{
			last_weapon = "ending_knife_silent";
//			level.player GiveWeapon( "ending_knife_silent" );
//			level.player SwitchToWeaponImmediate( "ending_knife_silent" );
		}
		else 
		if ( dist_to_shepherd > 120 && last_weapon != "ending_knife" )
		{
			last_weapon = "ending_knife";
//			level.player GiveWeapon( "ending_knife" );
//			level.player SwitchToWeaponImmediate( "ending_knife" );
		}

		if ( dist_to_shepherd < 500 )
		{
			flag_set( "shepherd_should_do_idle_b" );
		}
		else
		{
			flag_clear( "shepherd_should_do_idle_b" );
		}

		if ( player_touches_shepherd( dist_to_shepherd ) )
		{
			break;
		}

		if ( player_melees_shepherd( dist_to_shepherd ) )
		{
			break;
		}
		else 
		if ( dist_to_shepherd < 300 && GetTime() > timer )
		{
			if ( !flag( "player_near_shepherd" ) )
			{
				flag_set( "player_near_shepherd" );
				timer = GetTime() + time_until_first_comment * 1000;
			}
			else 
			if ( dist_to_shepherd < 500 )
			{
				if ( inc < queue.size )
				{
					level.shepherd thread dialogue_queue( queue[ inc ] );
				}
				timer = GetTime() + RandomIntRange( min_time_for_followup_comment * 1000, max_time_for_followup_comment * 1000 );
				inc++;
			}
		}
		else 
		if ( should_cough( dist_to_shepherd, cough_timer ) )
		{
			level.shepherd thread play_sound_on_entity( "shepherd_cough" );
			cough_timer = GetTime() + RandomIntRange( 4000, 7000 );
		}

		wait( 0.05 );
	}
	level notify( "stop_track_melee" );
	level.player StopSounds();
}

should_cough( dist_to_shepherd, cough_timer )
{
	if ( dist_to_shepherd < 400 )
		return false;
	if ( dist_to_shepherd > 700 )
		return false;
	if ( GetTime() < cough_timer )
		return false;
	if ( IsAlive( level.shepherd_stumble ) )
		return false;
	return true;
}

hint_crawl_right()
{
	return level.player buttonpressed( "mouse2" );
}

hint_crawl_left()
{
	return level.player buttonpressed( "mouse1" );
}

teleport_to_truck_area()
{
	struct = getstruct( "turnbuckle_start", "targetname" );
	level.player teleport_ent( struct );
}


get_stick_deflection()
{
	movement = level.player GetNormalizedMovement();
	move_x = abs( movement[ 0 ] );
	move_y = abs( movement[ 1 ] );

	if ( move_x > move_y )
		return move_x;
	return move_y;
}

dof_to_gun_kick_gun( dof_target_ent )
{
	gun_model = get_gun_model();
	dof_target_ent = get_dof_targetEnt();

	level notify( "dof_target_to_gun_crawl" );

	dof_target_ent.near_range = 300;
	dof_target_ent.far_range = 128;
	dof_target_ent.near_blur = 4.5;
	dof_target_ent.far_blur = 2.5;

	dof_target_ent movetotag( gun_model, "J_Cylinder_Rot", 1 );
//	dof_target_ent MoveTo( gun_model.origin, 1, .4, .4 );
}


gun_crawl_move_fighters_away()
{
	level.gun_crawl_fight_node MoveTo( level.gun_crawl_fight_node.origin + ( 100, 0, 0 ), 4.7, 0, 0 );
}

gun_crawl_price_falls()
{
	level endon( "stop_idle_crawl_fight" );// kill this if its running
	flag_set( "fade_away_idle_crawl_fight" );
	movetime = 1;
	level.gun_crawl_fight_node MoveTo( level.gun_crawl_fight_node.origin + ( 120, 0, 0 ), movetime, 0, 0 );
	wait movetime;
	level.shepherd Unlink();

	level.price Unlink();
//	level notify ( "stop_idle_crawl_fight" );
	anim_node = get_anim_node();

	new_anim_node = create_new_anim_node_from_anim_node();
	new_anim_node.angles = ( 2.74693, 145.684, -4.76702 );
	new_anim_node.origin = ( 29558.6, 32344.3, -9891.88 );

	new_anim_node_base_origin = new_anim_node.origin;
//	offset = new_anim_node.origin + ( 164, 0, 0 );
	offset = new_anim_node_base_origin + ( 64, 0, 0 );

	scene = "gun_kick_price";
	animation = level.price getanim( scene );
	anim_length = GetAnimLength( animation );
	thread fight_physics( scene, anim_length );

	new_anim_node.origin = offset;

	level.price thread play_sound_on_entity( "scn_afchase_collapse_foley_stereo" );
	new_anim_node thread anim_single_solo( level.price, scene );
	level.price LinkTo( new_anim_node );
	wait .05;
	new_anim_node MoveTo( new_anim_node_base_origin, .5, 0, 0 );

	level notify( "stop_idle_crawl_fight_just_the_fight" );
	anim_node anim_first_frame_solo( level.shepherd , "turn_buckle" ); // stop him from playing out the fight animation with punch sounds.

	wait 10;
	new_anim_node Delete();

//	time_to_slow_down = anim_length - .3;
//	wait time_to_slow_down;
	wait anim_length;

	level notify( "stop_idle_crawl_fight" );
//	new_anim_node anim_set_rate_single( level.price, scene, .002 );
}

gun_crawl_fight_idle()
{
	level endon( "stop_idle_crawl_fight" );
	level endon( "stop_idle_crawl_fight_just_the_fight" );
	anim_node = get_anim_node();

	new_anim_node = create_new_anim_node_from_anim_node();
	new_anim_node thread gun_crawl_fight_idle_cleanup();

	level.gun_crawl_fight_node = new_anim_node;

	// manually pasting origins and angles because mapents = no shadows and that's what I'm trying to achieve here.. shadow play. SIGH

	destorg = ( 28330.6, 36267.5, -9960 );
//	destorg += ( -20, 0, 0 );
	out_of_sight_offset = destorg + ( 40, 0, 0 );
	new_anim_node.origin = out_of_sight_offset;// start off scene and blend in
	new_anim_node.angles = ( 0, 273.025, 0 );


	guys = [];
	guys[ "shepherd" ] = level.shepherd;
	guys[ "price" ] = level.price;


	b_start = 0.06;
	b_end = 0.56;
	animation = level.shepherd getanim( "fight_B" );
	anim_length = GetAnimLength( animation );
	b_totaltime = ( b_end - b_start ) * anim_length;


	new_anim_node thread anim_single( guys, "fight_B" );
	wait( 0.05 );
	foreach ( guy in guys )
	{
		guy DontInterpolate();
		guy LinkTo( new_anim_node );
		guy Show();
	}
	
	level.price playsound( "scn_afchase_b_longoff_price_foley" );
	level.shepherd playsound( "scn_afchase_b_longoff_shep_foley" );

	level.price delaycall( 0.5, ::playsound, "scn_afchase_b_longoff_block1" );
	level.shepherd delaycall( 2, ::playsound, "scn_afchase_b_longoff_lifthead2" );
	level.shepherd delaycall( 3.25, ::playsound, "scn_afchase_b_longoff_headbutt3" );
	
	while ( 1 )
	{
		new_anim_node MoveTo( destorg, 2, 0, 0 );
		new_anim_node anim_set_time( guys, "fight_B", b_start );
//		level.shepherd thread play_sound_on_entity( "scn_afchase_b_long_shep_foley" );
//		level.price thread play_sound_on_entity( "scn_afchase_b_long_price_foley" );
		move_out_time = 1;
		wait( b_totaltime - move_out_time );

		if ( !flag( "fade_away_idle_crawl_fight" ) )
			new_anim_node MoveTo( out_of_sight_offset, move_out_time, 0, 0 );

		wait( move_out_time );
//		new_anim_node anim_single( guys, "fight_D2" );
//		new_anim_node anim_single( guys, "fight_D3" );
	}


}



gun_crawl_fight_idle_cleanup()
{
	level waittill( "stop_idle_crawl_fight" );
	self Delete();
}


dof_target_to_gun_crawl()
{
	level endon( "dof_target_to_gun_crawl" );
	player_rig = get_player_rig();
	dof_target_ent = get_dof_targetEnt();
	dof_target_ent movetotag( player_rig, "J_Wrist_LE", 1.5 );
}

button_wait( button_alt, button_track, button_index )
{

	time = GetTime();
	button_hint_time =  							time + 300;
	button_player_hurt_pulse = 						time + 2150;
	button_failure_time = 							time + 4000;

	button_hinted = false;
	hurt_pulsed = false;

	if ( button_index == 0 )
	{
		button_hint_time =  							time + 1400;
		button_player_hurt_pulse = 						time + 4150;
		button_failure_time = 							time + 7000;
	}

	if ( button_index > 2 )
	{
		button_hint_time =  							time + 1400;
		button_player_hurt_pulse = 						time + 2150;
		button_failure_time = 							time + 4000;
	}

	while ( 1 )
	{
		button_pressed = level.player [[ button_alt[ button_index ] ]]();
		needs_to_release = button_needs_to_release( button_track, button_index );

		if ( button_hint_time < GetTime() && ! button_hinted )
		{
			button_hinted = true;
			display_hint( button_track.button_hints[ button_index ] );
		}

		if ( button_player_hurt_pulse < GetTime() && ! hurt_pulsed )
		{

			hurt_pulsed = true;
			thread crawl_hurt_pulse();
		}

		if ( button_failure_time < GetTime() )
		{
			// Price was killed.
			SetDvar( "ui_deadquote", &"AF_CHASE_FAILED_TO_CRAWL" );
			missionFailedWrapper();
			level waittill( "never" );
		}
		if ( button_pressed && ! needs_to_release )
		{
			level notify( "clear_hurt_pulses" );
			return;
		}
		wait .05;
	}
}

crawl_hurt_pulse()
{
	fade_out( 2 );
	SetBlur( 4, 4 );
	set_vision_set( "aftermath_hurt", 4 );
	thread crawl_breath_start();
	level waittill( "clear_hurt_pulses" );
	set_vision_set( "af_chase_ending_noshock", .5 );
	thread crawl_breath_recover();
	SetBlur( 0, .5 );
	fade_in( .23 );
}

crawl_breath_start()
{
	level endon( "crawl_breath_recover" );
	level.player play_sound_on_entity( "breathing_hurt_start" );
	while ( 1 )
	{
		wait RandomFloatRange( .76, 1.7 );
		level.player play_sound_on_entity( "breathing_hurt" );

	}


}

crawl_breath_recover()
{
	level notify( "crawl_breath_recover" );
	level.player thread play_sound_on_entity( "breathing_better" );

}

crawl_hurt_pulse_clear()
{

}


button_needs_to_release( button_track, index )
{
	timediff = GetTime() - button_track.button_last_release[ index ];
	return timediff > 750;
}

track_buttons( button_track, button_alt, button_hints )
{
	buttons = [];
	for ( i = 0; i < button_alt.size; i++ )
		buttons[ i ] = GetTime();
	button_track.button_last_release = buttons;
	button_track.button_hints = button_hints;

	while ( 1 )
	{
		foreach ( index, button_func in button_alt )
		{
			if ( ! level.player [[ button_func ]]() )
				button_track.button_last_release[ index ] = GetTime();
		}
		wait .05;
	}
}


//modulate_player_movement()
//{
//	level.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );
//	level.ground_ref_ent.origin = level.player.origin;
//	level.player PlayerSetGroundReferenceEnt( level.ground_ref_ent );
//
//	//ent = Spawn( "script_origin", (0,0,0) );
//	//yaw = level.player GetPlayerAngles()[1];
////	ent.angles = ( 0, yaw, 0 );
//	//level.player PlayerSetGroundReferenceEnt( ent );
////	ent thread stick_to_player_angles();
//	last_blur = 0;
//	next_noblur = 0;
//
//
//	//level.player SetMoveSpeedScale( level.player_speed );
//	ramp_in_modifier = 0.25;
//
//	blurs_remaining = 4;
//	for ( ;; )
//	{
//		// the more you push the stick the faster you go.
//		stick_deflection = get_stick_deflection();
//		ramp_in_change_per_frame = stick_deflection * 0.01;
//		ramp_in_modifier += ramp_in_change_per_frame;
//
//		if ( IsAlive( level.shepherd_stumble ) )
//		{
//			if ( Distance( level.shepherd_stumble.origin, level.player.origin ) < 420 )
//			{
//				// get near shepherd? get slower
//				ramp_in_modifier -= 0.025;
//			}
//		}
//
//		ramp_in_modifier = clamp( ramp_in_modifier, 0.25, 1 );
//
//		bonus = ( Sin( GetTime() * 0.1 ) + 1 ) * 0.05 + 0.2;
//		speed = abs( ( Sin( GetTime() * 0.23 ) ) ) * 0.5 + 0.10;
//		speed += bonus;
//
//		level.player SetMoveSpeedScale( speed * ramp_in_modifier );
//
//		blur = 0;
//		player_speed = Distance( ( 0, 0, 0 ), level.player GetVelocity() );
//		if ( player_speed > 35 )
//		{
//			blur = 1 - speed;
//			blur *= 16;
//			blur -= 3;
//		}
//
//		if ( blur <= 0 )
//			blur = 0;
//
//		if ( blur > 0 && GetTime() > next_noblur )
//		{
//			if ( blurs_remaining > 0 )
//			{
//				blurs_remaining -= 1;
//				SetBlur( blur, 0.1 );
//			}
//		}
//		else
//		{
//			SetBlur( 0, 0.1 );
//		}
//
//		level.blur = blur;
//		level.speed = speed;
//
//		if ( last_blur != 0 && blur == 0 )
//		{
//			next_noblur_period = RandomFloatRange( 2000, 4000 );
//			if ( GetTime() > next_noblur + 6000 )
//				next_noblur = GetTime() + next_noblur_period;
//		}
//
//		last_blur = blur;
//		//pitch = speed * -5;
//		//ent RotateTo( ( pitch, 0, 0 ), 0.1 );
//		wait( 0.05 );
//	}
//}

player_links_to_rig_and_looks_left( player_rig, tag, left_degree )
{
	tag_origin = spawn_tag_origin();
	// 30
	tag_origin LinkTo( player_rig, tag, ( 0, 0, 0 ), ( 0, left_degree, 0 ) );

	level.player PlayerLinkToDelta( tag_origin, "tag_origin", 1, 0, 0, 0, 0, true );
//	wait( 0.5 );
//	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 30, 30, 10, 10, true );
//	tag_origin Delete();
}

movetotag( ent, tag, time )
{
	thread movetotag_internal( ent, tag, time );
}

movetotag_internal( ent, tag, time )
{
	self notify( "new_move_to_tag" );
	self endon( "new_move_to_tag" );
	timer = GetTime() + ( time * 1000 );
	tag_origin = ent GetTagOrigin( tag );
	self Unlink();
	self MoveTo( tag_origin, time );
	while ( GetTime() < timer )
	{
		updated_tag_origin = ent GetTagOrigin( tag );
		if ( updated_tag_origin != tag_origin )
		{
			tag_origin = updated_tag_origin;
			time = ( timer - GetTime() ) / 1000;
			self MoveTo( tag_origin, time );
		}
		wait .05;
	}
	self LinkToBlendToTag( ent, tag );

}

create_new_anim_node_from_anim_node()
{
	anim_node = get_anim_node();
	new_anim_node = Spawn( "script_origin", anim_node.origin );
	new_anim_node.angles = anim_node.angles;
	return new_anim_node;
}

dof_shifts_to_knife()
{
	flag_wait_or_timeout( "player_looks_at_knife", 3.5 );
	focus_time = 1.2;
	if ( !flag( "player_looks_at_knife" ) )
	{
		focus_time = 3.0;// takes longer if you didn't look at the knife
	}

	knife = get_knife();
	pos = knife GetTagOrigin( "tag_knife" );
	//dof_target_ent = get_dof_targetEnt();
	//dof_target_ent MoveTo( pos, focus_time, 0, focus_time * 0.5 );
	childthread blend_to_knife_dof( focus_time );
	wait( focus_time );
	flag_set( "focused_on_knife" );
	wait( 6 );
	flag_set( "player_looks_at_knife" );
}

player_fails_if_he_doesnt_use_knife()
{
	if ( flag( "player_uses_knife" ) )
		return;
	level endon( "player_uses_knife" );

	scene = "fight_C";
	animation = level.shepherd getanim( scene );
	for ( ;; )
	{
		if ( level.shepherd GetAnimTime( animation ) >= 0.57 )
			break;
		wait( 0.05 );
	}

	// Price was killed.
	SetDvar( "ui_deadquote", &"AF_CHASE_FAILED_TO_PULL_KNIFE" );
	missionFailedWrapper();
}

hide_end_of_fight_C()
{
	level endon( "fight_C_is_over" );
	scene = "fight_C";
	animation = level.shepherd getanim( scene );
	for ( ;; )
	{
		if ( level.shepherd GetAnimTime( animation ) >= 0.60 )
			break;
		wait( 0.05 );
	}
	level.shepherd Hide();
	level.price Hide();
}

player_tries_to_throw()
{
	if ( flag( "missionfailed" ) )
		return;
	level endon( "missionfailed" );
	
	
	level endon( "player_throws_knife" );
	anim_node = get_anim_node();
	player_rig = get_player_rig();
	knife = get_knife();

	guys = [];
	guys[ "player_rig" ] = player_rig;
	guys[ "knife" ] = knife;

	last_press = 0;

	for ( ;; )
	{
		level.player waittill( "throw" );
		if ( flag( "player_aims_knife_at_shepherd" ) )
		{
			flag_set( "player_throws_knife" );
		}
		else
		{
			if ( GetTime() > last_press + 500 )
			{
				anim_node thread anim_single( guys, "prethrow" );
				last_press = GetTime();
			}
		}
	}
}

player_throws_knife( reticle )
{
	level endon( "player_throws_knife" );
	level.player NotifyOnPlayerCommand( "throw", "+attack" );
	level.player NotifyOnPlayerCommand( "throw", "+melee" );

	thread player_tries_to_throw();
	movetime = 1;
	knife = get_knife();
	//dof_target_ent = get_dof_targetEnt();
	for ( ;; )
	{
		flag_waitopen( "player_aims_knife_at_shepherd" );
		reticle.color = (1,1,1);
		//dof_target_ent MoveTo( knife.origin, movetime, movetime * 0.25, movetime * 0.25 );
		thread blend_to_knife_dof( 1 );

		flag_wait( "player_aims_knife_at_shepherd" );
		reticle.color = (1,0,0);
		eyepos = level.shepherd GetTagOrigin( "tag_eye" );
		//dof_target_ent MoveTo( eyepos, movetime, movetime * 0.25, movetime * 0.25 );
		thread blend_to_shepherd_dof( 1 );
	}
}


fade_turn_buckle( fade_out_time )
{
	flag_wait( "turn_buckle_fadeout" );

	SetBlur( 3.5, fade_out_time * 0.75 );
	fade_out( fade_out_time );
	wait( fade_out_time );

}

scene_gun_monologue_dialogue( start_time_offset )
{
	level.override_eq = true;

	level.eq_ent MoveTo( ( 0.8, 0, 0 ), 4 );
	wait 3.5;
	start_time = GetTime() - start_time_offset * 1000;
	

	wait_for_buffer_time_to_pass( start_time, 5.7 );
	
	level.shepherd delaythread( 0.2, ::play_sound_on_entity, "afchase_shp_fiveyearsago_a" );
	level.shepherd delaythread( 7.5, ::play_sound_on_entity, "afchase_shp_fiveyearsago_b" );
	
	// Five years ago, I lost 30,000 men in the blink of an eye��and the world just fuckin' watched.	
	level.shepherd play_sound_on_tag( "afchase_shp_fiveyearsago", "J_Jaw" );
	extra_wait = 2.1;
	wait extra_wait;
	flag_set( "gloat_fade_in" );

	level.eq_ent MoveTo( ( 0.6, 0, 0 ), 2 );

	wait_for_buffer_time_to_pass( start_time, 16.8 + extra_wait );
	// Tomorrow...there will be no shortage of volunteers...no shortage of patriots.			
	level.shepherd thread play_sound_on_tag( "afchase_shp_noshortage", "J_Jaw" );

	wait_for_buffer_time_to_pass( start_time, 26.5 + extra_wait );
	// I know you understand�		
	level.shepherd thread play_sound_on_tag( "afchase_shp_iknow", "J_Jaw" );
	wait 0.5;
	level.eq_ent MoveTo( ( 0.0, 0, 0 ), 4 );
	level.override_eq = false;
}


scene_walk_off_dialog()
{
	//noself_delayCall( 22, ::MusicPlay, "af_chase_final_ending" );
//	level.price dialogue_queue( "afchase_pri_holdfornow" );
	wait( 15.1 );


	// "Price: I thought I told you this was a one-way trip!"
//	level.price thread dialogue_queue( "afchase_pri_toldyou" );

	wait( 3 );

 	// "Nikolai: Looks like it still is...they'll be looking for us you know..."
//	level.nikolai thread dialogue_queue( "afchase_nkl_lookingforus" );

	wait( 4 );

	// Nikolai, we gotta get Soap outta here..."
//	level.price thread dialogue_queue( "afchase_pri_soapouttahere" );

	wait( 2.8 );
	// "Nikolai: Da - I know a place."
//	level.nikolai thread dialogue_queue( "afchase_nkl_knowaplace" );

	level notify( "stop_blinding" );
//	wait( 3.75 );//2.6

/*	level waittill( "end_fade_out" );
	black_overlay = get_black_overlay();
	black_overlay.alpha = 0;
	black_overlay FadeOverTime( 0.05 );
	black_overlay.alpha = 1;
*/
}

remove_fences()
{
	fence_remove_at_heli_landing = GetEntArray( "fence_remove_at_heli_landing", "targetname" );
	array_call( fence_remove_at_heli_landing, ::Delete );
}

end_blind( ending_rescue_chopper )
{
	effect = getfx( "heli_blinds_player" );
	level endon( "stop_blinding" );
	end_org = ( ending_rescue_chopper.origin + level.player.origin ) / 2;
	end_org = set_z( end_org, level.player.origin[ 2 ] );
	while ( 1 )
	{
//		PlayFX( effect, level.player GetEye() );
		random_offset = randomvectorrange( -255, 255 );
		random_offset = flat_origin( random_offset );
		PlayFX( effect, end_org + random_offset );
		wait .4;
	}
}

dof_to_gun( guy )
{
	dof_target = get_dof_targetEnt();
	gun_model = get_gun_model();
	dof_target movetotag( gun_model, "TAG_FLASH", .7 );
}

fire_gun()
{
	gun_model = get_gun_model();
	fx = getfx( "shepherd_anaconda" );
	tag = "TAG_FLASH";
	PlayFXOnTag( fx, gun_model, tag );
	org = gun_model GetTagOrigin( tag );
	thread play_sound_in_space( "weap_anaconda_fire_plr", org );
}

player_fov_goes_to_min_arc( player_rig, tag )
{
	level.player PlayerLinkToDelta( player_rig, tag, 1, 30, 30, 30, 20, true );
}

fade_out_gun_kick( guy )
{
	//fade_out_time = .1;
	//SetBlur( 3.5, fade_out_time * 0.75 );
	//fade_out( fade_out_time );
	//wait( fade_out_time );
	
	black_overlay = get_black_overlay();	
	black_overlay.alpha = 1;
	thread eq_changes( 0.5, 0.1 );
	
}

cast_structs_to_origins()
{
	structs = [];
	structs[ "b" ] = getstruct( "end_scene_org_fight_B", "targetname" );
	structs[ "c" ] = getstruct( "end_scene_org_fight_C", "targetname" );

	root = get_anim_node();
	root2 = get_anim_node_rotated();

	ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	ent.origin = root.origin;
	ent.angles = root.angles;

	ents = [];
	foreach ( struct in structs )
	{
		newent = Spawn( "script_origin", ( 0, 0, 0 ) );
		newent.origin = struct.origin;
		newent.angles = struct.angles;
		newent.targetname = struct.targetname;
		//newent LinkTo( ent );
	}

	ent.origin = root2.origin;
	ent.angles = root2.angles;
}



sandstorm_fades_away()
{
	restore_time = 17;
	level notify( "stop_sandstorm_fog" );
	thread fog_set_changes( "afch_fog_waterfall", restore_time );
	thread maps\af_chase_fx::sunlight_restore( restore_time );
	//level delayThread( restore_time, maps\af_chase_fx::stop_sandstorm_effect );
	level.fogent Delete();
}

random_breathing_sounds()
{
	level endon( "stop_random_breathing_sounds" );
	sounds = [];
	sounds[ sounds.size ] = "breathing_hurt_alt";
	sounds[ sounds.size ] = "breathing_hurt_start_alt";
	sounds[ sounds.size ] = "breathing_better_alt";

	for ( ;; )
	{
		sound = random( sounds );
		eyepos = level.player GetEye();
		play_sound_in_space( sound, eyepos );

		timer = RandomFloatRange( 1, 3 );
		wait( timer );
	}
}
/*
reoccurring_shellshock_until_melee()
{
	if ( flag( "stop_aftermath_player" ) )
		return;
		
	level endon( "stop_aftermath_player" );

	childthread recover_from_jump();

	for ( ;; )
	{
		SetBlur( 20, 0 );
		SetBlur( 0, 2 );

		if ( flag( "player_standing" ) )
			level.player ShellShock( "af_chase_ending_wakeup", 60 );
		else
			level.player ShellShock( "af_chase_ending_wakeup_nomove", 60 );


		wait( 60 );
	}
}

recover_from_jump()
{
	for ( ;; )
	{
		level waittill( "slowview", time );
		wait( time );
		level.player ShellShock( "af_chase_ending_wakeup", 60 );
	}
}
*/

price_shepherd_fight_e( fighters )
{
	if ( level.start_point != "kill" )
	{
		scene = "fight_E";
		animation = level.price getanim( scene );
		scene_time = GetAnimLength( animation );
		thread fight_physics( scene, scene_time );

		self anim_single( fighters, scene );
	}
	self thread anim_loop( fighters, "fight_E_loop" );
}

blend_fov()
{
	self endon( "death" );
	for ( ;; )
	{
		SetSavedDvar( "cg_fov", self.origin[ 0 ] );
		wait( 0.05 );
	}
}

force_player_to_look_at_knife( lerp_time )
{
//	player_offset_tag = spawn_tag_origin();
//	player_rig = get_player_rig();
//	player_offset_tag LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, -15, 0 ) );
//	level.player PlayerLinkToBlend( player_offset_tag, "tag_origin", lerp_time, lerp_time * 0.5, lerp_time * 0.5 );

	level.player LerpViewAngleClamp( lerp_time, lerp_time * 0.75, lerp_time * 0.25, 4, 4, 5, 10 );
}

wounded_show_player_view( player_rig )
{
	level waittill( "link_player" );
	waittillframeend;// let anims get put in place first

	player_offset_tag = spawn_tag_origin();
	player_offset_tag LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, 25, 0 ) );

	thread player_links_to_rig_and_looks_left( player_offset_tag, "tag_origin", 0 );
	wait( 1 );
	lerp_time = 0.5;
//	level.player LerpViewAngleClamp( lerp_time, lerp_time * 0.5, lerp_time * 0.5, 0, 14, 10, 15 );
	// gotta link after using look_left
	level.player PlayerLinkToDelta( player_offset_tag, "tag_origin", 1, 5, 15, 15, 0, true );

}

pullout_player_view( player_rig )
{
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	First scene of KILL
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	waittillframeend;// let anims get put in place first
	player_offset_tag = spawn_tag_origin();
	player_offset_tag LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, 10, 0 ) );

	// positive is left, negative is right
	thread player_links_to_rig_and_looks_left( player_offset_tag, "tag_origin", -20 );
	wait( 0.25 );
	level.player PlayerLinkToDelta( player_offset_tag, "tag_origin", 1, 5, 15, 5, 10, true );
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	level waittill( "waiting_for_player_to_look_at_knife" );

	left_limit = 28 + 10;
	player_offset_tag LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, -15, 0 ) );// 5// - 15
	// positive is left, negative is right

	thread player_links_to_rig_and_looks_left( player_offset_tag, "tag_origin", 13 + 20 );
	wait( 0.5 );
	level.player PlayerLinkToDelta( player_offset_tag, "tag_origin", 1, 5, left_limit, 10, 10, true );

	level.player LerpViewAngleClamp( 0, 0, 0, 30, left_limit, 15, 10 );
	thread force_player_to_look_at_knife_if_he_doesnt();

	level waittill( "lerp_view_after_uses_knife" );

	lerp_time = 2.5;
	level.player PlayerLinkToBlend( player_offset_tag, "tag_origin", lerp_time, lerp_time * 0.5, lerp_time * 0.5, 0, 0, 0, 0 );

	wait 4;
	lerp_time = 3.0;

	player_offset_tag = spawn_tag_origin();
	player_offset_tag LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, -5, 0 ) );
	level.player PlayerLinkToBlend( player_offset_tag, "tag_origin", lerp_time, lerp_time * 0.5, lerp_time * 0.5, 0, 0, 0, 0 );

	level waittill( "second_knife_pull" );

	wait 0.5;
	player_offset_tag = spawn_tag_origin();
	player_offset_tag LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, -10, 0 ) );// - 15
	time = 0.5;
	level.player PlayerLinkToBlend( player_offset_tag, "tag_origin", time, time * 0.3, time * 0.5 );
}

force_player_to_look_at_knife_if_he_doesnt()
{
	if ( flag( "player_looks_at_knife" ) )
		return;
	level endon( "player_looks_at_knife" );
	wait 6;
	force_player_to_look_at_knife( 8 );
}

kill_player_view( player_rig )
{
	time = 1.5;
	if ( level.start_point == "kill" )
		time = 0;

	level.player PlayerLinkToBlend( player_rig, "tag_player", time, time * 0.3, time * 0.5 );

//	player_offset_tag = spawn_tag_origin();
//	player_offset_tag LinkTo( player_rig, "tag_player", (0,0,0), (0,10,0));

//	horz_arc = 15;
//	vert_arc = 5;
//
//	lerp_time = 2;
//	level.player LerpViewAngleClamp( lerp_time, lerp_time * 0.5, lerp_time * 0.5,  horz_arc, horz_arc, vert_arc, vert_arc );

	level waittill( "aim_at_shepherd" );
//	lerp_time = 1;
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 30, 60, 20, 15, true );

//	level.player LerpViewAngleClamp( lerp_time, lerp_time * 0.5, lerp_time * 0.5, 30, 35, 15, 15 );

	level waittill( "pull_back_knife_anim_starts" );

	time = 0.5;
	level.player LerpViewAngleClamp( time, time * 0.5, time * 0.5, 0, 0, 0, 0 );

	flag_wait( "shepherd_killed" );


	//time = 0.25;
	//level.player PlayerLinkToBlend( player_rig, "tag_player", time, time * 0.3, time * 0.5 );
	//wait( time );
	wait 3.2;
	time = 2;
	level.player LerpViewAngleClamp( time, time * 0.5, time * 0.5, 10, 15, 5, 10 );
	wait 3;
	time = 4;
	level.player LerpViewAngleClamp( time, time * 0.5, time * 0.5, 3, 3, 3, 3 );
	//level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 10, 15, 5, 10, true );
}

set_wounded_fov()
{
	level.fov_ent.origin = ( 45, 0, 0 );
}

wait_for_player_to_start_pulling_knife()
{
	childthread dof_shifts_to_knife();

	level.player endon( "pressed_use" );
	thread notify_on_use();

	wait_until_player_looks_at_knife();
	force_player_to_look_at_knife( 1 );
	//wait( 0.2 );

	flag_set( "player_looks_at_knife" );
	flag_wait( "focused_on_knife" );

	thread player_fails_if_he_doesnt_use_knife();

	if ( !knife_hint_visible() )
		fade_in_knife_hint();

	thread fade_to_death_if_no_use();

	for ( ;; )
	{
		if ( level.player UseButtonPressed() )
			break;

		wait( 0.05 );
	}

	fade_in( 0.5 );
	level notify( "player_used_knife" );
	fade_out_knife_hint();
}

fade_to_death_if_no_use()
{
	level endon( "player_used_knife" );
	level.player endon( "pressed_use" );
	wait 4.5;
	fade_out( 6 );
	wait 5;
	missionFailedWrapper();
}

notify_on_use()
{
//	level.player NotifyOnPlayerCommand( "pressed_use", "+use" ); no worky?
	was_pressed = use_pressed();
	for ( ;; )
	{
		if ( !was_pressed && use_pressed() )
			break;
		was_pressed = use_pressed();
		wait 0.05;
	}
	level.player notify( "pressed_use" );
}

sandstorm_wounded_settings()
{
	level.sandstorm_min_dist = 800;
	level.sandstorm_time.min = 0.5;
	level.sandstorm_time.max = 0.8;
}

occumulate_player_use_presses( struct )
{
	self endon( "stop" );

	press_time = 1500;
	self.presses = [];

	max_presses = 7;

	for ( ;; )
	{
		waittillframeend;// this always runs last

		for ( i = 0; i < self.presses.size; i++ )
		{
			press = self.presses[ i ];
			if ( press < GetTime() - press_time )
			{
//				PrintLn( "Removing press at time " + press );
				continue;
			}

			//i -= 1;	
			break;
		}

		newpresses = [];
		// i is set above
		for (; i < self.presses.size; i++ )
		{
			newpresses[ newpresses.size ] = self.presses[ i ];
		}

		self.presses = newpresses;

		scale = ( self.presses.size - struct.occumulator_base ) * 0.03;
		//scale *= scale;
		scale *= 10;
		scale = clamp( scale, 0, 1.0 );
		self.occumulator_scale = scale;

		wait 0.05;
	}

}

timescale_does_not_effect_sound()
{
	channels = maps\_equalizer::get_all_channels();
	foreach ( channel, _ in channels )
	{
		SoundSetTimeScaleFactor( channel, 0 );
	}
}

black_out_on_walk()
{
	wait( 21 );
	overlay = get_black_overlay();
	overlay FadeOverTime( 1.0 );
	overlay.alpha = 0.5;
//	set_vision_set( "aftermath_hurt", 2 );
	level.player delayThread( 0.2, ::play_sound_on_entity, "breathing_hurt_start" );
	wait( 1.4 );

	overlay FadeOverTime( 1.0 );
	overlay.alpha = 0.0;
//	set_vision_set( "aftermath_walking", 5 );

}

gun_drop_slowmo()
{
	start_time = GetTime();
	wait( 2.95 );
	slowmo_start();
	slowmo_setspeed_slow( 0.20 );
	slowmo_setlerptime_in( 0 );
	slowmo_lerp_in();

	wait_for_buffer_time_to_pass( start_time, 3.85 );

	slowmo_setlerptime_out( 0.5 );
	slowmo_lerp_out();
	slowmo_end();
}

swap_knife()
{
	knife = get_knife();
	knife SetModel( "weapon_commando_knife_bloody" );
}


convert_shepherd_to_drone()
{
	if ( !isai( level.shepherd ) )
		return;

	animname = level.shepherd.animname;
	if ( IsDefined( level.shepherd.magic_bullet_shield ) )
		level.shepherd stop_magic_bullet_shield();

	level.shepherd  = maps\_vehicle_aianim::convert_guy_to_drone( level.shepherd );// turning him into a drone at this point. not up for fighting with the boatride script
	Objective_OnEntity( obj( "get_shepherd" ), level.shepherd );// satisfy the systems need for him to be there.
	level.compass_ent = level.shepherd;

	level.shepherd.animname = animname;
	level.shepherd.script = "empty_script";
	level.shepherd.dontdonotetracks = true;

}

slowmo_sound_adjustment()
{
	channels = maps\_equalizer::get_all_channels();
	foreach ( channel, _ in channels )
	{
 		SoundSetTimeScaleFactor( channel, 0.0 );
	}
}

shellshock_very_long( shock )
{
	level.player ShellShock( shock, 31720 );
}


shep_blood()
{
	//wait 1.9;
	self.script_delay -= 3;
	script_delay();
	fx = getfx( "bloodpool_ending" );
	angles = self.angles;
	forward = anglestoforward( angles );
	up = anglestoup( angles );
	PlayFX( fx, self.origin, up, forward );
	

	/*
//	if ( trace[ "normal" ][2] > 0.9 )
	for ( i = 0; i < 50; i++ )
	{
		vec = randomvector( 100 );
		org = trace[ "position" ] + vec;
		PlayFX( level._effect[ "deathfx_bloodpool_generic" ], org );
		Print3d( org, "x", (1,0,0), 1, 1, 500 );
	}
	*/

//	level.shepherd thread animscripts\death::play_blood_pool();


	//restore_dof();

	//blend_to_ending_dof_fov();
//	level.player ShellShock( "af_chase_ending_pulling_knife_later", 60 );
}

expand_player_view()
{
	arc = 10;
	level.player LerpViewAngleClamp( 0.6, 0.25, 0.25, arc, arc, arc, arc );
}

gen_rocks()
{
	selforigin = ( 27756.9, 33994.4, -9962.5 );
//	PhysicsExplosionSphere( struct.origin, 320, 280, 4 );
	models = [];
	models[ models.size ] = "prop_misc_literock_small_01";
	models[ models.size ] = "prop_misc_literock_small_02";
	models[ models.size ] = "prop_misc_literock_small_03";
	models[ models.size ] = "prop_misc_literock_small_04";
	models[ models.size ] = "prop_misc_literock_small_05";
	models[ models.size ] = "prop_misc_literock_small_06";
	models[ models.size ] = "prop_misc_literock_small_07";
	models[ models.size ] = "prop_misc_literock_small_08";

	for ( i = 0; i < 24; i++ )
	{
		vec = randomvector( 200 );
		vec = set_z( vec, 0 );
		origin = selforigin + vec;
		index = RandomInt( models.size );
		ent = Spawn( "script_model", origin );
		ent SetModel( models[ index ] );

//		force = forward;
//		force *= 18000;
//		force *= forcemult[ index ];
//		force *= RandomFloatRange( 0.9, 1.6 );
//		offset = offsets[ index ] + randomvector( 1.2 );
//
//		ent PhysicsLaunchClient( ent.origin + offset, force );
		ent PhysicsLaunchClient( ent.origin, ( 0, 0, 1 ) );
	}

}

scoot_rocks()
{
	thread scoot_rocks_tags( "j_ball_le", "j_ankle_le" );
	thread scoot_rocks_tags( "j_ball_ri", "j_ankle_ri" );

	/*
	tags = [];
	tags[ tags.size ] = "j_ball_le";
	tags[ tags.size ] = "j_ball_ri";
	
	//MagicGrenadeManual( "fraggrenade", level.price.origin + (0,0,64), (0,0,5), 1 );
	for ( ;; )
	{
		foreach ( tag in tags )
		{
			org = self GetTagOrigin( tag );
			//PhysicsJitter( org, 20, 10, 1, 2 );
			//PhysicsJolt( org, 200, 100, (0,0,100) );
			PhysicsExplosionSphere( org, 10, 5, 0.5 );
			
//			Print3d( org, ".", (1,0,0), 1, 0.75, 10 );
			wait RandomFloatRange( 0.1, 0.3 );
		}
	}
	*/
}

get_pos_from_tags( tag1, tag2 )
{
	pos1 = self GetTagOrigin( tag1 );
	pos2 = self GetTagOrigin( tag2 );

	return pos1 * 0.5 + pos2 * 0.5;
}

scoot_rocks_tags( tag1, tag2 )
{
	self endon( "death" );

	oldpos = get_pos_from_tags( tag1, tag2 );

	for ( ;; )
	{
		pos = get_pos_from_tags( tag1, tag2 );

		up_pos = pos + ( 0, 0, 6 );// add some up to the vel
		angles = VectorToAngles( up_pos - oldpos );
		forward = AnglesToForward( angles );
		dist = Distance( oldpos, pos );
		force = dist * forward;

		force *= 0.04;

//		if ( dist < 3 )
//			PhysicsJolt( pos, 12, 8, force );

		oldpos = pos;
		wait 0.2;
	}
}

fight_physics_fires( scene_time )
{
	percent = self.script_percent * 0.01;

	time = scene_time * percent;
	wait time;

	radius = self.radius;
	scale = radius * 0.005;
	org = self.origin + ( 0, 0, 4 );
//	PhysicsExplosionSphere( org, radius, radius, scale );
//	PhysicsExplosionCylinder( self.origin + (0,0,16), radius, radius * 0.75, scale );
	PhysicsExplosionCylinder( org, radius, radius * 0.75, scale );
//	Print3d( org, "x", (1,0,0), 1, 0.5, 10 );
}

fight_physics( scene, scene_time )
{
	foreach ( struct in level.physics_structs[ scene ] )
	{
		struct thread fight_physics_fires( scene_time );
	}
}

init_fight_physics()
{
	structs = getstructarray( "physics_struct", "targetname" );
	array = [];

	ent = SpawnStruct();
	ent.origin = ( 27880, 34109, -9946 );
	ent.script_percent = 6.1;
	ent.radius = 15;
	ent.script_noteworthy = "gun_kick_price";
	structs[ structs.size ] = ent;


	ent = SpawnStruct();
	ent.origin = ( 27869, 34040, -9961 );
	ent.script_percent = 33.9;
	ent.radius = 15;
	ent.script_noteworthy = "gun_kick";
	structs[ structs.size ] = ent;


	foreach ( struct in structs )
	{
		scene = struct.script_noteworthy;

//		if ( scene == "fight_B2" )
//			struct.script_percent *= 1.90163; //included more frames in the anim
		if ( !isdefined( array[ scene ] ) )
		{
			array[ scene ] = [];
		}

		array[ scene ][ array[ scene ].size ] = struct;
	}


	level.physics_structs = array;
}

beat_up_prices_head()
{
//	level.price Detach( "head_hero_price_desert" );
//	level.price Attach( "head_hero_price_desert_beaten" );

}

shep_beatup()
{
//	level.shepherd Detach( "head_vil_shepherd" );
//	level.shepherd Attach( "head_vil_shepherd_damaged" );
}


helicopter_sound_blend()
{
	//afchase_littlebird_idle_off
	//afchase_littlebird_idle
	//afchase_littlebird_fly_off
	//afchase_littlebird_fly
		
	fly = "afchase_littlebird_fly";
	idle = "afchase_littlebird_idle";
	land = "afchase_littlebird_landed";


	flyblend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	flyblend thread manual_linkto( self, ( 0, 0, 0 ) );

	idleblend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	idleblend thread manual_linkto( self, ( 0, 0, 64 ) );

	flyblend thread mix_up( fly );
	wait 4;

	flyblend thread mix_down( fly );
	idleblend thread mix_up( idle );

	wait 13.5;

	flyblend thread mix_down( idle );
	idleblend thread mix_up( land );
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


eq_blender()
{
	setsaveddvar( "g_enteqdist", 1 );
	
	if ( isdefined( level.eq_ent ) )
		return;
	ent = spawn_tag_origin();
	level.eq_ent = ent;

	for ( ;; )
	{
		pos = clamp( ent.origin[ 0 ], 0, 1 );
		level.player SetEqLerp( pos, level.eq_mix_track );
		wait 0.05;
	}
}

set_water_sheating_time( bump_small, bump_big )
{
	// duplicated in af_chase_code
	level.water_sheating_time[ "bump" ] = level.water_sheating_time[ bump_small ];
	level.water_sheating_time[ "bump_big" ] = level.water_sheating_time[ bump_big ];
}

stop_melee_hint()
{
	if ( !isalive( level.crawler ) )
		return true;

	if ( !close_enough_for_melee_hint() )
		return true;
		
	return flag( "player_learned_melee" );	
}

player_melee_hint()
{
	notifyOnCommand( "player_did_melee", "+melee" );
	
	for ( ;; )
	{
		level.player waittill( "player_did_melee" );
		flag_set( "player_learned_melee" );
		break;
	}
}

close_enough_for_melee_hint()
{
	if ( !isalive( level.crawler ) )
		return false;
	
	dist = distance( level.crawler.origin, level.player.origin );
	
	return dist < 100;
}

hint_melee()
{
	self endon( "death" );
	was_close_enough = false;
	close_enough_time = 0;
	
	thread player_melee_hint();
	
	for ( ;; )
	{
		close_enough = close_enough_for_melee_hint();
		if ( close_enough )
		{
			if ( !was_close_enough )
				close_enough_time = gettime();
		}
		else
		{
			close_enough_time = 0;
		}
		
		hint_time_up = close_enough_time && gettime() > close_enough_time + 2000;
		
		attack_pressed = level.player attackButtonPressed();
		
		if ( hint_time_up || attack_pressed )
			display_hint( "hint_melee" );
		
		was_close_enough = close_enough;
		wait 0.05;
	}	
}

ending_fade_out()
{
	level endon( "now_fade_in" );
	/*


	min_time = 0;
	min_value = -0.4;

	max_time = 16.5;
	max_value = 1;
	
	max_time *= 1000;
	
	start_time = gettime();
	
	for ( ;; )
	{
		time = gettime();
		boost = sin( time * 0.09 ) * 0.5 + 0.5;
		boost *= 0.3;
		
		time_passed = time - start_time;
		base = graph_position( time_passed, min_time, min_value, max_time, max_value );
		
		alpha = base + boost;
		
		alpha = clamp( alpha, 0, 1 );
		
		black_overlay.alpha = alpha;
		black_overlay FadeOverTime( 0.1 );
		
		level.eq_ent.origin = ( ( alpha, 0, 0 ) );
		
		if ( alpha >= 0.8 )
			break;
			
		wait 0.05;
	}
	*/
	black_overlay = get_black_overlay();
	offset = 7;
	wait 2 + offset;
	fade_time = 8 - offset;
	black_overlay FadeOverTime( fade_time );
	black_overlay.alpha = 1;
//	level.eq_ent moveto( (1,0,0), fade_time, 0, 0 );
}
