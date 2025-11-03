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





# Links
- https://grahamc.com/blog/erase-your-darlings/
- https://github.com/Evertras/simple-homemanager/blob/main/README.md
- https://www.tweag.io/blog/2020-05-25-flakes/
