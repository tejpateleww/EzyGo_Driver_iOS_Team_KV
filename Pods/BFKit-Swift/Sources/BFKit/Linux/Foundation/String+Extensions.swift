//
//  String+Extensions.swift
//  BFKit-Swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 - 2018 Fabrizio Brancati.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

// MARK: - String extension

/// This extesion adds some useful functions to String.
public extension String {
    // MARK: - Variables

    /// Gets the individual characters and puts them in an array as Strings.
    var array: [String] {
        return description.map { String($0) }
    }
    
    /// Returns the Float value
    public var floatValue: Float {
        return NSString(string: self).floatValue
    }
    
    /// Returns the Int value
    public var intValue: Int {
        return Int(NSString(string: self).intValue)
    }

    /// Convert self to a Data.
    public var dataValue: Data? {
        return data(using: .utf8)
    }
    
    /// Encoded string to Base64.
    public var base64encoded: String {
        guard let data: Data = data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString()
    }
    
    /// Decoded Base64 to string.
    public var base64decoded: String {
        guard let data = Data(base64Encoded: String(self), options: .ignoreUnknownCharacters), let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return ""
        }
        return String(describing: dataString)
    }
    
    /// Encode self to an encoded url string.
    public var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
    }
    
    // MARK: - Functions
    
    @available(*, deprecated: 3.2, renamed: "count", message: "`length` is deprecated and will be removed in BFKit-Swift 4.")
    /// Returns the lenght of the string.
    public var length: Int {
        return count
    }
    
    /// Get the character at a given index.
    ///
    /// - Parameter index: The index.
    /// - Returns: Returns the character at a given index, starts from 0.
    public func character(at index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Returns a new string containing the characters of the String from the one at a given index to the end.
    ///
    /// - Parameter index: The index.
    /// - Returns: Returns the substring from index.
    public func substring(from index: Int) -> String {
        return String(self[self.index(startIndex, offsetBy: index)...])
    }
    
    /// Creates a substring from the given character.
    ///
    /// - Parameter character: The character.
    /// - Returns: Returns the substring from character.
    public func substring(from character: Character) -> String {
        let index: Int = self.index(of: character)
        guard index > -1 else {
            return ""
        }
        return substring(from: index + 1)
    }
    
    /// Returns a new string containing the characters of the String up to, but not including, the one at a given index.
    ///
    /// - Parameter index: The index.
    /// - Returns: Returns the substring to index.
    public func substring(to index: Int) -> String {
        guard index <= count else {
            return ""
        }
        return String(self[..<self.index(startIndex, offsetBy: index)])
    }
    
    /// Creates a substring to the given character.
    ///
    /// - Parameter character: The character.
    /// - Returns: Returns the substring to character.
    public func substring(to character: Character) -> String {
        let index: Int = self.index(of: character)
        guard index > -1 else {
            return ""
        }
        return substring(to: index)
    }
    
    /// Creates a substring with a given range.
    ///
    /// - Parameter range: The range.
    /// - Returns: Returns the string between the range.
    public func substring(with range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)

        return String(self[start..<end])
    }
    
    /// Creates a substring with a given range.
    ///
    /// - Parameter range: The range.
    /// - Returns: Returns the string between the range.
    public func substring(with range: CountableClosedRange<Int>) -> String {
        return substring(with: Range(uncheckedBounds: (lower: range.lowerBound, upper: range.upperBound + 1)))
    }
    
    /// Returns the index of the given character.
    ///
    /// - Parameter character: The character to search.
    /// - Returns: Returns the index of the given character, -1 if not found.
    public func index(of character: Character) -> Int {
        guard let index: Index = index(of: character) else {
            return -1
        }
        
        return distance(from: startIndex, to: index)
    }
    
    /// Check if self has the given substring in case-sensitiv or case-insensitive.
    ///
    /// - Parameters:
    ///   - string: The substring to be searched.
    ///   - caseSensitive: If the search has to be case-sensitive or not.
    /// - Returns: Returns true if founded, otherwise false.
    public func range(of string: String, caseSensitive: Bool = true) -> Bool {
        return caseSensitive ? (range(of: string) != nil) : (lowercased().range(of: string.lowercased()) != nil)
    }
    
    /// Check if self has the given substring in case-sensitiv or case-insensitive.
    ///
    /// - Parameters:
    ///   - string: The substring to be searched.
    ///   - caseSensitive: If the search has to be case-sensitive or not.
    /// - Returns: Returns true if founded, otherwise false.
    public func has(_ string: String, caseSensitive: Bool = true) -> Bool {
        return range(of: string, caseSensitive: caseSensitive)
    }
    
    /// Returns the number of occurrences of a String into 
    ///
    /// - Parameter string: String of occurrences.
    /// - Returns: Returns the number of occurrences of a String into 
    public func occurrences(of string: String, caseSensitive: Bool = true) -> Int {
        var string = string
        if !caseSensitive {
            string = string.lowercased()
        }
        return lowercased().components(separatedBy: string).count - 1
    }
    
    /// Conver self to a capitalized string.
    /// Example: "This is a Test" will return "This is a test" and "this is a test" will return "This is a test".
    ///
    /// - Returns: Returns the capitalized sentence string.
    public func sentenceCapitalizedString() -> String {
        guard !isEmpty else {
            return ""
        }
        let uppercase: String = substring(to: 1).uppercased()
        let lowercase: String = substring(from: 1).lowercased()

        return uppercase + lowercase
    }
    
    /// Convert a String to a NSAttributedString.
    /// With that variable you can customize a String with a style.
    ///
    /// Example:
    ///
    ///     string.attributedString.font(UIFont(fontName: .helveticaNeue, size: 20))
    ///
    /// You can even concatenate two or more styles:
    ///
    ///     string.attributedString.font(UIFont(fontName: .helveticaNeue, size: 20)).backgroundColor(UIColor.red)
    public var attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    /// Returns the last path component.
    public var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }

    /// Returns the path extension.
    public var pathExtension: String {
        return NSString(string: self).pathExtension
    }

    /// Delete the last path component.
    public var deletingLastPathComponent: String {
        return NSString(string: self).deletingLastPathComponent
    }

    /// Delete the path extension.
    public var deletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }

    /// Returns an array of path components.
    public var pathComponents: [String] {
        return NSString(string: self).pathComponents
    }
    
    /// Appends a path component to the string.
    ///
    /// - Parameter path: Path component to append.
    /// - Returns: Returns all the string.
    public func appendingPathComponent(_ path: String) -> String {
        let string = NSString(string: self)

        return string.appendingPathComponent(path)
    }
    
    /// Appends a path extension to the string.
    ///
    /// - Parameter ext: Extension to append.
    /// - Returns: Returns all the string.
    public func appendingPathExtension(_ ext: String) -> String? {
        let nsSt = NSString(string: self)

        return nsSt.appendingPathExtension(ext)
    }
    
    /// Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    ///
    /// - Returns: Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    public func readableUUID() -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
    /// Returns string with the first character uppercased.
    ///
    /// - returns: Returns string with the first character uppercased.
    public func uppercasedFirst() -> String {
        return String(prefix(1)).uppercased() + String(dropFirst())
    }
    
    /// Returns string with the first character lowercased.
    ///
    /// - returns: Returns string with the first character lowercased.
    public func lowercasedFirst() -> String {
        return String(prefix(1)).lowercased() + String(dropFirst())
    }
    
    /// Returns the reversed String.
    ///
    /// - parameter preserveFormat: If set to true preserve the String format.
    ///                             The default value is false.
    ///                             **Example:**
    ///                                 "Let's try this function?" ->
    ///                                 "?noitcnuf siht yrt S'tel"
    ///
    /// - returns: Returns the reversed String.
    public func reversed(preserveFormat: Bool) -> String {
        guard !isEmpty else {
            return ""
        }

        var reversed = String(removeExtraSpaces().reversed())

        guard preserveFormat else {
            return reversed
        }

        let words = reversed.components(separatedBy: " ").filter { !$0.isEmpty }

        reversed.removeAll()
        for word in words {
            if let char = word.unicodeScalars.last {
                if CharacterSet.uppercaseLetters.contains(char) {
                    reversed += word.lowercased().uppercasedFirst()
                } else {
                    reversed += word.lowercased()
                }
            } else {
                reversed += word.lowercased()
            }
            
            if word != words[words.count - 1] {
                reversed += " "
            }
        }

        return reversed
    }
    
    /// Returns true if the String has at least one uppercase chatacter, otherwise false.
    ///
    /// - returns: Returns true if the String has at least one uppercase chatacter, otherwise false.
    public func hasUppercasedCharacters() -> Bool {
        var found = false
        for character in unicodeScalars where CharacterSet.uppercaseLetters.contains(character) {
            found = true
        }
        return found
    }
    
    /// Returns true if the String has at least one lowercase chatacter, otherwise false.
    ///
    /// - returns: Returns true if the String has at least one lowercase chatacter, otherwise false.
    public func hasLowercasedCharacters() -> Bool {
        var found = false
        for character in unicodeScalars where CharacterSet.lowercaseLetters.contains(character) {
            found = true
        }
        return found
    }
    
    /// Remove double or more duplicated spaces.
    ///
    /// - returns: Remove double or more duplicated spaces.
    public func removeExtraSpaces() -> String {
        let squashed = replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression, range: nil)
        return squashed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Returns a new string in which all occurrences of a target strings in a specified range of the String are replaced by another given string.
    ///
    /// - Parameters:
    ///   - target: Target strings array.
    ///   - replacement: Replacement string.
    /// - Returns: Returns a new string in which all occurrences of a target strings in a specified range of the String are replaced by another given string.
    public func replacingOccurrences(of target: [String], with replacement: String) -> String {
        var string = self
        for occurrence in target {
            string = string.replacingOccurrences(of: occurrence, with: replacement)
        }
        
        return string
    }
    
    /// Count the number of lowercase characters.
    ///
    /// - Returns: Number of lowercase characters.
    public func countLowercasedCharacters() -> Int {
        var countChar = 0
        for index in 0 ..< count {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: index)) else {
                return 0
            }
            let isLowercase = CharacterSet.lowercaseLetters.contains(character)
            if isLowercase {
                countChar += 1
            }
        }
        
        return countChar
    }
    
    /// Count the number of uppercase characters.
    ///
    /// - Returns: Number of uppercase characters.
    public func countUppercasedCharacters() -> Int {
        var countChar = 0
        for index in 0 ..< count {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: index)) else {
                return 0
            }
            let isUppercase = CharacterSet.uppercaseLetters.contains(character)
            if isUppercase {
                countChar += 1
            }
        }
        
        return countChar
    }
    
    /// Count the number of numbers.
    ///
    /// - Returns: Number of numbers.
    public func countNumbers() -> Int {
        var countNumber = 0
        for index in 0 ..< count {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: index)) else {
                return 0
            }
            let isNumber = CharacterSet(charactersIn: "0123456789").contains(character)
            if isNumber {
                countNumber += 1
            }
        }
        
        return countNumber
    }
    
    /// Count the number of symbols.
    ///
    /// - Returns: Number of symbols.
    public func countSymbols() -> Int {
        var countSymbol = 0
        for index in 0 ..< count {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: index)) else {
                return 0
            }
            let isSymbol = CharacterSet(charactersIn: "`~!?@#$?????????%^&*()_+-={}[]:\";.,<>'???\\|/").contains(character)
            if isSymbol {
                countSymbol += 1
            }
        }
        
        return countSymbol
    }
    
    /// Convert HEX string (separated by space) to "usual" characters string.
    /// Example: "68 65 6c 6c 6f" -> "hello".
    ///
    /// - Returns: Readable string.
    public func stringFromHEX() -> String {
        var hex = self
        var string: String = ""
        
        hex = hex.replacingOccurrences(of: " ", with: "")
        
        while !hex.isEmpty {
            let character = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])
            var characterInt: UInt32 = 0
            
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
            _ = Scanner(string: character).scanHexInt32(&characterInt)
            string += String(format: "%c", characterInt)
        }
        return string
    }
    
    /// Return if self is anagram of another String.
    ///
    /// - Parameter string: Other String.
    /// - Returns: Return true if self is anagram of another String, otherwise false.
    public func isAnagram(of string: String) -> Bool {
        let lowerSelf = lowercased().replacingOccurrences(of: " ", with: "")
        let lowerOther = string.lowercased().replacingOccurrences(of: " ", with: "")
        return lowerSelf.sorted() == lowerOther.sorted()
    }
    
    /// Returns if self is palindrome.
    ///
    /// - Returns: Returns true if self is palindrome, otherwise false.
    public func isPalindrome() -> Bool {
        let selfString = lowercased().replacingOccurrences(of: " ", with: "")
        let otherString = String(selfString.reversed())
        return selfString == otherString
    }
    
    /// Returns the character at the given index.
    ///
    /// - Parameter index: Returns the character at the given index.
    public subscript(index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Returns the index of the given character, -1 if not found.
    ///
    /// - Parameter character: Returns the index of the given character, -1 if not found.
    public subscript(character: Character) -> Int {
        return index(of: character)
    }
    
    /// Returns the character at the given index as String.
    ///
    /// - Parameter index: Returns the character at the given index as String.
    public subscript(index: Int) -> String {
        return String(self[index])
    }
    
    /// Returns the string from a given range.
    /// Example: print("BFKit"[1...3]) the result is "FKi".
    ///
    /// - Parameter range: Returns the string from a given range.
    public subscript(range: Range<Int>) -> String {
        return substring(with: range)
    }
    
    /// Returns if self is a valid UUID or not.
    ///
    /// - Returns: Returns if self is a valid UUID or not.
    public func isUUID() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: count))
            return matches == 1
        } catch {
            return false
        }
    }
    
    /// Returns if self is a valid UUID for APNS (Apple Push Notification System) or not.
    ///
    /// - Returns: Returns if self is a valid UUID for APNS (Apple Push Notification System) or not.
    public func isUUIDForAPNS() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{32}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: count))
            return matches == 1
        } catch {
            return false
        }
    }
    
    /// Returns a new string containing matching regular expressions replaced with the template string.
    ///
    /// - Parameters:
    ///   - regexString: The regex string.
    ///   - replacement: The replacement string.
    /// - Returns: Returns a new string containing matching regular expressions replaced with the template string.
    /// - Throws: Throws NSRegularExpression(pattern:, options:) errors.
    public func replacingMatches(regex regexString: String, with replacement: String) throws -> String {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count), withTemplate: "")
    }
    
    /// Localize current String using self as key.
    ///
    /// - Returns: Returns localized String using self as key.
    public func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    // MARK: - Functions not available on Linux
    
    #if !os(Linux)
        /// Check if self is an email.
        ///
        /// - Returns: Returns true if it is an email, otherwise false.
        public func isEmail() -> Bool {
            let emailRegEx: String = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
            
            let regExPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            
            return regExPredicate.evaluate(with: lowercased())
        }
    
        /// Returns an array of String with all the links in 
        ///
        /// - Returns: Returns an array of String with all the links in 
        /// - Throws: Throws NSDataDetector errors.
        public func links() throws -> [String] {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            
            let links = Array(detector.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: count)))
            
            return links.filter { $0.url != nil }.map { $0.url?.absoluteString ?? "" }
        }

        /// Returns an array of Date with all the dates in 
        ///
        /// - Returns: Returns an array of Date with all the date in 
        /// - Throws: Throws NSDataDetector errors.
        public func dates() throws -> [Date] {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            
            let dates = Array(detector.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange(location: 0, length: count)))
            
            return dates.filter { $0.date != nil }.map { $0.date ?? Date() }
        }
    
        /// Returns an array of String with all the hashtags in 
        ///
        /// - Returns: Returns an array of String with all the hashtags in 
        /// - Throws: Throws NSRegularExpression errors.
        public func hashtags() throws -> [String] {
            let detector = try NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
            let hashtags = Array(detector.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSRange(location: 0, length: count)))
            
            return hashtags.map { (self as NSString).substring(with: $0.range(at: 1)) }
        }
    
        /// Returns an array of String with all the mentions in 
        ///
        /// - Returns: Returns an array of String with all the mentions in 
        /// - Throws: Throws NSRegularExpression errors.
        public func mentions() throws -> [String] {
            let detector = try NSRegularExpression(pattern: "@(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
            let mentions = Array(detector.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSRange(location: 0, length: count)))
            
            return mentions.map { (self as NSString).substring(with: $0.range(at: 1)) }
        }
    #endif
}

/// Infix operator `???` with NilCoalescingPrecedence.
infix operator ???: NilCoalescingPrecedence

/// Returns defaultValue if optional is nil, otherwise returns optional.
///
/// - Parameters:
///   - optional: The optional variable.
///   - defaultValue: The default value.
/// - Returns: Returns defaultValue if optional is nil, otherwise returns optional.
public func ??? <T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    return optional.map { String(describing: $0) } ?? defaultValue()
}
