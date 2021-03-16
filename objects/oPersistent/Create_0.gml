randomize();
h = window_get_height();
window_set_size(h/3*4, h/4*3);
t = 0;

inputKeys = array(vk_left, vk_right, vk_up, vk_down, 
	ord("W"), ord("A"), ord("S"), ord("D"), 
	vk_space, vk_shift);
	
inputKeys2 = array(vk_left, vk_right, vk_up, vk_down, 
	ord("W"), ord("A"), ord("S"), ord("D"), 
	vk_space, vk_enter, vk_escape);

//inputs: keyDown, inputs2: keyPressed
global.inputs = ds_map_create();
global.inputs2 = ds_map_create();

//load data
//if it's undefined, initialize default values
fileName = "data.sav";
data = ds_map_create();
if(file_exists(fileName)) {
	ds_map_destroy(data); 
	data = ds_map_secure_load("data.sav");
}
else init();
keys = ds_map_keys_to_array(data);
values = ds_map_values_to_array(data);
show_debug_message(keys);
//read in values in an array so that it can be used in the draw event
if(ds_map_find_value(data, "fs")) window_set_fullscreen(true);

//this enum assigns numbers to values 
//gs.menu = 0, gs.game = 1, and so on
//menu -> (select, options)
//paused -> options2

a = array_create(16, infinity);

enum gs {
	menu, game, select, options, paused, optionsGame
}
gameState = gs.menu;

//parent array: p[i] represents what screen to go back to (-1 if root)
parent = array(-1, -1, gs.menu, gs.menu, -1, gs.paused);
//row[i], col[i] = number of rows and columns for each menu state
row = array(4, 0, 5, 5, 3, 5);
col = array(1, 0, 8, 1, 1, 1);

//grid variables (with backtracking)
//tr, tc = row, col after transition
//pr, pc = previous row, previous col which will be used when u press escape
r = 0; c = 0; pr = 0; pc = 0; tr = 0; tc = 0;

//rectangle selector location (by default, it's at the 'Play' button)
//relative location (upon draw, add by vx and vy)
//to lerp these values, two arrays are required
selectorFrom = {
	xpos: 0, ypos: 0, w: 0, h: 0
}
selectorTo = {
	xpos: 0, ypos: 0, w: 0, h: 0
}

//snap: whether the rectangle will instantly snap to the
//current button selected upon draw
//pressing any arrow key will disable snap
snap = true; 
//delay for inputs
inputDelay = 15;

//transition data
state = 0; alpha = 1;
destState = -1;
canInteract = false; 
//for buttons which take up multiple rows
horizontal = true;

//enable interacting and disable snap
a[4] = inputDelay;

//titles
titles = array("Escape", "", "Level Select", "Options", "Game Paused", "Options");
menuTitles = array(ds_map_find_value(data, "lvl") > 1 ? "Continue" : "Play", "Level Select", "Options", "Quit");

global.timeFactor = 1; gameTimer = 0;

a[1] = 1; a[3] = random_range(30, 40);

global.ps_above = part_system_create();
part_system_depth(global.ps_above, layer_get_depth("Above"));
global.ps_below = part_system_create();
part_system_depth(global.ps_below, layer_get_depth("Below"));
part_system_automatic_update(global.ps_above, false);
part_system_automatic_update(global.ps_below, false);

//volume control (map which tracks default gain of audio)
vol = ds_map_create();
ds_map_add(vol, aMusic, audio_sound_get_gain(aMusic));

audio_sound_gain(aMusic, 0, 0);
audio_play_sound(aMusic, 0, true);