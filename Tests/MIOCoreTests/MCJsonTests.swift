import XCTest

@testable import MIOCore

final class MCJsonTests: XCTestCase {

    func testSerializableJSONConvertsUUID() {
        let uuid = UUID(uuidString: "6ba7b810-9dad-11d1-80b4-00c04fd430c8")!
        XCTAssertEqual(
            MCJSON.serializable(uuid) as? String,
            "6BA7B810-9DAD-11D1-80B4-00C04FD430C8")
    }

    func testSerializableJSONConvertsDate() {
        let converted = MCJSON.serializable(Date(timeIntervalSince1970: 0))
        XCTAssertTrue(converted is String)
    }

    func testSerializableJSONWalksNestedContainers() {
        let uuid = UUID(uuidString: "6ba7b810-9dad-11d1-80b4-00c04fd430c8")!
        let input: [String: Any] = ["id": uuid, "list": [uuid]]
        let out = MCJSON.serializable(input) as? [String: Any]
        XCTAssertEqual(out?["id"] as? String, "6BA7B810-9DAD-11D1-80B4-00C04FD430C8")
        XCTAssertEqual((out?["list"] as? [Any])?.first as? String, "6BA7B810-9DAD-11D1-80B4-00C04FD430C8")
    }

    func testSerializableJSONPassesScalarsThrough() {
        XCTAssertEqual(MCJSON.serializable(42) as? Int, 42)
        XCTAssertEqual(MCJSON.serializable("hi") as? String, "hi")
    }

    func testJsonValueRoundTrips() throws {
        let data = try MCJSON.data(from: ["ok": true, "n": 3])
        let back = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertEqual(back?["ok"] as? Bool, true)
        XCTAssertEqual(back?["n"] as? Int, 3)
    }

    func testJsonStringifyProducesText() throws {
        let text = try MCJSON.string(from: ["k": "v"])
        XCTAssertNotNil(text)
        XCTAssertTrue(text!.contains("\"k\""))
        XCTAssertTrue(text!.contains("\"v\""))
    }
}
