// obj_player2 step

event_inherited();

if collision_circle(x,y,1, obj_danger_zone, false, false ) and !fallen{ 
		global.score_player1 += 1
	}
// Check for player 2's movement
if (keyboard_check(ord("I"))) { move_up    = true; }
if (keyboard_check(ord("J"))) { move_left  = true; }
if (keyboard_check(ord("K"))) { move_down  = true; }
if (keyboard_check(ord("L"))) { move_right = true; }


// Check for player 2's combat move
if (!hit) {//change keys
	if (keyboard_check(ord("N"))) { charge = true; }
}

// Check for player 2's defense move
if (!defend) { //change key
	if (keyboard_check(ord("M")))      { block = true; } 
}


/*
if (point_distance(x, y, obj_player1.x, obj_player1.y) <= 128 && 
		obj_hp_bar1.current_hp > 0 && !obj_player1.defend) {
	*/
	
//if player collides with an active hitbox - 
if (collision_circle(x,y,sprite_width/2, obj_hitbox_1,true,false) && obj_hitbox_1.activated
	&& obj_hp_bar2.current_hp > 0 && !obj_player2.defend){
		
		hit = true;
		hit_timer = hit_duration;
		
		if (player2 != "Archer") { // Archer damage logic in hitboxes
			obj_hp_bar2.current_hp -= obj_hitbox_1.damage
			var a_damage_indicator = instance_create_depth(x+5,y-sprite_height,-1,obj_damage_indicator);
			a_damage_indicator.damage = obj_hitbox_1.damage;
		}
		
		push_amount = regular_push_amount;
		if (charge_att){
			push_amount = large_push_amount;
		}
		//knocked back by direction of the enemys attack ? 
		move_dir = obj_player1.move_dir
		
		obj_player2.stun = true;
		obj_player2.stun_timer = stun_duration;
	}

if (push_amount >= 0) {
	var new_x = x;
	var new_y = y;
	var offset = 2;
	
	if (move_dir == 0) {
		new_x += offset; // move right
	} else if (move_dir == 45) {
		new_x += offset; // move up_right
		new_y -= offset;
	} else if (move_dir == 90) {
		new_y -= offset; // move up
	} else if (move_dir == 135) {
		new_x -= offset; // move up-left
		new_y -= offset;
	} else if (move_dir == 180) {
		new_x -= offset; // move left
	} else if (move_dir == 225) {
		new_x -= offset; // move down-left
		new_y += offset;
	} else if (move_dir == 270) {
		new_y += offset; // move down
	} else if (move_dir == 315) {
		new_x += offset; // move down-right
		new_y += offset;
	}
		
	// Check if the new position is within room bounds
	if (new_x >= left_bound && new_x <= right_bound && new_y >= upper_bound && new_y <= lower_bound) {
		x = new_x;
		y = new_y;
	}
	
	push_amount -= offset;
}

if (charge) {
	if keyboard_check_released(ord("N")) {
		charge_timer = charge_duration
		charge = false
		
		charge_slide_spd = (charge_width_curr*1.5)/60;
		if (charge_slide_spd == 0) { // Avoid X/0
			charge_slide_spd = 0.1
		}
	}else{
		charge_timer--
		
		if (charge_width_curr < charge_width_target) {
			charge_width_curr++;
			var ratio = charge_width_curr / charge_width_target;
			charge_bar_color = make_color_rgb(lerp(255, 0, ratio), lerp(0, 255, ratio), 0);
		} else { // Prevents color skip to red
			charge_width_curr = charge_width_target;
			charge_bar_color = make_color_rgb(0, 255, 0);
		}
	}
	if charge_timer <= 0 {
		charge = false
		charge_att = true
		charge_timer = charge_duration
		
		charge_width_curr = 0;
	}
	else {
		if obj_hitbox_2.attack_type != "archer" {
		charge_att = false
		}
	}
}

if (charge_width_curr > 0 && !charge) {
	charge_width_curr -= charge_slide_spd;
	if (charge_width_curr < 0) {
		charge_width_curr = 0;
	}
}