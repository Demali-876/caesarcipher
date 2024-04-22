import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";

actor CaesarCipher {
    public type Message = {
        message: Text;
        shift: Nat;
        sensitivity: CaseSensitivity;
        foreignChar: ForeignCharacters;
    };

    public type CaseSensitivity = {
        #MaintainCase;
        #Ignore;
    };

    public type ForeignCharacters = {
        #Include;
        #Exclude;
    };

    private func shift(c: Char, shift: Nat, sensitivity: CaseSensitivity): Char {
        let code = Char.toNat32(c);
        let shiftAmount = Nat32.fromNat(shift % 26);

        let aLower = Char.toNat32('a');
        let aUpper = Char.toNat32('A');
        let zLower = Char.toNat32('z');
        let zUpper = Char.toNat32('Z');

        switch (sensitivity) {
            case (#Ignore){
                // Convert all to lowercase and shift
                let lowCode = if (Char.isUppercase(c)) code + 32 else code;
                if (lowCode >= aLower and lowCode <= zLower) {
                    return Char.fromNat32((lowCode - aLower + shiftAmount) % 26 + aLower);
                };
              };
            case (#MaintainCase){
                // Shift maintaining case
                if (Char.isUppercase(c)) {
                    if (code >= aUpper and code <= zUpper) {
                        return Char.fromNat32((code - aUpper + shiftAmount) % 26 + aUpper);
                    };
                } else if (Char.isLowercase(c)) {
                    if (code >= aLower and code <= zLower) {
                        return Char.fromNat32((code - aLower + shiftAmount) % 26 + aLower);
                    };
                };
              };
          };
        return c;
    };

    private func unshift(c: Char, shift: Nat, sensitivity: CaseSensitivity): Char {
        let code = Char.toNat32(c);
        let shiftAmount = Nat32.fromNat(shift % 26);

        let aLower = Char.toNat32('a');
        let aUpper = Char.toNat32('A');

        switch (sensitivity) {
            case (#Ignore){
                let lowCode = if (Char.isUppercase(c)) code + 32 else code;
                if (lowCode >= aLower and lowCode <= Char.toNat32('z')) {
                    return Char.fromNat32((lowCode - aLower + 26 - shiftAmount) % 26 + aLower);
                  };
                };
            case (#MaintainCase){
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
      var filteredText: Text = "";
      for (c in Text.toIter(message.message)) {
          if (Char.isAlphabetic(c) or (message.foreignChar == #Include and not Char.isWhitespace(c))) {
              filteredText := Text.concat(filteredText, Text.fromChar(c));
          } else if (Char.isWhitespace(c)) {
              filteredText := Text.concat(filteredText, Text.fromChar(c));
          };
      };
      return Text.map(filteredText, func(c: Char): Char {
          return shift(c, message.shift, message.sensitivity);
      });
    };

public func decode(message: Message): async Text {
    var filteredText: Text = "";
    for (c in Text.toIter(message.message)) {
        if (Char.isAlphabetic(c) or (message.foreignChar == #Include and not Char.isWhitespace(c))) {
            filteredText := Text.concat(filteredText, Text.fromChar(c));
        } else if (Char.isWhitespace(c)) {
            filteredText := Text.concat(filteredText, Text.fromChar(c));
        };
    };
    return Text.map(filteredText, func(c: Char): Char {
        return unshift(c, message.shift, message.sensitivity);
    });
};

    public func encodeUtf8(text : Text) : async Blob {
    return Text.encodeUtf8(text);
    };
    public func decodeUtf8(blob : Blob) : async ?Text {
      return Text.decodeUtf8(blob);
    };
};
