import XCTest
@testable import MIOCore

final class MCQueueTests: XCTestCase {

    func testQueueIsMemoizedByLabel() {
        let q1 = MIOCoreQueue( label: "test.memoize.q" )
        let q2 = MIOCoreQueue( label: "test.memoize.q" )
        XCTAssertTrue( q1 === q2, "same label must return the cached instance" )
        let other = MIOCoreQueue( label: "test.memoize.other" )
        XCTAssertFalse( q1 === other )
    }

    func testAcquireIsExclusiveUntilReleased() {
        let label = "test.acquire.lock"
        XCTAssertTrue( MIOCoreQueueAcquire( label: label ) )
        XCTAssertFalse( MIOCoreQueueAcquire( label: label ), "already held, re-acquire must fail" )
        MIOCoreQueueRelease( label: label )
        XCTAssertTrue( MIOCoreQueueAcquire( label: label ), "must be acquirable again after release" )
        MIOCoreQueueRelease( label: label )
    }

    func testRunningInfoReflectsHeldLock() {
        let label = "test.running.info"
        XCTAssertTrue( MIOCoreQueueAcquire( label: label ) )
        defer { MIOCoreQueueRelease( label: label ) }
        XCTAssertTrue( MIOCoreQueueRunningInfo().contains { $0.contains( label ) } )
    }

    func testCacheStatsAreNonNegative() {
        let stats = MIOCoreQueueCacheStats()
        XCTAssertGreaterThanOrEqual( stats.queues, 0 )
        XCTAssertGreaterThanOrEqual( stats.statuses, 0 )
    }
}
