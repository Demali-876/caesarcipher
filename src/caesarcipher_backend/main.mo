actor CaesarCipher{
  public type Message={
    message: Text;
    shift : Nat;
    sensitivity : CaseSensitivity;
    foreignChar : ForeignCharacters;

  };
  public type CaseSensitivity={
    #MaintainCase;
    #Ignore;
    #Strict;
  };
  public type ForeignCharacters={
    #Include;
    #Exclude;
  };
    public func encode(message: Message): async Text{
      
      return encodedMessage;
    };

};
