*
* PROGRAM COEFINT.ADO
*
*  This program calculates the return to schooling
*    for different family background levels as well
*    as the standard errors
*

capture program drop coefint
program define coefint
     version 3.1

/*
        The syntax for this command is:

        coefint (varlist)

                                  1 : 1st Variable
                                  2 : 2nd Variable
                                  3 : Coefficient on 1st Variable
                                  4 : Coefficient on 2nd Variable

*/

               /* Output:  coefficient estimates & std. errors */

                             /*  March 31, 1995  */



*et trace on

local x1 `1'
local x2 `2'
local bx1 `3'
local bx2 `4'

local i=9
  while `i' < 21 {
      test `x1'+(`x2'*`i')=0
      local t`i'=_result(6)^.5
      local b`i'=`bx1'+(`bx2'*`i')
      local se`i'=`b`i''/`t`i''
      di "b`i' = " `b`i''
      di "se`i' = " `se`i''
      di "t`i' = " `t`i''
      local i=`i'+1
  }

set trace off
end
