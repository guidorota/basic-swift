import Foundation

class Parser {

    func parse(_ input: InputStream) -> Void {
        let lexer = Lexer(input)
        defer { lexer.close() }

        while lexer.hasMoreTokens {
            let token = try! lexer.getNextToken()
            print("Parsed token: \(token)")
        }
    }

}
