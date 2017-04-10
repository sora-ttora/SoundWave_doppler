import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

PImage img;
Minim minim;
AudioInput in;
AudioOutput out;
Oscil wave;
FFT fft;

float highestAmp=0, freq, frequency;
float amplitude;
float a;

void setup() {
  //size(512, 200);
  size(1024, 400);
  
  // initialize Minim and catching the output
  minim = new Minim(this);
  out = minim.getLineOut();
  in = minim.getLineIn(Minim.MONO, 4096, 44100);
  fft = new FFT(in.left.size(), 44100);
  
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  wave.patch( out );
  
  img = loadImage("hand.png");
}


void draw() {
  highestAmp=0;
  amplitude=0;
  frequency = 0;
  fft.forward(in.left);
  //searching from 0Hz to 20000Hz. getting the band, and from the band the frequency
  wave.setFrequency(18000);
  wave.setAmplitude(1);

  for (int i = 17000; i < 20000; i++) {
    amplitude = fft.getFreq(i);
    if (amplitude > 5) {
      if (amplitude > highestAmp) {
        highestAmp = amplitude;
        frequency = i;
        a = 180+(100*(180-(frequency/100)));
        println(i);
      }
    }
  }
  //write the frequency on the screen
  fill(0);
  background(255);
  text(frequency, 200, 100);
  fill(255);
  ellipse(width/2, height/2, 180, 180);
  //tint(255, 127);
  //fill(0);
  //println(a);
  tint(255, 127);
  image(img, width/2.5, height/3, a, a);
  //ellipse(width/2, height/2, a, a);
}