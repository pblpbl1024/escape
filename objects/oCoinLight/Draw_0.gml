/// @description draw coin/gem glow
gpu_set_blendmode(bm_add);
with(oCoin) draw_sprite_ext(sSphere, 0, x, y, 0.4, 0.4, 0, c_yellow, 1); 
with(oGem) draw_sprite_ext(sSphere, 0, x, y, 1.2, 1.2, 0, c_green, 1); 
with(oGemOrange) {
    if(state == 0) draw_sprite_ext(sSphere, 0, x, y, 1.2, 1.2, 0, c_orange, 1); 
}
gpu_set_blendmode(bm_normal);

with(oCoin) draw_self();
with(oGem) draw_self();
with(oGemOrange) { if(state == 0) draw_self(); }