//general purpose transition function that switches gamestate or the current room with a transition 
//specify landing coordinates as well (leave blank for (0, 0))
//leave newSong blank for no change in song, or set newSong = -1 to stop the current song
/// @param newState
/// @param [newRow=0] (set r, c = -1 for the previous row + column; this stack is cleared whenever the room changes/is restarted)
/// @param [newCol=0]
/// @param [newRoom] (leave blank for no change in room, otherwise it will always go to the new room even if it's the same one) 
/// @param [newSong] (leave blank to avoid switching the song, or -1 to stop playing the song) 
function transitionTo(newState, newRow, newCol, newRoom, newSong) {
	//note: argument_count won't be accurate if you're including all the arguments in the function ^
	//use the undefined check
	if(is_undefined(newRow) && is_undefined(newCol)) { newRow = 0; newCol = 0; } 
	
	if(newRow == -1 && newCol == -1) {
		tr = ds_stack_pop(pr); tc = ds_stack_pop(pc); 
	} else { 
		ds_stack_push(pr, r); ds_stack_push(pc, c); tr = newRow; tc = newCol; 
	}
	canInteract = false; 
	if(is_undefined(newRoom)) {
		state = 1; destState = newState;
	} else {
		//every new room transition will automatically clear the previous row/col stack 
		state = 3; destState = newState; destRoom = newRoom;
		ds_stack_clear(pr); ds_stack_clear(pc);
	}
	if(!is_undefined(newSong)) {
		stopMusic(); if(newSong != -1) destSong = newSong;
	}
}

//teleport to a new state without transition e.g. going from gs.game to gs.paused
//this will also clear the history
function teleportTo(newState) {
	r = 0; c = 0; ds_stack_clear(pr); ds_stack_clear(pc); 
	canInteract = false; snap = true; a[4] = inputDelay;
	with(oMenuItem) instance_destroy(); cur = undefined;
	gameState = newState; loadMenu(gameState);
}

function changeCursor(dr, dc) {
	//log(object_get_name(object_index));
	r = (r+dr+maxRow[gameState]) % maxRow[gameState];
	c = (c+dc+maxCol[gameState]) % maxCol[gameState];	
	//only update the pointer to the current menu item, all selector variables will follow
	cur = itemIDs[#r, c];
}
