{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  _module.args.userName = "admin";

  users.users.${userName} = {
    initialHashedPassword = "$y$j9T$GoLuMdK9I2QfEAZ3K80KA0$Fgay3PXjsB3UZgZ70nlFYk/3qhEYlx4jmYx4/CyWI6/";
    #hashedPasswordFile = config.sops.secrets."user/nixos-serverpublic/admin".path;
  };
}
