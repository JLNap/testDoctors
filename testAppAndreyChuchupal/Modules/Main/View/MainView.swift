import SwiftUI

struct MainView: View {
    @Binding var path: [Screen]
    @StateObject private var vm = MainVM(manager: NetworkManager())
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bgCol.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Header(title: "Педиатры", action: { }, isMain: true)
                SearchSort(vm: vm)
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(vm.sortedDoctors) { doctor in
                            DocCell(data: doctor, path: $path)
                        }
                    }
                }
            }
            .padding(16)
        }
        .onAppear {
            vm.fetchDoctors()
        }
    }
}


