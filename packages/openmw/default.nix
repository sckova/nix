{
  openmw,
  openmw-git,
}:
openmw.overrideAttrs (oldAttrs: {
  version = "unstable-${openmw-git.date}-${openmw-git.version}";
  src = openmw-git.src;
})
