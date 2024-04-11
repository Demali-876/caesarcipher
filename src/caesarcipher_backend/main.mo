import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
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
  };
  public type ForeignCharacters={
    #Include;
    #Exclude;
  };
  
  private func shift(c: Char, shift: Nat, sensitivity: CaseSensitivity): Char {
  let code = Char.toNat32(c);
  let shiftAmount = Nat32.fromNat(shift % 26);

  // Unicode Range for upper case and lower case letters
  let aLower = Char.toNat32('a');
  let aUpper = Char.toNat32('A');
  let zLower = Char.toNat32('z');
  let zUpper = Char.toNat32('Z');

  switch (sensitivity) {
    case (#Ignore) {
      // Convert all to lowercase and shift
      let lowCode = if (Char.isUppercase(c)) code + (aLower - aUpper) else code;
      if (lowCode >= aLower and lowCode <= zLower) {
        let shiftedChar = (lowCode - aLower + shiftAmount) % 26 + aLower;
        return Char.fromNat32(shiftedChar);
      };
    };
    case (#MaintainCase) {
      // Shift maintaining case
      if (Char.isUppercase(c)) {
        return Char.fromNat32((code - aUpper + shiftAmount) % 26 + aUpper);
      } else if (Char.isLowercase(c)) {
        return Char.fromNat32((code - aLower + shiftAmount) % 26 + aLower);
      };
    };
  };
  return c;
};
private func unshift(c: Char, shift: Nat, sensitivity: CaseSensitivity): Char {
  let code = Char.toNat32(c);
  let shiftAmount = Nat32.fromNat(shift % 26);

  // Unicode Range for upper case and lower case letters
  let aLower = Char.toNat32('a');
  let aUpper = Char.toNat32('A');
    
    switch (sensitivity) {
        case (#Ignore) {
            // Convert all to lowercase for unshifting
            let lowCode = if (Char.isUppercase(c)) code + (aLower - aUpper) else code;
            if (lowCode >= aLower and lowCode <= Char.toNat32('z')) {
                // Wrapping the subtraction for the cipher
                let unshiftedChar = (lowCode - aLower + 26 - shiftAmount) % 26 + aLower;
                return Char.fromNat32(unshiftedChar);
            };
        };
        case (#MaintainCase) {
            // Unshift maintaining case
            if (Char.isUppercase(c)) {
                return Char.fromNat32((code - aUpper + 26 - shiftAmount) % 26 + aUpper);
            } else if (Char.isLowercase(c)) {
                return Char.fromNat32((code - aLower + 26 - shiftAmount) % 26 + aLower);
            };
        };
    };
    return c;
  };
  public func encode(message: Message): async Text {
    let Message = {
        text = message.message;
        shift = message.shift;
        sensitivity = message.sensitivity;
        foreignChar = message.foreignChar;
    };

    let encodedText = Text.map(Message.text, func(c: Char): Char {
        if (Message.foreignChar == #Include or Char.isAlphabetic(c)) {
            return shift(c, Message.shift, Message.sensitivity);
        } else {
            return c;
        }
    });
    return encodedText;
  };
  public func decode(message: Message): async Text {
    let Message = {
        text = message.message;
        shift = message.shift;
        sensitivity = message.sensitivity;
        foreignChar = message.foreignChar;
    };

    let decodedText = Text.map(Message.text, func(c: Char): Char {
        if (Message.foreignChar == #Include or Char.isAlphabetic(c)) {
            return unshift(c, Message.shift, Message.sensitivity);
        } else {
            return c;
        }
    });
    return decodedText;
  };
};
