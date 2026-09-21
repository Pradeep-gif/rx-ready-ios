import Foundation
import Observation

public struct Prescription: Identifiable, Equatable, Sendable {
    public enum Status: String, Sendable { case ready = "Ready for pickup", processing = "Processing" }
    public let id: UUID
    public let displayName: String
    public let status: Status
    public let readyDate: Date

    public init(id: UUID = UUID(), displayName: String, status: Status, readyDate: Date) {
        self.id = id; self.displayName = displayName; self.status = status; self.readyDate = readyDate
    }
}

public protocol PrescriptionServing: Sendable {
    func fetchPrescriptions() async throws -> [Prescription]
}

public struct MockPrescriptionService: PrescriptionServing {
    public init() {}
    public func fetchPrescriptions() async throws -> [Prescription] {
        [Prescription(displayName: "Blood pressure refill", status: .ready, readyDate: .now),
         Prescription(displayName: "Vitamin refill", status: .processing, readyDate: .now.addingTimeInterval(86_400))]
    }
}

public protocol EventLogging: Sendable { func log(_ name: String) }

public struct PrivacySafeLogger: EventLogging {
    public init() {}
    public func log(_ name: String) { print("[RxReady] event=\(name)") }
}

@MainActor @Observable
public final class RefillViewModel {
    public enum State: Equatable { case idle, loading, loaded([Prescription]), failed(String) }
    public private(set) var state: State = .idle
    private let service: any PrescriptionServing
    private let logger: any EventLogging

    public init(service: any PrescriptionServing, logger: any EventLogging = PrivacySafeLogger()) {
        self.service = service; self.logger = logger
    }

    public func load() async {
        state = .loading
        do {
            let prescriptions = try await service.fetchPrescriptions()
            state = .loaded(prescriptions)
            logger.log("refill_list_loaded")
        } catch {
            state = .failed("We couldn't load your refills. Please try again.")
            logger.log("refill_list_failed")
        }
    }

    public var readyCount: Int {
        guard case .loaded(let items) = state else { return 0 }
        return items.filter { $0.status == .ready }.count
    }
}
