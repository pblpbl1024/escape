cannonState = (cannonState + 1) % 3;
if(cannonState == 2) { audio_play_sound(aLaser, 0, false); image_index = 1; }
else image_index = 0;
alarms[1] = delay;