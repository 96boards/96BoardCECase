/*
 *      96BoardsCase.scad
 *
 *      Copyright (c) 2015 David Mandala <david.mandala@linaro.org
 *
 ***********************************************************************
 *
 * This scad file is free software; you can redistribute it
 * and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2 of the
 * License.
 * 
 * This OpenSCAD file is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 ***********************************************************************
 *
 * Note with smoothness > 20 - 100 it can take quite some time to render (F6) 
 * this is totally normal, about 2.5 minutes when smoothness == 50.  
 * It's not broken, just the quality takes time to realize
 *
 */
use <MCAD/boxes.scad>

// Square edge case or rounded edge case?
rounded_case = true;
// Only the retangle of the case rounded (sides) or all angles (top, bottom, sides)  
only_retangle_rounded = false;

// How thick do you want your case walls(in mm)
// Be careful if you are setting rounded_case true, too thin of walls will leave holes
// Don't go to thick (much over 2.5) or you will have problems plugging in cables
case_wall_thickness = 2.5;

// Extended board or reqular true/false question
96Boards_CE_extended_version = false;

// Do you hvave a UART board and want room to install it in the case?
96Board_UART_Board_Installed = true;

// The UART board has a reset button, if you want to be able to press it true
expose_UART_Board_Button = true;

// expose the low/high speed connectors or not true/false question
expose_low_speed_connector = true;
expose_high_speed_connector = false;
expose_DragonBoardDipSwitch = true;

// Do I want screw holes through the case? true/false question
screw_holes = true;
// Do I only want screw holes on the top of the case and no nuts on the botton, can thread screws into the standoffs --- Need to add code for this
screw_holes_top_only = false;
// Do I want nut holes on the bottom 
screw_terminator = true;

// For exporting .stl models, this will cut the model in 1/2 at the board top level.
// The board will fit into the bottom of the case cleanly and the top will sit on it
slice = true;
// top of the box or bottom 
slice_top = false;

// How round do you want holes  the higer it set to the longer it takes to render
smoothness = 50; //10-100

// For development only do you want to see the full case, the full diff model or the bare board model can help when adding new case type
// Set true for final case, false shows you the board and screw layout
case = true;
96BoardBlock = false;

// UART Board dimensions
uart_board_length = 41.00;
uart_board_width = 14.30;
uart_board_total_thickness = 12.00;
uart_board_top_surface = 14.2;
uart_board_connector_length = 8;
uart_board_connector_width = 5.68;
uart_board_connector_thickness = 2.65;
uart_board_button_x_offset = 44.00;
uart_board_button_center_y_offset = 44.00;
uart_board_button_length = 3.5;
uart_board_button_width = 3.5;

// Component dimensions
usb_host_length = 14.24;
usb_host_width = 14.25;
usb_host_thickness = 7;

usb_otg_length = 8;
usb_otg_width = 5.68;
usb_otg_thickness = 2.65;

hdmi_length = 15.20;
hdmi_width = 9.20;
hdmi_thickness = 6;

microSD_length = 15.00;
microSD_width = 15.00;
microSD_thickness = 1.30;

DC_pwr_length = 8.00;
DC_pwr_width = 12.50;
DC_pwr_thickness = 6;

low_speed_connector_length = 44.00;
low_speed_connector_width = 7.0;
low_speed_connector_thickness = 4.6;

high_speed_connector_length = 32.00;
high_speed_connector_width = 7.50;

DragonBoardDipSwitch_width = 6.30;
DragonBoardDipSwitch_length = 5.80;
DragonBoardDipSwitch_offset = 4.82;
DragonBoardDipSwitch_y_offset = 5.75;
DragonBoardDipSwitch_z_offset = -3.5;

// Safe cutout distance.  Things that cut holes must extand past the edge it's cutting
cutout = .5;

// All board measurements and offsets set by 96Boards CE specification
// Do not change.
// All measurements are from lower left corner by microSD area.
board_width_reg = 54.00;
board_width_ext = 100.00;
CE_spec_tolerance = 0.30;
board_length = 85.00;
total_thickness = 12;
board_thickness = 1.6;
board_top_clearence = 7;
// Some of the USB connectors take up too much room so add extra room if needed
// The first version of the HiKey the USB connectors were 7.46 high
board_top_clearence_extra_tolerance = .46;   
board_bottom_clearence = 3.4;
board_top_surface =5;
board_front_edge = 0;
// How wide is the board, normal or extended
bd_width = (96Boards_CE_extended_version == true?board_width_ext:board_width_reg);
// How tall is the board, normal or extended for the UART board?
bd_total_thickness = (96Board_UART_Board_Installed == false)?total_thickness:total_thickness+(uart_board_total_thickness-(board_top_clearence-low_speed_connector_thickness));
bd_top_clearence = (96Board_UART_Board_Installed == false)?board_top_clearence+board_top_clearence_extra_tolerance+CE_spec_tolerance:board_top_clearence+board_top_clearence_extra_tolerance+CE_spec_tolerance+(uart_board_total_thickness - (board_top_clearence-low_speed_connector_thickness));
bd_bottom_clearence = board_bottom_clearence+CE_spec_tolerance;
board_back_edge = bd_width - 1;

usb_host1_offset = 76.00;
usb_host2_offset = 56.60;
usb_otg3_offset = 41.60;
hdmi_offset = 25.00;
microSD_offset = 8;
DC_pwr_offset = 71.5;
uart_board_connector_offset = 14.00;

low_speed_connector_center_offset = 50.00;
low_speed_connector_pin_1_offset = 10.00;
low_speed_connector_left_offset = 8.00;

high_speed_connector_center_offset = 15.45;
high_speed_connector_pin_1_offset = 20.00;
high_speed_connector_left_offset = 17.00;

mount_hole_1_x = 4.00;
mount_hole_1_y = 18.50;
mount_hole_2_x = 81.00;
mount_hole_2_y = 18.50;
mount_hole_3_x = 4.00;
mount_hole_3_y = 50.00;
mount_hole_4_x = 81.00;
mount_hole_4_y = 50.00;
// Extended case mounting holes
mount_hole_5_x = 4.00;
mount_hole_5_y = 96.00;
mount_hole_6_x = 81.00;
mount_hole_6_y = 96.00;

// Need this to be oversized as holes are undsized
hole_size = 2.8;
hole_keepout = 4.5;

// Nuts and Screws to close the case
screw_head = 3.38;
screw_taper = true;
screw_taper_height = 1;
//screw_terminator for a nut how many sides
nut_type = 6;
// How tall is the nut
nut_hight = 1.65;
// from edge to edge
nut_size = 4.00;

// Modules
module slice_top(){
    translate([-1 * (cutout/2),-1 * (cutout/2),case_wall_thickness+board_top_surface-.001])
    cube([board_length+CE_spec_tolerance+(case_wall_thickness*2)+cutout, bd_width+CE_spec_tolerance+(case_wall_thickness*2)+cutout,case_wall_thickness+bd_top_clearence+cutout]);
}
module slice_bottom(){
    translate([-1 * (cutout/2),-1 * (cutout/2),-1 * cutout])
    // Something is slightly wrong here, had to add .001 to the size of the cube to cut everything as needed.  Rounding error?
    // Should not need the extra .001
    cube([board_length+CE_spec_tolerance+(case_wall_thickness*2)+cutout, bd_width+CE_spec_tolerance+(case_wall_thickness*2)+cutout,case_wall_thickness+board_top_surface+cutout+.001]);
}

module 96BoardStandoffMounts(){
    mount_cylinder(mount_hole_1_x+(CE_spec_tolerance/2),mount_hole_1_y+(CE_spec_tolerance/2),0, hole_keepout, false);
    mount_cylinder(mount_hole_2_x+(CE_spec_tolerance/2),mount_hole_2_y+(CE_spec_tolerance/2),0, hole_keepout, false);
    mount_cylinder(mount_hole_3_x+(CE_spec_tolerance/2),mount_hole_3_y+(CE_spec_tolerance/2),0, hole_keepout, false);
    mount_cylinder(mount_hole_4_x+(CE_spec_tolerance/2),mount_hole_4_y+(CE_spec_tolerance/2),0, hole_keepout, false);
    if (96Boards_CE_extended_version == true){
        mount_cylinder(mount_hole_5_x+(CE_spec_tolerance/2),mount_hole_5_y+(CE_spec_tolerance/2),0, hole_keepout, false);
        mount_cylinder(mount_hole_6_x+(CE_spec_tolerance/2),mount_hole_6_y+(CE_spec_tolerance/2),0, hole_keepout, false);
    }
}
// The way this works is we stick out what we want to diff away
module face_penetration(x_location, length, width , thickness, y_location, z_location, center){
    // Since this makes a model to diff from the external case have to add extra length to fully penatrate
    // the case
    // if y_location is 0 or exactly the full board width we are sticking things out the sides
    // 0 based so take 1 from bd_width
    if (y_location == 0 || y_location == (bd_width-1) ){
        translate([(x_location+(CE_spec_tolerance/2))-(length/2),y_location == 0? -1*(y_location+(CE_spec_tolerance/2)+case_wall_thickness+cutout):((y_location+(CE_spec_tolerance/2))-width)+case_wall_thickness,z_location])
        cube([length+CE_spec_tolerance,width+case_wall_thickness+cutout,thickness],center );
    }
    // if we are not sticking out the sides we must be sticking out the top though we could be cuttout the bottom too.
    else {
        translate([x_location+(CE_spec_tolerance/2),y_location+(CE_spec_tolerance/2),z_location])
        cube([length+CE_spec_tolerance,width+CE_spec_tolerance,thickness+case_wall_thickness+cutout],center );
    }
}
module 96BoardMountHoles(penetration){
    z_loc = (penetration == true)?-1*(case_wall_thickness+(CE_spec_tolerance/2)+(board_top_clearence_extra_tolerance/2)+cutout+.01):0;

    96BoardMountHole(mount_hole_1_x+(CE_spec_tolerance/2),mount_hole_1_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    96BoardMountHole(mount_hole_2_x+(CE_spec_tolerance/2),mount_hole_2_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    96BoardMountHole(mount_hole_3_x+(CE_spec_tolerance/2),mount_hole_3_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    96BoardMountHole(mount_hole_4_x+(CE_spec_tolerance/2),mount_hole_4_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    if (96Boards_CE_extended_version == true){
        96BoardMountHole(mount_hole_5_x+(CE_spec_tolerance/2),mount_hole_5_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
        96BoardMountHole(mount_hole_6_x+(CE_spec_tolerance/2),mount_hole_6_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    }
}
module 96BoardMountHole(x_location, y_location, z_location, size, penetration ){
    
    mount_cylinder(x_location, y_location, z_location, size, penetration);
}

module mount_cylinder(x_location, y_location, z_location, size, penetration){
    // Since this makes a model to diff from the external case have to add extra length to fully penatrate
    // the case
    union() {
        color("green")
        translate([x_location, y_location, z_location])
        cylinder(penetration != true?bd_total_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance:bd_total_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance+(case_wall_thickness*2)+cutout, d = size, false, $fn=smoothness);
        if (screw_terminator == true && penetration == true){
            color("Indigo")
            translate([x_location,y_location,z_location])
            cylinder(nut_hight, r=nut_size/2, $fn=nut_type);    // nut
            color("green")
            translate([x_location,y_location,z_location-cutout])
            cylinder(cutout, r=nut_size/2, $fn=nut_type);  // nut
        }
        if (screw_taper == true && penetration == true) {
            color("Indigo")
            translate([x_location,y_location,((bd_total_thickness+case_wall_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance)-screw_taper_height)])
            cylinder(screw_taper_height, r1=(size/2), r2=(size/2)+1.5, $fn=smoothness);  // screw taper
            color("red")
            translate([x_location,y_location,bd_total_thickness+case_wall_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance])
            cylinder(cutout, r1=(size/2)+1.5, r2=(size/2)+1.5, $fn=smoothness);
    
        }
    }
}
module 96BoardOuterCase(){
    if (rounded_case != true){
        translate(0,0,0);
        cube([board_length+CE_spec_tolerance+(case_wall_thickness*2),bd_width+CE_spec_tolerance+(case_wall_thickness*2),bd_total_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance+(case_wall_thickness*2)],false);
    } else {
        translate([(board_length+CE_spec_tolerance+(case_wall_thickness*2))/2,((bd_width+CE_spec_tolerance+(case_wall_thickness*2))/2),((bd_total_thickness+(case_wall_thickness*2))/2)])
        roundedBox([board_length+CE_spec_tolerance+(case_wall_thickness*2), bd_width+CE_spec_tolerance+(case_wall_thickness*2), bd_total_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance+(case_wall_thickness*2)], 5, only_retangle_rounded, $fn=smoothness);
    }
} 
module 96BoardBlock(penetration){
    96BoardBare(penetration);
    // Total footprint space consumed by 96Board
    difference() {
        cube([board_length+CE_spec_tolerance,bd_width+CE_spec_tolerance,bd_total_thickness+CE_spec_tolerance+board_top_clearence_extra_tolerance],false);
        96BoardStandoffMounts();
    };     
}

module 96BoardBare(penetration){
    // 96CE Board with connectors on it that stick out far enough to subtract from a case black
    union() {
        color( "orange" )
        translate([0,0,board_bottom_clearence])
        cube([board_length+CE_spec_tolerance,bd_width+CE_spec_tolerance,board_thickness],false);
        translate([0,0,0]){    
            // USB_Host_Connectors
            color( "DarkTurquoise" )
            face_penetration(usb_host1_offset, usb_host_length, usb_host_width, 
            usb_host_thickness, board_front_edge,board_top_surface, false);
            color( "DarkTurquoise" )
            face_penetration(usb_host2_offset, usb_host_length, usb_host_width, 
            usb_host_thickness, board_front_edge, board_top_surface, false);

            // USB_OTG_Connector
            color( "cyan" )
            face_penetration(usb_otg3_offset, usb_otg_length, usb_otg_width, 
            usb_otg_thickness, board_front_edge, board_top_surface, false);

            // HDMI_Connector
            color( "blue" )
            face_penetration(hdmi_offset, hdmi_length, hdmi_width,
            hdmi_thickness, board_front_edge, board_top_surface, false);
            
            //microSD_Connector
            color( "green" )
            face_penetration(microSD_offset, microSD_length, microSD_width, 
            microSD_thickness, board_front_edge, board_top_surface, false);
            
            // DC_pwr_Connector
            color( "lightgreen" )
            face_penetration(DC_pwr_offset, DC_pwr_length, DC_pwr_width, 
            DC_pwr_thickness, board_back_edge, board_top_surface, false);
            
            //Low_Speed_Connector
            if (expose_low_speed_connector == true ){
                color("Indigo")
                face_penetration(low_speed_connector_left_offset, low_speed_connector_length, low_speed_connector_width, 
                bd_top_clearence, low_speed_connector_center_offset-(low_speed_connector_width/2), board_top_surface, false);
            }
            
            // High_Speed_Connector
            if (expose_high_speed_connector == true ){
                color("Indigo")
                face_penetration(high_speed_connector_left_offset, high_speed_connector_length,high_speed_connector_width, 
                bd_top_clearence, high_speed_connector_center_offset-(high_speed_connector_width/2), board_top_surface, false);
            }
            
            // DragonBoardDipSwitch
            if (expose_DragonBoardDipSwitch == true){
                color("Fuchsia")
                face_penetration(DragonBoardDipSwitch_offset, DragonBoardDipSwitch_length, DragonBoardDipSwitch_width,
                bd_bottom_clearence, DragonBoardDipSwitch_y_offset, DragonBoardDipSwitch_z_offset, false);//-3.25
            }
            
            //UART_Board_Connector
            if (96Board_UART_Board_Installed == true && 96Boards_CE_extended_version == false){
                color( "DarkOliveGreen" )
                face_penetration(uart_board_connector_offset, uart_board_connector_length, uart_board_connector_width,
                uart_board_connector_thickness, board_back_edge, uart_board_top_surface, false);
            }
            
            // UART_Board_Button
            if (expose_UART_Board_Button == true && 96Board_UART_Board_Installed == true){
                color("DodgerBlue")
                translate([uart_board_button_x_offset, uart_board_button_center_y_offset, uart_board_top_surface])
                cylinder((bd_total_thickness+case_wall_thickness+cutout)-uart_board_top_surface, d=hole_size, $fn=smoothness);
            }
           96BoardMountHoles(penetration);
        }
    }
}

module 96BoardCase(penetration){
    difference() {
        96BoardOuterCase();
        translate( [case_wall_thickness,case_wall_thickness,case_wall_thickness])
        96BoardBlock(penetration);
        if (slice == true ){
            if (slice_top == true ){
                slice_top();
            } else {
                slice_bottom();
            }
        }
    }
}

if (case == true ){
    96BoardCase(screw_holes);
} else {
    if (96BoardBlock != true){
        96BoardBare(screw_holes);
    } else {
        96BoardBlock(screw_holes);
    }
}

