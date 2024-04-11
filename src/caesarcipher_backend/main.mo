import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
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
  
  private func shift(c: Char, shift :Nat, sensitivity :CaseSensitivity): Char{
    let code = Char.toNat32(c);
    let shiftAmount = Nat32.fromNat(shift % 26);

    //Unicode Range for upper case and lower case letters
    let aLower = Char.toNat32('a');
    let aUpper = Char.toNat32('A');
    let zLower = Char.toNat32('z');
    let zUpper = Char.toNat32('Z');

    switch (sensitivity){
      case(#Ignore){
        //Convert all to lower case and shift
          let lowCode = if(Char.isUppercase(c)) code + (aLower - aUpper) else code;
          if (lowCode >= aLower and lowCode <= zLower){
            let shiftedChar = (lowCode - aLower +shiftAmount) % 26 + aLower; 
            return Char.fromNat32(shiftedChar);
          };
      };
      case(#MaintainCase){
        //
        if (Char.isUppercase(c)){
          return Char.fromNat32((code - aUpper + shiftAmount) % 26 + aUpper);
        };
        else if (Char.isLowercase(c)){
          return Char.fromNat32((code - aLower + shiftAmount) % 26 + aLower);
        };
      };
    };
    return c;
  };

};
