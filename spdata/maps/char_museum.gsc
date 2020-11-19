#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\char_museum_code;
#using_animtree( "generic_human" );

main()
{		
	level.GLOBAL_ANIM_SPEED = .65;
	level.guys = [];
	level.activeRoom = "none";
	level.anim_ai = [];
	level.panic_guys = 0;
	level.pmc_alljuggernauts = true;

	flag_init( "do_museum_credits" );
	flag_init( "panic_button" );	
	flag_init( "fade_from_black" );
	flag_init( "looked_at_big_board" );
	flag_init( "museum_ready" );
	flag_init( "spawn_room1_civs" );
	flag_init( "af_caves_done" );
	flag_init( "dc_burning_done" );
	flag_init( "airport_done" );
	flag_init( "cliffhanger_done" );
	flag_init( "favela_done" );
	flag_init( "oilrig_done" );
	flag_init( "estate_done" );
	flag_init( "hostage_done" );
	flag_init( "arcadia_done" );
	flag_init( "trainer_done" );
				
	switch( level.level_mode )
	{
		case "free":			//-> free roam
			default_start( ::start_free );	
			add_start( "free", 			::start_free, 		"[free_roam]", 			::museum_main );
			setdvar( "start", "" );
			break;
		
		case "credits_black":	//-> coming from menu after never beating game
			maps\_credits::initcredits( "all" );
			level.credits_speed = level.credits_speed * .75;
			default_start( ::start_black );	
			add_start( "black", 		::start_black, 		"[black_credits]", 		::black_main );
			break;
		
		case "credits_1":		//-> coming from af_chase
			maps\_credits::initcredits( "all" );
			break;
		case "credits_2":		//-> coming from menu after beating game
			maps\_credits::initcredits( "all" );
			default_start( ::start_afcaves );	
			break;
	}
				
	add_start( "af_caves", 		::start_afcaves, 	"[af_caves]", 			::afcaves_main );
	add_start( "dc_burning",	::start_dcburning, 	"[dc_burning]", 		::dcburning_main );
	add_start( "airport",		::start_airport, 	"[airport]", 			::airport_main );
	add_start( "cliffhanger",	::start_cliffhanger,"[cliffhanger]", 		::cliffhanger_main );
	add_start( "favela",		::start_favela,		"[favela]", 			::favela_main );
	add_start( "hallway1",		::start_hallway1,	"[hallway1]", 			::hallway1_main );
	add_start( "vehicles",		::start_vehicles,	"[vehicles]", 			::vehicles_main );
	add_start( "hallway2",		::start_hallway2,	"[hallway2]", 			::hallway2_main );
	add_start( "oilrig",		::start_oilrig,		"[oilrig]", 			::oilrig_main );
	add_start( "estate",		::start_estate,		"[estate]",				::estate_main );
	add_start( "hostage",		::start_hostage,	"[hostage]",			::hostage_main );
	add_start( "trainer",		::start_trainer,	"[trainer]",			::trainer_main );
	add_start( "arcadia",		::start_arcadia,	"[arcadia]",			::arcadia_main );
			
	animscripts\dog\dog_init::initDogAnimations();
	maps\char_museum_precache::main();
	maps\char_museum_fx::main();	
	
	PreCacheModel( "ch_viewhands_player_gk_ar15" );
	PreCacheModel( "ch_viewhands_gk_ar15" );

	if( level.level_mode != "credits_1" )
	{
		maps\_load::main();
		//HAS TO COME AFTER _LOAD::MAIN()
		setSavedDvar( "sv_saveOnStartMap", false );
		imagename = "levelshots / autosave / autosave_" + level.script + "start";
		// string not found for AUTOSAVE_LEVELSTART
		SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename, true );
		maps\_load::set_player_viewhand_model( "ch_viewhands_player_gk_ar15" );
	}
	
	maps\_drone_civilian::init();
	maps\_drone_ai::init();
		
	thread post_init();
}

post_init()
{
	if( level.level_mode == "credits_1" )
	{
		flag_wait( "do_museum_credits" );
		thread start_afcaves();
	}
	
	maps\char_museum_anim::main();
			
	thread sign_departure_status();
	array_thread( getentarray( "c4barrelPacks", "script_noteworthy" ), ::c4_packs_think );

	SetSavedDvar( "player_sprintUnlimited", "1" );
	SetSavedDvar( "ui_hidemap", "1" );
		
	level.friendlyFireDisabled = true;	
	thread battlechatter_off();
}



/************************************************************************************************************/
/*													AF_CAVES												*/
/************************************************************************************************************/

afcaves_setup()
{
	level.anim_ai[ "af_caves" ] = [];
	array_thread( getentarray( "ai_af_caves", "script_noteworthy" ), ::add_spawn_function, ::afcaves_ai_setup );
	array_thread( getentarray( "ai_af_caves", "script_noteworthy" ), ::add_spawn_function, ::afcaves_ai_think );		
}

afcaves_main()
{		
	if( level.level_mode == "credits_1" )
	{
		flag_wait( "do_museum_credits" );
		flag_wait( "museum_ready" );
	}
	
	array_thread( getentarray( "civ_af_caves_1", "script_noteworthy" ), ::add_spawn_function, ::afcaves_civ1_think );
	thread afcaves_camera_think();
	
	flag_wait( "af_caves_spawn_civs" );
	array_thread( getentarray( "civ_af_caves_1", "script_noteworthy" ), ::spawn_ai, true );	
	
	flag_wait( "spawn_room1_civs" );
	array_thread( getentarray( "civ_af_caves_2", "script_noteworthy" ), ::spawn_ai, true );	
	
	flag_wait( "af_caves_done" );
	wait 1.25;
	array_thread( getentarray( "civ_af_caves_3", "script_noteworthy" ), ::delaythread, 1.25, ::spawn_ai, true );	
	camera_move( "camara_path_dc_burning", 25 );
}

afcaves_camera_think()
{
	flag_wait( "fade_from_black" );
	
	node = getvehiclenode( "camara_path_af_caves", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );
	level.camera attachpath( node );
	level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	
	wait .5;
	
	level.camera ResumeSpeed( .5 );		
	level.camera waittill( "reached_end_node" );
	camera_move( "camara_path_af_caves2", 6.5 );
		
	level.camera ResumeSpeed( .5 );			
	level.camera waittill( "reached_end_node" );
}

afcaves_civ1_think()
{
	guys = [];
	foreach( ai in level.anim_ai[ "af_caves" ] )
	{
		switch( ai.animation )
		{
			case "training_intro_foley_idle_talk_1":
				guys[ 0 ] = ai;
				break;	
			case "afgan_caves_Price_rappel_idle":
				guys[ 1 ] = ai;
				break;	
			case "casual_stand_v2_twitch_shift":
				guys[ 2 ] = ai;
				break;	
			case "afchase_ending_shepherd_gun_monologue":
				guys[ 3 ] = ai;
				break;	
			case "zodiac_trans_L2R":
				guys[ 4 ] = ai;
				break;	
			case "casual_stand_v2_idle":
				guys[ 5 ] = ai;
				break;	 
		}	
	}
	
	num = 0;
	while( num < 6 )
	{
		wait .05;
		
		p1 = level.player.origin;
		p1 = ( p1[0], p1[1], 0 );
		
		p2 = self.origin;
		p2 = ( p2[0], p2[1], 0 );
		
		p3 = guys[ num ].origin;
		p3 = ( p3[0], p3[1], 0 );
		
		dot = vectordot( vectornormalize( p3 - p1 ), vectornormalize( p2 - p1 ) );
		
		if( dot < .999 )
			continue;
		
		guys[ num ] ent_flag_set( "do_anim" );
		num++;
	}
	
	flag_set( "spawn_room1_civs" );
}

afcaves_ai_setup()
{
	self ai_default_setup( "af_caves" );
	node = self.anim_node;
	
	wait .05;
		
	switch( node.animation )
	{
		case "afchase_ending_shepherd_gun_monologue":
			self.anim_speed = level.GLOBAL_ANIM_SPEED * 1.23;
			break;
		case "zodiac_trans_L2R":
			self.animtime = .28;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			break;
	}
}

afcaves_ai_think()
{	
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "zodiac_trans_L2R":
			self thread ai_zodiac_anims( node.animation );
			break;
		case "afgan_caves_Price_rappel_idle":
			self thread ai_idle( node.animation );
			break;
		case "training_intro_foley_idle_talk_1":
			self thread ai_loop_random( node.animation, "foley_talk" );
			break;
		case "afchase_ending_shepherd_gun_monologue":
			if( isai( self ) )
				ai_wait_current_anim();
			else	
				ai_wait_current_anim( .40 );
			foreach( ent in level.anim_ai[ "af_caves" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "af_caves_done" );	
			break;
		default:
			self thread ai_loop_random( node.animation, "casual_stand" );
			break;
	}
}

ai_zodiac_anims( animation )
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();

	self ai_next_anim( %zodiac_rightside_wave );
	self ai_next_anim( %zodiac_trans_R2L );
	self ai_next_anim( %zodiac_leftside_wave );
	self ai_next_anim( %zodiac_trans_L2R );
}

/************************************************************************************************************/
/*													DC_BURNING												*/
/************************************************************************************************************/
dcburning_setup()
{	
	level.anim_ai[ "dc_burning" ] = [];
	array_thread( getentarray( "ai_dc_burning", "script_noteworthy" ), ::add_spawn_function, ::dcburning_ai_setup );
	array_thread( getentarray( "ai_dc_burning", "script_noteworthy" ), ::add_spawn_function, ::dcburning_ai_think );
}

dcburning_main()
{			
	thread dcburning_camera_think();
	
	flag_wait( "dc_burning_go" );
	wait 2;
	foreach( ent in level.anim_ai[ "dc_burning" ] )
		ent ent_flag_set( "do_anim" );		
	
	array_thread( getentarray( "civ_dc_burning_1", "script_noteworthy" ), ::delaythread, 11, ::spawn_ai, true );	
			
	flag_wait( "dc_burning_done" );	
	array_thread( getentarray( "civ_dc_burning_2", "script_noteworthy" ), ::spawn_ai, true );	
	array_thread( getentarray( "room1_civ_talkers", "targetname" ), ::spawn_ai, true );	
	
	wait 2;
	
	array_thread( getentarray( "civ_dc_burning_3", "script_noteworthy" ), ::spawn_ai, true );	
	array_thread( getentarray( "civ_dc_burning_4", "script_noteworthy" ), ::delaythread, 1.25, ::spawn_ai, true );	
	camera_move( "camara_path_airport_mid", 35 );
	level.camera ResumeSpeed( 5 );
	wait 2;
	camera_move( "camara_path_airport", 45, 0 );
}

dcburning_camera_think()
{
	node = getvehiclenode( "camara_path_dc_burning", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "dc_burning" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

dcburning_ai_setup()
{
	self ai_default_setup( "dc_burning" );
	node = self.anim_node;
	
	wait .05;
		
	switch( node.animation )
	{
		case "training_pit_sitting_welcome":
			self.gun_remove = true;
			self gun_remove();
			self.animtime = .6;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			self.anim_speed = level.GLOBAL_ANIM_SPEED * 1.23;
			self.animplaybackrate = self.anim_speed;
			self.moveplaybackrate = self.anim_speed;
			//self SetAnimTime( getanim_generic( node.animation ), .25 );
			//self dcburning_dunn_gun_setup( node );
			break;
		case "training_intro_foley_begining":
			self.animtime = .64;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			self.anim_speed = level.GLOBAL_ANIM_SPEED * 1.23;
			self.animplaybackrate = self.anim_speed;
			self.moveplaybackrate = self.anim_speed;
			break;
		case "civilian_sitting_talking_A_1":
			self.gun_remove = true;
			self gun_remove();
			break;
		case "riotshield_idle":
			if( !isai( self ) )
				self attach( "weapon_riot_shield", "TAG_WEAPON_LEFT" );
			break;
	}
}

dcburning_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "training_pit_sitting_welcome":
			self thread dcburning_dunn( node.animation );
			break;
		case "training_intro_foley_begining":
			self thread dcburning_foley( node.animation );
			break;
		case "civilian_sitting_talking_A_1":
			self thread ai_idle( node.animation );
			break;
		case "stinger_fire":
			self thread ai_loop_random( node.animation, "rpg" );
		case "casual_crouch_idle":
			self thread ai_loop_random( node.animation, "casual_crouch" );
			break;
		case "riotshield_idle":
			self thread ai_idle( node.animation );
			break;
		default:
			self thread ai_loop_random( node.animation, "casual_stand" );
			break;
	}
}

dcburning_dunn( animation )
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();
		
	//self thread dcburning_dunn_gun( animation );	
	self ai_next_anim( %training_pit_open_case );
	
	//this is important - dont take this out...its to make up for 
	//a sleight frame diference between drone and AI logic where in 
	//on the current_anim gets set one frame too late.
	percent = .41;
	delay = .1;	
	wait delay;

	self ai_wait_current_anim( percent, delay * -1 );			
	
	thread dcburning_dunn_stop();
}

dcburning_dunn_stop()
{
	foreach( ent in level.anim_ai[ "dc_burning" ] )
		ent ent_flag_clear( "do_anim" );	
	flag_set( "dc_burning_done" );	
}

#using_animtree( "script_model" );
dcburning_dunn_gun_setup( node )
{
	self.anim_gun = spawn( "script_model", ( 0, 0, 0 ) );
	self.anim_gun setmodel( "viewmodel_desert_eagle" );
	self.anim_gun.origin = node.origin;
	self.anim_gun.animname = "pit_gun";
	self.anim_gun assign_animtree();
	self.anim_gun set_start_pos( node.animation + "_gun", node.origin, node.angles );
	self.anim_gun _setanim( self.anim_gun getanim( node.animation + "_gun" ), 1, 0, 0 );
}

dcburning_dunn_gun( animation )
{
	self.anim_gun ent_flag_init( "do_anim" );
	self.anim_gun ent_flag_set( "do_anim" );
	self.anim_gun thread ai_current_anim_stop();
	self.anim_gun _setanim( self.anim_gun getanim( animation + "_gun" ), 1, 0, self.anim_speed );
	self.anim_gun.current_anim = self.anim_gun getanim( animation + "_gun" );
	
	self.anim_gun ai_next_anim( %training_pit_open_case_gun );
}
#using_animtree( "generic_human" );

dcburning_foley( animation )
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();

//	self ai_next_anim( %training_intro_foley_turnaround_2 );
//	self ai_next_anim( %training_intro_foley_idle_talk_1 );
	self ai_next_anim( %training_intro_foley_end );
}

/************************************************************************************************************/
/*													AIRPORT													*/
/************************************************************************************************************/
airport_setup()
{	
	level.anim_ai[ "airport" ] = [];
	array_thread( getentarray( "ai_airport", "script_noteworthy" ), ::add_spawn_function, ::airport_ai_setup );
	array_thread( getentarray( "ai_airport", "script_noteworthy" ), ::add_spawn_function, ::airport_ai_think );
}

airport_main()
{			
	thread airport_camera_think();
	
	flag_wait( "airport_go" );
	thread flag_set_delayed( "looked_at_big_board", 3 );
	wait 1.5;
	
	foreach( ent in level.anim_ai[ "airport" ] )
		ent ent_flag_set( "do_anim" );		
	
	array_thread( getentarray( "civ_airport_1", "script_noteworthy" ), ::delaythread, 6.5, ::spawn_ai, true );			
	flag_wait( "airport_done" );
	wait 1.5;
	array_thread( getentarray( "civ_airport_2", "script_noteworthy" ), ::delaythread, .5, ::spawn_ai, true );	
	array_thread( getentarray( "civ_airport_3", "script_noteworthy" ), ::delaythread, 2.5, ::spawn_ai, true );	
		
	camera_move( "camara_path_cliffhanger", 70 );
}

airport_camera_think()
{
	node = getvehiclenode( "camara_path_airport", "targetname" );
	level.camera thread vehicle_paths( node );
		
	if( level.start_point == "airport" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
	
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

airport_ai_setup()
{
	self ai_default_setup( "airport" );
	node = self.anim_node;
	
	wait .05;
		
	switch( node.animation )
	{
		case "airport_elevator_sequence_guy1":
		case "airport_elevator_sequence_guy2":
			self.animtime = .25;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			break;
		case "airport_security_guard_pillar_react_R":
		case "airport_security_civ_rush_guard":
			self thread give_beretta();
			break;
		case "riotshield_bashB_attack":
			if( !isai( self ) )
			{
				self attach( "weapon_riot_shield", "TAG_WEAPON_LEFT" );
			}
			break;
	}
}

airport_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "airport_elevator_sequence_guy2":
			self ai_wait_current_anim( .42 );
			foreach( ent in level.anim_ai[ "airport" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "airport_done" );
			break;
		case "airport_security_guard_pillar_react_R":
		case "airport_security_civ_rush_guard":
			self thread airport_security_guard();
			break;
		case "casual_stand_v2_idle":
			self thread ai_loop_random( node.animation, "casual_stand" );
			break;
	}
}

airport_security_guard()
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	
	self ai_next_anim( %airport_security_guard_pillar_death_R );
}

/************************************************************************************************************/
/*												CLIFFHANGER													*/
/************************************************************************************************************/
cliffhanger_setup()
{	
	level.anim_ai[ "cliffhanger" ] = [];
	array_thread( getentarray( "ai_cliffhanger", "script_noteworthy" ), ::add_spawn_function, ::cliffhanger_ai_setup );
	array_thread( getentarray( "ai_cliffhanger", "script_noteworthy" ), ::add_spawn_function, ::cliffhanger_ai_think );	
}

cliffhanger_main()
{			
	thread cliffhanger_camera_think();

	flag_wait( "cliffhanger_go" );
	wait 2;
	foreach( ent in level.anim_ai[ "cliffhanger" ] )
		ent ent_flag_set( "do_anim" );		
				
	flag_wait( "cliffhanger_done" );
	wait 1.5;	
	array_thread( getentarray( "civ_favela_0", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );		
	array_thread( getentarray( "civ_favela_1", "script_noteworthy" ), ::delaythread, 1.5, ::spawn_ai, true );		
	
	camera_move( "camara_path_favela" );
}

cliffhanger_camera_think()
{
	node = getvehiclenode( "camara_path_cliffhanger", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "cliffhanger" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

cliffhanger_ai_setup()
{
	self ai_default_setup( "cliffhanger" );
	node = self.anim_node;
	
	wait .05;
	switch( node.animation )
	{
		case "killhouse_sas_price":
			self.gun_remove = true;
			self gun_remove();
			self.animtime = .2;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			break;
		case "killhouse_sas_1":
		case "killhouse_sas_2":
		case "killhouse_sas_3":
			self.animtime = .15;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			break;
		default: 
			self.animtime = .01;
			self SetAnimTime( getanim_generic( node.animation ), self.animtime );
			break;
	}
}

cliffhanger_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
	/*	case "killhouse_sas_1":
		case "killhouse_sas_2":
		case "killhouse_sas_3":*/
		case "killhouse_sas_price":
			self ai_wait_current_anim( .5 );
			foreach( ent in level.anim_ai[ "cliffhanger" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "cliffhanger_done" );
			break;
		case "guardA_standing_cold_idle":
		case "guardB_standing_cold_idle":
			self thread ai_idle( node.animation );
			break;
		case "casual_crouch_idle":
			self thread ai_loop_random( node.animation, "casual_crouch" );
			break;
		case "casual_stand_v2_idle":
			self thread ai_loop_random( node.animation, "casual_stand" );
			break;
	}
}

/************************************************************************************************************/
/*													FAVELA													*/
/************************************************************************************************************/
favela_setup()
{	
	level.anim_ai[ "favela" ] = [];
	array_thread( getentarray( "ai_favela", "script_noteworthy" ), ::add_spawn_function, ::favela_ai_setup );
	array_thread( getentarray( "ai_favela", "script_noteworthy" ), ::add_spawn_function, ::favela_ai_think );
}

favela_main()
{			
	thread favela_camera_think();

	flag_wait( "favela_go" );
		
	wait 3;
	
	foreach( ent in level.anim_ai[ "favela" ] )
		ent ent_flag_set( "do_anim" );		
	
	array_thread( getentarray( "civ_favela_3", "script_noteworthy" ), ::delaythread, 6, ::spawn_ai, true );		
			
	flag_wait( "favela_done" );
	
	wait 1;
	
	array_thread( getentarray( "civ_hallway1_1", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );		
	
	camera_move( "camara_path_hallway1", 70 );
}

favela_camera_think()
{
	node = getvehiclenode( "camara_path_favela", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "favela" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

favela_ai_setup()
{
	self ai_default_setup( "favela" );
	node = self.anim_node;
		
	switch( node.animation )
	{
		case "airport_civ_in_line_15_B":
			self setanimtime( getanim_generic( node.animation ), .05 );
			break;
		case "estate_ghost_radio":
			self set_anim_time( node, .09 );
			break;
		case "invasion_vehicle_cover_dialogue_guy1":
		case "invasion_vehicle_cover_dialogue_guy2":
			self set_anim_time( node, .03 );
			break;
		case "gulag_end_evac_soap":
			self.anim_speed = level.GLOBAL_ANIM_SPEED * .65;
			break;
	}
}

favela_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "gulag_end_evac_soap":
			link = spawn( "script_origin", self.origin );
			self linkto( link );
			self ai_wait_current_anim( .20 );
			foreach( ent in level.anim_ai[ "favela" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "favela_done" );
			break;
		case "favela_chaotic_standcover_gunjamB":
			self thread ai_loop_random( node.animation, "favela_stand" ); 
			break;
		case "favela_chaotic_crouchcover_grenadefireA":
			self thread ai_loop_random( node.animation, "favela_crouch" ); 
			break;
		case "german_shepherd_attackidle":
			self thread ai_loop_dog( node.animation, "dog" ); 
			break;
	}
}

/************************************************************************************************************/
/*												HALLWAY 1													*/
/************************************************************************************************************/
hallway1_main()
{			
	thread hallway1_camera_think();
	
	array_thread( getentarray( "civ_hallway1_2", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );		
	
	flag_wait( "skip_vehicles" );
	
	ai = get_living_ai_array( "civ_talkers", "script_noteworthy" );
	array_call( ai, ::delete );
	array_thread( getentarray( "room3_civ_talkers", "targetname" ), ::delaythread, .5, ::spawn_ai, true );	
	
	array_thread( getentarray( "civ_hallway1_3", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );		
	flag_wait( "hallway1_go" );
}

hallway1_camera_think()
{
	node = getvehiclenode( "camara_path_hallway1", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "hallway1" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( 5 );
	level.camera waittill( "reached_end_node" );
}

/************************************************************************************************************/
/*												VEHICLES													*/
/************************************************************************************************************/
vehicles_main()
{	
	array_thread( getentarray( "civ_vehicles_1", "script_noteworthy" ), ::delaythread, 10, ::spawn_ai, true );
			
	thread vehicles_camera_think();	
	flag_wait( "vehicles_go" );	
}

vehicles_camera_think()
{
	if( level.start_point == "vehicles" )
	{
		node = getvehiclenode( "camara_path_vehicles", "targetname" );
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera thread vehicle_paths( node );
	
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
		
		level.camera ResumeSpeed( 2 );
	}
	
	level.camera waittill( "reached_end_node" );	
	
	array_thread( getentarray( "civ_vehicles_2", "script_noteworthy" ), ::delaythread, 2, ::spawn_ai, true );
	
	camera_move( "camara_path_vehicles2", 20, .25, .75 );	
		
	wait 1.5;
	
	array_thread( getentarray( "civ_vehicles_3", "script_noteworthy" ), ::delaythread, 3.5, ::spawn_ai, true );
	array_thread( getentarray( "civ_vehicles_4", "script_noteworthy" ), ::delaythread, 10, ::spawn_ai, true );
	
	camera_move( "camara_path_vehicles3", 20, .75, .25 );	
	level.camera ResumeSpeed( 2 );
	level.camera waittill( "reached_end_node" );
}

/************************************************************************************************************/
/*												HALLWAY 2													*/
/************************************************************************************************************/
hallway2_main()
{			
	thread hallway2_camera_think();	
	
	flag_wait( "skip_vehicles_to" );
	ai = get_living_ai_array( "civ_talkers", "script_noteworthy" );
	array_call( ai, ::delete );
	array_thread( getentarray( "room2_civ_talkers", "targetname" ), ::delaythread, .5, ::spawn_ai, true );	
	array_thread( getentarray( "civ_hallway2_1", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );	
	
	flag_wait( "hallway2_go" );
}

hallway2_camera_think()
{
	if( level.start_point == "hallway2" )
	{
		node = getvehiclenode( "camara_path_hallway2", "targetname" );
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera thread vehicle_paths( node );
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
		
		level.camera ResumeSpeed( 5 );
	}
		
	level.camera waittill( "reached_end_node" );
}

/************************************************************************************************************/
/*													OILRIG													*/
/************************************************************************************************************/
oilrig_setup()
{
	level.anim_ai[ "oilrig" ] = [];
	array_thread( getentarray( "ai_oilrig", "script_noteworthy" ), ::add_spawn_function, ::oilrig_ai_setup );
	array_thread( getentarray( "ai_oilrig", "script_noteworthy" ), ::add_spawn_function, ::oilrig_ai_think );		
}

oilrig_main()
{			
	thread oilrig_camera_think();

	flag_wait( "oilrig_go" );
	wait 2;
		
	foreach( ent in level.anim_ai[ "oilrig" ] )
		ent ent_flag_set( "do_anim" );		
	
	array_thread( getentarray( "civ_oilrig_1", "script_noteworthy" ), ::delaythread, 12, ::spawn_ai, true );			
	flag_wait( "oilrig_done" );
	array_thread( getentarray( "civ_oilrig_2", "script_noteworthy" ), ::delaythread, 1.5, ::spawn_ai, true );	
	wait 1.75;
	camera_move( "camara_path_estate" );
}

oilrig_camera_think()
{
	if( level.start_point == "oilrig" )
	{
		node = getvehiclenode( "camara_path_oilrig", "targetname" );
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera thread vehicle_paths( node );
		
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
		level.camera ResumeSpeed( .5 );
	}		
	
	level.camera waittill( "reached_end_node" );
}

oilrig_ai_setup()
{
	wait .1;
	self ai_default_setup( "oilrig" );
	node = self.anim_node;

}

oilrig_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "roadkill_opening_foley":
			self ai_wait_current_anim( .73 );
			foreach( ent in level.anim_ai[ "oilrig" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "oilrig_done" );
			break;
		case "roadkill_opening_shepherd":
			self ai_wait_current_anim( .83 );
			foreach( ent in level.anim_ai[ "oilrig" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "oilrig_done" );
			break;
		case "oilrig_sub_B_idle_3":
		case "oilrig_sub_B_idle_4":
			self thread bubbles();
		default:
			self thread ai_idle( node.animation );
			break;
	}
}

/************************************************************************************************************/
/*													ESTATE													*/
/************************************************************************************************************/
estate_setup()
{
	level.anim_ai[ "estate" ] = [];
	array_thread( getentarray( "ai_estate", "script_noteworthy" ), ::add_spawn_function, ::estate_ai_setup );
	array_thread( getentarray( "ai_estate", "script_noteworthy" ), ::add_spawn_function, ::estate_ai_think );	
	getent( "bh_node", "target" ) estate_struct_setup(); 	
}

estate_main()
{			
	thread estate_camera_think();

	flag_wait( "estate_go" );
	wait 2;
		
	foreach( ent in level.anim_ai[ "estate" ] )
		ent ent_flag_set( "do_anim" );		

	array_thread( getentarray( "civ_estate_1", "script_noteworthy" ), ::delaythread, 6, ::spawn_ai, true );	
				
	flag_wait( "estate_done" );
	wait 2;
	
	array_thread( getentarray( "civ_estate_2", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );	
	
	camera_move( "camara_path_hostage_mid", 55 );
	level.camera ResumeSpeed( 5 );
	wait 3.5;
	camera_move( "camara_path_hostage", 75, 0 );
}

estate_camera_think()
{
	node = getvehiclenode( "camara_path_estate", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "estate" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

estate_ai_setup()
{
	if( isdefined( self.target ) && self.target == "bh_ai_node" )
		self estate_bh_setup();
	
	self ai_default_setup( "estate" );
	node = self.anim_node;
	
	switch( node.animation )
	{
		case "bh_rope_drop_le":
		case "bh_6_drop":
			self.ragdoll_immediate = true;
			self.anim_speed = level.GLOBAL_ANIM_SPEED * .3;
			self set_anim_time( node, .765 );
			break;
		case "roadkill_cover_spotter":
		case "roadkill_cover_soldier":
		case "roadkill_cover_active_soldier2":
			if( isai( self ) )
				self.a.pose = "crouch";
			break;		
	}
}

estate_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "bh_rope_drop_le":
		case "bh_6_drop":
			self ai_wait_current_anim( .936 );
			foreach( ent in level.anim_ai[ "estate" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "estate_done" );				
			break;
		default:
			self thread ai_idle( node.animation );
			break;
	}
}

estate_struct_setup()
{
	helo = getent( self.target, "targetname" );
	
	node = spawnstruct();
	if( level.level_mode == "free" )
		node.origin = helo GetTagOrigin( "TAG_DETACH" ) + (0,0,-10);
	else	
		node.origin = helo GetTagOrigin( "TAG_DETACH" );
		
	node.angles = helo GetTagangles( "TAG_DETACH" );
	node.animation = "bh_6_drop";
	node.targetname = "bh_ai_node";
		
		if ( !isdefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
			level.struct_class_names[ "targetname" ][ node.targetname ] = [];
		size = level.struct_class_names[ "targetname" ][ node.targetname ].size;
		level.struct_class_names[ "targetname" ][ node.targetname ][ size ] = node;	
	
	node = spawnstruct();
	node.origin = helo GetTagOrigin( "TAG_FASTROPE_LE" ) + (0,0,.5);;
	node.angles = helo GetTagangles( "TAG_FASTROPE_LE" );
	node.animation = "bh_rope_drop_le";
	node.targetname = "bh_rope_node";
	
		if ( !isdefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
			level.struct_class_names[ "targetname" ][ node.targetname ] = [];
		size = level.struct_class_names[ "targetname" ][ node.targetname ].size;
		level.struct_class_names[ "targetname" ][ node.targetname ][ size ] = node;	
	
	self.target = "bh_ai_node";
}

estate_bh_setup()
{
	rope = spawn( "script_model", self.origin );
	rope setmodel( "rope_test" );
	
	rope.target = "bh_rope_node";
	rope UseAnimTree( #animtree );
	
	rope ent_flag_init( "do_anim" );
	level.guys[ level.guys.size ] = rope;
	level.rope = rope;
	rope thread estate_ai_setup();
	rope thread estate_ai_think();
}

/************************************************************************************************************/
/*													HOSTAGE													*/
/************************************************************************************************************/
hostage_setup()
{
	level.anim_ai[ "hostage" ] = [];
	array_thread( getentarray( "ai_hostage", "script_noteworthy" ), ::add_spawn_function, ::hostage_ai_setup );
	array_thread( getentarray( "ai_hostage", "script_noteworthy" ), ::add_spawn_function, ::hostage_ai_think );	
}

hostage_main()
{			
	if( level.start_point == "hostage" )
		level waittill( "cam_hostage" );
		
	thread hostage_camera_think();

	flag_wait( "hostage_go" );
			
	foreach( ent in level.anim_ai[ "hostage" ] )
		ent ent_flag_set( "do_anim" );		
	
	array_thread( getentarray( "civ_hostage_1", "script_noteworthy" ), ::delaythread, 5, ::spawn_ai, true );	
			
	flag_wait( "hostage_done" );
	wait 1;
	camera_move( "camara_path_trainer", 35 );
}

hostage_camera_think()
{				
	node = getvehiclenode( "camara_path_hostage", "targetname" );
	level.camera thread vehicle_paths( node );
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

hostage_ai_setup()
{
	self ai_default_setup( "hostage" );
	node = self.anim_node;
	
	switch( node.animation )
	{
		case "takedown_room1B_hostage":
			self.anim_mode = "gravity";
			if( isai( self ) )
				self.a.pose = "crouch";
		case "takedown_room1B_soldier":		
			self set_anim_time( node, .19 );
			break;
		case "hostage_chair_dive":
			self.anim_mode = "gravity";//zonly_physics, nophysics, none gravity
			break;
	}
}

hostage_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "takedown_room1B_hostage":
		case "takedown_room1B_soldier":
			self thread hostage_pose( node.animation );		
			self ai_wait_current_anim( .74 );
			foreach( ent in level.anim_ai[ "hostage" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "hostage_done" );				
			break;
		case "hostage_chair_dive":
			self thread hostage_dive( node.animation );
			break;
		default:
			self thread hostage_chair( node.animation );
			break;
	}
}

hostage_pose( animation )
{
	self endon( "death" );
	
	if( !isai( self ) )
		return;
	
	self ai_wait_current_anim( .39 );
		
	switch ( animation )
	{
		case "takedown_room1B_hostage":
			self.a.pose = "prone";
			break;
		case "takedown_room1B_soldier":
			self.a.pose = "crouch";
			break;
	}	
}

hostage_chair( animation )
{
	self endon( "death" );
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();
	
	self ai_next_anim( %hostage_chair_twitch2 );
	self ai_next_anim( %hostage_chair_twitch );
	self ai_next_anim( %hostage_chair_idle );
}

hostage_dive( animation )
{
	self endon( "death" );
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();
	
	self ai_next_anim( %hostage_chair_ground_idle );
	if( isai( self ) )
		self.a.pose = "prone";
	self ai_next_anim( %hostage_chair_ground_idle );
	self ai_next_anim( %hostage_chair_ground_idle );
	self ai_next_anim( %hostage_chair_ground_idle );
}

/************************************************************************************************************/
/*													TRAINER													*/
/************************************************************************************************************/
trainer_setup()
{
	level.anim_ai[ "trainer" ] = [];
	array_thread( getentarray( "ai_trainer", "script_noteworthy" ), ::add_spawn_function, ::trainer_ai_setup );
	array_thread( getentarray( "ai_trainer", "script_noteworthy" ), ::add_spawn_function, ::trainer_ai_think );	
}

trainer_main()
{			
	thread trainer_camera_think();

	flag_wait( "trainer_go" );
	wait 2.5;
		
	foreach( ent in level.anim_ai[ "trainer" ] )
		ent ent_flag_set( "do_anim" );		
			
	flag_wait( "trainer_done" );
	array_thread( getentarray( "civ_trainer_1", "script_noteworthy" ), ::delaythread, 0, ::spawn_ai, true );	
		
	wait 2;
	camera_move( "camara_path_arcadia" );
}

trainer_camera_think()
{
	node = getvehiclenode( "camara_path_trainer", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "trainer" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

trainer_ai_setup()
{
	self ai_default_setup( "trainer" );
	node = self.anim_node;
	
	switch( node.animation )
	{
		case "training_pushups_guy1":
			self.gun_remove = true;
			self gun_remove();
			self.grenadeweapon = "fraggrenade";
			self.grenadeammo = 0;
			self set_anim_time( node, .93 );
			break;
		case "parabolic_leaning_guy_idle_training":
			self.grenadeweapon = "fraggrenade";
			self.grenadeammo = 0;
			break;
		case "training_intro_translator_end":
			self.gun_remove = true;
			self gun_remove();
		case "training_intro_trainee_1_end":
		case "training_intro_foley_end":
			self set_anim_time( node, .25 );
			break;		
	}
}

trainer_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "training_intro_trainee_1_end":
		case "training_intro_translator_end":
		case "training_intro_foley_end":
			self ai_wait_current_anim( .50 );
			foreach( ent in level.anim_ai[ "trainer" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "trainer_done" );				
			break;
		default:
			self thread ai_idle( node.animation );
			break;
	}
}

/************************************************************************************************************/
/*													ARCADIA													*/
/************************************************************************************************************/
arcadia_setup()
{
	level.anim_ai[ "arcadia" ] = [];
	array_thread( getentarray( "ai_arcadia", "script_noteworthy" ), ::add_spawn_function, ::arcadia_ai_setup );
	array_thread( getentarray( "ai_arcadia", "script_noteworthy" ), ::add_spawn_function, ::arcadia_ai_think );	
}

arcadia_main()
{			
	thread arcadia_camera_think();

	flag_wait( "arcadia_go" );
	wait 2;
		
	foreach( ent in level.anim_ai[ "arcadia" ] )
		ent ent_flag_set( "do_anim" );		

	array_thread( getentarray( "civ_arcadia_1", "script_noteworthy" ), ::delaythread, 2.5, ::spawn_ai, true );	
				
	flag_wait( "arcadia_done" );
	
	wait 1;
	
	level.black FadeOverTime( 3 );
	level.black.alpha = 1;	
}

arcadia_camera_think()
{
	node = getvehiclenode( "camara_path_arcadia", "targetname" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );

	if( level.start_point == "arcadia" )
	{
		level.camera vehicle_teleport( node.origin, node.angles );
		level.camera attachpath( node );
		level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );
	}
		
	level.camera ResumeSpeed( .5 );
	level.camera waittill( "reached_end_node" );
}

arcadia_ai_setup()
{
	switch( self.animation )
	{
		case "coup_guard2_jeera":
			self.animtime = .35;
			self.animation = "coup_guard2_jeera";
			break;
		case "coup_guard2_jeerb":
			self.animtime = .05;		
			self.animation = "coup_guard2_jeera";
			break;
		case "coup_guard2_jeerc":
			self.animtime = .85;
			self.animation = "coup_guard2_jeera";
			break;
		case "coup_guard1_jeer":
			self.animtime = .6;
			self.animation = "coup_guard2_jeera";
			break;
	}
	
	self ai_default_setup( "arcadia" );
	node = self.anim_node;
	
	switch( self.animation )
	{
		case "village_interrogationA_Price":
		case "village_interrogationA_Zak":			
			self.gun_remove = true;
			self gun_remove();
			self set_anim_time( node, .677 );
			self.anim_speed = level.GLOBAL_ANIM_SPEED * .5;
			break;
		default:
			self set_anim_time( node, self.animtime );
			break;
	}
}

arcadia_ai_think()
{
	self endon( "panic_button" );
	self endon( "death" );
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	node = self.anim_node;
	
	self _setanim( getanim_generic( node.animation ), 1, 0, self.anim_speed );
	
	switch( node.animation )
	{
		case "village_interrogationA_Zak":
		case "village_interrogationA_Price":
			self thread arcadia_pose( node.animation );		
			self ai_wait_current_anim( .97 );
			foreach( ent in level.anim_ai[ "arcadia" ] )
				ent ent_flag_clear( "do_anim" );
			flag_set( "arcadia_done" );				
			break;
		default:
			self thread ai_idle( node.animation );
			break;
	}
}

arcadia_pose( animation )
{
	self endon( "panic_button" );
	self endon( "death" );
	
	if( !isai( self ) )
		return;	
	
	switch( animation )
	{
		case "village_interrogationA_Zak":
			self ai_wait_current_anim( .75 );
			self.ragdoll_immediate = true;
			break;	
		case "village_interrogationA_Price":
			self ai_wait_current_anim( .78 );
			self.a.pose = "crouch";
			break;	
	}
}

/************************************************************************************************************/
/*												BLACK CREDITS												*/
/************************************************************************************************************/
black_main()
{	
	thread maps\_credits::playCredits();
	
	wait 263 - 6;
	
	thread music_stop( 4 );
	
	wait 6;
	
	nextmission();
	
	level waittill( "never" );
}

/************************************************************************************************************/
/*											MUSEUM FREE ROAM												*/
/************************************************************************************************************/
museum_main()
{	
	// black screen while we do things in the background
	blackscreen_start();

	flag_wait( "museum_ready" );
	
	// room 1 guys spawn initially
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
			
	thread maps\_introscreen::char_museum_intro();
	
	set_console_status();
	if( level.Console )
	{
		if( level.ps3 )
			wait 9.0;	
		if( level.xenon )
			wait 6.0;
	}
	else
	{
		wait 2;	
	}
	
	array_call( level.players, ::freezecontrols, false );
	blackscreen_fadeout( 1.5 );
	
	level waittill( "never" );
}

museum_room1_anim_go()
{
	level notify( "new_room_anim_go" );
		
	add_wait( ::flag_wait, "af_caves_go" );
	add_func( ::do_anim, "af_caves" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "dc_burning_go" );
	add_func( ::do_anim, "dc_burning" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "airport_go" );
	add_func( ::do_anim, "airport" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "cliffhanger_go" );
	add_func( ::do_anim, "cliffhanger" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "favela_go" );
	add_func( ::do_anim, "favela" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
}

museum_room2_anim_go()
{
	level notify( "new_room_anim_go" );
	
	add_wait( ::flag_wait, "oilrig_go" );
	add_func( ::do_anim, "oilrig" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "estate_go" );
	add_func( ::do_anim, "estate" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "hostage_go" );
	add_func( ::do_anim, "hostage" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "arcadia_go" );
	add_func( ::do_anim, "arcadia" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
	
	add_wait( ::flag_wait, "trainer_go" );
	add_func( ::do_anim, "trainer" );
	level add_abort( ::waittill_msg, "new_room_anim_go" );
	thread do_wait();
}

/************************************************************************************************************/
/*												START POINTS												*/
/************************************************************************************************************/
start_common()
{
	SetSavedDvar( "hud_drawHUD", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "actionSlotsHide", "1" );
	SetSavedDvar( "compass", "0" );
	setsaveddvar( "g_friendlyNameDist", "0" );
	setsaveddvar( "g_enteqDist", "0" );
	
	trigger_off( "free_roam_look_ats", "targetname" );
		
	sidebar = create_client_overlay_custom_size( "credits_side_bar", .45, 600, 480 );
	sidebar.alignX = "left";
	sidebar.horzAlign = "left";
	sidebar.x = -280;
	
	level.black = create_client_overlay( "black", 1 );
			
	if( level.level_mode != "credits_1" )
	{
		player_lerp_eq();
		thread music_loop( "af_chase_ending_credits" , 122, 1 );
	}	
	else
		level.black_overlay delaycall( .5, ::destroy );
		
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player TakeAllWeapons();
	
	add_global_spawn_function( "axis", ::museum_ai_think );
	add_global_spawn_function( "allies", ::museum_ai_think );
	add_global_spawn_function( "neutral", ::museum_ai_think );
		
	level.camera = spawn_vehicle_from_targetname_and_drive( "credits_camera" );
	level.player playerlinkto( level.camera, undefined, 1, 0,0,0,0,0 );
		
	level.player delaycall( .1, ::freezecontrols, true );
	noself_delaycall( 1, ::SetSavedDvar, "cg_fov", 45 );
	
	spawntrigs = GetEntArray( "spawntrig", "targetname" );
	array_thread( spawntrigs, ::spawner_trig_think );	
	ai_anim_setups();
	
	thread end_credits();
}

player_lerp_eq()
{
	level.player SetEqLerp( .05, level.eq_main_track );
	AmbientStop( .05 );
	thread maps\_ambient::use_eq_settings( "fadeall_but_music", level.eq_mix_track );
	thread maps\_ambient::blend_to_eq_track( level.eq_mix_track , .05 );	
}

ai_anim_setups()
{
	array_thread( getentarray( "civ_talkers", "script_noteworthy" ), ::add_spawn_function, ::civ_talkers );
	array_thread( getentarray( "room1", "targetname" ), ::set_diarama_ai );
	array_thread( getentarray( "room2", "targetname" ), ::set_diarama_ai );
	array_thread( getentarray( "civilians", "targetname" ), ::set_civilian_ai );
	array_thread( getentarray( "civilians", "targetname" ), ::add_spawn_function, ::delete_civ_on_goal );
	array_thread( getentarray( "civ_talkers", "script_noteworthy" ), ::set_civilian_ai );
			
	afcaves_setup();
	dcburning_setup();
	airport_setup();
	cliffhanger_setup();
	favela_setup();
	oilrig_setup();
	estate_setup();
	hostage_setup();
	trainer_setup();
	arcadia_setup();
		
	thread flag_set_delayed( "museum_ready", .05 );	
}

start_free()
{
	precachestring( &"CHAR_MUSEUM_LINE1" );
	precachestring( &"CHAR_MUSEUM_LINE3" );
	precachestring( &"CHAR_MUSEUM_LINE4" );
	add_global_spawn_function( "axis", ::museum_ai_think );
	add_global_spawn_function( "allies", ::museum_ai_think );
	add_global_spawn_function( "neutral", ::museum_ai_think );
	
	array_thread( level.players, ::museum_player_setup );
		
	spawntrigs = GetEntArray( "spawntrig", "targetname" );
	array_thread( spawntrigs, ::spawner_trig_think );
	
	ai_anim_setups();
	
	array_thread( getentarray( "panic_button", "targetname" ), ::panic_button );
}

start_afcaves()
{
	start_common();
	
	flag_wait( "museum_ready" );	
	wait .05;
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();	
}

start_dcburning()
{
	start_common();
	
	flag_wait( "museum_ready" );	
	wait .05;
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
}

start_airport()
{
	start_common();
	
	flag_wait( "museum_ready" );	
	wait .05;
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
	array_thread( getentarray( "room1_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_cliffhanger()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
	array_thread( getentarray( "room1_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_favela()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
	array_thread( getentarray( "room1_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_hallway1()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
	array_thread( getentarray( "room1_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_vehicles()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	array_thread( getentarray( "room3_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_hallway2()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
}

start_oilrig()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room2trig = GetEnt( "room2", "script_noteworthy" );
	room2trig spawn_museum_dudes();
	array_thread( getentarray( "room2_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_estate()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room2trig = GetEnt( "room2", "script_noteworthy" );
	room2trig spawn_museum_dudes();
	array_thread( getentarray( "room2_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_hostage()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room2trig = GetEnt( "room2", "script_noteworthy" );
	room2trig spawn_museum_dudes();
	array_thread( getentarray( "room2_civ_talkers", "targetname" ), ::spawn_ai, true );	
	
	camera_move( "camara_path_hostage_mid", 500, 0, .05 );
	level.camera ResumeSpeed( 5 );
	wait 3.5;
	camera_move( "camara_path_hostage", 75, 0 );
	level notify( "cam_hostage" );
}

start_trainer()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room2trig = GetEnt( "room2", "script_noteworthy" );
	room2trig spawn_museum_dudes();
	array_thread( getentarray( "room2_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_arcadia()
{
	start_common();	
	
	flag_wait( "museum_ready" );	
	wait .05;
	room2trig = GetEnt( "room2", "script_noteworthy" );
	room2trig spawn_museum_dudes();
	array_thread( getentarray( "room2_civ_talkers", "targetname" ), ::spawn_ai, true );	
}

start_black()
{
	level.black = create_client_overlay( "black", 1 );
 	thread music_loop( "af_chase_ending_credits" , 122, 1 );
	
	level.player SetEqLerp( .05, level.eq_main_track );
	AmbientStop( .05 );
	thread maps\_ambient::use_eq_settings( "fadeall_but_music", level.eq_mix_track );
	thread maps\_ambient::blend_to_eq_track( level.eq_mix_track , .05 );	
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player TakeAllWeapons();
	level.player DisableWeapons();
	level.player FreezeControls( true );
}

end_credits()
{	
	level.credits_speed = 25.5;
	
	thread maps\_credits::playCredits();
	if( level.level_mode == "credits_1" )
		wait 3.5;
	thread fade_from_black();
		
	wait 290; //-> magic timing - do not change...change credit speed instead
	wait 28; //additional time after credits changes	
	level.credits_speed = 4;
	flag_set( "atvi_credits_go" );
	
	wait 20;
		
	thread music_stop( 4 );
	wait 5;
	
	if( level.level_mode == "credits_1" )
		flag_set( "af_chase_nextmission" );	
	else		
		nextmission();
}

fade_from_black()
{
	wait 9;	
	flag_set( "fade_from_black" );
	wait 1;
	
	level.black FadeOverTime( 2 );
	level.black.alpha = 0;	
}