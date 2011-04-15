Instructions for running Unit Tests:

1. Install binaries for lua 5.0.2 rc2  ---   http://luaforge.net/frs/?group_id=110
2. Add the install directory to the PATH
3. Open a DOS prompt in Panza/UnitTests
4. Run test with >lua50 pa.test.lua

You should see:

 >>>>>> TestPA
.....................

Success : 100% - 22 / 22

each dot represents a successful test

If a test fails you will see something like:

>>>>>> TestPA
..F..................
>>> TestPA:test_Shaman4 FAILED
pa.test.lua:809: CycleBless:
expected: true
actual  : false

Success : 95% - 21 / 22

Ouput from PA that normally is displayed in-game in a message window is appended to a
global variable called WoWMock.Output.

You can set this back to an empty string when testing calls e.g.:

	WoWMock.Output = "";
	Result = PA:AutoResurrect();
	assertEquals(false, Result, "Rez");
	assertEquals("|cffffff40 State=solo#|cffffff40Checking player, count=0#", WoWMock.Output, "Rez Output");

Notice that newlines are replaced with #s for easier string comparisons.
If an assert fails with one of these multiline strings then each line will be displayed in a list to make it easier
to see what is going on e.g.

Lines:

1 A '|cffffff40Panic'
2 A '|cffffff40 State=bg'
3 A '|cffffff40 Name=Nesferatu'
4 A '|cffffff40 Class=MAGE'
5 A '|cffffff40 Health=91.904761904762% Limit=95% (+ Ramp of 0%)'
6 A '|cffffff40 Index=1'
7 A '|cffffff40 Weighting=3'
8 A '|cffffff40 Name=Blodrazer'
9 A '|cff66cc33Target is not in Visable Range'
10 A '|cffffff40CheckTarget failed OutOfRange'
11 A '|cffffff40 Name=Tompif'
12 A '|cffffff40 Class=PRIEST'
13 A '|cffffff40 Health=95.181616011861% Limit=25% (+ Ramp of 0%)'
14 A '|cffffff40 Name=Capjim'
15 A '|cffffff40 Class=ROGUE'
16 A '|cffffff40 Health=94.050343249428% Limit=20% (+ Ramp of 0%)'
17 A '|cffffff40 Name=Dulaa'
18 A '|cffffff40 Class=MAGE'
19 A '|cffffff40 Health=99.411764705882% Limit=95% (+ Ramp of 0%)'
20 A '|cffffff40 Name=Mic'
21 A '|cffffff40 Class=DRUID'
22 A '|cffffff40 Health=100% Limit=20% (+ Ramp of 0%)'
23 A '|cffffff40 Name=Berginyon'
24 A '|cffffff40 Class=ROGUE'
25 A '|cffffff40 Health=100% Limit=20% (+ Ramp of 0%)'
26 A '|cffffff40 Name=Killhim'
27 A '|cff66cc33Target is not in Visable Range'
28 A '|cffffff40CheckTarget failed OutOfRange'
29 A '|cffffff40 Name=Ilnoa'
30 A '|cffffff40 Class=HUNTER'
31 A '|cffffff40 Health=100% Limit=20% (+ Ramp of 0%)'
31 E '|cffffff40Health=100% Limit=20% (+ Ramp of 0%)'
32 A '|cffffff40 Name=Smacker'
33 A '|cff66cc33Target is you'
34 A '|cffffff40 Class=PALADIN'
35 A '|cffffff40 Health=100% Limit=15% (+ Ramp of 0%)'
36 A '|cffffff40|cff66cc331|c00FFFFFF - |cff6666ffNesferatu (raid1) 3.0'
37 A '|cffffff40Top player to panic about Nesferatu (raid1) with weighting=3.0'
38 A '|cffffff40 BoP not up'
39 A '|cffffff40 Stage=1'
40 A '|cffffff40 BoP is ready'
41 A 'ClearTarget'
42 A 'CastSpellByName>>Blessing of Protection(Rank 3)'
43 A 'SpellTargetUnit>>raid1'
44 A 'SpellIsTargeting>>false'
45 A 'TargetLastTarget'
46 A ''

A = Actual
E = expected

Here you can see Line 31 of the expected text has a space missing.

The full actual text is also given, so you can paste it into the test if required:

ACTUAL:

|cffffff40Panic#|cffffff40 State=bg#|cffffff40 Name=Nesferatu#|cffffff40 Class=M
AGE#|cffffff40 Health=91.904761904762% Limit=95% (+ Ramp of 0%)#|cffffff40 Index
=1#|cffffff40 Weighting=3#|cffffff40 Name=Blodrazer#|cff66cc33Target is not in V
isable Range#|cffffff40CheckTarget failed OutOfRange#|cffffff40 Name=Tompif#|cff
ffff40 Class=PRIEST#|cffffff40 Health=95.181616011861% Limit=25% (+ Ramp of 0%)#
|cffffff40 Name=Capjim#|cffffff40 Class=ROGUE#|cffffff40 Health=94.050343249428%
 Limit=20% (+ Ramp of 0%)#|cffffff40 Name=Dulaa#|cffffff40 Class=MAGE#|cffffff40
 Health=99.411764705882% Limit=95% (+ Ramp of 0%)#|cffffff40 Name=Mic#|cffffff40
 Class=DRUID#|cffffff40 Health=100% Limit=20% (+ Ramp of 0%)#|cffffff40 Name=Ber
ginyon#|cffffff40 Class=ROGUE#|cffffff40 Health=100% Limit=20% (+ Ramp of 0%)#|c
ffffff40 Name=Killhim#|cff66cc33Target is not in Visable Range#|cffffff40CheckTa
rget failed OutOfRange#|cffffff40 Name=Ilnoa#|cffffff40 Class=HUNTER#|cffffff40
Health=100% Limit=20% (+ Ramp of 0%)#|cffffff40 Name=Smacker#|cff66cc33Target is
 you#|cffffff40 Class=PALADIN#|cffffff40 Health=100% Limit=15% (+ Ramp of 0%)#|c
ffffff40|cff66cc331|c00FFFFFF - |cff6666ffNesferatu (raid1) 3.0#|cffffff40Top pl
ayer to panic about Nesferatu (raid1) with weighting=3.0#|cffffff40 BoP not up#|
cffffff40 Stage=1#|cffffff40 BoP is ready#ClearTarget#CastSpellByName>>Blessing
of Protection(Rank 3)#SpellTargetUnit>>raid1#SpellIsTargeting>>false#TargetLastT
arget#

Output is also piped to test.log, so if you need to cut&paste back to a test then here is the place to do it.


Debugging
=========

If you open the pa.test.lua file you will see a series of tests (one test per function)
You can get the test suite to output more information via the luaUnit:ToggleVerbose() call
Put this around the call you are interested in like this:

		luaUnit:ToggleVerbose();
		Result = PA:AutoResurrect();
		luaUnit:ToggleVerbose();

You should then see output like this which should show the ingame messages:
--------------- Verbose ON ---------------

|cff66cc33You have not learned to resurrect players yet.
--------------- Verbose OFF ---------------

You can also use the following function in the main code:

PA:Debug(value list)  [entries in value list are nil protected and converted to a string]

e.g.
PA:Debug("Unit=", unit);

could give

DEBUG: Unit=raid3
or
DEBUG: Unit=nil

etc


In game PA:Debug is just a stub function but in the test suite it will output when verbose is on.


Golden Rules
============
1. Run the unit tests often (I run them every 5/10 mins when developing as I
get to a natural break)
2. Never commit code unless the Unit Tests all pass
3. If you create a new function then write at least one new test
4. If you find a bug then reproduce it with a new test (that will fail) and
then fix the bug (your new test should now pass)

If you are interested in how this all works then please feel free to ask me.

--Smacker (aka Sam#2)
mackrill@hotmail.com