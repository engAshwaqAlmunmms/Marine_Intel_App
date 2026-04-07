import Foundation

struct AISResponse: Decodable {
    let messageType: String
    let metaData: MetaData?
    let message: AISMessage?

    enum CodingKeys: String, CodingKey {
        case messageType = "MessageType"
        case metaData    = "MetaData"
        case message     = "Message"
    }
}

struct MetaData: Decodable {
    let mmsi: Int
    let shipName: String
    let latitude: Double
    let longitude: Double
    let timeUtc: String

    enum CodingKeys: String, CodingKey {
        case mmsi      = "MMSI"
        case shipName  = "ShipName"
        case latitude  = "latitude"
        case longitude = "longitude"
        case timeUtc   = "time_utc"
    }
}

struct AISMessage: Decodable {
    let shipStaticData: ShipStaticData?

    enum CodingKeys: String, CodingKey {
        case shipStaticData = "ShipStaticData"
    }
}

// MARK: - ShipStaticData

struct ShipStaticData: Decodable {
    let messageID: Int
    let userID: Int
    let valid: Bool
    let aisVersion: Int
    let imoNumber: Int
    let callSign: String
    let name: String
    let type: Int
    let dimension: Dimension
    let fixType: Int
    let eta: Eta
    let maximumStaticDraught: Double
    let destination: String
    let dte: Bool

    enum CodingKeys: String, CodingKey {
        case messageID            = "MessageID"
        case userID               = "UserID"
        case valid                = "Valid"
        case aisVersion           = "AisVersion"
        case imoNumber            = "ImoNumber"
        case callSign             = "CallSign"
        case name                 = "Name"
        case type                 = "Type"
        case dimension            = "Dimension"
        case fixType              = "FixType"
        case eta                  = "Eta"
        case maximumStaticDraught = "MaximumStaticDraught"
        case destination          = "Destination"
        case dte                  = "Dte"
    }

    struct Dimension: Decodable {
        let a: Int  // bow to GPS
        let b: Int  // stern to GPS
        let c: Int  // port
        let d: Int  // starboard

        var length: Int { a + b }
        var width: Int  { c + d }

        enum CodingKeys: String, CodingKey {
            case a = "A", b = "B", c = "C", d = "D"
        }
    }

    struct Eta: Decodable {
        let month: Int
        let day: Int
        let hour: Int
        let minute: Int

        enum CodingKeys: String, CodingKey {
            case month  = "Month"
            case day    = "Day"
            case hour   = "Hour"
            case minute = "Minute"
        }

        var formatted: String {
            guard month > 0 else { return "N/A" }
            return String(format: "%02d/%02d %02d:%02d UTC", month, day, hour, minute)
        }
    }
}

// MARK: - String Helper

extension String {
    var cleanedAIS: String {
        self.replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
