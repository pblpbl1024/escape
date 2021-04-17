walkSpd = 3.6; 
runSpd = 5.4;
jumpSpd = 6.4;
walkAcc = 3;
airAcc = 0.4;
bufferTime = 15;
jumpError = 20;
cameraOffset = 0;
boosted = false;
phsp = 0;

//input variables
dir = 1;
jump = false;
jumpHeld = false;
dash = false;
down = false;
grip = false;

hsp = 0;
vsp = 0;
khsp = 0;
fric = 0.04;
wallKickSpd = 5;

//jumptimer for when you're pressing jump as you're falling 
jumpTimer = false;
jumpBuffer = 15;

//boost timer for when you're pressing jump as you're still in boost mode
boostTimer = false;

//state = "ground", "buffer", "jump", "fall", "blink"
state = "ground";

//death variable so that the player never gets destroyed
dead = false;

//freecam
freecam = false;

a = array_create(16, infinity);
//disable movement for a bit
canMove = false;
a[1] = inputDelay;

input = array_create(in.length);
input2 = array_create(in.length);

//update the view instantly
camera_set_view_pos(view_camera[0], clamp(oPlayer.x - vw/2 + oPlayer.cameraOffset, 0, room_width-vw), clamp(floor(oPlayer.y/vh)*vh, 0, room_height/vh-1));
//increase attempts
oPersistent.attempts++;