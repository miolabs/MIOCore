import XCTest

@testable import MIOCore

final class MCQueueTests: XCTestCase {

    func testQueueIsMemoizedByLabel() {
        let q1 = MCQueue.named("test.memoize.q")
        let q2 = MCQueue.named("test.memoize.q")
        XCTAssertTrue(q1 === q2, "same label must return the cached instance")
        let other = MCQueue.named("test.memoize.other")
        XCTAssertFalse(q1 === other)
    }

    func testAcquireIsExclusiveUntilReleased() {
        let label = "test.acquire.lock"
        XCTAssertTrue(MCQueue.acquire(label))
        XCTAssertFalse(MCQueue.acquire(label), "already held, re-acquire must fail")
        MCQueue.release(label)
        XCTAssertTrue(MCQueue.acquire(label), "must be acquirable again after release")
        MCQueue.release(label)
    }

    func testRunningInfoReflectsHeldLock() {
        let label = "test.running.info"
        XCTAssertTrue(MCQueue.acquire(label))
        defer { MCQueue.release(label) }
        XCTAssertTrue(MCQueue.runningInfo().contains { $0.contains(label) })
    }

    func testCacheStatsAreNonNegative() {
        let stats = MCQueue.cacheStats()
        XCTAssertGreaterThanOrEqual(stats.queues, 0)
        XCTAssertGreaterThanOrEqual(stats.queue_statuses, 0)
    }
}
