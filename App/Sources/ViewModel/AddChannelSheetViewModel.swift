import SwiftUI
import XtreamCodesKit

class AddChannelSheetViewModel: ObservableObject {
    @Published var selectedCategory: CategoryItem?
    @Published var selectedChannel: LiveStream?
    @Published var name: String = ""
}
