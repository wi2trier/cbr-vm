{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.cbrkit.packages.${pkgs.system}.default.dependencyEnv
    maven
    gradle
  ];
  programs = {
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
      mutableExtensionsDir = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with (pkgs.forVSCodeVersion pkgs.vscode.version).vscode-marketplace; [
        visualstudioexptteam.vscodeintellicode
        visualstudioexptteam.vscodeintellicode-completions
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        charliermarsh.ruff
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-maven
        vscjava.vscode-gradle
      ];
      userSettings = {
        "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "basic";
        "java.compile.nullAnalysis.mode" = "automatic";
        "java.configuration.updateBuildConfiguration" = "automatic";
        "java.format.enabled" = true;
        "java.saveActions.organizeImports" = false;
      };
    };
  };
}
