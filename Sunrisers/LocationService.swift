import Foundation
import CoreLocation
@preconcurrency import MapKit

struct Location: Sendable, Codable {
    var name: String
    var lat, long: Double
}

@MainActor
protocol LocationProviding: Observable {
    func requestLocation()
    var location: Location? { get }
}

@MainActor
@Observable final class LocationService: NSObject, LocationProviding, @preconcurrency CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    private(set) var location: Location?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else {
            return
        }
        
        Task {
            let name = try await placeName(from: location)
            await MainActor.run {
                self.location = .init(name: name, lat: location.latitude, long: location.longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
    func placeName(from coordinates: CLLocationCoordinate2D) async throws -> String {
        
        let searchRequest = MKLocalPointsOfInterestRequest(center: coordinates, radius: 2000)
        
        var search: MKLocalSearch?
        search = MKLocalSearch(request: searchRequest)
        
        let response = try await search?.start()
        guard
            let response = response,
            let mapItem = response.mapItems.first,
            let name = mapItem.placemark.locality ?? mapItem.placemark.name else {
            throw FindLocationError.findNameError
        }
        return name
    }
}

enum FindLocationError: Error {
    case findNameError
}

@MainActor
class FakeLocationService: LocationProviding {
    func requestLocation() {
    }
    
    var location: Location? = .mock
}
