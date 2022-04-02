
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
//reenforced_case([100,200,300]);


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
