{ pkgs, inputs, ... }:

{
  packages = [ pkgs.nickel pkgs.dyff ];

  scripts.dyff-test.exec = "dyff between -b <(nickel export --format yaml -f scm-service.ncl) targetManifests/scm-service.yaml";
}
