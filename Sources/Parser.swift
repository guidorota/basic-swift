import Foundation

class Parser {

    func parse(_ input: String) -> Void {
        let stream = InputStream(data: input.data(using: .utf8)!)
        stream.open()
        parse(stream)
        stream.close()
    }

    func parse(_ input: InputStream) -> Void {
        let lexer = Lexer(input)

        while lexer.hasMoreTokens {
            let token = try! lexer.getNextToken()
            print("Parsed token: \(token)")
        }
    }

}
