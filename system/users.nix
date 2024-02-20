{ ... }:
{
  users = {
    mutableUsers = false;
    users.guest = {
      password = "guest";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  security.sudo.wheelNeedsPassword = false;
}
