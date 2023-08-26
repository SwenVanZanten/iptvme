import FormValidator
import SwiftUI

class SubscriptionForm: ObservableObject {
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var host: String = ""
    
    lazy var form = {
        return FormValidation(validationType: .immediate)
    }()
    
    lazy var nameValidation: ValidationContainer = {
        return $name.nonEmptyValidator(form: form, errorMessage: "Name cannot be empty")
    }()
    
    lazy var usernameValidation: ValidationContainer = {
        return $username.nonEmptyValidator(form: form, errorMessage: "Username cannot be empty")
    }()
    
    lazy var passwordValidation: ValidationContainer = {
        return $password.nonEmptyValidator(form: form, errorMessage: "Password cannot be empty")
    }()
    
    lazy var passwordConfirmValidation: ValidationContainer = {
        return $passwordConfirm.inlineValidator(form: form, errorMessage: "Confirm password doesn't match") { value in
            return !value.isEmpty && self.password == value
        }
    }()
    
    lazy var hostValidation: ValidationContainer = {
        return $host.patternValidator(
            form: form,
            pattern: "http(s?)://[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)",
            errorMessage: "Add a valid host (eg. http://host:80)"
        )
    }()
}
