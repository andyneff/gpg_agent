# TL;DR #

Todo

```
./preload.bsh mykey.key

docker run -v ?:$GNUPGHOME somedocker
```

# How to use #

The idea behind the gpg-agent docker is to start a gpg-agent daemon once for 
multiple dockers to use. This is useful for signing, etc... in multiple dockers
using properly secure keys, but not having to enter the passphase many times, or
at random times during the build step. It's all up to how you want to used this

1. I just want to have it cache as I go. Just run `./start.bsh`, and run your 
dockers with `-v ?:$GNUPGHOME" You will be prompted for passphases as you go, and
it will cache all the keys.
2. I want to cache all my keys, and run my dockers. Just run 
`./preload.bsh _keyfiles_` and it will cache your keyfiles, and ask you all your 
passphases right then and there. All you have to do is run your dockers with the
`-v ?:$GNUPGHOME` flag, and it will use the cached keys

What is `$GNUPGHOME`? This is the GPG home, typically `~/.gnupg`.

## Script usage ##

To prevent MANY passphrase entries at random times, a gpg-agent docker is used to
cache your signing key. Pre-caching keys is done by calling `./preload.bsh`. It 
will ask you for your passphrase, once for each unique key out of all the keys 
specified. So if you use the same key but call it multiple times, it will only 
prompt once. If you have 5 different keys, you'll have prompts, with only the the 
key ID to tell you which is which. Keys will also cache in any docker mounting the
$GNUPGHOME dir at run time.

The gpg agent TTL is set to 1 year. If this is not acceptable for you, set the 
`GPG_MAX_CACHE` and `GPG_DEFAULT_CACHE` environment variables (in seconds) before
starting the gpg-agent daemon.

`./start.bsh` starts the gpg-agent daemon. It is called 
automatically by `./preload.bsh`

`./stop.bsh` stops the gpg-agent daemon. It is called automatically by 
`./preload.bsh` when the -r flag is specified as the first argument

`./preload.bsh -r` - Stops and restarts the gpg agent daemon.
This is useful for reloading keys when you update them in your host.

## Arguments ##

`./start.bsh` - No arguments

`./stop.bsh` - No arguments

`./preload.bsh [-r] [keyfile/dir1] [keyfile/dir2...]` - All optional

- `-r` - Will stop and then restart the gpg-agent docker if it is currently running.
The default it to just start the gpg-agent docker as a docker daemon.
- `keyfile/dir` - Any filename that will be treated as a key for gpg to import, or
directory containing *.key files to be imported.

Preload can be called multiple times, and each time the keys are just added, unless
`-r` is used, in which case it resets each call, and only the latest call's keys
will be loaded

## Environment variables ##

GPG_MAX_CACHE - Default: 1 year. Set for gpg-agent. Units in seconds.

GPG_DEFAULT_CACHE - Default: 1 year. Set for gpg-agent. Units in seconds.

CONTAINER_NAME - Default: gpg-agent_debian_8. You can change the name used, and
even deploy multiple unique instances by overwriting this when calling the bash 
scripts.

## What about different distros? ##

While the gpg-agent uses it the one that ships with debian 8 (2.0.26), it has been
tested against CentOS 5, CentOS 6, CentOS 7, Debian 7, and Debian 8, and all work
without issue.
