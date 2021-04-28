
// Platinenhalter

// Resolution for 3D printing:
$fa = 1;
$fs = 0.4;

// Allgemeines:
delta                  =   0.1; // Standard Durchdringung

// Luft zwischen getrennten Teilen:
luft                   =   0.2;

// Gehäuse Dicke
wand_dicke             =   1.8;

// Schiene:
schiene_laenge         =  50.0;
schiene_tiefe          =   3.0;

// Platine:
platinen_dicke         =   1.6 + luft;

// Schraubenloch
schloch_durchm         =   3.5;
schloch_abstand        =   2.5;

schiene_tot_x          =   schiene_laenge + wand_dicke;
schiene_tot_y          =     2 * wand_dicke + platinen_dicke;
schiene_tot_z          =   schiene_tiefe + wand_dicke;

rundung_durchmesser    =  schloch_durchm + 2 * schloch_abstand;

stand_tot_x            =  rundung_durchmesser;
stand_tot_y            =  schiene_tot_y + 2 * schloch_abstand +
                             2 * rundung_durchmesser;

module schiene() {
    color("red", 1.0) {
        difference() {
            cube([schiene_tot_x,
                  schiene_tot_y,
                  schiene_tot_z]);
            translate([-delta, wand_dicke, wand_dicke])
                cube([schiene_tot_x + 2 * delta,
                      platinen_dicke,
                      schiene_tiefe + delta]);
        };
    }
}

module rundung() {
    translate ([stand_tot_x / 2, stand_tot_x / 2, 0])
        cylinder(d = stand_tot_x, h = wand_dicke);
}

module stand_basis() {
    // Grundplatte:
    translate([0, rundung_durchmesser / 2, 0])
        cube([stand_tot_x,
              stand_tot_y - rundung_durchmesser,
              wand_dicke]);
    
    // Verstärkung:
    translate([stand_tot_x - schiene_tot_z - wand_dicke,
               (stand_tot_y - schiene_tot_y) / 2 - wand_dicke,
               wand_dicke - delta])
        cube([schiene_tot_z + wand_dicke,
              schiene_tot_y + 2 * wand_dicke, 
              wand_dicke + delta]);
    
    // Rundung 1:
    rundung();
    
    // Rundung2:
    translate([0, stand_tot_y - rundung_durchmesser, 0])
        rundung();
}

module bohrloch() {
    cylinder(d = schloch_durchm, h = wand_dicke + 2 * delta);
}

module stand_d() {
    // Bohrloch 1
    translate([stand_tot_x / 2,
               stand_tot_x / 2,
              -delta])
        bohrloch();
    
    // Bohrloch 2
    translate([stand_tot_x / 2,
               stand_tot_y - rundung_durchmesser / 2,
              -delta])
        bohrloch();
    
    // Schienenloch
    translate([(stand_tot_x - schiene_tot_z - luft) / 2,
               (stand_tot_y - schiene_tot_y -luft) / 2,
               -delta])
        cube([schiene_tot_z + luft,
              schiene_tot_y + luft,
              wand_dicke * 2 + 2 * delta]);
}

module stand() {
    difference() {
        stand_basis();
        stand_d();
    }
}

module schiene_aufgestellt() {
    translate([schiene_tot_z, 0, 0])
        rotate([0, -90, 0])
            schiene();
}


module ansicht() {
    translate([(stand_tot_x - schiene_tot_z) / 2,
               (stand_tot_y - schiene_tot_y) / 2,
               0])
        schiene_aufgestellt();
    stand();
}

module druck() {
    translate([schiene_tot_y + 2, 0, 0])
        stand();
    
    translate([schiene_tot_y, 0, 0])
        rotate([0, 0, 90])
            schiene();
}

//ansicht();
druck();
