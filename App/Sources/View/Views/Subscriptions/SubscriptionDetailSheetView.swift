import SwiftUI
import XtreamCodesKit

struct SubscriptionDetailSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var subscription: Subscription
    var remove: (_ subscription: Subscription) -> Void
    @State var authenticated: Authenticated? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                GroupView {
                    GroupRow {
                        SubscriptionDetailView(label: "Name", value: subscription.name)
                    }
                    GroupRow {
                        SubscriptionDetailView(label: "Username", value: subscription.username)
                    }
                    GroupRow {
                        SubscriptionDetailView(label: "Password", value: subscription.password)
                    }
                    GroupRow(border: false) {
                        SubscriptionDetailView(label: "Host", value: subscription.host)
                    }
                }
                
                Text("Connections")
                    .font(.headline)
                    .padding(.top, 10)

                GroupView {
                    GroupRow {
                        SubscriptionDetailView(label: "Max", value: authenticated?.userInfo.maxConnections.description ?? "0")
                    }
                    GroupRow(border: false) {
                        SubscriptionDetailView(label: "Active", value: authenticated?.userInfo.activeConnections.description ?? "0")
                    }
                }
            }
            .padding(20)
            
            Divider()
            
            HStack {
                Button("Remove", role: .destructive) {
                    dismiss()
                    remove(subscription)
                }.buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
            }
            .padding(20)
        }
        .task {
            do {
                let api = Api(
                    host: subscription.host,
                    username: subscription.username,
                    password: subscription.password
                )
                
                self.authenticated = try await api.authenticate()
            } catch {
                print(error)
            }
        }
        .frame(minWidth: 400)
    }
}

struct SubscriptionDetailView: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct SubscriptionDetailSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionDetailSheetView(subscription: .init(name: "Test subscription", username: "MyUsername", password: "passwordVerySecret", host: "https://abetter-host.com")) { _ in
            //
        }
    }
}
