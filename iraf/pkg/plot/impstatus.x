# IMPSTATUS.X -- Support routines for multiple line, scrolling status line.


# SL_INIT -- Initialize the status lines for nlines

procedure sl_init (sl, nlines)

pointer	sl			# Pointer to status lines
int	nlines			# Number of lines

size_t	sz_val
int	i

begin
	i = nlines * (SZ_LINE + 1)
	if (sl == NULL) {
	    sz_val = i
	    call calloc (sl, sz_val, TY_CHAR)
	} else {
	    sz_val = i
	    call realloc (sl, sz_val, TY_CHAR)
	    call aclrc (Memc[sl], i)
	}
	Memc[sl] = nlines
end


# SL_FREE -- Free memory used in the status lines

procedure sl_free (sl)

pointer	sl			# Pointer to status lines

begin
	call mfree (sl, TY_CHAR)
end


# SL_GETSTR -- Get a status line string as a char pointer

pointer procedure sl_getstr (sl, line)

pointer	sl			# Pointer to status lines
int	line			# Line to enter

int	i

begin
	i = mod (line-1, int(Memc[sl]))
	return (sl + i * (SZ_LINE+1) + 1)
end
