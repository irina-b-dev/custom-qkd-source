use <scad-lib-FDMscrews-main/lib-FDMscrews.scad>


width = 53.8;
depth = 81.5;
height = 9.5;

rail_width = 9;
center_width = width - 2*rail_width;

r_width = 3.4;
r_depth = 1.5;
r_height = 4.3;
r_dist = 49.5;
r_dist1 = (depth - r_dist)/2;


pico_depth = 52.6;
pico_width = 21.1;
pico_height = 19 - height;


//cube([width, depth, height]);

$fn = 100; // smooth thread

pitch = 2;



////////////////////////////////////////////////////

// module stuff(d_outer=20, pitch=2, length=12, inner=12.7){
//      screwByPitch(pitch=pitch,
//                      d0=d_outer,
//                      dr=1.5,
//                      length=length,
//                      flat=1);

//         translate([0, 0, length])
//         screwByPitch(pitch=pitch,
//                      d0=25.6 + 8,
//                      dr=1.5,
//                      length=length,
//                      flat=1);
//             //cylinder(d=25.5 + 3, h=length + 2, center=false, $fn=$fn);
// }


// module stuff2(d_outer=20, pitch=2, length=12, inner=12.7){
//      screwByPitch(pitch=pitch,
//                      d0=d_outer,
//                      dr=1.5,
//                      length=length,
//                      flat=1);

//         translate([0, 0, length])
//         screwByPitch(pitch=pitch,
//                      d0=25.6 + 8.4,
//                      dr=1.5,
//                      length=length,
//                      flat=1);
//             //cylinder(d=25.5 + 3, h=length + 2, center=false, $fn=$fn);
// }


// module hollow_screw(d_outer=20, pitch=2, length=12, inner=12.7) {
 

//    difference(){

//         {
//             stuff();
//         }

//         color([1,0,0]){
        
//          translate([0, 0, 0])
//             cylinder(d=inner, h=length + 23, center=false, $fn=$fn);
        
//         translate([0, 0, length + 3])
//             cylinder(d=25.6 + 2, h=length, center=false, $fn=$fn);

//         }

//    }
     
// }

// module cap(d_outer=20, pitch=2, length=12, inner=12.7){
//     translate([0,0,length+1.5])
//         cylinder(d=25.6 + 8 + 5, h=length + 2, center=false, $fn=$fn);
// }

// module hollow_screw_cap(d_outer=20, pitch=2, length=8, inner=12.7){
//    difference(){
        
//         cap();
//         {
//         stuff2();

//         translate([0, 0, 0])
//             cylinder(d=inner + 5, h=length + 23, center=false, $fn=$fn);
//         }

//    }
// }
///////////////////////////////////////////////////////////////////////


//do = 25.6;
do = 25;

module stuff(d_outer=20, pitch=2, length=8, inner=12.7){
    translate([0, 0, -4])
     screwByPitch(pitch=pitch,
                     d0=d_outer,
                     dr=1.5,
                     length=length + 4,
                     flat=1);

        translate([0, 0, length])
        screwByPitch(pitch=pitch,
                     d0=do + 8,
                     dr=1.5,
                     length=length,
                     flat=1);
            //cylinder(d=25.5 + 3, h=length + 2, center=false, $fn=$fn);
}

allowance = 0.7;
module stuff2(d_outer=20, pitch=2, length=8, inner=12.7){
     screwByPitch(pitch=pitch,
                     d0=d_outer + allowance,
                     dr=1.5,
                     length=length,
                     flat=1);

        translate([0, 0, length])
        screwByPitch(pitch=pitch,
                     d0=do + 8 + allowance,
                     dr=1.5,
                     length=length,
                     flat=1);
            //cylinder(d=25.5 + 3, h=length + 2, center=false, $fn=$fn);
}


module hollow_screw(d_outer=20, pitch=2, length=8, inner=12.7) {
 

   difference(){

        {
            stuff();
        }

        color([1,0,0]){
        
         translate([0, 0, -4])
            cylinder(d=inner, h=length + 23, center=false, $fn=$fn);
        
        translate([0, 0, length + 3])
            cylinder(d=do + 2, h=length, center=false, $fn=$fn);

        }

   }
     
}

module cap(d_outer=20, pitch=2, length=8, inner=12.7){
    translate([0,0,length+1.5 - 4])
        cylinder(d=do + 8 + 5, h=length + 6, center=false, $fn=$fn);
}
module cap_inferior(d_outer=20, pitch=2, length=8, inner=12.7){
    translate([0,0,length*2])
        cylinder(d=d_outer + 5, h=length + 2, center=false, $fn=$fn);
}

module hollow_screw_cap(d_outer=20, pitch=2, length=8, inner=12.7){
   difference(){
        
        cap();
        {
        translate([0,0,-3])
        stuff2();

        translate([0, 0, 0])
            cylinder(d=inner + 5, h=length + 23, center=false, $fn=$fn);
        }

   }



     difference(){
        
        cap_inferior();
        {
        translate([0,0,length*2 + 4])
        stuff2();

         translate([0, 0, length*2])
            cylinder(d=inner + 5, h=length + 23, center=false, $fn=$fn);
        }

   }
}














waveplate_d = 25;
waveplate_h = 0.053;

fit_clearance = 0.2;
holder_d = waveplate_d + fit_clearance;
holder_h = 5;
pocket_d = holder_d;
pocket_h = waveplate_h + 0.05;

lip_h = 0.5;
lip_t = 0.5;

//$fn = 100; // smooth cylinder

module waveplate_holder() {
    difference() {
        // Outer body of the holder
        cylinder(d=holder_d + 2, h=holder_h);

        // Pocket to hold the waveplate
        translate([0, 0, 0 ])
         cylinder(d=holder_d, h=holder_h);

        // Optional central hole if you want to reduce material
        // translate([0, 0, 0]) cylinder(d=10, h=holder_h);
    }

    // // Optional lip to hold the waveplate from above
    // translate([0, 0, holder_h])
    //     cylinder(d=holder_d, h=lip_h);

    // Optional: Add mounting holes or features here
}





module pico_board(){
    color([0,0.7,0])
    cube([pico_width, pico_depth, pico_height]);
}

module breadboard_piece(wdt = rail_width, dth = depth){

    difference(){ 

        cube([wdt, dth, height]);
        {
            translate([wdt/2 - r_width/2, dth - r_depth, 0])
            cube([r_width, r_depth, r_height]);

            translate([0,  r_dist1- r_width/2, 0])
            cube([r_depth, r_width, r_height]);

            translate([0,  dth- r_dist1 + r_width/2, 0])
            cube([r_depth, r_width, r_height]);
        }

        
    }
    
    translate([wdt/2 - r_width/2, -r_depth, 0])
    cube([r_width, r_depth, r_height]);

    translate([wdt,  r_dist1 - r_width/2, 0])
    cube([r_depth, r_width, r_height]);

    translate([wdt,  dth - r_dist1 + r_width/2, 0])
    cube([r_depth, r_width, r_height]);
}

module breadboard_middle(){
    breadboard_piece(wdt=center_width);
}


module breadboard(){
    
    // cube([center_width, depth, height]);
    breadboard_piece(wdt=center_width);

    translate([-rail_width, 0, 0])
    color([1, 0, 1])
    breadboard_piece();

    translate([center_width, 0, 0])
    color([1, 0, 0])
    breadboard_piece();
    
    }

module double_breadboard(){

    breadboard_piece(wdt=center_width);

    translate([center_width, 0, 0])
    breadboard_piece(wdt=center_width);


    translate([-rail_width, 0, 0])
    color([0, 0, 1])
    breadboard_piece();

    translate([center_width*2, 0, 0])
    color([1, 0, 0])
    breadboard_piece();

}


bbo_diameter = 25.4;

module bbo_ring(){
    difference() {
    // Outer cylinder
    cylinder(d=bbo_diameter, h=3, $fn=100);  // $fn = smoothness (100 segments)

    // Inner cylinder (hole)
    cylinder(d=bbo_diameter - 2*2, h=3, $fn=100);  // 2 mm wall on both sides
}

}

module spad(apd_pos = 0, h_ray){
    breadboard_piece(wdt=center_width);
    translationx = (apd_pos == 0) ? center_width * 0.80 :
                   (apd_pos == 1) ? center_width * 0.27 - apd_size/2 :
                   (apd_pos == 2) ? center_width * 0.77 - apd_size :
                   "unknown";  // fallback
    translate([translationx, depth - depth/4 , height])
    apd(h_ray = h_ray);
}


module pico_on_board(){
    breadboard_piece(wdt=center_width);
    translate([width/8,depth/8,height])
    pico_board();
}

module spad_module(apd_pos = 0, h_ray){
    spad(apd_pos, h_ray);
    translate([-center_width, 0,0])
    pico_on_board();
}


ray_dim_d = 6;
beam_splitter_dim = 10;
beam_splitter_dist = 20;
module beam_splitter(){

    
     //ray straight
    // color([0.7,0,0,0.6])
    // translate([beam_splitter_dim/2 - ray_dim_d/2, -beam_splitter_dist , beam_splitter_dim/2 - ray_dim_d/4])
    // rotate([90,0,0])
    // mirror([0,0,1])
    // cylinder(d=ray_dim_d, h= 25, $fn=100);

    // //ray pol

    // color([0.7,0,0,0.6])
    // translate([beam_splitter_dim/2 - ray_dim_d/2, beam_splitter_dim/2- ray_dim_d/2 , beam_splitter_dim/2 - ray_dim_d/4])
    // rotate([0,90,0])
    // cylinder(d=ray_dim_d, h= 25, $fn=100);


    color([0,1,0,0.5])
    cube([beam_splitter_dim, beam_splitter_dim, beam_splitter_dim]);

   


    
}

filter_size = 5;
module filter(){

    cylinder(d=filter_size, h=3, $fn=100);  // $fn = smoothness (100 segments)
}



apd_size = 3.2;
module apd(h_ray = 100){
    color([0.1,0,0.1,1])
    cylinder(d=apd_size, h=apd_size, $fn=100);

    //rays
    color([0.7,0,0.5,0.8])
    cylinder(d=ray_dim_d, h=h_ray, $fn=100);

}



module waveplate(){

    color([0.1,0,1,0.1,0.6])
    rotate([90,0,0])
    cylinder(d=waveplate_d, h= waveplate_h, $fn=100);

}

module polarizing_module(){
    
    waveplate();

    translate([0,5,0])
    waveplate();

    translate([0,10,0])
    waveplate();


}

setup_dist = -300;
dist_bbo = setup_dist/9;
bbo_angle = 29.2;

module alice(){

    

    //laser pump
    color([1,1,0,])
    rotate([90,0,0])
    translate([center_width/3, 0,0])
    double_breadboard();

    //bbo
    translate([center_width, dist_bbo ,depth - depth/4])
    rotate([90,0,0])
    bbo_ring();

    

    //800nm filter
    color([0.5,0,0])
    translate([center_width, dist_bbo - 10 ,depth - depth/4])
    rotate([90,0,0])
    filter();




    //SPAD0
    translate([center_width, setup_dist/7 ,depth - depth/4])
    rotate([0, 0, -bbo_angle])
    translate([-center_width, -setup_dist/7 ,-depth + depth/4])
    translate([3,setup_dist*0.3,0])
    translate([0, 0, 0])
    rotate([90,0,0])
    mirror([0,0,1])
    spad_module(apd_pos = 0, h_ray = 80);
    

    //wave plates
    translate([center_width, setup_dist/7 ,depth - depth/4])
    rotate([0, 0, bbo_angle])
    translate([-center_width, -setup_dist/7 ,-depth + depth/4])
    translate([3,setup_dist*0.3,0])
    translate([center_width, 0 ,depth - depth/4])
    polarizing_module();




    // ray helper

    //blue ray
    color([0,0,1,0.3])
    translate([center_width, 0 ,depth - depth/4])
    rotate([90,0,0])
    cylinder(d=3, h=45, $fn=100);




    //red gen
    height = 200;
    radius = height * tan(bbo_angle);


    color([1,0,0,0.15])
    translate([center_width, dist_bbo ,depth - depth/4])
    rotate([90,0,0])
    cylinder(h=height, r1=0, r2=radius, $fn=100);  // Cone

   


}


module bob(){



    //SPAD1
    translate([center_width * 0.90,0,0 ])
    rotate([90,0,0])
    mirror([0,0,1])
    spad_module(apd_pos = 1, h_ray = 210);



    //SPAD2
    translate([center_width*2 + rail_width*2, 0, 0])
    rotate([90,0,90])
    mirror([0,0,1])
    spad(apd_pos = 2,h_ray = 30);



     //beam splitter
    translate([center_width,20,depth - depth/4 - beam_splitter_dim/2])
    beam_splitter();



}



module full_box(){

   difference(){

        {
            //big box
            color([0.7,0.1,0.1, 0.3])
            translate([-center_width/2, -center_width* 2, -r_depth - height/2])
            cube([center_width *3, center_width *3.1, depth + height*2]);


            
        }

        {
            //box
            color([0.1,0.1,0.1, 0.3])
            translate([center_width * 0.90,-height/2,0 ])
            scale([1,2,1])
            rotate([90,0,0])
            mirror([0,0,1])
            spad_module(apd_pos = 1, h_ray = 210);

            //box
            color([0.1,0.1,0.1, 0.3])
            translate([center_width*2 + rail_width*2 + height/2, 0, 0])
            scale([2,1,1])
            rotate([90,0,90])
            mirror([0,0,1])
            spad(apd_pos = 2,h_ray = 30);

            //box 2
            color([0.1,0.1,0.1, 0.3])
            translate([0, 0, -r_depth])
            cube([center_width*3, center_width, depth - 3]);


            //box 2
            color([0.1,0.1,0.1, 0.3])
            translate([-height, -height-30 - center_width, -r_depth])
            cube([center_width*2.5, center_width*2, depth + r_height]);

             //box beam
            color([0.1,0.1,0.1, 0.8])
            translate([center_width - beam_splitter_dim/4, 20, -r_depth])
            cube([center_width, 0, depth - depth/4]);

            color([0.1,0.1,0.1, 0.8])
            translate([center_width +center_width/2, -10, 0])
            cube([center_width - height, center_width/2 , depth]);
    
        }

   }
        
            //box support beam
            color([0.1,0.1,0.1, 0.8])
            translate([center_width - beam_splitter_dim/4, 20, -r_depth])
            cube([center_width/2, center_width/2, depth - depth/4 - beam_splitter_dim/2]);

}



module spad_box_support(){
    difference(){
        full_box();

        translate([-center_width, 0, 0])
        cube([center_width*4, center_width*3, center_width*3]);
    }

     // cube([center_width*3, center_width*3, center_width*3]);
      //box support beam
            color([0.1,0.1,0.1, 0.8])
            translate([center_width - beam_splitter_dim/4, 20, -r_depth])
            cube([center_width/2, center_width/2, depth - depth/4 - beam_splitter_dim/2]);

}

module spad_box_lid(){


    rim = 6;
    seam = 7;

    lid_h = depth + height*2 ;
    lid_w = center_width *3 +rim + seam;
    lid_d =  center_width *3.1 +rim + seam;

    translate([-width/3 - seam,width/2 + 2*seam,depth + height +6])
    rotate([180,0,0])
    scale([1,1,1])
    difference() {
    // Outer box: 60×40×30 mm



    cube([lid_w, lid_d, lid_h]);
    // Inner hollow space: smaller, inset by 6 mm on all sides
    translate([6, 0,6])
        cube([lid_w - rim*2, lid_d- rim*2, lid_h- rim]);  // Subtract walls (6 mm on each side)
    }


    difference(){
        full_box();
        spad_box_support();
    }
}


module alice_support(){

}



//spad_box_support();



module polarizing_support(){
    hollow_screw();

    translate([0,0,8 + 8 + 4])
    hollow_screw();

    translate([0,0,8 + 8 + 4 + 8 + 8 + 4])
    hollow_screw();

    color([1,0,0,0.4])
    hollow_screw_cap();

    color([1,0,0,0.4])
    translate([0,0,8 + 8 + 4])
    hollow_screw_cap();

     color([1,0,0,0.4])
    translate([0,0,8 + 8 + 4 + 8 + 8 + 4])
    hollow_screw_cap();
}


module the_setup(){



    translate([center_width, setup_dist/7 ,depth - depth/4])
    rotate([0, 0, bbo_angle])
    translate([-center_width, -setup_dist/7 ,-depth + depth/4])
    translate([0,setup_dist*0.75,0])
    {
       // bob();
        spad_box_lid();
    }

    translate([center_width, setup_dist/7 ,depth - depth/4])
    rotate([0, 0, -bbo_angle])
    translate([-center_width, -setup_dist/7 ,-depth + depth/4])
    translate([3,setup_dist*0.4,0])
    mirror([1,0,0])
    spad_box_lid();

    translate([center_width, setup_dist/7 ,depth - depth/4])
    rotate([0, 0, bbo_angle])
    translate([-center_width, -setup_dist/7 ,-depth + depth/4])
    translate([3,setup_dist*0.2,0])
    translate([center_width, 0 ,depth - depth/4])


    rotate([90,0,0])
    polarizing_support();

    translate([0,+50,0])
    spad_box_lid();
    alice();


    
   


}



the_setup();
