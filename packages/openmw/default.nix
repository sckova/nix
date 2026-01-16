{
  openmw,
  openmw-git,
}:
openmw.overrideAttrs (oldAttrs: {
  pname = "openmw-unstable";
  version = "unstable-${openmw-git.rev}";
  src = openmw-git;
})
