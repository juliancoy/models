$fn = 30;
module tapered_cube(dim, center=true){
    w_top = dim[0];
    d_top = dim[1];
    w_bot = dim[2];
    d_bot = dim[3];
    h     = dim[4];
    dw = w_bot - w_top;
    dd = d_bot - d_top;
    
    CubePointsNonCenter = [
      [  0,     0,      0 ],  //0
      [ w_bot,  0,      0 ],  //1
      [ w_bot,  d_bot,  0 ],  //2
      [  0,     d_bot,  0 ],  //3
      [ dw/2,          dd/2,      h ],  //4
      [ w_top + dw/2,  dd/2,      h ],  //5
      [ w_top + dw/2,  d_top + dd/2,  h ],  //6
      [ dw/2,          d_top + dd/2,  h ]]; //7
    
    CubePointsCenter = [
      [ -w_bot/2, -d_bot/2,     -h/2 ],  //0
      [  w_bot/2, -d_bot/2,     -h/2 ],  //1
      [  w_bot/2,  d_bot/2,     -h/2 ],  //2
      [ -w_bot/2,  d_bot/2,     -h/2 ],  //3
      [ -w_top/2, -d_top/2,      h/2 ],  //4
      [  w_top/2, -d_top/2,      h/2 ],  //5
      [  w_top/2,  d_bot/2,      h/2 ],  //6
      [ -w_top/2,  d_bot/2,      h/2 ]]; //7
      
    CubePoints = center ? CubePointsCenter : CubePointsNonCenter;
   
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
    dims = dim;
    polyhedron( CubePoints, CubeFaces );
}
//tapered_cube([228.8/2, 139.6/2, 220.8, 130.2, 210.1]);

module rounded_cube(d,r=3,center=true) {
    minkowski() {
        ca = center ? 0 : 2*r;
        ct = center ? 0 : r;
        
        translate([ct,ct]) cube([d[0]-ca, d[1]-ca, d[2]-ca], center=center);
        sphere(r);
    }
}


module pos_hemi(dims){
    translate([0,-dims[1]/2,0])
        cube([dims[0],dims[1],dims[2]]);
}
module pn_hemi(size = 300){
    translate([00,-size/2,-size/2])
        cube([size,size,size]);
}


module reenforced_case(dims, inner=10, outer=20, center=true){
    dim = dims;
    w_top = dim[0];
    d_top = dim[1];
    w_bot = dim[0];
    d_bot = dim[1];
    h     = dim[2];
    dw = w_bot - w_top;
    dd = d_bot - d_top;
    
    CubePointsNonCenter = [
      [  0,     0,      0 ],  //0
      [ w_bot,  0,      0 ],  //1
      [ w_bot,  d_bot,  0 ],  //2
      [  0,     d_bot,  0 ],  //3
      [ dw/2,          dd/2,      h ],  //4
      [ w_top + dw/2,  dd/2,      h ],  //5
      [ w_top + dw/2,  d_top + dd/2,  h ],  //6
      [ dw/2,          d_top + dd/2,  h ]]; //7
    
    CubePointsCenter = [
      [ -w_bot/2, -d_bot/2,     -h/2 ],  //0
      [  w_bot/2, -d_bot/2,     -h/2 ],  //1
      [  w_bot/2,  d_bot/2,     -h/2 ],  //2
      [ -w_bot/2,  d_bot/2,     -h/2 ],  //3
      [ -w_top/2, -d_top/2,      h/2 ],  //4
      [  w_top/2, -d_top/2,      h/2 ],  //5
      [  w_top/2,  d_bot/2,      h/2 ],  //6
      [ -w_top/2,  d_bot/2,      h/2 ]]; //7
      
    CubePoints = center ? CubePointsCenter : CubePointsNonCenter;
   
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
    
    faceCount = 6; // 6 faces on a cube
    for(i = [0:faceCount-1]){
        echo("i");
        echo(i);
        face = CubeFaces[i];
        echo("face");
        echo(face);
        vertPerFace = 4;
        for(vi = [0:vertPerFace-1]){
            v = CubePoints[face[vi]];
            translate(v)
            rounded_cube([outer,outer,outer]);
            hull(){
                v = CubePoints[face[vi]];
                translate(v)
                rounded_cube([inner,inner,inner]);
                v2 = CubePoints[face[(vi + 1) % vertPerFace]];
                translate(v2)
                rounded_cube([inner,inner,inner]);
            }
        }
    
    }
}

module prism(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
   /*
   // preview unfolded (do not include in your function
   z = 0.08;
   separation = 2;
   border = .2;
   translate([0,w+separation,0])
       cube([l,w,z]);
   translate([0,w+separation+w+border,0])
       cube([l,h,z]);
   translate([0,w+separation+w+border+h+border,0])
       cube([l,sqrt(w*w+h*h),z]);
   translate([l+border,w+separation+w+border+h+border,0])
       polyhedron(
               points=[[0,0,0],[h,0,0],[0,sqrt(w*w+h*h),0], [0,0,z],[h,0,z],[0,sqrt(w*w+h*h),z]],
               faces=[[0,1,2], [3,5,4], [0,3,4,1], [1,4,5,2], [2,5,3,0]]
               );
   translate([0-border,w+separation+w+border+h+border,0])
       polyhedron(
               points=[[0,0,0],[0-h,0,0],[0,sqrt(w*w+h*h),0], [0,0,z],[0-h,0,z],[0,sqrt(w*w+h*h),z]],
               faces=[[1,0,2],[5,3,4],[0,1,4,3],[1,2,5,4],[2,0,3,5]]
               );
               */
   }
       
e = 0.01;
module snapCellSingle(cellwidth = 5, cellLength = 10, height = 10){
    halffactor = 16;
    halfgrip = cellLength/halffactor;
    translate([-cellwidth/2,0,0])
    cube([cellwidth/2,cellLength/2,height]);
    translate([0,-halfgrip+e,-e])
    rotate([0,-90,0])
    prism(height-e,halfgrip,cellwidth/2);
}

module snapCellInverse(cellwidth = 5, cellLength = 10, height = 10){
    sf = 1.1;
    translate([-e,-e,-e])
    rotate([0,0,180])
    scale([sf,sf,sf])
        snapCellSingle(cellwidth,cellLength,height);
    
}

module radialSnap(cellwidth= 10, cellLength = 20, height = 10, smooth=false){
    snapCellSingle(cellwidth, cellLength, height);
    difference(){
        //rotate([0,0,180]){
        pos_hemi([cellwidth, cellLength, height]);
        snapCellInverse(cellwidth, cellLength, height);
    }

}

module RadialSnapArrayFemale(radius = 2.3,
    count = 6,
    cellwidth= 8,
    cellLength = 5,
    height = 2.2,
    smooth=false){
     for(i = [0: 360/count: 360]){
         rotate([i,0,0])
         translate([0, radius, -height/2])
            radialSnap(cellwidth,cellLength, height);  
     }
}
module RadialSnapArrayMale(radius = 2.3,
    count = 6,
    cellwidth= 8,
    cellLength = 5,
    height = 2.2,
    smooth=false){
     for(i = [0: 360/count: 360]){
         rotate([i,0,0])
         translate([0, -radius, -height/2])
            radialSnap(cellwidth,cellLength, height);  
     }
}

module SmoothRadialSnapArray(radius = 30,
        count = 8,
        cellwidth= 40,
        cellLength = 30,
        height = 15){
    minkowski() {
        
        RadialSnapArray(radius = radius, count = count, cellwidth= cellwidth,  cellLength = cellLength, height = height);
        sphere(2);
    }
}

module ffBar100(){
    translate([100/2,0,0])
    rotate([0,90,0])
    cylinder(h = 90, r = 5, center=true);
    RadialSnapArrayFemale();
    translate([100,0,0])
    rotate([0,0,180])
    RadialSnapArrayFemale();
    
}
module ffBar10(h = 10){
    translate([h/2,0,0])
    rotate([0,90,0])
    cylinder(h = h*.4, r = 5, center=true);
    RadialSnapArrayFemale();
    translate([h,0,0])
    rotate([0,0,180])
    RadialSnapArrayFemale();
    
}
//ffBar100();

module jack100(){
    rotate([0,90,0])
    cylinder(h = 8, r = 5, center=true);
    translate([-10,0,0])
    RadialSnapArrayMale();
}

module jack100_3way(){
    jack100();
    rotate([0,90,0])
    jack100();
    rotate([0,0,90])
    jack100();
}

scale([3, 3, 3])
ffBar10();
//jack100_3way();

module snapPlane(){
    sh = 20;
    cellwidth= 5;
    for(i = [0: cellwidth:30]){
        translate([i,0,0])
        snapCell1D(cellwidth,sh);
    }
}
//snapPlane();

module tapered_rounded_cube(dim,r) {
    dim = dim - [2*r, 2*r, 2*r, 2*r, 2*r];
    echo("TRC");
    /*
    for (d = [0:len(dim)]){
        echo(d);
        dim[d] = dim[d] - 2*r;
    }*/
    minkowski() {
        
        translate([r,r]) tapered_cube(dim);
        sphere(r);
    }
}

module hollowed_tapered_rounded_cube(dim,r,thickness = 3){
    t = thickness;
    dim_thick = dim + [2*t, 2*t, 2*t, 2*t, 2*t];
    difference(){
        translate([-t,-t,-t])
        tapered_rounded_cube(dim_thick,r);
        tapered_cube(dim);
    }
}
//hollowed_tapered_rounded_cube([200,300,100,200,300], 5, 10);
