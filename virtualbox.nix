{pkgs, ...}: let
  targetEnv = "virtualbox";
  virtualbox = {
    memorySize = 1024;
    vcpu = 1;
    headless = true;
  };
in {
  deployment = {
    targetEnv = targetEnv;
    virtualbox = virtualbox;
  };
}
