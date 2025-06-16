import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Carregando...")
        }
        .padding()
    }
}
