import SwiftUI
import XtreamCodesKit

struct ChooseCategoryView: View {
    @Binding var categories: [CategoryItem]
    @State var category: String = ""

    var body: some View {
        VStack(spacing: -1) {
            HStack {
                TextField("Category name", text: $category)
                    .textFieldStyle(.roundedBorder)
                    .padding(3)
            }
            .border(Color("sheetSeparator"))
            List(categories.filter({ category in
                if (self.category == "") {
                    return true
                }
                
                return category.name.lowercased().contains(self.category.lowercased())
            })) { category in
                NavigationLink(category.name, value: category)
            }
            #if os(macOS)
            .listStyle(.bordered(alternatesRowBackgrounds: true))
            #else
            .listStyle(.inset)
            #endif
            .border(Color("sheetSeparator"))
        }
    }
}

//struct ChooseCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
////        ChooseCategoryView(categories: [])
//    }
//}
