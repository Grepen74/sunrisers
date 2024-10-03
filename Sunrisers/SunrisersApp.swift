import SwiftUI
import SwiftData

@main
struct SunrisersApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Sunrise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: useMockedServices)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let useMockedServices: Bool = CommandLine.arguments.contains("mocked-services")
    
    let sunriseService: SunriseSunsetProviding = useMockedServices ? FakeSunriseService() : SunriseService()
    let locationService: LocationProviding = useMockedServices ? FakeLocationService() : LocationService()

    var body: some Scene {
        WindowGroup {
            ContentView(locationFinder: locationService, sunriseService: sunriseService)
        }
        .modelContainer(sharedModelContainer)
    }
}
