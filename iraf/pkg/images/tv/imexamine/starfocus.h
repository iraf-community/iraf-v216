# STARFOCUS

# Types of coordinates
define	SF_TYPES	"|center|mark1|markall|"
define	SF_CENTER	1		# Star at center of image
define	SF_MARK1	2		# Mark stars in first image
define	SF_MARKALL	3		# Mark stars in all images

# Task type
define	STARFOCUS	1
define	PSFMEASURE	2

# Radius types
define	SF_WTYPES	"|Radius|FWHM|GFWHM|MFWHM|"

define	SF_RMIN		16		# Minimum centering search radius
define	MAX_FRAMES	8		# Maximum number of display frames

# Data structures for STARFOCUS

define	NBNDRYPIX	0		# Number of boundary pixels
define	TYBNDRY		BT_REFLECT	# Type of boundary extension
define	SAMPLE		.2		# Subpixel sampling size
define	SF_SZFNAME	79		# Length of file names
define	SF_SZWTYPE	7		# Length of width type string

# Main data structure
define	SF		40
define	SF_TASK		Memi[P2I($1)]	# Task type
define	SF_WTYPE	Memc[P2C($1+1)]	# Width type string
define	SF_WCODE	Memi[P2I($1+5)]	# Width code
define	SF_BETA		Memr[P2R($1+6)]	# Moffat beta
define	SF_SCALE	Memr[P2R($1+7)]	# Pixel scale
define	SF_LEVEL	Memr[P2R($1+8)]	# Profile measurement level
define	SF_RADIUS	Memr[P2R($1+9)]	# Profile radius
define	SF_SBUF		Memr[P2R($1+10)]	# Sky region buffer
define	SF_SWIDTH	Memr[P2R($1+11)]	# Sky region width
define	SF_SAT		Memr[P2R($1+12)]	# Saturation
define	SF_NIT		Memi[P2I($1+13)]	# Number of iterations for radius
define	SF_OVRPLT	Memi[P2I($1+14)]	# Overplot the best profile?
define	SF_NCOLS	Meml[P2L($1+15)]	# Number of image columns
define	SF_NLINES	Meml[P2L($1+16)]	# Number of image lines
define	SF_XF		Memr[P2R($1+17)]	# X field center
define	SF_YF		Memr[P2R($1+18)]	# Y field center
define	SF_GP		Memp[$1+19]	# GIO pointer
define	SF_F		Memr[P2R($1+20)]	# Best focus
define	SF_W		Memr[P2R($1+21)]	# Width at best focus
define	SF_M		Memr[P2R($1+22)]	# Brightest star magnitude
define	SF_XP1		Memr[P2R($1+23)]	# First derivative point to plot
define	SF_XP2		Memr[P2R($1+24)]	# Last derivative point to plot
define	SF_YP1		Memr[P2R($1+25)]	# Minimum of derivative profile
define	SF_YP2		Memr[P2R($1+26)]	# Maximum of derivative profile
define	SF_N		Memi[P2I($1+27)]	# Number of points not deleted
define	SF_NSFD		Memi[P2I($1+28)]	# Number of data points
define	SF_SFDS		Memp[$1+29]	# Pointer to data structures
define	SF_NS		Memi[P2I($1+30)]	# Number of stars not deleted
define	SF_NSTARS	Memi[P2I($1+31)]	# Number of stars
define	SF_STARS	Memp[$1+32]	# Pointer to star groups
define	SF_NF		Memi[P2I($1+33)]	# Number of focuses not deleted
define	SF_NFOCUS	Memi[P2I($1+34)]	# Number of different focus values
define	SF_FOCUS	Memp[$1+35]	# Pointer to focus groups
define	SF_NI		Memi[P2I($1+36)]	# Number of images not deleted
define	SF_NIMAGES	Memi[P2I($1+37)]	# Number of images
define	SF_IMAGES	Memp[$1+38]	# Pointer to image groups
define	SF_BEST		Memp[$1+39]	# Pointer to best focus star

define	SF_SFD		Memp[SF_SFDS($1)+$2-1]
define	SF_SFS		Memp[SF_STARS($1)+$2-1]
define	SF_SFF		Memp[SF_FOCUS($1)+$2-1]
define	SF_SFI		Memp[SF_IMAGES($1)+$2-1]

# Basic data structure.
define	SFD		94
define	SFD_IMAGE	Memc[P2C($1)]	# Image name
define	SFD_DATA	Memp[$1+40]	# Pointer to real image raster
define	SFD_RADIUS	Memr[P2R($1+41)]	# Profile radius
define	SFD_NP		Memz[P2Z($1+42)]	# Number of profile points
define	SFD_NPMAX	Memz[P2Z($1+43)]	# Maximum number of profile points
define	SFD_X1		Meml[P2L($1+44)]	# Image raster limits
define	SFD_X2		Meml[P2L($1+45)]
define	SFD_Y1		Meml[P2L($1+46)]
define	SFD_Y2		Meml[P2L($1+47)]
define	SFD_ID		Memi[P2I($1+48)]	# Star ID
define	SFD_X		Memr[P2R($1+49)]	# Star X position
define	SFD_Y		Memr[P2R($1+50)]	# Star Y position
define	SFD_F		Memr[P2R($1+51)]	# Focus
define	SFD_W		Memr[P2R($1+52)]	# Width to use
define	SFD_M		Memr[P2R($1+53)]	# Magnitude
define	SFD_E		Memr[P2R($1+54)]	# Ellipticity
define	SFD_PA		Memr[P2R($1+55)]	# Position angle
define	SFD_R		Memr[P2R($1+56)]	# Radius at given level
define	SFD_DFWHM	Memr[P2R($1+57)]	# Direct FWHM
define	SFD_GFWHM	Memr[P2R($1+58)]	# Gaussian FWHM
define	SFD_MFWHM	Memr[P2R($1+59)]	# Moffat FWHM
define	SFD_ASI1	Memp[$1+60]	# Pointer to enclosed flux profile
define	SFD_ASI2	Memp[$1+61]	# Pointer to derivative profile
define	SFD_YP1		Memr[P2R($1+62)]	# Minimum of derivative profile
define	SFD_YP2		Memr[P2R($1+63)]	# Maximum of derivative profile
define	SFD_FWHM	Memr[P2R($1+64)+$2-1]	# FWHM vs level=0.5*i (i=1-19)
define	SFD_BKGD	Memr[P2R($1+83)]	# Background value
define	SFD_BKGD1	Memr[P2R($1+84)]	# Original background value
define	SFD_MISO	Memr[P2R($1+85)]	# Moment isophote
define	SFD_SIGMA	Memr[P2R($1+86)]	# Moffat alpha
define	SFD_ALPHA	Memr[P2R($1+87)]	# Moffat alpha
define	SFD_BETA	Memr[P2R($1+88)]	# Moffat beta
define	SFD_STATUS	Memi[P2I($1+89)]	# Status
define	SFD_NSAT	Memz[P2Z($1+90)]	# Number of saturated pixels
define	SFD_SFS		Memp[$1+91]	# Pointer to star group
define	SFD_SFF		Memp[$1+92]	# Pointer to focus group
define	SFD_SFI		Memp[$1+93]	# Pointer to image group


# Structure grouping data by star.
define	SFS		($1+7)
define	SFS_ID		Memi[P2I($1)]	# Star ID
define	SFS_F		Memr[P2R($1+1)]	# Best focus
define	SFS_W		Memr[P2R($1+2)]	# Best width
define	SFS_M		Memr[P2R($1+3)]	# Average magnitude
define	SFS_N		Memi[P2I($1+4)]	# Number of points used
define	SFS_NF		Memi[P2I($1+5)]	# Number of focuses
define	SFS_NSFD	Memi[P2I($1+6)]	# Number of data points
define	SFS_SFD		Memi[P2I($1+7)+$2-1]	# Array of data structures


# Structure grouping stars by focus values.
define	SFF		($1+5)
define	SFF_F		Memr[P2R($1)]	# Focus
define	SFF_W		Memr[P2R($1+1)]	# Average width
define	SFF_N		Memi[P2I($1+2)]	# Number in average
define	SFF_NI		Memi[P2I($1+3)]	# Number of images
define	SFF_NSFD	Memi[P2I($1+4)]	# Number of data points
define	SFF_SFD		Memi[P2I($1+5)+$2-1]	# Array of data structures


# Structure grouping stars by image.
define	SFI		($1+42)
define	SFI_IMAGE	Memc[P2C($1)]	# Image
define	SFI_N		Memi[P2I($1+40)]	# Number in imagE
define	SFI_NSFD	Memi[P2I($1+41)]	# Number of data points
define	SFI_SFD		Memi[P2I($1+42)+$2-1]	# Array of data structures
