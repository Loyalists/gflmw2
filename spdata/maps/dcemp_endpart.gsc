#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_weather;
#include maps\_slowmo_breach;

#include maps\dcemp_endpart_code;
#include maps\dcemp_code;

#using_animtree( "generic_human" );

/*
// custom command line
+exec scripter +set start "tunnels" +difficultyhard +set cg_drawfps 1 +set debug_colorfriendlies "off"
*/

start_tunnels()
{
	maps\dcemp::start_common_dcemp();
	flag_set( "rain_fx" );
	flag_set( "tunnels_main" );
	
	vision_set_tunnels();
	waittillframeend;

//	activate_trigger_with_targetname( "tunnels_start_color_trigger" );

	delaythread( 0.5, maps\_weather::rainHard, 0.1 );
	delaythread( 0.5, maps\_weather::lightning, maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );

	emp_teleport_team( level.team, getstructarray( "tunnels_start_points", "targetname" ) );
	emp_teleport_player();

	level.sky delete();

	delayThread( 0.25, ::activate_trigger_with_noteworthy, "tunnels_spawn_trigger" );
}

/*
start_whitehouse()
{
	maps\dcemp::start_common_dcemp();
	flag_set( "end_fx" );
	
	vision_set_whitehouse();
	level.sky delete();

	emp_teleport_team( level.team, getstructarray( "whitehouse_start_points", "targetname" ) );
	emp_teleport_player();

	maps\_weather::rainMedium( 1 );

	tunnels_flags();
	flag_set( "tunnels_teleport_done" );
	level thread endpart_objective();
}

whitehouse_flags()
{
	flag_init( "mg_threat" );
	flag_init( "whitehouse_radio" );
	flag_init( "whitehouse_interior" );
	flag_init( "whitehouse_radio_done" );
	flag_init( "whitehouse_flare_obj" );
	flag_init( "whitehouse_hammerdown" );
	flag_init( "whitehouse_hammerdown_stopped" );
	flag_init( "whitehouse_briefing_end" );
	flag_init( "whitehouse_hammerdown_started" );
	flag_init( "whitehouse_wrapup" );
	flag_init( "whitehouse_completed" );
	flag_init( "broadcast" );
	flag_init( "broadcast_pause" );
	flag_init( "broadcast_end" );
	flag_init( "countdown" );
	flag_init( "whitehouse_hammerdown_jets" );
	flag_init( "remove_use_hint" );
	flag_init( "flare_end_fx" );
	flag_init( "whitehouse_2min" );
	flag_init( "whitehouse_90sec" );
	flag_init( "whitehouse_1min" );
	flag_init( "whitehouse_30sec" );
}

whitehouse_main()
{
	whitehouse_flags();
	
	thread maps\_weather::rainMedium( 15 );

	autosave_by_name( "tunnel_exit" );

	array_spawn_function_noteworthy( "whitehouse_drone", ::whitehouse_drone  );
	array_spawn_function_noteworthy( "whitehouse_filler_drone", ::whitehouse_filler_drone  );
	array_spawn_function_noteworthy( "drone_war_drone", ::whitehouse_drone_war_drone  );

	spawner = getent( "marshall", "script_noteworthy" );
	spawner add_spawn_function( ::whitehouse_marshall );
	spawner spawn_ai();

	chandelier_setup();
	magic_rpg_setup();
	whitehouse_rappel_setup();
	sandbag_group_setup( "sandbag_group" );
	sandbag_group_setup( "sandbag_entrance_group" );
	whitehouse_mg_setup();

	wait .2; // only needed for the start point to work as it should.

	array_thread( level.team, ::whitehouse_team );
	level.foley thread whitehouse_foley();
	level.dunn thread whitehouse_dunn();

	level thread whitehouse_dialogue();
	level thread whitehouse_radio();
	level thread whitehouse_radio_loop();

	level.player.ignoreme = true;
	flag_wait( "whitehouse_moveout" );
	level.player.ignoreme = false;

	battlechatter_on( "allies" );

	flag_wait( "whitehouse_spotlight" );
	thread maps\_weather::rainlight( 5 );

	level thread whitehouse_spotlight();
	level thread whitehouse_drone_slaughter();

	whitehouse_entrance();
}

endpart_objective()
{
	flag_wait( "tunnels_teleport_done" );

	if( isdefined( level.objnum ) )
		objective_state( level.objnum, "done" );

	flag_wait( "whitehouse_moveout" );
		
	pos = getstruct( "objective_entrance", "targetname" );
	Objective_Add( 10, "current", &"DCEMP_OBJ_BREACH_WH", pos.origin );

	pos = getstruct( "objective_breach", "targetname" );
	Objective_Position( 10, pos.origin );

	flag_wait( "whitehouse_radio" );
	Objective_state( 10, "done" );

	flag_wait( "whitehouse_flare_obj" );

	pos = getstruct( "objective_roof", "targetname" );
//	Objective_Add( 11, "current", &"DCEMP_OBJ_DEPLOY_FLARE", pos.origin );
	Objective_Add( 11, "current", &"DCEMP_OBJ_DEPLOY_FLARE" );
	objective_onentity( 11, level.foley, ( 0,0,70 ) );

	flag_wait( "whitehouse_30sec" );
	wait 2;
	Objective_Position( 11, pos.origin );

	flag_wait( "whitehouse_pop_flare" );
	Objective_Ring( 11 );

	flag_wait( "whitehouse_hammerdown_jets_safe" );
	wait 10;
	Objective_state( 11, "done" );

	flag_wait( "whitehouse_completed" );

	if ( is_default_start() )
	{
		nextmission();
	}
	else
		IPrintLnBold( "DEVELOPER: END OF SCRIPTED LEVEL" );
}

whitehouse_dialogue()
{
	wait 0.5;
	level thread whitehouse_nag();

	// Keep hitting 'em with the Two-Forty Bravos! Get more men moving on the left flank! 
	level.marshall dialogue_queue( "dcemp_cml_moremen" );	

	flag_wait( "whitehouse_entrance_init" );

	//We need to punch through right here!
	level.foley dialogue_queue( "dcemp_fly_punchthrough" );	
	//Take out those machine guns!
	level.foley dialogue_queue( "dcemp_fly_machineguns" );	

	flag_wait( "whitehouse_entrance_clear" );

	//Ramirez, let's go! 
	level.foley dialogue_queue( "dcemp_fly_ramirezgo" );	

	flag_wait( "whitehouse_radio" );

	// Hey, there's a radio over here! The transmitter's not working, but I'm getting something!
	level.dunn dialogue_queue( "dcemp_cpd_radiooverhere" );	
	flag_set( "whitehouse_radio_done" );

	flag_wait( "whitehouse_2min" );

	// What the hell are they talking about?
	level.dunn dialogue_queue( "dcemp_cpd_talkingabout" );	

	thread flag_set_delayed( "whitehouse_flare_obj", 1.5 );

	//Hammer Down means they're gonna flatten the city - we gotta get to the roof and stop 'em! 
	level.foley dialogue_queue( "dcemp_fly_flattenthecity" );	

	//We got less than two minutes, let's go!
	level.foley dialogue_queue( "dcemp_fly_lessthantwomins" );	

	flag_wait( "whitehouse_90sec" );
	// 90 seconds! We got to push through.
	level.foley dialogue_queue( "dcemp_fly_90seconds" );

	flag_wait( "whitehouse_1min" );
	// One minute! Go go go!
	level.foley dialogue_queue( "dcemp_fly_60seconds" );

	flag_wait( "whitehouse_30sec" );
	// 30 seconds! We gotta get to the roof now!! Go! Go!
	level.foley dialogue_queue( "dcemp_fly_30seconds" );

}

whitehouse_radio_broadcast( soundalias )
{
	flag_set( "broadcast" );

	radio_array = SortByDistance( level.radio_array, level.player.origin );
	play_count = 1; // 3

	radio = undefined;
	for ( i=0; i<radio_array.size; i++ )
	{	
		// distance above or below player
		dist = abs( level.player.origin[2] - radio_array[i].origin[2] );
		if ( dist > 256 )
			continue;

		radio =  radio_array[i];
		radio PlaySound( soundalias, "sounddone" );

		play_count--;
		if ( !play_count )
			break;
	}
	assert( isdefined( radio ) );
	radio waittill( "sounddone" );
	flag_clear( "broadcast" );
}

whitehouse_radio_loop()
{
	level endon( "broadcast_terminate" );
	flag_wait( "whitehouse_entrance_lobby" );

	while( true )
	{
		flag_clear( "broadcast_end" );

		flag_waitopen( "broadcast_pause" );
		// This is Cujo-Five-One to any friendly units in D.C.: Hammer Down is in effect, I repeat, Hammer Down is in effect. 
		whitehouse_radio_broadcast( "dcemp_fp1_hammerdown" );

		flag_waitopen( "broadcast_pause" );
		// If you can receive this transmission, you are in a hardened high-value structure. 
		whitehouse_radio_broadcast( "dcemp_fp1_highvalue" );

		flag_waitopen( "broadcast_pause" );
		// Deploy green flares on the roof of this structure to indicate you are still combat effective. 
		whitehouse_radio_broadcast( "dcemp_fp1_greenflares" );

		flag_waitopen( "broadcast_pause" );
		// We will abort our mission on direct visual contact with this countersign. 
		whitehouse_radio_broadcast( "dcemp_fp1_willabort" );

		flag_set( "broadcast_end" );
		wait 0.05;	// lets other threads react to flags
	}
}

countdown_trigger()
{
	self waittill( "trigger" );
	if ( self.script_index == level.countdown_index )
	{
		flag_set( "countdown" );
		if ( self.script_index == 2 )
			autosave_by_name( "whitehouse_parlor" );
	}
}

countdown_timeout()
{
	level endon( "countdown" );
	wait 30;
	flag_set( "countdown" );
}

whitehouse_radio()
{
	level endon( "whitehouse_hammerdown" );

	level.radio_array = getentarray( "radio_origin", "targetname" );

	flag_wait( "whitehouse_entrance_lobby" );

	level.countdown_index = 0;

	triggers = getentarray( "countdown_trigger", "targetname" );
	array_thread( triggers, ::countdown_trigger );

	level.hammerdown_time = gettime() + 120 * 1000;

	countdown_line = [];
	countdown_line[0] = "dcemp_fp1_2minutes";
	countdown_line[1] = "dcemp_fp1_90secs";
	countdown_line[2] = "dcemp_fp1_1minute";
	countdown_line[3] = "dcemp_fp1_30secs";

	countdown_flag = [];
	countdown_flag[0] = "whitehouse_2min";
	countdown_flag[1] = "whitehouse_90sec";
	countdown_flag[2] = "whitehouse_1min";
	countdown_flag[3] = "whitehouse_30sec";

// whitehouse_1min
	flag_wait( "whitehouse_radio_done" );

	flag_set( "whitehouse_interior" );

	start_time = gettime();

	while( true )
	{
		level.countdown_index++;

		flag_set( "broadcast_pause" );
		flag_waitopen( "broadcast" );

		println( "***********************************" );
		println( "********** COUNTDOWN: " + elapsed_time( start_time ) + " **********" );
		println( "***********************************" );
		level whitehouse_radio_broadcast( countdown_line[ level.countdown_index - 1 ] );
		start_time = gettime();

		// set countdown flags
		flag_set( countdown_flag[ level.countdown_index - 1 ] );

		if ( level.countdown_index == 4 )
			break;

		level thread countdown_timeout();
		wait 6;
		flag_clear( "broadcast_pause" );

		flag_wait( "countdown" );
		flag_clear( "countdown" );
	}

	// 30 seconds to go ...
	flag_set( "whitehouse_hammerdown_jets" );

	flag_wait( "whitehouse_hammerdown_jets_fly" );

	//(garble)...target package Whiskey Hotel Zero-One has been authorized....roger...passing IP Buick...standby…
	level thread whitehouse_radio_broadcast( "dcemp_fp1_beenauthorized" );

	flag_wait( "whitehouse_hammerdown_jets_safe" );

	wait 2.5;

	// Countersign detected at the Whiskey Hotel! Abort abort!!
	whitehouse_radio_broadcast( "dcemp_fp1_abortabort" );
	//We got a countersign! Abort mission!
	whitehouse_radio_broadcast( "dcemp_fp2_abortmission" );
	//Aborting weapons release! Rolling out!
	whitehouse_radio_broadcast( "dcemp_fp3_rollingout" );
	//Roger, weapons on safe! Aborting mission!
	whitehouse_radio_broadcast( "dcemp_fp4_abortingmission" );
	// Cujo 5-1 to friendly ground units at the Whiskey Hotel - that was a close one. 
	whitehouse_radio_broadcast( "dcemp_fp1_closeone" );
	//We're sending word back to HQ, stay alive down there. Cujo 5-1 out.
	whitehouse_radio_broadcast( "dcemp_fp1_wordtohq" );
}

whitehouse_hammerdown_jet_safe()
{
	level endon( "whitehouse_hammerdown" );

	level.jets = [];
	array_spawn_function_noteworthy( "hammer_down_jet", ::whitehouse_hammerdown_jet  );

	flag_wait( "whitehouse_hammerdown_jets_safe" );
	activate_trigger_with_targetname( "hammer_down_jet_safe_trigger" );
	foreach( jet in level.jets )
	{
		jet delete();
	}
}

whitehouse_hammerdown_jet()
{
	level.jets[ level.jets.size ] = self;
}

whitehouse_hammerdown()
{
	level thread whitehouse_hammerdown_jet_safe();
	level thread whitehouse_early_bombs();

	flag_wait( "whitehouse_hammerdown_jets" );

	flag_wait_or_timeout( "whitehouse_hammerdown_jets_fly", 15 );
	flag_set( "whitehouse_hammerdown_jets_fly" );

	activate_trigger_with_targetname( "hammer_down_jet_trigger" );

	level endon( "whitehouse_hammerdown_stopped" );
	wait 21; // old 11 seconds added 10 seconds.

	flag_set( "whitehouse_hammerdown" );

	wait 3;
	flag_set( "whitehouse_hammerdown_started" );

	// Bombs away bombs away.
	whitehouse_radio_broadcast( "dcemp_fp1_bombsaway" );
	wait 2;

	exploder( "carpetbomb" );

	earthquake( 0.1, 1, level.player.origin, 512 );
	wait 0.5;
	earthquake( 0.2, 1, level.player.origin, 512 );
	wait 0.5;
	earthquake( 0.4, 1, level.player.origin, 512 );
	wait 0.5;
	earthquake( 0.6, 3, level.player.origin, 512 );
	wait .75;

	level notify( "whitehouse_hammerdown_death" );

	PlayFX( level._effect[ "carpetbomb" ], level.player.origin );
	level.player PlaySound( "explo_metal_rand" );
	wait 0.5;

	level.foley stop_magic_bullet_shield();
	level.dunn stop_magic_bullet_shield();

	level.foley kill();
	level.dunn kill();

	level.player kill();
	waittillframeend;
	setDvar( "ui_deadquote", &"DCEMP_FLARE_DEADQUOTE" );
}

whitehouse_early_bombs()
{
	flag_wait( "whitehouse_pop_flare" );
	exploder( "early_bomb_2" );
	wait 2;
	exploder( "early_bomb_3" );
	wait 1.5;
	exploder( "early_bomb" );
}

whitehouse_nag()
{
	level endon( "whitehouse_entrance_init" );

	flag_wait( "whitehouse_briefing_end" );

	while( true )
	{
		wait 6;

		//Work your way to the left!!
		level.foley dialogue_queue( "dcemp_fly_workyourwayleft" );	
		wait 3;

		//Ramirez, let's go! 
		level.foley dialogue_queue( "dcemp_fly_ramirezgo" );	
		wait 8;
	
		//Move up! We gotta take the left flank!
		level.foley dialogue_queue( "dcemp_fly_takeleftflank" );	

		wait 6;
	}
}

whitehouse_team()
{
	if ( self is_hero() )
		return;

	self endon( "death" );

	self.ignoreme = true;
	self.ignoreall = true;

	node_arr = getnodearray( "marine_node", "targetname" );
	node = random( node_arr );
	self setgoalnode( node );

	flag_wait( "whitehouse_moveout" );
	self.ignoreme = false;
	self.ignoreall = false;
	self set_fixednode_false();

	self stop_magic_bullet_shield();
	self setgoalentity( level.dunn );
	self.goalradius = 512;

	flag_wait( "whitehouse_entrance_init" );
	self setgoalentity( level.dunn );
	self setgoalpos( self.origin );

	flag_wait( "whitehouse_breached" );
	wait 2;
	self delete();
}

whitehouse_briefing( animent )
{
//	level endon( "whitehouse_moveout" );

	guys = [];
	guys[0] = level.foley;
	guys[1] = level.marshall;

	animent anim_single( guys , "DCemp_whitehouse_briefing" );

	flag_set( "whitehouse_briefing_end" );
//	flag_set( "whitehouse_moveout" );
}

whitehouse_foley()
{
	self disable_ai_color();
	self.ignoreme = true;
	self.ignoreall = true;

	wait 0.5;

	node = getnode( "foley_briefing_approach_node", "targetname" );
	self.goalradius = node.radius;
	self setgoalnode( node );
	self waittill( "goal" );

	animent = getent( "whitehouse_briefing_ent", "targetname" );
	animent anim_reach_solo( self, "DCemp_whitehouse_briefing" );

	level thread whitehouse_briefing( animent );

	flag_wait( "whitehouse_moveout" );
//	self anim_stopanimscripted();

	start_node = getnode( "foley_whitehouse_path", "targetname" );
	self thread maps\_spawner::go_to_node( start_node );

	self.ignoreme = false;
	self.ignoreall = false;

	flag_wait( "whitehouse_entrance_init" );
	old_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;

	flag_wait( "whitehouse_breached" );
	self.grenadeawareness = old_awareness;
//	self forceUseWeapon( "mp5", "primary" );
	wait 2;

	flag_wait( "whitehouse_radio" );

	// turn off cqb so that the guy will idle at idle node.
	self.neverenablecqb = true;
	self disable_cqbwalk();
	self.ignoreme = true;
	self.ignoreall = true;

	flag_wait( "whitehouse_flare_obj" );

	self notify( "stop_going_to_node" );

	door = getent( "whitehouse_kitchen_door", "targetname" );
	parts = getentarray( door.target, "targetname" );
	array_call( parts, ::linkto, door );

	// kick open kitchen door
	animent = getent( "whitehouse_kitchen_kick", "targetname" );
	animent anim_generic_reach( level.foley, "doorburst_wave" );
	animent thread anim_generic_gravity( level.foley, "doorburst_wave" );
	door thread door_open_kick();

	start_node = getnode( "foley_kitchen_path", "targetname" );
	self thread maps\_spawner::go_to_node( start_node );
	self.neverenablecqb = undefined;
	self enable_cqbwalk();
	self.ignoreme = false;
	self.ignoreall = false;

	// trying to not make him stop in the kitchen
//	self.pushable = false;
//	self pushplayer( true );
	self set_ignoreSuppression( true );
	self set_fixednode_false();  // this one seemed to do it

	flag_wait( "whitehouse_path_elevator" );

	// reset stuff trying to not make him stop in the kitchen
//	self pushplayer( false );
//	self.pushable = true;
	self set_ignoreSuppression( false );
	self set_fixednode_true();

	self thread whitehouse_foley_flare();
}

whitehouse_foley_flare()
{
	alt_animent = getent( "whitehouse_foley_flare_alt", "targetname" );
	animent = getent( "whitehouse_foley_flare", "targetname" );
	volume = getent( animent.target, "targetname" );

	flag_wait( "whitehouse_hammerdown_jets_safe" );
	
	if ( level.player istouching( volume ) )
		animent = alt_animent;

	animent anim_single_solo( self, "flare_moment_stand" );
	self notify( "remove_flare" );

	self.neverenablecqb = true;
	self disable_cqbwalk();
}

whitehouse_dunn()
{
	self disable_ai_color();
	self.ignoreme = true;
	self.ignoreall = true;

	wait 0.8;

	start_node = getnode( "dunn_whitehouse_path", "targetname" );
	self thread maps\_spawner::go_to_node( start_node );

	flag_wait( "whitehouse_moveout" );
	self.ignoreme = false;
	self.ignoreall = false;
	self.neverenablecqb = true;
	self disable_cqbwalk();

	flag_wait( "whitehouse_entrance_init" );
	old_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;

	flag_wait( "whitehouse_breached" );
	self.grenadeawareness = old_awareness;

	// turn off cqb so that the guy will idle at idle node.
	flag_wait( "whitehouse_radio" );
	self.ignoreme = true;
	self.ignoreall = true;

	flag_wait( "whitehouse_flare_obj" );
	self.neverenablecqb = undefined;
	self enable_cqbwalk();
	self.ignoreme = false;
	self.ignoreall = false;

	flag_wait( "whitehouse_pop_flare" );
	self.neverenablecqb = true;
	self disable_cqbwalk();
	self.ignoreme = true;
	self.ignoreall = true;
}

whitehouse_marshall()
{
	self.animname = "marshall";
	self.ignoreme = true;
	self.ignoreall = true;
	level.marshall = self;
	self magic_bullet_shield();

	animent = getent( "whitehouse_briefing_ent", "targetname" );
	animent thread anim_first_frame_solo( self, "DCemp_whitehouse_briefing" );

	flag_wait( "whitehouse_briefing_end" );

	animent thread anim_first_frame_solo( self, "DCemp_whitehouse_briefing" );

//	self anim_stopanimscripted();

	self stop_magic_bullet_shield();
	self.ignoreme = false;
	self.ignoreall = false;
}

whitehouse_entrance()
{
	flag_wait( "whitehouse_entrance_moveup" );
	level thread whitehouse_cleanup_approach();

	flag_wait( "whitehouse_entrance_init" );
	autosave_by_name( "entrance" );

	entrance_mg = getent( "west_side_mg", "script_noteworthy" );

	entrance_mg thread manual_mg_init();
//	sandbag_group_setup( "sandbag_entrance_group" );

	flag_wait( "whitehouse_entrance_clear" );

	battlechatter_off( "allies" );

	thread maps\_weather::rainNone( 5 );

	flag_wait( "whitehouse_breached" );

	activate_trigger_with_targetname( "drone_war_trigger" );

	flag_wait( "whitehouse_flare_obj" );

	whitehouse_interior();
}

whitehouse_interior()
{
	autosave_by_name( "interior" );

	set_group_advance_to_enemy_parameters( 45, 1 );
	reset_group_advance_to_enemy_timer( "axis" );

	level.foley enable_heat_behavior( true );
	level.dunn enable_heat_behavior( true );

	level thread whitehouse_hammerdown();

	setsaveddvar( "ai_friendlysuppression", 0 );
	setsaveddvar( "ai_friendlyfireblockduration", 0 );

	flag_wait( "whitehouse_path_elevator" );
	battlechatter_on( "allies" );

	flag_wait( "whitehouse_chandelier" );
	source_ent = getent( "chandelier_grenade_source", "targetname" );
	target_ent = getent( source_ent.target, "targetname" );
	MagicGrenade( "fraggrenade", source_ent.origin, target_ent.origin, 1.5 );

	flag_wait( "whitehouse_path_office_2" );
	thread maps\_weather::rainlight( 8 );

	flag_wait( "whitehouse_pop_flare" );

	level.foley disable_heat_behavior();
	level.dunn disable_heat_behavior();
}

whitehouse_drone()
{
	self endon( "death" );

	if ( !isdefined( level.whitehouse_drone_array ) )
		level.whitehouse_drone_array = [];
	level.whitehouse_drone_array[ level.whitehouse_drone_array.size ] = self;

	self.health = 10000;

	flag_wait( "whitehouse_silhouette_ready");

	if ( isdefined( self.script_animation ) )
		self.deathanim = level.drone_death_anims[ self.script_animation ];

	self.health = 200;
}

whitehouse_filler_drone()
{
	self endon( "death" );

	self.health = 1000;
	flag_wait( "whitehouse_breached" );
	wait randomfloat( 5 );
	self delete();
}

whitehouse_drone_war_drone()
{
	self endon( "death" );

	flag_wait( "whitehouse_path_roof" );
	wait randomfloat( 5 );
	self delete();
}

start_flare()
{
	maps\dcemp::start_common_dcemp();
	flag_set( "end_fx" );
	
	vision_set_whitehouse();
	level.sky delete();

	emp_teleport_team( level.team, getstructarray( "flare_start_points", "targetname" ) );
	emp_teleport_player();

	whitehouse_flags();

	start_node = getnode( "dunn_flare_path", "script_noteworthy" );
	level.dunn thread maps\_spawner::go_to_node( start_node );
	start_node = getnode( "foley_flare_path", "script_noteworthy" );
	level.foley thread maps\_spawner::go_to_node( start_node );

	level thread whitehouse_hammerdown();

	level thread whitehouse_radio();

	flag_set( "whitehouse_entrance_lobby" );
	wait 0.1;
	level.countdown_index = 3;
	flag_set( "whitehouse_radio_done" );
	flag_clear( "broadcast" );

	level.foley thread whitehouse_foley_flare();

	flag_wait( "whitehouse_hammerdown_jets_safe" );

	level.dunn.neverenablecqb = true;
	level.dunn disable_cqbwalk();
}

flare_main()
{
	level thread flare_dialogue();

	flag_wait( "whitehouse_pop_flare" );
	level.player thread whitehouse_player_flare();

	// stops iss from running when this thread ends.
	level waittill( "wtf_is_this_for" );
}

flare_dialogue()
{
	flag_wait( "whitehouse_hammerdown_jets_fly" );
	flag_wait_or_timeout( "whitehouse_pop_flare", 14 );

	// Pop the flares!!
	level.foley dialogue_queue( "dcemp_fly_poptheflares" );	
	flag_set( "whitehouse_pop_flare" );

	flag_wait( "whitehouse_wrapup" );

	// What happens now?
	level.dunn dialogue_queue( "dcemp_cpd_happensnow" );	
	//This war ain't over yet Corporal...all we did was level the playing field. 
	level.foley dialogue_queue( "dcemp_fly_waraintover" );	
	//Everyone downstairs. Let's try and get the transmitter working on that radio. 
	level.foley dialogue_queue( "dcemp_fly_backdownstairs" );	

	flag_set( "whitehouse_completed" );
}

whitehouse_player_flare()
{
	level endon( "whitehouse_hammerdown_started" );

	player_attached_use( &"SCRIPT_PLATFORM_HINTSTR_POPFLARE" );

	while( !level.player IsOnGround() )
		wait 0.05;

	lerp_time = 0.5;
	enablePlayerWeapons( false );
	level.player.rig = spawn_anim_model( "flare_rig", level.player.origin );
	level.player.rig hide();
	level.player.rig.angles = ( 0,180,0 );
	level.player.rig anim_first_frame_solo( level.player.rig, "flare");

	if ( !flag( "whitehouse_hammerdown" ) )
		flag_set( "whitehouse_hammerdown_stopped" );

	// get rid of the flare and release the player when he should die.
	level thread whitehouse_player_flare_death();

	level.player PlayerLinkToBlend( level.player.rig, "tag_player", lerp_time );
	wait lerp_time;
	level.player PlayerLinkToDelta( level.player.rig, "tag_player", 1, 20, 20, 20, 20 );

	movement_ent = level.player.rig spawn_tag_origin();
	movement_ent thread steer_player_rig();
	level.player.rig linkto( movement_ent );

	level.player.rig thread player_flare();
	level.player.rig show();
	movement_ent anim_single_solo( level.player.rig, "flare");

	flag_set( "flare_end_fx" );

	level.player Unlink();
	level.player.rig delete();
	enablePlayerWeapons( true );

	wait 3;
	flag_set( "whitehouse_wrapup" );
}

steer_player_rig()
{
	level endon( "flare_end_fx" );

	moveRate = 3;

	box1 = make_box( "flare_box1" );
	box2 = make_box( "flare_box2" );

	z_origin = level.player.origin[2];
	while( true )
	{
		wait( 0.05 );

		movement = level.player GetNormalizedMovement();
		//iprintlnbold( movement[ 0 ] + " : " + movement[ 1 ] );
		
		forward = anglesToForward( level.player.angles );
		right = anglesToRight( level.player.angles );
		
		forward *= movement[ 0 ] * moveRate;
		right *= movement[ 1 ] * moveRate;
		
		newLocation = level.player.origin + forward + right;
		newLocation = ( newLocation[ 0 ], newLocation[ 1 ], z_origin );

		if ( inside_box( newLocation, box1 ) || inside_box( newLocation, box2 ) )
			self MoveTo( newLocation, 0.05 );
	}
}

inside_box( new_origin, box )
{
	x = new_origin[0];
	y = new_origin[1];

	if ( x > box[0][0] )
		return false;
	if ( y > box[0][1] )
		return false;
	if ( x < box[1][0] )
		return false;
	if ( y < box[1][1] )
		return false;

	return true;
}

make_box( targetname_str )
{
	box = [];
	top = getstruct( targetname_str, "targetname" );
	bottom = getstruct( top.target, "targetname" );
	box[0] = top.origin;
	box[1] = bottom.origin;
	return box;
}

whitehouse_player_flare_death()
{
	level waittill( "whitehouse_hammerdown_death" );

	level.player Unlink();
	level.player.rig delete();
	enablePlayerWeapons( true );
}
*/

tunnels_flags()
{
	flag_init( "tunnels_teleport_done" );
	flag_init( "tunnels_teleport" );
	flag_init( "tunnels_door_open" );
	flag_init( "tunnels_door_open_done" );
	
	if( !flag_exist( "dc_emp_bunker" ) )
		flag_init( "dc_emp_bunker" );
}

tunnels_main()
{
	level.cosine[ "60" ] = cos( 60 );

	tunnels_flags();

	level.drone_spawn_func = ::simple_drone_init;

	array_spawn_function_noteworthy( "tunnels_dead_guy", ::tunnels_dead_guy  );
	array_spawn_function_noteworthy( "tunnels_dead_check", ::tunnels_dead_check  );
//	array_spawn_function_noteworthy( "tunnel_filler_drone", ::whitehouse_filler_drone  );
//	array_spawn_function_noteworthy( "tunnels_wave_guy", ::tunnels_wave_guy  );
//	array_spawn_function_noteworthy( "tunnels_twirl_guy", ::tunnels_twirl_guy  );

	wait 0.2;

	add_wait( ::trigger_wait_targetname, "tunnels_first_color_trig" );
	add_func( ::vision_set_tunnels );
	thread do_wait();

//	array_thread( level.team, ::disable_ai_color );

	level thread tunnels_door_scene();

	flag_wait( "tunnels_main" );

//	level thread endpart_objective();
	level thread tunnels_dialogues();

	force_flash_setup();

	thread battlechatter_off( "allies" );

	level.team[ "marine1" ] set_force_color( "g" );
	level.foley set_force_color( "y" );
	level.dunn set_force_color( "o" );

	if ( !flag( "tunnels_indoor" ) )
		activate_trigger_with_targetname( "tunnels_color_trigger" );

	level thread tunnels_rain();
	level thread tunnels_end();

	flag_wait( "tunnels_foley_dialogue" );
	delayThread( 9, maps\_ambient::set_ambience_blend_over_time, 6, "dcemp_heavy_rain_int", "dcemp_heavy_rain_tunnel" );

	flag_wait_either( "tunnels_door_open", "tunnels_teleport_done" );
	if ( flag( "tunnels_door_open" ) )
	{
		activate_trigger_with_targetname( "pre_teleport_color_trigger" );
		level.foley delayThread( 7, ::enable_ai_color );
		level.dunn delayThread( 4, ::enable_ai_color );
	}

	level waittill( "wait_for_ever" );
}

tunnels_end()
{
	trigger = getent( "tunnels_teleport_trigger", "targetname" );
	trigger waittill( "trigger" );

	wait 1;

	maps\_loadout::SavePlayerWeaponStatePersistent( "dcemp" );

	if ( is_default_start() )
	{
		nextmission();
	}
	else
		IPrintLnBold( "DEVELOPER: END OF SCRIPTED LEVEL" );
}

tunnels_rain()
{
	flag_wait( "tunnels_indoor" );
	flag_clear( "_weather_lightning_enabled" );
//	maps\_weather::rainlight( 2 );

//	flag_wait_or_timeout( "tunnels_dunn_anim_end", 5 );
//	maps\_weather::rainNone( 2 );

	flag_wait( "tunnels_teleport_done" );
	flag_set( "_weather_lightning_enabled" );
//	maps\_weather::rainHard( 5 );
}

tunnels_door_scene()
{
	level endon( "tunnels_teleport" );

	anim_ent = getent( "tunnel_door_animent", "targetname" );
	door_ent = tunnels_door_setup( anim_ent );

	flag_wait( "tunnels_main" );
	flag_wait( "tunnels_door_start" );
	level thread tunnels_friendlies_teleport();

	guys = [];
	guys[0] = level.dunn;
	guys[1] = door_ent;

	level thread  tunnels_door_scene_interrupt( anim_ent );

	level.dunn walkdist_zero();
	level.foley walkdist_zero();
	
	anim_ent anim_reach_solo( level.foley, "DCemp_door_sequence_foley_approch" );
	anim_ent add_func( ::anim_single_solo , level.foley , "DCemp_door_sequence_foley_approch" );
	anim_ent add_func( ::anim_loop_solo , level.foley , "DCemp_door_sequence_foley_idle", "foley_idle_end" );
	level thread do_funcs();

	anim_ent anim_reach_solo( level.dunn, "DCemp_door_sequence" );
	anim_ent anim_single( guys , "DCemp_door_sequence" );

	flag_set( "tunnels_door_open" );

	anim_ent notify( "foley_idle_end" );
	anim_ent thread anim_single_solo( level.foley, "DCemp_door_sequence_foley_wave" );
	level.foley setgoalpos( level.foley.origin );
}

tunnels_door_scene_interrupt( anim_ent )
{
	flag_wait( "tunnels_teleport" );
	anim_ent notify( "foley_idle_end" );

	level.dunn anim_stopanimscripted();
	level.foley anim_stopanimscripted();
}

tunnels_door_setup( anim_ent )
{
	anim_ent_2 = getent( "tunnel_door_animent_2", "targetname" );

	door_ent = spawn_anim_model( "tunnel_door", anim_ent.origin );
//	door_ent_2 = spawn_anim_model( "tunnel_door", anim_ent_2.origin );
//	door_ent_2.angles += (0,-90,0);

	brush_door = getent( "tunnel_door", "targetname" );
	brush_door linkto( door_ent );
//	brush_door_2 = getent( "tunnel_door_2", "targetname" );
//	brush_door_2 linkto( door_ent_2 );

	brush_door connectpaths();

	anim_ent anim_first_frame_solo( door_ent, "DCemp_door_sequence" );
//	anim_ent_2 thread anim_single_solo( door_ent_2, "DCemp_door_sequence" );

	return door_ent;
}

tunnels_friendlies_teleport()
{
	flag_wait( "tunnels_door_teleport" );

	foley_dest = getstruct( "tunnels_door_foley", "script_noteworthy" );
	dunn_dest = getstruct( "tunnels_door_dunn", "script_noteworthy" );

	volume = getent( "tunnels_door_volume", "targetname" );
	if ( !level.foley IsTouching( volume ) )
		level.foley ForceTeleport( foley_dest.origin, foley_dest.angles );
	if ( !level.dunn IsTouching( volume ) )
		level.dunn ForceTeleport( dunn_dest.origin, dunn_dest.angles );
}

tunnels_dialogues()
{
	flag_wait( "tunnels_indoor" );
	// Feet dry.
	level.team["marine1"] dialogue_queue( "dcemp_ar1_feetdry" );

	wait 0.5;
	// Huah.
	level.dunn dialogue_queue( "dcemp_cpd_huah3" );

	// Cut the chatter. Ramirez, take point.
	level.foley dialogue_queue( "dcemp_fly_cutchatter" );

	flag_wait( "tunnels_door_start" );
	flag_set( "dc_emp_bunker" );
	
	// time out for safety sake
	level.dunn waittill_any_timeout( 4, "goal" );

	// Dunn's dialogue is played from notetracks =
	// the flag below is set through notetrack in Dunn's animation
	flag_wait( "tunnels_foley_dialogue" );
	
	wait .65;
	// No, that's just for tourists. This must be the real thing. Open it up.
	level.foley dialogue_queue( "dcemp_fly_fortourists" );

	flag_wait( "tunnels_teleport_done" );
	wait 0.5;

	flag_wait( "whitehouse_ambience" );
	// Sounds like the party's already started.
	level.dunn dialogue_queue( "dcemp_cpd_partystarted" );

	// Roger that. Stay frosty.
	level.foley dialogue_queue( "dcemp_fly_rogerstayfrosty" );	
}

/*
tunnels_wave_guy()
{
	node = getnode( self.target, "targetname" );
	node thread anim_generic_loop( self, "wave_on" );

	flag_wait( "tunnels_wave_guy" );

	while( !flag( "whitehouse_init" ) )
	{
		self generic_dialogue_queue( "dcemp_ar3_hustleup" );
		wait randomfloatrange( 3, 5 );
		self generic_dialogue_queue( "dcemp_ar3_thisway" );
		wait randomfloatrange( 3, 5 );
		self generic_dialogue_queue( "dcemp_ar3_movemove" );
		wait randomfloatrange( 10, 20 );
	}

	flag_wait( "whitehouse_moveout" );
	self delete();
}

tunnels_twirl_guy()
{
	animent = getent( "tunnels_twirl_animent", "targetname" );

	self walkdist_zero();
	animent anim_generic_reach( self, "combatwalk_F_spin" );

	// Let's go! Let's go! 
//	self thread generic_dialogue_queue( "dcemp_ar2_letsgo" );

	animent anim_generic( self, "combatwalk_F_spin" );
	self enable_ai_color();
	self walkdist_reset();
}
*/

tunnels_dead_guy()
{
	self remove_drone_weapon();
	animent = getent( self.target, "targetname" );
	animent anim_generic_first_frame( self, "death_sitting_pose_v1" );

	flag_wait( "tunnels_dunn_anim_end" );
	self delete();
}

tunnels_dead_check()
{
	level endon( "tunnels_teleport" );
	level endon( "tunnels_dunn_anim_end" );

	self.animname = "dead_guy";
	self remove_drone_weapon();

	animent = getent( self.target, "targetname" );
	animent thread anim_loop_solo( self, "hunted_woundedhostage_idle_start" );

	level thread tunnels_dead_check_clear( self, animent );

	flag_wait( "tunnels_main" );
	wait 0.1;
	flag_wait( "tunnels_dead_check" );

	level.dunn disable_ai_color();
	level.dunn walkdist_zero();
	
	animent anim_reach_solo( level.dunn, "hunted_woundedhostage_check" );
	animent anim_stopanimscripted(); // stops the loop anim for the dead dude

	guys = [];
	guys[0] = level.dunn;
	guys[1] = self;
	
	level.dunn walkdist_reset();
	
	animent anim_single( guys, "hunted_woundedhostage_check" );
	animent thread anim_first_frame_solo( self, "hunted_woundedhostage_idle_end" );

	level.dunn enable_ai_color();
	animent anim_single_solo( level.dunn, "hunted_woundedhostage_check_soldier_end" );
	level notify( "tunnels_dead_check_done" );
}

tunnels_dead_check_clear( drone, animent )
{
	level endon( "tunnels_dead_check_done" );

	flag_wait( "tunnels_dunn_anim_end" );
	level.dunn anim_stopanimscripted();
	if ( flag( "tunnels_main" ) )
		level.dunn enable_ai_color();

	drone anim_stopanimscripted();
	animent anim_stopanimscripted();
	drone delete();
}

vision_set_tunnels()
{
	flag_clear( "spotlight_lightning" );
	thread lerp_saveddvar( "r_specularColorScale", 2.5, 2 ); 
	lights = getentarray( "parking_lighting_primary", "script_noteworthy" );
	array_call( lights, ::setLightIntensity, 0 );
	
	thread maps\_utility::set_vision_set( "dcemp_tunnels", 4 );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_tunnels", 4 );
}