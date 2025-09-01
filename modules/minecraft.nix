{ ... }:
{
services.minecraft-server = {
  enable = true;
  eula = true;
  openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
  declarative = true;
  serverProperties = {
    server-port = 43000;
    difficulty = 0;
    gamemode = 0;
    max-players = 5;
    motd = "Roommates Minecraft server!";
    level-seed = "-5365977600266094936";
    enable-rcon = true;
    # This password can be used to administer your minecraft server.
    # Exact details as to how will be explained later. If you want
    # you can replace this with another password.
    "rcon.password" = "hunter2";
  };
  jvmOpts = "-Xms2048M -Xmx8192M";
};
}
