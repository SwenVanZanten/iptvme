import SwiftUI
import XtreamCodesKit

struct SubscriptionViewOld: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @State var showAddSubscriptionSheet: Bool = false
    @State var showSubscriptionStats: Bool = false
    @State var editMode: Bool = false
    
    let subscriptionSelected: (_ subscription: Subscription) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                GroupView() {
                    ForEach(subscriptionVM.subscriptions) { subscription in
                        Button {
                            if !editMode {
                                subscriptionSelected(subscription)
                            }
                        } label: {
                            GroupRow(border: subscription != subscriptionVM.subscriptions.last) {
                                HStack {
                                    Text(subscription.name)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    if !editMode {
                                        Button {
                                            showSubscriptionStats.toggle()
                                        } label: {
                                            Image(systemName: "info.circle.fill")
                                        }
                                        .buttonStyle(.plain)
                                        .sheet(isPresented: $showSubscriptionStats) {
                                            Text(subscription.name)
                                        }
                                        
                                        Image(systemName: "chevron.forward")
                                    } else {
                                        Button {
                                            Task {
                                                try await subscriptionVM.deleteSubscription(subscription: subscription)
                                            }
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(.plain)
                                    }
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
            ToolbarItemGroup {
                Button {
                    editMode.toggle()
                } label: {
                    Label("Edit", systemImage: editMode ? "chevron.backward" : "ellipsis")
                }
                
                if !editMode {
                    Button {
                        showAddSubscriptionSheet = true
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                    .sheet(isPresented: $showAddSubscriptionSheet) {
                        AddSubscriptionSheet()
                    }
                }
            }
        }
        .environmentObject(subscriptionVM)
    }
}

struct SubscriptionViewOld_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionViewOld { subscription in
            //
        }
    }
}
