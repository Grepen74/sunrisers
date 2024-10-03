import SwiftUI

struct ListRowView: View {
    var sunrise: Sunrise
    
    var body: some View {
        HStack(spacing: 24) {
            Text(sunrise.timestamp, format: Date.FormatStyle(date: .numeric, time: .omitted))
            Spacer()
            Image(systemName: "sunrise")
            Text(sunrise.sunrise)
            Spacer()
        }
        .padding(4)
    }
}

extension Location {
    static var mock: Location {
        Location(name: "Stockholm", lat: 1, long: 1)
    }
}

#Preview {
    ListRowView(sunrise: .init(timestamp: Date(), location: .mock, sunrise: "07:45", sunset: "22:00"))
}
