import Foundation

func bytes(_ string: String) -> Data {
    Data(string.utf8)
}

func emptyData() -> Data {
    Data()
}
