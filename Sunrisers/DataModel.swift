import Foundation
import SwiftData

@Model
final class Sunrise: Identifiable {
    var timestamp: Date
    var location: Location?
    var sunset: String
    var sunrise: String
    
    init(timestamp: Date,
         location: Location,
         sunrise: String,
         sunset: String) {
        self.timestamp = timestamp
        self.sunset = sunset
        self.sunrise = sunrise
        self.location = location
    }
}

struct SunriseData: Codable {
    let results: InternalRepresentation
    let status, tzid: String
    
    struct InternalRepresentation: Codable {
        let sunrise, sunset: Date
        let solarNoon: String?
        let dayLength: Int
        
        enum CodingKeys: String, CodingKey {
            case sunrise, sunset
            case solarNoon = "solar_noon"
            case dayLength = "day_length"
        }
    }
}
