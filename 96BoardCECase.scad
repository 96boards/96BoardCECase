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
// Only the rectangle of the case rounded (sides) or all angles (top, bottom, sides)  
only_rectangle_rounded = false;

// How thick do you want your case walls(in mm)
// Be careful if you are setting rounded_case true, too thin of walls will leave holes
// Don't go to thick (much over 2.5) or you will have problems plugging in cables
case_wall_thickness = 2.5;

// Extended board or regular true/false question
96Boards_CE_extended_version = false;

// Do you have a UART board and want room to install it in the case?
96Board_UART_Board_Installed = true; 

// The UART board has a reset button, if you want to be able to press it true
expose_UART_Board_Button = true;

// expose the low/high speeo0id connectors or not true/false question
expose_low_speed_connector = true;
expose_high_speed_connector = false;
expose_DragonBoardDipSwitch = true;

// Do I want screw holes through the case? true/false question
screw_holes = true;
// Do I only want screw holes on the top of the case and no nuts on the bottom, can thread screws into the standoffs --- Need to add code for this
screw_holes_top_only = false;
// Do I want nut holes on the bottom 
screw_terminator = true;

// For exporting .stl models, this will cut the model in 1/2 at the board top level.
// The board will fit into the bottom of the case cleanly and the top will sit on it
slice = false;
// top of the box or bottom 
slice_top = true;

// turns out each 3D printer prints a little differently and that can make a board not fit the case
// so to be safe print out a 85x54x5 rectangle or a 100x85x5 rectangle depending on what size case 
// you are making and then measure it with a digital caliper calculate the % big or small for each 
// dimension and add it here. 1 is no scaling at all.  It is entirely possible to have negative scaling 
// .998 vs positive scaling 1.03 for each direction each printer has it's own thing.
// If the case is bigger then it needs to be but the board fits I'd leave it alonw, this is really needed
// if the case is too small
x_scaler = 1.0;
y_scaler = 1.0;
z_scaler = 1.0;

// How round do you want holes  the higher it set to the longer it takes to render
smoothness = 50; //10-100

// For development only do you want to see the full case, the full diff model or the bare board model can help when adding new case type
// Set true for final case, false shows you the board and screw layout
case = true;
96BoardBlock = true;

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

microSD_length = 15.20;
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

DragonBoardDipSwitch_width = 6.50;
DragonBoardDipSwitch_length = 6.00;
DragonBoardDipSwitch_offset = 4.82;
DragonBoardDipSwitch_y_offset = 5.65;
DragonBoardDipSwitch_z_offset = -3.5;

// Safe cutout distance.  Things that cut holes must extend past the edge it's cutting
// So odd thing with OpenSCAD, if you don't you can get bad stl files.
cutout = .5;

// All board measurements and offsets set by 96Boards CE specification
// Do not change.
// All measurements are from lower left corner by microSD area.
board_width_reg = 54.00;
board_width_ext = 100.00;
CE_spec_tolerance = 0.25;
board_length = 85.00;
total_thickness = 12;
board_thickness = 1.6;
board_top_clearance = 7;
// Some of the USB connectors take up too much room so add extra room if needed
// The first version of the HiKey the USB connectors were 7.46 high
board_top_clearance_extra_tolerance = .46;   
board_bottom_clearance = 3.4;
board_top_surface =5;
board_front_edge = 0;
// How wide is the board, normal or extended
bd_width = (96Boards_CE_extended_version == true?board_width_ext:board_width_reg);
// How tall is the board, normal or extended for the UART board?
bd_total_thickness = (96Board_UART_Board_Installed == false)?total_thickness:total_thickness+(uart_board_total_thickness-(board_top_clearance-low_speed_connector_thickness));
bd_top_clearance = (96Board_UART_Board_Installed == false)?board_top_clearance+board_top_clearance_extra_tolerance+CE_spec_tolerance:board_top_clearance+board_top_clearance_extra_tolerance+CE_spec_tolerance+(uart_board_total_thickness - (board_top_clearance-low_speed_connector_thickness));
bd_bottom_clearance = board_bottom_clearance+CE_spec_tolerance;
board_back_edge = bd_width - 1;
// Sometimes the front edge connectors extend out beyond the board and have edges that catch on the bottom case.
// So we will sink the connector models this much into the case, and make them this much taller so we have a larger hole
// for the connectors allowing for any manufacturing tolerance issues.
front_connector_tolerance_z_drop = .4;

usb_host1_offset = 76.00;
usb_host2_offset = 56.60;
usb_otg3_offset = 41.60;
hdmi_offset = 25.00;
microSD_offset = 7.8;
DC_pwr_offset = 72.00;
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

// Need this to be oversized as holes are undersized
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
    draw_cube(-1 * (cutout/2),-1 * (cutout/2),case_wall_thickness+board_top_surface-.001,
    board_length+CE_spec_tolerance+(case_wall_thickness*2)+cutout, bd_width+CE_spec_tolerance+(case_wall_thickness*2)+cutout,case_wall_thickness+bd_top_clearance+cutout);
}
module slice_bottom(){
    // Something is slightly wrong here, had to add .001 to the size of the cube to cut everything as needed.  Rounding error?
    // Should not need the extra .001
    draw_cube(-1 * (cutout/2),-1 * (cutout/2),-1 * cutout,
    board_length+CE_spec_tolerance+(case_wall_thickness*2)+cutout, bd_width+CE_spec_tolerance+(case_wall_thickness*2)+cutout,case_wall_thickness+board_top_surface+cutout+.001);
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
// module face_penetration(x_location, length, width , thickness, y_location, z_location, center){
module face_penetration(face, x_location, y_location, z_location, length, width , thickness, center){
    // Since this makes a model to diff from the external case have to add extra length to fully penetrate
    // the case
    if (face == "FR"){ // FRont face
        draw_cube((x_location+(CE_spec_tolerance/2))-(length/2),y_location == 0? -1*(y_location+(CE_spec_tolerance/2)+case_wall_thickness+cutout):((y_location+(CE_spec_tolerance/2))-width)+case_wall_thickness,z_location-front_connector_tolerance_z_drop,
        length+CE_spec_tolerance,width+case_wall_thickness+cutout,thickness+front_connector_tolerance_z_drop,center );
    }else if (face == "BA"){ // BAck face
        draw_cube((x_location+(CE_spec_tolerance/2))-(length/2),y_location == 0? -1*(y_location+(CE_spec_tolerance/2)+case_wall_thickness+cutout):((y_location+(CE_spec_tolerance/2))-width)+case_wall_thickness,z_location,
        length+CE_spec_tolerance,width+case_wall_thickness+cutout,thickness,center );
    }else if (face == "LS"){ // Left Side face
        draw_cube(x_location+(CE_spec_tolerance/2),y_location+(CE_spec_tolerance/2),z_location,
        length+CE_spec_tolerance+case_wall_thickness+cutout,width+CE_spec_tolerance,thickness,center );
    }else if (face == "RS"){ // Right Side face
        draw_cube(x_location+(CE_spec_tolerance/2),y_location+(CE_spec_tolerance/2),z_location,
        length+CE_spec_tolerance+case_wall_thickness+cutout,width+CE_spec_tolerance,thickness,center );
    }else if (face == "TO"){ // TOp face
        draw_cube(x_location+(CE_spec_tolerance/2),y_location+(CE_spec_tolerance/2),z_location,
        length+CE_spec_tolerance,width+CE_spec_tolerance,thickness+case_wall_thickness+cutout,center );
    }else { // BOttom face
        draw_cube(x_location+(CE_spec_tolerance/2),y_location+(CE_spec_tolerance/2),z_location, length+CE_spec_tolerance,width,thickness+case_wall_thickness+cutout,center);
    }
}
module MountHoles(penetration){
    z_loc = (penetration == true)?-1*(case_wall_thickness+(CE_spec_tolerance/2)+(board_top_clearance_extra_tolerance/2)+cutout+.01):0;

    MountHole(mount_hole_1_x+(CE_spec_tolerance/2),mount_hole_1_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    MountHole(mount_hole_2_x+(CE_spec_tolerance/2),mount_hole_2_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    MountHole(mount_hole_3_x+(CE_spec_tolerance/2),mount_hole_3_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    MountHole(mount_hole_4_x+(CE_spec_tolerance/2),mount_hole_4_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    if (96Boards_CE_extended_version == true){
        MountHole(mount_hole_5_x+(CE_spec_tolerance/2),mount_hole_5_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
        MountHole(mount_hole_6_x+(CE_spec_tolerance/2),mount_hole_6_y+(CE_spec_tolerance/2),z_loc, hole_size, penetration);
    }
}
module MountHole(x_location, y_location, z_location, size, penetration ){
    
    mount_cylinder(x_location, y_location, z_location, size, penetration);
}

module mount_cylinder(x, y, z, size, penetration){
    // Since this makes a model to diff from the external case have to add extra length to fully penetrate
    // the case
    union() {
        color("green")
        translate([x * x_scaler, y * y_scaler, z * z_scaler])
        cylinder(penetration != true?(bd_total_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance) * z_scaler:(bd_total_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance+(case_wall_thickness*2)+cutout)*z_scaler, d = size, false, $fn=smoothness);
        if (screw_terminator == true && penetration == true){
            color("Indigo")
            translate([x * x_scaler, y * y_scaler, z * z_scaler])
            cylinder(nut_hight * z_scaler, r=nut_size/2, $fn=nut_type);    // nut
            color("green")
            translate([x * x_scaler, y * y_scaler, (z-cutout) * z_scaler])
            cylinder(cutout * z_scaler, r=nut_size/2, $fn=nut_type);  // nut
        }
        if (screw_taper == true && penetration == true) {
            color("Indigo")
            translate([x * x_scaler, y * y_scaler,(((bd_total_thickness+case_wall_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance)-screw_taper_height))*z_scaler])
            cylinder(screw_taper_height * z_scaler, r1=(size/2), r2=(size/2)+1.5, $fn=smoothness);  // screw taper
            color("red")
            translate([x * x_scaler, y * y_scaler,(bd_total_thickness+case_wall_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance)*z_scaler])
            cylinder(cutout * z_scaler, r1=(size/2)+1.5, r2=(size/2)+1.5, $fn=smoothness);
    
        }
    }
}

module 96BoardOuterCase(){
    if (rounded_case != true){
        draw_cube(0,0,0,
        board_length+CE_spec_tolerance+(case_wall_thickness*2),bd_width+CE_spec_tolerance+(case_wall_thickness*2),bd_total_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance+(case_wall_thickness*2),false);
    } else {
        draw_roundedBox((board_length+CE_spec_tolerance+(case_wall_thickness*2))/2,((bd_width+CE_spec_tolerance+(case_wall_thickness*2))/2),((bd_total_thickness+(case_wall_thickness*2))/2),
        board_length+CE_spec_tolerance+(case_wall_thickness*2), bd_width+CE_spec_tolerance+(case_wall_thickness*2), bd_total_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance+(case_wall_thickness*2), 5, only_rectangle_rounded);
    }
} 
module 96BoardBlock(penetration){
    96BoardBare(penetration);
    // Total footprint space consumed by 96Board
    difference() {
        draw_cube(0,0,0, board_length+CE_spec_tolerance,bd_width+CE_spec_tolerance,bd_total_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance,false);
        96BoardStandoffMounts();
        };
      // This will cut the 96Board logo in the case top, not really useful as the centers of letters will just fall in.       
//    translate([40, 25,bd_total_thickness+CE_spec_tolerance+board_top_clearance_extra_tolerance+(case_wall_thickness*2)])
//    96BoardsLogo(8);
}

module 96BoardBare(penetration){
    // 96CE Board with connectors on it that stick out far enough to subtract from a case black
    union() {
        color( "orange" )
        draw_cube(0,0,board_bottom_clearance,
        board_length+CE_spec_tolerance,bd_width+CE_spec_tolerance,board_thickness,false);
        translate([0,0,0]){    
            // USB_Host_Connectors
            color( "DarkTurquoise" )
            face_penetration("FR", usb_host1_offset, board_front_edge,board_top_surface, usb_host_length, usb_host_width, 
            usb_host_thickness, false);
            color( "DarkTurquoise" )
            face_penetration("FR", usb_host2_offset, board_front_edge, board_top_surface, usb_host_length, usb_host_width, 
            usb_host_thickness, false);

            // USB_OTG_Connector
            color( "cyan" )
            face_penetration("FR", usb_otg3_offset, board_front_edge, board_top_surface, usb_otg_length, usb_otg_width, 
            usb_otg_thickness, false);

            // HDMI_Connector
            color( "blue" )
            face_penetration("FR", hdmi_offset, board_front_edge, board_top_surface, hdmi_length, hdmi_width,
            hdmi_thickness, false);
            
            //microSD_Connector
            color( "green" )
            face_penetration("FR", microSD_offset, board_front_edge, board_top_surface, microSD_length, microSD_width, 
            microSD_thickness, false);
            
            // DC_pwr_Connector
            color( "lightgreen" )
            face_penetration("BA", DC_pwr_offset, board_back_edge, board_top_surface, DC_pwr_length, DC_pwr_width, 
            DC_pwr_thickness, false);
            
            //Low_Speed_Connector
            if (expose_low_speed_connector == true ){
                color("Indigo")
                face_penetration("TO", low_speed_connector_left_offset, low_speed_connector_center_offset-(low_speed_connector_width/2), board_top_surface, low_speed_connector_length, low_speed_connector_width, 
                bd_top_clearance, false);
            }
            
            // High_Speed_Connector
            if (expose_high_speed_connector == true ){
                color("Indigo")
                face_penetration("TO", high_speed_connector_left_offset, high_speed_connector_center_offset-(high_speed_connector_width/2), board_top_surface, high_speed_connector_length,high_speed_connector_width, 
                bd_top_clearance, false);
            }
            
            // DragonBoardDipSwitch
            if (expose_DragonBoardDipSwitch == true){
                color("Fuchsia")
                face_penetration("BO", DragonBoardDipSwitch_offset, DragonBoardDipSwitch_y_offset, DragonBoardDipSwitch_z_offset, DragonBoardDipSwitch_length, DragonBoardDipSwitch_width,
                bd_bottom_clearance, false);//-3.25
            }
            
            //UART_Board_Connector
            if (96Board_UART_Board_Installed == true && 96Boards_CE_extended_version == false){
                color( "DarkOliveGreen" )
                face_penetration("BA", uart_board_connector_offset, board_back_edge, uart_board_top_surface, uart_board_connector_length, uart_board_connector_width,
                uart_board_connector_thickness, false);
            }
            
            // UART_Board_Button
            if (expose_UART_Board_Button == true && 96Board_UART_Board_Installed == true){
                color("DodgerBlue")
                translate([uart_board_button_x_offset * x_scaler, uart_board_button_center_y_offset * y_scaler, uart_board_top_surface * z_scaler])
                cylinder(((bd_total_thickness+case_wall_thickness+cutout)-uart_board_top_surface)* z_scaler, d=hole_size, $fn=smoothness);
            }
           MountHoles(penetration);
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



module draw_cube(x, y, z, length, width, thickness, center){
    // Apply the scalers to cubes
    translate([x * x_scaler,y * y_scaler,z * z_scaler])
    cube([length * x_scaler, width * y_scaler, thickness * z_scaler], center);
}

module draw_roundedBox(x , y, z, length, width, thickness, radius, sidesonly){
    translate([x * x_scaler,y * y_scaler,z * z_scaler])
    roundedBox([length * x_scaler, width * y_scaler, thickness * z_scaler], radius, sidesonly, $fn=smoothness);
}

// WARNING WARNING WARNING the code below here was auto-generated to 
// generate the 96Boards Logo
// keep the resulting .stl file manifold.
fudge = 0.1;

module 96BoardsLogo(h)
{
  scale([.1, .1, 1]) color("red") rotate(a=[180,0,0]) union()
  {
// WARNING WARNING WARNING the code below here was auto-generated to 
// generate the 96Boards Logo, don't mess with it unless you are an
// OpenSCAD Expert.  If you want to change the size, use the scale 
// command just above this comment.  The hight is passed in as part 
// of the module call.
    difference()
    {
       linear_extrude(height=h)
         polygon([[-267.998324,91.982466],[-247.585741,63.273636],[-247.140380,62.385043],[-247.295986,62.038046],[-252.382993,61.196306],[-260.706992,59.402576],[-268.425330,56.670199],[-275.467838,53.056616],[-281.764347,48.619271],[-287.244691,43.415606],[-291.838701,37.503064],[-295.476209,30.939086],[-298.087047,23.781116],[-299.076239,19.858223],[-299.705741,16.213725],[-300.253277,6.894326],[-300.224144,-0.649477],[-299.760585,-7.281851],[-298.816691,-13.419304],[-297.346557,-19.478344],[-294.479777,-27.619202],[-290.738587,-35.036892],[-286.186895,-41.670928],[-280.888607,-47.460826],[-274.907630,-52.346103],[-268.307873,-56.266274],[-261.153242,-59.160855],[-253.507645,-60.969362],[-246.069403,-61.692642],[-238.718528,-61.519488],[-231.608374,-60.462937],[-224.892294,-58.536033],[-218.474841,-55.649786],[-212.536475,-51.873275],[-207.125298,-47.267403],[-202.289412,-41.893072],[-198.076920,-35.811187],[-194.535924,-29.082650],[-191.714528,-21.768364],[-189.660833,-13.929234],[-188.673858,-7.373746],[-188.105424,0.099510],[-187.999344,7.522912],[-188.399433,13.928836],[-189.308445,19.903545],[-190.608146,25.699167],[-192.351776,31.440779],[-194.592576,37.253459],[-197.383787,43.262283],[-200.778651,49.592329],[-204.830407,56.368675],[-209.592297,63.716396],[-231.339384,94.565826],[-249.186475,119.585746],[-268.455659,119.585746],[-287.724840,119.585746],[-267.998324,91.982466]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-238.692295,27.353516],[-235.793816,26.237021],[-233.030507,24.666151],[-230.446330,22.689970],[-228.085246,20.357539],[-225.991216,17.717920],[-224.208202,14.820175],[-222.780164,11.713367],[-221.751063,8.446556],[-220.993278,3.445568],[-221.123350,-1.501487],[-222.084021,-6.277345],[-223.818032,-10.764736],[-226.268124,-14.846396],[-229.377038,-18.405056],[-233.087514,-21.323451],[-237.342295,-23.484314],[-240.355030,-24.418544],[-244.092295,-24.605932],[-247.135118,-24.508386],[-249.602511,-24.104845],[-251.939796,-23.281623],[-254.592295,-21.925034],[-256.788454,-20.514172],[-258.847204,-18.836700],[-262.464628,-14.801984],[-265.268861,-10.061000],[-267.084200,-4.853864],[-267.548485,-1.936941],[-267.730859,1.403078],[-267.626340,4.739041],[-267.229946,7.643796],[-265.339540,13.249406],[-263.653206,16.536509],[-260.774698,20.057656],[-257.855783,23.031532],[-255.034444,25.184218],[-252.037631,26.687286],[-248.592295,27.712306],[-246.329795,28.003754],[-243.645691,28.030960],[-240.959889,27.809142],[-238.692295,27.353516]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-240.320887,18.537076],[-241.984076,11.017498],[-243.069238,2.900056],[-243.253020,-7.177007],[-242.725012,-16.584524],[-242.363947,-19.069954],[-241.128121,-18.841794],[-238.847143,-18.204140],[-236.616570,-17.166437],[-234.481820,-15.772665],[-232.488312,-14.066801],[-230.681467,-12.092825],[-229.106702,-9.894714],[-227.809437,-7.516447],[-226.835091,-5.002004],[-226.281583,-2.392388],[-226.005050,0.705710],[-226.025196,3.815199],[-226.361727,6.458986],[-227.785142,10.707782],[-230.008277,14.579981],[-232.874795,17.856021],[-236.228362,20.316336],[-238.098482,21.327598],[-239.107039,21.497220],[-239.699388,20.631585],[-240.320887,18.537076]]);
    }
    linear_extrude(height=h)
      polygon([[-192.942293,60.463976],[-198.038862,59.791976],[-200.442293,59.101706],[-198.530153,55.666066],[-194.207522,48.058521],[-190.761387,41.000368],[-188.043897,34.158172],[-185.907203,27.198496],[-184.964103,23.651356],[-182.878203,23.236196],[-179.711507,22.338089],[-176.724507,20.957816],[-173.949693,19.128478],[-171.419552,16.883176],[-169.166573,14.255013],[-167.223244,11.277089],[-165.622055,7.982506],[-164.395493,4.404366],[-163.821784,1.490773],[-163.692293,-2.718034],[-163.821972,-6.928364],[-164.395193,-9.852444],[-166.547765,-15.489881],[-167.977111,-17.988972],[-169.628463,-20.248424],[-173.240197,-23.991377],[-177.072973,-26.663580],[-181.273189,-28.344363],[-185.987243,-29.113058],[-189.082183,-29.322091],[-190.230993,-31.902564],[-192.680010,-36.761157],[-195.598823,-41.441593],[-198.923754,-45.877990],[-202.591129,-50.004468],[-206.537271,-53.755146],[-210.698506,-57.064144],[-215.011157,-59.865582],[-219.411549,-62.093578],[-222.336549,-63.554136],[-196.992293,-99.169884],[-182.292303,-119.578586],[-163.019523,-119.582166],[-143.746753,-119.585746],[-164.120563,-91.420452],[-176.671743,-74.048222],[-182.476699,-65.666204],[-183.485621,-63.829533],[-183.571522,-63.020025],[-182.988912,-62.830883],[-181.992303,-62.855310],[-176.840032,-62.110464],[-170.439513,-60.641677],[-163.591530,-58.218476],[-157.139798,-55.021218],[-151.226116,-51.131175],[-145.992283,-46.629622],[-143.277662,-43.717498],[-140.822716,-40.593669],[-138.629752,-37.262803],[-136.701077,-33.729567],[-135.038998,-29.998630],[-133.645823,-26.074658],[-132.523859,-21.962321],[-131.675413,-17.666285],[-131.178284,-12.527387],[-130.989448,-5.972452],[-131.114997,0.723359],[-131.561023,6.284885],[-132.861299,13.744215],[-134.708840,20.709712],[-137.100676,27.176085],[-140.033842,33.138048],[-143.505368,38.590309],[-147.512287,43.527580],[-152.051631,47.944572],[-157.120433,51.835995],[-160.963819,54.191865],[-165.036430,56.194329],[-169.314275,57.837608],[-173.773362,59.115925],[-178.389698,60.023500],[-183.139294,60.554554],[-187.998156,60.703308],[-192.942293,60.463985]]);
    difference()
    {
       linear_extrude(height=h)
         polygon([[6.634687,56.706486],[1.744308,55.845545],[-2.842311,54.315737],[-7.087473,52.148600],[-10.953485,49.375669],[-14.402652,46.028481],[-17.397279,42.138572],[-19.899671,37.737478],[-21.872133,32.856736],[-22.919185,29.350146],[-23.613834,26.046569],[-24.249173,18.175526],[-24.124560,10.229373],[-22.993493,3.199036],[-21.404344,-2.245080],[-19.201384,-7.217235],[-16.422983,-11.678496],[-13.107510,-15.589932],[-9.293335,-18.912608],[-5.018828,-21.607595],[-0.322357,-23.635958],[4.757707,-24.958767],[11.143462,-25.459547],[17.527417,-25.115770],[21.217979,-24.272333],[24.943860,-22.934813],[28.503229,-21.188637],[31.694257,-19.119234],[35.670363,-15.386591],[39.329287,-10.871594],[41.007163,-7.982410],[42.595188,-4.518790],[43.966465,-0.789176],[44.994097,2.897986],[45.791463,7.312056],[46.078147,13.080686],[46.018483,19.781171],[45.414378,25.501205],[44.188683,30.701225],[42.264247,35.841666],[40.093513,40.187282],[37.612113,43.924479],[34.710318,47.196117],[31.278397,50.145056],[28.678494,51.910798],[25.876267,53.423692],[22.904225,54.675083],[19.794881,55.656314],[13.294326,56.773674],[9.968136,56.892492],[6.634687,56.706526]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[14.449717,41.959646],[16.379293,41.243890],[18.117765,40.264995],[21.435937,37.237586],[23.685716,34.098042],[25.490311,30.360837],[26.833375,26.149603],[27.698565,21.587973],[28.069533,16.799578],[27.929935,11.908052],[27.263425,7.037028],[26.053657,2.310136],[24.087300,-2.353311],[21.404317,-6.161204],[19.170078,-8.275432],[16.753923,-9.741506],[14.077686,-10.595037],[11.063197,-10.871634],[8.763332,-10.697132],[6.594444,-10.177792],[4.564864,-9.319862],[2.682918,-8.129591],[0.956936,-6.613226],[-0.604756,-4.777016],[-1.993828,-2.627209],[-3.201953,-0.170054],[-4.629694,3.887241],[-5.601896,8.229394],[-6.122325,12.742185],[-6.194745,17.311391],[-5.822923,21.822791],[-5.010624,26.162163],[-3.761612,30.215285],[-2.079653,33.867936],[0.823301,37.756201],[2.553669,39.427774],[4.190227,40.616546],[6.637411,41.700006],[9.273960,42.299528],[11.933515,42.393333],[14.449717,41.959646]]);
    }
    difference()
    {
       linear_extrude(height=h)
         polygon([[71.957707,56.712496],[68.208004,55.918462],[64.794654,54.506284],[61.750429,52.513639],[59.108103,49.978205],[56.900448,46.937661],[55.160235,43.429685],[53.920237,39.491954],[53.213227,35.162146],[53.188054,31.817527],[53.628547,28.052070],[54.457277,24.323009],[55.596817,21.087576],[57.052267,18.371010],[58.894286,15.842622],[61.102908,13.517042],[63.658170,11.408900],[66.540106,9.532824],[69.728752,7.903444],[73.204144,6.535388],[76.946317,5.443286],[83.922251,4.216925],[90.930877,3.736866],[94.457707,3.736866],[94.457707,1.728736],[93.948157,-2.244050],[92.484202,-5.666566],[90.162885,-8.381461],[87.081247,-10.231384],[84.678398,-10.952316],[82.002244,-11.335622],[79.121460,-11.390719],[76.104720,-11.127027],[69.938061,-9.680953],[66.925491,-8.517410],[64.051657,-7.072754],[61.608427,-5.839114],[58.276087,-18.077754],[58.667291,-18.827761],[60.555307,-20.043054],[64.105366,-21.800236],[68.029312,-23.246832],[72.298746,-24.373918],[76.885267,-25.172572],[80.434540,-25.400691],[84.841241,-25.368763],[89.063064,-25.111718],[92.057707,-24.664485],[96.224253,-23.254362],[99.893643,-21.323765],[103.072577,-18.863767],[105.767756,-15.865445],[107.985880,-12.319875],[109.733649,-8.218133],[111.017765,-3.551294],[111.844927,1.689566],[112.164517,24.111936],[112.339976,43.805983],[112.937377,53.592656],[113.125837,55.036536],[105.179407,55.036536],[97.232977,55.036536],[96.745357,51.490886],[96.257707,47.244236],[96.163698,46.692172],[95.864238,46.616526],[94.544377,47.936776],[92.222634,50.365095],[89.380766,52.570299],[86.249036,54.396974],[83.057707,55.689706],[78.568841,56.628015],[74.657707,57.023856],[71.957707,56.712496]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[84.857707,41.898126],[88.197123,40.297453],[91.163017,37.507376],[93.128534,34.760493],[94.315233,31.750413],[94.899062,27.783814],[95.055967,22.167376],[95.057967,16.646716],[91.871457,16.646716],[85.654329,17.135542],[80.265860,18.545070],[77.953382,19.568403],[75.933281,20.789879],[74.233962,22.198819],[72.883827,23.784546],[71.925380,25.425724],[71.264202,27.204498],[70.757967,31.447746],[70.893392,33.736701],[71.311715,35.731086],[72.031009,37.490526],[73.069347,39.074646],[75.343943,41.164351],[78.097902,42.338924],[81.284738,42.587228],[84.857967,41.898126]]);
    }
    difference()
    {
       linear_extrude(height=h)
         polygon([[197.499347,56.741926],[194.505626,56.168765],[191.592822,55.218832],[188.787461,53.910638],[186.116065,52.262698],[183.605158,50.293523],[181.281266,48.021628],[179.170910,45.465525],[177.300617,42.643726],[175.270031,38.784986],[173.658565,34.756441],[172.420181,30.423014],[171.508847,25.649626],[171.027141,21.064730],[171.045677,14.608306],[171.310472,8.274309],[171.949577,4.076596],[173.319798,-1.192189],[175.113887,-6.007153],[177.317409,-10.349676],[179.915927,-14.201139],[182.895004,-17.542923],[186.240205,-20.356409],[189.937091,-22.622978],[193.971227,-24.324010],[197.226348,-25.087088],[200.981691,-25.438959],[204.815925,-25.364240],[208.307717,-24.847548],[211.563946,-23.846404],[214.456075,-22.428717],[217.067774,-20.544287],[219.482717,-18.142914],[221.957717,-15.317304],[221.957717,-37.555238],[221.957717,-59.793151],[230.807717,-59.793151],[239.657717,-59.793151],[239.657717,-7.528334],[239.854547,49.886516],[240.051407,55.036536],[232.243307,55.036536],[224.435207,55.036536],[224.254547,53.083076],[223.873307,46.967866],[223.490207,42.822476],[222.257717,44.722906],[220.198001,47.695845],[217.496953,50.492034],[214.352358,52.934234],[210.961997,54.845206],[207.977499,55.890751],[204.491852,56.590186],[200.875616,56.891311],[197.499347,56.741926]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[210.097217,40.246976],[211.952839,39.554343],[213.649483,38.594716],[216.932807,35.626416],[218.565373,33.508471],[219.855805,31.165055],[220.832080,28.534778],[221.522177,25.556246],[221.897485,21.542188],[221.895107,13.665576],[221.688437,5.647671],[221.093867,2.377956],[219.520795,-1.512204],[217.178717,-4.876584],[214.864240,-7.208919],[212.407161,-8.781996],[209.630610,-9.679304],[206.357717,-9.984334],[203.425337,-9.856700],[201.177857,-9.225524],[198.719798,-8.003214],[196.514644,-6.355944],[194.568215,-4.293740],[192.886330,-1.826625],[191.474807,1.035376],[190.339466,4.282237],[189.486127,7.903936],[188.920607,11.890446],[188.759752,17.193373],[189.277258,22.529646],[190.413239,27.525075],[192.107807,31.805466],[193.362651,33.764209],[195.067993,35.818928],[196.905720,37.623141],[198.557717,38.830366],[201.340986,40.006996],[204.310423,40.649845],[207.288382,40.737108],[210.097217,40.246976]]);
    }
    linear_extrude(height=h)
      polygon([[265.757717,56.387596],[258.754063,54.801398],[252.717167,52.348206],[250.791317,51.359336],[251.676047,47.677256],[253.358897,40.597886],[254.252957,37.064006],[256.998077,38.321406],[262.120000,40.529746],[267.360812,41.924168],[272.293780,42.425169],[276.492167,41.953246],[279.492453,40.754113],[281.607366,38.983101],[282.855810,36.616949],[283.256687,33.632396],[283.118276,31.828706],[282.697611,30.266274],[281.956844,28.848033],[280.858127,27.476916],[279.550400,26.254208],[277.919185,25.145059],[272.345897,22.480696],[265.757717,19.370006],[261.990389,16.849877],[258.759580,13.919190],[256.154349,10.672219],[254.263757,7.203236],[253.190410,4.155270],[252.911357,0.315536],[252.927261,-3.360807],[253.292387,-6.256364],[254.146042,-9.420954],[255.410257,-12.381169],[257.060044,-15.110289],[259.070417,-17.581594],[261.416389,-19.768367],[264.072972,-21.643888],[267.015181,-23.181437],[270.218027,-24.354298],[273.397218,-25.014965],[277.216000,-25.388002],[281.177420,-25.445887],[284.784527,-25.161098],[289.110413,-24.255705],[293.271790,-22.937470],[296.352188,-21.548943],[297.200623,-20.935367],[297.435137,-20.432674],[295.715477,-13.324264],[294.487161,-8.628305],[293.823077,-6.932624],[289.700105,-8.909254],[286.527617,-10.135671],[283.689344,-10.806387],[280.569017,-11.115914],[277.594817,-11.098746],[275.184085,-10.659195],[273.236796,-9.766683],[271.652927,-8.390634],[270.444683,-6.549954],[269.785742,-4.469261],[269.701519,-2.294110],[270.217427,-0.170054],[271.427912,1.832549],[273.493461,3.695233],[276.627518,5.571478],[281.043527,7.614766],[285.833290,9.871739],[289.871381,12.274710],[293.192414,14.868060],[295.831007,17.696170],[297.821774,20.803423],[299.199331,24.234199],[299.998294,28.032879],[300.253277,32.243846],[299.831751,37.673464],[298.474397,42.142556],[297.216397,44.654229],[295.750176,46.911261],[294.064867,48.922517],[292.149602,50.696858],[289.993514,52.243146],[287.585736,53.570246],[281.971637,55.602326],[278.351923,56.305025],[273.257717,56.567826],[265.757717,56.387666]]);
    difference()
    {
       linear_extrude(height=h)
         polygon([[-86.142293,56.050956],[-94.917293,55.374566],[-99.042293,54.934486],[-99.042293,1.160756],[-98.966205,-44.846462],[-98.809038,-51.452130],[-98.517293,-52.795486],[-86.742293,-54.378805],[-80.654023,-54.711667],[-73.470848,-54.791045],[-66.698396,-54.626165],[-61.842293,-54.226251],[-57.014525,-53.286802],[-52.919279,-51.986304],[-49.217620,-50.190145],[-45.570613,-47.763714],[-42.357324,-44.894949],[-39.744712,-41.551306],[-37.764152,-37.781371],[-36.447023,-33.633732],[-36.065324,-30.915900],[-35.938718,-27.652140],[-36.067015,-24.406516],[-36.450023,-21.743094],[-38.167162,-16.733216],[-40.812605,-12.311701],[-44.328780,-8.554961],[-48.658113,-5.539404],[-51.619613,-3.714364],[-49.916963,-2.908474],[-47.287519,-1.789593],[-44.788721,-0.360752],[-42.448146,1.350072],[-40.293370,3.314899],[-38.351973,5.505751],[-36.651531,7.894648],[-35.219622,10.453613],[-34.083823,13.154666],[-32.897235,17.889466],[-32.453594,23.070601],[-32.757593,28.346784],[-33.813923,33.366726],[-34.886608,36.331411],[-36.270895,39.145029],[-37.949653,41.788294],[-39.905753,44.241915],[-42.122065,46.486605],[-44.581461,48.503074],[-47.266810,50.272034],[-50.160983,51.774196],[-53.367339,53.045592],[-56.937691,54.105885],[-65.180258,55.594339],[-74.908432,56.241912],[-86.141963,56.050956]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-66.240073,40.597806],[-62.912953,39.725948],[-59.984687,38.506708],[-57.461189,36.946479],[-55.348369,35.051650],[-53.652141,32.828613],[-52.378418,30.283760],[-51.533111,27.423481],[-51.122133,24.254166],[-51.146773,21.248999],[-51.570324,18.445895],[-52.380212,15.865189],[-53.563863,13.527218],[-55.108702,11.452317],[-57.002156,9.660822],[-59.231651,8.173070],[-61.784613,7.009396],[-64.388324,6.133130],[-66.779503,5.621630],[-74.367293,5.196976],[-81.642293,5.018836],[-81.642293,22.872776],[-81.642293,40.726706],[-80.517293,40.860106],[-73.099297,41.047664],[-66.240073,40.597946]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-65.383333,-10.469224],[-61.373927,-12.108663],[-58.211162,-14.332352],[-55.864484,-17.168347],[-54.303343,-20.644704],[-53.835995,-23.145946],[-53.757440,-26.049366],[-54.051377,-28.918057],[-54.701503,-31.315111],[-55.664094,-33.230780],[-56.887860,-34.910576],[-58.362228,-36.342305],[-60.076623,-37.513772],[-62.550117,-38.712888],[-65.148647,-39.448133],[-68.390082,-39.817453],[-72.792293,-39.918794],[-80.217293,-39.643165],[-81.642293,-39.367559],[-81.642293,-24.400649],[-81.642293,-9.433714],[-74.667293,-9.598894],[-68.570515,-9.865761],[-65.383333,-10.469184]]);
    }
    linear_extrude(height=h)
      polygon([[127.093807,16.222046],[126.740407,-23.186934],[126.792917,-23.515300],[127.683187,-23.693510],[134.287417,-23.781474],[142.081327,-23.781474],[142.300957,-16.307344],[142.763467,-8.833224],[144.215557,-11.662444],[146.759819,-16.389314],[149.942765,-20.234062],[153.682154,-23.116752],[157.895747,-24.957450],[161.747638,-25.456702],[165.520217,-25.267796],[166.457717,-25.055355],[166.457717,-15.779924],[166.457717,-6.504474],[162.585617,-6.699424],[158.913353,-6.729972],[156.170017,-5.996384],[152.533816,-4.127356],[149.572732,-1.325982],[147.286131,2.408521],[145.673377,7.076936],[145.305086,8.997950],[145.100643,12.408933],[144.928027,32.359546],[144.830027,55.036716],[136.015187,55.036716],[127.200317,55.036716],[127.093817,16.222236]]);
  }
}



