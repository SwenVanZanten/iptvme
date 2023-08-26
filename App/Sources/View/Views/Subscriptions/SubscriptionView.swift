import SwiftUI
import XtreamCodesKit

struct SubscriptionView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    
    let subscriptionSelected: (_ subscription: Subscription) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            AddSubscriptionView()
            
            SubscriptionsListView() { subscription in
                subscriptionSelected(subscription)
            }
            .ignoresSafeArea()
            .frame(width: 300)
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView { subscription in
            //
        }
        .frame(width: 800, height: 450)
        .environmentObject(SubscriptionViewModel())
    }
}
