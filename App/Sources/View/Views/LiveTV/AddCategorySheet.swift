import SwiftUI
import PhotosUI
import XtreamCodesKit

struct AddCategorySheet: View {
    @EnvironmentObject var liveTvCategoriesVM: LiveTVCategoriesViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var form = CategoryForm()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Check your IPTV providers setup guide and follow the setup for Xtream Codes or IPTVSmarters usage.")
                .fixedSize(horizontal: false, vertical: true)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Form {
                Section {
                    TextField("Name:", text: $form.name, prompt: Text("Your category name"))
                        .validation(form.nameValidation)
                        .disableAutocorrection(true)
                    #if os(iOS)
                        .textInputAutocapitalization(.never)
                    #endif
                    
                    Picker("Icon:", selection: $form.systemImage) {
                        ForEach(0 ..< LiveTVCategory.systemImages.count, id: \.self) { (i) in
                            HStack {
                                Image(systemName: LiveTVCategory.systemImages[i])
                                Text(LiveTVCategory.systemImages[i])
                            }.tag(i)
                        }
                    }
                    
                    ColorPicker("Color:", selection: $form.color)
                } header: {
                    Text("Choose your category settings")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(LiveTVCategory.images, id: \.self) { image in
                        Button {
                            form.image = image
                        } label: {
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 200, maxHeight: 80)
                                .cornerRadius(10)
                                .overlay(content: {
                                    if form.image == image {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 4)
                                    }
                                })
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 260)
            .background(.secondary.opacity(0.15))
            .cornerRadius(10)
            
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Button {
                    Task {
                        try await liveTvCategoriesVM.addCategory(.init(
                            subscriptionId: liveTvCategoriesVM.subscription.recordID!,
                            name: form.name,
                            image: form.image,
                            color: form.color,
                            systemImage: "trash"
                        ))
                        
                        dismiss()
                    }
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
}
