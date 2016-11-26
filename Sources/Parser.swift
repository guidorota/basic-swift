import Foundation

class Parser {

    func parse(input: InputStream) -> Void {
        let lexer = Lexer(input)
        defer { lexer.close() }

        while lexer.hasMoreTokens {
            let token = lexer.getNextToken()
        }
    }

}
