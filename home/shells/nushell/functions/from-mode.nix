{
  programs.nushell.extraConfig =
    # nu
    ''
      	def "from mode" []: str -> record<user: record<read: bool, write: bool, execute: bool>, group: record<read: bool, write: bool, execute: bool>, other: record<read: bool, write: bool, execute: bool>> {

      		let input = $in
      		
      	} 
    '';
}
