import SwiftUI
import XtreamCodesKit

struct AddCategorySheet: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var categoriesVM: LiveTVCategoriesViewModel
    @Environment(\.dismiss) var dismiss
    @State var categories: [CategoryItem] = []
    
    @State var name: String = ""
    @State var image: String = ""
    @State var systemImage: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Category")
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
                        Image(systemName: "photo.artframe")
                        
                        TextField("Image", text: $image, prompt: Text("Image name"))
                    }
                }
                GroupRow(border: false) {
                    HStack {
                        Image(systemName: "ellipsis.rectangle")
                        
                        SecureField("Icon", text: $systemImage, prompt: Text("Icons name"))
                    }
                }
            }
            
            HStack {
                Button {
                    Task {
                        await categoriesVM.addCategory(.init(
                            name: name,
                            image: image,
                            color: .blue,
                            systemImage: systemImage
                        ))
                        
                        dismiss()
                    }
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
        
        
//        ScrollView {
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
//
//                ForEach(categories) { category in
//                    NavigationLink(destination: LiveTvCategoryView(category: category)) {
//                        VStack {
//                            Text(category.id)
//                            Text(category.name)
//                        }
//                        .background(.red)
//                        .foregroundColor(.white)
//                    }.buttonStyle(.borderless)
//                }
//            }
//            .onAppear {
//                Task {
//                    self.categories = try! await contentVM.api.liveTvCategories()
//                }
//            }
//        }
//        .navigationTitle("Add a category")
    }
}
