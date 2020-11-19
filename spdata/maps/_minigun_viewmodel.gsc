#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

#using_animtree( "vehicles" );
player_viewhands_minigun( turret )
{
	/*
	viewhands = spawn_anim_model( "suburban_hands", turret getTagOrigin( "tag_player" ) );
	viewhands.angles = turret getTagAngles( "tag_player" );
	viewhands linkto( turret, "tag_player" );
	
	viewhands setAnim( viewhands getanim( "idle_L" ), 1, 0, 1 );
	viewhands setAnim( viewhands getanim( "idle_R" ), 1, 0, 1 );
	
	viewhands thread player_viewhands_minigun_hand( "LEFT" );
	viewhands thread player_viewhands_minigun_hand( "RIGHT" );
	*/
	
	turret useAnimTree( #animtree );
	turret.animname = "suburban_hands";
	turret attach( "ch_viewhands_player_gk_ump45", "tag_player" );
	turret setAnim( %player_suburban_minigun_idle_L, 1, 0, 1 );
	turret setAnim( %player_suburban_minigun_idle_R, 1, 0, 1 );
	
	turret thread player_viewhands_minigun_hand( "LEFT" );
	turret thread player_viewhands_minigun_hand( "RIGHT" );
}


#using_animtree( "vehicles" );
anim_minigun_hands()
{
	level.scr_animtree[ "suburban_hands" ] 							 		= #animtree;
	level.scr_model[ "suburban_hands" ] 									= "ch_viewhands_player_gk_ump45";
	level.scr_anim[ "suburban_hands" ][ "idle_L" ]						 	= %player_suburban_minigun_idle_L;
	level.scr_anim[ "suburban_hands" ][ "idle_R" ]						 	= %player_suburban_minigun_idle_R;
	level.scr_anim[ "suburban_hands" ][ "idle2fire_L" ]						= %player_suburban_minigun_idle2fire_L;
	level.scr_anim[ "suburban_hands" ][ "idle2fire_R" ]						= %player_suburban_minigun_idle2fire_R;
	level.scr_anim[ "suburban_hands" ][ "fire2idle_L" ]						= %player_suburban_minigun_fire2idle_L;
	level.scr_anim[ "suburban_hands" ][ "fire2idle_R" ]						= %player_suburban_minigun_fire2idle_R;
	
	//
	//
}

player_viewhands_minigun_hand( hand )
{
	self endon( "death" );
	checkFunc = undefined;
	if ( hand == "LEFT" )
		checkFunc = ::spinButtonPressed;
	else if ( hand == "RIGHT" )
		checkFunc = ::fireButtonPressed;
	assert( isdefined( checkFunc ) );
	
	for(;;)
	{
		if( level.player [[checkFunc]]() )
		{
			thread player_viewhands_minigun_presed( hand );
			while( level.player [[checkFunc]]() )
				wait 0.05;
		}
		else
		{
			thread player_viewhands_minigun_idle( hand );
			while( !level.player [[checkFunc]]() )
				wait 0.05;
		}
	}
}

spinButtonPressed()
{
	if ( level.player AdsButtonPressed() )
		return true;
	if ( level.player AttackButtonPressed() )
		return true;
	return false;
}

fireButtonPressed()
{
	return level.player AttackButtonPressed();
}

player_viewhands_minigun_idle( hand )
{
	animHand = undefined;
	if ( hand == "LEFT" )
		animHand = "L";
	else if ( hand == "RIGHT" )
		animHand = "R";
	assert( isdefined( animHand ) );
	
	self clearAnim( self getanim( "idle2fire_" + animHand ), 0.2 );
	self setFlaggedAnimRestart( "anim", self getanim( "fire2idle_" + animHand ) );
	self waittillmatch( "anim", "end" );
	self clearAnim( self getanim( "fire2idle_" + animHand ), 0.2 );
	self setAnim( self getanim( "idle_" + animHand ) );
}

player_viewhands_minigun_presed( hand )
{
	animHand = undefined;
	if ( hand == "LEFT" )
		animHand = "L";
	else if ( hand == "RIGHT" )
		animHand = "R";
	assert( isdefined( animHand ) );
	
	self clearAnim( self getanim( "idle_" + animHand ), 0.2 );
	self setAnim( self getanim( "idle2fire_" + animHand ) );
}