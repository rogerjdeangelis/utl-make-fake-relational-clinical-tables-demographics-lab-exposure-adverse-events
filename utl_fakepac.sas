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

