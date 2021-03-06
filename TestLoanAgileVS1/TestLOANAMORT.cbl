      *> Test Fixture for LOANAMORT, LOANAMORT

       copy "mfunit_prototypes.cpy".

       program-id. TestLOANAMORT.
       working-storage section.
       copy "mfunit.cpy".
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

       entry MFU-TC-PREFIX & TEST-TESTLOANAMORT.

           call "LOANAMORT" using
                       by reference LOANINFO
                       by reference OUTDATA

           *> Verify the outputs here
           goback returning MFU-PASS-RETURN-CODE
       .

      $region TestCase Configuration

       entry MFU-TC-SETUP-PREFIX & TEST-TESTLOANAMORT.
       perform InitializeLinkageData
           *> Add any other test setup code here
           goback returning 0
       .

       InitializeLinkageData section.
           *> Load the library that is being tested
           set pp to entry "LOANAMORT"

           initialize LOANINFO
           initialize OUTDATA
           exit section
       .

      $end-region

       end program.
