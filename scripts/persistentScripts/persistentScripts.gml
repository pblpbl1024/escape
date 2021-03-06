function checkSelected() {
	with(oButton) {
		if((oPersistent.r == r || r == span) && (oPersistent.c == c || c == span)) {
			//only change current pointer; all other selector properties will follow
			oPersistent.cur = id; break;
		}
	}
}

function updateSelector() {
	if(is_undefined(cur)) return;
	var spd = snap ? 1 : 0.12;
	selector[0] = smoothApproach(selector[0], cur.x, spd);
	selector[1] = smoothApproach(selector[1], cur.y, spd);
	selector[2] = smoothApproach(selector[2], cur.w, spd);
	selector[3] = smoothApproach(selector[3], cur.h, spd);
	vOffset = smoothApproach(vOffset, cur.vOffset, spd);
}

function updateSelectorTo() {
	for(var i = 0; i < 4; i++) oPersistent.selectorTo[i] = argument[i]; 
}

function update() {
	if(variable_instance_exists(id, "a")) {
		for(var i = 1; i <= 15; i++) {
			a[i]--;
			if(a[i] <= 0) {
				event_perform(ev_other, i+10);
			}
		}
	}
	event_perform(ev_other, ev_user0);
}

function updateLocal() {
    //updates things that can be paused (everything in game)
	part_system_update(global.ps_above);
	part_system_update(global.ps_below); 
	with(all) {
		if(object_index != oPersistent && object_index != oMenuItem && object_index != oBg) update();
	}
}

function updateGlobal() {
    //updates things that are persistent (persistent + menu stuff + background stuff)
	part_system_update(global.ps_bg);
	with(oMenuItem) update();
	with(oBg) update();
	update(); 
}

//operate on this array by reference by using the @ accessor
//take in an update function as well (upd is a function's integer reference)
//note that upd() will still be called from the original calling instance (in this case, oPersistent)
function step() {
    time[1] += time[0]; 
    if(floor(time[1]) != floor(time[1]-time[0]))
    {
    	var rem = floor(time[1]) - floor(time[1]-time[0]);
    	repeat rem {
	    	if(gameState != gs.paused && gameState != gs.optionsGame) updateLocal();
    		updateGlobal();
    	}
    }
}