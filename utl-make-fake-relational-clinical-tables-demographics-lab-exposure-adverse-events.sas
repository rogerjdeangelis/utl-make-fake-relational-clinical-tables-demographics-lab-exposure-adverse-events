Make fake relational clinical tables demographics lab exposure adverse events

I apologize to the programmer who created this tool. I did not. I cannot find a link or
the programmer.

github
https://tinyurl.com/y2dap3yj
https://github.com/rogerjdeangelis/utl-make-fake-relational-clinical-tables-demographics-lab-exposure-adverse-events

* this is the fakepac package, you need ti to include it ie %inc "c:/oto/fakepac.sas";
https://tinyurl.com/yyqrdan5
https://github.com/rogerjdeangelis/utl-make-fake-relational-clinical-tables-demographics-lab-exposure-adverse-events/blob/master/utl_fakepac.sas

/*
 * Fake data generation system
 *
 * Use   1) INITFAKE   starts a data set (first macro called)
 *       2) MAKEFAKE   creates the data set (last macro called)
 *
 *   One call to each of these adds a variable to the data set
 *
 *       3) FAKECONT   creates a fake continuous variable
 *       4) FAKEDATE   creates a fake DATE. variable
 *       5) FAKEINT    creates a fake integer
 *       6) FAKECAT    creates a fake categorical variable
 *
 * Example:
 *
 *      %initfake(test,4322,20) ;             /* output dataset name, seed and number of patients */
 *      %fakecont(wtkg,120,20) ;              /* random normal mean and standard deviation of weight */
 *      %fakecat(gender,C,$6.,Male Female) ;  /* random uniform genders */
 *      %makefake ;                           /* finish up */
 */

/*
 * INITFAKE - used to initialize a data set
 *
 * Parameters:  SETNAME = name of sas data set
 *              SEED = base seed
 *              REPS = number of records to produce
 */

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

proc format;
  value trt2des
  1='Aspirin'
  2='Placebo';
run;quit;

/* CREATE DEMOGRAPHICS */
%initfake(dm,4322,200) ;                        /* output dataset name, seed and number of patients */
%fakeint(trtcd,1,3) ;                           /* treatment codes 1 or 2 */
trt=put(trtcd,trt2des.);                        /* treatment description*/
%fakecat(treatment,C,$8.,Placebo Aspirin) ;     /* treatments */
%fakecont(wtkg,120,20) ;                        /* random normal mean and standard deviation of weight */
%fakecat(gender,C,$6.,Male Female) ;            /* random uniform genders */
%fakedate(birthdt,'01JAN1940'd,'01JAN1960'd) ;  /* random uniformly distributed dates from  JAN 2006 to JAN2008 */
%fakeint(age,50,90);                            /* random uniform ages from 50 to 90 */
format birthdt date9.;
%makefake ;

*            _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
;

*    _
  __| |_ __ ___
 / _` | '_ ` _ \
| (_| | | | | | |
 \__,_|_| |_| |_|

;

Up to 40 obs WORK.DEM total obs=200

 PATIENT     TREATMENT    TRTCD  GENDER      AGE       WTKG    BIRTHDT

     1        Placebo       2    Male         57     112.897  20SEP1943
     2        Placebo       2    Female       77      88.927  21JUN1944
     3        Placebo       1    Female       72      87.901  03NOV1943
     4        Placebo       1    Male         77     127.741  14DEC1940
     5        Placebo       1    Male         83     128.625  20SEP1951
     6        Aspirin       2    Female       85     135.931  05NOV1957
     7        Aspirin       2    Female       81     110.846  17DEC1942
     8        Aspirin       2    Female       55     102.679  18JUN1948
     9        Placebo       1    Female       66     118.907  13MAY1947
    10        Placebo       2    Male         66     107.110  17DEC1948
...

*_ _
| | |__
| | '_ \
| | |_) |
|_|_.__/

;

/* labs */
%initfake(lb,4322,200) ;
%fakedate(labdt,'01JAN2006'd,'01JAN2008'd) ;
%fakecont(wbc,130,10) ;
%fakecont(rbc,206,15) ;
%fakecont(sgt,99,20) ;
%fakecont(co2,44,6) ;
%fakecont(hct,36,2) ;
%fakecont(hgb,12,1) ;
%makefake ;

/* make long and skinny */
proc transpose data=lb out= labxpo (rename=(_name_=labtest col1=labval));
by patient labdt notsorted;
format labdte date9.;
var wbc rbc sgt co2 hct hgb;
run;

LABXPO total obs=1,200

  PATIENT      LABDT      LABTEST     LABVAL

     1       10MAR2007      WBC      122.036
     1       10MAR2007      RBC      223.753
     1       10MAR2007      SGT       87.891
     1       10MAR2007      CO2       43.577
     1       10MAR2007      HCT       37.249
     1       10MAR2007      HGB       12.142
     2       17NOV2006      WBC      132.146
     2       17NOV2006      RBC      189.844
     2       17NOV2006      SGT      106.741
     2       17NOV2006      CO2       36.760

*
  _____  __
 / _ \ \/ /
|  __/>  <
 \___/_/\_\

;

/* exposure */
%initfake(ex,4322,200) ;
%fakedate(expdt1,'01JAN2006'd,'01JAN2008'd) ;
%fakedate(expdt2,'01JAN2006'd,'01JAN2008'd) ;
%fakecont(dose1,130,10) ;
%fakecont(dose2,130,10) ;
%makefake ;

data addDos;
  set ex;
  expdt=expdt1;
  dose=dose1;
  output;
  expdt=expdt2;
  dose=dose2;
  output;
  format expdt date9.;
  drop expdt1 expdt2 dose1 dose2;
run;quit;

* You may want to sort by patient expdt;

PATIENT      EXPDT        DOSE

    1      10MAR2007    120.646
    1      22MAY2007    138.632
    2      07AUG2006    131.772
    2      03JAN2007    128.497
    3      13JUN2006    132.146
    3      17NOV2006    119.230
    4      09FEB2007    117.933
    4      21MAY2006    125.703

*
  __ _  ___
 / _` |/ _ \
| (_| |  __/
 \__,_|\___|

;
proc format;
  value ser2des
  1='Mild'
  2='Moderate'
  3='Severe'
  4='Life Threatening'
  5='Fatal';
  value rlt2des
  1='Not Related'
  2='Related';
run;

/* adverse event */
%initfake(aev,4322,200) ;
%fakedate(aevdt,'01jan2006'd,'01jan2008'd) ;
%fakeint(aevrelcd,1,3) ;
%fakeint(aevsevcd,1,6) ;
aevrel=put(aevrelcd,rlt2des.);
aevsev=put(aevsevcd,ser2des.);
format aevdt date9.;
%makefake ;

AEV total obs=200

Obs     PATIENT    AEVDT      AEVRELCD    AEVSEVCD    AEVREL         AEVSEV

  1         1    10MAR2007        2           3       Related        Severe
  2         2    05OCT2006        1           1       Not Related    Mild
  3         3    07AUG2006        2           2       Related        Moderate
  4         4    15JUL2007        2           4       Related        Life Threatening
  5         5    13JUN2006        1           2       Not Related    Moderate
  6         6    16JUL2007        2           3       Related        Severe
  7         7    09FEB2007        1           2       Not Related    Moderate
  8         8    04OCT2006        2           4       Related        Life Threatening
  9         9    04SEP2007        2           1       Related        Mild
 10        10    17APR2006        1           5       Not Related    Fatal


*
 _ __ ___   __ _  ___ _ __ ___  ___
| '_ ` _ \ / _` |/ __| '__/ _ \/ __|
| | | | | | (_| | (__| | | (_) \__ \
|_| |_| |_|\__,_|\___|_|  \___/|___/

;

%macro initfake(setname,seed,reps) ;

    %global _seed _anycat ;

    %let _anycat = N ;

    %let _seed = &seed ;

    data &setname ;
        do _rep = 1 to &reps ;

%mend initfake ;

/*
 * MAKEFAKE
 *
 * Parameters:  None
 */

%macro makefake ;

        patient=_rep;
        output ;
        end ;
        drop _rep %if &_anycat = Y %then %do ; _p %end ; ;
    run ;

%mend makefake ;

/*
 * FAKECONT adds a continuous variable to the data set
 *
 * Parameters:  VARNAME = variable name
 *              BASE = mean value for variable
 *              STDDEV = standard deviation for variable
 */

%macro fakecont(varname,base,stddev) ;

    %let _seed = %eval(&_seed + 1) ;

    &varname = &base + &stddev*rannor(&_seed) ;

%mend fakecont ;

/*
 * FAKEINTG adds a integer variable to the data set
 *
 * Parameters:  VARNAME = variable name
 *              MIN = mean value for variable
 *              MAX = standard deviation for variable
 */

%macro fakeint(varname,min,max) ;

    %let _seed = %eval(&_seed + 1) ;

    &varname = &min + int(ranuni(&_seed)*(&max-&min)) ;

%mend fakeint ;


/*
 * FAKEDATE adds a date variable to the data set
 *
 * Parameters:  VARNAME = variable name
 *              START = start of time period (year)
 *              END = end of time period (year)
 */

%macro fakedate(varname,start,end) ;
    format &varname date9.;
    %let _seed = %eval(&_seed + 1) ;

    &varname = &start + int(ranuni(&_seed)*(&end-&start)) ;

%mend fakedate ;

/*
 * FAKECAT adds a categorical variable to the data set
 *
 * Parameters:  VARNAME = variable name
 *              TYPE = C or N
 *              LENGTH = SAS length value
 *              LEVELS = list of levels for the variable
 *              PROBS = list of probabilities for a RANTBL call
 */


%macro fakecat(varname,type,length,levels,probs) ;

    %let _seed = %eval(&_seed + 1) ;

    %let _anycat = Y ;

    %* parse levels ;
    %let _lev = %scan(&levels,1) ;
    %let _clev = 0 ;
    %do %while (&_lev ne ) ;
        %let _clev = %eval(&_clev + 1) ;
        %let _lev&_clev = &_lev ;
        %let _lev = %scan(&levels,%eval(&_clev + 1)) ;
        %end ;

    %* set length and generate variable ;
    length &varname &length ;

    %if %scan(&probs,1) eq %then %do ;
        _p = 1 + int(&_clev*ranuni(&_seed)) ;
        %end ;
    %else %do ;
        _p = rantbl(&_seed,&probs) ;
        %end ;

    %if %upcase(&type) = C %then %do ;

        if _p = 1 then &varname = "&_lev1" ;
        %do _i = 2 %to &_clev ;
            else if _p = &_i then &varname = "&&_lev&_i" ;
            %end ;

        %end ;
    %else %do ;

        if _p = 1 then &varname = &_lev1 ;
        %do _i = 2 %to &_clev ;
            else if _p = &_i then &varname = &&_lev&_i ;
            %end ;

        %end ;

%mend fakecat ;

*               _
  ___ _ __   __| |
 / _ \ '_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

;

