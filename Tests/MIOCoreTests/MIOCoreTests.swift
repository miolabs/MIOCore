import XCTest
@testable import MIOCore

final class MIOCoreTests: XCTestCase {
   
    func testXMLSerialize() throws {
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
        let xmlDict = try XMLSerialization.xmlObject(with: data, options: []) as! [String:Any]
        
        XCTAssertTrue( xmlDict.count == 3, "3" )
        XCTAssertTrue( (xmlDict["__XML_TAG_NAME__"] as! String) == "MaterialDocumentResponse", "MaterialDocumentResponse" )
        XCTAssertTrue( (xmlDict["Status"] as! String) == "Created", "MaterialDocumentResponse['Status'] != Created" )
        let body = xmlDict["body"] as? [String:Any]
        XCTAssertTrue( body != nil, "MaterialDocumentResponse['body'] is null" )
        XCTAssertTrue( (body!["__XML_TAG_NAME__"] as! String) == "body", "body" )
        XCTAssertTrue( (body!["CreationDate"] as! String) == "2020-08-21T00:00:00.000", "MaterialDocumentResponse['body']['CreationDate'] != 2020-08-21T00:00:00.000" )
        XCTAssertTrue( (body!["MaterialDocumentYear"] as! String) == "2020", "MaterialDocumentResponse['body']['MaterialDocumentYear'] != 2020" )
        XCTAssertTrue( (body!["MaterialDocument"] as! String) == "4900647222", "MaterialDocumentResponse['body']['MaterialDocument'] != 4900647222" )
        XCTAssertTrue( (body!["CreatedByUser"] as! String) == "CC0000000001", "MaterialDocumentResponse['body']['CreatedByUser'] != CC0000000001" )
        XCTAssertTrue( (body!["VersionForPrintingSlip"] as! String) == "2", "MaterialDocumentResponse['body']['VersionForPrintingSlip'] != 2" )
        XCTAssertTrue( (body!["GoodsMovementCode"] as! String) == "04", "MaterialDocumentResponse['body']['GoodsMovementCode'] != 04" )
        XCTAssertTrue( (body!["MaterialDocumentHeaderText"] as! String) == "IO/135", "MaterialDocumentResponse['body']['MaterialDocumentHeaderText'] != IO/135" )
        XCTAssertTrue( body!["ReferenceDocument"] == nil, "MaterialDocumentResponse['body']['ReferenceDocument'] != nil" )
        XCTAssertTrue( (body!["InventoryTransactionType"] as! String) == "WA", "MaterialDocumentResponse['body']['InventoryTransactionType'] != WA" )
        XCTAssertTrue( (body!["PostingDate"] as! String) == "2020-08-20T00:00:00.000", "MaterialDocumentResponse['body']['PostingDate'] != 2020-08-20T00:00:00.000" )
        XCTAssertTrue( body!["to_MaterialDocumentItem"] == nil, "MaterialDocumentResponse['body']['to_MaterialDocumentItem'] != nil" )
        XCTAssertTrue( body!["ManualPrintIsTriggered"] == nil, "MaterialDocumentResponse['body']['ManualPrintIsTriggered'] != nil" )
        XCTAssertTrue( (body!["CreationTime"] as! String) == "1970-01-01T15:13:17.000", "MaterialDocumentResponse['body']['CreationTime'] != 1970-01-01T15:13:17.000" )
        XCTAssertTrue( (body!["DocumentDate"] as! String) == "2020-08-20T00:00:00.000", "MaterialDocumentResponse['body']['DocumentDate'] != 2020-08-20T00:00:00.000" )
    }
}
