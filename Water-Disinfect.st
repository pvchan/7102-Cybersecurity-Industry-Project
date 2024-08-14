PROGRAM Main
  VAR
    I_PbFill AT %IX100.1 : BOOL;
    O_FillValve AT %QX100.0 : BOOL;
    O_DischargeValve AT %QX100.1 : BOOL;
  END_VAR
  VAR
    Filling : BOOL;
    Discharging : BOOL;
    FillDone : BOOL;
    Purify_Done1 : BOOL;
    Purify_Done2 : BOOL;
    Purify_Done3 : BOOL;
    Purify_Done4 : BOOL;
    Restart : BOOL;
  END_VAR
  VAR
    PH_Level AT %QW101.1 : INT;
    Chlorine_Level AT %QW100.1 : INT;
  END_VAR
  VAR
    TON0 : TON;
    RS0 : RS;
    TON1 : TON;
    RS1 : RS;
    R_TRIG0 : R_TRIG;
    RS2 : RS;
    TON2 : TON;
    CTU0 : CTU;
    TON3 : TON;
    CTU1 : CTU;
    TON4 : TON;
    CTU2 : CTU;
    TON5 : TON;
    CTU3 : CTU;
    TON6 : TON;
    TON7 : TON;
    TON8 : TON;
    TON9 : TON;
    OR50_OUT : BOOL;
    NOT3_OUT : BOOL;
    AND5_OUT : BOOL;
    R_TRIG1 : R_TRIG;
    R_TRIG2 : R_TRIG;
    ADD60_OUT : INT;
    R_TRIG3 : R_TRIG;
    R_TRIG4 : R_TRIG;
    ADD61_OUT : INT;
    ADD62_OUT : INT;
    SUB67_OUT : INT;
    NOT17_OUT : BOOL;
    AND19_OUT : BOOL;
  END_VAR

  R_TRIG0(CLK := I_PbFill);
  OR50_OUT := OR(Restart, R_TRIG0.Q);
  NOT3_OUT := NOT(Discharging);
  AND5_OUT := AND(OR50_OUT, NOT3_OUT);
  TON0(IN := Filling, PT := T#70S);
  RS0(S := AND5_OUT, R1 := TON0.Q);
  Filling := RS0.Q1;
  FillDone := TON0.Q;
  RS2(S := FillDone, R1 := Purify_Done4);
  TON2(IN := RS2.Q1, PT := T#2S);
  R_TRIG1(CLK := TON2.Q);
  CTU0(CU := R_TRIG1.Q, R := Purify_Done1, PV := 1);
  TON3(IN := RS2.Q1, PT := T#4S);
  R_TRIG2(CLK := TON3.Q);
  CTU1(CU := R_TRIG2.Q, R := Purify_Done2, PV := 1);
  ADD60_OUT := ADD(CTU0.CV, CTU1.CV);
  TON4(IN := RS2.Q1, PT := T#6S);
  R_TRIG3(CLK := TON4.Q);
  CTU2(CU := R_TRIG3.Q, R := Purify_Done3, PV := 1);
  TON5(IN := RS2.Q1, PT := T#8S);
  R_TRIG4(CLK := TON5.Q);
  CTU3(CU := R_TRIG4.Q, R := Purify_Done4, PV := 1);
  ADD61_OUT := ADD(CTU2.CV, CTU3.CV);
  ADD62_OUT := ADD(ADD60_OUT, ADD61_OUT);
  Chlorine_Level := ADD62_OUT;
  SUB67_OUT := SUB(7, ADD61_OUT);
  PH_Level := SUB67_OUT;
  TON6(IN := CTU3.Q, PT := T#8S);
  Purify_Done1 := TON6.Q;
  TON7(IN := TON6.Q, PT := T#2S);
  Purify_Done2 := TON7.Q;
  TON8(IN := TON7.Q, PT := T#2S);
  Purify_Done3 := TON8.Q;
  NOT17_OUT := NOT(Filling);
  AND19_OUT := AND(Purify_Done4, NOT17_OUT);
  TON1(IN := Discharging, PT := T#90S);
  RS1(S := AND19_OUT, R1 := TON1.Q);
  Discharging := RS1.Q1;
  TON9(IN := TON8.Q, PT := T#2S);
  Purify_Done4 := TON9.Q;
  Restart := TON1.Q;
  O_FillValve := Filling;
  O_DischargeValve := Discharging;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : Main;
  END_RESOURCE
END_CONFIGURATION
