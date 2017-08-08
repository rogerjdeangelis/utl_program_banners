*
 _ __ ___   __ _  ___ _ __ ___  ___
| '_ ` _ \ / _` |/ __| '__/ _ \/ __|
| | | | | | (_| | (__| | | (_) \__ \
|_| |_| |_|\__,_|\___|_|  \___/|___/

;

You need

   1. filename mymacs2 'c:\oto';
      options cmdmac append=sasautos=(oto);
      put both macros below into c:/oto/xplo.sas


%macro xplo ( AFSTR1 )/cmd ;

/*-----------------------------------------*\
|  xplo %str(ONEaTWOaTHREE)                 |
|  lower case letters produce spaces        |
\*-----------------------------------------*/

note;notesubmit '%xploa';

%mend xplo;

%macro xploa
/  des = "Exploded Banner for Printouts";

options noovp;
title;
footnote;

%let uj=1;

%do %while(%scan(&afstr1.,&uj) ne );
   %let uj=%eval(&uj+1);
   %put uj= &uj;
%end;

data _null_;
   rc=filename('__xplo', "%sysfunc(pathname(work))/__xplo");
   if rc = 0 and fexist('__xplo') then rc=fdelete('__xplo');
   rc=filename('__xplo');

   rc=filename('__clp', "%sysfunc(pathname(work))/__clp");
   if rc = 0 and fexist('__clp') then rc=fdelete('__clp');
   rc=filename('__clp');
run;

filename ft15f001 "%sysfunc(pathname(work))/__xplo";

* format for proc explode;
data _null_;
file ft15f001;
   %do ui=1 %to %eval(&uj-1);
      put "D";
      put " %scan(&afstr1.,&ui)";
   %end;
run;

filename __clp "%sysfunc(pathname(work))/__clp";

proc printto print=__clp;
run;quit;

proc explode;
run;

filename ft15f001 clear;
run;quit;
proc printto;
run;quit;

filename __dm clipbrd ;

   data _null_;
     infile __clp;
     file __dm;
     input;
     putlog _infile_;
     put _infile_;
   run;

filename __dm clear;

%mend xploa;


*            _   _                   _
 _ __  _   _| |_| |__   ___  _ __   | |__   __ _ _ __  _ __   ___ _ __
| '_ \| | | | __| '_ \ / _ \| '_ \  | '_ \ / _` | '_ \| '_ \ / _ \ '__|
| |_) | |_| | |_| | | | (_) | | | | | |_) | (_| | | | | | | |  __/ |
| .__/ \__, |\__|_| |_|\___/|_| |_| |_.__/ \__,_|_| |_|_| |_|\___|_|
|_|    |___/
;

*            _   _
 _ __  _   _| |_| |__   ___  _ __
| '_ \| | | | __| '_ \ / _ \| '_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/
;

If you are only interested in the ASCII art, it may not
be worth it.

see
http://www.randalolson.com/2016/09/03/python-2-7-still-reigns-supreme-in-pip-installs/

I use 2,7 because AI packages have better support in 2.7?
Python 2.7 still comprises roughly 90% of all installs?

You need

   1. Download and install python 'https://www.python.org/downloads/'.
      I like vanilla python from the source(2.7.13?)

   2. filename mymacs2 'c:\oto';
      options cmdmac append=sasautos=(oto);
      put both macros below into c:/oto/xplo.sas

   3. put utl_submit_py64.sas in c:/oto
      put the two macros xpy and xpya in c:/oto/xpy.sas

   4. Open up C:Python27/scripts
      type: pip install pyfiglet
      You may get a message that another package or
      binary is needed. Just follw the directions?

change "C:\Python27/python.exe to point to your python install

%macro utl_submit_py64(pgm)/des="Semi colon separated set of py commands";
  * write the program to a temporary file;
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $1024;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'));
        if cmd=:'. ' then
           cmd=trim(substr(cmd,2));
           put cmd $char384.;
           putlog cmd $char384.;
      end;
  run;

  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %put &_loc;
  filename rut pipe  "C:\Python27/python.exe &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename py_pgm clear;
%mend utl_submit_py64;

%macro xpy()/cmd parmbuff;

%let afstr1=&syspbuff;

/*-----------------------------------------*\
|  xplo %str(ONE TWO THREE)                 |
|  lower case letters produce spaces        |
\*-----------------------------------------*/

note;notesubmit '%xpya';

%mend xpy;

%macro xpya
/  des = "Exploded Banner for Printouts";

%local uj revslash;

options noovp;
title;
footnote;

data _null_;
   rc=filename('__xplp', "%sysfunc(pathname(work))/__xplp");
   if rc = 0 and fexist('__xplo') then rc=fdelete('__xplp');
   rc=filename('__xplp');
run;

%let revslash=%sysfunc(translate(%sysfunc(pathname(work)),'/','\'));
%put &=revslash;
run;quit;

* note uou can altename single and double quotes;
%utl_submit_py64(resolve('
import sys;
from pyfiglet import figlet_format;
txt=figlet_format("&afstr1.", font="standard");
with open("&revslash./__xplp", "w") as f:;
.    f.write(txt);
'));

filename __dm clipbrd ;

   data _null_;
     infile "%sysfunc(pathname(work))/__xplp" end=dne;
     file __dm;
     input;
     if _n_=1 then substr(_infile_,1,1)='*';
     putlog _infile_;
     put _infile_;
     if dne then do;
        put ';';
        putlog ';';
     end;
   run;

filename __dm clear;

%mend xpya;

