{

  # TODO: check if this is the right place to generate the global project file
  # https://github.com/dotnet/vscode-csharp/issues/5149#issuecomment-1086893318
  home.file.".omnisharp/omnisharp.json".text = builtins.toJSON {
    roslynExtensionsOptions = {
      inlayHintsOptions = {
        enableForParameters = true;
        enableForTypes = true;
        forImplicitObjectCreation = true;
        forImplicitVariableTypes = true;
        forIndexerParameters = true;
        forLambdaParameterTypes = true;
        forLiteralParameters = true;
        forObjectCreationParameters = true;
        forOtherParameters = true;
        suppressForParametersThatDifferOnlyBySuffix = false;
        suppressForParametersThatMatchArgumentName = false;
        suppressForParametersThatMatchMethodIntent = false;
      };
    };
  };
}
