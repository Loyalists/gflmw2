#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\favela_escape_anim;

#using_animtree( "generic_human" );


// these can be triggered from any trigger, usually makes sense with a spawn trigger though
triggered_hostile_bursts_setup()
{
	triggered_hostile_burst_setup_lines();
	
	allents = GetEntArray();
	
	while( !IsDefined( level.struct_class_names ) )
	{
		wait( 0.05 );
	}
	
	trigs = [];
	foreach( ent in allents )
	{
		if ( !isdefined( ent.code_classname ) )
		{
			continue;
		}
		
		if( IsSubStr( ent.code_classname, "trigger" ) )
		{
			trigs[ trigs.size ] = ent;
		}
	}
	
	foreach( trig in trigs )
	{
		if( !IsDefined( trig.target ) )
		{
			continue;
		}
		
		orgs = GetStructArray( trig.target, "targetname" );
		
		foreach( org in orgs )
		{
			if( IsDefined( org.script_noteworthy ) && org.script_noteworthy == "hostile_burst" )
			{
				trig thread triggered_hostile_burst( org );
			}
		}
	}
}

triggered_hostile_burst_setup_lines()
{
	lines = [];
	
	// "You're going to pay for what you did to my brother, soldier! You hear me?"
	lines[ lines.size ] = "favesc_pe1_youhearme";
	
	// "Eduardo, call the truck! And bring more grenades! We're going to flush them out of this building!"
	lines[ lines.size ] = "favesc_pe2_callthetruck";
	
	// "We're going to kill you slowly for what you've done here. Do you hear me?"
	lines[ lines.size ] = "favesc_pe3_killslowly";
	
	// "Get on the roof of those buildings and go around them!! They can't stop all of us!!"
	lines[ lines.size ] = "favesc_pe3_cantstop";
	
	// "There is nowhere for you to run!!! We will find you wherever you go!!"
	lines[ lines.size ] = "favesc_pe4_wellfindyou";
	
	// "Heitor, set up the machine gun in the alley over on the next street, in case they go that way!!!"
	lines[ lines.size ] = "favesc_pe3_mginalley";
	
	// "Go after them!! Hurry!! Run them down!!"
	lines[ lines.size ] = "favesc_pe3_afterthem";
	
	// "Block the exits from this area! Don't let them escape!!"
	lines[ lines.size ] = "favesc_pe3_blockexits";
	
	// "Kill them!!! Kill them all!!! They deserve nothing less!!!"
	lines[ lines.size ] = "favesc_pe4_killthemall";
	
	// "There is nowhere for you to run!!! We will find you wherever you go!!"
	lines[ lines.size ] = "favesc_pe4_wellfindyou";
	
	// "Chase them!! Chase them!!!"
	lines[ lines.size ] = "favesc_pe4_chasethem";
	
	// "Hunt them down like animals!!!"
	lines[ lines.size ] = "favesc_pe4_huntthem";
	
	// "I'm going to cut you apart, limb by limb!!!"
	lines[ lines.size ] = "favesc_pe2_limbbylimb";
	
	// "People like you killed my family!! Never again!!!"
	lines[ lines.size ] = "favesc_pe4_neveragain";
	
	// "The police have no honor, now they send mercenaries to oppress us!!!"
	lines[ lines.size ] = "favesc_pe1_nohonor";
	
	// "Don't just throw the grenades! Wait at least two seconds before you throw them!"
	lines[ lines.size ] = "favesc_pe2_wait2seconds";
	
	// "If you capture them, keep them alive so we can use the machete!!!"
	lines[ lines.size ] = "favesc_pe1_keepthemalive";
	
	// "We need more bandages for the wounded!"
	lines[ lines.size ] = "favesc_pe2_morebandages";
	
	// "I will avenge my brother!!"
	lines[ lines.size ] = "favesc_pe1_avengemybrother";
	
	// "Get on the roof of those buildings and go around them!! They can't stop all of us!!"
	lines[ lines.size ] = "favesc_pe3_cantstop";
	
	// "You're all going to die up here for all the blood you've spilled!!!"
	lines[ lines.size ] = "favesc_pe1_goingtodie";
	
	
	lines = array_randomize( lines );
	
	level.triggeredHostileBursts = lines;
	
	level.triggeredHostileBurstIndex = undefined;
}

triggered_hostile_burst( org )
{
	self waittill( "trigger" );

	if( !self script_delay() )
	{
		wait( RandomFloatRange( 0.5, 1.25 ) );  // let the enemies spawn
	}
	
	burst = undefined;
	if( IsDefined( org.script_parameters ) )
	{
		burst = org.script_parameters;
	}
	
	if( !IsDefined( burst ) )
	{
		if( !IsDefined( level.triggeredHostileBurstIndex ) )
		{
			level.triggeredHostileBurstIndex = 0;
		}
		
		burst = level.triggeredHostileBursts[ level.triggeredHostileBurstIndex ];
		
		level.triggeredHostileBurstIndex++;
		if( level.triggeredHostileBurstIndex >= ( level.triggeredHostileBursts.size - 1 ) )
		{
			level.triggeredHostileBurstIndex = 0;
		}
	}
	
	level thread play_sound_in_space( burst, org.origin );
}


// -------------
// --- MUSIC ---
// -------------
favesc_combat_music()
{
	thread favesc_combat_music_stop();
	
	alias = "favelaescape_combat";
	tracktime = MusicLength( alias );
	
	while( !flag( "market_evac_insidepath_start" ) )
	{
		MusicPlayWrapper( alias );
		wait( tracktime );
		music_stop( 1 );
		wait( 3 );
	}
}

favesc_combat_music_stop()
{
	flag_wait( "market_evac_insidepath_start" );
	music_stop( 7.5 );
}

favesc_waveoff_music()
{
	music_loop( "favelaescape_waveoff", 72 );
}

favesc_falling_music()
{
	music_stop( 3 );
	level.player play_sound_on_entity( "favelaescape_fixedfall", "fixedfall_music_done" );
}

favesc_finalrun_music()
{
	music_stop( 3 );
	wait( 3 );
	MusicPlayWrapper( "favelaescape_finalrun" );
	
	flag_wait( "solorun_player_boarded_chopper" );
	music_stop( 10 );
	level.player play_sound_on_entity( "favelaescape_ending" );
}


// --------------
// --- WALLAS ---
// --------------
/* megaphone processed aliases:
favesc_pgm_killthemall
favesc_pgm_wellfindyou
favesc_pgm_nohonor
favesc_pgm_huntthem
favesc_pgm_blockexits
*/
radiotower_crowd_walla()
{
	org = ( 3712, 576, 1211 );
	delaythread( 5, ::play_sound_in_space, "favesc_pgm_wellfindyou", org );
	delaythread( 20, ::play_sound_in_space, "favesc_pgm_huntthem", org );
	play_sound_in_space( "wlla_favela_escape_start", org );
}

vista1_walla()
{
	org = ( 1972, -1340, 734 );
	delaythread( 5, ::play_sound_in_space, "favesc_pgm_blockexits", org );
	play_sound_in_space( "wlla_favela_escape_vista1", org );
}

vista2_walla()
{
	flag_wait( "uphill_advance_3" );
	
	org = ( -1156, 1796, 1124 );
	delaythread( 5, ::play_sound_in_space, "favesc_pgm_killthemall", org );
	delaythread( 20, ::play_sound_in_space, "favesc_pgm_nohonor", org );
	play_sound_in_space( "wlla_favela_escape_vista2", org );
}

market_evac_escape_walla()
{
	level.player play_sound_on_entity( "wlla_favela_escape_soccer" );
}

roofrun_walla()
{
	level.player play_sound_on_entity( "wlla_favela_escape_running1" );
}

bigjump_recovery_rightside_walla()
{
	org = ( -5588, -1852, 912 );
	delaythread( 5, ::play_sound_in_space, "favesc_pgm_wellfindyou", org );
	play_sound_in_space( "wlla_favela_escape_fallen_right", org );
}

bigjump_recovery_leftside_walla()
{
	org = ( -5704, -376, 814 );
	delaythread( 10, ::play_sound_in_space, "favesc_pgm_huntthem", org );
	play_sound_in_space( "wlla_favela_escape_fallen_left", org );
}


// ------------------
// --- RADIOTOWER ---
// ------------------
radiotower_runpath_dialogue()
{
	waitflag = "runpath_dialogue_continue"; 
	flag_init( waitflag );
	thread radiotower_runpath_dialogue_triggerwait( waitflag );
	
	flag_wait( "introscreen_start_dialogue" );
	
	// "Sir, the militia's closin' in! Almost two hundred of 'em, front and back!"
	level.hero1 dialogue( "favesc_gst_closingin" );
	
	// "We're gonna have to fight our way to the LZ! Let's go!"
	level.sarge dialogue( "favesc_cmt_fightourway" );
	
	// "What about Rojas?"
	level.hero1 dialogue( "favesc_gst_whataboutrojas" );
	
	// "Victim of a hostile takeover?"
	level.sarge dialogue( "favesc_cmt_takeover" );
	
	// "Works for me."
	level.hero1 dialogue( "favesc_gst_worksforme" );
	
	flag_wait( waitflag );
	
	// "Nikolai! We're at the top of the favela surrounded by militia! Bring the chopper to the market, do you copy, over!"
	level.sarge dialogue( "favesc_cmt_surrounded" );
	
	// "Ok my friend, I am on the way!"
	radio_dialogue( "favesc_nkl_ontheway" );
	
	// "Everyone get ready! Lock and load! "
	level.sarge dialogue( "favesc_cmt_lockandload" );
	
	// "Let's do this!!"
	level.hero1 dialogue( "favesc_gst_letsdothis" );
	
	flag_set( "radiotower_runpath_dialogue_done" );
}

radiotower_runpath_dialogue_triggerwait( flagname )
{
	trigger_wait_targetname( "trig_intro_playerturnedcorner" );
	flag_set( flagname );
}

// to avoid the feeling of endlessly picking off guys, stop the floodspawners early if we kill enough of them
radiotower_stop_roof_respawners()
{
	killsBeforeShutdown = 5;
	
	// this spawnfunc will track their deaths
	roofspawners = GetEntArray( "spawner_radiotower_wave1", "targetname" );
	array_thread( roofspawners, ::add_spawn_function, ::radiotower_roofguy_spawnfunc );
	
	if( !IsDefined( level.roofGuysKilled ) )
	{
		level.roofGuysKilled = 0;
	}
	
	while( level.roofGuysKilled < killsBeforeShutdown )
	{
		wait( 0.1 );
	}
	
	trigger_activate_targetname_safe( "trig_killspawner_7" );
}

radiotower_roofguy_spawnfunc()
{
	self waittill( "death", attacker );
	
	if( maps\_spawner::player_saw_kill( self, attacker ) )
	{
		level.roofGuysKilled++;
	}
}

radiotower_runup_scout()
{
	spawner = GetEnt( "radiotower_path_scout", "targetname" );
	anime = spawner.animation;
	endgoal = GetNode( spawner.target, "targetname" );
	
	guy = spawner spawn_ai();
	
	guy magic_bullet_shield();
	
	guy ignore_everything();
	guy.ignoreme = true;
	
	spawner anim_generic_first_frame( guy, anime );
	
	trigger_wait_targetname( "trig_radiotower_brushpath_start" );
	
	guy stop_magic_bullet_shield();
	guy endon( "death" );
	guy.allowdeath = true;
	
	// "Here they come!"
	guy thread play_sound_on_entity( "favesc_pe1_heretheycome" );
	spawner anim_generic( guy, anime );
	
	guy.goalradius = 64;
	guy SetGoalNode( endgoal );
	
	guy waittill( "goal" );
	
	if( IsDefined( guy ) )
	{
		guy clear_ignore_everything();
		guy.ignoreme = false;
		guy.fixednode = false;
		guy.goalradius = 1024;
		guy.combatmode = "ambush";
	}
}

radiotower_runup_friendlies_ignore()
{
	array_thread( level.friends, ::scr_ignoreall, true );
	
	trigger_wait_targetname( "trig_radiotower_brushpath_start" );
	
	// lets them look surprised
	wait( 2.25 );
	array_thread( level.friends, ::scr_ignoreall, false );
}

radiotower_friendly_colors()
{
	trigger_wait_targetname( "trig_radiotower_forcecolor_change_1" );
	level.sarge set_force_color( "b" );
}

radiotower_doorkick_1()
{
	trigger_wait_targetname( "trig_radiotower_doorkick_1" );
	
	tracer = GetStruct( "struct_radiotower_doorkick_1_sighttracer", "targetname" );
	// timer, dot (fov = 80)
	tracer waittill_player_lookat_for_time( 1, 0.7 );
	
	spawners = GetEntArray( "spawner_radiotower_doorkick_1", "targetname" );
	door = GetEnt( "sbmodel_radiotower_doorkick_1", "targetname" );
	kickRef = GetStruct( "struct_radiotower_doorkick_1_animref", "targetname" );
	
	thread door_kick_housespawn( spawners, door, kickRef );
	
	if( flag( "radiotower_runpath_dialogue_done" ) )
	{
		// "Militia comin' out of the shack on the left!"
		level.hero1 delaythread( 1, ::dialogue, "favesc_gst_shackonleft" );
	}
	
	// makes sure that dudes will go out the kicked door
	wait( 5 );
	backdoorBlocker = GetEnt( "sbmodel_radiotower_doorkick_1_backdoor_blocker", "targetname" );
	backdoorBlocker Delete();
}

radiotower_curtainpull_1()
{
	// spawn the curtain model early in this case
	node = GetEnt( "radiotower_curtainpull1_animref", "targetname" );
	curtain_pulldown_spawnmodel( node );
	
	// for our special waitfunc to use later
	node.traceSpot = GetStruct( "radiotower_curtainpull1_sighttracer", "targetname" );
	
	spawner = GetEnt( "spawner_radiotower_curtainpull_1", "targetname" );
	spawner thread curtain_pulldown( true, ::distant_curtainpull_waitfunc );
	
	level endon( "radiotower_exit" );
	
	trigger_wait( "trig_radiotower_rooftop_spawn", "script_noteworthy" );
	
	spawner spawn_ai();
	
}

distant_curtainpull_waitfunc( guy, node )
{
	guy endon( "death" );
	
	tracer = node.traceSpot;

	// default dot = 0.92
	tracer waittill_player_lookat( 0.95, 1.25 );
}

radiotower_hiding_door_guy_cleanup()
{
	killtrig = GetEnt( "trig_killspawner_radiotower_hiding_door_guy", "targetname" );
	spawner = undefined;
	door_org = undefined;
	
	worldOrigin = ( 4374, 1252, 1060 );
	
	ents = GetEntArray( "hiding_door_spawner", "script_noteworthy" );
	spawner = getclosest( worldOrigin, ents );
	
	door_clips = level._hiding_door_pushplayer_clips;
	door_clip = getclosest( worldOrigin, door_clips );
	
	thread radiotower_hiding_door_guy_cleanup_cancel( spawner, killtrig );
	level endon( "radiotower_hiding_door_guy_cleanup_cancel" );
	
	killtrig waittill( "trigger" );
	
	door_clip Delete();
}

radiotower_hiding_door_guy_cleanup_cancel( spawner, killtrig )
{
	killtrig endon( "trigger" );
	
	spawner waittill( "trigger" );
	level notify( "radiotower_hiding_door_guy_cleanup_cancel" );
}

radiotower_gate_open( doFx )
{
	if( !IsDefined( doFx ) )
	{
		doFx = true;
	}
	
	gateLeft = GetEnt( "sbmodel_radiotower_gate_left", "targetname" );
	gateRight = GetEnt( "sbmodel_radiotower_gate_right", "targetname" );
	
	openTime = 0.75;
	
	gates[0] = gateLeft;
	gates[1] = gateRight;
	gates[0] PlaySound( "scn_favela_escape_wood_gate" );
	array_thread( gates, ::sbmodel_rotate, openTime );
	
	if( doFx )
	{
		exploder( 1 );
	}
	
	gates[0] waittill( "sbmodel_rotatedone" );
}

radiotower_enemy_vehicles_prethink()
{
	flag_wait( "radiotower_vehicles_start" );
	
	thread radiotower_enemy_vehicles();
}

radiotower_enemy_vehicles()
{
	arr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
	technical = arr[ 0 ];
	technical thread play_sound_on_entity( "scn_favela_escape_truck_runup" );
	
	// open up exploder gates
	exploder( 110 );
	exploder( 120 );
	
	technical thread radiotower_technical_setup();
	
	// make a badplace where the truck does a donut
	technical thread radiotower_enemy_vehicles_badplaces();
	
	gate_node = GetVehicleNode( "node_technical_bust_gate", "script_noteworthy" );
	gate_node waittill( "trigger" );
	
	technical delaythread( 0.7, ::play_sound_on_entity, "scn_favela_escape_truck_land" );
	technical delaythread( 1.7, ::play_sound_on_entity, "scn_favela_escape_truck_donut" );
	
	flag_set( "radiotower_escape_technical_1_arrival" );
	level thread radiotower_gate_open();
	delaythread( 3, ::radiotower_enemy_vehicle_2 );
	delaythread( 5, ::radiotower_remove_vehicleclip );
}

radiotower_enemy_vehicles_badplaces()
{
	self waitfor_some_speed();
	
	refs = [];
	refs = GetStructArray( "struct_radiotower_vehicle1_road_badplaceRef", "targetname" );
	refs[ refs.size ] = GetStruct( "struct_radiotower_vehicle1_donut_badplaceRef", "targetname" );
	
	names = [];
	
	foreach( index, ref in refs )
	{
		badplaceName = "vehicle1_badplace_" + index;
		
		BadPlace_Cylinder( badplaceName, -1, groundpos( ref.origin ), ref.radius, 128, "axis", "allies" );
		
		names[ names.size ] = badplaceName;
	}
	
	while( !flag( "radiotower_vehicle1_donut_done" ) && self.health > 0 && self Vehicle_GetSpeed() > 1 )
	{
		wait( 0.1 );
	}
	
	foreach( name in names )
	{
		BadPlace_Delete( name );
	}
}

radiotower_enemy_vehicle_2()
{
	arr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 1 );
	technical = arr[ 0 ];
	
	technical thread radiotower_technical_setup();
	
	arrivalNode = GetVehicleNode( "vnode_technical2_arrival", "script_noteworthy" );
	arrivalNode waittill( "trigger" );
	flag_set( "radiotower_escape_technical_2_arrival" );
}

radiotower_technical_setup()
{
	waittillframeend;  // let the technical spawn
	
	self ent_flag_init( "reached_end_node" );
	self ent_flag_init( "stopped" );
	
	self thread technical_waittill_end_node();
	self thread technical_waittill_stopped();
	
	// find the gunner
	gunner = self vehicle_get_gunner();
	ASSERT( IsDefined( gunner ) );
	
	self ent_flag_init( "godoff" );
	self thread technical_temp_invincibility( gunner );
	
	turret = self.mgturret[ 0 ];
	turret thread technical_turret_think( self, gunner );
}

technical_waittill_end_node()
{
	self endon( "death" );
	self waittill( "reached_end_node" );
	self ent_flag_set( "reached_end_node" );
}

technical_waittill_stopped()
{
	self endon( "death" );
	
	self waitfor_some_speed();
	
	while( self Vehicle_GetSpeed() > 0 )
	{
		wait( 0.05 );
	}
	
	self ent_flag_set( "stopped" );
}

vehicle_get_gunner()
{
	gunner = undefined;
	foreach( guy in self.riders )
	{
		animpos = maps\_vehicle_aianim::anim_pos( self, guy.vehicle_position );
		
		if( maps\_vehicle_aianim::guy_should_man_turret( animpos ) )
		{
			gunner = guy;
			break;
		}
	}
	
	return gunner;
}

technical_temp_invincibility( gunner )
{
	self.resetHealth = false;
	
	riders = self.riders;
	array_thread( riders, ::magic_bullet_shield );
	foreach( rider in riders )
	{
		rider.health = 10000000;
		rider.threatbias = -2500;
		rider.attackerAccuracy = 0.5;
		rider thread vehicle_rider_reset_health( self, gunner );
	}
	
	self thread maps\_vehicle::godon();
	
	self waitfor_some_speed();
	
	self thread reset_health_at_end_node();
	self thread reset_health_at_low_speed();
	
	while( IsDefined( self ) && !self.resetHealth && !self ent_flag( "godoff" ) )
	{
		wait( 0.05 );
	}
	
	if( IsDefined( self ) )
	{
		self thread maps\_vehicle::godoff();
		self vehicle_set_health( 1500 );
		self notify( "technical_health_reset" );
	}
}

vehicle_rider_reset_health( vehicle, gunner )
{
	self endon( "death" );
	vehicle endon( "death" );
	
	vehicle ent_flag_wait( "godoff" );
	self.allowdeath = true;
	
	// hack to fix gunner pain anims snapping them back to the turret
	if( IsDefined( gunner ) && self == gunner )
	{
		self.health = 1;
	}
	else
	{
		self.health = 150;
	}
	
	self thread stop_magic_bullet_shield_safe();
}

vehicle_set_health( health )
{
	self.health = health + self.healthbuffer;
	self.currenthealth = self.health;
}

reset_health_at_end_node()
{
	self endon( "death" );
	self endon( "technical_health_reset" );
	
	self waitfor_end_node();
	self.resetHealth = true;
}

reset_health_at_low_speed()
{
	self endon( "death" );
	self endon( "technical_health_reset" );
	
	self waitfor_low_speed();
	self.resetHealth = true;
}

waitfor_end_node()
{
	self endon( "death" );
	self waittill( "reached_end_node" );	
}

waitfor_low_speed()
{
	self endon( "death" );
	self endon( "technical_health_reset" );
	
	while( self Vehicle_GetSpeed() > 2 )
	{
		wait( 0.1 );
	}
}

waitfor_some_speed()
{
	self endon( "death" );
	self endon( "technical_health_reset" );
	
	while( self Vehicle_GetSpeed() < 1 )
	{
		wait( 0.1 );
	}
}

technical_turret_think( vehicle, gunner )
{
	self endon( "death" );
	
	// this isn't getting called on all the technicals
	//self thread turret_disable_til_node( vehicle, gunner );
	gunner thread gunner_scripted_death();
	
	// gunner has to die, and vehicle has to stop
	gunner waittill( "death" );
	vehicle ent_flag_wait_either( "reached_end_node", "stopped" );
	
	// now the gun is usable by the player
	self MakeUsable();
}

turret_disable_til_node( vehicle, gunner )
{
	self endon( "death" );
	gunner endon( "death" );
	
	self TurretFireDisable();
	vehicle waittillmatch( "noteworthy", "vnode_technical_turret_activate" );
	self TurretFireEnable();
}

gunner_scripted_death()
{
	self endon( "death" );
	level waittill( "kill_technical_gunners" );
	self stop_magic_bullet_shield_safe();
	self Kill();
}

radiotower_remove_vehicleclip()
{
	clip = GetEnt( "sbmodel_technical_jump_helper", "targetname" );
	clip trigger_off();
}

radiotower_escape_dialogue()
{
	thread radiotower_enemy_callout_rooftop();
	thread radiotower_enemy_callout_walljumpers_left();
	
	// "Tangos at ground level dead ahead!!"
	level.hero1 dialogue( "favesc_gst_deadahead" );
	
	// "We've gotta get to the helicopter - head through the gate to the market! Move!"
	level.sarge dialogue( "favesc_cmt_thrugate" );
	
	battlechatter_on( "allies" );
	
	flag_wait( "radiotower_escape_technical_1_arrival" );
	
	battlechatter_off( "allies" );
	
	// "Technical comin' in from the south!!"
	level.hero1 dialogue( "favesc_gst_technical" );
	
	flag_wait( "radiotower_escape_technical_2_arrival" );
	
	// "We got another technical! Take it out!!!"
	level.sarge dialogue( "favesc_cmt_technical" );
	
	battlechatter_on( "allies" );
}

radiotower_enemy_callout_rooftop()
{
	level endon( "radiotower_exit" );
	
	trigger_wait( "trig_radiotower_rooftop_spawn", "script_noteworthy" );
	
	/*
	startTime = GetTime();
	
	flag_waitopen( "scripted_dialogue" );
	
	if( seconds( GetTime() - startTime ) < 0.5 )
	{
		wait( 2 );
	}
	*/
	
	// "Contaaact!!! Foot-mobiles on the rooftops, closing in fast from the south!!!"
	level.hero1 dialogue( "favesc_gst_onrooftops" );
}
	
radiotower_enemy_callout_walljumpers_left()
{
	level endon( "radiotower_exit" );
	
	trigger_wait_targetname( "trig_radiotower_walljumper_spawn" );
	
	//flag_waitopen( "scripted_dialogue" );
	
	// "Tangos moving in low from the southeast!"
	level.sarge dialogue( "favesc_cmt_lowfromse" );
}

radiotower_enemies_retreat()
{
	// don't retreat until after the second vehicle shows up
	flag_wait( "radiotower_escape_technical_2_arrival" );
	
	while( get_alive_enemies().size >= 6 )
	{
		wait( 0.1 );
	}
	
	// turn off triggers in case player comes back through here for some reason
	spawntrigs = GetEntArray( "trig_radiotower_cleanup_at_exit", "script_noteworthy" );
	array_thread( spawntrigs, ::trigger_off );
	
	// activate killspawner
	trigger_activate_targetname_safe( "trig_killspawner_7" );
	
	allenemies = get_alive_enemies();
	enemies = [];
	roofenemies = [];
	foreach( guy in allenemies )
	{
		if( guy.origin[ 0 ] > 3600 )
		{
			if( guy.origin[ 2 ] > 1140 )
			{
				roofenemies[roofenemies.size] = guy;
			}
			else
			{
				enemies[enemies.size] = guy;
			}
		}
	}
	
	flag_set( "radiotower_enemies_retreat" );
	
	// roof enemies die
	level thread kill_group_over_time( roofenemies, 10 );
	
	level notify( "kill_technical_gunners" );
	
	// try resetting goalpos to avoid the "cannot set goal volume when a goal entity is set" SRE
	//  (this happens to guys who are playerseeking)
	foreach( guy in enemies )
	{
		guy SetGoalPos( guy.origin );
	}
	wait( 0.05 );
	
	// guys retreat
	retreatVolume = GetEnt( "goalvolume_52", "targetname" );
	enemies = array_removeundefined( enemies );
	enemies = array_removedead( enemies );
	thread array_call( enemies, ::SetGoalVolumeAuto, retreatVolume );
	
	// "Head through that gate!!! Keep pushing to the evac point!!!"
	level.sarge dialogue( "favesc_cmt_thruthatgate" );
	
	// "Go! Go! Go!"
	level.hero1 dialogue( "favesc_gst_gogogo" );
	
	flag_set( "radiotower_escape_moveup" );
	
	// turn off triggers that can send friendlies back after we force them forward
	trigs = GetEntArray( "trig_radiotower_escape_removeAtExit", "targetname" );
	array_thread( trigs, ::trigger_off );
	
	// put soap on the right color chain, if the player didn't hit that trigger already
	trigger_activate_targetname_safe( "trig_radiotower_forcecolor_change_1" );
	
	// move friendlies up if the player hasn't already
	trig = GetEnt( "trig_script_color_allies_b5", "targetname" );
	if( IsDefined( trig ) )
	{
		trig notify( "trigger" );
	}
}

// ---------------
// --- STREETS ---
// ---------------
street_dialogue()
{
	thread street_dialogue_playerabove();
	thread street_dialogue_leftalley();
	
	flag_wait( "vista1_dialogue_start" );
	
	// "Let's go, let's go!  We've gotta push through these streets to the market!"
	level.sarge dialogue( "favesc_cmt_pushthrustreets" );
	
	flag_wait( "multipath_dialogue_start" );
	
	// "Watch for flanking routes!"
	level.sarge dialogue( "favesc_cmt_flankingroutes" );
	
	flag_wait( "almostatmarket_dialogue_start" );
	
	// "Keep moving!! We're almost at the market!"
	level.sarge dialogue( "favesc_cmt_almostatmarket" );
}

street_dialogue_playerabove()
{
	level endon( "playerabove_dialogue_cancel" );
	
	flag_wait( "playerabove_dialogue_start" );
	
	// "Roach! Lay down some fire on the intersection!"
	level.sarge dialogue( "favesc_cmt_laydownfire" );
}

street_dialogue_leftalley()
{
	flag_wait( "leftalley_dialogue_start" );
	
	// "Heads up! Alley on the left!"
	level.sarge thread dialogue( "favesc_cmt_alleyonleft" );
}

vista1_door1_kick()
{
	trigger_wait_targetname( "trig_vista1_doorkick1" );
	
	tracer = GetStruct( "struct_vista1_doorkick1_sighttracer", "targetname" );
	tracer waittill_player_lookat_for_time( 1.5, 0.7 );
	
	door = GetEnt( "sbmodel_vista1_door1", "targetname" );
	animref = GetStruct( "struct_vista1_door1_animref", "targetname" );
	spawners = GetEntArray( "spawner_vista1_door1_houseguy", "targetname" );
	
	thread door_kick_housespawn( spawners, door, animref );
}

vista1_wavingguy()
{
	level endon( "multipath_dialogue_start" );
	flag_wait( "street_advance_1" );
	
	animref = GetStruct( "struct_vista1_wavingguy_animref", "targetname" );
	spawner = GetEnt( animref.target, "targetname" );
	anime = "favela_run_and_wave";
	
	guy = spawner spawn_ai();
	guy.ignoreme = true;
	guy.ignoreall = true;
	guy magic_bullet_shield();
	
	animref anim_generic_first_frame( guy, anime );
	
	// remove this guy if we don't ever get to him for some reason
	guy thread vista1_wavingguy_cleanup();
	
	// wait for anime
	trigger_wait_targetname( "trig_vista1_wavingguy" );
	
	// spawn his buddies
	thread trigger_activate_targetname( "trig_vista1_wavingguy_spawngroup" );
	
	guy stop_magic_bullet_shield();
	guy.allowdeath = true;
	
	guy notify( "wavingguy_activated" );
	
	// "Attaaaack!"
	guy thread play_sound_on_entity( "favesc_pe1_attack" );
	
	// he waves them on
	animref anim_generic( guy, anime );
	
	// when done, waver fights
	if( IsAlive( guy ) )
	{
		guy.ignoreme = false;
		guy.ignoreall = false;
		node = GetNode( guy.target, "targetname" );
		guy SetGoalNode( node );
	}
}

vista1_wavingguy_cleanup()
{
	self endon( "death" );
	self endon( "wavingguy_activated" );
	
	flag_wait( "multipath_dialogue_start" );
	self stop_magic_bullet_shield();
	self Delete();
}

street_roof1_doorkick()
{
	trigger_wait_targetname_multiple( "trig_street_roof1_doorkick" );
	
	spawners = GetEntArray( "spawner_street_roof1_doorkick", "targetname" );
	door = GetEnt( "sbmodel_street_roof1_doorkick", "targetname" );
	kickRef = GetStruct( "struct_street_roof1_doorkick_animref", "targetname" );
	
	thread door_kick_housespawn( spawners, door, kickRef );
}

// helps clear out the intersection faster if the player is moving ahead
street_mid_intersection_clearout()
{
	flag_wait( "uphill_advance_3" );
	
	thread street_mid_intersection_kill_inside_guys();
	
	vols = GetEntArray( "volume_enemies_street_mid_intersection", "targetname" );
	ASSERT( vols.size );
	
	array_thread( vols, ::street_mid_intersection_clearout_volume );
}

street_mid_intersection_kill_inside_guys()
{
	guys = get_ai_group_ai( "street_mid_inside_guys" );
	array_thread( guys, ::kill_when_player_not_looking );
}

street_mid_intersection_clearout_volume()
{
	level endon( "market_evac_start" );
	
	clearoutWaitTime = milliseconds( 5 );
	
	while( 1 )
	{
		wait( RandomFloatRange( 0.5, 1 ) );  // don't grab the aiarray at the same time for each volume
		
		ais = self get_ai_touching_volume( "axis", "human" );
		
		foreach( guy in ais )
		{
			if( !IsAlive( guy ) )
			{
				continue;
			}
			
			if( guy doingLongDeath() )
			{
				continue;
			}
			
			if( IsDefined( guy.volume_clearout ) )
			{
				if( GetTime() > guy.volume_clearout + clearoutWaitTime && !IsDefined( guy.waitingToKill ) )
				{
					guy.waitingToKill = true;
					guy thread kill_when_player_not_looking();
				}
				
				continue;
			}
			
			guy.volume_clearout = GetTime();
			guy.health = 1;
			guy.attackeraccuracy = 1;
			//guy thread set_ignoreSuppression( true );
		}
	}
}

kill_when_player_not_looking()
{
	self endon( "death" );
	
	while( within_fov( level.player.origin, level.player GetPlayerAngles(), self.origin, level.cosine[ "45" ] ) )
	{
		wait( RandomFloatRange( 0.5, 2 ) );
	}
	
	self Kill();
}

vista2_technical_prethink()
{
	trigger_wait_targetname( "trig_vista2_truckstart" );
	thread vista2_technical();
}

vista2_technical()
{
	arr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 3 );
	technical = arr[ 0 ];
	ASSERT( IsDefined( technical ) );
	
	technical thread radiotower_technical_setup();
}

vista2_endhouse_jumpthru()
{
	trigger_wait_targetname( "trig_vista2_endhouse_clearout" );
	
	vol = GetEnt( "vista2_endhouse_goalvolume", "targetname" );
	ais = GetAiArray( "axis" );
	guys = [];
	foreach( guy in ais )
	{
		if( guy IsTouching( vol ) )
		{
			guys[ guys.size ] = guy;
		}
	}
	
	if( !guys.size )
	{
		// he's dead already
		return;
	}
	
	// we're only set up to handle one guy in the building right now
	ASSERT( guys.size == 1 );
	
	houseguy = guys[ 0 ];
	
	firespot = GetNode( "node_vista2_endhouse_firespot", "targetname" );
	nadetarget = GetEnt( "org_vista2_endhouse_nadetarget", "targetname" );
	animref = GetStruct( "street_vista2_jumpthru_animref", "targetname" );
	jumperNode = GetNode( "node_vista2_endhouse_windowjumper_target", "targetname" );
	
	nader = level.hero1;
	
	og_weapon = nader.primaryweapon;
	nader thread forceUseWeapon( "m79", "primary" );
	
	og_color = nader get_force_color();
	
	nader set_temp_goalradius( 64 );
	nader ignore_everything();
	nader clear_force_color();
	nader AllowedStances( "stand" );
	
	nader SetGoalNode( firespot );
	nader waittill( "goal" );
	
	if( IsAlive( houseguy ) )
	{
		houseguy magic_bullet_shield();
	
		animref = GetStruct( "street_vista2_jumpthru_animref", "targetname" );
		anime = "traverse_window_M_2_dive";
		
		houseguy.animname = "generic";
		animation = houseguy getanim( anime );
		org = GetStartOrigin( animref.origin, animref.angles, animation );
		ang = GetStartAngles( animref.origin, animref.angles, animation );
		
		houseguy ForceTeleport( org, ang );
		
		nader SetEntityTarget( nadetarget );
		//nader delaycall( 0.5, ::Shoot, 1000, nadetarget.origin );
		wait( 1 );
		nader Shoot( 1.0, nadetarget.origin );
		
		houseguy delaythread( 1.5, ::stop_magic_bullet_shield );
		houseguy delaythread( 2, ::set_allowdeath, true );
		animref thread anim_generic( houseguy, anime );
		//animref anim_generic_gravity( houseguy, anime );
		
		wait( GetAnimLength( animation ) );
	}
	
	if( IsAlive( houseguy ) )
	{
		houseguy SetGoalNode( jumperNode );
	}
	
	nader ClearEntityTarget();
	nader AllowedStances( "stand", "crouch", "prone" );
	nader set_force_color( og_color );
	nader clear_ignore_everything();
	nader restore_goalradius();
	
	nader delaythread( 5, ::forceUseWeapon, og_weapon, "primary" );
}

vista2_firsthalf_enemies_retreat()
{
	moveToVol = GetEnt( "volume_vista2_retreat", "targetname" );
	
	trigger_wait_targetname( "trig_vista2_truckstart" );
	
	ais = get_ai_group_ai( "vista2_firsthalf_enemies" );
	foreach( guy in ais )
	{
		guy SetGoalVolumeAuto( moveToVol );
	}
}

vista2_leftbalcony_enemies_magicgrenade()
{
	level endon( "vista2_leftbalcony_deathflag" );
	flag_wait( "market_advance_1" );
	
	spots = [];
	spots[ 0 ] = ( -1064, 1340, 1254 );
	spots[ 1 ] = ( -1156, 1380, 1254 );
	
	foreach( spot in spots )
	{
		MagicGrenade( "fraggrenade", spot, groundpos( spot ), RandomFloat( 0.25 ) );
	}
}


// --------------
// --- MARKET ---
// --------------
market_dialogue()
{
	thread market_dialogue_chaoticaboves();
	thread market_dialogue_rightshack();
	
	flag_wait( "market_dialogue_start" );
	
	wait( 2 );
	
	// "Squad! Split up and clear the market! Watch your sectors - these guys are everywhere!"
	level.sarge dialogue( "favesc_cmt_splitup" );
	
	flag_set( "market_introdialogue_done" );
}

market_dialogue_chaoticaboves()
{
	trigger_wait_targetname( "trig_market_chaoticaboves_1" );
	
	flag_wait( "market_introdialogue_done" );
	
	// "Contacts above us at 11 o'clock, firing blind!"
	level.hero1 dialogue( "favesc_gst_firingblind" );
}

market_dialogue_rightshack()
{
	trigger_wait_targetname( "trig_market_door1" );
	
	if( !flag( "market_introdialogue_done" ) )
	{
		flag_wait( "market_introdialogue_done" );
	}
	else
	{
		wait( 2 );
	}
	
	// "Tango coming out of the shack on the right!!!"
	level.sarge dialogue( "favesc_cmt_shackonright" );
}

market_kill_extra_redshirts()
{
	trigger_wait_targetname( "trig_market_door1" );
	
	// the hidden reinforcement thread can potentially spawn a new guy later if we're waiting for
	//  the player to not be looking at the spawner, so shut that thread down
	level notify( "kill_hidden_reinforcement_waiting" );
	
	// only want one after this point
	redshirts = get_nonhero_friends();
	
	singleguy = redshirts[ 0 ];
	if( IsDefined( singleguy ) )
	{
		singleguy set_force_color( "p" );
	}
	
	if( redshirts.size > 1 )
	{
		redshirts = array_remove( redshirts, singleguy );
		array_thread( redshirts, ::friend_remove );
		array_thread( redshirts, ::disable_replace_on_death );
		array_thread( redshirts, ::scr_set_health, 1 );
		array_thread( redshirts, ::bloody_death_after_min_delay, 10, 10 );
		
		// in case the player runs fast ahead, failsafe so these guys don't try to move up on the color chains that don't have enough nodes to accomodate them
		trigger_wait_targetname( "trig_market_redshirts_remove_failsafe" );
		redshirts = array_removedead( redshirts );
		array_thread( redshirts, ::disable_ai_color );
	}
}

market_hero1_change_color()
{
	trigger_wait_targetname( "trig_market_redshirts_remove_failsafe" );
	// ghost becomes a blue guy
	level.hero1 set_force_color( "b" );
}

market_door1()
{
	trigger_wait_targetname( "trig_market_door1" );
	
	door1_spawners = GetEntArray( "spawner_market_door_1", "targetname" );
	door1 = GetEnt( "sbmodel_market_door_1", "targetname" );
	door1_physicsRef = GetStruct( "struct_physicsref_market_door1", "targetname" );
	door1_animRef = GetStruct( "struct_animref_market_door1_kick", "targetname" );
	
	door_kick_housespawn( door1_spawners, door1, door1_animRef, door1_physicsRef );
}


// ------------------
// --- MARKET EVAC---
// ------------------
market_evac_dialogue()
{
	flag_wait( "market_evac_insidepath_start" );
	
	battlechatter_off( "allies" );
	
	// "Nikolai! ETA 20 seconds! Be ready for immediate dustoff!"
	level.sarge dialogue( "favesc_cmt_immediatedustoff" );
	
	// "That may not be fast enough! I see more militia closing in on the market!"
	radio_dialogue( "favesc_nkl_notfastenough" );
	
	// "Pick up the pace! Let's go!"
	level.sarge dialogue( "favesc_cmt_pickuppace" );
	
	flag_wait( "market_evac_chopper_incoming" );
	
	// "It's too hot! We will not survive this landing!"
	radio_dialogue( "favesc_nkl_toohot" );
	
	delaythread( 2, ::favesc_waveoff_music );
	// "Nikolai, wave off, wave off! We'll meet you at the secondary LZ instead! Go!"
	level.sarge dialogue( "favesc_cmt_waveoff" );
	
	// "Very well, I will meet you there! Good luck!"
	radio_dialogue( "favesc_nkl_meetyouthere" );
}

spawn_chopper( spawngroup, followPath )
{
	if( !IsDefined( followPath ) )
	{
		followPath = true;
	}
	
	arr = [];
	
	if( followPath )
	{
		arr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( spawngroup );
	}
	else
	{
		arr = maps\_vehicle::scripted_spawn( spawngroup );
	}
	chopper = arr[ 0 ];
	ASSERT( IsDefined( chopper ) );
	
	chopper.health = 2000000;
	Missile_CreateRepulsorEnt( chopper, 1150, 850 );
	
	return chopper;
}

market_evac_chopper()
{
	chopper = spawn_chopper( 4 );
	level.chopper = chopper;
	
	flag_set( "market_chopper_spawned" );
	
	//chopper SetYawSpeed( 45, 20, 45, 0 );
	chopper SetMaxPitchRoll( 30, 40 );
	
	// wait for player to get near the soccer field entrance
	flag_wait( "market_evac_player_near_soccerfield" );
	
	level.chopper Delete();
	
	// new chopper path
	chopper = spawn_chopper( 6, false );
	level.chopper = chopper;
	
	flag_set( "market_evac_chopper_spawned" );
	
	path2start = GetStruct( "struct_market_evac_chopper_path2", "targetname" );
	chopper thread market_evac_chopper_bugout_path( path2start );
}

// jiesang magic
market_evac_chopper_bugout_path( start )
{
	self thread play_sound_on_entity( "scn_favela_escape_heli_land" );
	
	flag_set( "market_evac_chopper_incoming" );
	
	spot2 = GetStruct( start.target, "targetname" );
	spot3 = GetStruct( spot2.target, "targetname" );
	
	spot4 = GetStruct( spot3.target, "targetname" );
	spot5 = GetStruct( spot4.target, "targetname" );
	
	self Vehicle_SetSpeedImmediate( 30 );
	self Vehicle_SetSpeed( 30, 15, 5 );
	self SetVehGoalPos( spot2.origin, 1 );
	self SetMaxPitchRoll( 30, 25 );
	
	self SetNearGoalNotifyDist( 256 );
	self waittill( "near_goal" );
	self SetGoalYaw( spot2.angles[1] );

	self waittill( "goal" );
	wait( 1 );
	
	flag_set( "market_evac_chopper_bugout" );
	
	//self waittill( "goal_yaw" );
	
	self setVehGoalPos( spot3.origin );
	self Vehicle_SetSpeed( 60, 10 );
	self SetNearGoalNotifyDist( 600 );

	self waittill( "near_goal" );
	self setVehGoalPos( spot4.origin );
	
	flag_set( "market_evac_chopper_leaves_scene" );
	
	delaythread( 10, ::market_evac_escape_walla );
	
	self waittill( "near_goal" );
	self setVehGoalPos( spot5.origin );
	
	self waittill( "goal" );
	
	self notify( "death" );
	self Delete();
	
	level.chopper = undefined;
}

market_evac_enemy_foreshadowing()
{
	flag_wait( "market_evac_insidepath_start" );
	
	killflag = "market_evac_ambush_start";
	
	lines = [];
	// "You're going to pay for what you did to my brother, soldier! You hear me?"
	lines[ lines.size ] = "favesc_pe1_youhearme";
	// "Eduardo, call the truck! And bring more grenades! We're going to flush them out of this building!"
	lines[ lines.size ] = "favesc_pe2_callthetruck";
	// "We're going to kill you slowly for what you've done here. Do you hear me?"
	lines[ lines.size ] = "favesc_pe3_killslowly";
	// "Get on the roof of those buildings and go around them!! They can't stop all of us!!"
	lines[ lines.size ] = "favesc_pe3_cantstop";
	// "They have a helicopter!! Bring more rockets!!! We can shoot it down!!"
	lines[ lines.size ] = "favesc_pe2_morerockets";
	// "There is nowhere for you to run!!! We will find you wherever you go!!"
	lines[ lines.size ] = "favesc_pe4_wellfindyou";
	// "If you capture them, keep them alive so we can use the machete!!!"
	lines[ lines.size ] = "favesc_pe1_keepthemalive";
	
	firstWaitMax = 3.5;
	lineWaitMin = 8;
	lineWaitMax = 13;
	
	spots = GetStructArray( "struct_market_evac_foreshadow_dialoguespot", "targetname" );
	playOrg = Spawn( "script_origin", ( 0, 0, 0 ) );
	
	wait( RandomFloat( firstWaitMax ) );
	
	while( !flag( killflag ) )
	{
		lines = array_randomize( lines );
		spots = array_randomize( spots );
		spotIndex = 0;
		
		foreach( line in lines )
		{
			if( flag( killflag ) )
			{
				break;
			}
			
			playOrg.origin = spots[ spotIndex ].origin;
			playOrg PlaySound( line, "sound_done" );
			playOrg waittill( "sound_done" );
			
			if( spotIndex == ( spots.size - 1 ) )
			{
				spotIndex = 0;
			}
			else
			{
				spotIndex++;
			}
			
			wait( RandomFloatRange( lineWaitMin, lineWaitMax ) );
		}
	}
	
	playOrg Delete();
}

market_evac_fakefire_smallarms()
{
	spots = GetStructArray( "market_evac_ambush_rpg_firespot", "targetname" );
	array_thread( spots, ::fakefire_smallarms_spot, "market_evac_chopper_leaves_scene" );
}

fakefire_smallarms_spot( flagname )
{
	if( !IsDefined( flagname ) )
	{
		if( IsDefined( self.script_flag ) )
		{
			flagname = self.script_flag;
		}
	}
	
	if( flagname == "none" )
	{
		return;
	}
	
	ASSERT( IsDefined( flagname ) );
	
	spot = self;
	
	weapons = level.scriptedweapons;
	
	burstShotsMin = 5;
	burstShotsMax = 12;
	
	shotWaitMin = 0.1;
	shotWaitMax = 0.15;
	burstWaitMin = 0.5;
	burstWaitMax = 1;
	
	start = spot.origin;
	
	while( !flag( flagname ) && IsDefined( level.chopper ) )
	{
		weapon = get_random( weapons );
		burstShots = RandomIntRange( 5, 12 );
		
		for( i = 0; i < burstShots; i++ )
		{
			if( !IsDefined( level.chopper ) )
			{
				break;
			}
			
			x = level.chopper.origin[ 0 ] + RandomIntRange( -256, 256 );
			y = level.chopper.origin[ 1 ] + RandomIntRange( -256, 256 );
			z = level.chopper.origin[ 2 ] + RandomIntRange( -256, 0 );
			targetOrigin = ( x, y, z );
			
			angles = VectorToAngles( targetOrigin - start );
			forward = AnglesToForward( angles );
			vec = vector_multiply( forward, 12 );
			end = start + vec;
			
			// make sure we're not going to hit sarge or the player
			trace = BulletTrace( spot.origin, end, true );
			traceEnt = trace[ "entity" ];
			
			if( IsDefined( traceEnt ) )
			{
				if( IsDefined( level.sarge ) )
				{
					if( traceEnt == level.sarge )
					{
						continue;
					}
				}
				
				if( IsPlayer( traceEnt ) )
				{
					continue;
				}
			}
				
			
			MagicBullet( weapon, spot.origin, end );
			
			wait( RandomFloatRange( shotWaitMin, shotWaitMax ) );
		}
		
		wait( RandomFloatRange( burstWaitMin, burstWaitMax ) );
	}
}

market_evac_fakefire_rpgs()
{
	allSpots = GetStructArray( "market_evac_ambush_rpg_firespot", "targetname" );
	
	// the ones with script_start set should go first
	fireSpots = [];
	foreach( spot in allSpots )
	{
		if( IsDefined( spot.script_start ) )
		{
			fireSpots[ fireSpots.size ] = spot;
		}
	}
	
	// bubble sort by script_start so the highest ones go first
	lastIndex = fireSpots.size - 1;
	for( i = 0; i < lastIndex; i++ )  // sort needs to add one to compare so the max is size-1
	{
		for( j = 0; j < lastIndex - i; j++ ) // don't look past the number of previous sorts, since they will be lowest
		{
			if( fireSpots[ j + 1 ].script_start < fireSpots[ j ].script_start )
			{
				temp = fireSpots[ j ];
				fireSpots[ j ] = fireSpots[ j + 1 ];
				fireSpots[ j + 1 ] = temp;
			}
		}
	}
	
	// the rest get randomized and added separately
	allSpots = array_remove_array( allSpots, fireSpots );
	allSpots = array_randomize( allSpots );
	foreach( spot in allSpots )
	{
		fireSpots[ fireSpots.size ] = spot;
	}
	
	foreach( spot in fireSpots )
	{
		/*
		if( player_can_see( spot.origin ) )
		{
			continue;
		}
		*/
			
		target = GetStruct( spot.target, "targetname" );
		MagicBullet( "rpg_straight", spot.origin, target.origin );
			
		wait( RandomFloatRange( 0.8, 1.5 ) );
	}
	
	while( !flag( "market_evac_chopper_leaves_scene" ) && IsDefined( level.chopper ) )
	{
		fireSpots = array_randomize( fireSpots );
		
		foreach( spot in fireSpots )
		{
			if( flag( "market_evac_chopper_leaves_scene" ) || !IsDefined( level.chopper ) )
			{
				break;
			}
			
			if( player_can_see( spot.origin ) )
			{
				wait( 0.05 );
				continue;
			}
			
			target = level.chopper;
			MagicBullet( "rpg_straight", spot.origin, target.origin );
			
			wait( RandomFloatRange( 0.8, 1.5 ) );
		}
	}	
}

// this is to remove the clip that helps AIs get up on buildings in the roof run area during the market evac event
market_evac_remove_helperclip()
{
	clips = level.market_evac_helperClips;
	foreach( clip in clips )
	{
		clip DisconnectPaths();
		clip Delete();
	}
}

market_evac_enemies()
{
	ambushers = GetEntArray( "ai_market_evac_ambusher", "script_noteworthy" );
	array_thread( ambushers, ::add_spawn_function, ::market_evac_enemy_spawnfunc );
	
	wait( 1.5 );
	trigger_activate_targetname( "trig_market_evac_spawn1" );
	
	/*
	spawners_rpgs = GetEntArray( "spawner_market_evac_ambush_rpg", "targetname" );
	rpgers = spawn_group( spawners_rpgs );
	*/
	
	flag_init( "housespawners_done" );
	
	delaythread( 9, ::market_evac_housespawners );
	
	flag_wait( "housespawners_done" );
	wait( 0.05 );
	
	numGuysAliveBeforeContinuing = 2;
	
	while( 1 )
	{
		marketguys = market_evac_get_active_enemies();
		
		guysFound = 0;
		
		foreach( guy in marketguys )
		{
			if( IsAlive( guy ) && !guy doingLongDeath() )
			{
				guysFound++;
			}
		}
		
		if( guysFound <= numGuysAliveBeforeContinuing )
		{
			break;
		}
		else
		{
			wait( 0.1 );
		}
	}
	
	guys = market_evac_get_active_enemies();
	level thread kill_group_over_time( guys, 4 );
	
	flag_set( "market_evac_enemies_depleted" );
}

market_evac_get_active_enemies()
{
	ais = GetAiArray( "axis" );
	ais = array_removedead( ais );
	
	marketguys = [];
	foreach( guy in ais )
	{
		if( IsDefined( guy.script_noteworthy ) && guy.script_noteworthy == "ai_market_evac_ambusher" )
		{
			marketguys[ marketguys.size ] = guy;
		}
	}
	
	return marketguys;
}

market_evac_enemy_spawnfunc()
{
	self endon( "death" );
	
	// make these guys less accurate so the event is easier
	self.baseaccuracy = self.baseaccuracy * 0.35;
	
	if( IsDefined( level.chopper ) )
	{
		self SetEntityTarget( level.chopper, 0.4 );
	}
	
	wait( 15 );
	self playerseek();
}

market_evac_housespawners()
{
	door1_spawners = GetEntArray( "spawner_market_evac_door1", "targetname" );
	door2_spawners = GetEntArray( "spawner_market_evac_door2", "targetname" );
	door3_spawners = GetEntArray( "spawner_market_evac_door3", "targetname" );
	door1 = GetEnt( "sbmodel_market_evac_door1", "targetname" );
	door2 = GetEnt( "sbmodel_market_evac_door2", "targetname" );
	door3 = GetEnt( "sbmodel_market_evac_door3", "targetname" );
	kickRef1 = GetStruct( "struct_animref_market_evac_kick_door1", "targetname" );
	kickRef2 = GetStruct( "struct_animref_market_evac_kick_door2", "targetname" );
	kickRef3 = GetStruct( "struct_animref_market_evac_kick_door3", "targetname" );
	
	thread door_kick_housespawn( door3_spawners, door3, kickRef3 );
	delaythread( 2, ::door_kick_housespawn, door1_spawners, door1, kickRef1 );
	delaythread( 4, ::door_kick_housespawn, door2_spawners, door2, kickRef2 );
	
	wait( 6 );
	flag_set( "housespawners_done" );
}

market_evac_bugplayer()
{
	stopflag = "market_evac_player_on_roof";
	level endon( stopflag );
	
	lines = [];
	// "Roach! Get up here on the rooftops, let's go!"
	lines[ lines.size ] = "favesc_cmt_getuphere";
	// "Roach! Get over here and climb up to the rooftops!"
	lines[ lines.size ] = "favesc_cmt_climbup";
	// "Roach! You can climb up over here!"
	lines[ lines.size ] = "favesc_cmt_climbuphere";
	
	while( !flag( stopflag ) && IsDefined( level.sarge ) )
	{
		lines = array_randomize( lines );
		
		foreach( line in lines )
		{
			while( Distance( level.player.origin, level.sarge.origin ) < 256 )
			{
				wait( 1 );
			}
				
			if( !flag( stopflag ) )
			{
				level.sarge dialogue( line );
				wait( 20 );
			}
		}
	}
}

market_evac_playermantle_watch( zTest )
{
	while( level.player.origin[ 2 ] < zTest )
	{
		wait( 0.05 );
	}
	
	flag_set( "market_evac_player_mantled" );
}

market_evac_playermantle_helper( zTest )
{
	trig = GetEnt( "trig_market_evac_mantlehelper", "targetname" );
	
	NotifyOnCommand( "mantle", "+gostand" );
	NotifyOnCommand( "mantle", "+moveup" );
	
	while( 1 )
	{
		if( level.player IsTouching( trig ) && !level.player CanMantle() && level.player.origin[2] < zTest )
		{
			SetSavedDvar( "hud_forceMantleHint", 1 );
			
			while( level.player IsTouching( trig ) )
			{
				level.player player_mantle_wait( trig );
				level.player ForceMantle();
				SetSavedDvar( "hud_forceMantleHint", 0 );
				
				// wait for mantle to be done
				while( !level.player IsOnGround() )
				{
					wait( 0.05 );
				}
				
				break;
			}
		}
		else
		{
			SetSavedDvar( "hud_forceMantleHint", 0 );
		}
		wait( 0.05 );
	}
}

player_mantle_wait( trig )
{
	self endon( "left_trigger" );
	
	self thread player_left_trigger_notify( trig );
	self waittill( "mantle" );
}

player_left_trigger_notify( trig )
{
	self endon( "mantle" );
	
	while( self IsTouching( trig ) )
	{
		wait( 0.05 );
	}
	
	self notify( "left_trigger" );
}


// ----------------
// --- ROOF RUN ---
// ----------------
roofrun_dialogue()
{
	// "Let's go, let's go!!"
	level.sarge dialogue( "favesc_cmt_letsgoletsgo" );
	
	// "My friend, from up here, it looks like the whole village is trying to kill you!"
	radio_dialogue( "favesc_nkl_wholevillage" );
	
	// "Tell me something I don't know! Just get ready to pick us up at the secondary RV!"
	level.sarge dialogue( "favesc_cmt_pickusup" );
	
	// DEPRECATED - not enough time to use this one
	// "Ok, I will pick you up soon, keep going!"
	//radio_dialogue( "favesc_nkl_keepgoing" );
	
	// "We're running out of rooftop!!!"
	level.hero1 dialogue( "favesc_gst_runoutofroof" );
	// (add after this line so the scr_sound doesn't stomp on the scripted dialogue if the timing works out that way)
	// "Unghh!"
	level.scr_sound[ "freerunner" ][ "favela_escape_bigjump_ghost" ] = "favesc_gst_jumpsfx";
	
	// "We can make it! Go go go!"
	level.sarge dialogue( "favesc_cmt_makeitgogo" );
	// "Uraaa!"
	level.scr_sound[ "freerunner" ][ "favela_escape_bigjump_soap" ] = "favesc_cmt_jumpsfx";
	
	if( !flag( "player_jump_watcher_stop" ) && !flag( "player_fell_normally" ) )
	{
		thread roofrun_nag_dialogue();
	}
}

roofrun_nag_dialogue()
{
	// end when jumping or falling off the roof
	level endon( "player_fell_normally" );
	level endon( "player_jump_watcher_stop" );
	
	nags = [];
	// "C'mon Roach, we're almost at the chopper!"
	nags[ 0 ] = "favesc_cmt_gettochopper";
	// "Roach, what's the holdup, let's go!"
	nags[ 1 ] = "favesc_cmt_whatsholdup";
	// "We've got to get out of here, Roach, come on!"
	nags[ 2 ] = "favesc_cmt_getoutta";
	
	nagIdx = 0;
	minWait = 10000;
	nextTime = -1;
	while( 1 )
	{
		wait( 0.1 );
		
		lowSpeed = false;
		timeForNewLine = false;
		
		vel = level.player GetVelocity();
		// figure out the length of the vector to get the speed (distance from world center = length)
		speed = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
		
		if( speed < 125 )
		{
			lowSpeed = true;
		}
		
		if( GetTime() >= nextTime )
		{
			timeForNewLine = true;
		}
		
		if( !lowSpeed || !timeForNewLine )
		{
			continue;
		}
		
		level.sarge dialogue( nags[ nagIdx ] );
		nextTime = GetTime() + minWait;
		
		nagIdx++;
		if( nagIdx >= nags.size )
		{
			nagIdx = 0;
		}
	}
}

roofrun_waitfor_finish()
{
	while( level.runnersDone < level.friends.size )
	{
		wait( 0.05 );
	}
	
	flag_set( "roofrun_done" );
}

roofrun_player_bigjump()
{
	player = level.player;
	
	jumpstart_trig = GetEnt( "trig_roofrun_player_bigjump_start", "targetname" );
	edgeref = GetStruct( "struct_player_bigjump_edge_reference", "targetname" );
	groundref = GetStruct( "struct_player_recovery_animref", "targetname" );
	
	jumpForward = AnglesToForward( edgeref.angles );
	thread player_jump_watcher();
	
	// takes care of a player who missed the cool animated jump and just fell
	thread player_normalfall_watcher();
	level endon( "player_fell_normally" );
	
	while( 1 )
	{
		breakout = false;
		
		while( level.player IsTouching( jumpstart_trig ) )
		{
			flag_wait( "player_jumping" );
			if( player_leaps( jumpstart_trig, jumpForward, 0.915, true ) )  // 0.925
			{
				breakout = true;
				break;
			}
			wait( 0.05 );
		}
		
		if( breakout )
		{
			break;
		}
		wait( 0.05 );
	}
	
	flag_set( "player_jump_watcher_stop" );
	
	thread favesc_falling_music();
	
	falltrig = GetEnt( "trig_roofrun_playerjump_falltrig", "targetname" );
	falltrig Delete();
	
	flag_set( "roofrun_player_bigjump_start" );
	
	player TakeAllWeapons();
	
	animname = "player_bigjump";
	jump_scene = "jump";
	anime_jump = level.scr_anim[ animname ][ jump_scene ];
	
	// figure out our start point
	// move the edge reference to the player location, this math only works because we are moving it in a cardinal direction
	startpoint = ( edgeref.origin[ 0 ], player.origin[ 1 ], edgeref.origin[ 2 ] );
	startangles = edgeref.angles;
	animstartorigin = GetStartOrigin( startpoint, startangles, anime_jump );
	animstartangles = GetStartAngles( startpoint, startangles, anime_jump );
	
	// spawn our animref spot
	animref = Spawn( "script_origin", startpoint );
	animref.angles = startangles;
	
	// spawn & set up the rig
	player_rig = spawn_anim_model( animname, animstartorigin );
	player_rig.angles = animstartangles;
	player_rig Hide();

	// don't show the rig until after the player has blended into the animation
	thread bigjump_player_blend_to_anim( player_rig );	
	player_rig delaycall( 1.0, ::Show );
	
	// set up the part that falls away
	thread bigjump_roof_anim( player_rig, groundref );
	
	animref thread anim_single_solo( player_rig, jump_scene );
	thread roofrun_player_bigjump_rumble();
	
	// soap tries to catch player
	player_rig waittillmatch( "single anim", "start_soap" );
	
	level.player FreezeControls( true );
	
	level.sarge thread scr_animplaybackrate( 1 );
	
	// if Soap isn't ahead of the player, don't include him in the animation
	if( flag( "roofrun_sarge_bigjumped" ) )
	{
		thread bigjump_slowmo_controls();
		
		flag_set( "bigjump_sargeplayer_interact_start" );
		
		if( IsDefined( level.sarge.animlooporg ) )
		{
			level.sarge.animlooporg notify( "stop_loop" );
		}
		
		animref thread anim_single_solo( level.sarge, "favela_escape_bigjump_soap_reach" );
	}
	
	// level progression
	thread roofrun_player_recovery( player_rig, groundref );
	
	if( flag( "roofrun_sarge_bigjumped" ) )
	{
		level.sarge waittillmatch( "single anim", "end" );
		wait( 1 );
	}
	else
	{
		wait( 5 );
	}
	
	animref Delete();
}

roofrun_player_bigjump_rumble()
{
	wait( 1.25 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	wait( 0.25 );
	endTime = GetTime() + milliseconds( 0.4 );
	while( GetTime() < endTime )
	{
		level.player PlayRumbleOnEntity( "damage_light" );
		wait( 0.115 );
	}
	
	wait( 0.1 );
	
	level.player PlayRumbleOnEntity( "artillery_rumble" );
}

bigjump_slowmo_controls()
{
	wait( 0.5 );
	slowmo_start();
	slowmo_setspeed_slow( 0.3 );  // 0.1 console
	slowmo_setlerptime_in( 0.15 );  // 0.25 console
	slowmo_lerp_in();

	wait( 0.6 );  // 0.7 console

	slowmo_setlerptime_out( 0.15 ); // 0.2 console
	slowmo_lerp_out();
	slowmo_end();
}

player_normalfall_watcher()
{
	level endon( "player_jump_watcher_stop" );
	
	trig = GetEnt( "trig_roofrun_playerjump_falltrig", "targetname" );
	trig waittill( "trigger" );
	trig Delete();
	
	flag_set( "player_fell_normally" );
	
	// alternate level progression
	thread roofrun_player_recovery();
}

roofrun_player_recovery( player_rig, groundref )
{
	// either we got here after the animated jump...
	if( IsDefined( player_rig ) )
	{
		player_rig waittillmatch( "single anim", "blackout" );
	}
	// ...or we fell
	else
	{
		level.player EnableInvulnerability();  // don't die from the fall
		
		while( !level.player IsOnGround() )
		{
			wait( 0.05 );
		}
		
		music_stop();
		
		level.player FreezeControls( true );
		
		level.player DisableInvulnerability();
	}
	
	// rumble for hitting the ground
	level.player PlayRumbleLoopOnEntity( "artillery_rumble" );
	level.player delaycall( 1, ::StopRumble, "artillery_rumble" );
	
	blacktime = 6.5;
	thread bigjump_angrymob( blacktime );
	thread bigjump_dialogue( blacktime );
	thread bigjump_heartbeat( blacktime );
	
	shockfile = "favela_escape_player_recovery";
	level.player Shellshock( shockfile, blacktime + 0.1 );
	
	if( !IsDefined( groundref ) )
	{
		groundref = GetStruct( "struct_player_recovery_animref", "targetname" );
	}
	
	SetSavedDvar( "objectiveHide", 1 );
	
	level thread favesc_finalrun_music();
	black_overlay = maps\_hud_util::create_client_overlay( "black", 0, level.player );
	black_overlay.alpha = 1;
	level.player allowcrouch( false );
	level.player AllowProne( false );
	level.player setstance( "stand" );

	
	flag_set( "player_recovery_blackscreen" );
	
	level.player TakeAllWeapons();
	
	animname = "player_bigjump";
	recover_scene = "recover";
	recover_animation = level.scr_anim[ animname ][ recover_scene ];
	animstartorigin = GetStartOrigin( groundref.origin, groundref.angles, recover_animation );
	animstartangles = GetStartAngles( groundref.origin, groundref.angles, recover_animation );
	
	// if the player fell, we need to set up the rig for the first time
	if( !IsDefined( player_rig ) )
	{
		player_rig = spawn_anim_model( "player_bigjump", animstartorigin );
		player_rig.angles = animstartangles;
		level.player PlayerLinkToBlend( player_rig, "tag_player", 0.05 );
	}
	
	// stop friends from looping anims before deleting them
	foreach( guy in level.friends )
	{
		guy notify( "stop_loop" );
		
		if( IsDefined( guy.animlooporg ) )
		{
			guy.animlooporg notify( "stop_loop" );
		}
	}
	delaythread( 0.05, ::delete_all_friends );
	
	// delete chopper
	chopper = get_vehicle( "veh_chopper_roofrun", "targetname" );
	if( IsDefined( chopper ) )
	{
		chopper Delete();
	}
	
	thread vision_set_fog_changes( "favela_escape_playerfall_recovery", 1 );
	wait( blacktime );
	
	flag_set( "player_bigjump_done" );
	
	groundref thread anim_single_solo( player_rig, recover_scene );
	
	animtime = GetAnimLength( level.scr_anim[ "player_bigjump" ][ "recover" ] );
	thread solorun_recovery_objective_update_flagset( animtime );
	thread player_bigjump_recovery_vfx( animtime, shockfile );
	thread recovery_fov_change();
	
	wait( 0.1 );
	black_overlay FadeOverTime( 1 );
	black_overlay.alpha = 0;
	
	delaythread( ( animtime - 2 ), ::bigjump_save );

	// wait for recovery anim end
	player_rig waittillmatch( "single anim", "end" );
	level.player allowcrouch( true );
	level.player AllowProne( true );
	
	thread vision_set_fog_changes( "favela_escape", 1.5 );
	
	flag_set( "player_recovery_done" );

	black_overlay Destroy();
	
	level.player Unlink();
	level.player FreezeControls( false );
	
	player_rig Delete();
}

solorun_recovery_objective_update_flagset( animTime )
{
	waitTime = animTime * 0.75;
	wait( waitTime );
	flag_set( "solorun_objective_display" );
	SetSavedDvar( "objectiveHide", 0 );
}

recovery_fov_change()
{
	setsaveddvar( "cg_fov", 30 );
	wait( 5 );
	lerp_fov_overtime( 2, 40 );
	//setsaveddvar( "cg_fov", 40 );
	wait( 2.2 );
	//wait( 9.2 );
	lerp_fov_overtime( 2, 65 );
}


bigjump_save()
{
	// we can force save since we are in a known state of goodness and safeness
	SaveGame( "bigjump_recovery", &"AUTOSAVE_AUTOSAVE" );
}

roofrun_modulate_playerspeed( targetEnt )
{
	// these are the distance ranges from the targetEnt that will trigger speed changes
	distMin = 175;
	distMax = 300;
	distCatchup = 425;
	
	// allowed run speed range
	runSpeedMin = 80;
	runSpeedMax = 90;
	runSpeedCatchup = 95;
	
	// allowed sprint multiplier range
	sprintMultMin = 1.2;
	sprintMultMax = 1.4;
	sprintMultCatchup = 1.5;
	
	interval = 0.5;
	
	playerFailDist = 850;
	playerFailDmg = 75;
	
	while( !flag( "roofrun_done" ) )
	{
		distFromTarget = get_dist_to_plane_nearest_player( targetEnt );
		
		println( distFromTarget );
		
		/* do damage if the player is too far back
		if( distFromTarget > playerFailDist )
		{
			forward = AnglesToForward( level.player GetPlayerAngles() );
			backward = vector_multiply( forward, -1 );
			dmgOrigin = level.player.origin + ( 0, 0, 50 );
			dmgOrigin += vector_multiply( backward, 5000 );
			
			level.player DoDamage( playerFailDmg, dmgOrigin );
		}
		*/
		
		// init to something
		targetRunSpeed = runSpeedMax;
		targetSprintMult = sprintMultMax;
		
		// if past max distance, give a speed boost above established maximums
		if( distFromTarget > distCatchup )
		{
			targetRunSpeed = runSpeedCatchup;
			targetSprintMult = sprintMultCatchup;
			println( "CATCHUP" );
		}
		// otherwise scale speed based on how far away the player is
		else
		{
			fraction = get_fraction( distFromTarget, distMin, distMax );
			
			runRange = runSpeedMax - runSpeedMin;  // figure out the range of values that we will use to modify the max value
			runRangeFrac = runRange * ( 1 - fraction );  // figure out where in the range the fraction puts us
			targetRunSpeed = runSpeedMax - runRangeFrac;  // modify the max speed by the fractional range value
			
			sprintRange = sprintMultMax - sprintMultMin;
			sprintRangeFrac = sprintRange * ( 1 - fraction );
			targetSprintMult = sprintMultMax - sprintRangeFrac;
			
			if( distFromTarget >= distMax )
			{
				println( "MAX" );
			}
			else if( distFromTarget <= distMin )
			{
				println( "MIN" );
			}
		}
		
		player_speed_percent( targetRunSpeed, interval );
		player_sprint_multiplier_blend( targetSprintMult, interval );
		
		wait( interval );
	}
}

get_dist_to_plane_nearest_player( ent )
{
	P = level.player.origin;
	A = ent.origin + ( AnglesToRight( ent.angles ) * -5000 );
	B = ent.origin + ( AnglesToRight( ent.angles ) * 5000 );
	
	nearestOrigin = PointOnSegmentNearestToPoint( A, B, P );
	return Distance( P, nearestOrigin );
}

get_fraction( value, min, max )
{
	if( value >= max )
	{
		return 1.0;
	}
	
	if( value <= min )
	{
		return 0.0;
	}

	
	fraction = ( value - min ) / ( max - min );
	fraction = cap_value( fraction, 0.0, 1.0 );
	return fraction;
}

player_sprint_multiplier_blend( goal, time )
{
	curr = GetDvarFloat( "player_sprintSpeedScale" );
	
	if ( IsDefined( time ) )
	{
		range = goal - curr;
		interval = .05;
		numcycles = time / interval;
		fraction = range / numcycles;

		while ( abs( goal - curr ) > abs( fraction * 1.1 ) )
		{
			curr += fraction;
			SetSavedDvar( "player_sprintSpeedScale", curr );
			wait interval;
		}
	}

	SetSavedDvar( "player_sprintSpeedScale", goal );
}

roofrun_sarge( skipToBigJump )
{
	self endon( "death" );
	
	self ent_flag_wait( "roofrun_start" );
	
	if( !IsDefined( skipToBigJump ) )
	{
		skipToBigJump = false;
	}
	
	self set_generic_run_anim( "freerunnerA_run" );
	
	if( !skipToBigJump )
	{
		animref = GetStruct( "roofrun_jump1", "targetname" );
		anime = "freerunnerA_right";
		animref anim_reach_solo( self, anime );
		animref anim_single_run_solo( self, anime );
		
		self roofrun_friendly_setup();
		
		// wait for player if necessary
		struct = GetStruct( "roofrun_sarge_waitforplayer", "targetname" );
		self SetGoalPos( struct.origin );
		self waittill( "goal" );
	}
	else
	{
		// we've already teleported him, just set him up
		self roofrun_friendly_setup();
	}
	
	// a trigger sets this flag
	flag_wait( "player_near_bigjump" );
	
	// big jump
	animref = GetStruct( "roofrun_bigjump3", "targetname" );
	temp = Spawn( "script_origin", animref.origin );
	temp.angles = animref.angles;
	animref = temp;
	
	
	self.anim_bigjump_org = animref;
	anime = "favela_escape_bigjump_soap";
	animref anim_reach_solo( self, anime );
	self PushPlayer( false );
	
	if( !flag( "roofrun_player_bigjump_start" ) )
	{
		flag_set( "roofrun_sarge_bigjumped" );
		
		animref anim_single_solo( self, anime );
		self SetGoalPos( self.origin );
		
		if( !flag( "bigjump_sargeplayer_interact_start" ) )
		{
			anime = "favela_escape_bigjump_soap_loop";
			self.animlooporg = animref;
			animref thread anim_loop_solo( self, anime, "stop_loop" );
		}
	}
	
	level.runnersDone++;
}

roofrun_hero1( skipToBigJump )
{
	self endon( "death" );
	
	animref = GetStruct( "roofrun_jump2", "targetname" );
	anime = "roofrun_laundry_2";
	sheet = GetEnt( "smodel_roofrun_sheet_right", "targetname" );
	self thread sheet_roofrun_animate( animref, sheet, anime );
	
	self ent_flag_wait( "roofrun_start" );
	
	if( !IsDefined( skipToBigJump ) )
	{
		skipToBigJump = false;
	}
	
	self set_generic_run_anim( "freerunnerB_run" );
	
	if( !skipToBigJump )
	{
		anime = "freerunnerB_mid";
		animref anim_reach_solo( self, anime );
		animref anim_single_run_solo( self, anime );
	}
	
	self roofrun_friendly_setup();
	
	// big jump
	animref = GetStruct( "roofrun_bigjump1", "targetname" );
	anime = "favela_escape_bigjump_ghost";
	if( !skipToBigJump )
	{
		animref anim_reach_solo( self, anime );
	}
	
	self PushPlayer( false );
	animref anim_single_run_solo( self, anime );
	
	self.animlooporg = animref;
	anime = "favela_escape_bigjump_ghost_loop";
	animref thread anim_loop_solo( self, anime, "stop_loop" );
	
	level.runnersDone++;
}

roofrun_redshirt( skipToBigJump )
{
	self endon( "death" );
	
	animref = GetStruct( "roofrun_jump2", "targetname" );
	anime = "roofrun_laundry_1";
	sheet = GetEnt( "smodel_roofrun_sheet_left", "targetname" );
	
	self thread sheet_roofrun_animate( animref, sheet, anime );
	
	self ent_flag_wait( "roofrun_start" );
	
	if( !IsDefined( skipToBigJump ) )
	{
		skipToBigJump = false;
	}
	
	self set_generic_run_anim( "freerunnerA_run" );
	
	if( !skipToBigJump )
	{
		anime = "freerunnerA_left";
		animref anim_reach_solo( self, anime );
		animref anim_single_run_solo( self, anime );
	}
	
	self roofrun_friendly_setup();
	
	// (he automatically runs across the little bridge to reach to the big jump)
	// big jump
	animref = GetStruct( "roofrun_bigjump2", "targetname" );
	anime = "favela_escape_bigjump_faust";
	if( !skipToBigJump )
	{
		animref anim_reach_solo( self, anime );
	}
	self PushPlayer( false );
	animref anim_single_run_solo( self, anime );
	
	self.animlooporg = animref;
	anime = "favela_escape_bigjump_faust_loop";
	animref thread anim_loop_solo( self, anime, "stop_loop" );
	
	level.runnersDone++;
}

// self = the guy running and pushing the sheet out of the way
sheet_roofrun_animate( animref, og_sheet, anime )
{
	sheet = spawn_anim_model( "laundry", og_sheet.origin );
	sheet.angles = og_sheet.angles;
	og_sheet Delete();
	
	animref thread anim_first_frame_solo( sheet, anime );
	
	self waittillmatch( "single anim", "start_laundry" );
	animref anim_single_solo( sheet, anime );
}

roofrun_friendly_generic()
{
	self roofrun_friendly_setup();
	
	self waittill( "roofrun_reset" );
	self restore_goalradius();
	
	self SetGoalPos( self.origin );
	
	self roofrun_friendly_cleanup();
}

roofrun_friendly_setup()
{
	self PushPlayer( true );
	self disable_cqbwalk();
	self.dontavoidplayer = true;
	self.disablearrivals = true;
	self.disableexits = true;
	self.usechokepoints = false;
	
	self ignore_everything();
	self set_temp_goalradius( 32 );
	
	self scr_moveplaybackrate( 1 );
	
	if( !IsDefined( self.roofrunStoredVals ) )
	{
		self.og_walkDistFacingMotion = self.walkDistFacingMotion;
	}
	self.walkDistFacingMotion = 0;
	
	if( !IsDefined( self.roofrunStoredVals ) )
	{
		self.og_maxsightdistsqrd = self.maxsightdistsqrd;
	}
	self.maxsightdistsqrd = 0;
	
	if( !IsDefined( self.roofrunStoredVals ) )
	{
		self.og_pathRandomPercent = self.pathRandomPercent;
	}
	self.pathRandomPercent = 0;
	
	if( !IsDefined( self.roofrunStoredVals ) )
	{
		self.og_animname = self.animname;
	}
	self.animname = "freerunner";
	
	self.roofrunStoredVals = true;
}

roofrun_friendly_cleanup()
{
	self notify( "roofrun_friendly_cleanup" );
	
	self.moveplaybackrate = 1;
	self.animplaybackrate = 1;
	self.moveTransitionRate = 1;
	
	self PushPlayer( false );
	self.dontavoidplayer = false;
	self.disablearrivals = false;
	self.disableexits = false;
	self.usechokepoints = true;
	
	self.walkDistFacingMotion = self.og_walkDistFacingMotion;
	
	self clear_ignore_everything();
	self restore_goalradius();
	
	self.maxsightdistsqrd = self.og_maxsightdistsqrd;
	self.pathRandomPercent = self.og_pathRandomPercent;
	
	self.animname = self.og_animname;
}

player_leaps( trig, jump_forward, goodDot, checkIsOnGround )
{
	if( !IsDefined( goodDot ) )
	{
		goodDot = 0.965;
	}
	
	if( !IsDefined( checkIsOnGround ) )
	{
		checkIsOnGround = true;
	}
	
	if( !level.player IsTouching( trig ) )
	{
		return false;
	}
	
	if ( level.player GetStance() != "stand" )
	{
		return false;
	}
	
	if( checkIsOnGround && level.player IsOnGround() )
	{
		return false;
	}

	// gotta jump straight
	player_angles = level.player GetPlayerAngles();
	player_angles = ( 0, player_angles[ 1 ], 0 );
	player_forward = anglestoforward( player_angles );
	dot = vectordot( player_forward, jump_forward );
	if ( dot < goodDot )
	{
		return false;
	}

	vel = level.player GetVelocity();
	// figure out the length of the vector to get the speed (distance from world center = length)
	velocity = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
	if ( velocity < 162 )
	{
		return false;
	}

	//level.player setVelocity( ( vel[ 0 ] * 1.5, vel[ 1 ] * 1.5, vel[ 2 ] ) );
	return true;
}

bigjump_roof_anim( player_rig, animref )
{
	roof = bigjump_roof_setup();
	
	roof_rig = spawn_anim_model( "roof_rig" );
	roof_rig Hide();
	scene = "breakaway";
	roofanim = level.scr_anim[ roof_rig.animname ][ scene ];
	roof_rig.origin = GetStartOrigin( animref.origin, animref.angles, roofanim );
	roof_rig.angles = GetStartAngles( animref.origin, animref.angles, roofanim );
	roof LinkTo( roof_rig, "J_Roof_01" );
	
	player_rig waittillmatch( "single anim", "start_roof_collapse" );
	animref anim_single_solo( roof_rig, scene );
}

bigjump_roof_setup()
{
	ents = GetEntArray( "roof_fall", "targetname" );
	// find the sbmodel
	sbmodel = undefined;
	
	foreach( ent in ents )
	{
		if( ent.code_classname == "script_brushmodel" )
		{
			sbmodel = ent;
			break;
		}
	}
	
	ASSERT( IsDefined( sbmodel ) );
	
	ents = array_remove( ents, sbmodel );
	
	// link everything else to the sbmodel
	foreach( ent in ents )
	{
		ent LinkTo( sbmodel );
	}
	
	return sbmodel;
}

bigjump_player_blend_to_anim( player_rig )
{
	wait( 0.3 );
//	Print3d( level.player.origin, "x", (1,1,1), 1, 2, 500 );
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.6, 0.2, 0.4 );
}

player_bigjump_recovery_vfx( animtime, shockfile )
{
	shocktime = animtime * 0.75;
	endtime = GetTime() + milliseconds( shocktime );
	
	level.player Shellshock( shockfile, shocktime + 1.5 );
	
	//blurHigh = 0.6;
	//blurLow = 0.2;
	blurHigh = 4.5;
	blurLow = 2;
	blurTransTime = 0.5;
	waitMin = 0.75;
	waitMax = 1.25;
	while( GetTime() < endtime )
	{
		SetBlur( blurHigh, blurTransTime );
		wait( RandomFloatRange( waitMin, waitMax ) );
		SetBlur( blurLow, blurTransTime );
		wait( RandomFloatRange( waitMin, waitMax ) );
	}
	
	SetBlur( 0, .5 );
	
	/*-----------------------
	LOOK AT HANDS, BG BLURS
	-------------------------
	dof_see_hands = [];          
	dof_see_hands[ "nearStart" ] = 0;
	dof_see_hands[ "nearEnd" ] = 0;
	dof_see_hands[ "nearBlur" ] = 6;
	dof_see_hands[ "farStart" ] = 30;
	dof_see_hands[ "farEnd" ] = 70;
	dof_see_hands[ "farBlur" ] = 2.5;
	thread blend_dof( dof_start, dof_see_hands, 3 );
	SetBlur( 0, 3 );
	

	flag_wait( "notetrack_player_lowerhands" );
	/*-----------------------
	DROP HANDS, BG COMES INTO FOCUS
	-------------------------
	dof_see_dudes = [];          
	dof_see_dudes[ "nearStart" ] = 4.7;
	dof_see_dudes[ "nearEnd" ] = 56;
	dof_see_dudes[ "nearBlur" ] = 6;
	dof_see_dudes[ "farStart" ] = 1000;
	dof_see_dudes[ "farEnd" ] = 7000;
	dof_see_dudes[ "farBlur" ] = 0;
	//thread blend_dof( dof_see_hands, dof_see_dudes, 5 );
	thread blend_dof( dof_see_hands, dof_start, 6 );
	*/
}

bigjump_heartbeat( waitTime )
{
	//wait( waitTime );
	
	beatTime = 1.5;
	
	endTime = GetTime() + milliseconds( waitTime );
	while( GetTime() < endTime )
	{
		play_sound_in_space( "breathing_heartbeat", level.player.origin );
		
		if( GetTime() < endTime )
		{
			wait( beatTime );
		}
	}
	
	beatTime = 1;
	
	play_sound_in_space( "breathing_hurt_start", level.player.origin, true );
	wait( beatTime );
	
	tracker = 0;
	
	while( !flag( "player_recovery_done" ) )
	{
		alias = "breathing_hurt";
		
		// just do a regular heartbeat on odd numbered beats
		if( tracker % 2 != 0 )
		{
			alias = "breathing_heartbeat";
		}
		
		play_sound_in_space( alias, level.player.origin, true );
		
		tracker++;
		wait( beatTime );
	}
	
	play_sound_in_space( "breathing_better", level.player.origin, true );
}

bigjump_dialogue( waitTime )
{
	wait( 5.5 );
	
	// "Roach!!! Roach!!! Wake up!!!"
	radio_dialogue( "favesc_cmt_wakeup" );
	
	wait( 0.5 );
	
	// "Roach! We can see them from the chopper! They're coming for you, dozens of 'em!!!"
	radio_dialogue( "favesc_gst_comingforyou" );
	
	wait( 0.5 );
	
	// "Roach! There's too many of them! Get the hell out of there and find a way to the rooftops! Move!"
	thread radio_dialogue( "favesc_cmt_toomany" );
}

bigjump_angrymob( waitTime )
{
	if( IsDefined( waitTime ) )
	{
		wait( waitTime );
	}
	
	// wallas
	thread bigjump_recovery_rightside_walla();
	thread bigjump_recovery_leftside_walla();
	
	// -- ground mob on right --
	thread bigjump_angrymob_right_ground();
	
	// -- rooftop guys on left --
	delaythread( 3.5, ::bigjump_angrymob_left_roof );
	
	// -- ground mob on left --
	delaythread( 7.75, ::bigjump_angrymob_left_ground );
}

bigjump_angrymob_left_roof()
{
	wait( 1 );
	
	animref_center = GetStruct( "struct_mob_roof_2", "targetname" );
	animref_left = GetStruct( "struct_mob_roof_1", "targetname" );
	animref_right = GetStruct( "struct_mob_roof_3", "targetname" );
	roofspawners = GetEntArray( "spawner_mob_left_roof", "targetname" );
	
	roofguys = spawn_group( roofspawners, true, false );
	ASSERT( roofguys.size == 4 );
	
	roofguys[ 0 ].animref = animref_center;
	roofguys[ 0 ].anime = "favela_escape_rooftop_mob1";
	roofguys[ 1 ].animref = animref_center;
	roofguys[ 1 ].anime = "favela_escape_rooftop_mob2";
	roofguys[ 2 ].animref = animref_right;
	roofguys[ 2 ].anime = "favela_escape_rooftop_mob4";
	roofguys[ 3 ].animref = animref_left;
	roofguys[ 3 ].anime = "favela_escape_rooftop_mob3";
	
	array_thread( roofguys, ::bigjump_angrymob_roofguy );
}

bigjump_angrymob_left_ground()
{
	animref = GetEnt( "animref_mob_left", "targetname" );
	spawners = GetEntArray( "spawner_mob_left", "targetname" );
	
	anims = [];
	anims[ anims.size ] = "mob_left_A";
	anims[ anims.size ] = "mob_left_B";
	anims[ anims.size ] = "mob_left_C";
	anims[ anims.size ] = "mob_left_D";
	
	guys = spawn_group( spawners, true, false );
	ASSERT( guys.size == anims.size );
	
	foreach( index, guy in guys )
	{
		guy.ignoreall = true;
		guy.ignoreme = true;
		
		scene = anims[ index ];
		anime = level.scr_anim[ "generic" ][ scene ];
		
		animref thread anim_generic_gravity( guy, scene );
		guy thread angrymob_animdone_think( anime, animref );
	}
}

bigjump_angrymob_right_ground()
{
	animref = GetEnt( "animref_mob_right", "targetname" );
	spawners = GetEntArray( "spawner_mob_right", "targetname" );
	
	anims = [];
	anims[ anims.size ] = "mob2_arc_A";
	anims[ anims.size ] = "mob2_arc_B";
	anims[ anims.size ] = "mob3_arc_C";
	anims[ anims.size ] = "mob2_arc_D";
	anims[ anims.size ] = "mob2_arc_E";
	anims[ anims.size ] = "mob2_arc_F";
	anims[ anims.size ] = "mob2_arc_G";
	anims[ anims.size ] = "mob2_arc_H";
	
	guys = spawn_group( spawners, true, false );
	ASSERT( guys.size == anims.size );
	
	foreach( index, guy in guys )
	{
		guy.ignoreall = true;
		guy.ignoreme = true;
		
		scene = anims[ index ];
		anime = level.scr_anim[ "generic" ][ scene ];
		
		animref thread anim_generic_gravity( guy, scene );
		guy thread angrymob_animdone_think( anime, animref );
	}
}

bigjump_angrymob_roofguy()
{
	self.ignoreall = true;
	self.ignoreme = true;
		
	self.animref anim_generic( self, self.anime );
	
	self SetGoalPos( self.origin );
}

angrymob_animdone_think( anime, animref )
{
	animtime = GetAnimLength( anime );
	endTime = GetTime() + milliseconds( animtime );
	level waittill_any_timeout( animtime, "solorun_mob_start_shooting" );
	
	if( GetTime() < endTime )
	{
		self StopAnimScripted();
	}
	
	if( !flag( "solorun_mob_start_shooting" ) )
	{
		self set_generic_run_anim( "intro_casual_walk", true );
		self.angrymob_newrunanim = true;
	}
	
	self.goalradius = 512;
	self SetGoalEntity( level.player );
	
	flag_wait( "solorun_mob_start_shooting" );
	
	/*
	if( IsDefined( animref ) )
	{
		animref anim_stopanimscripted();
	}
	*/
	self notify( "stop_animmode" );
	//self anim_stopanimscripted();

	if( IsDefined( self.angrymob_newrunanim ) )
	{
		self clear_run_anim();
	}

	self.ignoreall = false;
}


// ----------------
// --- SOLO RUN ---
// ----------------
solorun_chaser_spawnfunc()
{
	if( !IsDefined( level.chasers ) )
	{
		level.chasers = [];
	}
	
	level.chasers[ level.chasers.size ] = self;
}

solorun_chasers_remove()
{
	flag_wait( "solorun_player_off_balcony" );
	
	if( !IsDefined( level.chasers ) )
	{
		return;
	}
	
	level.chasers = array_removedead( level.chasers );
	level.chasers = array_removeundefined( level.chasers );
	
	array_thread( level.chasers, ::solorun_chaser_remove );
}

dont_shoot_player_in_back()
{
	self endon( "death" );
	level.player endon( "death" );
	
	// don't fire at the player while he's not looking
	while( 1 )
	{
		playerangles = level.player GetPlayerAngles();
		player_forward = AnglesToForward( playerangles );
		vec = VectorNormalize( self.origin - level.player GetEye() );
		anglesFromPlayer = VectorToAngles( vec );
		forward_to_self = AnglesToForward( anglesFromPlayer );
	
		dot = vectordot( player_forward, forward_to_self );
		
		// in view of the player
		if( dot > 0.75 || flag( "solorun_player_progression_stalled" ) )
		{
			if( IsDefined( self.dontEverShoot ) )
			{
				self.dontEverShoot = undefined;
			}
		}
		// not in view
		else
		{
			if( !IsDefined( self.dontEverShoot ) )
			{
				self.dontEverShoot = true;
			}
		}
		
		wait( 0.05 );
	}
}

solorun_chaser_remove()
{
	self endon( "death" );
	
	while( player_can_see_ai( self ) )
	{
		wait( 0.1 );
	}
	
	self Delete();
}

solorun_timer_prethink()
{
	dvar = GetDvarInt( "timer_off" );
	if( IsDefined( dvar ) && dvar > 0 )
	{
		return;
	}
	
	flag_wait( "solorun_timer_start" );
	timerTime = 30;
	timerLoc = &"FAVELA_ESCAPE_CHOPPER_TIMER";
	thread solorun_timer( timerTime, timerLoc, true );
	
	thread solorun_timer_extend_when_close( timerTime, timerLoc );
	
	flag_wait( "chopperjump_player_jump" );
	level notify( "kill_timer" );
	level.timer destroy();
}

solorun_timer_extend_when_close( timerTime, timerLoc )
{
	if( level.gameskill == 3 )
	{
		// player gets no help on veteran
		return;
	}
	
	flag_wait( "trig_solorun_player_on_slide" );
	
	// if timer is less than 10 seconds, reset to 10 seconds
	extraTime = 10.5;
	elapsedTime = seconds( GetTime() - level.start_time );	
	if( timerTime - elapsedTime < extraTime )
	{
		thread solorun_timer( extraTime, timerLoc, true );
	}
	
	thread autosave_by_name( "chopperjump" );
}

solorun_timer( iSeconds, sLabel, bUseTick )
{
	if ( getdvar( "notimer" ) == "1" )
		return;

	if ( !isdefined( bUseTick ) )
		bUseTick = false;
	// destroy any previous timer just in case
	killTimer();
	level endon( "kill_timer" );

	// -- timer setup --	
	level.hudTimerIndex = 20;
	level.timer = maps\_hud_util::get_countdown_hud( -250 );
	level.timer SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.timer.label = sLabel;
	level.timer settenthstimer( iSeconds );
	level.start_time = gettime();

	// -- timer expired --
	if ( bUseTick == true )
		thread timer_tick();
	wait( iSeconds );

	flag_set( "timer_expired" );
	level.timer destroy();
	// Mission failed. The objective was not completed in time.
	level thread solorun_timer_expired();
}

timer_tick()
{
	level endon( "stop_timer_tick" );
	level endon( "kill_timer" );
	while ( true )
	{
		wait( 1 );
		level.player thread play_sound_on_entity( "countdown_beep" );
		level notify( "timer_tick" );
	}
}

solorun_timer_expired()
{
	deadquote = &"FAVELA_ESCAPE_CHOPPER_TIMER_EXPIRED";
	level.player endon( "death" );
	level endon( "kill_timer" );
	level notify( "mission failed" );
	level.player FreezeControls( true );
	
	setDvar( "ui_deadquote", deadquote );
	maps\_utility::missionFailedWrapper();
	level notify( "kill_timer" );
}

killTimer()
{
	level notify( "kill_timer" );
	
	if ( IsDefined( level.timer ) )
	{
		level.timer Destroy();
	}
}

solorun_start_playerfail( timeout )
{
	level endon( "solorun_player_off_balcony" );
	
	// "Run for it!!! Get to the rooftops!!"
	thread radio_dialogue( "favesc_cmt_runforit" );
	
	xTest = -6074;
	zTest = 900;
	trig = GetEnt( "trig_solorun_start_playersafezone", "targetname" );
	maxhealth = level.player.maxhealth;
	
	thread solorun_start_playerfail_timeout( timeout );
	thread solorun_player_leaves_trigger( trig );
	
	while( 1 )
	{
		if( solorun_start_playerfail_should_damage( xTest, trig, "solorun_mob_start_shooting" ) )
		{
			dmgspot = level.player.origin;
				
			axis = GetAiArray( "axis" );
			if( axis.size )
			{
				guy = get_random( axis );
				dmgspot = guy.origin;
			}
			level.player DoDamage( maxhealth * 0.25, dmgspot );
			
			if( !flag( "solorun_mob_start_shooting" ) )
			{
				flag_set( "solorun_mob_start_shooting" );
			}
		}
		
		wait( 0.5 );
	}
}

solorun_start_playerfail_should_damage( xTest, trig, flagname )
{
	if( level.player.origin[ 0 ] < xTest && !level.player IsTouching( trig ) )
	{
		return true;
	}
	
	if( level.player IsTouching( trig ) && flag( flagname ) )
	{
		return true;
	}
	
	return false;
}

solorun_start_playerfail_timeout( timeout )
{
	level endon( "solorun_mob_start_shooting" );
	wait( timeout );
	flag_set( "solorun_mob_start_shooting" );
}

solorun_player_leaves_trigger( trig )
{
	level endon( "solorun_mob_start_shooting" );
	
	while( 1 )
	{
		trig waittill( "trigger", other );
		if( IsPlayer( other ) )
		{
			break;
		}
		wait( 0.05 );
	}
	
	while( level.player IsTouching( trig ) )
	{
		wait( 0.05 );
	}
	
	flag_set( "solorun_mob_start_shooting" );
}

solorun_civilian_doorshut()
{
	trig = GetEnt( "trig_solorun_civilian_doorshut", "targetname" );
	spawner = GetEnt( trig.target, "targetname" );
	animref = GetStruct( "struct_solorun_civilian_doorshut_animref", "targetname" );
	
	door = spawn_anim_model( "civ_door" );
	guy = spawner spawn_ai();
	guy.animname = "default_civilian";
	guy.ignoreme = true;
	guy ignore_everything();
	guy thread magic_bullet_shield();
	
	ents[ 0 ] = door;
	ents[ 1 ] = guy;
	
	animref thread anim_loop( ents, "run_and_slam_idle", "stop_loop" );
	
	trig waittill( "trigger" );
	
	door notify( "stop_loop" );
	guy notify( "stop_loop" );
	
	animref anim_single( ents, "run_and_slam" );
	
	guy SetGoalPos( guy.origin );
	
	// idle at end
	guy thread anim_loop_solo( guy, "run_and_slam_endidle", "stop_loop" );
	
	flag_wait( "solorun_player_at_balcony" );
	guy stop_magic_bullet_shield();
	guy notify( "stop_loop" );
	wait( 0.05 );
	guy Delete();
}

rooftop_slide_exploder()
{
	flag_wait( "trig_solorun_player_on_slide" );
	exploder( "roof_slide" );
}

rooftop_slide_glassbreak()
{
	trigger_wait_targetname( "trig_end_glass_break" );
	level notify( "glass_break", level.player );
	
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	thread play_sound_in_space( "scn_favela_escape_player_window", level.player.origin );
}

rooftop_slide_deleteaxis()
{
	trigger_wait_targetname( "trig_end_glass_break" );
	axis = GetAiArray( "axis" );
	array_call( axis, ::Delete );
}

solorun_player_difficulty_adjustment()
{
	movingVelocity = 170;
	easySettings = false;
	
	earlySuperHardSettings = false;
	
	safeZoneTrig = GetEnt( "trig_solorun_start_playersafezone", "targetname" );
	
	while( 1 )
	{
		// first make sure he's not running around outside the solorun start area
		if( flag( "solorun_player_outside_first_house" ) && !level.player IsTouching( safeZoneTrig ) && !earlySuperHardSettings )
		{
			earlySuperHardSettings = true;
			
			level.player.noPlayerInvul = true;
			set_custom_gameskill_func( ::solorun_superhard_gameskill_settings );
		}
		else if( ( !flag( "solorun_player_outside_first_house" ) || level.player IsTouching( safeZoneTrig ) ) && earlySuperHardSettings )
		{
			// this resets settings that don't get set to new values when the player is away from the starting area
			earlySuperHardSettings = false;
			
			level.player.noPlayerInvul = undefined;
			set_custom_gameskill_func( ::solorun_reset_gameskill_settings );
		}
		
		vel = level.player GetVelocity();
		velocity = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
		
		// easier when player is moving
		if( velocity >= movingVelocity && !easySettings )
		{
			easySettings = true;
			
			set_custom_gameskill_func( ::solorun_fastmoving_gameskill_settings );
		}
		else if( velocity < movingVelocity && easySettings )
		{
			easySettings = false;
			
			set_custom_gameskill_func( ::solorun_slowmoving_gameskill_settings );
		}
		
		wait( 0.5 );
	}
}

solorun_superhard_gameskill_settings()
{
	level.difficultySettings[ "playerDifficultyHealth" ][ "easy" ]		= 100;
	level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ]	= 100;
	level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ]	= 100;
	level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ]	= 100;
	
	level.difficultySettings[ "longRegenTime" ][ "easy" ]		= 20000;
	level.difficultySettings[ "longRegenTime" ][ "normal" ]		= 20000;
	level.difficultySettings[ "longRegenTime" ][ "hardened" ]	= 20000;
	level.difficultySettings[ "longRegenTime" ][ "veteran" ]	= 20000;
	
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "easy" ]		= 0;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ]		= 0;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ]	= 0;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ]		= 0;
	
	level.difficultySettings[ "base_enemy_accuracy" ][ "easy" ]		= 50000;
	level.difficultySettings[ "base_enemy_accuracy" ][ "normal" ]	= 50000;
	level.difficultySettings[ "base_enemy_accuracy" ][ "hardened" ]	= 50000;
	level.difficultySettings[ "base_enemy_accuracy" ][ "veteran" ]	= 50000;
	
	level.difficultySettings[ "invulTime_preShield" ][ "easy" ]		= 0;
	level.difficultySettings[ "invulTime_preShield" ][ "normal" ]	= 0;
	level.difficultySettings[ "invulTime_preShield" ][ "hardened" ]	= 0;
	level.difficultySettings[ "invulTime_preShield" ][ "veteran" ]	= 0;
	
	level.difficultySettings[ "invulTime_onShield" ][ "easy" ]		= 0;
	level.difficultySettings[ "invulTime_onShield" ][ "normal" ]	= 0;
	level.difficultySettings[ "invulTime_onShield" ][ "hardened" ]	= 0;
	level.difficultySettings[ "invulTime_onShield" ][ "veteran" ]	= 0;
	
	level.difficultySettings[ "invulTime_postShield" ][ "easy" ]		= 0;
	level.difficultySettings[ "invulTime_postShield" ][ "normal" ]		= 0;
	level.difficultySettings[ "invulTime_postShield" ][ "hardened" ]	= 0;
	level.difficultySettings[ "invulTime_postShield" ][ "veteran" ]		= 0;
}

solorun_reset_gameskill_settings()
{
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "easy" ]		= 4000;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ]		= 2500;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ]	= 600;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ]		= 100;
		
	level.difficultySettings[ "base_enemy_accuracy" ][ "easy" ]		= 0.9;
	level.difficultySettings[ "base_enemy_accuracy" ][ "normal" ]	= 1.0;
	level.difficultySettings[ "base_enemy_accuracy" ][ "hardened" ]	= 1.15;
	level.difficultySettings[ "base_enemy_accuracy" ][ "veteran" ]	= 1.15;
		
	level.difficultySettings[ "invulTime_preShield" ][ "easy" ]		= 0.6;
	level.difficultySettings[ "invulTime_preShield" ][ "normal" ]	= 0.5;
	level.difficultySettings[ "invulTime_preShield" ][ "hardened" ]	= 0.3;
	level.difficultySettings[ "invulTime_preShield" ][ "veteran" ]	= 0.0;
		
	level.difficultySettings[ "invulTime_onShield" ][ "easy" ]		= 1.6;
	level.difficultySettings[ "invulTime_onShield" ][ "normal" ]	= 1.0;
	level.difficultySettings[ "invulTime_onShield" ][ "hardened" ]	= 0.5;
	level.difficultySettings[ "invulTime_onShield" ][ "veteran" ]	= 0.25;
		
	level.difficultySettings[ "invulTime_postShield" ][ "easy" ]		= 0.5;
	level.difficultySettings[ "invulTime_postShield" ][ "normal" ]		= 0.4;
	level.difficultySettings[ "invulTime_postShield" ][ "hardened" ]	= 0.3;
	level.difficultySettings[ "invulTime_postShield" ][ "veteran" ]		= 0.0;
}

solorun_fastmoving_gameskill_settings()
{
	// the amount of health you have in this difficulty
	level.difficultySettings[ "playerDifficultyHealth" ][ "easy" ]		= 900;  // 475
	level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ]	= 550;  // 275
	level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ]	= 330;  // 165
	level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ]	= 230;  // 115
	
	// If you go to red flashing, the amount of time before your health regens
	level.difficultySettings[ "longRegenTime" ][ "easy" ]		= 1000;  // 5000
	level.difficultySettings[ "longRegenTime" ][ "normal" ]		= 1000;  // 5000
	level.difficultySettings[ "longRegenTime" ][ "hardened" ]	= 1000;  // 3200
	level.difficultySettings[ "longRegenTime" ][ "veteran" ]	= 1000;  // 3200
}

solorun_slowmoving_gameskill_settings()
{
	// defaults
	level.difficultySettings[ "playerDifficultyHealth" ][ "easy" ] = 475;
	level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ] = 275;
	level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = 165;
	level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ] = 115;
	
	level.difficultySettings[ "longRegenTime" ][ "easy" ] = 5000;
	level.difficultySettings[ "longRegenTime" ][ "normal" ] = 5000;
	level.difficultySettings[ "longRegenTime" ][ "hardened" ] = 3200;
	level.difficultySettings[ "longRegenTime" ][ "veteran" ] = 3200;
}

solorun_playerhurt_replacehint()
{
	wait( 1 );
	
	// "You are Hurt, Run For Your Life!"
	level.strings[ "take_cover" ].text = &"FAVELA_ESCAPE_SOLORUN_KEEP_MOVING";
}

solorun_player_progression_tracker()
{
	level endon( "trig_solorun_player_on_slide" );
	
	trigs = GetEntArray( "trig_solorun_roof_progression", "targetname" );
	ASSERT( trigs.size );
	
	level.solorun_progression_hilo = 0;
	thread solorun_player_progression_hilo_watcher();
	
	lastTrigNum = 1;
	maxCap = 1;
	
	while( 1 )
	{
		foreach( trig in trigs )
		{
			if( level.player IsTouching( trig ) )
			{
				if( trig.script_count > lastTrigNum )
				{
					if( level.solorun_progression_hilo >= maxCap )
					{
						level.solorun_progression_hilo = 0;
					}
					
					level.solorun_progression_hilo++;
				}
				else if( trig.script_count < lastTrigNum )
				{
					level.solorun_progression_hilo--;
				}
				
				while( level.player IsTouching( trig ) )
				{
					wait( 0.05 );
				}
				
				lastTrigNum = trig.script_count;
				
				break;
			}
		}
		
		wait( 0.05 );
	}
}

solorun_player_progression_hilo_watcher()
{
	level endon( "trig_solorun_player_on_slide" );
	
	flagstr = "solorun_player_progression_stalled";
	og_hilo = 0;
	
	while( 1 )
	{
		while( level.solorun_progression_hilo == og_hilo )
		{
			wait( 0.1 );
		}
		
		if( level.solorun_progression_hilo < 1 )
		{
			// going backwards
			if( !flag( flagstr ) )
			{
				flag_set( flagstr );
			}
		}
		else
		{
			if( flag( flagstr ) )
			{
				flag_clear( flagstr );
			}
		}
		
		og_hilo = level.solorun_progression_hilo;
	}
}

solorun_sprint_tracker()
{
	// no hints on veteran
	if( level.gameskill > 2 )
	{
		return;
	}
	
	flagstr = "solorun_player_sprinted";
	flag_init( flagstr );
	level thread set_flag_on_sprint( flagstr );
	
	//level.player ent_flag_wait( "player_has_red_flashing_overlay" );
	
	while( level.player.health > ( level.player.maxhealth * 0.9 ) && !flag( flagstr ) )
	{
		wait( 0.1 );
	}
	
	if( !flag( flagstr ) )
	{
		// hint
		level thread sprint_hint( flagstr );
	}
}

sprint_hint( flagstr )
{
	hintstr = &"FAVELA_ESCAPE_HINT_SPRINT_PC_ALT";  // "Press ^3[{+breath_sprint}]^7 while moving forward to sprint."
	if( !level.console )
	{
		change = false;
		
		// we want the sprint command to be the one that gets displayed on PC
		if ( is_command_bound( "+sprint" ) )
		{
			change = true;
		}
		// if neither are bound, show the PC-specific hint
		else if( !is_command_bound( "+breath_sprint" ) )
		{
			change = true;
		}
		
		if( change )
		{
			hintstr = &"FAVELA_ESCAPE_HINT_SPRINT_PC";  //"Press ^3[{+sprint}]^7 while moving forward to sprint."
		}
	}
	
	fontsize = 1.6;
	if( !level.console )
	{
		fontsize = 1.2;
	}
	hintElem = CreateFontString( "default", fontsize );
	hintElem.hidewheninmenu = true;
	hintElem setPoint( "TOP", undefined, 0, 110 );
	hintElem.sort = 0.5;
	hintElem.alpha = 0;
	hintElem SetText( hintstr );
	
	fadeTime = 0.25;
	hintElem FadeOverTime( fadeTime );
	hintElem.alpha = 1;
	
	//endTime = GetTime() + 5000;
	//while( !flag( flagstr ) && GetTime() < endTime && level.player.health > 0 )
	while( !flag( flagstr ) && level.player.health > 0 )
	{
		wait( 0.05 );
	}
	
	hintElem FadeOverTime( fadeTime );
	hintElem.alpha = 0;
	wait( fadeTime );
	hintElem Destroy();
}

set_flag_on_sprint( flagstr )
{
	NotifyOnCommand( flagstr, "+breath_sprint" );
	NotifyOnCommand( flagstr, "+sprint" );
	
	level.player waittill( flagstr );
	flag_set( flagstr );
}

player_bullet_whizbys()
{
	thread player_bullet_whizby_sounds();
	
	dmgtrigs = GetEntArray( "solorun_dmgtrig", "targetname" );
	array_thread( dmgtrigs, ::player_bullet_whizby_dmgtrigs );
	
	trigs = GetEntArray( "trig_solorun_squibs", "targetname" );
	array_thread( trigs, ::player_bullet_whizby_trig );
}

// to cover having "bursts" of squibs, play bullet sounds randomly in the background
player_bullet_whizby_sounds()
{
	level endon( "solorun_player_at_balcony" );
	
	shotWaitMin = 0.07;
	shotWaitMax = 0.1;
	
	shotsMin = 5;
	shotsMax = 9;
	
	burstWaitMin = 1;
	burstWaitMax = 2;
	
	weapons = level.scriptedweapons;
	sounds = level.scriptedweaponsounds;
	
	while( 1 )
	{
		weapon = get_random( weapons );
		numShots = RandomIntRange( shotsMin, shotsMax );
		
		for( i = 0; i < numShots; i++ )
		{
			playereye = level.player GetEye();
			
			thread play_sound_in_space( sounds[ weapon ], playereye );
			
			if( cointoss() )
			{
				thread play_sound_in_space( "whizby", playereye );
			}
			
			wait( RandomFloatRange( shotWaitMin, shotWaitMax ) );
		}
		
		wait( RandomFloatRange( burstWaitMin, burstWaitMax ) );
	}
}

player_bullet_whizby_dmgtrigs()
{
	self waittill( "trigger" );
	RadiusDamage( self.origin, 32, 1000, 1000 );
}

player_bullet_whizby_trig()
{
	ASSERT( IsDefined( self.target ) );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsAlive( other ) && IsDefined( other.team ) && other.team == "axis" )
		{
			break;
		}
		
		wait( 0.05 );
	}
	
	weapons = level.scriptedweapons;
	
	weapon = get_random( weapons );
	
	fx = getfx( "squib_plaster" );
	
	shotWaitMin = 0.07;
	shotWaitMax = 0.1;
	
	// either target a bunch of spots (for random squibs),
	//  or just one spot that targets a line of spots (for ordered squibs)
	squibs = GetStructArray( self.target, "targetname" );
	if( squibs.size == 1 )
	{
		squibs = get_targeted_line_array( squibs[ 0 ] );
	}
	// for now, they're all random since I think that's looking better and less scripty
	//else
	//{
		squibs = array_randomize( squibs );
	//}
	
	squibs[ 0 ] script_delay();
	
	foreach( squib in squibs )
	{
		// aim in the direction the squib is pointing
		ASSERT( IsDefined( squib.angles ) );
		forward = AnglesToForward( squib.angles );
		forwardscaled = vector_multiply( forward, 1024 );
		targetspot = squib.origin + forwardscaled;
		
		MagicBullet( weapon, squib.origin, targetspot );
		
		if( cointoss() )
		{
			thread play_sound_in_space( "whizby", squib.origin );
		}
		
		wait( RandomFloatRange( shotWaitMin, shotWaitMax ) );
	}
}

get_targeted_line_array( start )
{
	arr = [];
	arr[ 0 ] = start;
	point = start;
	
	while( IsDefined( point.target ) )
	{
		nextpoint = GetStruct( point.target, "targetname" );
		if( !IsDefined( nextpoint ) )
		{
			nextpoint = GetEnt( point.target, "targetname" );
		}
		if( !IsDefined( nextpoint ) )
		{
			nextpoint = GetNode( point.target, "targetname" );
		}
		
		if( IsDefined( nextpoint ) )
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

player_bullet_whizby_location_trig()
{
	spots = GetStructArray( self.target, "targetname" );
	ASSERT( spots.size );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsPlayer( other ) && !flag( "whizby_location_updating" ) )
		{
			flag_set( "whizby_location_updating" );
			
			level.whizbyStarts = spots;
			while( other IsTouching( self ) )
			{
				wait( 0.1 );
			}
			
			flag_clear( "whizby_location_updating" );
		}
		
		wait( 0.05 );
	}
}

solorun_rooftop_squibs()
{
	level.player endon( "death" );
	level endon( "trig_solorun_player_on_slide" );
	
	flag_wait( "solorun_player_off_balcony" );
	
	startOffsetMin = 128;
	startOffsetMax = 256;
	
	endOffsetMin = 32;
	endOffsetMax = 64;
	
	shotWaitMin = 0.08;
	shotWaitMax = 0.11;
	
	burstWaitMin = 0.5;
	burstWaitMax = 1;
	
	shotsMin = 5;
	shotsMax = 9;
	
	weapons = level.scriptedweapons;
	
	while( 1 )
	{
		weapon = get_random( weapons );
		numShots = RandomIntRange( shotsMin, shotsMax );
		
		axis = GetAiArray( "axis" );
		enemy = undefined;
		foreach( guy in axis )
		{
			if( guy CanSee( level.player ) && !player_can_see_ai( guy ) )
			{
				if( !IsDefined( enemy ) || ( Distance( guy.origin, level.player.origin ) < Distance( enemy.origin, level.player.origin ) ) )
				{
					enemy = guy;
				}
			}
		}
		
		if( !IsDefined( enemy ) )
		{
			wait( 1 );
			continue;
		}
		
		for( i = 0; i < numShots; i++ )
		{
			if( !IsAlive( enemy ) || player_can_see_ai( enemy ) )
			{
				wait( 0.05 );
				continue;
			}
			
			startPos = enemy GetEye() + ( 0, 0, 32 );
			
			playereye = level.player GetEye();
			playerangles = level.player.angles;
			forward = AnglesToForward( playerangles );
			refPoint = playereye + ( forward * 256 );
			startZ = refPoint[ 2 ] + 256;
			
			groundRefPoint = groundpos( refPoint );
			endX = solorun_rooftop_squib_offset( groundRefPoint[ 0 ], endOffsetMin, endOffsetMax );
			endY = solorun_rooftop_squib_offset( groundRefPoint[ 1 ], endOffsetMin, endOffsetMax );
			endZ = startZ;
			endPos = groundpos( ( endX, endY, endZ ) );
			
			// make sure we're not going to hit the player
			trace = BulletTrace( startPos, endPos, true );
			traceEnt = trace[ "entity" ];
			
			if( IsDefined( traceEnt ) )
			{
				if( IsPlayer( traceEnt ) )
				{
					continue;
				}
			}
			
			MagicBullet( weapon, startPos, endPos );
			
			wait( RandomFloatRange( shotWaitMin, shotWaitMax ) );
		}
		
		wait( RandomFloatRange( burstWaitMin, burstWaitMax ) );
	}
	
}

solorun_rooftop_squib_offset( coord, offsetMin, offsetMax )
{
	rand = RandomIntRange( offsetMin, offsetMax );
	
	if( cointoss() )
	{
		rand *= -1;
	}
	
	newcoord = coord + rand;
	return newcoord;
}

solorun_chopper_audio()
{
	trigger_wait_targetname( "trig_balcony_chopper_spawn" );
	
	chopper = undefined;
	while( !IsDefined( chopper ) )
	{
		wait( 0.05 );
		chopper = get_vehicle( "solorun_balcony_chopper", "targetname" );
	}
	
	chopper thread play_sound_on_entity( "scn_favela_escape_heli_flyover" );
}

solorun_rooftop_chopper_fakefire()
{
	trigs = GetEntArray( "solorun_chopper_fakefire_trig", "targetname" );
	
	array_thread( trigs, ::solorun_rooftop_chopper_fakefire_trig );
}

solorun_rooftop_chopper_fakefire_trig()
{
	spots = GetStructArray( self.target, "targetname" );
	
	self waittill( "trigger" );

	array_thread( spots, ::fakefire_smallarms_spot );	
	array_thread( spots, ::solorun_rooftop_chopper_fakefire_spot );
}

solorun_rooftop_chopper_fakefire_spot()
{
	if( !self script_delay() )
	{
		wait( RandomFloatRange( 0.5, 1.2 ) );
	}
	
	target = GetStruct( self.target, "targetname" );
	
	MagicBullet( "rpg_straight_short_life", self.origin, target.origin );
}

solorun_chopper_spawnfunc()
{
	self.health = 2000000;
	Missile_CreateRepulsorEnt( self, 1150, 1200 );
	
	level.chopper = self;
}

solorun_dialogue( bugplayer )
{
	balconyflag = "solorun_player_at_balcony";
	
	if( !IsDefined( bugplayer ) || bugplayer )
	{
		thread solorun_dialogue_bugplayer_inside( balconyflag );
	}
	
	flag_wait( balconyflag );
	// "Roach! I see you! Jump down to the rooftops and meet us south of your position! Go!"
	radio_dialogue( "favesc_cmt_meetussouth" );
	
	// "Gas is very low! I must leave in thirty seconds, ok?"
	radio_dialogue( "favesc_nkl_verylow" );
	
	flag_set( "solorun_timer_start" );
	
	// "Roach! We're running on fumes here! You got thirty seconds! Run!"
	radio_dialogue( "favesc_cmt_onfumes" );
	
	
	// DEPRECATED maybe do this one if you're in the trigger for a while?
	//flag_wait( "solorun_dialogue_3" );
	// "Head to the right!"
	//radio_dialogue( "favesc_cmt_headtoright" );
	
	
	flag_wait( "solorun_dialogue_4" );
	// "Left!!! Turn left and jump down!"
	radio_dialogue( "favesc_cmt_leftturnleft" );
	
	
	flag_wait( "solorun_dialogue_5" );
	// "Come on!!!!"
	radio_dialogue( "favesc_cmt_comeon" );
}

solorun_dialogue_bugplayer_inside( ender )
{
	level endon( ender );
	level.player endon( "death" );
	
	wait( 5 );
	//flag_wait( "solorun_dialogue_1" );
	// "Roach, we're circling the area but I can't see you! You've got to get to the rooftops!"
	radio_dialogue( "favesc_cmt_circlingarea" );
	
	wait( 15 );
	//flag_wait( "solorun_dialogue_2" );
	// "Roach, we're running low on fuel! Where the hell are you?!"
	radio_dialogue( "favesc_cmt_lowonfuel" );
}

solorun_chopperjump_killtrig()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsPlayer( other ) )
		{
			SetDvar( "ui_deadquote", "@FAVELA_ESCAPE_DEADQUOTE_FAILED_CHOPPER_JUMP" );
			maps\_utility::missionFailedWrapper();
		}
		
		wait( 0.05 );
	}
}

solorun_chopperjump( waitBeforeJump )
{
	if( !IsDefined( waitBeforeJump ) || waitBeforeJump )
	{
		flag_wait( "trig_solorun_player_on_slide" );
	}
	
	slidetrig = GetEnt( "trig_slide_chopperjump_ledge", "targetname" );
	killtrig = GetEnt( "killtrig_chopperjump", "script_noteworthy" );
	killtrig thread solorun_chopperjump_killtrig();
	
	animref = GetStruct( "solorun_chopperjump_animref", "targetname" );
	
	animname_player = "player";
	animname_chopper = "chopper";
	animname_ladder = "ladder";
	animname_doorguy = "chopper_door_guy";
	doorguyTag = "tag_detach";
	propsTag = "tag_body";
	fly_in_scene = "chopperjump_in";
	loop_scene = "chopperjump_loop";
	jump_scene = "chopperjump_jump";
	fly_out_scene = "chopperjump_flyaway";
	anime_jump = level.scr_anim[ animname_player ][ jump_scene ];
	
	// spawn props
	player_rig = spawn_anim_model( animname_player, animref.origin );
	player_rig Hide();
	
	chopper = spawn_anim_model( animname_chopper, animref.origin );
	chopper.angles = animref.angles;
	maps\_vehicle::build_drive( chopper getanim( "rotors" ), undefined, 0 );
	chopper thread maps\_vehicle::animate_drive_idle();
	chopper thread solorun_chopper_sfx();
	level.chopper = chopper;
	
	spawner = GetEnt( "chopperjump_sarge", "targetname" );
	sarge = spawner spawn_ai();
	sarge.animname = animname_doorguy;
	level.sarge = sarge;
	sarge LinkTo( chopper, doorguyTag );
	
	thread chopperjump_dialogue();
	
	ladder = spawn_anim_model( animname_ladder, ( 0, 0, 0 ) );
	level.chopperladder = ladder;
	
	player_rig LinkTo( chopper, propsTag );
	ladder LinkTo( chopper, propsTag );
	
	player_and_ladder = [];
	player_and_ladder[ 0 ] = player_rig;
	player_and_ladder[ 1 ] = ladder;
	
	// otherwise sunshadows pop in and out as world geo goes in and out of the view
	EnableForcedSunShadows();
	
	// flying in anim
	thread solorun_chopperjump_chopper_fly_in_and_idle( animref, chopper, ladder, sarge, fly_in_scene, propsTag, loop_scene, doorguyTag );
	
	// catch the jump
	jumpstart_vol = GetEnt( "trig_player_chopperjump", "script_noteworthy" );
	jumpForward = AnglesToForward( ( 0, 90, 0 ) );
	thread player_jump_watcher();
	
	altLookSpots = GetStructArray( "struct_chopperjump_alt_lookspot", "targetname" );
	ASSERT( altLookSpots.size );
	
	while( 1 )
	{
		breakout = false;
		
		while( level.player IsTouching( jumpstart_vol ) )
		{
			flag_wait( "player_jumping" );
			if( player_leaps_to_chopper( jumpstart_vol, ladder, altLookSpots, true ) )
			{
				breakout = true;
				break;
			}
			wait( 0.05 );
		}
		
		if( breakout )
		{
			break;
		}
		wait( 0.05 );
	}
	
	flag_set( "chopperjump_player_jump" );
	
	thread vision_set_fog_changes( "favela_escape_chopperjump", 3 );
	
	killtrig Delete();
	slidetrig Delete();
	
	chopper notify( "stop_loop" );
	
	animlength = GetAnimLength( player_rig getanim( jump_scene ) );
	
	level.player DisableWeapons();
	level.player AllowJump( false );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	
	// jump anim
	chopper thread anim_single( player_and_ladder, jump_scene, propsTag );
	// don't show the rig until after the player has blended into the animation
	thread chopperjump_player_blend_to_anim( player_rig );
	player_rig delaycall( 0.9, ::Show );
	delaythread( 1, ::solorun_chopperjump_rumble );
	
	level.chopperFlyawayDelay = animlength * 0.2;
	flag_set( "solorun_player_boarded_chopper" );
	
	animref delaythread( 0.05, ::anim_single_solo, chopper, fly_out_scene );
	chopper delaythread( 0.05, ::anim_single_solo, sarge, fly_out_scene, doorguyTag );
}

solorun_chopperjump_rumble()
{
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	wait( 0.5 );
	while( !flag( "level_faded_to_black" ) )
	{
		level.player PlayRumbleOnEntity( "damage_light" );
		wait( 0.115 );
	}
}

player_leaps_to_chopper( volume, ladder, altLookSpots, checkIsOnGround )
{
	if( !IsDefined( checkIsOnGround ) )
	{
		checkIsOnGround = true;
	}
	
	if( !volume IsTouching( level.player ) )
	{
		return false;
	}
	
	if ( level.player GetStance() != "stand" )
	{
		return false;
	}
	
	if( checkIsOnGround && level.player IsOnGround() )
	{
		return false;
	}
	
	// need to be looking at the ladder or at one of our alternate look spots while jumping for it
	lookingGood = true;
	
	refPoint = ladder.origin + ( 0, 0, -85 );  // uses the same offset as the objective indicator
	fov = GetDvarInt( "cg_fov" );
	if( !level.player WorldPointInReticle_Circle( refPoint, fov, 120 ) )
	{
		lookingGood = false;
	}
	
	if( !lookingGood )
	{
		foundOne = false;
		foreach( spot in altLookSpots )
		{
			//print3d( spot.origin, "*", ( 1, 1, 1 ), 1, 1, 60 );
			
			if( level.player WorldPointInReticle_Circle( spot.origin, fov, 165 ) )
			{
				foundOne = true;
				break;
			}
		}
		
		if( foundOne )
		{
			lookingGood = true;
		}
	}
	
	if( !lookingGood )
	{
		return false;
	}

	vel = level.player GetVelocity();
	// figure out the length of the vector to get the speed (distance from world center = length)
	velocity = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
	if ( velocity < 145 )
	{
		return false;
	}
	
	return true;
}

solorun_chopperjump_chopper_fly_in_and_idle( animref, chopper, ladder, sarge, fly_in_scene, propsTag, loop_scene, doorguyTag )
{
	animref thread anim_single_solo( chopper, fly_in_scene );
	chopper thread anim_single_solo( sarge, fly_in_scene, doorguyTag );
	chopper anim_single_solo( ladder, fly_in_scene, propsTag );
	
	// idle anim
	if( !flag( "chopperjump_player_jump" ) )
	{
		packets = [];
		packet_chopper = [];
		packet_chopper[ "guy" ] = chopper;
		packet_chopper[ "entity" ] = animref;
		packet_chopper[ "tag" ] = undefined;
		packets[ packets.size ] = packet_chopper;
		
		packet_ladder = [];
		packet_ladder[ "guy" ] = ladder;
		packet_ladder[ "entity" ] = chopper;
		packet_ladder[ "tag" ] = propsTag;
		packets[ packets.size ] = packet_ladder;
		
		packet_sarge = [];
		packet_sarge[ "guy" ] = sarge;
		packet_sarge[ "entity" ] = chopper;
		packet_sarge[ "tag" ] = doorguyTag;
		packets[ packets.size ] = packet_sarge;
		
		chopper thread anim_loop_packet( packets, loop_scene );
	}
}

solorun_chopper_sfx()
{
	idleAlias = "pavelow_idle_high";
	movingAlias = "pavelow_engine_high";
	
	self thread play_loop_sound_on_entity( idleAlias );
	
	flag_wait( "chopperjump_player_jump" );
	wait( level.chopperFlyawayDelay );
	
	self thread play_loop_sound_on_entity( movingAlias );
	wait( 0.25 );
	self notify( "stop sound" + idleAlias );
}

player_jump_watcher()
{
	level endon( "player_jump_watcher_stop" );
	
	jumpflag = "player_jumping";
	if( !flag_exist( jumpflag ) )
	{
		flag_init( jumpflag );
	}
	else
	{
		flag_clear( jumpflag );
	}
	
	NotifyOnCommand( "playerjump", "+gostand" );
	NotifyOnCommand( "playerjump", "+moveup" );
	
	while( 1 )
	{
		level.player waittill( "playerjump" );
		wait( 0.1 );  // jumps don't happen immediately
		
		if( !level.player IsOnGround() )
		{
			flag_set( jumpflag );
			println( "jumping" );
		}
		
		while( !level.player IsOnGround() )
		{
			wait( 0.05 );
		}
		flag_clear( jumpflag );
		println( "not jumping" );
	}
}

chopperjump_player_blend_to_anim( player_rig )
{
	wait( 0.3 );
	level.player notify( "stop_sliding" );  // defensive. deleting the slide trigger when we catch the jump should work, but just in case it starts in some super edge case, I don't want StopSlide() to ever try to unlink him
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.6, 0.2, 0.4 );
}

chopperjump_dialogue()
{
	trigger_wait_targetname( "chopperjump_dialogue_jumpforit" );
	
	// "Jump for it!!!"
	level.sarge thread dialogue_queue( "favesc_cmt_jump" );
	
	flag_wait( "chopperjump_player_jump" );
	wait( 2 );
	
	// "Nikolai! We got him! Get us outta here!"
	radio_dialogue( "favesc_cmt_gothim" );
	
	wait( 1 );
	
	// "Where to, Captain?"
	radio_dialogue( "favesc_nkl_whereto" );
	
	wait( 0.4 );
	
	// "Just get us to the sub..."
	radio_dialogue( "favesc_cmt_tothesub" );
}


// -----------------
// -- AI STUFF --
// -----------------
get_single_redshirt()
{
	guys = get_nonhero_friends();
	ASSERT( guys.size == 1 );
	redshirt = guys[ 0 ];
	return redshirt;
}

setup_color_friendly_spawners()
{
	spawners = GetEntArray( "color_friendly_spawner", "targetname" );
	ASSERT( spawners.size );
	
	level._color_friendly_spawners = spawners;
}

enemy_cleanup()
{
	cleanuptrigs = GetEntArray( "enemy_cleanup_trigger", "targetname" );
	array_thread( cleanuptrigs, ::enemy_cleanup_trigger_think );
}

enemy_cleanup_trigger_think()
{
	assertstr = "Enemy cleanup trigger at origin " + self.origin + " needs to target a volume.";
	ASSERTEX( IsDefined( self.target ), assertstr );
	
	killVolumes = GetEntArray( self.target, "targetname" );
	ASSERTEX( killVolumes.size, assertstr );
	
	self waittill( "trigger" );
	guys = GetAiArray( "axis" );
	
	foreach( guy in guys )
	{
		foreach( vol in killVolumes )
		{
			foundHim = false;
			if( guy IsTouching( vol ) )
			{
				foundHim = true;
				guy Delete();
				break;
			}
			
			if( foundHim )
			{
				break;
			}
		}
	}
	
	array_delete( killVolumes );
	self Delete();
}

try_spawn_loop( numTries, waitTime )
{
	if( !IsDefined( numTries ) )
	{
		numTries = 10;
	}
	
	if( !IsDefined( waitTime ) )
	{
		waitTime = 0.05;
	}
	
	for( i = 0; i < numTries; i++ )
	{
		if( IsDefined( self.forcespawn ) && self.forcespawn > 0 )
		{
			guy = self StalingradSpawn();
		}
		else
		{
			guy = self DoSpawn();
		}
		
		if( !spawn_failed( guy ) )
		{
			return guy;
		}
		
		wait( waitTime );
	}
	
	return undefined;
}

spawn_group_staggered( aSpawners, doSafe )
{
	spawn_group( aSpawners, doSafe, true );
}

spawn_group( aSpawners, doSafe, doStaggered )
{
	ASSERTEX( ( aSpawners.size > 0 ), "The array passed to array_spawn function is empty" );
	
	if( !IsDefined( doSafe ) )
	{
		doSafe = false;
	}
	
	if( !IsDefined( doStaggered ) )
	{
		doStaggered = false;
	}
	
	aSpawners = array_randomize( aSpawners );
	
	spawnedGuys = [];
	foreach( index, spawner in aSpawners )
	{
		guy = spawner spawn_ai();
		spawnedGuys[ spawnedGuys.size ] = guy;
		
		if( doStaggered )
		{
			if( index != ( aSpawners.size - 1 ) )
			{
				wait( randomfloatrange( .25, 1 ) );
			}
		}
	}
	
	if( doSafe )
	{
		//check to ensure all the guys were spawned
		ASSERTEX( ( aSpawners.size == spawnedGuys.size ), "Not all guys were spawned successfully from array_spawn" );
	}

	return spawnedGuys;
}

ai_unlimited_rocket_ammo()
{
	self endon( "death" );
	
	ASSERT( IsDefined( self.a.rockets ) );
	
	while( 1 )
	{
		if( self.a.rockets < 3 )
		{
			self.a.rockets = 3;
		}
		
		wait( 1 );
	}
}

bloody_pain( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	if( damage <= 1 )
	{
		return;
	}
	
	angles = VectorToAngles( direction_vec );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );
	
	anglesReversed = VectorToAngles( direction_vec ) + ( 0, 180, 0 );
	backward = AnglesToForward( anglesReversed );

	PlayFX( getfx( "headshot" ), point, forward, up );
	PlayFX( getfx( "bodyshot" ), point, backward, up );
}

// ---- door kicker guys ----
// spawns AIs in a house and has one of them kick the door open
door_kick_housespawn( spawners, door, animRef, physicsRef )
{
	spawners = array_randomize( spawners );
	
	kickerSpawner = undefined;
	
	// if one of them has script_parameters set to "kicker" then he should kick the door
	foreach( spawner in spawners )
	{
		if( IsDefined( spawner.script_parameters ) && spawner.script_parameters == "kicker" )
		{
			kickerSpawner = spawner;
			break;
		}
	}
	
	if( !IsDefined( kickerSpawner ) )
	{
		kickerSpawner = spawners[ 0 ];
	}
	
	spawners = array_remove( spawners, kickerSpawner );
	kicker  = kickerSpawner spawn_ai( true );
	kicker magic_bullet_shield();
	
	// spawn the other guys after the kicker has started his anim
	if( spawners.size )
	{
		delaythread( 0.15, ::spawn_group, spawners );
	}
	
	kickAnime = "door_kick_in";
	kickNotetrack = "kick";
	if( IsDefined( animRef.script_noteworthy ) )
	{
		switch( animRef.script_noteworthy )
		{
			case "wave":
				kickAnime = "doorburst_wave";
				kickNotetrack = "door_kick";
				break;
				
			case "search":
				kickAnime = "doorburst_search";
				kickNotetrack = "door_kick";
				break;
			
			case "fall":
				kickAnime = "doorburst_fall";
				kickNotetrack = "door_kick";
				break;
		}
	}
	
	animRef thread anim_generic( kicker, kickAnime );
	kicker waittillmatch( "single anim", kickNotetrack );
	thread play_sound_in_space( "door_wood_double_kick", door.origin );
	door thread sbmodel_rotate( 0.25, true );
	
	// optionally push some stuff out of the way when the door opens
	if( IsDefined( physicsRef ) )
	{
		PhysicsExplosionCylinder( physicsRef.origin, physicsRef.radius, ( physicsRef.radius / 2 ), 1.0 );
	}
	
	kicker stop_magic_bullet_shield();
	kicker.allowdeath = true;
	
	kicker waittillmatch( "single anim", "end" );
	
	if( IsAlive( kicker ) )
	{
		if( IsDefined( kickerSpawner.script_playerseek ) && kickerSpawner.script_playerseek > 0 )
		{
			kicker playerseek();
		}
		else
		{
			if( IsDefined( kickerSpawner.target ) )
			{
				node = GetNode( kickerSpawner.target, "targetname" );
				if( IsDefined( node ) )
				{
					kicker set_temp_goalradius( 96 );
					kicker SetGoalNode( node );
				
					kicker waittill_notify_or_timeout( "goal", 5 );
					
					if( IsAlive( kicker ) )
					{
						kicker restore_goalradius();
					}
				}
			}
		}
	}
}

// ---- chaotic above shooter guys ----
chaotic_above_shooter()
{
	self endon( "death" );
	
	animref = GetStruct( self.target, "targetname" );
	
	// favela_chaotic_above_through, favela_chaotic_above_through_uzi, favela_chaotic_above_through_back
	anime = "favela_chaotic_above_through";
	if( IsDefined( animref.script_noteworthy ) )
	{
		anime = animref.script_noteworthy;
	}
	
	animref anim_generic_reach( self, anime );
	
	self.allowdeath = true;
	animref anim_generic( self, anime );
}

// ---- window smash guys ----
window_smash_stop_inside()
{
	self endon( "death" );
	
	self window_smash( "window_smash_stop_inside" );
	
	node = GetNode( self.target, "targetname" );
	
	if( IsDefined( self.script_playerseek ) && self.script_playerseek )
	{
		self playerseek();
	}
	else if( IsDefined( node ) )
	{
		self SetGoalNode( node );
	}
}

window_smash( smashAnime )
{
	self endon( "death" );
	
	errorstr = "window smash guy at origin " + self.origin + " needs to be targeting a script_struct that he can use as his animref.";
	ASSERTEX( IsDefined( self.target ), errorstr );
	animref = GetStruct( self.target, "targetname" );
	ASSERTEX( IsDefined( animref ), errorstr );
	
	animref anim_generic_reach( self, smashAnime );
	animref anim_generic( self, smashAnime );
}

// ---- curtain pulldown guys ----
curtain_pulldown( bWaitForPlayer, specialWaitFunc )
{
	if ( !isdefined( bWaitForPlayer ) )
		bWaitForPlayer = false;
	
	assert( isdefined( self.target ) );
	node = self curtain_pulldown_getnode();
	assert( isdefined( node ) );
	
	curtain = curtain_pulldown_spawnmodel( node );
	
	self waittill( "spawned", guy );
	if ( spawn_failed( guy ) )
		return;
	
	guy endon( "death" );
	
	guy.animname = "curtain_pull";
	
	guy set_ignoreme( true );
	guy.usechokepoints = false;
	
	wait 0.05;
	
	guy_and_curtain[ 0 ] = guy;
	guy_and_curtain[ 1 ] = curtain;
	
	node anim_reach_solo( guy, "pulldown" );
	
	if ( bWaitForPlayer )
	{
		node anim_first_frame_solo( guy, "pulldown" );
		
		if( IsDefined( specialWaitFunc ) )
		{
			[[specialWaitFunc]]( guy, node );
		}
		else
		{
			waittill_player_lookat( 0.9, undefined, true, 5.0 );
		}
	}
	
	guy.allowdeath = true;
	node anim_single( guy_and_curtain, "pulldown" );
	
	guy endon( "death" );
	
	guy set_ignoreme( false );
	guy.goalradius = 1000;
	guy setGoalPos( guy.origin );
	guy.usechokepoints = true;
}

// broke out into a separate function so we can spawn the model early
curtain_pulldown_spawnmodel( node )
{
	if( IsDefined( node.curtain ) )
	{
		return node.curtain;
	}
	
	curtain = spawn_anim_model( "curtain" );
	
	node thread anim_first_frame_solo( curtain, "pulldown" );
	node.curtain = curtain;
	
	return node.curtain;
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

dialogue( msg )
{
	if( !IsDefined( level.scripted_dialogue_struct ) )
	{
		level.scripted_dialogue_struct = SpawnStruct();
	}
	
	level.scripted_dialogue_struct function_stack( ::dialogue_stack, self, msg );
}

dialogue_stack( guy, msg )
{
	guy dialogue_queue( msg );
}

dialogue_print( line, timeout )
{
	if( !IsDefined( timeout ) )
	{
		timeout = 3;
	}
	
	hintfade = 0.5;

	level endon( "clearing_hints" );

	if ( isDefined( level.tempHint ) )
		level.tempHint destroyElem();

	level.tempHint = createFontString( "default", 1.5 );
	level.tempHint setPoint( "BOTTOM", undefined, 0, -40 );
	level.tempHint.color = ( 1, 1, 1 );
	level.tempHint setText( line );
	level.tempHint.alpha = 0;
	level.tempHint fadeOverTime( 0.5 );
	level.tempHint.alpha = 1;
	level.tempHint.sort = 1;
	wait( 0.5 );
	level.tempHint endon( "death" );

	wait( timeout );

	level.tempHint fadeOverTime( hintfade );
	level.tempHint.alpha = 0;
	wait( hintfade );

	level.tempHint destroyElem();
}

playsound_from_random_spot( soundalias, moveSpots )
{
	// in case we're just passing a single spot
	if( !IsArray( moveSpots ) )
	{
		newArr = [];
		newArr[ 0 ] = moveSpots;
		moveSpots = newArr;
	}
	
	org = Spawn( "script_origin", get_random( moveSpots ).origin );
	org PlaySound( soundAlias, "sound_done" );
	org waittill( "sound_done" );
	org Delete();
}

delete_at_path_end()
{
	self waittill( "reached_path_end" );
	
	if( IsAlive( self ) )
	{
		self Kill();
	}
	
	wait( 0.1 );
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

ignore_til_pathend_or_damage()
{
	self endon( "death" );
	
	self ignore_everything();
	self waittill_either( "reached_path_end", "damage" );
	self clear_ignore_everything();
}

ignore_til_pathend()
{
	self endon( "death" );
	
	self ignore_everything();
	self waittill( "reached_path_end" );
	self clear_ignore_everything();
}

ignore_and_delete_at_path_end()
{
	self endon( "death" );
	
	self ignore_everything();
	
	while( 1 )
	{
		msg = self waittill_any_return( "reached_path_end", "damage" );
		
		if( msg == "damage" )
		{
			self clear_ignore_everything();
		}
		else if( msg == "reached_path_end" )
		{
			break;
		}
	}
	
	wait( 0.1 );
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

playerseek_at_path_end()
{
	self endon( "death" );
	
	self waittill( "reached_path_end" );
	self playerseek();
}

playerseek()
{
	self SetGoalEntity( level.player );
}

scr_animplaybackrate( rate )
{
	self.animplaybackrate = rate;
}

scr_usechokepoints( bool )
{
	self.useChokePoints = bool;
}

scr_disable_dontshootwhilemoving()
{
	self.dontshootwhilemoving = undefined;
}

scr_moveplaybackrate( rate )
{
	self.moveplaybackrate = rate;
}

scr_accuracy( acc )
{
	self.baseAccuracy = acc;
}

scr_setgoalvolume( ent )
{
	self SetGoalVolume( ent );
}

scr_cleargoalvolume()
{
	self ClearGoalVolume();
}

scr_set_health( newhealth )
{
	self.health = newhealth;
}

scr_ignoreall( bool )
{
	self.ignoreall = bool;
}

scr_ignoreme( bool )
{
	self.ignoreme = bool;
}

scr_walkDistFacingMotion( dist )
{
	self.walkDistFacingMotion = dist;
}

set_temp_goalradius( newRadius )
{
	if( !IsDefined( self.og_goalradius ) )
	{
		self.og_goalradius = self.goalradius;
	}
	
	self.goalradius = newRadius;
}

restore_goalradius()
{
	if( IsDefined( self.og_goalradius ) )
	{
		self.goalradius = self.og_goalradius;
	}
}

set_threatbias_group( groupname )
{
	self.og_threatbiasgroup = self GetThreatBiasGroup();
	self SetThreatBiasGroup( groupname );
}

reset_threatbias_group()
{
	ASSERT( IsDefined( self.og_threatbiasgroup ) );
	self SetThreatBiasGroup( self.og_threatbiasgroup );
}

magic_bullet_shield_safe()
{
	if( !IsDefined( self.magic_bullet_shield ) || !self.magic_bullet_shield )
	{
		self thread magic_bullet_shield();
	}
}

stop_magic_bullet_shield_safe()
{
	if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self thread stop_magic_bullet_shield();
	}
}

ignore_everything()
{
	self.ignoreall = true;
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.ignoresuppression = true;
	self.fixednode = false;
	self.disableBulletWhizbyReaction = true;
	self disable_pain();
	
	self.og_newEnemyReactionDistSq = self.newEnemyReactionDistSq;
	self.newEnemyReactionDistSq = 0;
}

clear_ignore_everything()
{
	self.ignoreall = false;
	self.grenadeawareness = 1;
	self.ignoreexplosionevents = false;
	self.ignorerandombulletdamage = false;
	self.ignoresuppression = false;
	self.fixednode = true;
	self.disableBulletWhizbyReaction = false;
	self enable_pain();
	
	if( IsDefined( self.og_newEnemyReactionDistSq ) )
	{
		self.newEnemyReactionDistSq = self.og_newEnemyReactionDistSq;
	}
}

be_less_scared()
{
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.ignoresuppression = true;
	//self.fixednode = false;
	self.disableBulletWhizbyReaction = true;
	self disable_pain();
	
	self PushPlayer( true );
}

group_clear_atScriptedGoal( arr )
{
	foreach( guy in arr )
	{
		guy.atScriptedGoal = false;
	}
}

goto_scripted_goalnode( node )
{
	self ignore_everything();
	
	self set_temp_goalradius( 32 );
	self SetGoalNode( node );
	self waittill( "goal" );
	self.atScriptedGoal = true;
	
	self clear_ignore_everything();
}

group_waitfor_scriptedgoal( arr )
{
	while( 1 )
	{
		foundOne = false;
		
		foreach( guy in arr )
		{
			if( IsAlive( guy ) && !guy.atScriptedGoal )
			{
				foundOne = true;
				break;
			}
		}
		
		if( !foundOne )
		{
			break;
		}
		
		wait( 0.05 );
	}
	
	level notify( "group_at_scriptedgoal" );
}

get_alive_enemies()
{
	enemies = GetAiArray( "axis" );
	return array_removeDead( enemies );
}

get_nonhero_friends()
{
	nonheroes = [];
	
	foreach( guy in level.friends )
	{
		if( !IsDefined( guy.isHero ) )
		{
			nonheroes[ nonheroes.size ] = guy;
		}
	}
	
	return nonheroes;
}

remove_nonhero_friends( exceptThisMany )
{
	flag_wait( "friends_setup" );
	
	nonheroes = get_nonhero_friends();
	
	if( IsDefined( exceptThisMany ) )
	{
		nonheroes = array_remove( nonheroes, nonheroes[0] );
	}
	
	battlechatter_off( "allies" );
	
	foreach( guy in nonheroes )
	{
		level.friends = array_remove( level.friends, guy );
		
		guy disable_replace_on_death();
		guy stop_magic_bullet_shield_safe();
		guy Kill();
	}
	
	battlechatter_on( "allies" );
}

// color reinforcement system startup thread
favela_escape_friendly_startup_thread()
{
	self scr_accuracy( level.friendly_baseaccuracy );
	self friend_add();
}

// adds a guy to level.friends
friend_add()
{
	if( !IsDefined( level.friends ) )
	{
		level.friends = [];
	}
	
	ASSERT( !is_in_array( level.friends, self ), "Trying to add a guy to level.friends who's already in there." );
	
	level.friends = array_add( level.friends, self );
	self thread remove_from_friends_on_death();
}

// removes a guy from level.friends
friend_remove()
{
	ASSERT( IsDefined( level.friends ) );
	level.friends = array_remove( level.friends, self );
}

remove_from_friends_on_death()
{
	self waittill( "death" );
	self friend_remove();
}

delete_all_friends()
{
	if( IsDefined( level.scripted_dialogue_struct ) )
	{
		// clear the dialogue function stack so it's not waiting to run a function that depends on one of these guys being alive
		level.scripted_dialogue_struct function_stack_clear();
	}
	
	array_notify( level.friends, "death" );
	
	nonheroes = get_nonhero_friends();
	foreach( guy in nonheroes )
	{
		guy disable_replace_on_death();
		guy stop_magic_bullet_shield_safe();
		guy Delete();
	}
	
	level.sarge disable_replace_on_death();
	level.hero1 disable_replace_on_death();
	level.sarge stop_magic_bullet_shield();
	level.hero1 stop_magic_bullet_shield();
	level.sarge Delete();
	level.hero1 Delete();
}

warp_friends_and_player( str )
{
	level.friends = array_removeundefined( level.friends );
	level.friends = array_removedead( level.friends );
	
	friendSpots = GetStructArray( str, "targetname" );
	playerSpot = GetStruct( str + "_player", "targetname" );
	
	ASSERT( friendSpots.size >= level.friends.size );
	ASSERT( IsDefined( playerSpot ) );
	
	foreach( index, guy in level.friends )
	{
		origin = friendSpots[ index ].origin;
		angles = friendSpots[ index ].angles;
		guy thread teleport_to_origin( origin, angles );
	}
	
	level.player teleport_to_origin( playerSpot.origin, playerSpot.angles );
}

teleport_to_node( node )
{
	self teleport_to_origin( node.origin, node.angles );
}

teleport_to_origin( origin, angles )
{
	if( !IsDefined( angles ) )
	{
		angles = ( 0, 0, 0 );
	}
	
	if( !IsPlayer( self ) )
	{
		self ForceTeleport( groundpos( origin ), angles );
		self SetGoalPos( self.origin );
	}
	else
	{
		org = level.player spawn_tag_origin();
		level.player PlayerLinkTo( org, "tag_origin", 1 );
		org MoveTo( origin, 0.05 );
		org RotateTo( angles, 0.05 );
		wait( 0.1 );
		level.player Unlink();
		org Delete();
	}
}

kill_group_over_time( guys, time )
{
	if( guys.size < 1 )
	{
		return;
	}
	
	timePerKill = time / guys.size;
	
	foreach( index, guy in guys )
	{
		guy thread bloody_death( 0 );
		
		if( index != guys.size - 1 )
		{
			wait( timePerKill );
		}
	}		
}

bloody_death_after_min_delay( mindelay, randomdelay )
{
	wait( mindelay );
	self bloody_death( randomdelay );
}

// fake death
bloody_death( delay )
{
	self endon( "death" );

	if( !IsSentient( self ) || !IsAlive( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";

	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	self DoDamage( self.health + 50, self.origin );
}

bloody_death_fx( tag, fxName )
{
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}


// -------------------------------
// -- FRIENDLY COLOR MANAGEMENT --
// -------------------------------
// kind of a fancy version of the linear friendly color management technique, in that it
//  supports multiple colorCode/volume combos per trigger
// - the basic concept is that we don't want friendlies to move forward until
//   a volume associated with their colorCode is clear of enemies
color_flags_advance( baseName, numTotalFlags, startFlagNum )
{
	thread color_flags_advance_cleanup();
	level endon( "color_flags_advance_stop" );
	
	team = "allies";
	
	// maybe we want to start from the middle of the chain, like for a start point
	if( !IsDefined( startFlagNum ) )
	{
		startFlagNum = 1;
	}
	
	for ( i = startFlagNum; i <= numTotalFlags; i++ )
	{
		// final name looks like "[baseName]_1" or whatever
		name = baseName + "_" + i;
		flagtrig = GetEnt( name, "targetname" );
		colortrig = GetEnt( flagtrig.target, "targetname" );
		
		flag_wait( name );
		
		// get all the color codes on this trigger
		array = colortrig maps\_colors::get_colorcodes_from_trigger( colortrig.script_color_allies, team );
		colorCodes = array[ "colorCodes" ];
		colorCodesByColorIndex = array[ "colorCodesByColorIndex" ];
		colors = array[ "colors" ];
		
		// figure out the test volume for each color code
		// note: only works for one volume per color code! I think this is how the color system works anyway, only one volume is supported afaik.
		infos = [];
		foreach( colorCode in colorCodes )
		{
			volume = level.arrays_of_colorCoded_volumes[ team ][ colorCode ];
			if( IsDefined( volume ) )
			{
				// can only support one volume per colorCode at the moment
				ASSERTEX( !color_flags_dupe_info( infos, colorCode ), "More than one volume found for colorCode " + colorCode + ", currently we only support one volume per colorCode." );
				
				info = spawnstruct();
				
				// set up arrays for us to manually pass to activate_color_trigger_internal
				info.colorCodes[ 0 ] = colorCode;
				color = GetSubStr( colorCode, 0, 1 );
				info.colors[ 0 ] = color;
				info.colorCodesByColorIndex[ color ] = colorCodesByColorIndex[ color ];
				info.colortrig = colortrig;
				info.name = name;
				info.volume = volume;
				
				infos[ infos.size ] = info;
			}
		}
		
		array_thread( infos, ::color_flags_advance_queue_add );
	}
}

color_flags_advance_cleanup()
{
	level waittill( "color_flags_advance_stop" );
	
	level.color_flags_advance_queue = undefined;
}		

color_flags_advance_queue_manager( color )
{
	level endon( "color_flags_advance_stop" );
	
	while( 1 )
	{
		// if we have any volumes of this color to wait for, do them in order
		if( level.color_flags_advance_queue[ color ].size )
		{
			// process the first volume in the stack, if the stack has any entries
			volume = level.color_flags_advance_queue[ color ][ 0 ];
			volume color_flag_volume_advance_wait();
		}
		// otherwise, wait for an update and try again
		else
		{
			level waittill( "color_flag_advance_queue_updated" );
		}
	}
	
}

// self = the info spawnstruct to add
color_flags_advance_queue_add()
{
	color = self.colors[ 0 ];
	
	if( !IsDefined( level.color_flags_advance_queue ) )
	{
		level.color_flags_advance_queue = [];
	}
	
	// see if we need to set up the key for this color
	keys = GetArrayKeys( level.color_flags_advance_queue );
	foundOne = false;
	foreach( key in keys )
	{
		if( key == color )
		{
			foundOne = true;
			break;
		}
	}
	
	// set it up if necessary
	if( !foundOne )
	{
		level.color_flags_advance_queue[ color ] = [];
		
		// kick off a queue manager for this color
		thread color_flags_advance_queue_manager( color );
	}
	
	// add the volume to the end of the array
	level.color_flags_advance_queue[ color ][ level.color_flags_advance_queue[ color ].size ] = self;
	
	level notify( "color_flag_advance_queue_updated" );
}

// self = the info spawnstruct to remove
color_flags_advance_queue_remove()
{
	color = self.colors[ 0 ];
	
	ASSERTEX( self == level.color_flags_advance_queue[ color ][ 0 ], "Tried to remove a volume from the color_flags_advance queue for color " + color + ", but that volume wasn't at the top of the stack. This is unexpected." );
	
	level.color_flags_advance_queue[ color ] = array_remove( level.color_flags_advance_queue[ color ], self );
}

// self = the info spawnstruct
color_flag_volume_advance_wait()
{
	level endon( "color_flags_advance_stop" );
	
	self.volume waittill_volume_dead_or_dying();
	
	self.colorTrig thread maps\_colors::activate_color_trigger_internal( self.colorCodes, self.colors, "allies", self.colorCodesByColorIndex );
	
	self color_flags_advance_queue_remove();
}

color_flags_dupe_info( infos, colorCode )
{
	if( !infos.size )
	{
		return false;
	}
	
	foreach( info in infos )
	{
		if( info.colorCodes[ 0 ] == colorCode )
		{
			return true;
		}
	}
	
	return false;
}


// ----------------------
// --- AIRLINER STUFF ---
// ----------------------
airliner_flyby_trigs()
{
	ASSERT( IsDefined( level.airliner ) );
	airliner_hide();
	
	lockflag = "airliner_flyby";
	flag_init( lockflag );
	
	trigs = GetEntArray( "trig_airliner_flyby", "targetname" );
	array_thread( trigs, ::airliner_flyby, lockflag );
}

airliner_setup()
{
	// gets all the ents in the prefab
	ents = GetEntArray( "sbmodel_airliner_flyby", "targetname" );
	level.airlinerParts = ents;
	
	org = undefined;
	light_wingtip_left = undefined;
	light_belly = undefined;
	light_tail = undefined;
	lights_wingtip_right = [];
	engine_exhausts = [];
	
	// find the script_origins and sort them
	foreach( ent in ents )
	{
		if( ent.code_classname == "script_origin" )
		{
			ASSERT( IsDefined( ent.script_noteworthy ) );
			
			switch( ent.script_noteworthy )
			{
				case "origin_marker":
					org = ent;
					break;
				
				case "light_wingtip_left":
					light_wingtip_left = ent;
					break;
					
				case "light_belly":
					light_belly = ent;
					break;
					
				case "light_tail":
					light_tail = ent;
					break;
					
				case "light_wingtip_right":
					lights_wingtip_right[ lights_wingtip_right.size ] = ent;
					break;
					
				case "engine_exhaust":
					engine_exhausts[ engine_exhausts.size ] = ent;
					break;
			}
		}
	}
	
	ASSERT( IsDefined( org ) );
	otherents = array_remove( ents, org );
	
	// turn on lights & exhaust
	light_wingtip_left	= airliner_fx( light_wingtip_left, "airliner_wingtip_left" );
	light_belly		= airliner_fx( light_belly, "airliner_belly" );
	light_tail		= airliner_fx( light_tail, "airliner_tail" );
	lights_wingtip_right	= airliner_fx_group( lights_wingtip_right, "airliner_wingtip_right" );
	engine_exhausts		= airliner_fx_group( engine_exhausts, "airliner_exhaust" );
	
	otherents[ otherents.size ] = light_wingtip_left;
	otherents[ otherents.size ] = light_belly;
	otherents[ otherents.size ] = light_tail;
	otherents = array_combine( otherents, lights_wingtip_right );
	otherents = array_combine( otherents, engine_exhausts );
	
	// link everything to the main script_origin
	foreach( ent in otherents )
	{
		ent LinkTo( org );
	}
	
	org.og_angles = org.angles;
	
	return org;
}

airliner_fx( spot, fxid )
{
	if( IsDefined( spot ) )
	{
		newspot = spot spawn_tag_origin();
		spot = newspot;
		
		PlayFxOnTag( getfx( fxid ), spot, "tag_origin" );
		
		return spot;
	}
	
	return undefined;
}

airliner_fx_group( group, fxid )
{
	if( group.size )
	{
		newspots = [];
		
		foreach( spot in group )
		{
			newspot = spot spawn_tag_origin();
			newspots[ newspots.size ] = newspot;
		}
		
		group = newspots;
		
		foreach( spot in group )
		{
			PlayFxOnTag( getfx( fxid ), spot, "tag_origin" );
		}
		
		return group;
	}
	
	return undefined;
}

airliner_hide()
{
	array_call( level.airlinerParts, ::Hide );
}

airliner_show()
{
	array_call( level.airlinerParts, ::Show );
}

airliner_flyby( lockflag )
{
	pathStart = GetStruct( self.target, "targetname" );
	pathEnd = GetStruct( pathStart.target, "targetname" );
	ASSERT( IsDefined( pathStart ), IsDefined( pathEnd ) );
	
	self waittill( "trigger" );
	
	level notify( "airliner_flyby" );
	
	speed = 1500;
	if( IsDefined( pathStart.speed ) )
	{
		speed = pathStart.speed;
	}
	
	flag_waitopen( lockflag );
	flag_set( lockflag );
		
	// move jet to path origin and unhide
	level.airliner.origin = pathStart.origin;
	
	if( IsDefined( pathStart.angles ) )
	{
		level.airliner.angles = pathStart.angles;
	}
	else
	{
		level.airliner.angles = level.airliner.og_angles;
	}
	
	wait( 0.05 );  // if we don't wait a bit while moving the plane, we'll see it move through the world
	airliner_show();
	
	level.airliner thread airliner_flyby_audio( pathStart.origin, pathEnd.origin, self );
		
	// move along path
	dist = Distance( pathStart.origin, pathEnd.origin );
	time = dist / speed;
	level.airliner MoveTo( pathEnd.origin, time );
	level.airliner waittill( "movedone" );
		
	// hide at path end
	airliner_hide();
		
	flag_clear( lockflag );
	
	self Delete();
}

airliner_flyby_audio( start, end, trig )
{
	if( IsDefined( trig.script_sound ) )
	{
		self play_sound_on_entity( trig.script_sound );
		return;
	}
	
	loop = "veh_airliner_dist_loop";  // main looping sound
	boom = "veh_airliner_boom_low";  // layers on top when the plane goes near the player
	
	boomspot = PointOnSegmentNearestToPoint( start, end, level.player.origin );
	boomDistSqd = 350 * 350;
	
	self thread play_loop_sound_on_entity( loop );
	
	while( DistanceSquared( self.origin, boomspot ) < boomDistSqd )
	{
		wait( 0.05 );
	}
	
	wait( 0.5 );  // delay before the "boom"
	
	self thread play_sound_in_space( boom );
	self waittill( "movedone" );
	self stop_sound( loop );
}

stop_sound( alias )
{
	self notify( "stop sound" + alias );
}


// -----------------
// -- UTIL STUFF --
// -----------------
sbmodel_rotate( rotateTime, makeNotSolid )
{
	if( !IsDefined( makeNotSolid ) )
	{
		makeNotSolid = false;
	}
	
	linker = GetEnt( self.target, "targetname" );
	ASSERTEX( IsDefined( linker ), "sbmodel_rotate(): sbmodel at origin " + self.origin + " doesn't have a linker entity targeted. Did you make it a script_struct instead of a script_origin by mistake?" );
	
	self LinkTo( linker );
	
	self ConnectPaths();
	
	ASSERTEX( IsDefined( linker.script_angles ), "sbmodel rotate linker script_origin at origin " + linker.origin + " needs script_angles set." );
	
	linker.og_angles = linker.angles;
	
	linker RotateTo( linker.script_angles, rotateTime );
	linker waittill( "rotatedone" );
	
	self DisconnectPaths();
	
	self Unlink();
	
	if( makeNotSolid )
	{
		self NotSolid();
		self thread make_solid_again_when_player_isnt_touching();
	}
	
	self notify( "sbmodel_rotatedone" );
}

make_solid_again_when_player_isnt_touching()
{
	while( level.player IsTouching( self ) )
	{
		wait( 0.05 );
	}
	
	self Solid();
}

sbmodel_rotate_back( rotateTime )
{
	linker = GetEnt( self.target, "targetname" );
	ASSERTEX( IsDefined( linker.og_angles ) );
	
	self LinkTo( linker );
	
	self ConnectPaths();
	
	ASSERTEX( IsDefined( linker.script_angles ), "sbmodel rotate linker script_origin at origin " + linker.origin + " needs script_angles set." );
	
	linker RotateTo( linker.og_angles, rotateTime );
	linker waittill( "rotatedone" );
	
	self DisconnectPaths();
	
	self Unlink();
	
	self notify( "sbmodel_rotatedone" );
}

minigun_squib_line( lineTime, fireInterval, weaponType )
{
	turret = self.scriptedTurret;
	
	lineStart = GetStruct( "hind_fakefire_impactLine_start", "targetname" );
	lineEnd = GetStruct( lineStart.target, "targetname" );
	
	numSquibs = lineTime / fireInterval;
	
	distance = Distance2D( lineStart.origin, lineEnd.origin );
	movementPerSquib = distance / numSquibs;
	
	targetOrigin = lineStart.origin;
	
	// get info about the direction of the line
	vec = VectorNormalize( lineEnd.origin - lineStart.origin );
	angles = VectorToAngles( vec );
	forward = AnglesToForward( angles );
	
	// how random our squib placement will be
	offsetMin = -25;
	offsetMax = 25;
	
	axis = GetAiArray( "axis" );  // if lineTime is super long this could be unreliable
	killradius = 64;
	
	startTime = GetTime();
	
	for( i = 0; i < numSquibs; i++ )
	{
		truePos = groundpos( targetOrigin );
		//Print3D( truePos, "*", ( 1, 1, 1 ), 0.8, 0.5, 90 );
		
		offsetX = RandomFloatRange( offsetMin, offsetMax );
		offsetY = RandomFloatRange( offsetMin, offsetMax );
		adjustedPos = ( truePos[ 0 ] + offsetX, truePos[ 1 ] + offsetY, truePos[ 2 ] );
		
		ASSERTEX( IsDefined( turret ), "minigun_squib_line(): the turret deleted after " + seconds( GetTime() - startTime ) + " seconds!" );
		MagicBullet( weaponType, turret GetTagOrigin( "tag_flash" ), adjustedPos );
		
		foreach( guy in axis )
		{
			if( !IsAlive( guy ) )
			{
				continue;
			}
			
			if( Distance2D( guy.origin, truePos ) < 64 )
			{
				guy Kill();
			}
		}
		
		wait( fireInterval );
		
		// move the target origin up
		targetOrigin += vector_multiply( forward, movementPerSquib );
	}
}

player_can_see( origin )
{
	if( !level.player animscripts\battlechatter::pointInFov( origin ) )
	{
		return false;
	}
	
	if( SightTracePassed( level.player GetEye(), origin, false, level.player ) )
	{
		return true;
	}
	
	return false;
}

deletetrigs()
{
	trigs = GetEntArray( "delete", "script_noteworthy" );
	array_thread( trigs, ::delete_after_touch );
}

delete_after_touch()
{
	self waittill( "trigger" );
	wait( 0.05 );
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

// spins the minigun up to the full rate needed to fire
minigun_spinup()
{
	if( self GetBarrelSpinRate() == 1 )
	{
		return;
	}
	
	self StartBarrelSpin();
	
	while( self GetBarrelSpinRate() < 1 )
	{
		wait( 0.05 );
	}
}

keep_objective_on_entity( objective_number, ent )
{
	ent endon( "death" );
	level endon( "objective_complete" + objective_number );

	for ( ;; )
	{
		objective_position( objective_number, ent.origin );
		wait 0.05;
	}
}

// makes sure self is in the trigger for a certain amount of time before continuing
trigger_wait_fuse( trig, fuseTime )
{
	self endon( "death" );
	
	while( IsDefined( self ) && IsDefined( trig ) )
	{
		trig waittill( "trigger", other );
		
		if( self == other )
		{
			endTime = GetTime() + milliseconds( fuseTime );
			
			while( GetTime() < endTime )
			{
				wait( 0.1 );
				
				if( !self IsTouching( trig ) )
				{
					break;
				}
			}
			
			if( GetTime() >= endTime )
			{
				trig notify( "trigger_fuse", self );
				return;
			}
		}
		
		wait( 0.05 );
	}
}

// like trigger_wait_targetname, except it works for multiple triggers named with the same targetname
trigger_wait_targetname_multiple( trigTN )
{
	trigs = GetEntArray( trigTN, "targetname" );
	if ( !trigs.size )
	{
		AssertMsg( "no triggers found with targetname: " + trigTN );
		return;
	}
	
	other = undefined;
	
	if( trigs.size > 1 )
	{
		array_thread( trigs, ::trigger_wait_multiple_think, trigTN );
		level waittill( trigTN, other );
	}
	else
	{
		trigs[ 0 ] waittill( "trigger", other );
	}
	
	return other;
}

trigger_wait_multiple_think( trigTN )
{
	self endon( trigTN );
	
	self waittill( "trigger", other );
	level notify( trigTN, other );
}

// gets a trigger by targetname and triggers it, not doing anything if the trigger is undefined.
// - use for artificially activating triggers that the player might have already activated
//   normally, like killspawners, etc.
trigger_activate_targetname_safe( trigTN )
{
	trig = GetEnt( trigTN, "targetname" );
	if( IsDefined( trig ) )
	{
		trig notify( "trigger" );
	}
}

trigger_activate_targetname( trigTN )
{
	trig = GetEnt( trigTN, "targetname" );
	ASSERT( IsDefined( trig ) );
	
	trig notify( "trigger" );
}

// waits until flag is set, then threads the function
flag_wait_thread( flag, process )
{
	flag_wait( flag );
	self thread [[ process ]]();
}

waittill_defined( ent )
{
	while( !IsDefined( ent ) )
	{
		wait( 0.05 );
	}
}

waittill_undefined( ent )
{
	while( IsDefined( ent ) )
	{
		wait( 0.05 );
	}
}

milliseconds( seconds )
{
	return seconds * 1000;
}

seconds( milliseconds )
{
	return milliseconds / 1000;
}

fade_to_black( fadeTime, isForeground )
{
	level.black_overlay = maps\_hud_util::create_client_overlay( "black", 0, level.player );
	level.black_overlay FadeOverTime( fadeTime );
	level.black_overlay.alpha = 1;
	
	if( IsDefined( isForeground ) )
	{
		level.black_overlay.foreground = isForeground;
	}
	
	wait( fadeTime );
}

fade_in_from_black( fadeTime )
{
	ASSERT( IsDefined( level.black_overlay ) );
	
	level.black_overlay FadeOverTime( fadeTime );
	level.black_overlay.alpha = 0;
	wait( fadeTime );
	
	level.black_overlay Destroy();
}

remove_all_flood_spawners()
{
	trigs = getentarray( "flood_spawner", "targetname" );
	foreach( trig in trigs )
	{
		trig Delete();
	}
}

get_random( arr )
{
	ASSERT( arr.size > 0 );
	
	if( arr.size == 1 )
	{
		return arr[ 0 ];
	}
	
	return arr[ RandomInt( arr.size - 1 ) ];
}

player_dots()
{
	for ( ;; )
	{
		Print3d( level.player.origin, ".", (1,1,1), 1, 1, 500 );
		wait( 0.05 );
	}
}


// bootleg client-side flashlight. originally this was for testing hunted lights but
//  ended up being interesting enough to keep around for later
player_fake_flashlight()
{
	// for testing hunted light off the player
	SetSavedDvar( "r_spotlightStartRadius", 36 );
	SetSavedDvar( "r_spotlightEndRadius", 325 );
	SetSavedDvar( "r_spotlightBrightness", 0.9 );
	fxspot = spawn_tag_origin();
	fxspot.origin = level.player GetEye();
	fxspot.angles = level.player GetPlayerAngles();
	fxspot thread flashlight_updater();
	fx = getfx( "flashlight" );
	PlayFxOnTag( fx, fxspot, "tag_origin" );
	
	level.player.fakeflashlight = fxspot;
}

flashlight_updater()
{
	while( 1 )
	{
		playerAngles = level.player GetPlayerAngles();
		playerEye = level.player GetEye();
		
		if( self.angles != playerAngles )
		{
			self.angles = playerAngles;
		}
		
		if( self.origin != playerEye )
		{
			self.origin = playerEye;
		}
		wait( 0.05 );
	}
}