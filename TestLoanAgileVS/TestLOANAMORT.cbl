      *> Test Fixture for LoanAgileVS, LOANAMORT

       copy "mfunit_prototypes.cpy".

       program-id. TestLOANAMORT.
       working-storage section.
       copy "mfunit.cpy".

       01 WS-FAIL-MSG.
          03 FILLER      PIC X(31) VALUE "EXPECTED Total Interest value: ".
          03 WK-EXPECTED-VALUE     PIC X(09).
          03 FILLER      PIC X(31) VALUE "  ACTUAL Total Interest value: ".
          03 WK-ACTUAL-VALUE       PIC X(09).

       78 TEST-TESTLOANAMORT value "TestLOANAMORT".
       01 pp procedure-pointer.

      *> Program linkage data
       01 LOANINFO.
         03 PRINCIPAL PIC S9(8) COMP-3.
         03 LOANTERM PIC S9(8) COMP-3.
         03 RATE PIC S9(9)V9(9).
       01 OUTDATA.
         03 PAYMENTS occurs 480 depending on LOANTERM.
           05 OUTINTPAID PIC $$,$(3).99.
           05 OUTPRINCPAID PIC $$,$(3).99.
           05 OUTPAYMENT PIC $$,$(3).99.
           05 OUTBALANCE PIC $(3),$(3).99.
         03 OUTTOTINTPAID PIC $$,$(3).99.

       procedure division.
           goback returning 0
       .

       entry MFU-TC-PREFIX & "01".

           move 36000 to PRINCIPAL
           move 4.5   to RATE
		   move 48    to LOANTERM

           call "LOANAMORT" using
                       by reference LOANINFO
                       by reference OUTDATA

           *> Verify the outputs here
		   IF OUTINTPAID(1) =   "  $135.00" and
			  OUTPRINCPAID(1) = "  $685.92" and
			  OUTPAYMENT(1)   = "  $820.92" and
			  OUTBALANCE(1)   = "$35,314.08" and
			  OUTTOTINTPAID   = "$3,404.44"
			   continue
	       else 
              move OUTTOTINTPAID to WK-ACTUAL-VALUE
			  move "$3,404.60"   to WK-EXPECTED-VALUE
              CALL "MFU_ASSERT_FAIL" USING
                 BY REFERENCE WS-FAIL-MSG
                 BY VALUE 80
           END-IF


           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & "02".

           move 85000 to PRINCIPAL
           move 5.5    to RATE
		   move 120    to LOANTERM

           call "LOANAMORT" using
                       by reference LOANINFO
                       by reference OUTDATA

           *> Verify the outputs here
		   IF OUTINTPAID(1) =   "  $389.58" and
			  OUTPRINCPAID(1) = "  $532.89" and
			  OUTPAYMENT(1)   = "  $922.47" and
			  OUTBALANCE(1)   = "$84,467.11" and
			  OUTTOTINTPAID   = "$5,697.01"
			   continue
	       else 
              move OUTTOTINTPAID to WK-ACTUAL-VALUE
			  move "$5,697.01"   to WK-EXPECTED-VALUE
              CALL "MFU_ASSERT_FAIL" USING
                 BY REFERENCE WS-FAIL-MSG
                 BY VALUE 80
           END-IF


           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & "03".

		   move 6500  to PRINCIPAL
		   move 6.9   to RATE
		   move 36    to LOANTERM

           call "LOANAMORT" using
                       by reference LOANINFO
                       by reference OUTDATA

           *> Verify the outputs here
		   IF OUTINTPAID(1) =   "   $37.37" and
			  OUTPRINCPAID(1) = "  $163.02" and
			  OUTPAYMENT(1)   = "  $200.40" and
			  OUTBALANCE(1)   = " $6,336.98" and
			  OUTTOTINTPAID   = "  $714.56"
			   continue
	       else 
              move OUTTOTINTPAID to WK-ACTUAL-VALUE
			  move "  $714.56"   to WK-EXPECTED-VALUE
              CALL "MFU_ASSERT_FAIL" USING
                 BY REFERENCE WS-FAIL-MSG
                 BY VALUE 80
           END-IF

           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & "04".
       
           move 5500 to PRINCIPAL
           move 0.0 to RATE
           move 24 to LOANTERM
       
           call "LOANAMORT" using by reference LOANINFO
                                  by reference OUTDATA

           *> Test for Zero Rate
           *>Verify the outputs here

           IF OUTINTPAID(1) = "     $.00" and
             OUTPRINCPAID(1) = "  $229.16" and
             OUTPAYMENT(1) = "  $229.16" and
             OUTBALANCE(1) = " $5,270.84" and
             OUTTOTINTPAID = "     $.00"
               continue
           else
               move OUTTOTINTPAID to WK-ACTUAL-VALUE
               move "  $714.56" to WK-EXPECTED-VALUE
               CALL "MFU_ASSERT_FAIL" USING BY REFERENCE WS-FAIL-MSG
                                            BY VALUE 80
           END-IF
       
           goback returning MFU-PASS-RETURN-CODE.


      $region TestCase Configuration

       entry MFU-TC-SETUP-PREFIX & "01".
           *> Load the library that is being tested
           set pp to entry "LoanAgileVS"
       
           initialize LOANINFO
           initialize OUTDATA
           *> Add any other test setup code here
           goback returning 0
       .

      $end-region

       end program.
