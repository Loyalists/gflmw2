#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

// ---------------------------------------------------------------------------------
//	Rapelling AI
// ---------------------------------------------------------------------------------
player_seek_stages()
{
	self endon( "death" );

	stages[ 0 ] = 2000;
	stages[ 1 ] = 1500;
	stages[ 2 ] = 1000;

	if ( IsDefined( self.script_vehicleride ) )
	{
		self waittill( "jumpedout" );
		wait 0.5;
	}

	self SetGoalEntity( level.players[ 0 ] );

	foreach ( iRadius in stages )
	{
		self.goalradius = iRadius;
		wait 15.0;
	}
}

ai_rappel_think( playerSeek )
{
	self endon( "death" );

	self.animname = "generic";
	self.oldhealth = self.health;
	self.health = 3;
	self Hide();

	reference = self.spawner;
	reference anim_first_frame_solo( self, self.animation );

	wait( 0.5 );
	wait RandomFloat( 4 );

	eRopeOrg = Spawn( "script_origin", reference.origin );
	eRopeOrg.angles = reference.angles;

	eRope = Spawn( "script_model", eRopeOrg.origin );
	eRope SetModel( "coop_bridge_rappelrope" );
	eRope.animname = "rope";
	eRope assign_animtree();

	eRopeOrg anim_first_frame_solo( eRope, "coop_ropedrop_01" );
	eRopeOrg anim_single_solo( eRope, "coop_ropedrop_01" );

	self Show();
	self.allowdeath = true;
	self thread ai_rappel_death();

	eRopeOrg thread anim_single_solo( eRope, "coop_" + self.animation );
	reference thread anim_generic( self, self.animation );

	self thread prevent_fall_overbridge();
	self thread prevent_fall_overrail();
	self waittill( "over_solid_ground" );

	self.health = self.oldhealth;
	if ( IsDefined( playerSeek ) && playerSeek )
	{
		self thread player_seek_stages();
	}
	else
	{
		self.goalradius = 500;
		self SetGoalPos( self.origin );
	}
}

prevent_fall_overbridge()
{
	level endon( "special_op_terminated" );
	self endon( "over_solid_ground" );
	self endon( "death" );
	self endon( "overrail" );

	if ( self.animation == "bridge_rappel_R" )
	{
		x = 10888;
	}
	else
	{
		x = 10106;
	}

	while ( 1 )
	{
		if ( self.animation == "bridge_rappel_R" )
		{
			self.allowdeath = self.origin[ 0 ] > x;
		}
		else
		{
			self.allowdeath = self.origin[ 0 ] < x;
		}

		// Catch if killed during allowdeath is false
		if ( self.allowdeath && self.health == 1 )
		{
			self Kill();
			return;
		}

		wait( 0.05 );
	}
}

// This will prevent the AI from dying while clipping through the hand rail on the bridge
prevent_fall_overrail()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	animation = level.scr_anim[ self.animname ][ self.animation ];
	overall_time = GetAnimLength( animation );
	time_fracs = GetNoteTrackTimes( animation, "over_solid" );

	delay = overall_time * time_fracs[ 0 ];

	wait( delay - 0.2 );

	self notify( "overrail" );

	self.allowdeath = false;
//	self thread debug_draw_on_ent( "CANNOT" );
	wait( 0.35 );
	self.allowdeath = true;

	if ( self.health == 1 )
	{
		self Kill();
	}

//	self thread debug_draw_on_ent( "can" );
}

debug_draw_on_ent( msg )
{
/#
	self notify( "stop_draw_on_ent" );
	self endon( "stop_draw_on_ent" );
	self endon( "death" );

	timer = GetTime() + 3000;

	while ( GetTime() < timer )
	{
		Print3d( self.origin, msg, ( 0.8, 0.8, 0.2 ) );
		wait( 0.05 );
	}
#/
}

ai_rappel_death()
{
	self endon( "over_solid_ground" );
	if ( !isdefined( self ) )
	{
		return;
	}

	self set_deathanim( "fastrope_fall" );
	self waittill( "death" );

	if ( IsDefined( self ) )
	{
		self thread play_sound_in_space( "generic_death_falling" );
	}
}

ai_rappel_over_ground_death_anim( guy )
{
	guy endon( "death" );
	guy notify( "over_solid_ground" );
	guy clear_deathanim();
}

// ---------------------------------------------------------------------------------
//	Scripted Destructions
// ---------------------------------------------------------------------------------
missile_taxi_moves()
{
	// Remove the script_noteworthy from the ad sign on the taxi
	ents = GetEntArray( "taxi_ad_clip", "targetname" );
	foreach ( ent in ents )
	{
		if ( IsDefined( ent.script_noteworthy ) && ent.script_noteworthy == "missile_taxi" )
		{
			ent.script_noteworthy = undefined;
		}
	}

	taxi = GetEnt( "missile_taxi", "script_noteworthy" );
	taxi.finalOrg = taxi.origin;
	taxi.finalAng = taxi.angles;

	clip = GetEnt( "missile_taxi_clip", "script_noteworthy" );

	taxi.origin += ( 80, 200, 0 );
	taxi.angles = ( 0, 180, 0 );

	wait( 3 );

	taxi thread missile_taxi_get_hit_by_hellfire();
	taxi thread missile_taxi_get_exploded();
	taxi waittill( "taxi_moving" );

	clip ConnectPaths();
	clip Delete();

	taxi thread destructible_force_explosion();
	moveTime = 1.0;
	taxi MoveTo( taxi.finalOrg, moveTime, 0, moveTime / 2 );
	taxi RotateTo( taxi.finalAng, moveTime, 0, moveTime / 2 );
}

missile_taxi_get_hit_by_hellfire()
{
	self endon( "taxi_moving" );

	for ( ;; )
	{
		self waittill( "damage", amount, attacker );
		if ( !isdefined( attacker ) )
		{
			continue;
		}

		if ( !isdefined( attacker.classname ) )
		{
			continue;
		}

		if ( attacker.classname == "script_vehicle" )
		{
			break;
		}
	}

	self notify( "taxi_moving" );

}

missile_taxi_get_exploded()
{
	self endon( "taxi_moving" );
	
	self waittill( "exploded" );

	self notify( "taxi_moving" );
}

// ---------------------------------------------------------------------------------
//	Attack Helicopter
// ---------------------------------------------------------------------------------
attack_heli()
{
	trigger_wait( "attack_heli", "targetname" );
	attack_heli = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "kill_heli" );
	thread maps\_attack_heli::begin_attack_heli_behavior( attack_heli );
	Assert( IsDefined( attack_heli ) );
	wait 2;
	radio_dialogue( "so_bridge_hqr_enemy_helo" );
}

// ---------------------------------------------------------------------------------
//	Bridge Collapsing
// ---------------------------------------------------------------------------------
BRIDGE_COLLAPSE_SPEED = 1.0;

collapsed_section_shakes()
{
	trigger = GetEnt( "collapsed_bridge_effects", "targetname" );
	targets = GetEntArray( trigger.target, "targetname" );

	trigger waittill( "trigger" );

	foreach ( eTarget in targets )
	{
		//playfx( <effect id >, <position of effect>, <forward vector>, <up vector> )
		PlayFX( getfx( "dust_ceiling_fall" ), eTarget.origin );
	}
}

bridge_collapse_prep()
{
	wait 0.1;

	thread road_piece_1();
	thread road_piece_2();
	thread road_piece_3();
	thread road_piece_4();
	thread road_piece_5();
	thread road_piece_6();
	// thread road_piece_7();
	thread road_piece_8();
	thread bridge_collapse_van();
	thread bridge_collapse_suv();
	thread bridge_collapse_truck_1();
	thread bridge_collapse_truck_2();
	thread bridge_collapse_sedan_1();

	thread reveal_details();

	thread car_slide( "slide_car_1", "slide_car_start_1" );
	thread car_slide( "slide_car_2", "slide_car_start_2" );
	thread car_slide( "slide_car_3", "slide_car_start_3" );
	thread car_slide( "slide_car_4", "slide_car_start_4" );

	thread view_tilt();

	//bridge_collapse_smashed_car_1

//	if ( GetDvar( "test_bridge_collapse" ) == "1" )
//	{	
//		level thread notify_delay( "bridge_collapse", 10 );
//	}

	level waittill( "bridge_collapse" );

	// start sound, needs 2 seconds to play before bridge comes down
	bridge_collapse_sound = GetEnt( "bridge_collapse_sound", "targetname" );
	Assert( IsDefined( bridge_collapse_sound ) );
	bridge_collapse_sound thread play_sound_on_entity( "scn_bridge_collapse" );

	if ( IsDefined( level.player_sprint_scale ) )
	{
		SetSavedDvar( "player_sprintSpeedScale", level.default_sprint );
	}

	// bridge begins to fall
	level notify( "bridge_collapse_start" );
	level thread notify_delay( "bridge_sway_start", 0.5 );

	exploder( 1 );

	//setblur( 1.0, 0.5 );
	wait 6 * BRIDGE_COLLAPSE_SPEED;
	//setblur( 0, 0.5 );

	if ( IsDefined( level.player_sprint_scale ) )
	{
		SetSavedDvar( "player_sprintSpeedScale", level.player_sprint_scale );
	}
}

bridge_collapse_earthquake()
{
	ent = GetEnt( "bridge_collapse_sound", "targetname" );
	ent PlayRumbleOnEntity( "so_bridge_collapse" );

	// start earthquake now, bridge is tilting and cars are sliding
	time = 1;
	Earthquake( 0.7, time, ent.origin, 5000 );
	wait( time * 0.7 );

	time = 7;
	Earthquake( 0.25, time, ent.origin, 5000 );
	wait( time * 0.5 );

	time = 7;
	Earthquake( 0.2, time, ent.origin, 5000 );
	wait( time * 0.5 );

	time = 5;
	Earthquake( 0.15, time, ent.origin, 5000 );
	wait( time );
}

reveal_details()
{
	// bridge destroyed details that dont move, they just spawn in after the collapse and are hidden by the smoke
	bridge_collapse_details = GetEntArray( "bridge_collapse_detail", "targetname" );
	thread array_call( bridge_collapse_details, ::Hide );

	// these destroyed bridge details spawn in also but need to slide into position because they are less hidden by the smoke
	/*
	bridge_collapse_detail_slide_origin = GetEnt( "bridge_collapse_detail_slide_origin", "targetname" ).origin;
	bridge_collapse_detail_slide = GetEntArray( "bridge_collapse_detail_slide", "targetname" );
	
	foreach( part in bridge_collapse_detail_slide )
	{
		part.finalOrigin = part.origin;
		part.origin = ( part.origin[ 0 ], bridge_collapse_detail_slide_origin[ 1 ], bridge_collapse_detail_slide_origin[ 2 ] );
		part Hide();
	}
	*/
	level waittill( "bridge_collapse_start" );

	wait 1;
	/*
	foreach( part in bridge_collapse_detail_slide )
	{
		part Show();
		part thread reveal_details_slide();
	}
	*/
	wait 1.5;

	thread array_call( bridge_collapse_details, ::Show );
}

reveal_details_slide()
{
	self Show();
	self MoveTo( self.finalOrigin, 2.0, 0.0, 0.5 );
	wait 2.0;
	self.origin = self.finalOrigin;
}

road_piece_1()
{
	part = GetEnt( "bridge_piece_1", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	details = GetEntArray( "road_piece_1_detail", "targetname" );
	thread array_call( details, ::Hide );

	part.origin += ( 0, 0, 280 );
	part.angles = ( -3, 0, 0 );

	level waittill( "bridge_collapse_start" );

	nextPosOrigin = part.origin - ( 0, 0, 150 );
	nextPosAngle = part.angles + ( -2, 0, 20 );

	moveTime = 0.75 * BRIDGE_COLLAPSE_SPEED;

	part RotateTo( nextPosAngle, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0 * BRIDGE_COLLAPSE_SPEED );
	part MoveTo( nextPosOrigin, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0 * BRIDGE_COLLAPSE_SPEED );
	wait moveTime;

	part RotateTo( part.landingSpotAng, moveTime, 0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	part MoveTo( part.landingSpotOrg, moveTime, 0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	wait moveTime;

	thread array_call( details, ::Show );

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_2()
{
	part = GetEnt( "bridge_piece_2", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	details = GetEntArray( "road_piece_2_detail", "targetname" );
	thread array_call( details, ::Hide );

	part.origin += ( 0, 0, 130 );
	part.angles = ( -15, 0, -22 );

	level waittill( "bridge_collapse_start" );

	moveTime = 1.5 * BRIDGE_COLLAPSE_SPEED;

	part RotateTo( part.landingSpotAng, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	part MoveTo( part.landingSpotOrg, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	wait moveTime;

	thread array_call( details, ::Show );

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_3()
{
	PART_SPEED = 0.75;

	part = GetEnt( "bridge_piece_3", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 90 );

	level waittill( "bridge_collapse_start" );

	wait 2.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );

	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_4()
{
	PART_SPEED = 0.75;

	part = GetEnt( "bridge_piece_4", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 30 );

	level waittill( "bridge_collapse_start" );

	wait 3.0 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_5()
{
	PART_SPEED = 0.75;

	part = GetEnt( "bridge_piece_5", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 20 );

	level waittill( "bridge_collapse_start" );

	wait 2.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_6()
{
	PART_SPEED = 0.75;

	part = GetEnt( "bridge_piece_6", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 40 );

	level waittill( "bridge_collapse_start" );

	wait 1.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_7()
{
	PART_SPEED = 0.75;

	part = GetEnt( "bridge_piece_7", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 40 );

	level waittill( "bridge_collapse_start" );

	wait 2.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_8()
{
	PART_SPEED = 0.75;

	part = GetEnt( "bridge_piece_8", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 40 );

	level waittill( "bridge_collapse_start" );

	wait 1.5 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part MoveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );

	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

bridge_collapse_van()
{
	part = GetEnt( "bridge_collapse_van", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( -80, 50, 280 );

	level waittill( "bridge_collapse_start" );

	nextPosOrigin = part.origin - ( 0, 0, 280 );
	part MoveTo( nextPosOrigin, 1.4 * BRIDGE_COLLAPSE_SPEED, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );

	wait 1.4 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.2 * BRIDGE_COLLAPSE_SPEED, 0.7 * BRIDGE_COLLAPSE_SPEED, 0.5 * BRIDGE_COLLAPSE_SPEED );
}

bridge_collapse_suv()
{
	part = GetEnt( "bridge_collapse_suv", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 200 );
	part.angles = ( 90, 90, 0 );

	level waittill( "bridge_collapse_start" );

	wait 1.8 * BRIDGE_COLLAPSE_SPEED;

	nextPosOrigin = part.origin - ( 0, 0, 200 );
	part MoveTo( nextPosOrigin, 0.5 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );

	wait 0.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 0.5 * BRIDGE_COLLAPSE_SPEED, 0.1 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	part RotateTo( part.landingSpotAng, 0.5 * BRIDGE_COLLAPSE_SPEED, 0.1 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
}

bridge_collapse_truck_1()
{
	part = GetEnt( "bridge_collapse_truck_1", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 280 );
	part.angles = ( 90, 0, 90 );

	level waittill( "bridge_collapse_start" );

	wait 2.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg + ( 0, 0, 84 ), 1.0 * BRIDGE_COLLAPSE_SPEED, 0.9 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );

	wait 1.0 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 0.8 * BRIDGE_COLLAPSE_SPEED, 0.8 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	part RotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );

	wait 1.0 * BRIDGE_COLLAPSE_SPEED;

//	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

bridge_collapse_truck_2()
{
	part = GetEnt( "bridge_collapse_truck_2", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( 0, 0, 380 );
	part.angles = ( 90, -30, 0 );

	level waittill( "bridge_collapse_start" );

	wait 0.5 * BRIDGE_COLLAPSE_SPEED;

	moveTime = 1.0 * BRIDGE_COLLAPSE_SPEED;
	part MoveTo( part.landingSpotOrg + ( 0, 0, 80 ), moveTime, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );

	wait 0.2 * BRIDGE_COLLAPSE_SPEED;

	moveTime = 0.75 * BRIDGE_COLLAPSE_SPEED;
	part MoveTo( part.landingSpotOrg, moveTime, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	part RotateTo( part.landingSpotAng, moveTime, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );

	wait moveTime;

	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

bridge_collapse_sedan_1()
{
	part = GetEnt( "bridge_collapse_sedan_1", "targetname" );
	Assert( IsDefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;

	part.origin += ( -50, 180, 150 );
	part.angles = ( 0, 330, 0 );	// 26 330 13

	part SetModel( "vehicle_coupe_gold" );

	level waittill( "bridge_collapse_start" );

	nextPosOrigin = part.origin - ( 0, 0, 50 );
	part MoveTo( nextPosOrigin, 1.5 * BRIDGE_COLLAPSE_SPEED, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	part RotateTo( part.landingSpotAng, 1.5 * BRIDGE_COLLAPSE_SPEED, 0.1 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );

	wait 1.5 * BRIDGE_COLLAPSE_SPEED;

	part MoveTo( part.landingSpotOrg, 1.2 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 1.0 * BRIDGE_COLLAPSE_SPEED );

	wait 1.2 * BRIDGE_COLLAPSE_SPEED;

	part SetModel( "vehicle_coupe_gold_destroyed" );
}

part_rummble( finalOrg, finalAng )
{
	// makes a part move around a bit after crashing down to make it seem less mechanical

	MAX_RUMBLE_ORG_OFFSET = 5;
	MAX_RUMBLE_ANG_OFFSET = 1;

	numMoves = RandomIntRange( 3, 5 );

	for ( i = 0; i < numMoves; i++ )
	{
		moveTime = RandomFloatRange( 0.05, 0.2 ) * BRIDGE_COLLAPSE_SPEED;
		//accel_decel = RandomFloatRange( 0.0, moveTime / 2 );
		accel_decel = 0 * BRIDGE_COLLAPSE_SPEED;

		offsetAng = ( RandomIntRange( 0, MAX_RUMBLE_ANG_OFFSET ) - ( MAX_RUMBLE_ANG_OFFSET / 2 ), RandomIntRange( 0, MAX_RUMBLE_ANG_OFFSET ) - ( MAX_RUMBLE_ANG_OFFSET / 2 ), RandomIntRange( 0, MAX_RUMBLE_ANG_OFFSET ) - ( MAX_RUMBLE_ANG_OFFSET / 2 ) );
		offsetOrg = ( RandomIntRange( 0, MAX_RUMBLE_ORG_OFFSET ) - ( MAX_RUMBLE_ORG_OFFSET / 2 ), RandomIntRange( 0, MAX_RUMBLE_ORG_OFFSET ) - ( MAX_RUMBLE_ORG_OFFSET / 2 ), RandomIntRange( 0, MAX_RUMBLE_ORG_OFFSET ) - ( MAX_RUMBLE_ORG_OFFSET / 2 ) );

		self RotateTo( self.angles + offsetAng, moveTime, accel_decel, accel_decel );
		self MoveTo( self.origin + offsetOrg, moveTime, accel_decel, accel_decel );

		wait moveTime;

		self RotateTo( finalAng, moveTime, accel_decel, accel_decel );
		self MoveTo( finalOrg, moveTime, accel_decel, accel_decel );

		wait moveTime;
	}

	self.origin = finalOrg;
	self.angles = finalAng;
}

view_tilt()
{
	view_angle_controller_entity = GetEnt( "view_angle_controller_entity", "targetname" );
	Assert( IsDefined( view_angle_controller_entity ) );
	direction_ent = GetEnt( view_angle_controller_entity.target, "targetname" );
	Assert( IsDefined( direction_ent ) );
	gravity_vec = VectorNormalize( direction_ent.origin - view_angle_controller_entity.origin );

//	level waittill( "bridge_collapse_start" );
	level waittill( "bridge_sway_start" );

	SetSavedDvar( "phys_gravityChangeWakeupRadius", 1600 );

	foreach ( player in level.players )
	{
		player SetMoveSpeedScale( 0.5 );
		player PlayerSetGroundReferenceEnt( view_angle_controller_entity );
	}

	moveTime = 1.5;
	view_angle_controller_entity RotateTo( ( 10, 13, 0 ), moveTime, moveTime * 0.5, moveTime * 0.5 );
	wait( moveTime - 0.5 );

	SetPhysicsGravityDir( gravity_vec );
	wait( 1.5 );

	moveTime = 1.0;
	view_angle_controller_entity RotateTo( ( -3, -1, 0 ), moveTime, moveTime * 0.5, moveTime * 0.5 );
	wait( moveTime );

	moveTime = 1.0;
	view_angle_controller_entity RotateTo( ( 4, 5, 0 ), moveTime, moveTime * 0.5, moveTime * 0.5 );
	wait( moveTime );

	moveTime = 2.0;
	view_angle_controller_entity RotateTo( ( 0, 2, 0 ), moveTime, moveTime * 0.5, moveTime * 0.5 );
	wait( moveTime );

	SetPhysicsGravityDir( ( 0, 0, -1 ) );

	foreach ( player in level.players )
	{
		player AllowSprint( true );
		player SetMoveSpeedScale( 1 );
	}
}

car_slide( carName, startName )
{
	ents = GetEntArray( carName, "script_noteworthy" );
	car = undefined;
	foreach ( ent in ents )
	{
		if ( ent.classname != "script_model" )
		{
			continue;
		}

		car = ent;
		break;
	}

	// Link Clip
	clip = GetEnt( carName + "_clip", "script_noteworthy" );
	clip.origin = car.origin;
	clip.angles = car.angles;

	clip LinkTo( car );

	Assert( IsDefined( car ) );

	start = GetEnt( startName, "script_noteworthy" );
	Assert( IsDefined( car ) );
	Assert( IsDefined( start ) );

	d = Distance( car.origin, start.origin );
	moveTime = d / 50;
	accel_decel = moveTime / 4;

	car.finalOrg = car.origin;
	car.origin = start.origin;

//	level waittill( "bridge_collapse_start" );
	level waittill( "bridge_sway_start" );

	wait 1;

	car MoveTo( car.finalOrg, moveTime, accel_decel, accel_decel );

	car waittill( "movedone" );
	clip Delete();
}