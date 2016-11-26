import Foundation

print("BASIC Swift - (C) Guido Rota 2016")

repeat {
    guard let line = readLine(), line.characters.count > 0 else {
        continue
    }

    let inputStream: InputStream? = Data(base64Encoded: line).map { data in InputStream(data: data) }

    print("Got line")
} while true
