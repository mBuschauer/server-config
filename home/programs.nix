{ ... }:
{
  programs.lsd = {
    enable = true;
    settings = {
      classic = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
      ];
      color = {
        when = "never";
        theme = "default";
      };
      date = "date";
      dereference = false;
      icons = {
        when = "auto";
        theme = "fancy";
        seperator = " ";
      };
      indicators = false;
      layout = "tree";
      recursion = {
        enabled = false;
        depth = 1;
      };
      size = "default";
      permission = "rwx";
      sorting = {
        column = "name";
        reverse = false;
        dir-grouping = "first";
      };
      no-symlink = false;
      hyperlink = "never";
      symlink-arrow = "⇒";
      header = false;
    };
  };
}
