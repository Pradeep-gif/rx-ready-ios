#if canImport(SwiftUI)
import SwiftUI
import RxReady

@main
struct RxReadyDemoApp: App {
    var body: some Scene { WindowGroup { RefillDashboard() } }
}

@available(iOS 17.0, *)
private struct RefillDashboard: View {
    @State private var viewModel = RefillViewModel(service: MockPrescriptionService())

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading refills…")
                case .failed(let message):
                    ContentUnavailableView("Unable to load", systemImage: "exclamationmark.triangle", description: Text(message))
                case .loaded(let prescriptions):
                    List(prescriptions) { prescription in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(prescription.displayName).font(.headline)
                                Text(prescription.status.rawValue).foregroundStyle(prescription.status == .ready ? .green : .secondary)
                            }
                            Spacer()
                            Image(systemName: prescription.status == .ready ? "checkmark.circle.fill" : "clock")
                                .foregroundStyle(prescription.status == .ready ? .green : .secondary)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            .navigationTitle("Rx Ready")
            .toolbar { Text("\(viewModel.readyCount) ready") }
            .task { await viewModel.load() }
        }
    }
}
#endif
