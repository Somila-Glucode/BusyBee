import SwiftUI

struct OnboardingUI: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color("primaryColor"))
                
                VStack(spacing: 8) {
                    Text("Welcome to BusyBee")
                        .font(.title.bold())
                        .foregroundStyle(Color("textColor"))
                    
                    Text("Organize your tasks into lists, track your progress, and see local weather right on your home screen.")
                        .font(.subheadline)
                        .foregroundStyle(Color("textColor").opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color("containerText"))
                            .frame(width: 40, height: 40)
                            .background(Color("primaryColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Enable Location")
                                .font(.subheadline.bold())
                                .foregroundStyle(Color("textColor"))
                            
                            Text("Used to show local weather on your home screen")
                                .font(.caption)
                                .foregroundStyle(Color("textColor").opacity(0.6))
                        }
                    }
                }
                .padding(16)
                .background(Color("primaryColor").opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 24)
                
                VStack(spacing: 12) {
                    Button {
                        locationManager.checkLocationAuthorization()
                        hasCompletedOnboarding = true
                    } label: {
                        Text("Allow Location")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .background(Color("primaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    OnboardingUI()
}

