import SwiftUI

enum Screen: Hashable {
    case second(Doctor)
    case price(Doctor)
}

struct TabBar: View {
    @State var path: [Screen] = []
    var body: some View {
        TabView {
            NavigationStack(path: $path) {
                MainView(path: $path)
                    .navigationDestination(for: Screen.self) { screen in
                        switch screen {
                        case .second(let doctor):
                            SecondView(path: $path, doctor: doctor)
                        case .price(let doctor):
                            PriceView(path: $path, doctor: doctor)
                        }
                    }
                    .navigationBarHidden(true)
            }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }
            
            VStack {
                Spacer()
                Text("Приемы")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Приемы")
            }
            
            VStack {
                Spacer()
                Text("Чат")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Чат")
            } .badge(1)
            
            VStack {
                Spacer()
                Text("Профиль")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Профиль")
            }
        }
    }
}

#Preview {
    TabBar()
}
    

