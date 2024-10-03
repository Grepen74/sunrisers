import SwiftUI
import SwiftData
import CoreLocationUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var sunrises: [Sunrise]
    
    @State var error: Error?
    
    var locationFinder: LocationProviding
    
    var sunriseService: SunriseSunsetProviding
    
    var bestGuessedLocation: Location? {
        locationFinder.location ?? sunrises.first?.location
    }
    
    let padding: CGFloat = 20
    
    var body: some View {
        NavigationSplitView {
            GeometryReader { reader in
                Grid(alignment: .leading, verticalSpacing: 16) {
                    GridRow {
                        Text("Last location")
                            .frame(width: reader.firstColumnWidth, alignment: .leading)
                        
                        Text(bestGuessedLocation?.name ?? "----")
                            .foregroundStyle(.secondary)
                            .frame(width: reader.secondColumnWidth, alignment: .leading)
                        
                        LocationButton(.currentLocation) {
                            deleteItems()
                            locationFinder.requestLocation()
                        }
                        .symbolVariant(.fill)
                        .labelStyle(.iconOnly)
                        .frame(width: 40, height: 40)
                        .cornerRadius(6)
                    }
                    
                    GridRow {
                        Text("Sunrises refreshed")
                            .frame(width: reader.firstColumnWidth, alignment: .leading)
                            
                        Text(sunrises.first?.timestamp.formatted(date: .abbreviated, time: .omitted) ?? "----")
                            .foregroundStyle(.secondary)
                            .frame(width: reader.secondColumnWidth, alignment: .leading)
                        
                        Button {
                            deleteItems()
                            Task {
                                for day in Date.nextSevenDays {
                                    guard let bestGuessedLocation else { continue }
                                    do {
                                        let sunrise = try await sunriseService.refresh(for: bestGuessedLocation, date: day)
                                        addItem(sunrise: sunrise)
                                    } catch {
                                        self.error = error
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise.square.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }.disabled(locationFinder.location == nil)
                    }
                    
                    List {
                        Section {
                            ForEach(sunrises) { sunrise in
                                NavigationLink {
                                    SunriseDetailsView(sunrise: sunrise)
                                        .navigationTitle(sunrise.timestamp.formatted(date: .abbreviated, time: .omitted))
                                } label: {
                                    ListRowView(sunrise: sunrise)
                                }
                            }                        }
                        header: {
                            Text("Sunrise for the next seven days")
                        }
                    }
                    .navigationTitle("Find sunrises")
                    .padding(.horizontal, -padding)
                }
            }
            .alert("Something went wrong",
                   isPresented: Binding(get: { error != nil }, set: { _ in error = nil }),
                   actions: { Button("OK", role: nil, action: {}) },
                   message: { Text(error?.localizedDescription ?? "") })
            .padding(padding)
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addItem(sunrise: Sunrise) {
        withAnimation {
            modelContext.insert(sunrise)
            try? modelContext.save()
        }
    }
    
    private func deleteItems() {
        withAnimation {
            for item in sunrises {
                modelContext.delete(item)
            }
        }
    }
}


#Preview {
    let locationService = FakeLocationService()
    
    let sunriseService = FakeSunriseService()
    
    return ContentView(locationFinder: locationService,
                       sunriseService: sunriseService)
        .modelContainer(for: Sunrise.self, inMemory: true)
}

#Preview {
    let locationService = FakeLocationService()
    
    let sunriseService = FakeSunriseService()
    
    sunriseService.error = FakeSunriseService.SunriseServiceErrors.noSunrisesFound
    
    return ContentView(locationFinder: locationService,
                       sunriseService: sunriseService)
        .modelContainer(for: Sunrise.self, inMemory: true)
}
