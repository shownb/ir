
#include <stdio.h>
#include <wiringPi.h>


#define	pin	21
double halfPeriodicTime;

void enableIROut(int khz) {
  halfPeriodicTime = 500/khz;
  printf("%lf",halfPeriodicTime);
}

void mark(int duration)  {
    int startTime = millis();
    while (millis()-startTime < duration) {
          digitalWrite(pin, 1);
          delayMicroseconds(halfPeriodicTime);
          digitalWrite(pin, 0);
          delayMicroseconds(halfPeriodicTime);
    }

}

void space(int duration)  {
          digitalWrite(pin, 0);
          delayMicroseconds(duration);
}  

void sendRaw (unsigned int buf[], int len, int hz)
{
  printf("sendRaw");
  enableIROut(hz);
  int i=0;
  for (i = 0; i < len; i++) {
    if (i & 1) {
      space(buf[i]);
    } 
    else {
      mark(buf[i]);
    }
  }
  space(0); // Just to be sure
}

int main (void)
{
  wiringPiSetup () ;
  pinMode (pin,1) ;
  printf ("go\n") ;

  unsigned int rightbutton[23]=  {1033,551,604,1108,605,543,611,824,612,1101,613,539,615,535,619,1371,617,536,621,531,618,1094,621};

  sendRaw(rightbutton,23,38);

  return 0 ;
}
