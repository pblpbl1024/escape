/// @description handle state
cameraOffset = smoothApproach(cameraOffset, hsp*100, 0.006);
//get input
if(!dead) {
	if(canMove) checkInput();
	checkEnemy();
}

var right = input[in.right] || input[in.keyD];
var left = input[in.left] || input[in.keyA];
dir = right-left;

jump = input2[in.up] || input2[in.keyW] || input2[in.space];

jumpHeld = input[in.up] || input[in.keyW] || input[in.space];
dash = input[in.shift];
down = input[in.down] || input[in.keyS];

//if we're in freecam mode, cancel all inputs and only care about dir
//to control the game's camera
if(freecam) {
	//oGame.targetX = clamp(oGame.targetX + 6*dir, oGame.leftBoundary, oGame.rightBoundary);
	
	//free camera movement 
	oGame.targetX += 6*dir; oGame.targetY += 6*(input[in.down]-input[in.up]);
	
	dir = 0; jump = false; jumpHeld = false; dash = false; down = false;
}

//check if you're grabbing onto any walls
if(place_meeting(x+1, y, oGround)) grip = 1;
else if(place_meeting(x-1, y, oGround)) grip = -1;
else grip = 0;

cameraOffset = smoothApproach(cameraOffset, hsp*100, 0.008);
switch(state)
{
	case "ground": 
		//only allow freecam if the player is actually on solid ground
		if(input2[in.enter] && place_meeting(x, y+1, oGround)) {
			freecam = !freecam;
			if(freecam) snd(aCamOn);
			else snd(aCamOff);
		}
		boosted = false;
		khsp = 0;
		updateHsp(walkAcc, walkAcc/8);
		if(jump || jumpTimer) { 
			vsp = -jumpSpd; state = "jump"; snd(aJump); 
			event_perform(ev_other, ev_user3); 
		}
		if(!place_meeting(x, y+1, oGround) && !place_meeting(x, y+1, oPlatform)) {
			state = "jump"; a[2] = bufferTime;	
		}
	break;
	case "jump":
		//special check to cancel wallkick speed if you started to move in the other direction and released the key
		checkReleasedWallKick();
		khsp = approach(khsp, 0, fric);
		updateHsp(airAcc, airAcc/2); 
		updateVsp();
		if(jump || boostTimer)
		{
			if(grip != 0) {
				vsp = -jumpSpd;	khsp = wallKickSpd*-grip; snd(aJump); state = "djump"; boosted = false;
			} else {
				vsp = -jumpSpd;	snd(aJump); boosted = false;
				if(a[2] != infinity) a[2] = infinity; else state = "djump";
			}
			event_perform(ev_other, ev_user4);
		}
		if((place_meeting(x, y+1, oGround) || place_meeting(x, y+1, oPlatform)) && vsp >= 0) { state = "ground"; }
	break;
	case "djump":
		checkReleasedWallKick();
		khsp = approach(khsp, 0, fric);
		updateVsp();
		updateHsp(airAcc, airAcc/2); 
		if(jump || boostTimer)
		{
			if(grip != 0) {
				vsp = -jumpSpd;	khsp = wallKickSpd*-grip; snd(aJump); boosted = false;
			} else {
				//jump buffer (like geometry dash)
				jumpTimer = true; a[3] = jumpBuffer;	
			}
			event_perform(ev_other, ev_user4);
		}
		if((place_meeting(x, y+1, oGround) || place_meeting(x, y+1, oPlatform)) && vsp >= 0) { state = "ground"; }
	break;
	case "boosted":
		//boosted state for when you hit a jump powerup
		//you can't jump until you reach a certain vsp threshold (i.e. when you aren't moving as quick anymore)
		checkReleasedWallKick();
		khsp = approach(khsp, 0, fric);
		updateVsp();
		updateHsp(airAcc, airAcc/2); 
		if(jump) {
			boostTimer = true; a[4] = jumpBuffer;
		}
		//renew the jump i guess
		if(vsp >= -jumpSpd) { state = "jump"; }
	break;
}	

//falling platform check
if(vsp >= 0) pCollision(); else phsp = 0;

//check collision
if(!dead) {
	hCollision(); vCollision();
}
clearPressed(); clearReleased();