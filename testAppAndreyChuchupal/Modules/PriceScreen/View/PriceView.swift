import SwiftUI

struct PriceView: View {
    @Binding var path: [Screen]
    let doctor: Doctor
    var body: some View {
        ZStack(alignment: .top) {
            Color.bgCol.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                Header(title: "Стоимость услуг", action: {
                    if !path.isEmpty {
                        path.removeLast()
                    }
                }, isMain: false)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Видеоконсультация")
                            .font(.system(size: 16, weight: .semibold))
                        PriceViewStack(
                            time: "30 мин",
                            price: doctor.videoChatPrice != nil && doctor.videoChatPrice! > 0
                            ? "от \(doctor.videoChatPrice!) ₽"
                            : "Нет услуги"
                        )
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Чат с врачом")
                            .font(.system(size: 16, weight: .semibold))
                        PriceViewStack(
                            time: "30 мин",
                            price: doctor.textChatPrice != nil && doctor.textChatPrice! > 0
                            ? "от \(doctor.textChatPrice!) ₽"
                            : "Нет услуги"
                        )
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Приём в клинике")
                            .font(.system(size: 16, weight: .semibold))
                        PriceViewStack(
                            time: "В клинике",
                            price: doctor.hospitalPrice != nil && doctor.hospitalPrice! > 0
                            ? "от \(doctor.hospitalPrice!) ₽"
                            : "Нет услуги"
                        )
                    }
                }
            }
            .padding(16)
            .navigationBarHidden(true)
        }
    }
}
