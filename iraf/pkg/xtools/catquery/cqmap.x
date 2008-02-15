include	<ctype.h>
include	"cqdef.h"

# CQ_MAP -- Map a catalog database.

pointer procedure cq_map (database, mode)

char	database[ARB]			#I The database file
int	mode				#I The database file access mode

size_t	sz_val
int	i, nrec, cq_alloc1, cq_alloc2
pointer	cq, str

long	note()
int	open(), fscan(), strlen()
bool	streq()
errchk	open()

begin
	if (mode != READ_ONLY && mode != NEW_FILE && mode != APPEND)
	    return (NULL)

	iferr (i = open (database, mode, TEXT_FILE))
	    return (NULL)

	sz_val = CQ_LEN
	call calloc (cq, sz_val, TY_STRUCT)
	call strcpy (database, CQ_CATDB(cq), SZ_FNAME)
	CQ_FD(cq) = i

	if (mode != READ_ONLY)
	    return (cq)

	cq_alloc1 = CQ_ALLOC
	cq_alloc2 = CQ_ALLOC * SZ_LINE
	sz_val = cq_alloc1
	call malloc (CQ_OFFSETS(cq), sz_val, TY_LONG)
	call malloc (CQ_NAMES(cq), sz_val, TY_INT)
	sz_val = cq_alloc2
	call malloc (CQ_MAP(cq), sz_val, TY_CHAR)
	sz_val = SZ_LINE
	call malloc (str, sz_val, TY_CHAR)

	nrec = 1
	CQ_NRECS(cq) = 0
	CQ_NAMEI(cq, nrec) = 0

	while (fscan (CQ_FD(cq)) != EOF) {
	    call gargwrd (CQ_NAME(cq, nrec), SZ_LINE)

	    if (streq (CQ_NAME(cq, nrec), "begin")) {
	        call gargstr (Memc[str], SZ_LINE)
		for (i=str; IS_WHITE(Memc[i]); i=i+1)
		    ;
		call strcpy (Memc[i], CQ_NAME(cq,nrec), SZ_LINE)

		for (i = 1; i < nrec; i = i + 1)
		    if (streq (CQ_NAME(cq, i), CQ_NAME(cq, nrec)))
			break

		if (i < nrec)
		    CQ_OFFSET(cq, i) = note (CQ_FD(cq))
		else {
		    CQ_NRECS(cq) = nrec
		    CQ_OFFSET(cq, nrec) = note (CQ_FD(cq))
		    CQ_NAMEI(cq, nrec+1) = CQ_NAMEI(cq, nrec) +
			strlen (CQ_NAME(cq, nrec)) + 1
		    nrec = nrec + 1
		}

		if (nrec == cq_alloc1) {
		    cq_alloc1 = cq_alloc1 + CQ_ALLOC
		    sz_val = cq_alloc1
		    call realloc (CQ_OFFSETS(cq), sz_val, TY_LONG)
		    call realloc (CQ_NAMES(cq), sz_val, TY_INT)
		}
		if (CQ_NAMEI(cq, nrec) + SZ_LINE >= cq_alloc2) {
		    cq_alloc2 = cq_alloc2 + CQ_ALLOC * SZ_LINE
		    sz_val = cq_alloc2
		    call realloc (CQ_MAP(cq), sz_val, TY_CHAR)
		}
	    }
	}

	sz_val = CQ_NAMEI(cq, nrec)
	call realloc (CQ_MAP(cq), sz_val, TY_CHAR)
	sz_val = CQ_NRECS(cq)
	call realloc (CQ_OFFSETS(cq), sz_val, TY_LONG)
	call realloc (CQ_NAMES(cq), sz_val, TY_INT)
	call mfree (str, TY_CHAR)

	return (cq)
end


# CQ_UNMAP -- Close the database.

procedure cq_unmap (cq)

pointer	cq				#U The database file descriptor

begin
	if (cq == NULL)
	    return

	# Free the current catalog structure.
	call cq_ccfree (cq)

	# Close the catalog database file.
	if (CQ_FD(cq) != NULL)
	    call close (CQ_FD(cq))

	# Free the record mapping arrays.
	call mfree (CQ_MAP(cq), TY_CHAR)
	call mfree (CQ_OFFSETS(cq), TY_LONG)
	call mfree (CQ_NAMES(cq), TY_INT)

	# Free the structure.
	call mfree (cq, TY_STRUCT)
end
