#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\char_museum;
#using_animtree( "generic_human" );




/*------------------------------------------------------------------------------------------------------------------------------------*/

ai_default_setup( array )
{
	self set_allowdeath( true );
	
	self.anim_speed = level.GLOBAL_ANIM_SPEED;
	
	if( !isdefined( level.anim_ai[ array ] ) )
		level.anim_ai[ array ] = [];
	level.anim_ai[ array ][ level.anim_ai[ array ].size ] = self;
	node = self;
	if( isdefined( self.target ) )
	{
		node = getstruct( self.target, "targetname" );
		self.animation = node.animation;
	}	
	self.anim_node = node;
	
	self drone_anim_first_frame( node );
	self thread ai_current_anim_stop();
	self thread ai_death_track( array );
}

ai_death_track( array )
{
	self waittill( "death" );
	
	if( isdefined( self ) )
		level.anim_ai[ array ] = array_remove( level.anim_ai[ array ], self );
	else	
		level.anim_ai[ array ] = [];
}

drone_anim_first_frame( node )
{
	self.current_anim = getanim_generic( node.animation );
	node anim_generic_first_frame( self, node.animation );
}

ai_idle( animation )
{
	if( isai( self ) )
		self ai_idle_ai( animation );
	else	
		self ai_idle_drone( animation );
}

ai_idle_ai( animation )
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self.anim_to_do = getanim_generic( animation );
	
	self thread ai_current_anim_stop();
		
	self ai_wait_current_anim();
	waittillframeend;
	
	self.animtime = undefined;
	self AnimCustom( ::custom_ai_idle );
}

ai_idle_drone( animation )
{
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();
	
	while( 1 )
	{
		self ai_wait_current_anim();
		
		waittillframeend;
		
		self.animtime = undefined;
		anime = self.current_anim;
		self ClearAnim( anime, 0 );
		self setanimrestart( self.current_anim, 1, 0, self.anim_speed );
	}
}

custom_ai_idle()
{	
	self endon( "killanimscript" );
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self notify( "new_custom_anim" );
	self endon( "new_custom_anim" );
	
	animation = self.anim_to_do;
		
	while( 1 )
	{						
		anime = self.current_anim;
		self ClearAnim( anime, 0 );
		self animMode( "nogravity" );
		self setanimrestart( self.current_anim, 1, 0, self.anim_speed );
		
		self ai_wait_current_anim();
		waittillframeend;
	}
}

ai_loop_random( animation, array )
{
	if( isai( self ) )
		self ai_loop_random_ai( animation, array );
	else	
		self ai_loop_random_drone( animation, array );
}

ai_loop_random_ai( animation, array )
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self.anim_to_do = getanim_generic( animation );
	self.array_to_do = array;
	self.current_anim = getanim_generic( animation );
	
	self thread ai_current_anim_stop();
	
	self ai_wait_current_anim();	
	waittillframeend;
	
	self.animtime = undefined;	
	self AnimCustom( ::custom_ai_loop_random );
}

ai_loop_random_drone( animation, array )
{
	self endon( "do_anim" );
	self.current_anim = getanim_generic( animation );
	self thread ai_current_anim_stop();
	
	while( 1 )
	{
		self ai_wait_current_anim();
		
		waittillframeend;
		
		self.animtime = undefined;
		anime = self.current_anim;
		self.current_anim = random( level.scr_anim[ "generic" ][ array ] );
		self ClearAnim( anime, 0 );
		self setanimrestart( self.current_anim, 1, 0, self.anim_speed );
	}
}

custom_ai_loop_random()
{
	self endon( "killanimscript" );
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self notify( "new_custom_anim" );
	self endon( "new_custom_anim" );
	
	animation = self.anim_to_do;
	array = self.array_to_do;	

	while( 1 )
	{
		anime = self.current_anim;
		self.current_anim = random( level.scr_anim[ "generic" ][ array ] );
		self ClearAnim( anime, 0 );
		self animMode( "nogravity" );
		self setanimrestart( self.current_anim, 1, 0, self.anim_speed );
		
		self ai_wait_current_anim();	
		waittillframeend;
	}
}

ai_wait_current_anim( percent, delay )
{
	if( !isdefined( self.current_anim ) )
		return;
		
	if( !isdefined( delay ) )
		delay = 0;
		
	time = getanimlength( self.current_anim );
	
	if( isdefined( percent ) && isdefined( self.animtime ) )
		time *= ( percent - self.animtime );
	else
	if( isdefined( percent ) )
		time *= percent;
	else
	if( isdefined( self.animtime ) )
		time *= ( 1.0 - self.animtime );
			
	final = ( time / self.anim_speed ) + delay;
	
	if( final > 0 )
		wait final;
}

ai_next_anim( xanim, percent, delay )
{
	if( isai( self ) )
		self ai_next_anim_ai( xanim, percent, delay );
	else	
		self ai_next_anim_drone( xanim, percent, delay );
}

ai_next_anim_ai( xanim, percent, delay )
{	
	self endon( "panic_button" );
	self endon( "death" );
	wait .1;
	self ai_wait_current_anim( percent, delay );
		
	waittillframeend;
	
	self.animtime = undefined;
	self.anim_to_do = xanim;
	self.perc_to_do = percent;
	self.delay_to_do = delay;
	
	self AnimCustom( ::custom_ai_next_anim );
}

ai_next_anim_drone( xanim, percent, delay )
{	
	self ai_wait_current_anim( percent, delay );
	
	waittillframeend;
	
	self.animtime = undefined;
	anime = self.current_anim;
	self.current_anim = xanim;
	self ClearAnim( anime, .2 );
	self setanimrestart( self.current_anim, 1, .2, self.anim_speed );
}

custom_ai_next_anim()
{
	self endon( "killanimscript" );
	self endon( "panic_button" );
	self endon( "death" );
	self notify( "new_custom_anim" );
	self endon( "new_custom_anim" );
		
	xanim = undefined;
	percent = undefined;
	delay = undefined;
	if( isdefined( self.anim_to_do ) )
		xanim = self.anim_to_do;
	if( isdefined( self.perc_to_do ) )
		percent = self.perc_to_do;
	if( isdefined( self.delay_to_do ) )
		delay = self.delay_to_do;
	
	anime = self.current_anim;
	self.current_anim = xanim;
	self ClearAnim( anime, .2 );
	self animMode( "nogravity" );
	self setanimrestart( self.current_anim, 1, .2, self.anim_speed );
	
	self waittill( "new_custom_anim" );
}

ai_current_anim_stop()
{
	if( isai( self ) )
		self ai_current_anim_stop_ai();
	else
		self ai_current_anim_stop_drone();
}

ai_current_anim_stop_ai()
{
	self endon( "panic_button" );
	self endon( "death" );
	
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	self ent_flag_waitopen( "do_anim" );
	self AnimCustom( ::custom_ai_current_anim_stop );	
}

ai_current_anim_stop_drone()
{
	while( !self ent_flag_exist( "do_anim" ) )
		wait .05;
	self ent_flag_wait( "do_anim" );
	self ent_flag_waitopen( "do_anim" );
	self SetAnim( self.current_anim, 1, 0, 0 ); 	
}

custom_ai_current_anim_stop()
{
	self endon( "killanimscript" );
	self endon( "panic_button" );
	self endon( "death" );
	self notify( "new_custom_anim" );
	
	self animMode( "nogravity" );	
	self SetAnim( self.current_anim, 1, 0, 0 ); 
	
	self waittill( "new_custom_anim" );
}

_setanim( animation, weight, blend, rate )
{
	if( isai( self ) )
		self _setanim_ai( animation, weight, blend, rate );	
	else	
		self _setanim_drone( animation, weight, blend, rate );	
}

_setanim_ai( animation, weight, blend, rate )
{
	self.anim_to_do = animation;
	self.weight_2_do = weight;
	self.blend_2_do = blend;
	self.rate_2_do = rate;
	
	self AnimCustom( ::custom_setanim );	
}

_setanim_drone( animation, weight, blend, rate )
{
	self setanim( animation , weight, blend, rate );	
}

custom_setanim()
{
	self endon( "killanimscript" );
	self endon( "panic_button" );
	self endon( "death" );
	self notify( "new_custom_anim" );
		
	animation = self.anim_to_do;
	weight = self.weight_2_do;
	blend = self.blend_2_do;
	rate = self.rate_2_do;
	
	if( isdefined( self.anim_mode ) )
		self animMode( self.anim_mode );
	else
		self animMode( "nogravity" );
	self setanim( animation, weight, blend, rate );
	
	self waittill( "new_custom_anim" );
}

set_anim_time( node, time )
{
	wait .05;

	self.animtime = time;
	
	ent = spawn( "script_origin", GetStartOrigin( node.origin, node.angles, getanim_generic( node.animation ) ) );
	ent.angles = GetStartangles( node.origin, node.angles, getanim_generic( node.animation ) );
	
	delta = GetMoveDelta( getanim_generic( node.animation ), 0, self.animtime );
	endPoint = ent LocalToWorldCoords( delta );
	angles = getangledelta( getanim_generic( node.animation ), 0, self.animtime );
				
	self SetAnimTime( getanim_generic( node.animation ), self.animtime );

	if( isai( self ) )
		self ForceTeleport( endPoint, ent.angles + ( 0, angles, 0) );
	else
	{
		self.origin = endPoint;
		self.angles = ent.angles + ( 0, angles, 0) ;	
	}
	
	ent delaycall( .05, ::delete );
}

camera_move( targetname, speed, acc, dec )
{
	node = getvehiclenode( targetname, "targetname" );
	
	old_camera = level.camera;
	level.camera = spawn_vehicle_from_targetname_and_drive( "credits_camera" );
	level.camera vehicle_teleport( node.origin, node.angles );
	level.camera thread vehicle_paths( node );
	level.camera attachpath( node );
	
	level.camera vehicle_setspeedimmediate( 0, 1000, 1000 );	
		
	if( !isdefined( speed )  )
		speed = 30;// units per second.
			
	dist = distance( level.camera.origin, old_camera.origin );
	time = dist / speed;
	
	if( !isdefined( acc ) )
		acc = .25;
	
	if( !isdefined( dec ) )
		dec = .25;	
	
	if( !acc && !dec )	
		level.player playerlinktoblend( level.camera, undefined, time );
	else
		level.player playerlinktoblend( level.camera, undefined, time, time * acc, time * dec );
	
	if( time > .5 && time < 1.0 )
		wait time;
	else
	if( time > 1.0 )
		wait time - 1.0;
	
	old_camera delaycall( 1.5, ::delete );
}

set_diarama_ai()
{
	if( level.level_mode == "free" || self.classname == "actor_enemy_dog" )
	{
		self.script_drone = undefined;
		self.script_moveoverride = 1;
	}
	else
	{
		self.script_drone_override = 1;	
		self.script_drone = 1;
	}
}

set_civilian_ai()
{
	self.moveplaybackrate = 1.0;
	self.animplaybackrate = 1.0;
	
	if( level.level_mode == "free" )
	{
		self.script_drone = 1;
	}
	else
	{
		self.script_drone = undefined;	
	}
}

do_anim( name )
{
	foreach( ent in level.anim_ai[ name ] )
		ent ent_flag_set( "do_anim" );	
}

//---------------------------------------------------------------------------------------------------
delete_civ_on_goal()
{
	self endon( "death" );
	
	self waittill( "reached_path_end" );
	
	self delete();	
}

civ_talkers()
{
	self endon( "death" );
	
	wait .1;//let initiliazing functions run
	
	node = self;
	if( isdefined( self.target ) )
	{
		node = getstruct( self.target, "targetname" );
		self.animation = node.animation;
	}	
	
	if( node.animation == "civilian_texting_sitting" )
		self attach( "electronics_pda", "TAG_INHAND" );
	
	self set_allowdeath( true );	
	node anim_generic_loop( self, node.animation );
}

bubbles()
{
	self endon( "death" );

	fx = getfx( "scuba_bubbles_friendly" );
	while( self ent_flag( "do_anim" ) )
	{
		count = randomint( 3 ) + 1;
		for ( i = 0; i < count; i++ )
		{
			PlayFXOnTag( fx, self, "tag_eye" );
			wait( 0.05 );
		}
		wait( randomfloatrange( 0.6, 2.5 ) );
	}
}

museum_player_setup()
{
	self.ignoreme = true;
	
	startingWeapon = "beretta";
	startingViewhands = "ch_viewhands_gk_ump45";
	self TakeAllWeapons();
	self GiveWeapon( startingWeapon );
	self SwitchToWeapon( startingWeapon );
	self SetViewmodel( startingViewhands );
	self giveWeapon( "fraggrenade" );
	self setOffhandSecondaryClass( "flash" );
	self giveWeapon( "flash_grenade" );
	self freezecontrols( true );
}

spawner_trig_think()
{
	room = self.script_noteworthy;
	ASSERT( IsDefined( room ) );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsPlayer( other ) && level.activeRoom != room )
		{
			self spawn_museum_dudes();
			
			while( other IsTouching( self ) )
			{
				wait( 0.05 );
			}
		}
	}
}

spawn_museum_dudes()
{
	if( flag( "panic_button" ) )
		return;
		
	level.activeRoom = self.script_noteworthy;

	if( level.level_mode == "free" )
		level.guys = getaispeciesarray();
	
	foreach( guy in level.guys )
	{
		if( IsDefined( guy ) )
		{
			guy Delete();
		}
	}
	if( isdefined( level.rope ) )
	{
		level.rope delete();
		level.rope = undefined;
	}

	level.guys = [];
	
	wait( 0.05 );  // let the guys delete to make room
	
	if( level.activeRoom == "none" )
		return;
	
	newspawners = GetEntArray( self.script_noteworthy, "targetname" );
	ASSERT( newspawners.size );
	
	if( level.level_mode == "free" )
	{
		//ClearAllCorpses();
		
		switch( self.script_noteworthy )
		{
			case "room1":
				museum_room1_anim_go();
				break;
			case "room2":
				museum_room2_anim_go();
				break;
		}
	}	
	array_thread( newspawners, ::spawn_museum_dude );
}

spawn_museum_dude()
{
	self.count = 3;
	self spawn_ai( true );
}

museum_ai_think()
{
	self endon( "death" );
	
	self ent_flag_init( "do_anim" );
	self.ignoreme = true;
	self.ignoreall = true;
	
	self.old = [];
	self.old[ "grenadeawareness" ] 				= self.grenadeawareness;
	self.old[ "ignoreexplosionevents" ]			= self.ignoreexplosionevents;
	self.old[ "ignorerandombulletdamage" ]		= self.ignorerandombulletdamage;
	self.old[ "ignoresuppression" ]				= self.ignoresuppression;
	self.old[ "disableBulletWhizbyReaction" ]	= self.disableBulletWhizbyReaction;
	self.old[ "newEnemyReactionDistSq" ]		= self.newEnemyReactionDistSq;
	self.old[ "health" ] 						= self.health;
	self.old[ "maxhealth" ] 					= self.maxhealth;
	self.old[ "flashbangimmunity" ] 			= self.flashbangimmunity;
		
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.ignoresuppression = true;
	self.disableBulletWhizbyReaction = true;
	self.newEnemyReactionDistSq = 0;
	self.name = " ";
	self.health = 1;
	self.maxhealth = 1;
	self.flashbangimmunity = 1;
	
	
	self pathrandompercent_zero();
		
	if( IsDefined( self.team ) && self.team == "axis" )
	{
		self.team = "neutral";
	}
	
	if( isai( self ) )
	{
		self disable_pain();
		self ClearEnemy();
		self PushPlayer( true );
	}
	else
	{
//		self thread death_thread();
	}
	// make the guy go back to idle even if he freaked out on the first frame
	self.alertlevel = "noncombat";
//	self.alertlevelInt = 2;
	
	if( isdefined( self.type ) && self.type == "civilian" )
		return;
	
	level.guys[ level.guys.size ] = self;
}

blackscreen_start()
{
	foreach( player in level.players )
	{
		player.black_overlay = maps\_hud_util::create_client_overlay( "black", 0, player );
		player.black_overlay.alpha = 1;
	}
}

blackscreen_fadeout( fadeTime )
{
	foreach( player in level.players )
	{
		player.black_overlay FadeOverTime( fadeTime );
		player.black_overlay.alpha = 0;
		player.black_overlay delaycall( fadeTime, ::Destroy );
	}
}

sign_departure_status()
{
	array = sign_departure_status_system_setup();
	array_thread( array, ::sign_departure_status_tab_setup );

	level.departure_status_array = array;
	
	statuses = [];
//	statuses[ statuses.size ] = "arriving";
//	statuses[ statuses.size ] = "ontime";
//	statuses[ statuses.size ] = "boarding";
	statuses[ statuses.size ] = "delayed";
	
	array = array_randomize( level.departure_status_array );
	
	flag_wait( "looked_at_big_board" );
	
	snds = getentarray( "snd_departure_board", "targetname" );
	foreach( member in snds )
		member playsound( member.script_soundalias );
	
	array = array_randomize( level.departure_status_array );
	foreach( value in array )
	{
		value thread sign_departure_status_flip_to( statuses[ randomint( statuses.size ) ] );
		wait 0.2;
	}
}

sign_departure_status_system_setup()
{
	pieces = GetEntArray( "sign_departure_status", "targetname" );
	array = [];

	foreach ( tab in pieces )
	{
		makenew = true;
		origin = tab.origin;

		foreach ( member in array )
		{
			if ( member.origin != origin )
				continue;

			makenew = false;
			member.tabs[ tab.script_noteworthy ] = tab;
			break;
		}

		if ( !makenew )
			continue;

		newtab = SpawnStruct();
		newtab.origin = origin;
		newtab.tabs = [];
		newtab.tabs[ tab.script_noteworthy ] = tab;

		array[ array.size ] = newtab;
	}

	return array;
}

sign_departure_status_tab_setup()
{
	self.status[ "angles" ] 				 = [];
	self.status[ "angles" ][ "bottom" ] 	 = self.tabs[ "ontime" ].angles;
	self.status[ "angles" ][ "top" ] 		 = self.tabs[ "boarding" ].angles;
	self.status[ "angles" ][ "waiting" ] 	 = self.tabs[ "delayed" ].angles;

	self.status[ "order" ] 					 = [];
	self.status[ "order" ][ "ontime" ] 		 = "arriving";
	self.status[ "order" ][ "arriving" ] 	 = "boarding";
	self.status[ "order" ][ "boarding" ] 	 = "delayed";
	self.status[ "order" ][ "delayed" ] 	 = "ontime";

	self.status[ "ontime" ] 				 = [];
	self.status[ "ontime" ][ "bottom" ]		 = "ontime";
	self.status[ "ontime" ][ "top" ] 		 = "arriving";

	self.status[ "arriving" ] 				 = [];
	self.status[ "arriving" ][ "bottom" ]	 = "arriving";
	self.status[ "arriving" ][ "top" ]		 = "boarding";

	self.status[ "boarding" ] 				 = [];
	self.status[ "boarding" ][ "bottom" ]	 = "boarding";
	self.status[ "boarding" ][ "top" ] 		 = "delayed";

	self.status[ "delayed" ] 				 = [];
	self.status[ "delayed" ][ "bottom" ] 	 = "delayed";
	self.status[ "delayed" ][ "top" ] 		 = "ontime";

	self.current_state							 = "ontime";

	self.tabs[ "arriving" ].angles = self.status[ "angles" ][ "top" ];
	self.tabs[ "boarding" ].angles = self.status[ "angles" ][ "waiting" ];
	self.tabs[ "boarding" ] Hide();
	self.tabs[ "delayed" ] Hide();
}

sign_departure_status_flip_to( state )
{
	time = .20;
	while ( self.current_state != state )
	{
		next_state 	 = self.status[ "order" ][ self.current_state ];
		topname 	 = self.status[ self.current_state ][ "top" ];
		bottomname 	 = self.status[ self.current_state ][ "bottom" ];
		newname		 = self.status[ next_state ][ "top" ];

		toptab		 = self.tabs[ topname ];
		bottomtab   = self.tabs[ bottomname ];
		newtab		 = self.tabs[ newname ];

		//move top to bottom position
		toptab RotatePitch( 180, time );
		newtab.angles = self.status[ "angles" ][ "top" ];
		//bring new to top position
		wait .05;
		newtab Show();
		//bring bottom to wait position
		wait( time - .1 );
		bottomtab Hide();
		bottomtab.angles = self.status[ "angles" ][ "waiting" ];
		wait .05;
		self.current_state = next_state;
	}
}

give_beretta()
{
	self endon( "death" );
	
	self.gun_remove = true;
	self gun_remove();
	gun = GetWeaponModel( "beretta" );
	self Attach( gun, "tag_weapon_right" );

	self HidePart( "TAG_SILENCER" );
	
	self waittill( "panic_button" );
	self detach( gun, "tag_weapon_right" );	
}


#using_animtree( "dog" );
ai_loop_dog( animation, array )
{
	self endon( "panic_button" );
	self endon( "death" );
	self endon( "do_anim" );
	self.anim_to_do = getanim_generic( animation );
	self.array_to_do = array;
	self.current_anim = getanim_generic( animation );
	
	self thread ai_current_anim_stop();
	
	self ai_wait_current_anim();	
	waittillframeend;
		
	self AnimCustom( ::custom_ai_loop_dog );
}

custom_ai_loop_dog()
{
	self endon( "panic_button" );
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "do_anim" );
	self notify( "new_custom_anim" );
	self endon( "new_custom_anim" );
	
	animation = self.anim_to_do;
	array = self.array_to_do;	

	while( 1 )
	{
		anime = self.current_anim;
		self.current_anim = random( level.scr_anim[ "generic" ][ array ] );
		self ClearAnim( anime, 0 );
		self animMode( "nogravity" );
		self setanimrestart( self.current_anim, 1, 0, self.anim_speed );
		
		self ai_wait_current_anim();	
		waittillframeend;
	}
}
#using_animtree( "generic_human" );

panic_button()
{
	self setHintString( &"CHAR_MUSEUM_DO_NOT_PRESS" );
	self usetriggerrequirelookat();	

	self thread panic_icon();
	self thread panic_trig_on_off();
	
	model = getent( self.target, "targetname" );
	model ent_flag_init( "ready" );
	model ent_flag_set( "ready" );
	
	while( 1 )
	{
		model ent_flag_wait( "ready" );
			
		self waittill( "trigger" );
		
		self thread panic_button_move( model );
		
		ai = getaispeciesarray();
		
		if( !ai.size )
			continue;
		if( !test_ai( ai ) )
			continue;
		
		if( flag( "panic_button" ) )
			continue;
		flag_set( "panic_button" );
				
		array_thread( level.players, ::playLocalSoundWrapper, "arcademode_kill_streak_lost" );
		
		
		level.player.ignoreme = false;
		
		array_thread( ai, ::panic_ai_attack );
		
		
		flag_waitopen( "panic_button" );
		
		array_thread( level.players, ::playLocalSoundWrapper, "arcademode_kill_streak_won" );
	}
}

panic_button_move( model )
{	
	model ent_flag_clear( "ready" );
	if( !isdefined( self.trigger_off ) )
		self trigger_off();
	
	model movez( -1, .1 );
	model playsound( "detpack_trigger" );
	wait 1;	
	model movez( 1, .1 );
	wait .25;	
	
	model ent_flag_set( "ready" );
	
	flag_waitopen( "panic_button" );
	if( isdefined( self.trigger_off ) )		
		self trigger_on();
}

panic_trig_on_off()
{
	while( 1 )
	{
		flag_wait( "panic_button" );
		if( !isdefined( self.trigger_off ) )	
			self trigger_off();
		
		flag_waitopen( "panic_button" );	
		if( isdefined( self.trigger_off ) )
			self trigger_on();
	}
}

panic_icon()
{
	trigger = Spawn( "trigger_radius", self.origin, 0, 50, 72 );

	icon = NewHudElem();
	icon SetShader( "panic_button", 1, 1 );
	icon.alpha = 0;
	icon.color = ( 1, 1, 1 );
	icon.x = self.origin[ 0 ];
	icon.y = self.origin[ 1 ];
	icon.z = self.origin[ 2 ];
	icon SetWayPoint( true, true );

	wait( 0.05 );

	while ( true )
	{
		trigger waittill( "trigger", other );

		if ( !isplayer( other ) )
			continue;

		while ( other IsTouching( trigger ) )
		{
			show = true;
			
			if ( player_looking_at( self.origin, 0.8, true ) && show )
				icon_fade_in( icon );
			else
				icon_fade_out( icon );
			wait 0.25;
		}
		icon_fade_out( icon );
	}
}

icon_fade_in( icon )
{
	if ( icon.alpha != 0 )
		return;

	icon FadeOverTime( 0.2 );
	icon.alpha = .6;
	wait( 0.2 );
}

icon_fade_out( icon )
{
	if ( icon.alpha == 0 )
		return;

	icon FadeOverTime( 0.2 );
	icon.alpha = 0;
	wait( 0.2 );
}

test_ai( ai )
{
	foreach( guy in ai )
	{
		if( guy test_ai_individual() )
			return true;	
	}
	
	return false;
}

test_ai_individual()
{
	if( isdefined( self.current_anim ) && ( self.current_anim == %oilrig_sub_B_idle_3 || self.current_anim == %oilrig_sub_B_idle_4 ) )
		return false;
	if( isdefined( self.type ) && self.type == "civilian" )
		return false;
	return true;
}

panic_ai_attack()
{
	if( !isalive( self ) )
		return;
		
	if( !self test_ai_individual() )
		return;
			
	self notify( "panic_button" );
	self notify( "stop_first_frame" );
	self stopanimscripted();
	
	if( self.anim_node.animation == "gulag_end_evac_soap" )
	{
		self unlink();
		origin = self getDropToFloorPosition( self.origin );
		self forceTeleport( origin, self.angles );
	}
		
	if( isdefined( self.gun_remove ) )
		self gun_recall();
	
	self thread panic_set_attack();
		
	self.grenadeawareness 				= self.old[ "grenadeawareness" ];
	self.ignoreexplosionevents 			= self.old[ "ignoreexplosionevents" ];
	self.ignorerandombulletdamage 		= self.old[ "ignorerandombulletdamage" ];
	self.ignoresuppression 				= self.old[ "ignoresuppression" ];
	self.disableBulletWhizbyReaction 	= self.old[ "disableBulletWhizbyReaction" ];
	self.newEnemyReactionDistSq 		= self.old[ "newEnemyReactionDistSq" ];
	self.flashbangimmunity				= self.old[ "flashbangimmunity" ];
	
	self.health 						= 150;
	self.maxhealth 						= 150;
	
	if( isdefined( self.juggernaut ) && self.juggernaut == true )
	{
		self.health 						= 3600;
		self.maxhealth 						= 3600;	
	}
	if( isdefined( self.script_health ) )
	{
		self.health = self.script_health;
		self.maxhealth = self.script_health;
	}
	self pathrandompercent_reset();
	self enable_pain();
	self PushPlayer( false );
	self.goalradius = 4000;
	//self setgoalentity( level.player );
	self.fixednode = false;
	
	level.panic_guys++;
	
	self waittill( "death" );
	level.panic_guys--;
	
	wait .5;
	
	if( level.panic_guys == 0 )
		flag_clear( "panic_button" );
}

panic_set_attack()
{
	self endon( "death" );
	wait .5;
	wait randomfloat( .5 );
	
	self.ignoreall = false;
	self.ignoreme = false;
	self.team = "axis";
	self.favoriteenemy = level.player;
}

c4_packs_think()
{
   wait( randomfloatrange( 0, .6 ) );   //so they don't all blink simultaneously
   playFXOnTag( getfx( "c4_blink" ), self, "tag_fx" );
}