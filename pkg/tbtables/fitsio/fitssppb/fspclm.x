include "fitsio.h"

procedure fspclm(ounit,colnum,frow,felem,nelem,array,status)

# write an array of double precision complex data values to the
# specified column of the table.
# The binary table column being written to must have datatype 'M'
# and no datatype conversion will be perform if it is not.

int     ounit           # i output file pointer
int     colnum          # i column number
int     frow            # i first row
int     felem           # i first element in row
int     nelem           # i number of elements
double  array[ARB]      # i array of values
int     status          # o error status

begin

call ftpclm(ounit,colnum,frow,felem,nelem,array,status)
end
