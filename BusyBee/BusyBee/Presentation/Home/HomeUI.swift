import SwiftUI

struct HomeUI: View {
    
var body: some View {
    NavigationStack {
        
        VStack(spacing: 16) {
            Greeting()
        }
        
        HStack(spacing: 16) {
            OverviewView()
        }
        VStack(spacing: 16) {
            AddButton()
        }
    }
}
}

struct OverviewView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 19)
        {
            Text("OVERVIEW")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .tracking(1.2)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                OverviewCard(icon: "play.fill", count: 12, label: "Today", color: .blue)
                OverviewCard(icon: "person.crop.circle.badge.ellipsis", count: 12, label: "Upcoming", color: .blue)
                OverviewCard(icon: "play.fill", count: 3, label: "Overdue", color: .blue)
            }
            
            Text("ITEMS")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .tracking(1.2)
                .padding(.horizontal)
            
            ListCard(title: "Gym", subtitle: "Benchpress", cardColor: Color.blue)
        }
    }
}

struct OverviewCard: View {
    let icon: String
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
            
            Text("3")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Text(label)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white.opacity(0.9))
            
            Spacer()
        }
        .padding(16)
        .frame(width: 110, height: 118, alignment: .topLeading)
        .background(color)
        .cornerRadius(12)
    }
    
}

struct Greeting: View {
    var body: some View {
        Text("Good Afternoon, Somila")
            .font(.title3).bold()
            .foregroundStyle(.black)
            .padding(.horizontal)
        
        Text(Date().formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(Locale(identifier: "en_GB"))))
            .font(.caption)
            .foregroundStyle(.black.opacity(0.7))
            .padding(.horizontal)
    }
}

struct AddButton: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(16)
        .background(Color.blue)
        .cornerRadius(12)
    }
}

struct ListCard: View {
    let title: String
    let subtitle: String
    let cardColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title).bold()
                .foregroundStyle(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(width: 100, height: 100)
        .padding(16)
        .background(cardColor)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ListItemUI{
    let letter: String
    let name: String
    let detail: String
}

#Preview {
    HomeUI()
}
