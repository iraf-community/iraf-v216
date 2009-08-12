include "../ptkeysdef.h"

# PT_CHOOSE -- Determine which fields are to be selected.

int procedure pt_choose (key, fields)

pointer	key		# pointer to key structure
char	fields[ARB]	# fields to be evaluated

size_t	sz_val
int	max_nkeys, nkeys, index, nelems, element, len
long	elems
pointer	list, sp, kname, uname, fname, aranges, ranges, rangeset
pointer	nop, uop, fop
int	pt_gnfn(), pt_ranges(), strdic(), decode_ranges()
long	get_next_number()
int	pt_kstati(), iint()
pointer	pt_ofnl()
real	asumi()

begin
	# Allocate buffer space
	call smark (sp)
	sz_val = KY_SZPAR
	call salloc (kname, sz_val, TY_CHAR)
	call salloc (uname, sz_val, TY_CHAR)
	call salloc (fname, sz_val, TY_CHAR)
	sz_val = SZ_FNAME
	call salloc (aranges, sz_val, TY_CHAR)
	call salloc (ranges, sz_val, TY_CHAR)
	sz_val = 3 * KY_MAXNRANGES + 1
	call salloc (rangeset, sz_val, TY_LONG)

	# Allocate space for the select buffers. Space equal to the number
	# of keys in the database is allocated. Allowance must be made for
	# array subsripts.

	sz_val = KY_NKEYS(key)
	max_nkeys = iint (asumi (Memi[KY_NELEMS(key)], sz_val)) + 1

	if (KY_SELECT(key) != NULL)
	    call mfree (KY_SELECT(key), TY_INT)
	sz_val = max_nkeys
	call malloc (KY_SELECT(key), sz_val, TY_INT)
	if (KY_ELEM_SELECT(key) != NULL)
	    call mfree (KY_ELEM_SELECT(key), TY_INT)
	sz_val = max_nkeys
	call malloc (KY_ELEM_SELECT(key), sz_val, TY_INT)
	if (KY_LEN_SELECT(key) != NULL)
	    call mfree (KY_LEN_SELECT(key), TY_INT)
	sz_val = max_nkeys
	call malloc (KY_LEN_SELECT(key), sz_val, TY_INT)

	if (KY_NAME_SELECT(key) != NULL)
	    call mfree (KY_NAME_SELECT(key), TY_CHAR)
	sz_val = max_nkeys * KY_SZPAR
	call malloc (KY_NAME_SELECT(key), sz_val, TY_CHAR)
	if (KY_UNIT_SELECT(key) != NULL)
	    call mfree (KY_UNIT_SELECT(key), TY_CHAR)
	sz_val = max_nkeys * KY_SZPAR
	call malloc (KY_UNIT_SELECT(key), sz_val, TY_CHAR)
	if (KY_FMT_SELECT(key) != NULL)
	    call mfree (KY_FMT_SELECT(key), TY_CHAR)
	sz_val = max_nkeys * KY_SZPAR
	call malloc (KY_FMT_SELECT(key), sz_val, TY_CHAR)

	nop = KY_NAME_SELECT(key)
	uop = KY_UNIT_SELECT(key)
	fop = KY_FMT_SELECT(key)
	nkeys = 0

	# Loop through the fields list.
	list = pt_ofnl (key, fields)
	while (pt_gnfn (list, Memc[kname], Memc[aranges], KY_SZPAR) != EOF) {

	    # Find the field name and the ranges.
	    index = strdic (Memc[kname], Memc[kname], KY_SZPAR,
	        Memc[KY_WORDS(key)])
	    if (pt_ranges (Memc[aranges], Memc[ranges], element,
	        SZ_FNAME) == ERR)
		call error (0, "Cannot decode apphot range string")
	    if (index == 0)
		next

	    # Get the length, format and the units strings.
	    nelems = pt_kstati (key, Memc[kname], KY_NUMELEMS)
	    len = pt_kstati (key, Memc[kname], KY_LENGTH)
	    call pt_kstats (key, Memc[kname], KY_UNITSTR, Memc[uname],
	        KY_SZPAR)
	    call pt_kstats (key, Memc[kname], KY_FMTSTR, Memc[fname],
	        KY_SZPAR)

	    # Load the fields.
	    if (nelems == 1) {

	        Memi[KY_SELECT(key)+nkeys] = index
	        Memi[KY_ELEM_SELECT(key)+nkeys] = 1
		Memi[KY_LEN_SELECT(key)+nkeys] = len

		call sprintf (Memc[nop], len, "%*.*s")
		    call pargi (-len)
		    call pargi (len)
		    call pargstr (Memc[kname])
		nop = nop + len

		call sprintf (Memc[uop], len, "%*.*s")
		    call pargi (-len)
		    call pargi (len)
		    call pargstr (Memc[uname])
		uop = uop + len

		call sprintf (Memc[fop], len, "%*.*s")
		    call pargi (-len)
		    call pargi (len)
		    call pargstr (Memc[fname])
		fop = fop + len

	        nkeys = nkeys + 1

	    } else {

		if (Memc[ranges] == EOS) {
		    call sprintf (Memc[ranges], SZ_FNAME, "1-%d")
			call pargi (nelems)
		}
		if (decode_ranges (Memc[ranges], Meml[rangeset], KY_MAXNRANGES,
		    elems) == ERR)
		    call error (0, "Cannot decode ranges string")

		elems = 0
		while (get_next_number (Meml[rangeset], elems) != EOF) {

		    if (elems < 1 || elems > nelems)
			break
		    Memi[KY_SELECT(key)+nkeys] = index
		    Memi[KY_ELEM_SELECT(key)+nkeys] = elems
		    Memi[KY_LEN_SELECT(key)+nkeys] = len

		    call sprintf (Memc[nop], max_nkeys * KY_SZPAR, "%s%*.*d")
		        call pargstr (Memc[kname])
		        call pargi (-len)
			call pargi (len)
			call pargl (elems)
		    nop = nop + len

		    call sprintf (Memc[uop], len, "%*.*s")
		        call pargi (-len)
			call pargi (len)
		        call pargstr (Memc[uname])
		    uop = uop + len

		    call sprintf (Memc[fop], len, "%*.*s")
		        call pargi (-len)
			call pargi (len)
		        call pargstr (Memc[fname])
		    fop = fop + len

		    nkeys = nkeys + 1
		}
	    }
	}

	# Reallocate the select buffer space.
	KY_NSELECT(key) = nkeys
	sz_val = KY_NSELECT(key)
	call realloc (KY_SELECT(key), sz_val, TY_INT)
	call realloc (KY_ELEM_SELECT(key), sz_val, TY_INT)
	call realloc (KY_LEN_SELECT(key), sz_val, TY_INT)
	sz_val = KY_NSELECT(key) * KY_SZPAR
	call realloc (KY_NAME_SELECT(key), sz_val, TY_CHAR)
	call realloc (KY_UNIT_SELECT(key), sz_val, TY_CHAR)
	call realloc (KY_FMT_SELECT(key), sz_val, TY_CHAR)

	# Free list storage space.
	call pt_cfnl (list)
	call sfree (sp)

	return (nkeys)
end
