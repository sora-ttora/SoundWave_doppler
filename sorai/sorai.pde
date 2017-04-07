import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;
AudioInput in;
FFT         fftOut;
FFT         fftIn;

float step = 8.0;

void setup() {
  size(512, 200, P3D);

  minim = new Minim(this);
  out = minim.getLineOut();
  in = minim.getLineIn();
  
  
  fftOut = new FFT( out.bufferSize(), out.sampleRate() );
  fftIn = new FFT( in.bufferSize(), out.sampleRate() );
  
   out.playNote(0.0,1000, 15000);
}
void draw() {
  background(0);
  
  fftOut.forward( out.mix );
  fftIn.forward( in.mix );

  for (int i = 330; i < 370; i++)
  {
    
    stroke(255,150);
    line( i, height, i, height - (fftOut.getBand(i))*8 );
    
    stroke(255,255,0,150);
    line( i-100, height, i-100, height - (fftIn.getBand(i))*8*step );
    
    if((fftOut.getBand(i)-fftIn.getBand(i)*step)<0) {
    stroke(255,0,0,150);
    line( i-200, height, i-200, height - ((fftIn.getBand(i)*step)-fftOut.getBand(i))*8 );
    }
    else {
      stroke(0,0,255,150);
    line( i-200, height, i-200, height - ((fftOut.getBand(i)-fftIn.getBand(i)*step))*8 );
    }
  }
}