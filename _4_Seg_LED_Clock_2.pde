// This clock engine is based of of code from nootropicdesign.com - thanks!
// Jeremy Saglimbeni 2011 - thecustomgeek.com
// These are indexes into the groundPins array
#define MIDDLE 0 // G
#define UPPER_L 1 // F
#define LOWER_L 2 // E
#define BOTTOM 3 // D
#define LOWER_R 4 // C
#define UPPER_R 5 // B
#define TOP 6 // A
// pin 13 is the colon between the hours and minutes
int groundPins[7] = {2, 3, 4, 5, 6, 7, 8}; // G, F, E, D, C, B, A
int digitPins[4] = {17, 18, 19, 16}; // positive voltage supply for each of the 4 digits --17 is RIGHT most digit--
int ON = HIGH; // HIGH for CA, LOW for CC
int OFF = LOW; // LOW for CA, HIGH for CC
int number[10][7]; // holds information about which segments are needed for each of the 10 numbers
int digit[4]; // holds values for each of the 4 display digits

int hours = 12;
int minutes = 00;
int elapsedMinutes = 0;
int seconds = 0;
int secon;
int hourset = 14;
int hoursetv = 0;
int minuteset = 15;
int minutesetv = 0;
int showsw = 12;
int showswv = 0;
unsigned long prevtime;
int showtime = 16380;
int delaytime = 200;
void setup()
{
  digitalWrite(13, HIGH);
  pinMode(hourset, INPUT);
  pinMode(minuteset, INPUT);
  pinMode(showsw, INPUT);
  digitalWrite(hourset, HIGH);
  digitalWrite(minuteset, HIGH);
  digitalWrite(showsw, HIGH);
  initNumber();
  for(int i=0; i < 7; i++) {
    pinMode(groundPins[i], OUTPUT);
    digitalWrite(groundPins[i], HIGH); // HIGH for CA, LOW for CC
  }
  for(int i=0; i < 4; i++) {
    pinMode(digitPins[i], OUTPUT);
    digitalWrite(digitPins[i], LOW); // LOW for CA, HIGH for CC
  }
}

void loop() {
  int n = 0;
  unsigned long time = millis() - (elapsedMinutes * 60000);
  seconds = (time / 1000);
  if (seconds > 60) {
    seconds = 0;
    minutes++;
    elapsedMinutes++;
    if (minutes >= 60) {
      minutes = 0;
      hours++;
      if (hours > 12) {
        hours = 1;
      }
    }
  }
  n = (hours * 100) + minutes;
  setDigit(n);

  for(int g=0; g < 7; g++) {
    digitalWrite(groundPins[g], LOW); // LOW for CA, HIGH for CC
    for(int i=0; i < 4; i++) {
      if (digit[i] < 0) {
        continue;
      }
      digitalWrite(digitPins[i], number[digit[i]][g]);
    }
    getDelay(); // delay multiplexing function
    digitalWrite(groundPins[g], HIGH); // HIGH for CA, LOW for CC
  }
  if (time - prevtime > 500) { // toggle a second flag to blink the colon
    prevtime = time;
    if (secon == 1) {
      secon = 0;
      return;
    }
    if (secon == 0) {
      secon = 1;
      return;
    }
  }
if (secon == 1) {
  digitalWrite(13, HIGH);
}
if (secon == 0) {
  digitalWrite(13, LOW);
}
hoursetv = digitalRead(hourset); // hour set button
if (hoursetv == LOW) {
hours++;
delay(40);
if (hours > 12) {
  hours = 1;
}
}
minutesetv = digitalRead(minuteset); // minute set button
if (minutesetv == LOW) {
minutes++;
delay(40);
if (minutes > 59) {
  minutes = 0;
}
}
showswv = digitalRead(showsw); // button to slow the multiplexing down
if (showswv == LOW) {
showtime = 16380;
delaytime = 200;
}
}

void setDigit(int n) {
  n = n % 2000;
  digit[0] = n % 10;
  digit[1] = (n / 10) % 10;
  if ((digit[1] == 0) && (n < 10)) {
    digit[1] = -1;
  }
  digit[2] = (n / 100) % 10;
  if ((digit[2] == 0) && (n < 100)) {
    digit[2] = -1;
  }
  digit[3] = (n / 1000) % 10;
  if (digit[3] == 0) {
    digit[3] = -1;
  }
}

void getDelay() { //stutter the multiplexing refresh
  if (delaytime >= 7) {
  delay(delaytime);
  delaytime -= 1;
}
  if (delaytime < 7) {
  delayMicroseconds(showtime);
  showtime -= 35;
  if (showtime <= 1501) {
  showtime = 1500;
  }
  }
} 

void initNumber() {
  number[0][MIDDLE]  = OFF;
  number[0][UPPER_L] = ON;
  number[0][LOWER_L] = ON;
  number[0][BOTTOM]  = ON;
  number[0][LOWER_R] = ON;
  number[0][UPPER_R] = ON;
  number[0][TOP]     = ON;

  number[1][MIDDLE]  = OFF;
  number[1][UPPER_L] = OFF;
  number[1][LOWER_L] = OFF;
  number[1][BOTTOM]  = OFF;
  number[1][LOWER_R] = ON;
  number[1][UPPER_R] = ON;
  number[1][TOP]     = OFF;

  number[2][MIDDLE]  = ON;
  number[2][UPPER_L] = OFF;
  number[2][LOWER_L] = ON;
  number[2][BOTTOM]  = ON;
  number[2][LOWER_R] = OFF;
  number[2][UPPER_R] = ON;
  number[2][TOP]     = ON;

  number[3][MIDDLE]  = ON;
  number[3][UPPER_L] = OFF;
  number[3][LOWER_L] = OFF;
  number[3][BOTTOM]  = ON;
  number[3][LOWER_R] = ON;
  number[3][UPPER_R] = ON;
  number[3][TOP]     = ON;

  number[4][MIDDLE]  = ON;
  number[4][UPPER_L] = ON;
  number[4][LOWER_L] = OFF;
  number[4][BOTTOM]  = OFF;
  number[4][LOWER_R] = ON;
  number[4][UPPER_R] = ON;
  number[4][TOP]     = OFF;

  number[5][MIDDLE]  = ON;
  number[5][UPPER_L] = ON;
  number[5][LOWER_L] = OFF;
  number[5][BOTTOM]  = ON;
  number[5][LOWER_R] = ON;
  number[5][UPPER_R] = OFF;
  number[5][TOP]     = ON;

  number[6][MIDDLE]  = ON;
  number[6][UPPER_L] = ON;
  number[6][LOWER_L] = ON;
  number[6][BOTTOM]  = ON;
  number[6][LOWER_R] = ON;
  number[6][UPPER_R] = OFF;
  number[6][TOP]     = ON;

  number[7][MIDDLE]  = OFF;
  number[7][UPPER_L] = OFF;
  number[7][LOWER_L] = OFF;
  number[7][BOTTOM]  = OFF;
  number[7][LOWER_R] = ON;
  number[7][UPPER_R] = ON;
  number[7][TOP]     = ON;

  number[8][MIDDLE]  = ON;
  number[8][UPPER_L] = ON;
  number[8][LOWER_L] = ON;
  number[8][BOTTOM]  = ON;
  number[8][LOWER_R] = ON;
  number[8][UPPER_R] = ON;
  number[8][TOP]     = ON;

  number[9][MIDDLE]  = ON;
  number[9][UPPER_L] = ON;
  number[9][LOWER_L] = OFF;
  number[9][BOTTOM]  = ON;
  number[9][LOWER_R] = ON;
  number[9][UPPER_R] = ON;
  number[9][TOP]     = ON;
}
