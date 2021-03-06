public class Laser {

  LaserScan currentScan;
  float x, y, theta;

  Laser() {
    println("new laser!");
    rp.subscribe("/scan", this, "newScan");
  }


  Transform getMapToRobot(Time t) {
    return rp.lookupTransform("map", "base_link", t);
  }

  Transform getRobotToLaser()
  {
    return rp.lookupTransform("base_link", "laser_link");
  }


  public void newScan(LaserScan newScan) {

    if (newScan!=null) {

      println("new scan!");

      Transform robotToLaser = getRobotToLaser();
      Transform mapToRobotScan = getMapToRobot(newScan.getTime());
      Transform mapToLaserScan = Transform.combine(mapToRobotScan, robotToLaser);

      if (mapToLaserScan!=null) { 
        currentScan = newScan;

        x = mapToLaserScan.getTranslation().getX32();
        y =mapToLaserScan.getTranslation().getY32(); 
        theta = mapToLaserScan.getRotation().getYaw32();
      }
    }
  }

  void render() {
    if (currentScan!=null) {
      pushMatrix();
      translate(x, y);
      rotate(theta); 
      //fill(255, 0, 0);
      strokeWeight(1);
      stroke(255, 255, 255);
      float angle = currentScan.getAngleMin();
      beginShape();
      for (int i=0; i<currentScan.getRanges().length; ++i) {  
        //println(currentScan.getRanges()[i]);
        float xx = currentScan.getRanges()[i]*cos(angle);
        float yy = currentScan.getRanges()[i]*sin(angle);
        vertex(xx, yy, 0);
        angle+=currentScan.getAngleIncrement();
      }
      endShape();
      popMatrix();
    } else {
      fill(255, 0, 0);
      textSize(55);
      text("no laser yet", 100, 100);
    }
  }
}

