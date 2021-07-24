# Why trash?

:hammer: Obviously, while taking care of our system we inadvertedly deleted (:eyes: at you,`rm`) and lost the file forever.
I do know the existence of the `-i` flag, however it does not protect against the dreaded :triangular_flag_on_post: `-rf`.
So as another measure of security, I added an extra-layer security with `trash`

After a few tweaks :wrench:, I came up with `trash` and I firmly believe it's a solid wrapper for rm.

* `-d` moves the file passed as argument to a temporary directory `${THRASH_DIR}`
* `-e` directly empties `${THRASH_DIR}`
* `-c` deletes file older than 30 days on `${THRASH_DIR}`
