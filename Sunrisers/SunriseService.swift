import Foundation

protocol SunriseSunsetProviding {
    @MainActor func refresh(for location: Location, date: Date) async throws -> Sunrise
}

// https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&date=today&formatted=0

@MainActor
final class SunriseService: SunriseSunsetProviding, Sendable {
    
    func refresh(for location: Location, date: Date) async throws -> Sunrise {
        let urlSession = URLSession.shared
        
        let request = URLRequest(url: URL(string: "https://api.sunrise-sunset.org/json?lat=\(location.lat)&lng=\(location.long)&date=\(date.formatted(date: .abbreviated, time: .omitted))&formatted=0")!)
        
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let dataItem = try decoder.decode(SunriseData.self, from: data)
        
        return Sunrise(timestamp: date, location: location, sunrise: dataItem.results.sunrise.formatted(date: .omitted, time: .shortened), sunset: dataItem.results.sunset.formatted(date: .omitted, time: .shortened))
    }
}

@MainActor
class FakeSunriseService: SunriseSunsetProviding {
    
    enum SunriseServiceErrors: Error {
        case noSunrisesFound
    }
    
    var sunrises = Date.nextSevenDays.reduce(into: [String: Sunrise]()) {
        $0[$1.formatted(date: .abbreviated, time: .omitted)] = Sunrise(timestamp: $1, location: .mock, sunrise: "06:15", sunset: "Sunset time")
    }
    
    var error: Error?
    
    func refresh(for location: Location, date: Date) async throws -> Sunrise {
        if let error { throw error }
        return sunrises[date.formatted(date: .abbreviated, time: .omitted)]!
    }
}
