import XCTest

@testable import MIOCore

final class XMLSerializationTests: XCTestCase {

    func testSerializeNestedBody() throws {
        let xml =
            """
            <?xml version=\'1.0\' encoding=\'UTF-8\'?>
                <MaterialDocumentResponse>
                    <Status>Created</Status>
                    <body>
                        <CreationDate>2020-08-21T00:00:00.000</CreationDate>
                        <MaterialDocumentYear>2020</MaterialDocumentYear>
                        <MaterialDocument>4900647222</MaterialDocument>
                        <CreatedByUser>CC0000000001</CreatedByUser>
                        <VersionForPrintingSlip>2</VersionForPrintingSlip>
                        <GoodsMovementCode>04</GoodsMovementCode>
                        <MaterialDocumentHeaderText>IO/135</MaterialDocumentHeaderText>
                        <ReferenceDocument/>
                        <InventoryTransactionType>WA</InventoryTransactionType>
                        <PostingDate>2020-08-20T00:00:00.000</PostingDate>
                        <to_MaterialDocumentItem/>
                        <ManualPrintIsTriggered/>
                        <CreationTime>1970-01-01T15:13:17.000</CreationTime>
                        <DocumentDate>2020-08-20T00:00:00.000</DocumentDate>
                    </body>
            </MaterialDocumentResponse>
            """
        let data = xml.data(using: .utf8)!
        let xmlDict = try XMLSerialization.xmlObject(with: data, options: []) as! [String: Any]

        XCTAssertEqual(xmlDict["__XML_TAG_NAME__"] as? String, "MaterialDocumentResponse")
        XCTAssertEqual(xmlDict["Status"] as? String, "Created")

        let body = try XCTUnwrap(xmlDict["body"] as? [String: Any])
        XCTAssertEqual(body["__XML_TAG_NAME__"] as? String, "body")
        XCTAssertEqual(body["CreationDate"] as? String, "2020-08-21T00:00:00.000")
        XCTAssertEqual(body["MaterialDocumentYear"] as? String, "2020")
        XCTAssertEqual(body["MaterialDocument"] as? String, "4900647222")
        XCTAssertEqual(body["CreatedByUser"] as? String, "CC0000000001")
        XCTAssertEqual(body["VersionForPrintingSlip"] as? String, "2")
        XCTAssertEqual(body["GoodsMovementCode"] as? String, "04")
        XCTAssertEqual(body["MaterialDocumentHeaderText"] as? String, "IO/135")
        XCTAssertEqual(body["InventoryTransactionType"] as? String, "WA")
        XCTAssertEqual(body["PostingDate"] as? String, "2020-08-20T00:00:00.000")
        XCTAssertEqual(body["CreationTime"] as? String, "1970-01-01T15:13:17.000")
        XCTAssertEqual(body["DocumentDate"] as? String, "2020-08-20T00:00:00.000")
        // Empty (self-closing) elements are not added.
        XCTAssertNil(body["ReferenceDocument"])
        XCTAssertNil(body["to_MaterialDocumentItem"])
        XCTAssertNil(body["ManualPrintIsTriggered"])
    }

    func testSerializeDeeplyNestedError() throws {
        let xml =
            """
            <?xml version=\'1.0\' encoding=\'UTF-8\'?>
                <MaterialDocumentResponse>
                    <error xmlns="http;//schemas.microsoft.com/ado/2007/08/dataservices/metada">
                        <code>M3/351</code>
                        <message xml:lang="en">Material 1001780 not maintained in plant 2403</message>
                        <innererror>
                            <application>
                                <component_id>MM-IM-VDM-SGM</component_id>
                                <service_namespace>/SAP/</service_namespace>
                                <service_id>API_MATERIAL_DOCUMENT</service_id>
                            </application>
                        </innererror>
                    </error>
                </MaterialDocumentResponse>
            """
        let data = xml.data(using: .utf8)!
        let xmlDict = try XMLSerialization.xmlObject(with: data, options: []) as! [String: Any]

        XCTAssertEqual(xmlDict["__XML_TAG_NAME__"] as? String, "MaterialDocumentResponse")
        let error = try XCTUnwrap(xmlDict["error"] as? [String: Any])
        XCTAssertEqual(error["code"] as? String, "M3/351")
        XCTAssertEqual(error["message"] as? String, "Material 1001780 not maintained in plant 2403")

        let innererror = try XCTUnwrap(error["innererror"] as? [String: Any])
        let application = try XCTUnwrap(innererror["application"] as? [String: Any])
        XCTAssertEqual(application["component_id"] as? String, "MM-IM-VDM-SGM")
        XCTAssertEqual(application["service_namespace"] as? String, "/SAP/")
        XCTAssertEqual(application["service_id"] as? String, "API_MATERIAL_DOCUMENT")
    }

    // Regression for the inverted success/failure check in parse(): malformed XML must
    // surface the parser error, not the success path (and well-formed XML must not throw).
    func testMalformedXMLThrows() {
        let data = "<a><b></a>".data(using: .utf8)!
        XCTAssertThrowsError(try XMLSerialization.xmlObject(with: data, options: []))
    }
}
