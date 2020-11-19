#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;


CONST_BTR_SLIDE_TIME_1 		= 1.5;
CONST_BTR_SLIDE_TIME_2 		= .65;
CONST_STREET_CAR_WAIT 		= .25;
CONST_NEW_HELI_DROP_HEIGHT	= 5500;



//------- SPACE SUIT INPUT --------->

CONST_ISS_INPUT_X_MIN		= 8;
CONST_ISS_INPUT_RATE_X		= .3;
CONST_ISS_INPUT_FORCE_X		= .75;
CONST_ISS_INPUT_ACC_X_MAX	= 5;
CONST_ISS_INPUT_DEC_X		= .05;

CONST_ISS_INPUT_RATE_Y		= .5;
CONST_ISS_INPUT_DEC_Y		= .05;
CONST_ISS_INPUT_ACC_Y_MIN	= 1;

//<---------------------------------

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/
iss_get_satellite_model()
{
	node = getent( "iss_player_link", "targetname" );
	model = spawn_anim_model( "iss_satellite", node.origin );
	model.angles = node.angles;
	model linkto( node );
		
	foreach( part in level.iss_ents[ "satellite" ] )
		part linkto( model );
	
	return model;
}

iss_satellite_update_model( veh )
{
	while( 1 )
	{
		self moveto( veh.origin, .1 );
		self rotateto( veh.angles, .1 );
		wait .05;	
	}
}

iss_camera_setup()
{
	setsaveddvar( "ui_hidemap", 1 );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player freezecontrols( true );
	
	node = getent( "iss_player_link2", "targetname" );
			
	camera = spawn_anim_model( "iss_rig", node.origin );
	//camera hide();
	camera.angles = node.angles;
	camera linkto( node );
	camera.node = node;
				
	level.player playerlinktodelta( camera, "tag_origin", 1, 0, 0, 0, 0 );
	level.player PlayerSetGroundReferenceEnt( camera );
	
	node anim_first_frame_solo( camera, "ISS_animation" );
//	camera thread iss_camera_spotlight();
	
	return camera;
}

iss_camera_spotlight()
{
	offset = self iss_camera_offset();	
	
	setsaveddvar( "r_spotlightstartradius", "16" );
	setsaveddvar( "r_spotlightEndradius", "500" );
	setsaveddvar( "r_spotlightfovinnerfraction", ".1" );
	setsaveddvar( "r_spotlightexponent", "5" );
	setsaveddvar( "r_spotlightBrightness", "2" );
		
	origin = self.origin + offset;
	model = spawn( "script_model", origin );
	model setmodel( "TAG_ORIGIN" );
	model.angles = level.player getplayerangles();
			
	playfxontag( level._effect[ "space_helmet_spot_light" ], model, "TAG_ORIGIN" );
		
	while( !flag( "iss_destroy_blast_wave" ) )
	{
		offset = self iss_camera_offset();
		
		model.origin = self.origin + offset;			// model moveto( self.origin + offset, .1 );
		model.angles = level.player getplayerangles() + self.angles;
		wait .05;	
	}
	
	model delete();
}

iss_camera_offset()
{
	up 		= anglestoup( self.angles );
	right 	= anglestoright( self.angles );
	forward = anglestoforward( self.angles );
	offset = ( up * 64 ) + ( right * 16 ) + ( forward * -2 );
	
	return offset;	
}

iss_satellite()
{	
	
	model 	= iss_get_satellite_model();

	diff = (5092, 4344, 3438) - ( 5440, 4634, 3470 );
	node = getent( "iss_player_link", "targetname" );
	node2 = spawn( "script_origin", node.origin );
	node2.angles = node.angles;
	node2.targetname = "iss_player_link2";
	node2 linkto( model );
	
	camera 	= iss_camera_setup();
	
	array = [];
	array[ "model" ] 	= model;
	array[ "node" ] 	= node;
	array[ "camera" ] 	= camera;
	
	return array;
}

iss_organize_ents()
{
	level.iss_ents = [];
	
	nodes = getstructarray( "iss_group_node", "targetname" );
	array_thread( nodes, ::iss_organize_ents_by_node );
	array_wait( nodes, "done_organizing" );
	
	flag_set( "iss_organize_ents" );
}

iss_organize_ents_by_node()
{
	ents = getentarray( "iss_entity", "targetname" );
	level.iss_ents[ self.script_noteworthy ] = [];
	node = getstruct( "iss_blast_node", "targetname" );
	
	num = 0;
	foreach( obj in ents )
	{
		if( distancesquared( obj getorigin(), self.origin ) > squared( self.radius ) )
			continue;
		
		obj.distance_to_blast = distance( node.origin, obj getorigin() );
		
		size = level.iss_ents[ self.script_noteworthy ].size;
		level.iss_ents[ self.script_noteworthy ][ size ] = obj;
				
		num++;
		if( num == 50 )
		{
			wait .05;
			num = 0;	
		}
	}
	
	self notify( "done_organizing" );
}

iss_destroy_iss()
{
	level.iss_destroy_small = 0;
	parts = level.iss_ents[ "iss" ];
	flag_init( "temp" );
	array_thread( parts, ::iss_destroy_iss_parts );	
}

iss_destroy_sat()
{
	parts = level.iss_ents[ "satellite" ];
	array_thread( parts, ::iss_destroy_sat_parts );	
}

iss_destroy_iss_parts()
{		
	magicnumber = .0012;
	
	time = magicnumber * self.distance_to_blast;
	
	time = time - 3;// + randomfloat( .1 );
	
	flag_wait_or_timeout( "iss_destroy_blast_wave", time );	
	flag_set( "iss_destroy_first_wave" );
	thread flag_set_delayed( "iss_destroy_blast_wave", 1.5 );
							
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "delete" )
	{
		self delete();
		return;
	}
	
	if( flag( "iss_destroy_blast_wave" ) && self.script_type == "small" )
	{
		level.iss_destroy_small++;
		if( level.iss_destroy_small > 1 )
		{
			self delete();
			level.iss_destroy_small = 0;
			return;
		}	
	}
		
	dist = [];
	dist[ "small" ]		= 55000;
	dist[ "medium" ]	= 25000; 
	dist[ "large" ]		= 16000;
	rot = [];
	rot[ "small" ] 		= 500;
	rot[ "medium" ] 	= 200;
	rot[ "large" ] 		= 100;
	
	signp = 1;
	signr = 1;
	
	if( cointoss() )
		signp = -1;
	if( cointoss() )
		signr = -1;
	
	blaststart = getstruct( "iss_blast_node", "targetname" );
	blastend = getstruct( blaststart.target, "targetname" );
	
	time 		= 30;
	rotation 	= ( randomfloatrange( .75, 1 ) * signp, 0, randomfloatrange( .75, 1 ) * signr );
	vector 		= vectornormalize( blastend.origin - blaststart.origin );
	origin 		= self getorigin() + ( vector * dist[ self.script_type ] * randomfloatrange( .8, 1.2 ) );
	angles 		= rotation * rot[ self.script_type ] * randomfloatrange( .8, 1.2 );
	
	self moveto( origin, time );
	self rotatevelocity( angles, time );
}

iss_destroy_sat_parts()
{
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "delete" )
	{
		self delete();
		return;
	}
	
	if( self.script_type == "small" )
	{
		level.iss_destroy_small++;
		if( level.iss_destroy_small > 10 )
		{
			self delete();
			level.iss_destroy_small = 0;
			return;
		}	
		
		wait .5;
	}
	
	self unlink();
			
	dist = [];
	dist[ "small" ]		= 40000;
	dist[ "medium" ]	= 20000; 
	dist[ "large" ]		= 15000;
	rot = [];
	rot[ "small" ] 		= 500;
	rot[ "medium" ] 	= 200;
	rot[ "large" ] 		= 100;
	
	signp = 1;
	signr = 1;
	
	if( cointoss() )
		signp = -1;
	if( cointoss() )
		signr = -1;
	
	blaststart = getstruct( "iss_blast_node", "targetname" );
	blastend = getstruct( blaststart.target, "targetname" );
	
	time 		= 30;
	rotation 	= ( randomfloatrange( .75, 1 ) * signp, 0, randomfloatrange( .75, 1 ) * signr );
	vector 		= vectornormalize( blastend.origin - blaststart.origin );
	origin 		= self getorigin() + ( vector * dist[ self.script_type ] * randomfloatrange( .8, 1.2 ) );
	angles 		= rotation * rot[ self.script_type ] * randomfloatrange( .8, 1.2 );
	
	self moveto( origin, time );
	self rotatevelocity( angles, time );
}

iss_kill_player()
{
	cam = level.iss_sat[ "camera" ];
	cam.node unlink();	
	
	blaststart = getstruct( "iss_blast_node", "targetname" );
	blastend = getstruct( blaststart.target, "targetname" );
	
	time 		= 30;
	vector 		= vectornormalize( blastend.origin - blaststart.origin );
	origin 		= cam.origin + ( vector * 25000 );
	angles 		= ( 0, 0, 80 );
	
	cam.node moveto( origin, time );
	cam.node rotatevelocity( angles, time );
		
	time = 4;
	plate = spawn( "script_model", level.player geteye() + ( vector * -2000 ) );
	plate setmodel( "iss_sail_center" );
	plate rotatevelocity( ( 195, 0, -215 ), time );
	
	while( time > 0 )
	{
		plate moveto( level.player geteye() + ( vector * 256 ), time );
		time -= .05;
		wait .05;
	}
}

iss_player_quake()
{
	level endon( "iss_done" );
	
	while( 1 )
	{
		earthquake( .35, .2, level.player.origin, 1024 );
		wait .05;
	}
}

iss_lights_out()
{
	node = getent( "earth_model", "targetname" );
	
	model = spawn( "script_model", node.origin + ( 0,0,300 ) );
	model.angles = node.angles;
	model.targetname = "iss_lights";
	
	wait 1;
			
	for( i = 1; i <= level.bg_iss_darknum; i++ )
	{
		name = "bg_iss_dark0";
		if( i > 9 )
			name = "bg_iss_dark";
		
		model setmodel( name + i );
				
		wait randomfloatrange( .2, .4 );
	}
}

iss_preload_lights()
{
	origin = level.player.origin + ( 0,0,1024 );
	for( i = 1; i <= level.bg_iss_darknum; i++ )
	{
		name = "bg_iss_dark0";
		if( i > 9 )
			name = "bg_iss_dark";

		model = spawn( "script_model", origin );
		model.targetname = "iss_lights";
		model setmodel( name + i );
	}
}

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/
intro_enemy_setup()
{
	flag_wait( "crash_cut_to_black" );
	
	thread battlechatter_off();
	
	flag_wait( "emp_entity_cleanup_done" );
	
	ai = getaiarray( "axis" );	
	ai = array_removeDead_or_dying( ai );
	
	array_thread( ai, ::intro_enemy_reaction );
}

intro_enemy_reaction()
{
	self endon( "death" );
	self endon( "long_death" );
	
	self.allowdeath = true;
	self.diequietly = true;
	self thread anim_generic_loop( self, "covercrouch_hide_idle" );
	
	flag_wait( "emp_back_from_whiteout" );
	
	center = getstruct( "emp_center", "targetname" );
	
	node = spawnstruct();
	node.origin = self.origin;
	angles = node.origin - center.origin;
	node.angles = vectortoangles( angles );
	
	animes = [];
	animes[ animes.size ] = "cqb_stand_react_A";
	animes[ animes.size ] = "cqb_stand_react_B";
	animes[ animes.size ] = "cqb_stand_react_C";
	animes[ animes.size ] = "cqb_stand_react_D";
	animes[ animes.size ] = "cqb_stand_react_E";
	
	self notify( "stop_loop" );
	self anim_stopanimscripted();
	node anim_generic_gravity( self, random( animes ) );
	
	self setgoalnode( getnode( "intro_enemy_node", "targetname" ) );
	self.goalradius = 100;
	
	self add_wait( ::waittill_msg, "goal" );
	level add_wait( ::flag_wait, "street_player_hide" );
	do_wait_any();
	
	self delete();
}



/************************************************************************************************************/
/*													EMP														*/
/************************************************************************************************************/
emp_entities()
{
	switch( self.targetname )
	{
		case "emp_delete":
			self emp_ents_wait();
			if( isdefined( self.script_noteworthy ) )
			{
				switch( self.script_noteworthy )
				{
					case "lamp":
						playfx( level._effect[ "powerline_runner_oneshot" ], self getorigin() + ( 0, 0, 50) );
						thread play_sound_in_space( "glass_pane_blowout", self getorigin() );
						break;	
					case "window":
						playfx( level._effect[ "dcemp_glass_74x44" ], self getorigin(), anglestoforward( (0,270,0) ) );//, anglestoright( (0,270,0) ) );
						thread play_sound_in_space( "glass_pane_blowout", self getorigin() );
						break;	
				}
			}
			self delete();
			break;
		
		case "emp_swap":	
			if( isdefined( self.target ) )
			{
				after = getent( self.target, "targetname" );	
				after hide();
				self emp_ents_wait();
				after show();
				self delete();
			}
			else
				self emp_smart_swap();
			break;
			
		case "emp_light":
			self setlightintensity( 1.5 );
			self emp_ents_wait();
			self setlightintensity( 0 );
			break;
		
		case "emp_show":
			self hide();
			self emp_ents_wait();
			self show();
			playfx( level._effect[ "powerline_runner_oneshot" ], self getorigin() );
			thread play_sound_in_space( "glass_pane_blowout", self getorigin() );
			break;
	}
}

emp_smart_swap()
{
	self emp_ents_wait();
	
	switch( self.model )
	{
		case "ch_street_light_01_on":
			self setmodel( "ch_street_light_01_off" );
			break;
	}	
}

emp_ents_wait( type )
{
	flag_wait( "iss_done" );
	
	wait 2;
		
	center = getstruct( "emp_center", "targetname" );
	dist = 0;
	magicnumber = 1 / 2500;
	
	if( !isdefined( type ) )
		type = self.targetname;
		
	switch( type )
	{
		case "emp_delete":
			dist = distance( self getorigin(), center.origin );
			break;
		
		case "emp_swap":	
			dist = distance( self.origin, center.origin );
			break;
			
		case "emp_light":
			dist = distance( self.origin, center.origin );
			break;
		
		case "emp_show":
			dist = distance( self.origin, center.origin );
			break;
	}	
	
	time = dist * magicnumber - 13;
	if( time < 0 )
		time = 0;
	wait time;
}

emp_stop_start_heli()
{
	self endon( "death" );
	
	flag_wait( "emp_entity_cleanup_done" );


	speed = self vehicle_getspeed();
	self notify( "newpath" );
	self vehicle_setspeedimmediate( 0, 100, 100 );
	node = undefined;
	
	if( level.start_point != "emp" )
		node = getstruct( self.currentNode.target, "targetname" );
		
	flag_wait( "iss_done" );
	
	self vehicle_setspeedimmediate( speed, 100, 100 );	
	
	if( level.start_point != "emp" )
		self thread maps\_vehicle::vehicle_paths( node );
}

#using_animtree( "vehicles" );
emp_heli_spotlight()
{
	level.emp_heli_spotlight = self;
	
	add_wait( ::flag_wait, "emp_entity_cleanup_done" );
	self add_func( maps\_attack_heli::heli_spotlight_off );
	thread do_wait();
	
	self thread emp_stop_start_heli();
	
	wait 2;
	
	flag_wait( "iss_done" );
	
		
	node = getstruct( "emp_anim_heli_spot", "targetname" );		
	heli = spawn_anim_model( "emp_mi28", self.origin );
	heli maps\_vehicle::vehicle_lights_on( "running" );
	
	heli maps\_attack_heli::heli_spotlight_on( "tag_spotlight", false );
	
	heli thread play_loop_sound_on_entity( "scn_dcemp_cobra_shutdown_hover" );
	self delete();
	
//	node thread anim_first_frame_solo( heli, "crash" );
	
//	wait level.EMPWAIT_BETA;
											
	node thread anim_single_solo( heli, "crash" );
	
	heli waittillmatch( "single anim", "emp" );
	heli stop_loop_sound_on_entity( "scn_dcemp_cobra_shutdown_hover" );
	heli delaycall( .1, ::playsound, "scn_dcemp_cobra_shutdown" );
	
	flag_set( "emp_heli_crash_go" );
	heli thread heli_spark_effects();
	heli maps\_attack_heli::heli_spotlight_off();
	heli thread attackheli_spotlight_flicker();
	heli maps\_vehicle::vehicle_lights_off( "running" );
	
	heli waittillmatch( "single anim", "explode" );
	heli notify( "stop_heli_spark_effects" );
	heli playsound( "scn_dcemp_cobra_shutdown_crash" );
	
	flag_set( "emp_heli_crash" );
	
	playfx( level._effect[ "helicopter_crash" ], heli gettagorigin( "TAG_DEATHFX" ) );
	//thread play_sound_in_space( "mi17_helicopter_crash_dist", heli gettagorigin( "TAG_DEATHFX" ) );
	heli setmodel( "vehicle_mi-28_d_animated" );
	
	time = 0;
	level.player delaycall( time, ::PlayRumbleLoopOnEntity, "tank_rumble" );
	level.player delaycall( 1.5 + time, ::stopRumble, "tank_rumble" );
	noself_delaycall( time, ::earthquake, 0.25, 1.5, level.player.origin, 5000 );
	
	node waittill( "crash" );
	//heli delete();
}

heli_spark_effects()
{
	self endon( "stop_heli_spark_effects" );
	while ( true )
	{
		playfxontag( getfx( "powerline_runner_oneshot" ), self, "tag_engine_left" );
		wait( RandomFloatRange( .15, .25 ) );
	}
	
}

attackheli_spotlight_flicker()
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
}


#using_animtree( "vehicles" );
emp_heli_rappel()
{
	if( !isdefined( level.helis_crash_rappel ) )
		level.helis_crash_rappel = [];
	level.helis_crash_rappel[ level.helis_crash_rappel.size ] = self;	
	
	self thread emp_stop_start_heli();
	
	flag_wait( "emp_heli_crash_go" );
	wait .25;
	
	if( isdefined( level.emp_heli_rappel ) )
		wait .5;
	level.emp_heli_rappel = 1;
	
	heli = spawn( "script_model", self.origin );
	heli.angles = self.angles;
	heli setmodel( self.model );
	heli.animname = "emp_heli_rappel";
	heli UseAnimTree( #animtree );
	self delete();
	
	heli thread heli_spark_effects();
	
	node = spawn( "script_origin", heli.origin );
	node.angles = ( 0, heli.angles[ 1 ], 0 );
	heli linkto( node );	
	node thread anim_single_solo( heli, "crash" );
	time = 6.5;
	node movez( -400, time, time, 0 );
	
	wait time;
	
	heli notify( "stop_heli_spark_effects" );
	playfx( level._effect[ "helicopter_explosion" ], heli.origin );
	thread play_sound_in_space( "mi17_helicopter_crash_dist", heli.origin );
			
	time = 1;
	level.player delaycall( time, ::PlayRumbleLoopOnEntity, "tank_rumble" );
	level.player delaycall( 1.0 + time, ::stopRumble, "tank_rumble" );
	noself_delaycall( time, ::earthquake, 0.2, 1, level.player.origin, 5000 );
	
	heli delete();
	node delete();
}

#using_animtree( "vehicles" );
emp_heli_distant()
{
	if( !isdefined( level.helis_crash_distant ) )
		level.helis_crash_distant = [];
	level.helis_crash_distant[ level.helis_crash_distant.size ] = self;	
	
	self thread emp_stop_start_heli();
		
	self emp_ents_wait( "emp_swap" );
	
	heli = spawn( "script_model", self.origin );
	heli.angles = self.angles;
	heli setmodel( self.model );
	heli.animname = "emp_heli_distant";
	heli UseAnimTree( #animtree );
	self delete();
	
	heli anim_single_solo( heli, "crash" );
	heli delete();
}

emp_btr()
{
	level.emp_btr80 = self;
	
	flag_wait( "emp_heli_crash_go" );
	
	wait .35;
		
	btr = spawn( "script_model", self.origin );
	btr.angles = self.angles;
	btr setmodel( self.model );
	
	btr thread heli_spark_effects();
	
	self delete();
	
	wait 2;
	
	btr notify( "stop_heli_spark_effects" );
}

emp_jet_crash()
{
	flag_wait( "iss_done" );
	
	wait 4;
	
	wait level.EMPWAIT_BETA;
	
	jet = spawn_vehicle_from_targetname_and_drive( "emp_jet_crasher" );
	
	//jet ent_flag_set( "contrails" );
	jet ent_flag_clear( "engineeffects" );
	
	wait 5.25;
	
	flag_set( "emp_jet_crash" );
	
	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
	level.player delaycall( 1, ::stopRumble, "tank_rumble" );
	earthquake( 0.15, 1, level.player.origin, 2000 );
	
	exploder( "emp_jet_crash" );
	
	wait .25;
	
	jet delete();
}

#using_animtree( "vehicles" );
emp_heli_crash()
{
	heli = getent( "emp_heli_crash_last", "targetname" );
	heli hide();
	
	flag_wait( "iss_done" );
	
	wait level.EMPWAIT_BETA;
	
	spawners = getentarray( "emp_heli_crash_guys", "targetname" );
	guys = array_spawn( spawners, true );
	
	guys[0] thread emp_heli_crash_guys_link( heli, "WHEEL_FRONT_L_JNT" );
	guys[1] thread emp_heli_crash_guys_link( heli, "WHEEL_FRONT_R_JNT" );
	
	wait .5;
	
	node = spawnstruct();
	node.origin = heli.origin;
	node.angles = heli.angles;
	
	heli.animname = "emp_heli_last";
	heli UseAnimTree( #animtree );
	node anim_first_frame_solo( heli, "crash" );
	
	wait 3.5;
	
	heli show();
	
	node thread anim_single_solo( heli, "crash" );	
			
	guys[ 0 ] delaythread( 7.5, ::emp_heli_crash_guys_fallout );
	guys[ 1 ] delaythread( 8.5, ::emp_heli_crash_guys_fallout );

	heli thread heli_spark_effects();
	
	wait 9.65;

	heli notify( "stop_heli_spark_effects" );
	playfxontag( level._effect[ "helicopter_explosion" ], heli, "TAG_ORIGIN" );
	thread play_sound_in_space( "exp_armor_vehicle", heli.origin );
	
	range = 900;
	maxd = 600;
	RadiusDamage( heli.origin + (0,0,10), range, maxd, 20, heli );//similar to destructibles
			
	time = .25;
	level.player delaycall( time, ::PlayRumbleLoopOnEntity, "tank_rumble" );
	level.player delaycall( 1.0 + time, ::stopRumble, "tank_rumble" );
	noself_delaycall( time, ::earthquake, 0.2, 1, level.player.origin, 5000 );
}

#using_animtree( "generic_human" );
emp_heli_crash_guys_link( heli, tag )
{
	self hide();
	self.ignoreme = true;
	self.ignoreall = true;
	
	heli anim_generic_first_frame( self, "fastrope_fall", tag );
	wait .1;
	self linkto( heli );
}

emp_heli_crash_guys_fallout()
{
	self show();
	
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles;
	
	self linkto( node );
	
	//find out the various end origins we need
	grndpos = GetGroundPosition( node.origin, 0, 1000, 64 );
	delta = getmovedelta( getanim_generic( "fastrope_fall" ), 0, 1 );
	endpos = node.origin + delta;
	animdist = abs( delta[ 2 ] );
	
	//this is the full distance from the ai's height to the ground
	fulldist = node.origin[ 2 ] - grndpos[ 2 ];
	//this is the extra distance we need to cover that the animation does not
	extradist = endpos[ 2 ] - grndpos[ 2 ];
	//this is the length of time it takes for the ai to fall the distance of delta[ 2 ]
	length = getanimlength( getanim_generic( "fastrope_fall" ) );
	//this is the equation to figure out the time it takes to fall delta[ 2 ] + dist
	time = ( length * fulldist ) / animdist;	
	
	time -= .25;
	
	//this is the new rate the animation needs to play at in order for it to play the full length of time
	rate = ( length / time );
		
	self playsound( "generic_death_falling_scream" );	
	node thread anim_generic( self, "fastrope_fall" );	
	
	
	node movez( extradist * -1, time );
	node rotatevelocity( (0, randomfloatrange( -100, 100 ), 0), time );
	
	wait .05;
	
	self setanimknoball( getanim_generic( "fastrope_fall" ), %body, 1, 0, rate );
	
	wait time -.2;
	
	self.skipdeathanim = 1;
	self kill();
	self startragdoll();
	
	wait .1;
	
	playfx( level._effect[ "bodyfall_dust_high" ], grndpos );
}


/************************************************************************************************************/
/*													STREET													*/
/************************************************************************************************************/
street_hide_moment()
{
	foreach( member in level.team )
		member ent_flag_wait( "street_hide" );
	
	flag_wait( "street_player_hide" );
	flag_set( "street_safe" );
	flag_set( "street_crash_heli_hide" );
	
	flag_wait( "street_crash_hide" );
		
	wait CONST_STREET_CAR_WAIT;
		
	wait .1;

	exploder( "hide_heli_crash" );
	
	clip = getent( "hide_clip", "targetname" );	
	clip disconnectpaths();
	clip solid();
	
	if( isalive( level.player ) && level.player istouching( clip ) )
		level.player kill();
	
	array_thread( level.team, ::walkdist_reset );
	
	foreach( member in level.team )
	{
		anime = undefined;
		switch( member.script_noteworthy )
		{
			case "foley":	
				anime = "exposed_flashbang_v5";
				break;
			case "dunn":	
				anime = "exposed_flashbang_v1";
				break;
			case "marine1":	
				anime = "exposed_flashbang_v4";
				break;
			case "marine2":	
				anime = "exposed_flashbang_v1";
				break;
			case "marine3":	
				anime = "bog_b_spotter_react";
				break;
		}	
		member thread anim_generic_gravity_run( member, anime );
		member playsound( "generic_flashbang_american_" + randomintrange( 1,9 ) );
	}
		
	level.player shellshock( "default", 3 );
	
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
	
	level.sky delete();
	array_call( getaiarray( "axis" ), ::delete );
		
	glass = getglassarray( "street_hide_glass" );
	dir = anglestoforward( ( 0, 345, 0 ) );
	foreach( piece in glass )
		destroyglass( piece, dir * 200 );
	
//	time = 4.5;
//	array_thread( level.team, ::notify_delay, "killanimscript", time );
	
	wait 4;
	
	flag_set( "allow_ammo_pickups" );
	level.player giveWeapon( "Beretta" );
	level.player SetWeaponAmmoClip( "Beretta", 30 );
	level.player SetWeaponAmmoStock( "Beretta", 90 );
	level.player SetWeaponAmmoStock( "m4m203_eotech", 300 );
	level.player SetWeaponAmmoStock( "m203_m4_eotech", 9 );
	level.player setWeaponAmmoStock( "fraggrenade", 4 );
	level.player setWeaponAmmoStock( "flash_grenade", 4 );
	
	if( isalive( level.player ) )
		thread autosave_by_name( "street_hide_moment" );
	
	wait 1;
	SetSavedDvar( "ammoCounterHide", "0" );
	
	time = 1.25;
	wait time;
	//What the hell are we gonna do now? We got no air support...we got no comms…we're screwed man! We are totally- fucked!			
	level.dunn thread dialogue_queue( "dcemp_cpd_wearetotally" );
	wait 6.25 - time;
	//Shut up!! Get a grip Corporal! Our weapons still work, which means we can still kick some ass, huah?			
	level.foley thread dialogue_queue( "dcemp_fly_getagrip" );
	level.dunn delaycall( .5, ::stopsounds );
	flag_wait( "corner_start_crash_scene" );
	wait .4;
	
	level.foley stopsounds();
	
	wait .5;
		
	level.foley add_wait( ::anim_generic_gravity, level.foley, "corner_standR_explosion_divedown" );
	level.foley add_func( ::anim_generic_gravity_run, level.foley, "corner_standR_explosion_standup" );
	thread do_wait();
	
	wait .5;
	level.team[ "marine2" ] thread anim_generic( level.team[ "marine2" ], "bog_b_spotter_react" );
	length = getanimlength( getanim_generic( "bog_b_spotter_react" ) );
	level.team[ "marine2" ] delaythread( length * .93, ::anim_stopanimscripted );	
	
	wait .45;
	
	level.team[ "marine1" ] thread anim_generic_run( level.team[ "marine1" ], "corner_standR_flinchB" );
		
	wait .15;
	
	level.team[ "marine3" ] thread anim_generic( level.team[ "marine3" ], "bog_b_spotter_react" );
	length = getanimlength( getanim_generic( "bog_b_spotter_react" ) );
	level.team[ "marine3" ] delaythread( length * .93, ::anim_stopanimscripted );
	
	wait .05;
	
	level.dunn thread anim_generic_run( level.dunn, "exposed_idle_reactA" );
	
	array_thread( level.team, ::walkdist_zero );	
}

street_heli_player_kill()
{
	magicnumber = .001;
	time = 22;
	
	units = time / magicnumber;
	
	model = spawn( "script_model", level.player.origin + ( 0,0,units + 60 ) );
	model setmodel( "vehicle_little_bird_landed" );
	
	model rotatevelocity( (0,100,0), time + 1 );
	
	interval = .1;
	count = int( time / interval );
	frac = ( units / count ) * -1;
	time = 1;
	
	while( !flag( "street_safe" ) && count > 0 )
	{
		if( !flag( "street_insta_death" ) )
		{
			org = ( model.origin[0] + ( level.player.origin[0] - model.origin[0] ) * .25, model.origin[1] + ( level.player.origin[1] - model.origin[1] ) * .25, model.origin[2] + frac );
			model moveto( org, interval );
			wait interval;	
			count--;
		}
		else
		{
			org = ( model.origin[0] + ( level.player.origin[0] - model.origin[0] ) * .25, model.origin[1] + ( level.player.origin[1] - model.origin[1] ) * .25, level.player.origin[2] + 50 ); 	
			model moveto( org, time );
			wait interval;	
			time -= interval;
			if( time <= 0 )
				count = 0;
			else
				count--;
		}
	}
	
	origin = level.player.origin + (0,0,80);
	model delete();
	
	if( flag( "street_safe" ) )
		return;
		
	range = 300;
	
	PhysicsExplosionSphere( origin, range, 0, range * .01 );//similar to destructibles	
	
	playfx( level._effect[ "helicopter_explosion" ], origin );
	thread play_sound_in_space( "exp_armor_vehicle", origin );
	
	wait .2;
	
	level.player kill();
}

#using_animtree( "generic_human" );
street_guy_fall_guy()
{
	node = getstruct( self.target, "targetname" );
	
	self playsound( "generic_death_falling_scream" );
	
	node anim_generic( self, "fastrope_fall" );
	self.skipdeathanim = 1;
	self kill();
	self startragdoll();
	
	flag_set( "street_guy_fall" );
}

street_btr_scene()
{
	//SETUP
	heli 	= getent( "street_heli", "targetname" );
	target 	= getent( "street_heli_target", "targetname" );
	slide1 	= getent( "street_btr_slide_1", "targetname" );
	slide2 	= getent( "street_btr_slide_2", "targetname" );
	
	heli 	hide();
	target 	hide();
	slide1 	hide();
	slide2 	hide();		
	target 	notsolid();
	slide1 	notsolid();
	slide2 	notsolid();
	
	dmg_trig = getent( "btr_dmg_trig", "targetname" );
	dmg_trig trigger_off();
	clip = getent( "street_btr80_d_clip", "targetname" );
	clip notsolid();
	clip connectpaths();
		
	self maps\_vehicle::mgoff();
	self stopsounds();
	d_heli = street_btr_make_destroyed_heli();
	level.street_btrorigin = self.origin;
	
	if( level.start_point != "corner" )
	{				
		flag_wait( "street_crash_btr_first" );
				
		//start dropping the heli
		street_btr_scene_drop_heli();
	
		flag_set( "street_btr_death" );
		waittillframeend;
									
		//kill the btr and get a model so we can animate it
		earthquake( .5, 1.25, level.player.origin, 2048 );
		level.player PlayRumbleLoopOnEntity( "tank_rumble" );
		level.player delaycall( 1.25, ::stopRumble, "tank_rumble" );
		
		dmg_trig trigger_on();
		model = self street_btr_scene_kill_btr();
		thread street_btr_blur( model );
		
		//show the damaged heli
		array_call( getentarray( "street_heli_destroyed", "targetname" ), ::show );
		
		//move the heli parts
		d_heli thread street_btr_animate_heli();
		
		//move the btr
		model street_btr_animate_btr();
	}
	else
	{
		model = self street_btr_scene_kill_btr();
		model.origin = slide2.origin;
		model.angles = slide2.angles;
	}	
		
	//delete the damage trig and turn on the clip brush
	clip solid();
	clip disconnectpaths();
	
	flag_set( "street_btr_scene_done" );	
}

street_crash_cars()
{
	parts = array_combine( getentarray( self.target, "targetname" ), getstructarray( self.target, "targetname" ) );
	info = [];
	info[ "fx" ] = [];
	info[ "light" ] = [];
	
	foreach( part in parts )
	{
		switch( part.script_noteworthy )
		{
			case "fire_fx":
				info[ "fx" ][ info[ "fx" ].size ] = part;
				break;	
			case "light":
				part.old_intensity = part getlightintensity();
				part setlightintensity( 0 );
				info[ "light" ][ info[ "light" ].size ] = part;
				break;
			case "start":
				self.endorg = self.origin;
				self.endang = self.angles;
				self.origin = part.origin;
				self.angles = part.angles;
				part delete();
				break;				
		}	
	}
	
	if( level.start_point == "corner" )
	{
		self maps\_vehicle::force_kill();
		if( isdefined( self.endorg )) 
		{
			self.origin = self.endorg;
			self.angles = self.endang;
		}
	}	
	else
	{
		flag_wait( self.script_flag_wait );
	
		self maps\_vehicle::force_kill();
	
		wait CONST_STREET_CAR_WAIT;
	
		do_player_crash_fx( self.origin );
	
		if( isdefined( self.endorg )) 
		{
			magicnumber = .005;
			time = distance( self.origin, self.endorg ) * magicnumber;
			self moveto( self.endorg, time );
			self rotateto( self.endang, time );
			wait time;	
		}
	}

	//fx and light
	foreach( fx in info[ "fx" ] )
	{
		playfx( level._effect[ "me_dumpster_fire_FX" ], fx.origin, anglestoforward( fx.angles ), anglestoup( fx.angles ) );
		thread play_loopsound_in_space( "fire_dumpster_medium", fx.origin );
	}		
	foreach( light in info[ "light" ] )
		light setlightintensity( light.old_intensity );
	
	wait .05;
			
	array_thread( info[ "light" ], ::light_street_fire );	
}

street_crash_helis()
{
	parts = array_combine( getentarray( self.target, "targetname" ), getstructarray( self.target, "targetname" ) );
	deathmodel 	= [];
	fx_array = [];
	clip 		= undefined;
	endorg	 	= undefined;
	endang	 	= undefined;
	foreach( part in parts )
	{
		switch( part.script_noteworthy )
		{
			case "end":
				endorg = part.origin;
				endang = part.angles;
				part delete();
				break;
			case "destroy":
				part hide();
				deathmodel[ deathmodel.size ] = part;
				break;
			case "fire_fx":
				fx_array[ fx_array.size ] = part;
				break;
			case "clip":
				clip = part;
				clip notsolid();
				break;
		}
	}
	
	if( level.start_point != "corner" && level.start_point != "meetup"  )
	{
		self hide();
		
		if( self.script_flag_wait == "street_crash_heli_first" )
			self.origin += ( 0,0, CONST_NEW_HELI_DROP_HEIGHT );	
			//self.script_flag_wait = "street_crash_btr_first";
			
		flag_wait( self.script_flag_wait );
		
		self show();
			
		dist = distance( self.origin, endorg );
		magicnumber = .001;
		time = dist * magicnumber;
		
		sndtime = time - 3;
		if( sndtime >= 0 )
			self delaycall( sndtime, ::playsound, "scn_dcemp_heli_shutdown" );
					
		self moveto( endorg, time, time );
		self rotateto( endang, time );
		
		if( isdefined( self.script_flag_set ) )
			thread flag_set_delayed( self.script_flag_set, time - CONST_STREET_CAR_WAIT );
		self waittill( "movedone" );
		
		do_player_crash_fx( self.origin );
		
		range = 300;
		maxd = 300;
		if( !flag( "street_safe" ) )
			RadiusDamage( self.origin + (0,0,10), range, maxd, 20, self );//similar to destructibles
		PhysicsExplosionSphere( self.origin, range, 0, range * .01 );//similar to destructibles	
		
		playfx( level._effect[ "helicopter_explosion" ], endorg + ( 0, 0, -128) );
		thread play_sound_in_space( "exp_armor_vehicle", endorg );
	}
		
	self delete();			
	
	if( isdefined( clip ) )
		clip solid();	
	if( deathmodel.size )
		array_call( deathmodel, ::show );
	foreach( fx in fx_array )
	{
		playfx( level._effect[ "me_dumpster_fire_FX" ], fx.origin, anglestoforward( fx.angles ), anglestoup( fx.angles ) );
		thread play_loopsound_in_space( "fire_dumpster_medium", fx.origin );
	}	
	
}

#using_animtree( "vehicles" );
street_crash_helis_anim()
{
	parts 	= [];
	fx_array = [];
	clip = undefined;
	dmg = undefined;
	
	if( isdefined( self.target ) )
		parts = array_combine( getentarray( self.target, "targetname" ), getstructarray( self.target, "targetname" ) );
		
	foreach( part in parts )
	{
		switch( part.script_noteworthy )
		{
			case "fire_fx":
				fx_array[ fx_array.size ] = part;
				break;
			case "clip":
				clip = part;
				clip notsolid();
				break;
			case "damage":
				dmg = part;
				dmg trigger_off();
				break;
		}
	}
	
	name = "street_mi28";
	switch( self.script_flag_set )
	{
		case "street_crash_cop":
			name = "street_mi28a";
			break;
		
		case "street_crash_left":
			name = "street_bh";
			break;
		
		case "street_crash_left2":
			name = "street_mi28b";
			break;
	}
	
	if( level.start_point != "corner" && level.start_point != "meetup"  )
	{		
		flag_wait( self.script_flag_wait );
		
		
		switch( self.script_flag_set )
		{		
			case "street_crash_left":
				car = getent( "street_cars_blackhawk_bounce", "targetname" );
				clipcar = getent( "street_blackhawk_car_clip", "targetname" );
				clipcar linkto( car );
				
				//car.angles += (0,90,0);
				car.animname = "street_car";
				car UseAnimTree( #animtree );
				self thread anim_single_solo( car, "crash" );
				break;
		}
	}
				
	heli = spawn_anim_model( name, self.origin );
	self thread anim_single_solo( heli, "crash" );	
	
	if( level.start_point != "corner" && level.start_point != "meetup" )
	{	
//		heli waittillmatch( "single anim", "play_sound" );
//		heli playsound( "scn_dcemp_heli_shutdown" );
		
		heli waittillmatch( "single anim", "pre_explode" );		
	
		thread flag_set( self.script_flag_set );
		
		heli waittillmatch( "single anim", "explode" );
		
		switch( self.script_flag_set )
		{
			case "street_crash_cop":
				name = "vehicle_mi-28_d_animated";
				break;
			
			case "street_crash_left":	
				thread street_heli_crash_secondaries_2();
				name = "vehicle_blackhawk_crash";
				break;
			
			case "street_crash_left2":
				thread street_heli_crash_secondaries_3();
				name = "vehicle_mi-28_d_animated";
				break;
		}
		
		dmg trigger_on();	
		heli setmodel( name );
				
		do_player_crash_fx( self.origin );
		
		range = 300;
		maxd = 300;
		if( !flag( "street_safe" ) )
			RadiusDamage( heli gettagOrigin( "TAG_DEATHFX" ), range, maxd, 20, heli );//similar to destructibles
		PhysicsExplosionSphere( heli gettagOrigin( "TAG_DEATHFX" ), range, 0, range * .01 );//similar to destructibles	
		
		switch( self.script_flag_set )
		{
			
			case "street_crash_left":
				playfx( level._effect[ "helicopter_crash" ], heli gettagorigin( "TAG_DEATHFX" ) + (0,0,-60) );
				break;
				
			case "street_crash_cop":
			case "street_crash_left2":
				playfxontag( level._effect[ "helicopter_explosion" ], heli, "TAG_DEATHFX" );
				break;
		}
		
		thread play_sound_in_space( "exp_armor_vehicle", heli gettagOrigin( "TAG_DEATHFX" ) );
		
		heli waittillmatch( "single anim", "end" );
	}
	else
	{
		heli waittillmatch( "single anim", "explode" );
		switch( self.script_flag_set )
		{
			case "street_crash_cop":
				name = "vehicle_mi-28_d_animated";
				break;
			
			case "street_crash_left":	
				thread street_heli_crash_secondaries_2();
				name = "vehicle_blackhawk_crash";
				break;
			
			case "street_crash_left2":
				thread street_heli_crash_secondaries_3();
				name = "vehicle_mi-28_d_animated";
				break;
		}
		heli setmodel( name );
	}
	
	dmg delete();
	
	if( isdefined( clip ) )
		clip solid();					
	foreach( fx in fx_array )
	{
		playfx( level._effect[ "me_dumpster_fire_FX" ], fx.origin, anglestoforward( fx.angles ), anglestoup( fx.angles ) );
		thread play_loopsound_in_space( "fire_dumpster_medium", fx.origin );
	}	
	
}

street_heli_crash_secondaries_2()
{
	trees = getentarray( "street_blackhawk_tree", "targetname" );
	array_thread( trees, ::street_trees );
	dmg = getstructarray( "street_damage_node_2", "targetname" );
	array_thread( dmg, ::street_damage_radius );		
}

street_heli_crash_secondaries_3()
{
	trees = getentarray( "street_heli3_tree", "targetname" );
	array_thread( trees, ::street_trees );
	dmg = getstructarray( "street_damage_node_3", "targetname" );
	array_thread( dmg, ::street_damage_radius );		
}

street_damage_radius()
{
	RadiusDamage( self.origin, self.radius, 1000, 1000 );	
}

street_trees()
{
	dir = [];
	dir[0] = anglestoforward( ( 0, 160 - randomfloatrange( 50, 90 ), 0 ) );
	dir[1] = anglestoforward( ( 0, 160, 0 ) );
	dir[2] = anglestoforward( ( 0, 160 + randomfloatrange( 50, 90 ), 0 ) );
	
	time = 2;
	parts = getentarray( self.target, "targetname" );
	
	self delete();
	centers = [];
	
	foreach( part in parts )
	{
		org = getent( part.target, "targetname" );;
		part linkto( org );
		centers[ centers.size ] = org;
	}
	
	foreach( index, part in centers )
	{
		vec = dir[ index ];
		
		p = randomfloatrange( 100, 150 );
		r = randomfloatrange( 100, 150 );
		if( cointoss() )
			p *= -1;
		if( cointoss() )
			r *= -1;
					
		vec += ( 0,0, randomfloat( .5 ) + .75 );
		vec *= randomfloatrange( 300, 400 );
		rot = ( p, 0, r );
		
		part movegravity( vec, time );
		part rotatevelocity( rot, time, 0, time );
		
	}
	
	wait time;
	
	array_call( parts, ::delete );
	array_call( centers, ::delete );
}


street_cars_bounce()
{
	flag_wait( self.script_noteworthy );
	
	wait randomfloatrange( .2, .4 );
	
	height = randomfloatrange( 15, 24 );
	time = randomfloatrange( .5, .75 );
	min = 5;
	max = 10;
	
	rotation = ( randomfloatrange( min, max ), randomfloatrange( min, max ), randomfloatrange( min, max ) );
	angles = self.angles;
	origin = self.origin;
	
	self movez( height, time, 0, time * .5 );
	self rotateto( self.angles + rotation, time, 0, time );
	
	wait time * .6;
	
	self delaycall( time * .5, ::rotateto, angles, time * .5 );
	self moveto( origin, time, time, 0 );
	
	wait time;	
	
	time = time * .2;
	height = height * .1;
	rotation = rotation * .1;
	
	self movez( height, time, 0, time );
	self rotateto( self.angles + rotation, time, 0, time );
	
	wait time * .85;
	
	self delaycall( time * .5, ::rotateto, angles, time * .5 );
	self moveto( origin, time, time, 0 );
}

street_crash_motorcycle()
{
	forward = anglestoforward( self.angles );
	target = getent( self.target, "targetname" );
	endorg = target.origin;
	endang = target.angles;
	target delete();
	
	origin = self.origin;
	angles = self.angles;
	
	self.origin = self.origin + ( forward * 400 );
	self.angles = self.angles + ( 0,180,0 );
	flag_wait( "street_crash_left2" );
	
	wait .5;
	
	playfxontag( level._effect[ "firelp_med_pm" ], self, "tag_death_fx" );
	self playloopsound( "fire_dumpster_medium" );
	
	wait 2.5;
	
	playfx( level._effect[ "small_vehicle_explosion" ], self.origin );
	self playsound( "car_explode" );
	
	time = 1.5;	
			
	self moveto( origin, time );	
	self rotateto( angles, time );
	
	wait time;
		
	time = 1;	
	self moveto( endorg, time, 0, time );
	self rotateto( endang, time, 0, time );
	
	wait time;
	
	self.origin = self.origin;
	self.angles = self.angles;
}

street_btr_make_destroyed_heli()
{
	pieces = getentarray( "street_heli_destroyed", "targetname" );
	array_call( pieces, ::hide );	
	
	array = [];
	foreach( part in pieces )
	{
		array[ part.script_noteworthy ] = part;
		part notsolid();
	}
	body = array[ "back" ];
	body.parts = array;

	return body;
}

street_btr_scene_drop_heli()
{
	heli 	= getent( "street_heli", "targetname" );
	target 	= getent( "street_heli_target", "targetname" );
	heli show();
	
	dist = distance( heli.origin, target.origin );
	magicnumber = .001;
	time = dist * magicnumber;
		
	heli moveto( target.origin, time, time );
	heli rotatevelocity( ( 0,105,0 ), time );
		
	wait time;	
	
	heli delete();
	target delete();
}

street_btr_scene_kill_btr()
{	
	model = spawn( "script_model", self.origin );
	model.angles = self.angles;
	model setmodel( "vehicle_btr80_d" );
	model.vehicletype = self.vehicletype;
	model.modeldummyon = false;
	model thread maps\_vehicle::kill_fx( "vehicle_btr80", false );
		
	self delete();
				
	range = 300;
	RadiusDamage( model.origin + (0,0,10), range, 300, 20, model );//similar to destructibles
	PhysicsExplosionSphere( model.origin, range, 0, range * .01 );//similar to destructibles	
			
	return model;
}

street_kill_vehicle()
{
	model = spawn( "script_model", self.origin );
	model.angles = self.angles;
	model setmodel( self.model );
	
	model.vehicletype = self.vehicletype;
	model.modeldummyon = false;
	model thread maps\_vehicle::kill_fx( self.model, false );
	
	self delete();
				
	range = 300;
	RadiusDamage( model.origin + (0,0,10), range, 300, 20, model );//similar to destructibles
	PhysicsExplosionSphere( model.origin, range, 0, range * .01 );//similar to destructibles	
			
	return model;
}

street_btr_animate_btr()
{
	slide1 = getent( "street_btr_slide_1", "targetname" );
	slide2 = getent( "street_btr_slide_2", "targetname" );
	
	dmg_trig = getent( "btr_dmg_trig", "targetname" );	
	dmg_trig thread street_btr_move_dmg_trig( self );
		
	time = CONST_BTR_SLIDE_TIME_1;
	self moveto( slide1.origin, time, 0, time );
	self rotateto( slide1.angles, time, 0, time );
		
	wait time;
					
	time = CONST_BTR_SLIDE_TIME_2;
	self moveto( slide2.origin, time, time, 0 );
	self rotateto( slide2.angles, time, time, 0 );
	
	wait time;
	earthquake( .2, .5, level.player.origin, 2048 );
	
	//cleanup
	slide1 delete();
	slide2 delete();	
}

street_btr_blur( btr )
{
	if( !player_looking_at( btr.origin, undefined, true ) )
		return;
	
	setblur( 4, 0 );	
	wait .1;
	setblur( 0, .5 );	
}

street_btr_move_dmg_trig( btr )
{
	btr_origin = btr.origin;
	dmg_origin = self.origin;
	
	while( !flag( "street_btr_scene_done" ) )
	{
		delta = btr.origin - btr_origin;
		self.origin = ( dmg_origin + ( delta[ 0 ], delta[ 1 ], 0 ) );
		wait .05;
	}	
	
	self delete();
}

street_btr_animate_heli()
{
	struct = getstruct( "street_physics_launch_point", "targetname" );
	parts = self.parts;		
	foreach( part in parts )
	{
		vec = vectornormalize( ( part.origin + (0,0,32) ) - struct.origin );
		vec = vec * randomfloatrange( 800, 900 );
		//part PhysicsLaunchClient( targets[ part.script_noteworthy ].origin, vec );
		part movegravity( vec, 5 );
		part rotatevelocity( ( randomfloatrange( 150, 250 ), randomfloatrange( 150, 250 ), randomfloatrange( 150, 250 ) ), 5, 0, 5 );
	}
	
	wait 5;
	foreach( part in parts )
		part delete();
}

do_player_crash_fx( origin )
{
	if( flag( "do_player_crash_fx" ) )
		return;
	flag_set( "do_player_crash_fx" );
	
	thread flag_clear_delayed( "do_player_crash_fx", .25 );
		
	dist = distancesquared( level.player.origin, origin );
	
	//player stuff		
	if( dist < squared( 1500 ) )
	{
		level.player PlayRumbleLoopOnEntity( "tank_rumble" );
		level.player delaycall( 1.0, ::stopRumble, "tank_rumble" );
		earthquake( 0.5, 1, origin, 2000 );
		level.player setvelocity( anglestoup( level.player.angles ) * 210 );
		if( dist < squared( 650 ) )
		{
			//level.player dirtEffect( origin );
				
			level.player allowStand( false );
			level.player allowProne( false );
			level.player setstance( "crouch" );
			
			level.player blend_movespeedscale( .5 );
	
			level.player delayThread( .1, ::playLocalSoundWrapper, "breathing_hurt" );
			
			time = 1;
			level.player delayThread( .5, ::blend_movespeedscale, .8, 1.0 );
			level.player delayThread( time + .25, ::playLocalSoundWrapper, "breathing_better" );
			level.player delaycall( time, ::allowStand, true );
			level.player delaycall( time, ::allowProne, true );
			level.player delaycall( time, ::setstance, "stand" );	
		}	
	}
}

/************************************************************************************************************/
/*													CORNER													*/
/************************************************************************************************************/
corner_hide_damage()
{
	scene = corner_get_scene();
	
	array_call( scene[ "lights" ], ::setlightintensity, 0.0 );
}

corner_show_damage()
{
	scene = corner_get_scene();
	
	array_call( scene[ "lights" ], ::setlightintensity, 2.0 );
	wait .05;
		
	array_thread( scene[ "lights" ], ::light_street_fire );	
	exploder( "plane_crash_aftermath" );
}

corner_get_scene()
{
	array = [];
		
//	fixed an issue from rockets checkin when you where away. -Roger
//	plane = getentarray( "corner_crash_plane", "targetname" );
//	tail = getentarray( "crash_plane_tail", "targetname" );
//	post_crash_ents = array_combine( plane, tail );
//	array[ "plane" ] 		= plane;

	array[ "lights" ] 		= getentarray( "light_crash_fire", "script_noteworthy" );
	
	return array;
}	

corner_palm_style_door_open( soundalias )
{
	wait( 1.35 );

	if ( IsDefined( soundalias ) )
		self PlaySound( soundalias );
	else
		self PlaySound( "door_wood_slow_open" );

	self ConnectPaths();
	
	self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 29, 0 ), 1.5, 0, 1.5 );
}

corner_plane_launch()
{
	wait randomfloat( 2 );
	
	names = [];
	names[ names.size ] = "vehicle_van_white_door_rb";
	names[ names.size ] = "bc_military_tire01";
	names[ names.size ] = "vehicle_van_white_hood";
	names[ names.size ] = "rubble_large_slab_02";
	names[ names.size ] = "727_seats_row_left";	
		
	if( !isdefined( level.corner_plane_launch_num ) )
		level.corner_plane_launch_num = 0;
	
	level.corner_plane_launch_num++;
	
	if( level.corner_plane_launch_num == names.size )
		level.corner_plane_launch_num = 0;
		
	name = names[ level.corner_plane_launch_num ];
	
	model = spawn( "script_model", self.origin );
	model setmodel( name );
	
	vec = anglestoforward( self.angles ) * randomfloatrange( 1300, 1500 );
	neg1 = 1;
	neg2 = 1;
	neg3 = 1;
	
	if( cointoss() )
		neg1 = -1;
	if( cointoss() )
		neg2 = -1;
	if( cointoss() )
		neg3 = -1;
	
	fxmod = spawn( "script_model", model.origin );
	fxmod setmodel( "tag_origin" );
	fxmod linkto( model );
	playfxontag( level._effect[ "firelp_med_pm_nolight" ], fxmod, "TAG_ORIGIN" );
	
	time = 1.0;
	model movegravity( vec, time );
	model rotatevelocity( ( randomfloatrange( 50, 100) * neg1, randomfloatrange( 50, 100) * neg2, randomfloatrange( 50, 100) * neg3 ), time );
	
	node = getstruct( "corner_anim1", "targetname" );
	
	wait time - .05;

	names = [];
	names[ names.size ] = "wood_door_kick";
	names[ names.size ] = "explo_tree";
	names[ names.size ] = "door_wood_double_kick";
	names[ names.size ] = "door_wood_fence_post_kick";
	names[ names.size ] = "door_cargo_container_burst_open";
	names[ names.size ] = "bullet_ap_metal";
	
	thread play_sound_in_space( random( names ), fxmod.origin );
	
	wait .05;
	
	fxmod delete();
	model delete();	
}

corner_truck_engine_crash()
{
	self corner_vehicle_engine_crash_setup();
	
	flag_wait( "corner_engine_hit" );
	
	level.corner_engine linkto( self );
	self delaythread( .25, ::corner_vehicle_engine_crash_move );
	
	node = getstruct( "corner_engine_fx_sparks", "targetname" );
	centerfx = spawn( "script_model", node.origin );
	centerfx.angles = node.angles;
	centerfx setmodel( "tag_origin" );
	centerfx linkto( self );
					
	wait .2 + .25;
	
	for( i=0; i< 11; i++ )
	{
		playfx( level._effect[ "fire_trail_60" ], centerfx.origin + ( randomfloatrange( -15, 15 ), 0, -5 ), anglestoup( centerfx.angles ), anglestoforward( centerfx.angles ) );
	
		if( i > 8 )
			wait .2;
		else
			wait .1;
	}	
	
	wait .25;
	
	playfx( level._effect[ "firelp_med_pm_nolight" ], centerfx.origin );//, anglestoup( centerfx.angles ), anglestoforward( centerfx.angles ) );
	
	wait 3.0;
	
	flag_set( "corner_look_outside" );
	
	centerfx delete();
}

corner_vehicle_engine_crash_setup()
{
	self thread street_cars_bounce();
	ents = getentarray( self.target, "targetname" );
	array = [];
	
	foreach( ent in ents )
		array[ ent.script_noteworthy ] = ent;	
	
	array[ "clip" ] linkto( self );
	array[ "clip" ] disconnectpaths();
	
	self.clip = array[ "clip" ];
	self.endorg = array[ "target" ].origin;
	self.endang = array[ "target" ].angles;
	
	array[ "target" ] delete();
}

corner_engine_crash()
{	
	self hide();
	target1 = getent( self.target, "targetname" );
	target2 = getent( target1.target, "targetname" );
	midorg = target1.origin;
	midang = target1.angles;
	endorg = target2.origin;
	endang = target2.angles;
	
	target1 delete();
	target2 delete();
	
	flag_wait( "corner_engine_crash" );	
	
	self show();
	node = getstruct( "corner_engine_fx_fire", "targetname" );
	fx = spawn( "script_model", node.origin );
	fx.angles = node.angles;
	fx setmodel( "tag_origin" );
	fx linkto( self );
	
	playfxontag( level._effect[ "window_fire_large" ], fx, "TAG_ORIGIN" );
	self playloopsound( "fire_dumpster_medium" );
	
	magicnumber = .001;
	time = distance( self.origin, midorg ) * magicnumber;
	self moveto( midorg, time );
	self rotateto( midang, time );
	wait time;	
	
	self playsound( "exp_armor_vehicle" );
	
	time = .5;
	earthquake( 0.5, time, self.origin, 3000 );
	quakeobj = spawn( "script_origin", level.player.origin + (0,0,200) );
	quakeobj PlayRumbleLoopOnEntity( "steady_rumble" );
	quakeobj delaycall( time, ::stopRumble, "steady_rumble" );
		
	magicnumber = .001;
	time = distance( self.origin, endorg ) * magicnumber;
	
	self moveto( endorg, time );
	self rotateto( endang, time );
	wait time;
		
	level.corner_engine = self;
	self playsound( "exp_armor_vehicle" );

	time = 1.5;
	
	earthquake( 0.5, time * .5, self.origin, 3000 );
	quakeobj.origin += (0,0,50);
	quakeobj PlayRumbleLoopOnEntity( "steady_rumble" );
	quakeobj movez( 700, time );
	quakeobj delaycall( time, ::stopRumble, "steady_rumble" );
	quakeobj delaycall( time + .1, ::delete );
	
	flag_set( "corner_engine_hit" );
	
}

corner_vehicle_engine_crash_move()
{
	self.clip connectpaths();
		
	magicnumber = .0025;
			
	time = distance( self.origin, self.endorg ) * magicnumber;
		
	self moveto( self.endorg, time, 0, time );
	self rotateto( self.endang, time, 0, time );
	wait time + .2;	
		
	self.clip disconnectpaths();
}

corner_dead_check()
{
	spawner = getent( "meepup_dead_guy", "targetname" );
	guy = dronespawn_bodyonly( spawner );
	level.corner_dead_check_guy = guy;
	guy.animname = "dead_guy";
	
	wait .05;
	guy gun_remove();
	node = getstruct( spawner.target, "targetname" );
	node thread anim_loop_solo( guy, "hunted_woundedhostage_idle_start" );
	
	flag_wait( "parking_main" );
	guy delete();
}


/************************************************************************************************************/
/*													MEETUP													*/
/************************************************************************************************************/
meetup_runner_threads()
{
	level.foley delaythread( 0, ::meetup_runner_jog, "meetup_runner_foley" );
	level.team[ "marine1" ] delaythread( 3, ::meetup_runner_walk, "meetup_runner_2" );
	level.team[ "marine3" ] delaythread( 2, ::meetup_runner_jog, "meetup_runner_3" );
	level.team[ "marine2" ] delaythread( 1.5, ::meetup_runner_walk, "meetup_runner_1" );
		
	level.dunn meetup_runner_dunn();
}

meetup_runner_dunn()
{
	node = getstruct( "meetup_runner_anim_node", "targetname" );
	node.origin = self.origin;
		
	//start
	self disable_exits();
	self disable_arrivals();
	self setlookatentity( level.runner );
	
	self clearentitytarget();
	self set_ignoreall( true );
	self disable_dontevershoot();
				
	self anim_generic_run( self, "exposed_crouch_2_stand" );
	self thread anim_generic( self, "stand_exposed_wave_halt_v2" );	

	self.alertlevel = "noncombat";
	self allowedstances( "stand" );
		
	flag_wait( "meetup_do_scripted_scene" );
	
	//node waittill( "DCemp_run_sequence" );
	time = getanimlength( getanim_generic( "DCemp_run_sequence_guy1" ) );
	time *= .62;
	self thread delaycall( time, ::setlookatentity );
	
	node anim_generic_gravity( self, "DCemp_run_sequence_guy1" );
	self setgoalpos( self.origin );
}

meetup_runner_jog( name )
{
	meetup_runner_start();
	
	node = getstruct( name, "targetname" );
	
	ent = spawn( "script_origin", self.origin );
	ent.angles = self.angles;
	
	self linkto( ent );
	
	time = .75;
	ent rotateto( vectortoangles( node.origin - ent.origin ), time, time );
	ent thread anim_generic_run( self, "casual_killer_jog_start" );
	
	ent waittill( "rotatedone" );
	self unlink();
	ent delete();
	
	self thread meetup_runner_end();
	
	self set_generic_run_anim_array( "casual_killer_jog" );
	node anim_generic_reach( self, "casual_killer_jog_stop" );
	node anim_generic_gravity_run( self, "casual_killer_jog_stop" );
	
	self setgoalpos( self.origin );
	self ent_flag_set( "meetup_runner_end" );
}

meetup_runner_walk( name )
{
	meetup_runner_start();
	
	node = getstruct( name, "targetname" );
	
	ent = spawn( "script_origin", self.origin );
	ent.angles = self.angles;
	
	self linkto( ent );
	
	time = .5;
	ent rotateto( vectortoangles( node.origin - ent.origin ) + (0,10,0), time, time );
	ent thread anim_generic_run( self, "patrol_bored_2_walk" );
	
	ent waittill( "rotatedone" );
	self unlink();
	ent delete();
	
	self thread meetup_runner_end();
	
	self set_generic_run_anim_array( "patrol_bored_patrolwalk" );
	
	if( distance( node.origin, self.origin ) > 48 )
		node anim_generic_reach( self, "patrol_bored_walk_2_bored" );
	else
		node = self;
	
	node anim_generic_gravity_run( self, "patrol_bored_walk_2_bored" );
	
	self setgoalpos( self.origin );
	self ent_flag_set( "meetup_runner_end" );
}

meetup_runner_start()
{
	self disable_exits();
	self disable_arrivals();
	self setlookatentity( level.runner );
	
	switch( self.script_noteworthy )
	{
		case "foley":
			self anim_generic_run( self, "exposed_crouch_2_stand" );
			break;
		case "marine1":
			self anim_generic_run( self, "coverstand_hide_2_aim" );
			break;
		case "marine2":
			self anim_generic_run( self, "corner_standR_trans_alert_2_A_v2" );
			break;
	}
	self.alertlevel = "noncombat";
	self anim_generic_run( self, "casual_stand_idle_trans_in" );
	self allowedstances( "stand" );
}

#using_animtree( "generic_human" );
meetup_runner_end()
{	
	self ent_flag_init( "meetup_runner_end" );
	
	flag_wait( "meetup_runner_leave" );
	
	angle = 0;
	switch( self.script_noteworthy )
	{
		case "marine3":
			wait 0;
			angle = 80;
			break;
		case "marine2":
			wait .2;
			angle = 65;
			break;
		case "foley":	
			wait .5;
			angle = 70;
			break;
	}
	
	if( !angle )
		return;
		
	
	self ent_flag_wait( "meetup_runner_end" );
		
	self ai_turn( angle );	
		
	self anim_generic_run( self, "casual_stand_idle_trans_in" );
}




/************************************************************************************************************/
/*													LOBBY													*/
/************************************************************************************************************/
lobby_enemy_suppressive_fire()
{	
	level endon( "office_enemy_suppressive_fire" );
	level thread notify_delay( "office_enemy_suppressive_fire", 5 );
	
	node = getstruct( "office_magic_bullet_target2", "targetname" );
	target = spawnstruct();
	target.origin = self geteye();
	
	while( 1 )
	{
		weapon = "ak47";
		if( cointoss() )
			weapon = "rpd";
			
		shots = randomintrange( 10, 25 );
		for( i = 0; i < shots; i++ )
		{
			magicbullet( weapon, node.origin, target.origin + ( randomfloatrange( -64, 64 ), 0, randomfloat( 10 ) - 10  ) );
			wait .1;
		}
		wait randomfloatrange( .5, 1.5 );
	}
}


/************************************************************************************************************/
/*													OFFICE													*/
/************************************************************************************************************/
office_enemies_wave1()
{
	self endon( "death" );
	
	self.ignoreall = true;
	
	self.oldgrenadeammo = self.grenadeammo;
	self.grenadeammo = 0;
		
	add_wait( ::flag_wait, "lobby_robo_death" );
	self add_wait( ::waittill_msg, "damage" );
	level add_wait( ::waittill_msg, "office_enemies_wave1_hurt" );
	do_wait_any();
	
	level notify( "office_enemies_wave1_hurt" );
	self.ignoreall = false;
	
	trigger_wait( "office_enemies_wave2", "target" );
	self.grenadeammo = self.oldgrenadeammo;
}

office_enemies_wave1_runner()
{
	self.ignoreall = true;
	
	level delaythread( 2, ::dcemp_lightningFlash, "double" );
	thread flag_set_delayed( "_weather_lightning_enabled", 4 );
	
	self endon( "death" );
	self waittill( "goal" );
	
	self.ignoreall = false;	
}



/************************************************************************************************************/
/*													PARKING													*/
/************************************************************************************************************/
parking_drone()
{
	spawner = getent( "parkinglot_drone", "targetname" );
	guy = dronespawn_bodyonly( spawner );
	guy gun_remove();
	spawner anim_generic( guy, "death_pose_on_desk" );	
	
}

parking_dead_check()
{
	spawner = getent( "parking_dead_check_guy", "targetname" );
	guy = dronespawn_bodyonly( spawner );
	level.parking_dead_check_guy = guy;
	guy.animname = "dead_guy";
	
	wait .05;
	guy gun_remove();
	node = getstruct( spawner.target, "targetname" );
	node thread anim_loop_solo( guy, "hunted_woundedhostage_idle_start" );
	
	flag_wait( "tunnels_main" );
	guy delete();
}

parking_high_spec()
{
	while( 1 )
	{
		flag_wait( "parking_high_spec" );
		
		lerp_saveddvar( "r_specularColorScale", 15, 2 ); 
		
		flag_waitopen( "parking_high_spec" );
		
		lerp_saveddvar( "r_specularColorScale", 10, 2 ); 
	}
}

parking_btr_extra_wait()
{
	self thread anim_generic_loop( self, "coverstand_hide_idle" );
	
	while( !flag( "parking_open_fire" ) && distancesquared( self.origin, level.player.origin ) > squared( 1250 ) )
		wait .1;
	
	self notify( "stop_loop" );
	self anim_stopanimscripted();
}

parking_traverse_from_office()
{
	node = getent( "office_to_parking_jump_down", "targetname" );
	link = spawn( "script_origin", node.origin );
	link.angles = node.angles;
	
	link anim_generic_reach( self, "traverse_jumpdown_96" );
	link thread anim_generic( self, "traverse_jumpdown_96" );
	
	length = getanimlength( getanim_generic( "traverse_jumpdown_96" ) );
	wait length * .66;
	
	self anim_stopanimscripted();
	
	node = getent( "office_to_parking_hop", "targetname" );
	length = getanimlength( getanim_generic( "traverse40" ) );
	
	height1 = 25;
	height2 = -14;
	time1 = length * .34;
	time2 = length * .75;
	time3 = length - time2 - .25;
	
	link.origin = node.origin + ( 0,0, height1 );
	link.angles = node.angles;
	
	self linkto( link );
	link thread anim_generic_run( self, "traverse40" );
	link movez( height1 * -1, time1 );
	
	wait time2;
	
	link movez( height2, time3 );
	
	wait time3;
	
	self unlink();
}



/************************************************************************************************************/
/*													PLAZA													*/
/************************************************************************************************************/
plaza_flare_fx()
{
	model = getent( "street_flare", "targetname" );
	model.fxtag = getent( model.target, "targetname" );
	model.fxtag linkto( model );
	
	playfxontag( level._effect[ "groundflare" ], model.fxtag, "TAG_ORIGIN" );	
}

plaza_enemies()
{
	self endon( "death" );
	self endon( "long_death" );
	
	self.ignoreall = true;
	
	self add_wait( ::waittill_msg, "damage" );
	self add_wait( ::waittill_msg, "death" );
	self add_func( ::flag_set, "plaza_open_fire" );
	thread do_wait_any();
	
	self set_allowdeath( true );
	self walkdist_zero();
	self pathrandompercent_zero();
	
	self thread anim_generic_loop( self, "covercrouch_hide_idle" );
	
	self thread plaza_enemies_wakeup();
	self thread plaza_enemies_player_close();
	
	level endon( "plaza_open_fire" );
	level endon( "plaza_throw_react" );	
	flag_wait( "plaza_show_enemies" );
	
	node = getstruct( self.target, "targetname" );
	
	node script_delay();
	
	self notify( "stop_loop" );
	self anim_stopanimscripted();
	node anim_generic_reach( self, node.script_animation );
	node anim_generic_gravity_run( self, node.script_animation );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = 80;
}

plaza_enemies_player_close()
{
	level endon( "plaza_open_fire" );
	level.player endon( "death" );
	
	while( distancesquared( level.player.origin, self.origin ) > squared( 300 ) )
		wait .25;
	
	flag_set( "plaza_open_fire" );	
}

plaza_enemies_wakeup()
{
	self endon( "death" );
	self endon( "long_death" );
	
	flag_wait_any( "plaza_open_fire", "plaza_throw_react" );
		
	node = spawnstruct();
	node.origin = self.origin;
	node.angles = ( 0, 270, 0 );
	
	if( !isdefined( level.plaza_enemies_wakeup ) )
		level.plaza_enemies_wakeup = 0;
	
	self.reactnum = level.plaza_enemies_wakeup;
	level.plaza_enemies_wakeup++;
	
	anims = [];
	anims[ anims.size ] = "patrol_bored_react_look_retreat";
	anims[ anims.size ] = "exposed_idle_reactB";
	anims[ anims.size ] = "exposed_idle_reactB";
	
	delays = [];
	delays[ delays.size ] = 0;
	delays[ delays.size ] = 0;
	delays[ delays.size ] = .5;
	
	if( !flag( "plaza_open_fire" ) )
		wait .5;
	
	wait( delays[ self.reactnum ] );
	
	self anim_stopanimscripted();
	self.ignoreall = false;
	self walkdist_reset();
	self pathrandompercent_reset();	
	
	node anim_generic_gravity_run( self, anims[ self.reactnum ] );
}

/************************************************************************************************************/
/*													MISC													*/
/************************************************************************************************************/
send_team_to_random_nodes( team, nodes )
{
	index = 0;
	foreach( actor in team )
	{
		node = nodes[ index ];
		node.taken = actor;
		actor thread follow_path( node );	
		index++;
	}
}

send_team_to_specific_nodes( name, type )
{
	nodes = getnodearray( name, type );
	if( !nodes.size )
		nodes = getentarray( name, type );
	if( !nodes.size )
		nodes = getstructarray( name, type );
		
	foreach( node in nodes )
	{
		name = node.script_noteworthy;
		if( !isalive( level.team[ name ] ) )
			continue;
		level.team[ name ] thread follow_path( node );	
	}
}

emp_teleport_player( name )
{
	if ( !isdefined( name ) )
		name = level.start_point;

	array = getstructarray( "start_point", "targetname" );

	nodes = [];
	foreach ( ent in array )
	{
		if ( ent.script_noteworthy != name )
			continue;

		nodes[ nodes.size ] = ent;
	}

	teleport_players( nodes );
}

emp_teleport_team( team, nodes )
{	
	index = 0;
	foreach( actor in team )
	{
		actor thread teleport_actor( nodes[ index ] );
		index++;
	}
}

emp_teleport_team_specific( team, nodes )
{
	foreach( node in nodes )
		level.team[ node.script_noteworthy ] thread teleport_actor( node );
}

teleport_actor( node )
{
	link = spawn( "script_origin", self.origin );
	link.angles = self.angles;
	self linkto( link );
	
	link moveto( node.origin, .05 );
	if( isdefined( node.angles ) )
		link rotateto( node.angles, .05 );
	
	link waittill( "movedone" );
	wait .05;
	
	self setgoalpos( node.origin );
	self unlink();
	link delete();
	self orientmode( "face angle", node.angles[ 1 ] );
}

flickerlight_flares()
{
	wait randomfloatrange( .05, .5 );
	
	intensity = self getlightintensity();
	while( 1 )
	{
		self setlightintensity( intensity * randomfloatrange( .8, 1.1 ) );
		wait .05;
	}
}

light_street_fire()
{
	wait randomfloatrange( .05, .5 );
	
	intensity = self getlightintensity();
	color = self getlightcolor();
	origin = self.origin;
	
	while( 1 )
	{
		for( i = 0; i<randomintrange( 2, 8 ); i ++ )
		{
			x = randomfloatrange( 4, 10 );
			light_street_fire_dance( color, intensity, origin, x );
		}
		
		for( i = 0; i<randomintrange( 25, 60 ); i ++ )
		{
			x = randomfloatrange( .5, 1 );
			light_street_fire_dance( color, intensity, origin, x );
		}
	}	
}

light_street_fire_dance( color, intensity, origin, x )
{
	time = randomfloatrange( .05, .1 );
	self setlightintensity( intensity * randomfloatrange( .90, 1.1 ) );
	self setlightcolor( ( color[0] + randomfloatrange( -.05, .05 ), color[1], color[2] ) );
	self moveto( origin + ( randomfloatrange( x * -1, x ), randomfloatrange( x * -1, x ), randomfloatrange( x * -1, x ) ), time );
		
	wait time;	
}

handle_color_advance( sname, start, end )
{
	for ( i = start; i <= end; i++ )
	{
		name = sname + i;
		
		color_trig 	= getent( name, "targetname" );
		
		flag_wait( name );
					
		volume = color_trig get_color_volume_from_trigger();
		volume waittill_volume_dead_or_dying();
		
		color_trig activate_trigger();
	}
}

handle_node_advance( sname, start, end )
{
	for ( i = start; i <= end; i++ )
	{
		name = sname + i;
		
		color_trig 	= getent( name, "targetname" );
		
		flag_wait( name );
					
		volume = color_trig get_color_volume_from_trigger();
		volume waittill_volume_dead_or_dying();
		
		nodes = color_trig get_color_nodes_from_trigger();
		advance_team_to_nodes( nodes );
	}
}

enable_node_advance()
{
	self.node_advance = true;
}

disable_node_advance( nodes )
{
	self.node_advance = undefined;
}

advance_team_to_nodes( nodes )
{
	team = [];
	foreach( key, member in level.team )
	{
		if( !isdefined( member.node_advance ) )
			continue;
		
		team[ key ] = member;	
	}
	
	if( !team.size )
		return;
	
	foreach( node in nodes )
	{
		guy = team[ node.script_noteworthy ];
		if( !isdefined( guy ) )
			continue;
			
		guy thread follow_path( node );	
	}
}

stop_shield_on_random_teammate( num )
{		
	if( !isdefined( num ) )
		num = 1;
		
	array = [];
	foreach( member in level.team )
	{
		if( member is_hero() )
			continue;
		if( !isdefined( member.magic_bullet_shield ) )
			continue;
		
		array[ array.size ] = member; 
	}
	
	if( !array.size )
		return;
	
	if( array.size < num )
		num = array.size;
	
	for( i = 0; i < num; i++ )
	{
		actor = random( array );
		array = array_remove( array, actor );
		actor stop_magic_bullet_shield();
	}
}

kill_random_teammate( num, del )
{
	if( !isdefined( num ) )
		num = 1;
	if( !isdefined( del ) )
		del = false;
	
	array = [];
	foreach( member in level.team )
	{
		if( member is_hero() )
			continue;
		if( isdefined( member.magic_bullet_shield ) )
			continue;
		
		array[ array.size ] = member; 
	}
	
	if( !array.size )
		return false;
	
	if( array.size < num )
		num = array.size;
		
	array = get_array_of_farthest( level.player.origin, array );
	
	for( i = 0; i < array.size; i++ )
	{
		member = array[ i ];
		if( player_looking_at( member geteye() ) )
			continue;
		
		if( del )
			member delete();
		else
			member kill();
		num--;
		
		if( num == 0 )
			return true;	 	
	}
	
	array = array_removedead( array );
	array = get_array_of_farthest( level.player.origin, array );
	
	//if we got here its because we couldn't kill enough people the player was NOT looking at
	//so now we dont do a look at check.
	for( i = 0; i < num; i++ )
	{
		member = array[ i ];
				
		if( del )
			member delete();
		else
			member kill();
		num--;
		
		if( num == 0 )
			return true;	 	
	} 
	
	return false;
}

add_team( team )
{
	array = [];
	if( !isarray( team ) )
		array[ array.size ] = team;
	else
		array = team;
		
	array_thread( array, ::remove_team );
	
	foreach( member in array )
	{
		if( isdefined( member.script_noteworthy ) )
		{
			member.animname = member.script_noteworthy;
			level.team[ member.script_noteworthy ] = member;
		}
		else
			level.team[ level.team.size ] = member;	
	}
}

remove_team()
{
	self notify( "remove_team" );
	self endon( "remove_team" );
	
	self waittill( "death" );
	level.team = array_removedead_keepkeys( level.team );
}

team_init()
{
	self thread magic_bullet_shield();
	add_team( self );	
	
	if( isdefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "foley" )
		{
			self make_hero();
			level.foley = self;
		}
		if( self.script_noteworthy == "dunn" )
		{
			self make_hero();
			level.dunn = self;
		}
	}
	
	spawners = getentarray( "intro_team", "targetname" );
	if( level.team.size == spawners.size )
		flag_set( "team_initialized" );
}

setup_sun()
{
	level.suncolor = [];
	
	level.suncolor[ "intro" ] 	= [];
	level.suncolor[ "intro" ][ 0 ] = 1.0;
	level.suncolor[ "intro" ][ 1 ] = 0.61;
	level.suncolor[ "intro" ][ 2 ] = 0.21;
	
	multiplier = 1.8;
	level.suncolor[ "emp" ] 	= [];
	level.suncolor[ "emp" ][ 0 ] = level.suncolor[ "intro" ][ 0 ] * multiplier;
	level.suncolor[ "emp" ][ 1 ] = level.suncolor[ "intro" ][ 1 ] * multiplier;
	level.suncolor[ "emp" ][ 2 ] = level.suncolor[ "intro" ][ 2 ] * multiplier;
	
	level.suncolor[ "sunset" ] 	= [];
	level.suncolor[ "sunset" ][ 0 ] = 0.31;
	level.suncolor[ "sunset" ][ 1 ] = 0.35;
	level.suncolor[ "sunset" ][ 2 ] = 0.42;
	
	level.suncolor[ "office" ] 	= [];
	level.suncolor[ "office" ][ 0 ] = 0.88;
	level.suncolor[ "office" ][ 1 ] = 0.93;
	level.suncolor[ "office" ][ 2 ] = 1.0;
		
	level.suncolor_cur = level.suncolor[ "intro" ];
	level.sky = getent( "sky_dcburning", "targetname" );
}

vision_set_intro( time )
{
	if( !isdefined( time ) )
		time = 0;
	
	thread maps\_utility::set_vision_set( "dcburning_crash", time );
	thread maps\_utility::vision_set_fog_changes( "dcburning_crash", time );
	thread lerp_sunlight( level.suncolor[ "intro" ], time );
}

vision_set_emp( time )
{
	time = 2;
	
	fx = getstruct( "emp_sun_fx", "targetname" );
	model = spawn( "script_model", fx.origin );
	model.angles = vectortoangles( level.player.origin - fx.origin );
	model setmodel( "tag_origin" );
	
	setsaveddvar( "r_spotlightstartradius", "800" );
	setsaveddvar( "r_spotlightEndradius", "1200" );
	setsaveddvar( "r_spotlightfovinnerfraction", ".5" );
	setsaveddvar( "r_spotlightexponent", "4" );
	setsaveddvar( "r_spotlightBrightness", "8" );
	
	model thread vision_update_sun_spotlight_fx();
	model thread fake_motion();	
	
	thread maps\_utility::set_vision_set( "dcemp_emp", time );
	thread maps\_utility::vision_set_fog_changes( "dcemp_emp", time );
	thread lerp_sunlight( level.suncolor[ "emp" ], time );
	
	wait 5;
	
	time = 3;
	
	thread maps\_utility::set_vision_set( "dcemp_postemp", time );
	thread maps\_utility::vision_set_fog_changes( "dcemp_postemp", time );
	thread lerp_sunlight( level.suncolor[ "intro" ], time );
		
	wait time;
	
	model notify( "stop_sun_fx" );
	wait 1;
	model delete();
	
	
}

vision_update_sun_spotlight_fx()
{			
	self endon( "stop_sun_fx" );
	
	while( 1 )
	{
		wait .05;
		
		self.angles = vectortoangles( level.player.origin - self.origin );		
	}
}

fake_motion()
{
	self endon( "stop_sun_fx" );
	
	origin = self.origin;
	time = .5;
	min = -128;
	max = 128;
	
	while( 1 )
	{
		delta = ( randomfloatrange( min, max ), randomfloatrange( min, max ), randomfloatrange( min, max ) );
		self moveto( origin + delta, time, time * .5, time * .5 );	
		
		wait time;
		
		self moveto( origin, time, time * .5, time * .5 );	
		
		wait time;
	}
}

vision_set_sunset( time )
{
	if( !isdefined( time ) )
		time = 60;
		
	thread maps\_utility::set_vision_set( "dcemp_postemp2", time );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_postemp2", time );
	thread lerp_sunlight( level.suncolor[ "sunset" ], time );
}

vision_set_office( time )
{
	if( !isdefined( time ) )
		time = 5;
		
	thread maps\_utility::set_vision_set( "dcemp_office", time );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_office", time );
}

vision_set_lobby()
{
	time = 3;
	
	trigger_wait_targetname( "lobby_vision_change" );
	
	thread maps\_utility::set_vision_set( "dcemp_office", time );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_office", time );
		
}

vision_set_parking( time )
{
	if( !isdefined( time ) )
		time = 5;
	
	thread maps\_utility::set_vision_set( "dcemp_parking", time );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_parking", time );
	
	thread lerp_saveddvar( "r_specularColorScale", 10, time ); 
}	

vision_set_night( time )
{
	if( !isdefined( time ) )
		time = 0;
	
	thread maps\_utility::set_vision_set( "dcemp", time );	
	thread maps\_utility::vision_set_fog_changes( "dcemp", time );
}

vision_set_whitehouse()
{
	thread maps\_utility::set_vision_set( "whitehouse", 0 );	
	thread maps\_utility::vision_set_fog_changes( "whitehouse", 0 );
}

handle_sunlight()
{
	while( 1 )
	{
		trigger_wait( "office_ally_color_1", "target" );
		resetsunlight();
	
		trigger_wait( "lobby_vision_change", "targetname" );	
		thread lerp_sunlight( level.suncolor[ "sunset" ], 0 );
	}
}

lerp_sunlight( color, time )
{
	level notify( "lerp_sunlight" );
	level endon( "lerp_sunlight" );
	
	if( array_compare( color, level.suncolor_cur ) )
		return;
	
	interval = .05;
	count = time / interval;
	current = 0;
	
	start_color = level.suncolor_cur;
	
	rangeR = color[0] - start_color[0];
	rangeG = color[1] - start_color[1];
	rangeB = color[2] - start_color[2];
		
	while( current < count )
	{
		fracR = rangeR * ( current / count );
		fracG = rangeG * ( current / count );
		fracB = rangeB * ( current / count );
		
		level.suncolor_cur[ 0 ] = start_color[0] + fracR;
		level.suncolor_cur[ 1 ] = start_color[1] + fracG;
		level.suncolor_cur[ 2 ] = start_color[2] + fracB;
		
		setSunlight( level.suncolor_cur[ 0 ], level.suncolor_cur[ 1 ], level.suncolor_cur[ 2 ] );
		
		current++;
		wait interval;
	}
	
	level.suncolor_cur = color;
	setSunlight( color[ 0 ], color[ 1 ], color[ 2 ] );
}

lerp_specular( scale, time )
{
	level notify( "lerp_specular" );
	level endon( "lerp_specular" );
	
	start_scale = getdvarfloat( "r_specularColorScale", "2.5" );
	
	if( scale == start_scale )
		return;
	
	interval = .05;
	count = time / interval;
	current = 0;
	
	range = scale - start_scale;
	
	while( current < count )
	{
		frac = range * ( current / count );
		
		setSavedDvar( "r_specularColorScale", string( start_scale + frac ) );
		
		current++;
		wait interval;
	}
	
	setSavedDvar( "r_specularColorScale", string( scale ) );
}

anim_generic_gravity_run( guy, anime, tag )
{
	self thread anim_generic_gravity( guy, anime, tag );
	length = getanimlength( getanim_generic( anime ) );
	wait length - .2;
	guy clearanim( getanim_generic( anime ), .2);
	guy notify( "killanimscript" );
}

set_pushplayer( value )
{
	if( value )
		self.dontchangepushplayer = true;
	else
		self.dontchangepushplayer = undefined;
	
	self pushplayer( value );
}

ai_turn( angle )
{
	self.turnThreshold = self.defaultTurnThreshold;
	self.a.array[ "turn_left_45" ] = %exposed_tracking_turn45L;
	self.a.array[ "turn_left_90" ] = %exposed_tracking_turn90L;
	self.a.array[ "turn_left_135" ] = %exposed_tracking_turn135L;
	self.a.array[ "turn_left_180" ] = %exposed_tracking_turn180L;
	self.a.array[ "turn_right_45" ] = %exposed_tracking_turn45R;
	self.a.array[ "turn_right_90" ] = %exposed_tracking_turn90R;
	self.a.array[ "turn_right_135" ] = %exposed_tracking_turn135R;
	self.a.array[ "turn_right_180" ] = %exposed_tracking_turn180R;
	self.a.array[ "straight_level" ] = %exposed_aim_5;
	
	self animscripts\combat::TurnToFaceRelativeYaw( angle );
}

fx_rain_pause()
{
	node = getstruct( "rainfxnode", "targetname" );
	radius = squared( node.radius );
			
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius && !isdefined( EntFx.v[ "exploder" ] ) )
			EntFx pauseEffect(); 
	}
	
	/*
	array = getfxarraybyID( "rain_noise_splashes" );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite" ) );
	array = array_combine( array, getfxarraybyID( "cgo_ship_puddle_large" ) );
	array = array_combine( array, getfxarraybyID( "cgo_ship_puddle_small" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_4x64" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_4x128" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_8x64" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_8x128" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_64x64" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_128x128" ) );
	
	array_thread( array, ::pauseEffect );*/
}

fx_rain_pause2()
{
	node = getstruct( "rainfxnode2", "targetname" );
	radius = squared( node.radius );
			
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius && !isdefined( EntFx.v[ "exploder" ] ) )
			EntFx pauseEffect(); 
	}
}

fx_rain_restart()
{
	node = getstruct( "rainfxnode", "targetname" );
	radius = squared( node.radius );
		
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius && !isdefined( EntFx.v[ "exploder" ] ) )
			EntFx restartEffect(); 
	}	
	
/*	array = getfxarraybyID( "rain_noise_splashes" );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite" ) );
	array = array_combine( array, getfxarraybyID( "cgo_ship_puddle_large" ) );
	array = array_combine( array, getfxarraybyID( "cgo_ship_puddle_small" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_4x64" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_4x128" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_8x64" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_8x128" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_64x64" ) );
	array = array_combine( array, getfxarraybyID( "rain_splash_lite_128x128" ) );
	
	array_thread( array, ::restartEffect );*/
}

fx_end_pause()
{
	node = getstruct( "whitehousefxnode", "targetname" );
	radius = squared( node.radius );
		
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius && !isdefined( EntFx.v[ "exploder" ] ) )
			EntFx pauseEffect(); 
	}
}

fx_end_restart()
{
	node = getstruct( "whitehousefxnode", "targetname" );
	radius = squared( node.radius );
		
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius && !isdefined( EntFx.v[ "exploder" ] ) )
			EntFx restartEffect(); 
	}	
}

fx_intro_pause()
{
	if( !flag( "intro_fx" ) )
		return;
		
	pauseExploder( "plane_crash_aftermath" );
	
	node = getstruct( "introfxnode", "targetname" );
	radius = squared( node.radius );
	
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius )
			EntFx pauseEffect(); 
	}
	
	flag_clear( "intro_fx" );
}

fx_intro_restart()
{
	if( flag( "intro_fx" ) )
		return;
		
	restartExploder( "plane_crash_aftermath" );
	
	node = getstruct( "introfxnode", "targetname" );
	radius = squared( node.radius );
	
	foreach( EntFx in level.createfxent )
	{
		if( distancesquared( EntFx.v[ "origin" ], node.origin ) < radius )
			EntFx restartEffect(); 
	}
	
	flag_set( "intro_fx" );
}

fx_iss_pause()
{
	if( !flag( "iss_fx" ) )
		return;
				
	foreach( EntFx in level.createfxent )
	{
		if( EntFx.v[ "fxid" ] == "dcemp_sun" )
			EntFx pauseEffect(); 
	}
	
	flag_clear( "iss_fx" );
}

dcemp_create_triggerfx()
{
	intro = spawnstruct();
	intro.node = getstruct( "introfxnode", "targetname" );
	intro.radius = squared( intro.node.radius );
		
	rain = spawnstruct();
	rain.node = getstruct( "rainfxnode", "targetname" );
	rain.radius = squared( rain.node.radius );
	
	rain = spawnstruct();
	rain.node = getstruct( "rainfxnode2", "targetname" );
	rain.radius = squared( rain.node.radius );
	
	end = spawnstruct();
	end.node = getstruct( "whitehousefxnode", "targetname" );
	end.radius = squared( end.node.radius );
	
	/*israinfx = false;
	if( self.v[ "fxid" ] == "rain_noise_splashes" ||
		self.v[ "fxid" ] == "rain_splash_lite" ||
	 	self.v[ "fxid" ] == "cgo_ship_puddle_large" ||
	 	self.v[ "fxid" ] == "cgo_ship_puddle_small" ||
	 	self.v[ "fxid" ] == "rain_splash_lite_4x64" ||
	 	self.v[ "fxid" ] == "rain_splash_lite_4x128" ||
	 	self.v[ "fxid" ] == "rain_splash_lite_8x64" ||
	 	self.v[ "fxid" ] == "rain_splash_lite_8x128" ||
	 	self.v[ "fxid" ] == "rain_splash_lite_64x64" ||
	 	self.v[ "fxid" ] == "rain_splash_lite_128x128" )
	 	israinfx = true;*/
	
	isissfx = false;
	if( self.v[ "fxid" ] == "dcemp_sun" ||
		self.v[ "fxid" ] == "space_nuke" ||
		self.v[ "fxid" ] == "space_nuke_shockwave" ||
		self.v[ "fxid" ] == "space_emp" ||
		self.v[ "fxid" ] == "space_explosion" ||
		self.v[ "fxid" ] == "space_explosion_small" )
		isissfx = true; 
	
	isendfx = false;
	if( self.v[ "fxid" ] == "carpetbomb" ||
		self.v[ "fxid" ] == "wire_spark" )
		isendfx = true; 
		
	//INTRO FX
	if( distancesquared( self.v[ "origin" ], intro.node.origin ) < intro.radius )
		flag_wait( "intro_fx" );
	//ISS FX
	else
	if( isissfx )
		flag_wait( "iss_fx" );
	//RAIN FX
	else
	if( distancesquared( self.v[ "origin" ], rain.node.origin ) < rain.radius )
		flag_wait( "rain_fx" );
	//RAIN FX2
	else
	if( distancesquared( self.v[ "origin" ], rain.node.origin ) < rain.radius )
		flag_wait( "rain_fx2" );
	//END FX
	else
	if( distancesquared( self.v[ "origin" ], end.node.origin ) < end.radius || isendfx )
		flag_wait( "end_fx" );
	
	//OTHER FX just start at first frame
	self common_scripts\_fx::create_triggerfx();
}

lerp_lightintensity( value, time )
{
	curr = 	self getlightintensity();
	
	range = value - curr;
	
	interval = .05;
	count = int( time / interval );
	
	delta = range / count;
	
	while( count )
	{
		curr += delta;
		self setlightintensity( curr );
		
		wait interval;
		count--;
	}
	
	self setlightintensity( value );
}

dcemp_lightningFlash( type )
{
	flash = [];
	flash[ "quick" ] = 0;
	flash[ "double" ] = 1;
	flash[ "triple" ] = 2;
	maps\_weather::lightningFlash( maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash, flash[ type ] );	
}

CornerStndR_aim()
{	
	self setAnimlimited( %CornerStndR_lean_aim_5, 1, .2 );
	
	self setAnimLimited( %aim_6, .55, .2 );
	self setAnimKnobLimited( %CornerStndR_lean_aim_6, 1, .2 );
	
	self setAnimLimited( %add_idle, 1, .2 );
	self setAnimKnobLimitedRestart( %CornerStndR_lean_idle, 1, .2 );
	 //%CornerStndR_lean_auto
	self waittill( "stop_custom_aim" );
}

CornerCrR_aim()
{	
	self setAnimlimited( %CornerCrR_lean_aim_5, 1, .2 );
	
	self setAnimLimited( %aim_6, .5, .2 );
	self setAnimKnobLimited( %CornerCrR_lean_aim_6, 1, .2 );
	
	self setAnimLimited( %add_idle, 1, .2 );
	self setAnimKnobLimitedRestart( %CornerCrR_lean_idle, 1, .2 );
	 //%CornerStndR_lean_auto
	self waittill( "stop_custom_aim" );
}

bodyshot( fx )
{
	origin = self gettagorigin( "J_SpineUpper" );
	enemy = random( level.team );  
	vec = vectornormalize( enemy.origin - origin );
	vec = vector_multiply( vec, 10 );
	 
	PlayFX( getfx( fx ), origin + vec );
}

script2model_precache()
{
	precachelist = [];
	data = getstructarray( "script_to_model_swap_intro", "script_noteworthy" );
	data = array_add( data, getstruct( "earth_model", "targetname" ) );
	data = array_combine( data, getstructarray( "crash_cars", "targetname" ) );
	data = array_combine( data, getstructarray( "street_cars_bounce", "targetname" ) );
	data = array_combine( data, getstructarray( "iss_entity", "targetname" ) );
		
	foreach( obj in data )
	{
		if( isdefined( precachelist[ obj.script_modelname ] ) )
			continue;
		
		precachelist[ obj.script_modelname ] = obj.script_modelname;
	}
	
	foreach( model in precachelist )
		precachemodel( model );
}

script2model_intro()
{
	if( flag( "script2model_intro" ) )
		return;
		
	data = getstructarray( "script_to_model_swap_intro", "script_noteworthy" );
	data = array_combine( data, getstructarray( "crash_cars", "targetname" ) );
	data = array_combine( data, getstructarray( "street_cars_bounce", "targetname" ) );
	
	foreach( obj in data )
	{
		model = spawn( "script_model", obj.origin );
		model.angles = obj.angles;
		model.targetname = obj.targetname;
		model.script_noteworthy = obj.script_noteworthy;
		model setmodel( obj.script_modelname );
	}
	
	flag_set( "script2model_intro" );
}

script2model_iss()
{
	if( flag( "script2model_iss" ) )
		return;
	
	earthdata 			= getstruct( "earth_model", "targetname" );
	earth 				= spawn( "script_model", earthdata.origin );
	earth.angles 		= (0,0,0);
	earth.targetname 	= earthdata.targetname;
	earth 				setmodel( earthdata.script_modelname );
				
	data = getstructarray( "iss_entity", "targetname" );
	
	//spawning 700 entities...so need to break it up into several frames
	num = 0;	
	
	foreach( obj in data )
	{
		model = spawn( "script_model", obj.origin );
		model.angles = obj.angles;
		model.targetname = obj.targetname;
		model.script_noteworthy = obj.script_noteworthy;
		model.script_type = obj.script_type;
		model setmodel( obj.script_modelname );
		
		num++;
		if( num == 50 )
		{
			wait .05;
			num = 0;	
		}
	}
	
	flag_set( "script2model_iss" );
}

script2model_del_intro()
{
	if( !flag( "script2model_intro" ) )
		return;
		
	models = getentarray( "script_to_model_swap_intro", "script_noteworthy" );
	models = array_combine( models, getentarray( "crash_cars", "targetname" ) );
	models = array_combine( models, getentarray( "street_cars_bounce", "targetname" ) );
	array_call( models, ::delete );
	
	flag_clear( "script2model_intro" );
}

script2model_del_iss()
{
	if( !flag( "script2model_iss" ) )
		return;
		
	models = getentarray( "iss_entity", "targetname" );
	models = array_combine( models, getentarray( "iss_lights", "targetname" ) );
	array_call( models, ::delete );
	
	earth = getent( "earth_model", "targetname" );
	earth delete();
		
	flag_clear( "script2model_iss" );
}