# cpsc
Adventure game written in pdp-11 assembly. I wrote this in college in 1989. Martin Zimmerman wrote the parse routines! The map was based on the layout of the computer science ground floor. You had to become super user and reboot the vax to win.

![img](https://github.com/kjs452/cpsc/blob/main/kenpdp11.jpg "Me with the PiDP-11")

Me, showing off the Rasberry Pi based kit that looks like a PDP-11 front panel. It is called the PiDP-11.
[https://obsolescence.wixsite.com/obsolescence/pidp-11]

# MAP
![img](https://github.com/kjs452/cpsc/blob/main/cpsc_map_all.jpg "CPSC map")

# PUZZLES
1. Go to continious tutorial room to get "help". Learn the goal of game.
2. Ask professor. Learn that he needs to be paid. Get coin and ask him again. He tells you about Dave
(the super user) who does not allow food or drink in the terminal rooms.
3. The next puzzle is dropping a beverage in the VAXA termainal room. Which causes DAVE to leave
his office and show up where the drink was dropped.
4. Now you can get the machine room key from Dave's office.
5. In the machine room is the root password, you must now find a terminal.
6. Last puzzle, you find a terminal and login as root and reboot the vax.

# Walkthrough
I got this code working again by porting it to BSD 2.11 running under SIMH. Whew...
Anyway, here is the game play walkthrough.

```
This program recognizes the following commands:
    go,move,get,put,take,drop,help*,login*,ask*,read*
    drink,eat,look,wait,inventory,score and quit.
Use north,south,east or west to move instead of go.
NOTE: * denotes an important command.

You are outside the CPSC floor. To enter the
terminal rooms, go west.
A math271 text is here.

Well? help
Ask Theo Deraadt, or go to the continous tutorial for help.
Talking to anyone else could be risky.

Well? take math271
math271 text taken.

Well? read math

Sorry this book is in greek.


Well? invent
Your U of C bag contains the following:
math271 text


Well? score
Your decimal score is: +00120

Well? l
You are outside the CPSC floor. To enter the
terminal rooms, go west.

Well? w
This is a small north-south hallway. To the north are some
locked glass doors. An opening to the east leads outside.

Well? s
This is the comm-media room. A single exit goes north.

Well? n
This is a small north-south hallway. To the north are some
locked glass doors. An opening to the east leads outside.

Well? w
This is the start of a long east-west hallway. To the west
are some glass doors. To the north is a large terminal room.

Well? w
This is part of a long east-west hallway. You can hear
loud rumbling noise to the north.
A jolt is here.

Well? take jolt
jolt taken.

Well? drink jolt
The drink clears your head.

Well? read jolt

Not available for reading.


Well? invent
Your U of C bag contains the following:
math271 text


Well? s
You are in the advanced graphics lab. There is a single un-watched
iris termial here. Other terminials are doing ray-tacing stuff.
An exit goes north.

Well? n
This is part of a long east-west hallway. You can hear
loud rumbling noise to the north.

Well? n
The machine room is locked. A key is required.

Well? w
You are in part of a long east-west hallway. Exits lead
north and south.
A proffesor is here.

Well? ask proffesor

The proffesor says:
    'Good help is hard to find. It is even worth
    paying for...'


Well? take prof
You cannot get the proffesor!

Well? kill prod
Invalid CPSC operation.

Well? look
You are in part of a long east-west hallway. Exits lead
north and south.

Well? s
You are in the develnet terminal room. There are
several terminals hooked up to develet here.
A rs232 cable is here.

Well? read rs232

The cable says 'AMP' on the side.


Well? take rs232
rs232 cable taken.

Well? n
You are in part of a long east-west hallway. Exits lead
north and south.

Well? w
You are in part of a long east-west hallway. Exits lead
north and south.

Well? s
This is the senior logic lab. You see strange hardware
creations here. A door leads north.

Well? n
You are in part of a long east-west hallway. Exits lead
north and south.

Well? w
This is part of a long east-west hallway.

Well? s
This is the hardware technical support office. a
large door is on the north wall.

Well? n
This is part of a long east-west hallway.

Well? n
You are in the Electronics Lab. A door leads west. There
is an exit south. There is a lot of stuff here.

Well? s
This is part of a long east-west hallway.

Well? w
This is part of a long east-west hallway, with a
large door to the south. The sign on the door says 'DAVE'.
A super user is here.

Well? ask super

The super user exlaims:
   'Hi, Im preventing you from entering!'

Well? take super
You cannot get the super user!

Well? s
The super-user blocks your way!

Well? look
This is part of a long east-west hallway, with a
large door to the south. The sign on the door says 'DAVE'.
A insane hacker is here.
A super user is here.

Well? ask insane hacker

The insane hacker mumbles:
    'Dave keeps a key to the machine room
    in his office.'

Well? look
This is part of a long east-west hallway, with a
large door to the south. The sign on the door says 'DAVE'.
A super user is here.

Well? w
You are at the end of a great east-west hallway. To the
north is a small terminal room.
A sev is here.

Well? read sev

The seven eleven slurpie has nothing on it to read.


Well? take sev
sev taken.

Well? w
You are in the CSUS lounge. A Coke machine attracts you attention.
You notice an exit north and east.
A coke is here.

Well? read coke

The can says Coke.


Well? take coke
coke taken.

Well? n
You are in a north-south hallway, to the west
leads to the CSUS office.

Well? w
You are in a small corridor just outside the CSUS office.
A hallway goes to the east. To the north is the office.

Well? n
This is the CSUS office. Notice the artwork. A
doorway out leads to the south.
A coin is here.

Well? take coin
coin taken.

Well? read coin

The coin reads like an other 50 cent piece.


Well? look
This is the CSUS office. Notice the artwork. A
doorway out leads to the south.

Well? s
You are in a small corridor just outside the CSUS office.
A hallway goes to the east. To the north is the office.

Well? e
You are in a north-south hallway, to the west
leads to the CSUS office.

Well? n
You are in the disabled students computer lab. There is
a single exit south.

Well? s
You are in a north-south hallway, to the west
leads to the CSUS office.

Well? e
You are at the end of a long east-west hallway.
An opening to the north leads to a small room. To the
south is a slightly large room.

Well? n
This is the 504 Lab. Not much here, except a door on
the south wall.

Well? s
You are at the end of a long east-west hallway.
An opening to the north leads to a small room. To the
south is a slightly large room.

Well? s
You have entered the Micro Computer Lab. Rows of 6502 based
machines are here. An exit goes north.
A disk is here.

Well? take disk
disk taken.

Well? read disk

non-dos disk. Error reading disk. Want to format it?


Well? score
Your decimal score is: +00353


Well? invent
Your U of C bag contains the following:
coin
math271 text
coke
sev
disk
rs232 cable


Well? look
You have entered the Micro Computer Lab. Rows of 6502 based
machines are here. An exit goes north.

Well? n
You are at the end of a long east-west hallway.
An opening to the north leads to a small room. To the
south is a slightly large room.

Well? e
You are in part of a long east-west hallway. Exits lead
north and south.

Well? n
This is the men's wash room. There is nothing here
but urinals. Wash your hands? A door is on the south wall.

Well? s
You are in part of a long east-west hallway. Exits lead
north and south.

Well? s
You are in the women's bathroom. Unlike the men's bathroom
this room is spotlessly clean. A door is on the north wall.

Well? n
You are in part of a long east-west hallway. Exits lead
north and south.

Well? e
You are in an open hallway, with elevators to the south
There are glass doors to east. North leads out.

Well? n
You have wandered out into the university campus.
Go south to re-enter the CPSC floor.

Well? s
You are in an open hallway, with elevators to the south
There are glass doors to east. North leads out.

Well? s
This is the north-south hallway. To the east is a
Electronics lab.

Well? n
You are in an open hallway, with elevators to the south
There are glass doors to east. North leads out.

Well? e
You are in a East-West hallway, with glass doors to the west.
Passages go north and south.

Well? n
This is the junior logic lab. There are wires and chips
everywhere. A large door is on the south wall.
A z80 cpu is here.
A dart is here.

Well? read z80

The LSI chip has printed on it: Zilog Z80CPU


Well? read dart

The LSI chip has Zilog printed on it.


Well? take dart
dart taken.

Well? take z80
z80 cpu taken.

Well? score
Your decimal score is: +00504


Well? look
This is the junior logic lab. There are wires and chips
everywhere. A large door is on the south wall.

Well? s
You are in a East-West hallway, with glass doors to the west.
Passages go north and south.

Well? s
You are in the sun terminal room. Someone has forgot
to logout. There is an exit north and south.
A sun terminal is here.

Well? read sun

The screen has snakes moving across the screen.


Well? eat sun
You can't eat what you do not have.

Well? drink sun
You don't have that.

Well? take sun
You cannot get the sun terminal!

Well? login
You are unable to login here.


Well? look
You are in the sun terminal room. Someone has forgot
to logout. There is an exit north and south.
A sun terminal is here.

Well? n
You are in a East-West hallway, with glass doors to the west.
Passages go north and south.

Well? e
You are in part of a long east-west hallway. Exits lead
north and south.

Well? n
You have entered into the graphics terminal room.
To the south is an exit. A V550 is drawing stuff.
A v550 terminal is here.

Well? login
You are unable to login here.


Well? read v550

You see an rwho of the vax's.
It does not appear as though dave is logged in.


Well? look
You have entered into the graphics terminal room.
To the south is an exit. A V550 is drawing stuff.
A v550 terminal is here.

Well? a

I don't know how to ask that thing!

Well? s
You are in part of a long east-west hallway. Exits lead
north and south.

Well? s
This is the VAXD terminal room. To the north is an exit.
There is an exit south. There are z80 designs on the chalk
board.
A vt102 terminal is here.

Well? read vt102

The screen has a login banner:

University of Calgary  4.2 BSD Unix    [vaxd)

login:


Well? login
University of Calgary    4.2 BSD  Unix       [vaxd]

login: root

password: dsfsfsd

login incorrect.

Well? login
University of Calgary    4.2 BSD  Unix       [vaxd]

login: ken

user not found.

Well? look
This is the VAXD terminal room. To the north is an exit.
There is an exit south. There are z80 designs on the chalk
board.
A vt102 terminal is here.

Well? n
You are in part of a long east-west hallway. Exits lead
north and south.

Well? e
You are in a hallway just outside the tutorial room. To the
south you can here a chattering sound.

Well? n
You are in the continous tutorial room. The
ambassador terminal was left in csh. A single exit
goes south.
A ambassador terminal is here.

Well? read ambassador

Not available for reading.


Well? read ambassador

The screen shows a csh prompt.


Well? login
You are unable to login here.


Well? look
You are in the continous tutorial room. The
ambassador terminal was left in csh. A single exit
goes south.
A ambassador terminal is here.

Well? s
You are in a hallway just outside the tutorial room. To the
south you can here a chattering sound.

Well? s
You are in a small room with a printer here. It is
faithfully printing away. A small door is on the north wall.
A printout is here.

Well? take printout
printout taken.

Well? read printout

Part of the print out reads as follows:
The vax can only be REBOOTed by root. Roots password
is ##########.
The ### text is scratched off.


Well? n
You are in a hallway just outside the tutorial room. To the
south you can here a chattering sound.

Well? reboot
That command does not operate yet.

Well? invet
Invalid CPSC operation.

Well? inv
Your U of C bag contains the following:
coin
math271 text
coke
sev
z80 cpu
dart
printout
disk
rs232 cable


Well? score
Your decimal score is: +00555


Well? e
You are in a huge terminal room. (vaxa)
Shhh, some 211'ers are sleeping here. Exits go south
east and west.
A pascal text is here.

Well? take pascal
pascal text taken.

Well? read pascal

The book says: Adventure written by Ken Stauffer.


Well? look
You are in a huge terminal room. (vaxa)
Shhh, some 211'ers are sleeping here. Exits go south
east and west.
A proffesor is here.

Well? ask proffesor

The happy proffesor takes your coin, smiles and says:
    'Super users don't allow food or DRINK in the
     terminal rooms...'


Well? look
You are in a huge terminal room. (vaxa)
Shhh, some 211'ers are sleeping here. Exits go south
east and west.

Well? s
This is the VAXC terminal room. There is an exit
to the north and south. There are rows of VT102's here.
A pdp-11 text is here.
A proffesor is here.

Well? ask proffesor

The proffesor says:
    'Good help is hard to find. It is even worth
    paying for...'


Well? read pdp-11

The book says: 'PDP-11 assembly programming'


Well? take pdp-11
pdp-11 text taken.

Well? look
This is the VAXC terminal room. There is an exit
to the north and south. There are rows of VT102's here.
A proffesor is here.

Well? n
You are in a huge terminal room. (vaxa)
Shhh, some 211'ers are sleeping here. Exits go south
east and west.

Well? e
This is a small north-south hallway. To the north are some
locked glass doors. An opening to the east leads outside.

Well? w
This is the start of a long east-west hallway. To the west
are some glass doors. To the north is a large terminal room.

Well? n
This is the VAXC terminal room. There is an exit
to the north and south. There are rows of VT102's here.

Well? n
You are in a huge terminal room. (vaxa)
Shhh, some 211'ers are sleeping here. Exits go south
east and west.

Well? drop coke
coke has been set down.

Well? look
You are in a huge terminal room. (vaxa)
Shhh, some 211'ers are sleeping here. Exits go south
east and west.
A coke is here.
A super user is here.

Well? ask super

The super user exlaims:
   'Hi, Im preventing you from entering!'

Well? s
This is the VAXC terminal room. There is an exit
to the north and south. There are rows of VT102's here.

Well? s
This is the start of a long east-west hallway. To the west
are some glass doors. To the north is a large terminal room.

Well? w
This is part of a long east-west hallway. You can hear
loud rumbling noise to the north.

Well? w
You are in part of a long east-west hallway. Exits lead
north and south.

Well? w
You are in part of a long east-west hallway. Exits lead
north and south.

Well? w
This is part of a long east-west hallway.

Well? w
This is part of a long east-west hallway, with a
large door to the south. The sign on the door says 'DAVE'.

Well? s
This is dave's office. An exit lies to the North.
There is a large terminal here. You don't see Dave so you
don't mind snooping.
A key is here.

Well? look key
This is dave's office. An exit lies to the North.
There is a large terminal here. You don't see Dave so you
don't mind snooping.
A key is here.

Well? take key
key taken.

Well? inv
Your U of C bag contains the following:
key
pascal text
pdp-11 text
math271 text
sev
z80 cpu
dart
printout
disk
rs232 cable


Well? read printout

Part of the print out reads as follows:
The vax can only be REBOOTed by root. Roots password
is ##########.
The ### text is scratched off.


Well? n
This is part of a long east-west hallway, with a
large door to the south. The sign on the door says 'DAVE'.

Well? e
This is part of a long east-west hallway.

Well? e
You are in part of a long east-west hallway. Exits lead
north and south.

Well? e
You are in part of a long east-west hallway. Exits lead
north and south.

Well? e
This is part of a long east-west hallway. You can hear
loud rumbling noise to the north.

Well? n
You are in the machine room. The vax's are all here.
The loud rumble of machinery can be heard.
A large iron door is on the south wall.
A password is here.
A vax 11/780 is here.

Well? take password
password taken.

Well? score
Your decimal score is: +00936


Well? take vax
You cannot get the vax 11/780!

Well? reboot
That command does not operate yet.

Well? login
You are unable to login here.


Well? read password

The password says: &sde!p5


Well? invent
Your U of C bag contains the following:
key
password
pascal text
pdp-11 text
math271 text
sev
z80 cpu
dart
printout
disk
rs232 cable


Well? score
Your decimal score is: +00936


Well? s
This is part of a long east-west hallway. You can hear
loud rumbling noise to the north.

Well? w
You are in part of a long east-west hallway. Exits lead
north and south.

Well? n
This is the VAXD terminal room. To the north is an exit.
There is an exit south. There are z80 designs on the chalk
board.
A vt102 terminal is here.

Well? n
You are in part of a long east-west hallway. Exits lead
north and south.

Well? e
You are in a hallway just outside the tutorial room. To the
south you can here a chattering sound.

Well? n
You are in the continous tutorial room. The
ambassador terminal was left in csh. A single exit
goes south.
A ambassador terminal is here.

Well? login
You are unable to login here.


Well? s
You are in a hallway just outside the tutorial room. To the
south you can here a chattering sound.

Well? w
You are in part of a long east-west hallway. Exits lead
north and south.

Well? n
You have entered into the graphics terminal room.
To the south is an exit. A V550 is drawing stuff.
A v550 terminal is here.

Well? login
You are unable to login here.


Well? s
You are in part of a long east-west hallway. Exits lead
north and south.

Well? s
This is the VAXD terminal room. To the north is an exit.
There is an exit south. There are z80 designs on the chalk
board.
A vt102 terminal is here.

Well? login
University of Calgary    4.2 BSD  Unix       [vaxd]

login: root

password: &sde!p5

% ls

command not found.
% logout


Well? login
University of Calgary    4.2 BSD  Unix       [vaxd]

login: root

password: &sde!p5

% reboot

.... now re-booting ....
All the terminals display garbage on the screen.
Congradulations you have reset the VAX you WIN!!!!
&%#$%')&%$%''%&%$%&$TYFYT&%GF(&%F&((&%F%&~~~~~~

```
