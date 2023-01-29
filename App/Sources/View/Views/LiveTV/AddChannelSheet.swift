import SwiftUI
import XtreamCodesKit
import CachedAsyncImage

struct AddChannelSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var channelsVM: LiveTVChannelsViewModel
    @ObservedObject var addChannelSheetVM = AddChannelSheetViewModel()
    
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose a channel category:")

            NavigationStack(path: $path) {
                AddChannelSheetChooseCategoryView()
                    .navigationDestination(for: CategoryItem.self) { category in
                        AddChannelSheetChooseChannelView(category: category)
                    }
                    .navigationDestination(for: LiveStream.self) { channel in
                        AddChannelSheetChooseSettingsView(category: addChannelSheetVM.selectedCategory!, channel: channel)
                    }
            }
            .environmentObject(addChannelSheetVM)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }

                Spacer()
                
                Button {
                    path.removeLast()
                } label: {
                    Text("Previous")
                }
                .disabled(path.count < 1)
                
                if addChannelSheetVM.name != "" {
                    Button {
                        Task {
                            await channelsVM.addChannel(.init(
                                name: addChannelSheetVM.name,
                                categoryId: channelsVM.category.id!,
                                liveSteam: addChannelSheetVM.selectedChannel!
                            ))
                            
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .frame(width: 700, height: 500)
    }
}

struct AddChannelSheetChooseCategoryView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var addChannelSheetVM: AddChannelSheetViewModel
    
    @State var categories: [CategoryItem] = []
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
        .task {
            do {
                categories = try await contentVM.api.liveTvCategories()
            } catch {
                print(error)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct AddChannelSheetChooseChannelView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var addChannelSheetVM: AddChannelSheetViewModel
    
    var category: CategoryItem
    
    @State var channels: [LiveStream] = []
    @State var channel: String = ""
    
    var body: some View {
        VStack(spacing: -1) {
            HStack {
                TextField("Channel name", text: $channel)
                    .textFieldStyle(.roundedBorder)
                    .padding(3)
            }
            .border(Color("sheetSeparator"))
            List(channels.filter({ channel in
                if (self.channel == "") {
                    return true
                }
                
                return channel.name.lowercased().contains(self.channel.lowercased())
            })) { channel in
                NavigationLink(channel.name, value: channel)
            }
            #if os(macOS)
            .listStyle(.bordered(alternatesRowBackgrounds: true))
            #else
            .listStyle(.inset)
            #endif
            .border(Color("sheetSeparator"))
        }
        .task {
            do {
                addChannelSheetVM.selectedCategory = category
                
                channels = try await contentVM.api.liveTvCategory(category: category.id)
            } catch {
                print("Wrong stuff")
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct AddChannelSheetChooseSettingsView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var addChannelSheetVM: AddChannelSheetViewModel
    
    var category: CategoryItem
    var channel: LiveStream
    
    var body: some View {
        VStack {
            Form {
                Section {
                    LabeledContent {
                        Text(category.name).bold()
                    } label: {
                        Text("Category:")
                    }
                    LabeledContent {
                        Text(channel.name).bold()
                    } label: {
                        Text("Channel:")
                    }

                } header: {
                    Text("Selected")
                        .bold()
                        .padding(.bottom)
                }
                
                Section {
                    TextField("Name:", text: $addChannelSheetVM.name, prompt: Text("channel name"))
                } header: {
                    Text("Settings")
                        .bold()
                        .padding(.vertical)
                }
            }
            .padding()
        }
        .task {
            addChannelSheetVM.selectedChannel = channel
            addChannelSheetVM.name = channel.name
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .border(Color("sheetSeparator"))
        .navigationBarBackButtonHidden()
    }
}
