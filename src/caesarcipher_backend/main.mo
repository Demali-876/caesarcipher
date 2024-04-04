
actor CaesarCipher{
  public type Message={
    message: Text;
    shift : Nat;
    sensitivity : CaseSensitivity;


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
    public func encode(message : Text, shift : Nat): async Text{
      return message;

    };
};
