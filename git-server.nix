{
  network.description = "Git server";

  git-server =
    { config, pkgs, ... }: 
    let
      repos-dir = "/home/git"; #set up a directory to hold the git repos, this will also be the git users home directory
      repos = import ./repos-packages.nix { inherit pkgs repos-dir; };
    in
    { 
      imports = [
        ./virtualbox.nix
      ];

      time.timeZone = "UTC";

      services.openssh.enable = true;
      services.cron.enable = true;
      services.cron.systemCronJobs = [ "30 9 * * * root repos-backup" ]; #run repos-backup once a day at 9:30

      nix.gc.automatic = true;

      environment.systemPackages = with pkgs;
      [
        vim git
        
        #custom scripts
        repos.repos-backup repos.repos-create repos.repos-delete repos.repos-list repos.repos-setenvvars 
      ];

      users.mutableUsers = false;

      users.users.root.openssh.authorizedKeys.keys = [
        "your public rsa key goes here"
      ];

      users.users.git = {
        isNormalUser = true;
        description = "git user";
        createHome = true;
        home = "${repos-dir}";
        shell = "${pkgs.git}/bin/git-shell";
        openssh.authorizedKeys.keys = ["your public rsa key goes here"];
      };
    };
}
