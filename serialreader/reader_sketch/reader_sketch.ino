// Example 15.2

int data1 = 0;
int ok=-1;
// define the tag numbers that can have access
int yellowtag[14] = {  50,3,2,49,48,48,53,67,68,54,50,57,65,50}; //  my yellow tag. Change this to suit your own tags, use example 15.1 sketch to read your tags
int redtag[14] = {  2,51,67,48,48,67,67,51,69,69,51,50,68,3}; // my red tag...
int newtag[14] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}; // used for read comparisons
int okdelay = 500; // this is the time the output will be set high for when an acceptable tag has been read
int notokdelay = 500; // time to show no entry (red LED)
void setup()
{
  Serial.flush(); // need to flush serial buffer, otherwise first read from reset/power on may not be correct
  pinMode(3, OUTPUT); // this if for "rejected" LED
  pinMode(4, OUTPUT); // this will be set high when correct tag is read. Use to switch something on, for now - an LED. 
  Serial.begin(9600); // for debugging
}

boolean comparetag(int aa[14], int bb[14])
//  compares two arrrays, returns true if identical - good for comparing tags
{
  boolean ff=false;
  int fg=0;
  for (int cc=0; cc<14; cc++)
  {
    if (aa[cc]==bb[cc])
    {
      fg++;
    }
  }
  if (fg==14)
  {
    ff=true;
  }
  return ff;
}

void checkmytags()
//compares each tag against the tag just read
{
  ok=0; // this variable helps decision making, if it is 1, we have a match, zero - a read but no match, -1, no read attempt made
  if (comparetag(newtag,yellowtag)==true)
  {
    ok++;
  }
  if (comparetag(newtag,redtag)==true)
  {
    ok++;
  }
}

void readTag() 
// poll serial port to see if tag data is coming in (i.e. a read attempt)
{
  ok=-1;
  if (Serial.available() > 0) // if a read has been attempted
  {
    // read the incoming number on serial RX
    delay(100);  // Needed to allow time for the data to come in from the serial buffer. 
    for (int z=0; z<14; z++) // read the rest of the tag
    {
      data1=Serial.read();
      newtag[z]=data1;
      Serial.println(data1);
    }
    Serial.flush(); // stops multiple reads
    // now to match tags up
    checkmytags(); // compare the number of the tag just read against my own tags' number
  }
  //now do something based on tag type
  if (ok>0==true) // if we had a match
  {
    digitalWrite(4, HIGH);
    
    delay(okdelay);
    digitalWrite(4, LOW);
    ok=-1;
  } 
  else if (ok==0) // if we didn't have a match
  {
    digitalWrite(3, HIGH);
    
    delay(notokdelay);
    digitalWrite(3, LOW);
    ok=-1;
  }
}

void loop()
{
  readTag(); // we should create a function to take care of reading tags, as later on 
  // we will want other things to happen while waiting for a tag read, such as 
  // displaying data on an LCD, etc
}


