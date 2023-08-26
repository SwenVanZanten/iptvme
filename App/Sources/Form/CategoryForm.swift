import SwiftUI
import PhotosUI
import FormValidator

class CategoryForm: ObservableObject {
    @Published var name: String = ""
    @Published var image: String = ""
    @Published var systemImage: Int = 0
    @Published var color: Color = .accentColor
    
    lazy var form = {
        return FormValidation(validationType: .immediate)
    }()
    
    lazy var nameValidation: ValidationContainer = {
        return $name.nonEmptyValidator(form: form, errorMessage: "Name cannot be empty")
    }()
    
    lazy var imageValidation: ValidationContainer = {
        return $image.nonEmptyValidator(form: form, errorMessage: "Select a category image")
    }()
}
