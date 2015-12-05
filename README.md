### GPG Agent ###

To prevent MANY passphrase entries at random times, a gpg-agent docker is used to
cache your signing key. This is done automatically for you, whenever you call
`./docker/run_dockers.bsh` on a building image (`git-lfs_*.dockerfile`). It can
be manually preloaded by calling `./docker/gpg-agent_preload.bsh`. It will ask 
you for your passphrase, once for each unique key out of all the dockers. So if
you use the same key for every docker, it will only prompt once. If you have 5
different keys, you'll have prompts, with only the the key ID to tell you which
is which.

The gpg agent TTL is set to 1 year. If this is not acceptable for you, set the 
`GPG_MAX_CACHE` and `GPG_DEFAULT_CACHE` environment variables (in seconds) before
starting the gpg-agent daemon.

`./docker/gpg-agent_start.bsh` starts the gpg-agent daemon. It is called 
automatically by `./docker/gpg-agent_preload.bsh`

`./docker/gpg-agent_stop.bsh` stops the gpg-agent daemon. It is called 
automatically by `./docker/gpg-agent_preload.bsh`

`./docker/gpg-agent_preload.bsh` is called automatically by 
`./docker/run_dockers.bsh` when running any of the signing dockers. 

`./docker/gpg-agent_preload.bsh -r` - Stops and restarts the gpg agent daemon.
This is useful for reloading keys when you update them in your host.