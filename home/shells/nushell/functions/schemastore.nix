# { pkgs, ... }:
{
  programs.nushell.extraConfig = # nu
    ''
      		# https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json
      		# https://www.schemastore.org/json/

      		def schemastore [] {
              
            }

            def "schemastore list" [] {
              
            }

            def "schemastore get" [schema: string] {
              
            }

            # TODO: generate dynamic completions


            # TODO: create a `schemastore-ls` that will be active for json/toml/yaml files, and suggest to download a schema
            # if it can detect that you are editing a file that has a schema in the store, and is not available for your current file.
      	'';
}
