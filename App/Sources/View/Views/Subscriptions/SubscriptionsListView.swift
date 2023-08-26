import SwiftUI
import XtreamCodesKit

struct SubscriptionsListView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @State var showSubscriptionStats: Bool = false
    @State var showDeleteSubscriptionAlert: Bool = false
    
    let subscriptionSelected: (_ subscription: Subscription) -> Void
    
    var body: some View {
        List(selection: $subscriptionVM.selectedSubscription) {
            ForEach(subscriptionVM.subscriptions) { subscription in
                Button {
                    subscriptionSelected(subscription)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(subscription.name)
                                .bold()
                            Text(subscription.host)
                                .font(.caption)
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                    }
                }
                .contextMenu {
                    Button("Open") {
                        subscriptionVM.selectedSubscription = subscription
                        subscriptionSelected(subscription)
                    }
                    Divider()
                    Button("Show details") {
                        subscriptionVM.selectedSubscription = subscription
                        showSubscriptionStats = true
                    }
                    Button("Remove") {
                        subscriptionVM.selectedSubscription = subscription
                        showDeleteSubscriptionAlert.toggle()
                    }
                }
                .buttonStyle(SubscriptionButtonStyle())
            }
        }
        .listStyle(.sidebar)
        .sheet(isPresented: $showSubscriptionStats) {
            SubscriptionDetailSheetView(subscription: subscriptionVM.selectedSubscription!) { subscription in
                subscriptionVM.selectedSubscription = subscription
                showDeleteSubscriptionAlert.toggle()
            }
        }
        .alert("Confirm delete", isPresented: $showDeleteSubscriptionAlert, actions: {
            Button("Delete", role: .destructive) {
                Task {
                    try await subscriptionVM.deleteSubscription(subscription: subscriptionVM.selectedSubscription!)
                }
            }
            
            Button("Cancel", role: .cancel) { }
        })
    }
}

struct SubscriptionButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding(5)
      .background(configuration.isPressed ? .red : Color.clear)
      .foregroundColor(configuration.isPressed ? .white : nil)
      .cornerRadius(5)
      .frame(maxWidth: .infinity, alignment: .leading)
      .contentShape(Rectangle())
  }
}

struct SubscriptionsListView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsListView() { subscription in
            //
        }
    }
}
