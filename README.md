# Why `rm.sh`?

:hammer: Obviously, while taking care of our system we inadvertedly deleted (:eyes: at you,`rm`) and lost the file forever.
I do know the existence of the `-i` flag, however it does not protect against the dreaded :triangular_flag_on_post: `-rf`.
So as another measure of security, I added an extra-layer security with `rm.sh`. In the grand scheme, it temporarily moves the file to be deleted to a directory `TRASH_DIR`(can be set as env variable :recycle:) and the same file can, later on, be permanantly deleted or recovered.

After a few tweaks :wrench:, I came up with `rm.sh` and I firmly believe that it's a solid wrapper for rm.

## USAGE
```
rm.sh 0.1.0 by @matdexir

DESCRIPTION:
This program is a rm replacement for sloppy just like me. It is essentially a wrapper for rm and mv commands.

OPTIONS:
	-h|--help:	Displays the current help message
	-e|--empty:	Empties the trash directory defined by $TRASH_DIR
    -c|--clear:	Clears the file that are older than 30 days inside $TRASH_DIR

```

**Recommendation**:
For convenience's sake, you could put this into your crontab.

```
# crontab format
# * * * * *  command_to_execute
# - - - - -
# | | | | |
# | | | | +- day of week (0 - 7) (where sunday is 0 and 7)
# | | | +--- month (1 - 12)
# | | +----- day (1 - 31)
# | +------- hour (0 - 23)
# +--------- minute (0 - 59)
0 0 * * * /path/to/rm.sh -c
```
