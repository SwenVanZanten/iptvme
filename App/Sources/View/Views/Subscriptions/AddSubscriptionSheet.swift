import SwiftUI
import XtreamCodesKit

struct AddSubscriptionSheet: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var form = SubscriptionForm()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Check your IPTV providers setup guide and follow the setup for Xtream Codes or IPTVSmarters usage.")
                .fixedSize(horizontal: false, vertical: true)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Form {
                Section {
                    TextField("Name:", text: $form.name, prompt: Text("Your subscription name"))
                        .validation(form.nameValidation)
                        .disableAutocorrection(true)
                    #if os(iOS)
                        .textInputAutocapitalization(.never)
                    #endif
                } header: {
                    Text("Choose your own subscription name")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Section {
                    TextField("Username:", text: $form.username, prompt: Text("Required"))
                        .validation(form.usernameValidation)
                    SecureField("Password:", text: $form.password, prompt: Text("Required"))
                        .validation(form.passwordValidation)
                    SecureField("Confirm:", text: $form.passwordConfirm, prompt: Text("Required"))
                        .validation(form.passwordConfirmValidation)
                } header: {
                    Text("Credentials can be found in the providers setup settings")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                }
                
                Section {
                    TextField("Host:", text: $form.host, prompt: Text("https://your-provider.net:8000"))
                        .validation(form.hostValidation)
                        .disableAutocorrection(true)
                    #if os(iOS)
                        .textInputAutocapitalization(.never)
                    #endif
                } header: {
                    Text("The providers host for Xtream Codes or IPTVsmarters connections")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                }
            }
            
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Button {
                    addSubscription(subscription: .init(
                        name: form.name,
                        username: form.username,
                        password: form.password,
                        host: form.host
                    ))
                    
                    dismiss()
                } label: {
                    Text("Add")
                }
                .disabled(!form.form.allValid)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(minWidth: 400)
    }
    
    private func addSubscription(subscription: Subscription) {
        Task {
            try? await subscriptionVM.addSubscription(subscription: subscription)
        }
    }
}

struct AddSubscriptionSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionSheet()
            .frame(maxWidth: 400)
    }
}
