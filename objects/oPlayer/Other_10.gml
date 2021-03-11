cameraOffset = smooth_approach(cameraOffset, hsp*100, 0.008);
if(y-30 > room_height) death();
alpha = approach(alpha, imgAlpha, 0.05);
if(place_meeting(x, y, oRespawn))
{
	var r = instance_nearest(x, y, oRespawn);
	oGame.respawn = r;
}
var dir = keyboard_check(vk_right) - keyboard_check(vk_left);
khsp = approach(khsp, 0, fric);
kvsp = approach(kvsp, 0, fric);
if(isAttacking) swingSword();
switch(state)
{
	case "ground": 
		if(keyboard_check(vk_shift)) hsp = approach(hsp, (sprintSpd-abs(khsp)*3/4)*dir, runAcc);
		else hsp = approach(hsp, (moveSpd-abs(khsp)*3/4)*dir, runAcc);
		collision();
		if(jump)
		{
			vsp = -jumpSpd;	audio_play_sound(aJump, 0, false); state = "jump"; 
		}
		if(!place_meeting(x, y+1, oGround)) {
			state = "buffer"; alarms[1] = bufferTime;	
		}
		checkBlink();
		checkAttack();
		checkEnemy();
	break;
	case "jump":
		if(keyboard_check(vk_shift)) hsp = approach(hsp, (sprintSpd-abs(khsp)*3/4)*dir, airAcc/2);
		else hsp = approach(hsp, (moveSpd-abs(khsp)*3/4)*dir, airAcc);
		applyGrav();
		collision();
		if(jump)
		{
			if(place_meeting(x, y+jumpPixels, oGround))
			{	
				vsp = -jumpSpd;	audio_play_sound(aJump, 0, false); 
			}
			else if(place_meeting(x+1, y, oGround))
			{
				vsp = -jumpSpd;	khsp = -wallKickSpd; audio_play_sound(aJump, 0, false); state = "fall";
			}
			else if(place_meeting(x-1, y, oGround))
			{
				vsp = -jumpSpd;	khsp = wallKickSpd; audio_play_sound(aJump, 0, false); state = "fall";
			}
			else
			{
				vsp = -jumpSpd;	audio_play_sound(aJump, 0, false); state = "fall";
			}
		}
		if(place_meeting(x, y+1, oGround)) { state = "ground"; }
		checkBlink();
		checkAttack();
		checkEnemy();
	break;
	case "buffer": 
		if(keyboard_check(vk_shift)) hsp = approach(hsp, (sprintSpd-abs(khsp)*3/4)*dir, airAcc/2);
		else hsp = approach(hsp, (moveSpd-abs(khsp)*3/4)*dir, airAcc);
		applyGrav();
		collision();
		if(jump)
		{
			vsp = -jumpSpd;	audio_play_sound(aJump, 0, false); state = "jump"; alarms[1] = infinity;
		}
		if(place_meeting(x, y+1, oGround)) { state = "ground"; alarms[1] = infinity; }
		checkBlink();
		checkAttack();
		checkEnemy();
	break;
	case "fall":
		if(keyboard_check(vk_shift)) hsp = approach(hsp, (sprintSpd-abs(khsp)*3/4)*dir, airAcc/2);
		else hsp = approach(hsp, (moveSpd-abs(khsp)*3/4)*dir, airAcc);
		applyGrav();
		collision();
		if(jump)
		{
			if(place_meeting(x, y+jumpPixels, oGround))
			{
				vsp = -jumpSpd;	audio_play_sound(aJump, 0, false); state = "jump";
			}
			else if(place_meeting(x+1, y, oGround))
			{
				vsp = -jumpSpd;	khsp = -wallKickSpd; audio_play_sound(aJump, 0, false); //state = "jump";
			}
			else if(place_meeting(x-1, y, oGround))
			{
				vsp = -jumpSpd;	khsp = wallKickSpd; audio_play_sound(aJump, 0, false); //state = "jump";
			}
		}
		if(place_meeting(x, y+1, oGround)) { state = "ground"; }
		checkBlink();
		checkAttack();
		checkEnemy();
	break;
	
	case "blink": 
	smoke(c_white);//effect_create_above(ef_smoke, x, y, 0, c_white);
	collision();
	if(place_meeting(x-1, y, oGround) || place_meeting(x+1, y, oGround) || 
		place_meeting(x, y-1, oGround) || place_meeting(x, y+1, oGround))
		{
			ring(c_white); vsp *= 5/6; hsp /= 2;
			imgAlpha = 1;
			state = "jump"; alarms[2] = infinity; 
		}
	break;
}

if(prevState != state)
{
	show_debug_message("state change");
}

//reset stuff
prevState = state;
jump = false;
lmb = false;
rmb = false;

if(keyboard_check_pressed(vk_enter)) 
{
	var e = part_type_create();
	part_type_shape(e, pt_shape_sphere);
	part_type_alpha2(e, 1, 0);
	part_type_life(e, 240, 240);
	part_type_size(e, 1, 1, -0.001, 0);
	part_type_blend(e, true);
	part_particles_create(global.ps_below, x, y-100, e, 1);
}