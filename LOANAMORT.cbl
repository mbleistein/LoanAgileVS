       PROGRAM-ID. LOANAMORT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 PctDivider pic s9(3) comp-5 value 100.
       01 P PIC S9(8) COMP-3.
       01 T PIC S9(8) COMP-3.
       01 R PIC S9(9)V99(9).
       01 MONTH PIC S9(4) COMP.
       
       01 NUMPAYMENT PIC S9(9)V99.
       01 STRPAYMENT PIC $$,$$$.99.
       01 DECPAYMENT PIC S9(9)V9(9) COMP-3.
       01 INTPAID    PIC S9(9)V9(9).
       01 TOTINTPAID PIC S9(9)V9(9).
       01 PRINCPAID  PIC S9(8)V99 COMP-3.
       01 WORK-FIELDS.
          03 WRK-MESSAGE         PIC X(40) VALUE "CALCULATING PAYMENT".
          03 WRK-RATE            PIC S9(9)V9(9) COMP-3.
          03 WRK-PAYMENT         PIC S9(9)V9(9) COMP-3.
          03 WRK-PAYMENT-A       PIC $$,$$$.99.
       
       LINKAGE SECTION.
       01 LOANINFO.
           03 PRINCIPAL              PIC S9(8) COMP-3.
           03 LOANTERM               PIC S9(8) COMP-3.
           03 RATE                   PIC S9(9)V9(9).
           
       01 OUTDATA.
           03 PAYMENTS OCCURS 1 TO 480 DEPENDING ON LOANTERM.
               05 OUTINTPAID     PIC $$,$$$.99.
               05 OUTPRINCPAID   PIC $$,$$$.99.
               05 OUTPAYMENT     PIC $$,$$$.99.
               05 OUTBALANCE     PIC $$$,$$$.99.
           03 OUTTOTINTPAID  PIC $$,$$$.99.
       
       
       PROCEDURE DIVISION USING LOANINFO
                                OUTDATA.
                   
           PERFORM CALC-PAYMENT
           MOVE WRK-PAYMENT TO DECPAYMENT
           
           
           PERFORM VARYING MONTH FROM 1 BY 1 UNTIL MONTH > LOANTERM
               COMPUTE INTPAID ROUNDED = PRINCIPAL * ((RATE / 100) /12)
               COMPUTE TOTINTPAID = TOTINTPAID + INTPAID
               
               IF MONTH = LOANTERM
                   COMPUTE DECPAYMENT = INTPAID + PRINCIPAL
               END-IF    
               
               COMPUTE PRINCPAID = DECPAYMENT - INTPAID
               COMPUTE PRINCIPAL ROUNDED = PRINCIPAL - PRINCPAID
               MOVE PRINCPAID   TO OUTPRINCPAID(MONTH)
               MOVE INTPAID     TO OUTINTPAID(MONTH)
               MOVE DECPAYMENT  TO OUTPAYMENT(MONTH)
               MOVE PRINCIPAL   TO OUTBALANCE(MONTH)
               
           END-PERFORM
           MOVE TOTINTPAID TO         OUTTOTINTPAID

           GOBACK.
           
       CALC-PAYMENT.

           IF RATE = ZERO
               COMPUTE WRK-PAYMENT ROUNDED = PRINCIPAL / LOANTERM
           ELSE
               COMPUTE WRK-RATE = (RATE / 100) / 12
               COMPUTE WRK-PAYMENT ROUNDED = (PRINCIPAL * WRK-RATE) /
                 (1 - (1 / ((1 + WRK-RATE) ** (LOANTERM))))
           END-IF.

       CALC-PAYMENT-EXIT.
           EXIT.
           
          
       END PROGRAM.
