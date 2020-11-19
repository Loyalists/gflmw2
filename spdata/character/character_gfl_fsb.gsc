main()
{
	switch( codescripts\character::get_random_character(5) )
	{
	case 0:
		character\character_gfl_p90::main();
		break;
	case 1:
		character\character_gfl_m1903::main();
		break;
	case 2:
		character\character_gfl_tac50::main();
		break;
	case 3:
		character\character_gfl_type97::main();
		break;
	case 4:
		character\character_gfl_rfb::main();
		break;
	}
	self.voice = "russian";
}

precache()
{
	character\character_gfl_p90::precache();
	character\character_gfl_m1903::precache();
	character\character_gfl_tac50::precache();
	character\character_gfl_type97::precache();
	character\character_gfl_rfb::precache();

}