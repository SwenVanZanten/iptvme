import SwiftUI

struct TabButton: View {
    var title: String
    var image: String
    @Binding var selectedTab: String

    var body: some View {
        Button {
            selectedTab = title
        } label: {
            HStack(spacing: 7) {
                Image(systemName: image)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.red)
            }
            .padding(7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(Color.primary.opacity(selectedTab == title ? 0.15 : 0))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}
