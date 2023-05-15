{ pkgs, inputs, ... }:

{
  packages = [ pkgs.nickel pkgs.dyff ];

  scripts.dyff-test-svc.exec = "dyff between -b <(nickel export --format yaml -f scm-service.ncl) targetManifests/scm-service.yaml";
  scripts.dyff-test-sts.exec = "dyff between -b <(nickel export --format yaml -f scm-sts.ncl) targetManifests/scm-statefulset.yaml";
  scripts.test-ozone.exec = "nickel export --format raw -f ozone.ncl";
}
