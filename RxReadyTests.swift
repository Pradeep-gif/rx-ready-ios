import XCTest
@testable import RxReady

final class RxReadyTests: XCTestCase {
    func testReadyCountReflectsOnlyReadyPrescriptions() async {
        let viewModel = await RefillViewModel(service: MockPrescriptionService())
        await viewModel.load()
        XCTAssertEqual(await viewModel.readyCount, 1)
    }

    func testFailureShowsRecoveryMessage() async {
        let viewModel = await RefillViewModel(service: FailingService())
        await viewModel.load()
        XCTAssertEqual(await viewModel.state, .failed("We couldn't load your refills. Please try again."))
    }
}

private struct FailingService: PrescriptionServing {
    func fetchPrescriptions() async throws -> [Prescription] { throw URLError(.notConnectedToInternet) }
}
