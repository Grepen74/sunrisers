import SwiftUI

struct SunriseDetailsView: View {
    var sunrise: Sunrise
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "sunrise")
                        
                    Text(sunrise.sunrise)
                }
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "sunset")
                    Text(sunrise.sunset)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(60)
        .font(.title)
    }
}

#Preview {
    SunriseDetailsView(sunrise: .init(timestamp: Date(), location: .init(name: "Umeå", lat: 1, long: 2), sunrise: "04:45", sunset: "18:56"))
}
