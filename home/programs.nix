{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    python3
    maven
    gradle
    jetbrains.idea-community
    jetbrains.pycharm-community
    poetry
  ];
  programs = {
    bash.enable = true;
    git.enable = true;
    chromium.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
      mutableExtensionsDir = false;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with (pkgs.forVSCodeVersion pkgs.vscode.version).vscode-marketplace; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        charliermarsh.ruff
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-maven
        vscjava.vscode-gradle
        vscjava.vscode-java-dependency
        vscjava.vscode-java-test
      ];
      userSettings = {
        "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "basic";
        "java.compile.nullAnalysis.mode" = "automatic";
        "java.configuration.updateBuildConfiguration" = "automatic";
        "java.format.enabled" = true;
        "java.saveActions.organizeImports" = false;
        "java.jdt.ls.java.home" = config.programs.java.package.home;
        "extensions.ignoreRecommendations" = true;
      };
    };
  };
}
