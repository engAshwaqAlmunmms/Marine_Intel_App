import Foundation

struct AISResponse: Codable {
    let messageType: String?
    let metaData: MetaDataResponse?

    enum CodingKeys: String, CodingKey {
        case messageType = "MessageType"
        case metaData = "MetaData"
    }
}

struct MetaDataResponse: Codable {
    let shipName: String?
    let mmsi: Int? // Maritime Mobile Service Identity , 9 digit
    let latitude: Double?
    let longitude: Double?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case shipName = "ShipName"
        case mmsi = "MMSI"
        case latitude
        case longitude
        case time = "time_utc"
    }
}

struct MessageResponse: Codable {
    let positionReport: PositionReportResponse?
    
    enum CodingKeys: String, CodingKey {
        case positionReport = "PositionReport"
    }
}

struct PositionReportResponse: Codable {
    let cog: Int?
    let communicationState: Int?
    let latitude: Double?
    let longitude: Double?
    let messageID: Int?
    let navigationalStatus: Int?
    let positionAccuracy: Bool?
    let raim: Bool?
    let rateOfTurn: Int?
    let repeatIndicator: Int?
    let sog: Int?
    let spare: Int?
    let specialManoeuvreIndicator: Int?
    let timestamp: Int?
    let trueHeading: Int?
    let userID: Int?
    let valid: Bool?
    
    enum CodingKeys: String, CodingKey {
        case cog = "Cog"
        case communicationState = "CommunicationState"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case messageID = "MessageID"
        case navigationalStatus = "NavigationalStatus"
        case positionAccuracy = "PositionAccuracy"
        case raim = "Raim"
        case rateOfTurn = "RateOfTurn"
        case repeatIndicator = "RepeatIndicator"
        case sog = "Sog"
        case spare = "Spare"
        case specialManoeuvreIndicator = "SpecialManoeuvreIndicator"
        case timestamp = "Timestamp"
        case trueHeading = "TrueHeading"
        case userID = "UserID"
        case valid = "Valid"
    }
}
