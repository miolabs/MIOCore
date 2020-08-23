import XCTest
@testable import MIOCore

final class MIOCoreTests: XCTestCase {
   
    func testXMLSerialize1() throws {
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
    
    func testXMLSerialize2() throws {
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
        let xmlDict = try XMLSerialization.xmlObject(with: data, options: []) as! [String:Any]
                
        XCTAssertTrue( (xmlDict["__XML_TAG_NAME__"] as! String) == "MaterialDocumentResponse", "MaterialDocumentResponse" )
        let error = xmlDict["error"] as? [String:Any]
        XCTAssertTrue( error != nil, "MaterialDocumentResponse['error'] is null" )
        XCTAssertTrue( (error!["__XML_TAG_NAME__"] as! String) == "error", "error" )
        XCTAssertTrue( (error!["code"] as! String) == "M3/351", "MaterialDocumentResponse['error']['code'] != 2020-08-21T00:00:00.000" )
        XCTAssertTrue( (error!["message"] as! String) == "Material 1001780 not maintained in plant 2403", "MaterialDocumentResponse['error']['message'] != Material 1001780 not maintained in plant 2403" )
        let innererror = error!["innererror"] as? [String:Any]
        XCTAssertTrue( innererror != nil, "MaterialDocumentResponse['error']['innererror'] is null" )
        XCTAssertTrue( (innererror!["__XML_TAG_NAME__"] as! String) == "innererror", "innererror" )
        let application = innererror!["application"] as? [String:Any]
        XCTAssertTrue( application != nil, "MaterialDocumentResponse['error']['innererror']['application'] is null" )
        XCTAssertTrue( (application!["__XML_TAG_NAME__"] as! String) == "application", "application" )
        XCTAssertTrue( (application!["component_id"] as! String) == "MM-IM-VDM-SGM", "MaterialDocumentResponse['error']['innererror']['application']['component_id'] != MM-IM-VDM-SGM" )
        XCTAssertTrue( (application!["service_namespace"] as! String) == "/SAP/", "MaterialDocumentResponse['error']['innererror']['application']['service_namespace'] != /SAP/" )
        XCTAssertTrue( (application!["service_id"] as! String) == "API_MATERIAL_DOCUMENT", "MaterialDocumentResponse['error']['innererror']['application']['service_id'] != API_MATERIAL_DOCUMENT" )
    }
}
