void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  fill(255);
  noStroke();
  rect(0, 0, width, 200);
  rect(0, height-130, width, 130);
  fill(255, 0, 0);
  textSize(32);
  textAlign(LEFT);
  text("cars passed: " + passCount, 20, 100);
  stroke(0, 255, 0);
  line(passThreshold, height-130, passThreshold, height);
  noStroke();
  noFill();



  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(3);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs && (b.w*width > 100) && (b.w*height > 65) && (b.yMin*height > 200) && ((b.yMin*height + b.h*height) < (height - 130))) {
        strokeWeight(2);
        stroke(255, 0, 0);
        fill(255, 0, 0);
        textSize(32);
        textAlign(CENTER, BOTTOM);
        int blobX = int(b.xMin*width + (b.w*width/2));
        text(blobX, b.xMin*width + (b.w*width/2), b.yMin*height - 10);
        noFill();
        //rect(xpos of left edge, ypos of top edge, width of blob, height of blob);
        rect(b.xMin*width, b.yMin*height, b.w*width, b.h*height);

        //booleans
        if (blobX < passThreshold) {
          blobOnLeft = true;
          fill(0, 255, 0);
          noStroke();
          rect(0, height-130, passThreshold, 130);
          noFill();
        }

        if (blobX > width - passThreshold && blobOnLeft) {
          blobOnLeft = false;
          passCount++;
          println(passCount);
          fill(0, 255, 0);
          noStroke();
          rect(passThreshold, height-130, width - passThreshold, 130);
          noFill();
        }

        //boolean for background image that doesn't work
        if (b.w*width > 1) {
          somethingsThere = true;
        } else {
          somethingsThere = false;
        }
        if (somethingsThere = false) {
          backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
          backgroundImage.updatePixels();
          println("took a new picture");
        }
        ///end booleans
      }
    }
  }
}



// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img, int radius)
{
  if (radius<1) {
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
  int vmin[] = new int[max(w, h)];
  int vmax[] = new int[max(w, h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++) {
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++) {
    rsum=gsum=bsum=0;
    for (i=-radius;i<=radius;i++) {
      p=pix[yi+min(wm, max(i, 0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++) {

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if (y==0) {
        vmin[x]=min(x+radius+1, wm);
        vmax[x]=max(x-radius, 0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++) {
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for (i=-radius;i<=radius;i++) {
      yi=max(0, yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++) {
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if (x==0) {
        vmin[y]=min(y+radius+1, hm)*w;
        vmax[y]=max(y-radius, 0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }
}

