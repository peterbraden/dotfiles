# NixOS
I'm not a nix fanboy - I've had enough nix issues to temper any irrational
enthusiasm. Nevertheless I now have several nixos based servers, and use devbox
in some cases.

But nix is a cult, and a lot of the tooling assumes you are locked into the nix
ecosystem for everything - this isn't me - I assume I will be using my dotfiles
on a variety of different distributions / OS's for the foreseeable future. Thus
nix just has to play well with the rest of the team.


## Learnings and design.

The nixos documentation is fairly dreadful. There are a lot of suboptimal ways
of doing things that end up biting you later.


### Flakes

Flakes don't play nicely with `/etc/nixos/configuration.nix` - you have to go
all in. Any time rebuild-switch is called _without_ the flake, you will get the
empty configuration.nix, and there is no good way in nix to keep these in sync.

Additionally, hardware configuration in flakes is a mess. Unless you manually
sync your hardware configuration into your flake, then you can't have it auto
generate.

### Language
The nix language is horrible and badly conceived - the fact that certain
operations happen at different phases, and depending on the phase of each
operation, the eager evaluation might try and include something that doesn't
exist yet, makes writing configurations baroque and infuriating. This coupled
with the _terrible_ error messages means inevitable frustration.

It also means if you want _anything_ that isn't in your repo, you are doomed to
use --impure - the fact that eval requires purity but happens before realisation
(which doesn't) is entirely backwards.

I don't have any solutions here. It's just inevitable pain.

### Bootstrapping

I originally had a plan to pre-build an iso for a machine's setup, so that you
could simply flash the machine with this iso, and it would be completely up and
running. But after a lot of experimentation I don't think this is a good
approach.

The root of the problem with a completely declarative build is that in order to
get the system to the desired state, you need secrets on the machine.  This gets
us in a chicken-and-egg scenario. To pass encrypted secrets to the machine, you
need at least one secret to encrypt/decrypt them with, and until the
machine-specific secret is created, there isn't a key to use.

For me, the key secret needed is an SSH key, that can be authed to github, as
without github access, I don't have access to the flakes necessary to configure
the machine.

Nix doesn't consider the nix-store secure, so generating a key at build time
doesn't work, as that key would be in plaintext in the store. Everyone
recommends doing this manually - either generating a key on the machine over
ssh, or manually copying a key onto the machine. 

Nixos-anywhere scripts this approach
(https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md)
allowing copying of a secret by the install script.

It's possible to
[generate](https://search.nixos.org/options?show=services.openssh.hostKeys) SSH
keys on the host at setup, but as this happens on the host after OpenSSH is
installed, then you don't have the key before hand, and any subsequent
decryption requires that you extract the public key, and apply a second pass
with the encrypted files.

In the past I've treated ssh key's as a transient thing - I generate one on each
host, and throw them away when reprovisioning a host. As soon as you start using
the ssh key as the encryption target for the machine, then you tie your git
repository content to the lifecycle of that key - if the key is lost, then all
the encrypted files are useless, and your repository is full of cruft. Because
of this, I don't see a big advantage to storing encrypted secrets in the repo -
you may as well have a single secret store, and put everything there, and then
just copy everything across at once.

And if you have to login to the machine to create the SSH key, there isn't a lot
of value in making the bootstrap iso particularly useful - all you are going to
do is create an SSH key, export the pubkey and use that to auth GitHub etc, and
then run an install from a flake.





# Links
- https://grahamc.com/blog/erase-your-darlings/
- https://github.com/Evertras/simple-homemanager/blob/main/README.md
- https://www.tweag.io/blog/2020-05-25-flakes/
