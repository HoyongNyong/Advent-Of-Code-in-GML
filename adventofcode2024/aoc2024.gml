/// @description ADVENT OF CODE 2024 in GML.

//I didn't care about performance.

//DAY1 Input
function process_day1_input(){
    var buf = buffer_load("aoc2024day1.txt");
    var datas = string_split_ext(buffer_read(buf, buffer_text),["   ", "\n"]);
    buffer_delete(buf);
    
    var l_arr = [];
    var r_arr = [];
    
    for(var i = 0; i < array_length(datas); i += 2){
        if (datas[i] != ""){
            array_push(l_arr,real(datas[i]));
            array_push(r_arr,real(datas[i+1]));
        }
    }
    array_sort(l_arr, true);
    array_sort(r_arr, true);
    
    return [l_arr, r_arr];
}

//DAY1 Part One//
function day1_part_one(){
    var input = process_day1_input();
    var l_arr = input[0];
    var r_arr = input[1];
    
    var result = 0;
    for(var i = 0; i < array_length(l_arr); i += 1){
        result += abs(l_arr[i] - r_arr[i])
    }
    show_debug_message(result);
}

//DAY1 Part Two//
function day1_part_two(){    
    var input = process_day1_input();
    var l_arr = input[0];
    var r_arr = input[1];
    
    var result = 0;
    var count = 0;
    var n = array_length(l_arr);
    var l = 0, r = 0;
    while(l < n && r < n){ 
        if(l_arr[l] > r_arr[r]){
            count = 0;
            r ++;
        }else if (l_arr[l] == r_arr[r]){
            if(count == 0) {
                while(l_arr[l] == r_arr[r] && r < n) { 
                    r ++
                    count ++; 
                }
            }
            l ++;
            result += l_arr[l] * count;
        } else {
            count = 0;
            l ++;
        }
    }
    show_debug_message(result);
}

//Day2 Input
function process_day2_input(){
    var file = file_text_open_read("aoc2024day2.txt");
    var datas = [];
    while(!file_text_eof(file)){
        array_push(datas, string_split(string_trim(file_text_readln(file))," "));
    }
    file_text_close(file);
    return datas;
}

//Day2 Part One
function day2_part_one(){
    var datas = process_day2_input();
    
    var count = 0;
    for(var i = 0; i < array_length(datas); i++){
        var safe = true;
        var report = datas[i];
        var prev_sign = sign(real(report[0]) - real(report[1]));
        for(var j = 0; j < array_length(report)-1; j++){
            var diff = real(report[j]) - real(report[j+1]);
            if(diff == 0 || abs(diff) > 3 || sign(diff) != prev_sign){
                safe = false;
                break;
            }else{
                prev_sign = sign(diff);
            }
        }
        if (safe) count ++;
    }
    show_debug_message(count);
}

//Day2 Part Two
function day2_part_two(){
    var datas = process_day2_input();
    var count = 0;
    for(var i = 0; i < array_length(datas); i++){
        var report_copies = [datas[i]];
        for(var k = 0; k < array_length(datas[i]); k ++){
            var temp = [];
            for(var j = 0; j < array_length(datas[i]); j ++){
                if(j == k) continue;
                array_push(temp, datas[i][j]);
            }
            array_push(report_copies, temp);
        }
        
        for(var k = 0; k < array_length(report_copies); k ++){
            var safe = true;
            var report = report_copies[k];
            var prev_sign = sign(real(report[0]) - real(report[1]));
            
            for(var j = 0; j < array_length(report)-1; j++){
                var diff = real(report[j]) - real(report[j+1]);
                if(diff == 0 || abs(diff) > 3 || sign(diff) != prev_sign){
                    safe = false;
                    break;
                }else{
                    prev_sign = sign(diff);
                }
            }
            
            if (safe) {
                count ++;
                break;
            }
        }
    }
    show_debug_message(count);
}

//Day3 Input
function process_day3_input(){
    var buf = buffer_load("aoc2024day3.txt");
    var datas = buffer_read(buf, buffer_text);
    buffer_delete(buf);
    return datas;
}

//Day3 Part One
function day3_part_one(){
    var datas = process_day3_input();
    var result = 0;
    var cursor = 1;
    var back_cursor = 1;
    
    while(cursor != 0 && back_cursor != 0){
        cursor = string_pos_ext("mul(",datas,cursor);
        if (cursor == 0)
            break;
        cursor += 4;
        back_cursor = string_pos_ext(")", datas, cursor);
        
        if ( back_cursor - cursor > 7 ) 
            continue;
        
        var args = string_copy(datas, cursor, back_cursor-cursor);
        
        var this_mul_result = 0;
        var nums = string_split(args, ",");
        if( array_length(nums) == 2 ){
            var invalid = false;
            for(var i = 0; i < 2; i ++){
                var str_to_test = nums[i];
                if(string_length(string_digits(str_to_test)) != string_length(str_to_test)){
                    invalid = true;
                    break;
                }else{
                    nums[i] = real(str_to_test);
                }
            }
            if(invalid) {
                continue; 
            } else {
                result += nums[0] * nums[1];
            }
        }
    }
    show_debug_message(result);
}

//Day3 Part Two
function day3_part_two(){
    var datas = process_day3_input();
    var result = 0;
    var cursor = 1;
    var back_cursor = 1;

    var enable = true;
    
    while(cursor != 0 && back_cursor != 0){
        cursor = string_pos_ext("mul(",datas,cursor);
        if (cursor == 0)
            break;
        cursor += 4;
        back_cursor = string_pos_ext(")", datas, cursor);
        
        if ( back_cursor - cursor > 7) 
            continue;
        
        var dont_cursor = string_last_pos_ext("don't()", datas, cursor);
        var do_cursor = string_last_pos_ext("do()", datas, cursor)
        
        if (dont_cursor != 0 && (dont_cursor > do_cursor)) 
            continue;
        
        var args = string_copy(datas, cursor, back_cursor-cursor);
        var this_mul_result = 0;
        var nums = string_split(args, ",");
        if( array_length(nums) == 2 ){ 
            var invalid = false; 
            for(var i = 0; i < 2; i ++){ 
                var str_to_test = nums[i]; 
                if(string_length(string_digits(str_to_test)) != string_length(str_to_test)){ 
                    invalid = true; 
                    break; 
                }else{ 
                    nums[i] = real(str_to_test); 
                } 
            } 
            if(invalid) { 
                continue; 
            } else {
                show_debug_message($"{nums} with {string_copy(datas, cursor, back_cursor-cursor)}");
                result += nums[0] * nums[1];
            }
        }
    }
    show_debug_message(result);
}

//Day4 Input
function process_day4_input(){
    var buf = buffer_load("aoc2024day4.txt");
    var datas = string_trim(buffer_read(buf, buffer_text));
    buffer_delete(buf);
    return string_split(datas, "\n");
}

//Day4 Part One
function check_xmas(datas, cx, cy, w, h){
    var count = 0;
    var check_char = ["M", "A", "S"];
    
    for(var i = 0; i < 8; i ++){
        var check = true;
        var dx = round(cos(pi*i/4));
        var dy = round(sin(pi*i/4));
        
        for(var j = 1; j < 4; j ++){
            var nx = cx + j*dx;
            var ny = cy + j*dy;
            
            if (nx < 1 || ny < 0 || nx > w || ny >= h || string_char_at(datas[ny], nx) != check_char[j-1]) {
                check = false;
                break;
            }
        }
        if (check)
            count ++;
    }
    return count;
}

function day4_part_one(){
    var datas = process_day4_input();
    var height = array_length(datas);
    
    var result = 0;
    for(var i = 0; i < height; i ++){
        var row = datas[i];
        var width = string_length(row);
        for(var j = 0; j < width; j ++){
            if (string_char_at(row, j+1) == "X"){
                result += check_xmas(datas, j+1, i, width, height);
            }
        }
    }
    
    show_debug_message(result);
}

//Day4 Part Two
function check_x_shaped_mas(datas, cx, cy, w, h){
    var check_char = [];
    //Gamemaker String sucks. why it begins from 1.
    if (cx < 2 || cy < 1 || cx > w-1 || cy >= h-1) {
        return 0;
    }
    
    for(var i = 1; i < 8; i += 2){
        var check = true;
        var nx = cx + round(cos(pi*i/4));
        var ny = cy + round(sin(pi*i/4));
        
        var cur_char = string_char_at(datas[ny], nx);
        if (cur_char == "X" || cur_char == "A") {
            return 0;
        }
        if (i >= 5){
            if ( cur_char != array_shift(check_char) )
                return 0;
        }else{
            if (cur_char == "M") array_push(check_char, "S"); 
            if (cur_char == "S") array_push(check_char, "M");
        }
    }
    return 1;
}

function day4_part_two(){
    var datas = process_day4_input();
    var height = array_length(datas);
    
    var result = 0;
    for(var i = 0; i < height; i ++){
        var row = datas[i];
        var width = string_length(row);
        for(var j = 0; j < width; j ++){
            if (string_char_at(row, j+1) == "A"){
                result += check_x_shaped_mas(datas, j+1, i, width, height);
            }
        }
    }
    show_debug_message(result);
}

//Day5 Input
function process_day5_input(){
    var buf = buffer_load("aoc2024day5.txt");
    var datas = string_trim(buffer_read(buf, buffer_text));
    buffer_delete(buf);
    
    var section = string_split(datas, "\n\n");
    var page_rules = string_split(section[0], "\n");
    var page_inputs = string_split(section[1], "\n");
    
    return [page_rules, page_inputs];
}

//Day5 Part One
function day5_part_one(){
    var section = process_day5_input();
    var page_rules = section[0];
    var page_inputs = section[1];
    
    var pages = {};
    //construct rules
    for(var i = 0; i < array_length(page_rules); i ++){
        var rule = string_split(page_rules[i], "|");
        var front = rule[0];
        var back = rule[1];
        
        if ( !struct_exists(pages, back) ){
            struct_set(pages, back, [front]);
        }else{
            var arr = struct_get(pages, back);
            array_push(arr, front);
        }
    }
    
    var result = 0;
    for(var i = 0; i < array_length(page_inputs); i ++){
        var valid = true;
        var page_datas = string_split(page_inputs[i], ",");
        var page_datas_n = array_length(page_datas);
        for(var j = 0; j < page_datas_n; j ++){
            if(!struct_exists(pages, page_datas[j])) continue;
            var rule = pages[$ page_datas[j]];
            for(var k = j; k < page_datas_n; k ++){
                if(array_contains(rule, page_datas[k])){
                    valid = false;
                    break;
                }
            }
            if (!valid) break;
        }
        if (valid){ 
            result += page_datas[page_datas_n div 2];
        }
    }
    show_debug_message(result);
}
//Day5 Part Two
function day5_part_two() {
    var section = process_day5_input();
    var page_rules = section[0];
    var page_inputs = section[1];
    
    var pages = {};
    //construct rules
    for(var i = 0; i < array_length(page_rules); i ++){
        var rule = string_split(page_rules[i], "|");
        var front = rule[0];
        var back = rule[1];
        
        if ( !struct_exists(pages, back) ){
            struct_set(pages, back, [front]);
        }else{
            var arr = struct_get(pages, back);
            array_push(arr, front);
        }
    }
    
    var result = 0;
    for(var i = 0; i < array_length(page_inputs); i ++){
        var valid = true;
        var correctable = true;
        var page_datas = string_split(page_inputs[i], ",");
        var page_datas_n = array_length(page_datas);
        for(var j = 0; j < page_datas_n; j ++){
            var cur_page = page_datas[j];
            var corrected = false;
            for(var k = j; k < page_datas_n; k ++){
                if(!struct_exists(pages, page_datas[j])) continue;
                if (corrected && page_datas[j] == cur_page) {
                    correctable = false;
                    break;
                }
                if(array_contains(pages[$ page_datas[j]], page_datas[k])){
                    var temp = page_datas[j];
                    page_datas[j] = page_datas[k];
                    page_datas[k] = temp;
                    valid = false;
                    corrected = true;
                    k = j;
                }
            }
        }
        if (!valid && correctable){
            result += page_datas[page_datas_n div 2];
        }
    }
    show_debug_message(result);
}

//Day6 Input
function process_day6_input(){
    var buf = buffer_load("aoc2024day6.txt");
    var datas = string_trim(buffer_read(buf, buffer_text));
    buffer_delete(buf);
    
    var map = string_split(datas, "\n");
    var yy = 0;
    var xx = 0;
    
    while(xx == 0 && yy < array_length(map)){
        xx = string_pos("^", map[yy++]);
    }
    
    return [xx, yy-1, map];
}

//Day6 Part One    note : ans 5131. ref it when refactoring.
function day6_part_one(){
    var datas = process_day6_input();
    var map = datas[2];
    var guard_x = datas[0]; //in gamemaker string pos.
    var guard_y = datas[1]; //in gamemaker array index.
    var dirs = [0, -1, 1, 0, 0, 1, -1, 0];
    var dir = 0;
    var count = 0;
    while(true){
        var cur_map_element = string_char_at(map[guard_y], guard_x);
        if(cur_map_element == "." || cur_map_element == "^"){
            map[guard_y] = string_insert("X", string_delete(map[guard_y], guard_x, 1), guard_x);
            count ++;
        }
    
        var nx = guard_x + dirs[dir];
        var ny = guard_y + dirs[dir+1];
        
        if( 
            nx < 1 || ny < 0 || 
            ny >= array_length(map) || nx > string_length(map[ny]) 
        ) {
            break;
        }
        
        var next_map_element = string_char_at(map[ny], nx);
        if(next_map_element == "#"){
            dir = (dir + 2) mod 8;
        }else{guard_x = nx; guard_y = ny;}
    }
    
    for(var i = 0; i < array_length(map); i ++)
        show_debug_message(map[i]);
    show_debug_message(count);
}

//Day6 Part Two
function day6_part_two_brute_force1(){    
    var datas = process_day6_input();
    var count = 0;
    var dirs = [0, -1, 1, 0, 0, 1, -1, 0];
    
    //I don't like this brute force approach. it's too slow.
    //It might be Improved : place a new obtacle on pre-calculated path exclusively, it will be faster than this.
    for(var i = 0; i < array_length(datas[2]); i ++){
        for(var j = 1; j <= string_length(datas[2][0]); j ++) {
            var map = array_filter(datas[2], function(){ return true });
            if ( string_char_at(map[i], j) != "." ) {continue;}
            map[i] = string_insert("#", string_delete(map[i], j, 1), j);
            
            var guard_x = datas[0]; //in gamemaker string pos.
            var guard_y = datas[1]; //in gamemaker array index.
            var dir = 0;
            
            while(true){
                var cur_map_element = string_char_at(map[guard_y], guard_x);
                
                if(cur_map_element == $"{dir}"){
                    count ++;
                    break;
                }
                
                var nx = guard_x + dirs[dir];
                var ny = guard_y + dirs[dir+1];
                
                if( 
                    nx < 1 || ny < 0 || 
                    ny >= array_length(map) || nx > string_length(map[ny]) 
                ) {
                    break;
                }
                
                var next_map_element = string_char_at(map[ny], nx);
                if(next_map_element == "#"){
                    if(cur_map_element == "." || cur_map_element == "^"){
                        map[guard_y] = string_insert($"{dir}", string_delete(map[guard_y], guard_x, 1), guard_x);
                    }
                    dir = (dir + 2) mod 8;
                }else{guard_x = nx; guard_y = ny;}
            }            
        }
    }
    
    show_debug_message(count);
}

//Day6 Part Two - brute force improved. bit better, but still slow.
function day6_part_two_brute_force2(){ 
    var datas = process_day6_input();
    var count = 0;
    var dirs = [0, -1, 1, 0, 0, 1, -1, 0];
    
    var map = array_filter(datas[2], function(){ return true });
    var guard_x = datas[0]; //in gamemaker string pos.
    var guard_y = datas[1]; //in gamemaker array index.
    var dir = 0;
    var path_array = [];
    while(true){
        var cur_map_element = string_char_at(map[guard_y], guard_x);
        if(cur_map_element == "." || cur_map_element == "^"){
            map[guard_y] = string_insert("X", string_delete(map[guard_y], guard_x, 1), guard_x);
            array_push(path_array, dir, guard_x, guard_y);
        }
    
        var nx = guard_x + dirs[dir];
        var ny = guard_y + dirs[dir+1];
        
        if( 
            nx < 1 || ny < 0 || 
            ny >= array_length(map) || nx > string_length(map[ny]) 
        ) {
            break;
        }
        
        var next_map_element = string_char_at(map[ny], nx);
        if(next_map_element == "#"){
            dir = (dir + 2) mod 8;
        }else{guard_x = nx; guard_y = ny;}
    }
    
    for(var i = 0; i < array_length(path_array); i += 3){
        map = array_filter(datas[2], function(){ return true });
        
        var place_x = path_array[i+1];
        var place_y = path_array[i+2];
        
        if ( string_char_at(map[place_y], place_x) != "." ) {continue;}
        map[place_y] = string_insert("#", string_delete(map[place_y], place_x, 1), place_x);
        
        guard_x = datas[0]; //in gamemaker string pos.
        guard_y = datas[1]; //in gamemaker array index.
        dir = 0;
        
        while(true){
            var cur_map_element = string_char_at(map[guard_y], guard_x);
            
            var nx = guard_x + dirs[dir];
            var ny = guard_y + dirs[dir+1];
            
            if( 
                nx < 1 || ny < 0 || 
                ny >= array_length(map) || nx > string_length(map[ny]) 
            ) {
                break;
            }
            
            var next_map_element = string_char_at(map[ny], nx);
            if(next_map_element == "#"){
                if(cur_map_element == "." || cur_map_element == "^"){
                    map[guard_y] = string_insert($"{dir}", string_delete(map[guard_y], guard_x, 1), guard_x);
                }else if(cur_map_element == $"{dir}"){
                    count ++;
                    break;
                }
                dir = (dir + 2) mod 8;
            }else{guard_x = nx; guard_y = ny;}
        }             
    }
    
    show_debug_message(count);
}

day6_part_two_brute_force2();

