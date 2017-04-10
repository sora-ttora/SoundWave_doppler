import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;
AudioInput in;
FFT         fftOut;
FFT         fftIn;

int myBufferSize = 4096;
float mySampleRate = 44100.0;

float oldInFFT [] = new float [myBufferSize+1];

void setup() {
  size(512, 200, P3D);

  minim = new Minim(this);

  out = minim.getLineOut(Minim.MONO, myBufferSize, mySampleRate);
  in = minim.getLineIn(Minim.MONO, myBufferSize, mySampleRate);

  //println(out.sampleRate());
  fftOut = new FFT( out.bufferSize(), out.sampleRate() );
  fftIn = new FFT( in.bufferSize(), out.sampleRate() );

  out.playNote(0.0, 1000, 15000);
}
void draw() {
  background(0);

  fftOut.forward( out.mix );
  fftIn.forward( in.mix );

  int startFrq = 340*myBufferSize/1024;
  int endFrq = 358*myBufferSize/1024;
  int highestIn=startFrq;
  int highestOut=startFrq;
  for (int i = startFrq; i < endFrq; i++)
  {

    stroke(255, 150);
    line( i*1024/myBufferSize, height, i*1024/myBufferSize, height - (fftOut.getBand(i))*8 );

    stroke(255, 255, 0);
    line( i*1024/myBufferSize+60, height, i*1024/myBufferSize+60, height - (fftIn.getBand(i))*8 );

    if (fftOut.getBand(i)>fftOut.getBand(highestOut))
     highestOut=i;
     
    if (fftIn.getBand(i)>fftIn.getBand(highestIn))
     highestIn=i;
  }
//  println(highestOut);

  int mult=10;
  fill(255);
  rect(150, 50, (highestIn-highestOut)*mult, 100);
  fill(0, 50);
  rect(0, 0, width, height);
}