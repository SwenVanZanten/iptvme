import SwiftUI
import XtreamCodesKit

struct SubscriptionView: View {
    @StateObject var subscriptionVM: SubscriptionViewModel = SubscriptionViewModel()
    @State var showAddSubscriptionSheet: Bool = false
    
    let subscriptionSelected: (_ subscription: Subscription) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(10)
                
                Text("Select a subscription:")
                    .padding(10)
                
                GroupView() {
                    ForEach(subscriptionVM.subscriptions) { subscription in
                        Button {
                            subscriptionSelected(subscription)
                        } label: {
                            GroupRow(border: subscription != subscriptionVM.subscriptions.last) {
                                HStack {
                                    Text(subscription.name)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.forward")
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .frame(maxWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem {
                Button {
                    showAddSubscriptionSheet = true
                } label: {
                    Label("Add Subscription", systemImage: "plus.circle.fill")
                }
                .sheet(isPresented: $showAddSubscriptionSheet) {
                    AddScriptionSheet()
                }
            }
        }
        .environmentObject(subscriptionVM)
    }
}

struct AddScriptionSheet: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var host: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Subscription")
                .font(.title)
            
            Text("Check your IPTV providers setup guide and follow the setup for Xtream Codes usage.")
                .fixedSize(horizontal: false, vertical: true)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            GroupView {
                GroupRow {
                    HStack {
                        Image(systemName: "tag")
                        
                        TextField("Name", text: $name, prompt: Text("Name"))
                    }
                }
                GroupRow {
                    HStack {
                        Image(systemName: "person")
                        
                        TextField("Username", text: $username, prompt: Text("Username"))
                    }
                }
                GroupRow {
                    HStack {
                        Image(systemName: "ellipsis.rectangle")
                        
                        SecureField("Password", text: $password, prompt: Text("Password"))
                    }
                }
                GroupRow(border: false) {
                    HStack {
                        Image(systemName: "link")
                        
                        TextField("Host", text: $host, prompt: Text("Host"))
                    }
                }
            }
            
            HStack {
                Button {
                    addSubscription(subscription: .init(
                        name: name,
                        username: username,
                        password: password,
                        host: host
                    ))
                    
                    dismiss()
                } label: {
                    Text("Add")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .padding(40)
        .frame(minWidth: 400)
    }
    
    private func addSubscription(subscription: Subscription) {
        Task {
            try? await subscriptionVM.addSubscription(subscription: .init(
                name: name,
                username: username,
                password: password,
                host: host
            ))
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView { subscription in
            //
        }
    }
}

struct AddScriptionSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddScriptionSheet()
            .frame(maxWidth: 400)
    }
}
