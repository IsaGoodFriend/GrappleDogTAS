//*

//(\t+global\.)(up|down|left|right)_(press|check|release)( = \d)\r\n
//$0$1menu_$2_$3$4\n

// TODO:
// Ignore empty and commented lines in input
// Read other input files while loading original
// Allow human input while tas isn't playing
// 
	
// R = Right
// L = Left
// U = Up
// D = Down
// J = Jump
// G = Grapple
// S = Slam
// T = Talk
// P = Pause
// C = Confirm
// B = Back
function read_tas_file(argument0)
{
	file = file_text_open_read(argument0)
	index = 0
	
	while (!file_text_eof(file))
	{
		global.tas_inputs[index] = []
		
		line = file_text_readln(file)
		//if (string_length(line) <= 0)
		//	continue
		
		i = 1;
		
		frames = "0"
		
		for (; i <= string_length(line); i++)
		{
			char = string_copy(line, i, 1)
			
			if (char == ";")
				break
			
			frames = frames + char
		}
		global.tas_inputs[index][0] = real(frames)
		global.tas_inputs[index][1] = 0
		
		for (; i <= string_length(line); i++)
		{
			char = string_copy(line, i, 1)
			
			if (char == "R")
				global.tas_inputs[index][1] |= 1 // 0b 0000 000 0001
			else if (char == "L")
				global.tas_inputs[index][1] |= 2 // 0b 0000 000 0010
			else if (char == "U")
				global.tas_inputs[index][1] |= 4 // 0b 0000 000 0100
			else if (char == "D")
				global.tas_inputs[index][1] |= 8 // 0b 0000 000 1000
			else if (char == "J")
				global.tas_inputs[index][1] |= 16 // 0b 0000 001 0000
			else if (char == "G")
				global.tas_inputs[index][1] |= 32 // 0b 0000 010 0000
			else if (char == "S")
				global.tas_inputs[index][1] |= 64 // 0b 0000 100 0000
			else if (char == "T")
				global.tas_inputs[index][1] |= 128 // 0b 0001 000 0000
			else if (char == "P")
				global.tas_inputs[index][1] |= 256 // 0b 0010 000 0000
			else if (char == "C")
				global.tas_inputs[index][1] |= 512 // 0b 0100 000 0000
			else if (char == "B")
				global.tas_inputs[index][1] |= 1024 // 0b 1000 000 0000
			else if (char == "A")
				global.tas_inputs[index][1] |= 0 // dummy extra
			else if (char == "A")
				global.tas_inputs[index][1] |= 0 // dummy extra
			else if (char == "A")
				global.tas_inputs[index][1] |= 0 // dummy extra
			
		}
		
		index++
	}
	
	file_text_close(file)
}

function tas_start()
{
	global.tas_totalframe = 0
	global.tas_chunkindex = 0
	global.tas_chunkframe = 0
	global.tas_inputs = []
	
	read_tas_file("tas/input.txt")
}
function tas_update()
{
	if (gamepad_button_check_pressed(global.gamepad, gp_face2))
	{
		global.tas_state = 2
		
		return 0;
	}
	
	if (global.tas_chunkindex >= 0 && global.tas_chunkindex < array_length(global.tas_inputs))
	{
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0001)
		{
			if (global.tas_chunkframe == 0)
			{
				global.right_press = !global.right_check
				global.menu_right_press = !global.menu_right_check
			}
			else
			{
				global.right_press = 0
				global.menu_right_press = 0
			}
			global.right_release = 0
			global.menu_right_release = 0
			global.right_check = 1
			global.menu_right_check = 1
		}
		else
		{
			global.right_release = global.right_check
			global.right_press = 0
			global.right_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0002)
		{
			if (global.tas_chunkframe == 0)
			{
				global.left_press = !global.left_check
				global.menu_left_press = !global.menu_left_check
			}
			else
			{
				global.left_press = 0
				global.menu_left_press = 0
			}
			global.left_release = 0
			global.menu_left_release = 0
			global.left_check = 1
			global.menu_left_check = 1
		}
		else
		{
			global.left_release = global.left_check
			global.left_press = 0
			global.menu_left_release = global.menu_left_check
			global.menu_left_press = 0
			global.left_check = 0
			global.menu_left_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0004)
		{
			if (global.tas_chunkframe == 0)
			{
				global.up_press = !global.up_check
				global.menu_up_press = !global.menu_up_check
			}
			else
			{
				global.up_press = 0
				global.menu_up_press = 0
			}
			global.up_release = 0
			global.menu_up_release = 0
			global.up_check = 1
			global.menu_up_check = 1
		}
		else
		{
			global.up_release = global.up_check
			global.up_press = 0
			global.menu_up_release = global.menu_up_check
			global.menu_up_press = 0
			global.up_check = 0
			global.menu_up_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0008)
		{
			if (global.tas_chunkframe == 0)
			{
				global.down_press = !global.down_check
				global.menu_down_press = !global.menu_down_check
			}
			else
			{
				global.down_press = 0
				global.menu_down_press = 0
			}
			global.down_release = 0
			global.menu_down_release = 0
			global.down_check = 1
			global.menu_down_check = 1
		}
		else
		{
			global.down_release = global.down_check
			global.down_press = 0
			global.menu_down_release = global.menu_down_check
			global.menu_down_press = 0
			global.down_check = 0
			global.menu_down_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0010)
		{
			if (global.tas_chunkframe == 0)
			{
				global.jump_press = !global.jump_check
			}
			else
			{
				global.jump_press = 0
			}
			global.jump_release = 0
			global.jump_check = 1
		}
		else
		{
			global.jump_release = global.jump_check
			global.jump_press = 0
			global.jump_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0020)
		{
			if (global.tas_chunkframe == 0)
			{
				global.grapple_press = !global.grapple_check
			}
			else
			{
				global.grapple_press = 0
			}
			global.grapple_release = 0
			global.grapple_check = 1
		}
		else
		{
			global.grapple_release = global.grapple_check
			global.grapple_press = 0
			global.grapple_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0040)
		{
			if (global.tas_chunkframe == 0)
			{
				global.slam_press = !global.slam_check
			}
			else
			{
				global.slam_press = 0
			}
			global.slam_release = 0
			global.slam_check = 1
		}
		else
		{
			global.slam_release = global.slam_check
			global.slam_press = 0
			global.slam_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0080)
		{
			if (global.tas_chunkframe == 0)
			{
				global.talk_press = !global.talk_check
			}
			else
			{
				global.talk_press = 0
			}
			global.talk_release = 0
			global.talk_check = 1
		}
		else
		{
			global.talk_release = global.talk_check
			global.talk_press = 0
			global.talk_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0100)
		{
			if (global.tas_chunkframe == 0)
			{
				global.pause_press = !global.pause_check
			}
			else
			{
				global.pause_press = 0
			}
			global.pause_release = 0
			global.pause_check = 1
		}
		else
		{
			global.pause_release = global.pause_check
			global.pause_press = 0
			global.pause_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0200)
		{
			if (global.tas_chunkframe == 0)
			{
				global.confirm_press = !global.confirm_check
				global.confirm_press = !global.confirm_check
			}
			else
			{
				global.confirm_press = 0
			}
			global.confirm_release = 0
			global.confirm_check = 1
		}
		else
		{
			global.confirm_release = global.confirm_check
			global.confirm_press = 0
			global.confirm_check = 0
		}
		if (global.tas_inputs[global.tas_chunkindex][1] & 0x0400)
		{
			if (global.tas_chunkframe == 0)
			{
				global.back_press = !global.back_check
			}
			else
			{
				global.back_press = 0
			}
			global.back_release = 0
			global.back_check = 1
		}
		else
		{
			global.back_release = global.back_check
			global.back_press = 0
			global.back_check = 0
		}
		
		
		// increment chunk frame
		global.tas_chunkframe += 1
		
		// if chunk finished, continue onward
		if (global.tas_chunkframe >= global.tas_inputs[global.tas_chunkindex][0])
		{
			global.tas_chunkindex += 1
			global.tas_chunkframe = 0
		}
	}
	else
	{
		global.left_check = 0
		global.left_press = 0
		global.left_release = 0
		global.right_check = 0
		global.right_press = 0
		global.right_release = 0
		global.up_check = 0
		global.up_press = 0
		global.up_release = 0
		global.down_check = 0
		global.down_press = 0
		global.down_release = 0
		global.jump_check = 0
		global.jump_press = 0
		global.jump_release = 0
		global.slam_check = 0
		global.slam_press = 0
		global.slam_release = 0
		global.cutskip_check = 0
		global.cutskip_press = 0
		global.cutskip_release = 0
		global.talk_check = 0
		global.talk_press = 0
		global.talk_release = 0
		global.grapple_check = 0
		global.grapple_press = 0
		global.grapple_release = 0
		global.grapple_down_check = 0
		global.grapple_down_press = 0
		global.grapple_down_release = 0
		global.pause_check = 0
		global.pause_press = 0
		global.pause_release = 0
		global.confirm_press = 0
		global.confirm_check = 0
		global.back_release = 0
		global.back_press = 0
		global.back_check = 0
		global.menu_left_check = 0
		global.menu_left_press = 0
		global.menu_left_release = 0
		global.menu_right_check = 0
		global.menu_right_press = 0
		global.menu_right_release = 0
		global.menu_up_check = 0
		global.menu_up_press = 0
		global.menu_up_release = 0
		global.menu_down_check = 0
		global.menu_down_press = 0
		global.menu_down_release = 0
		
	}
}

//*/

function input_keyboard_restore_defaults() //gml_Script_input_keyboard_restore_defaults
{
    global.input_key_left = ord("A")
    global.input_key_right = ord("D")
    global.input_key_up = ord("W")
    global.input_key_down = ord("S")
    global.input_key_jump = ord("L")
    global.input_key_slam = ord("K")
    global.input_key_grapple = ord("J")
    global.input_key_talk = ord("I")
    global.input_key_cutskip = vk_backspace
    global.input_key_pause = ord("P")
    global.input_key_menu_select = vk_return
    global.input_key_menu_back = vk_backspace
    global.input_key_menu_left = vk_left
    global.input_key_menu_right = vk_right
    global.input_key_menu_up = vk_up
    global.input_key_menu_down = vk_down
}

function input_gamepad_restore_defaults() //gml_Script_input_gamepad_restore_defaults
{
    global.input_gamepad_up = gp_padu
    global.input_gamepad_down = gp_padd
    global.input_gamepad_left = gp_padl
    global.input_gamepad_right = gp_padr
    global.input_gamepad_jump = gp_face1
    global.input_gamepad_slam = gp_face2
    global.input_gamepad_talk = gp_face4
    global.input_gamepad_grapple = gp_face3
    global.input_gamepad_cutskip = gp_select
    global.input_gamepad_pause = gp_start
    global.input_gamepad_menu_select = gp_face1
    global.input_gamepad_menu_back = gp_face2
    global.input_gamepad_menu_up = gp_padu
    global.input_gamepad_menu_down = gp_padd
    global.input_gamepad_menu_left = gp_padl
    global.input_gamepad_menu_right = gp_padr
	
    global.leftstick_move_option = 1
    global.rightstick_move_option = 0
}

function input_init() //gml_Script_input_init
{
    input_keyboard_restore_defaults()
    input_gamepad_restore_defaults()
	
	global.tas_state = 1
	
	//global.tas_state = 1
	/*
    for (i = 0; i < 30; i += 1)
    {
        for (j = 0; j < 3; j += 1)
            global.inputID[i][j] = 0
    }
	//*/
	
	//*
    global.left_check = 0
    global.left_press = 0
    global.left_release = 0
    global.right_check = 0
    global.right_press = 0
    global.right_release = 0
    global.up_check = 0
    global.up_press = 0
    global.up_release = 0
    global.down_check = 0
    global.down_press = 0
    global.down_release = 0
    global.jump_check = 0
    global.jump_press = 0
    global.jump_release = 0
    global.slam_check = 0
    global.slam_press = 0
    global.slam_release = 0
    global.cutskip_check = 0
    global.cutskip_press = 0
    global.cutskip_release = 0
    global.talk_check = 0
    global.talk_press = 0
    global.talk_release = 0
    global.grapple_check = 0
    global.grapple_press = 0
    global.grapple_release = 0
    global.grapple_down_check = 0
    global.grapple_down_press = 0
    global.grapple_down_release = 0
    global.pause_check = 0
    global.pause_press = 0
    global.pause_release = 0
    global.confirm_press = 0
    global.confirm_check = 0
    global.back_press = 0
    global.back_check = 0
    global.menu_left_check = 0
    global.menu_left_press = 0
    global.menu_left_release = 0
    global.menu_right_check = 0
    global.menu_right_press = 0
    global.menu_right_release = 0
    global.menu_up_check = 0
    global.menu_up_press = 0
    global.menu_up_release = 0
    global.menu_down_check = 0
    global.menu_down_press = 0
    global.menu_down_release = 0
	//*/
	
	
	tas_start()
}

function input() //gml_Script_input
{
	if (global.tas_state == 1)
	{
		global.tas_totalframe++
		
		global.confirm_press = 0
		if (global.tas_totalframe == 1540 || global.tas_totalframe == 1570 || global.tas_totalframe == 1600 || global.tas_totalframe == 1630)
		{
			global.confirm_press = 1
		}
		if (global.tas_totalframe == 1800)
		{
			global.tas_state = 0
			global.tas_totalframe = 0
		}
	}
	else if (global.tas_state == 2)
	{
		global.tas_totalframe++
		
		global.confirm_press = 0
		global.pause_press = 0
		global.menu_up_press = 0
		if (global.tas_totalframe == 1)
		{
			global.pause_press = 1
		}
		if (global.tas_totalframe == 25)
		{
			global.menu_up_press = 1
		}
		if (global.tas_totalframe == 30)
		{
			global.confirm_press = 1
		}
		if (global.tas_totalframe == 140)
		{
			tas_start()
			global.tas_state = 0
			global.tas_totalframe = 0
		}
	}
	else
	{
		tas_update()
	}
    global.cutskip_check = 1
    global.cutskip_press = 0
    global.cutskip_release = 0
	
    if ((!instance_exists(oTransition)) && global.controls_active == 1)
    {
    }
	else
	{
		global.left_check = 0
		global.left_press = 0
		global.left_release = 0
		
		global.right_check = 0
		global.right_press = 0
		global.right_release = 0
		
		global.up_check = 0
		global.up_press = 0
		global.up_release = 0
		
		global.down_check = 0
		global.down_press = 0
		global.down_release = 0
		
		global.jump_check = 0
		global.jump_press = 0
		global.jump_release = 0
		
		global.slam_check = 0
		global.slam_press = 0
		global.slam_release = 0
		
		global.talk_check = 0
		global.talk_press = 0
		global.talk_release = 0
		
		global.grapple_check = 0
		global.grapple_press = 0
		global.grapple_release = 0
		
		global.pause_check = 0
		global.pause_press = 0
		global.pause_release = 0
		
		global.confirm_release = 0
		global.confirm_press = 0
		global.confirm_check = 0
	}
	
    if (global.left_check_active == 0)
        global.left_check = 0
    if (global.left_press_active == 0)
        global.left_press = 0
    if (global.left_release_active == 0)
        global.left_release = 0
    if (global.right_check_active == 0)
        global.right_check = 0
    if (global.right_press_active == 0)
        global.right_press = 0
    if (global.right_release_active == 0)
        global.right_release = 0
    if (global.up_check_active == 0)
        global.up_check = 0
    if (global.up_press_active == 0)
        global.up_press = 0
    if (global.up_release_active == 0)
        global.up_release = 0
    if (global.down_check_active == 0)
        global.down_check = 0
    if (global.down_press_active == 0)
        global.down_press = 0
    if (global.down_release_active == 0)
        global.down_release = 0
    if (global.jump_check_active == 0)
        global.jump_check = 0
    if (global.jump_press_active == 0)
        global.jump_press = 0
    if (global.jump_release_active == 0)
        global.jump_release = 0
    if (global.slam_check_active == 0)
        global.slam_check = 0
    if (global.slam_press_active == 0)
        global.slam_press = 0
    if (global.slam_release_active == 0)
        global.slam_release = 0
    if (global.grapple_check_active == 0)
        global.grapple_check = 0
    if (global.grapple_press_active == 0)
        global.grapple_press = 0
    if (global.grapple_release_active == 0)
        global.grapple_release = 0
    if (global.grapple_down_check_active == 0)
        global.grapple_down_check = 0
    if (global.grapple_down_press_active == 0)
        global.grapple_down_press = 0
    if (global.grapple_down_release_active == 0)
        global.grapple_down_release = 0
    if (global.pause_check_active == 0)
        global.pause_check = 0
    if (global.pause_press_active == 0)
        global.pause_press = 0
    if (global.pause_release_active == 0)
        global.pause_release = 0
    if (global.confirm_press_active == 0)
        global.confirm_press = 0
    if (global.confirm_check_active == 0)
        global.confirm_check = 0
    if (global.back_press_active == 0)
        global.back_press = 0
    if (global.back_check_active == 0)
        global.back_check = 0
	
}

function input_gamepad_draw_sprite(argument0, argument1, argument2, argument3, argument4) //gml_Script_input_gamepad_draw_sprite
{
    igds_drawX = argument0
    igds_drawY = argument1
    igds_drawXscale = argument3
    igds_drawYscale = argument4
    if (global.buttonsprite_option == 0)
        igds_drawSprite = sButtons_fullset_xbox
    if (global.buttonsprite_option == 1)
        igds_drawSprite = sButtons_fullset_ps
    if (global.buttonsprite_option == 2)
        igds_drawSprite = sButtons_fullset_switch
    if (os_type == os_switch)
        igds_drawSprite = sButtons_fullset_switch
    if on_xbox()
        igds_drawSprite = sButtons_fullset_xbox
    igds_drawImg = 0
    if (argument2 == 32769)
        igds_drawImg = 0
    if (argument2 == 32770)
        igds_drawImg = 1
    if (argument2 == 32771)
        igds_drawImg = 2
    if (argument2 == 32772)
        igds_drawImg = 3
    if (argument2 == 32773)
        igds_drawImg = 4
    if (argument2 == 32775)
        igds_drawImg = 5
    if (argument2 == 32774)
        igds_drawImg = 6
    if (argument2 == 32776)
        igds_drawImg = 7
    if (argument2 == 32777)
        igds_drawImg = 8
    if (argument2 == 32778)
        igds_drawImg = 9
    if (argument2 == 32779)
        igds_drawImg = 10
    if (argument2 == 32780)
        igds_drawImg = 11
    if (argument2 == 32781)
        igds_drawImg = 12
    if (argument2 == 32782)
        igds_drawImg = 13
    if (argument2 == 32783)
        igds_drawImg = 14
    if (argument2 == 32784)
        igds_drawImg = 15
    if (argument2 == "leftstick_up")
        igds_drawImg = 16
    if (argument2 == "leftstick_down")
        igds_drawImg = 17
    if (argument2 == "leftstick_left")
        igds_drawImg = 18
    if (argument2 == "leftstick_right")
        igds_drawImg = 19
    if (argument2 == "rightstick_up")
        igds_drawImg = 20
    if (argument2 == "rightstick_down")
        igds_drawImg = 21
    if (argument2 == "rightstick_left")
        igds_drawImg = 22
    if (argument2 == "rightstick_right")
        igds_drawImg = 23
    draw_sprite_ext(igds_drawSprite, igds_drawImg, igds_drawX, igds_drawY, igds_drawXscale, igds_drawYscale, 0, c_white, 1)
}

function input_gamepad_checkforbutton() //gml_Script_input_gamepad_checkforbutton
{
    ig_cfb_return = "none"
    if gamepad_button_check_pressed(global.gamepad, gp_face1)
        ig_cfb_return = 32769
    if gamepad_button_check_pressed(global.gamepad, gp_face2)
        ig_cfb_return = 32770
    if gamepad_button_check_pressed(global.gamepad, gp_face3)
        ig_cfb_return = 32771
    if gamepad_button_check_pressed(global.gamepad, gp_face4)
        ig_cfb_return = 32772
    if gamepad_button_check_pressed(global.gamepad, gp_shoulderl)
        ig_cfb_return = 32773
    if gamepad_button_check_pressed(global.gamepad, gp_shoulderlb)
        ig_cfb_return = 32775
    if gamepad_button_check_pressed(global.gamepad, gp_shoulderr)
        ig_cfb_return = 32774
    if gamepad_button_check_pressed(global.gamepad, gp_shoulderrb)
        ig_cfb_return = 32776
    if gamepad_button_check_pressed(global.gamepad, gp_select)
        ig_cfb_return = 32777
    if gamepad_button_check_pressed(global.gamepad, gp_start)
        ig_cfb_return = 32778
    if gamepad_button_check_pressed(global.gamepad, gp_stickl)
        ig_cfb_return = 32779
    if gamepad_button_check_pressed(global.gamepad, gp_stickr)
        ig_cfb_return = 32780
    if gamepad_button_check_pressed(global.gamepad, gp_padu)
        ig_cfb_return = 32781
    if gamepad_button_check_pressed(global.gamepad, gp_padd)
        ig_cfb_return = 32782
    if gamepad_button_check_pressed(global.gamepad, gp_padl)
        ig_cfb_return = 32783
    if gamepad_button_check_pressed(global.gamepad, gp_padr)
        ig_cfb_return = 32784
    if gamepad_stick_check_pressed(0, "up")
        ig_cfb_return = "leftstick_up"
    if gamepad_stick_check_pressed(0, "down")
        ig_cfb_return = "leftstick_down"
    if gamepad_stick_check_pressed(0, "left")
        ig_cfb_return = "leftstick_left"
    if gamepad_stick_check_pressed(0, "right")
        ig_cfb_return = "leftstick_right"
    if gamepad_stick_check_pressed(1, "up")
        ig_cfb_return = "rightstick_up"
    if gamepad_stick_check_pressed(1, "down")
        ig_cfb_return = "rightstick_down"
    if gamepad_stick_check_pressed(1, "left")
        ig_cfb_return = "rightstick_left"
    if gamepad_stick_check_pressed(1, "right")
        ig_cfb_return = "rightstick_right"
    return ig_cfb_return;
}

function input_keyboard_draw_sprite(argument0, argument1, argument2, argument3, argument4) //gml_Script_input_keyboard_draw_sprite
{
    ikds_drawX = argument0
    ikds_drawY = argument1
    ikds_drawXscale = argument3
    ikds_drawYscale = argument4
    ikds_drawSprite = sButtons_keyboard_fullset
    ikds_drawImg = 0
    if (argument2 == 65)
        ikds_drawImg = 0
    if (argument2 == 66)
        ikds_drawImg = 1
    if (argument2 == 67)
        ikds_drawImg = 2
    if (argument2 == 68)
        ikds_drawImg = 3
    if (argument2 == 69)
        ikds_drawImg = 4
    if (argument2 == 70)
        ikds_drawImg = 5
    if (argument2 == 71)
        ikds_drawImg = 6
    if (argument2 == 72)
        ikds_drawImg = 7
    if (argument2 == 73)
        ikds_drawImg = 8
    if (argument2 == 74)
        ikds_drawImg = 9
    if (argument2 == 75)
        ikds_drawImg = 10
    if (argument2 == 76)
        ikds_drawImg = 11
    if (argument2 == 77)
        ikds_drawImg = 12
    if (argument2 == 78)
        ikds_drawImg = 13
    if (argument2 == 79)
        ikds_drawImg = 14
    if (argument2 == 80)
        ikds_drawImg = 15
    if (argument2 == 81)
        ikds_drawImg = 16
    if (argument2 == 82)
        ikds_drawImg = 17
    if (argument2 == 83)
        ikds_drawImg = 18
    if (argument2 == 84)
        ikds_drawImg = 19
    if (argument2 == 85)
        ikds_drawImg = 20
    if (argument2 == 86)
        ikds_drawImg = 21
    if (argument2 == 87)
        ikds_drawImg = 22
    if (argument2 == 88)
        ikds_drawImg = 23
    if (argument2 == 89)
        ikds_drawImg = 24
    if (argument2 == 90)
        ikds_drawImg = 25
    if (argument2 == 48)
        ikds_drawImg = 26
    if (argument2 == 49)
        ikds_drawImg = 27
    if (argument2 == 50)
        ikds_drawImg = 28
    if (argument2 == 51)
        ikds_drawImg = 29
    if (argument2 == 52)
        ikds_drawImg = 30
    if (argument2 == 53)
        ikds_drawImg = 31
    if (argument2 == 54)
        ikds_drawImg = 32
    if (argument2 == 55)
        ikds_drawImg = 33
    if (argument2 == 56)
        ikds_drawImg = 34
    if (argument2 == 57)
        ikds_drawImg = 35
    if (argument2 == 38)
        ikds_drawImg = 36
    if (argument2 == 40)
        ikds_drawImg = 37
    if (argument2 == 37)
        ikds_drawImg = 38
    if (argument2 == 39)
        ikds_drawImg = 39
    if (argument2 == 32)
        ikds_drawImg = 40
    if (argument2 == 8)
        ikds_drawImg = 41
    if (argument2 == 36)
        ikds_drawImg = 43
    if (argument2 == 35)
        ikds_drawImg = 44
    if (argument2 == 46)
        ikds_drawImg = 45
    if (argument2 == 45)
        ikds_drawImg = 46
    if (argument2 == 33)
        ikds_drawImg = 47
    if (argument2 == 34)
        ikds_drawImg = 48
    if (argument2 == 19)
        ikds_drawImg = 49
    if (argument2 == 16)
        ikds_drawImg = 50
    if (argument2 == 162)
        ikds_drawImg = 51
    if (argument2 == 164)
        ikds_drawImg = 52
    if (argument2 == 16)
        ikds_drawImg = 53
    if (argument2 == 163)
        ikds_drawImg = 54
    if (argument2 == 165)
        ikds_drawImg = 55
    if (argument2 == 191)
        ikds_drawImg = 56
    if (argument2 == 106)
        ikds_drawImg = 57
    if (argument2 == 107)
        ikds_drawImg = 58
    if (argument2 == 189)
        ikds_drawImg = 59
    if (argument2 == 190)
        ikds_drawImg = 60
    if (argument2 == 190)
        ikds_drawImg = 61
    if (argument2 == 188)
        ikds_drawImg = 62
    if (argument2 == 186)
        ikds_drawImg = 64
    if (argument2 == 192)
        ikds_drawImg = 67
    if (argument2 == 189)
        ikds_drawImg = 68
    if (argument2 == 107)
        ikds_drawImg = 69
    if (argument2 == 187)
        ikds_drawImg = 70
    if (argument2 == 219)
        ikds_drawImg = 73
    if (argument2 == 221)
        ikds_drawImg = 74
    if (argument2 == 222)
        ikds_drawImg = 75
    if (argument2 == 13)
        ikds_drawImg = 77
    draw_sprite_ext(ikds_drawSprite, ikds_drawImg, ikds_drawX, ikds_drawY, ikds_drawXscale, ikds_drawYscale, 0, c_white, 1)
}

function input_keyboard_checkforbutton() //gml_Script_input_keyboard_checkforbutton
{
    ik_cfb_return = 10000
    return ik_cfb_return;
}

