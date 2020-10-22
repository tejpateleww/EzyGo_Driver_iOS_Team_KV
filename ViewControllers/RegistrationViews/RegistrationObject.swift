//
//  RegistrationObject.swift
//  ezygo-Driver
//
//  Created by Apple on 12/12/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class RegistrationObject: NSObject,NSCoding {
    
    //Email Screen
    var strMobileNo: String = ""
    var strLandLineNumber: String = ""
    var strEmail: String =  ""
    var strPassword: String = ""
    var strCountryCode: String =  ""   // 2 newzealand 1 = Aus
    var strConfirmPassword = ""
    var nFillPageNumber: CGFloat = 0.0
    
    //Personal Detail Screen
    var strProfileImageUrl: String = ""
    var strFirstName: String = ""
    var strLastName: String = ""
    var strGender: String = ""
    var strStreetAddress: String = ""
    var strSuburb: String = ""
    var strPostCode: String = ""
    var strCity: String = ""
    var strCountry: String = ""
    var strInviteCode: String = ""
    var isRegisteredForGst: Bool = false
    var strGstnumber: String = ""
    var strGstRegistrationName: String = ""
   
    var strKinFirstName: String = ""
    var strKinLastName: String = ""
    var strRelationshipWithKin: String = ""
    var strKinCountryCode: String =  ""    // 2 newzealand 1 = Aus
    var strKinMobileNumber: String =  ""
    var strKinLandlineNumber: String = ""
    
    //Bank Details
    var strBankName: String = ""
    var strBankBranch: String = ""
    var strAccountHolder: String = ""
    var strAccountNumber: String = ""
    var isColllectFromOffice: Bool = false
    
    //Vehicle Details
    var strVehicleImageUrl: String = ""
    var strVehicleOwnerFullName: String = ""
    var strVehiclePlateNumber: String = ""
    var strVehicleMake: String = ""
    var strVehicleModel: String = ""
    var strVehicleType: String = ""
    var strVehicleManufactureYear: String = ""
    var strVehicleColor: String = ""
    var strNoOfPassenger: String = ""
    
    
    //Driver Certificate details
    
    var strLicenceNumber: String = ""
    var strLicenceExpirationDate: String = ""
    var strLicenceFrontImageUrl: String = ""
    var strLicenceBackImageUrl: String = ""
    var strUniqueIDCard: String = ""
    var strUniquIdExpiryDate: String = ""
    var strUniqueIdFrontImageUrl: String = ""
    var strUniqueIdBackImageUrl: String = ""
    var isHoldSPSL: Bool = false
    var strSpslHolderName: String = ""
    var strSpslHolderNumber: String = ""
    var strSpslCertificateImageUrl: String = ""
    var strEndorsementPassenger: String = ""
    var strCOFExpiryDate: String = ""
    var strCofExpiryImageUrl: String = ""
    var strCertificateOfRegistrationExpiryDate: String = ""
    var strCertificateOfRegistrationExpiryImageUrl: String = ""
    var strVehicleRegistrationLabel: String = ""
    var strVehicleRegistrationImageUrl: String = ""
    var strCameraMakeModel: String = ""
    var strCameraSerialNumber: String = ""
    var strLatestCameraTestFrom: String = ""
    var strLatestCameraTestImageUrl: String = ""
    var strInsurancePolicy: String = ""
    var strInsurancePolicyImageUrl: String = ""
    var strSelectImmigrationStatus: String = ""
    
    var strVisaExpiryDate:  String = ""
    var strWorkVisaUrl: String = ""
    var IsWorkVisa: Bool = false
    
    var isAirportTamTag: Bool = false
    



    
    override init() {
        super.init()
    }
    required init(coder decoder: NSCoder) {
        
        self.strMobileNo = decoder.decodeObject(forKey: "strMobileNo") as? String ?? ""
        self.strLandLineNumber = decoder.decodeObject(forKey: "strLandLineNumber") as? String ?? ""
        self.strEmail = decoder.decodeObject(forKey: "strEmail") as? String ?? ""
        self.strPassword = decoder.decodeObject(forKey: "strPassword") as? String ?? ""
        
        self.strCountryCode = decoder.decodeObject(forKey: "strCountryCode") as? String ?? ""
        self.strConfirmPassword = decoder.decodeObject(forKey: "strConfirmPassword") as? String ?? ""
        
        self.nFillPageNumber = decoder.decodeObject(forKey: "nFillPageNumber") as? CGFloat ?? 0.0
        
        
        //Personal Details
        self.strProfileImageUrl = decoder.decodeObject(forKey: "strProfileImageUrl") as? String ?? ""
        self.strFirstName = decoder.decodeObject(forKey: "strFirstName") as? String ?? ""
        self.strLastName = decoder.decodeObject(forKey: "strLastName") as? String ?? ""
        self.strGender = decoder.decodeObject(forKey: "strGender") as? String ?? ""
        self.strStreetAddress = decoder.decodeObject(forKey: "strStreetAddress") as? String ?? ""
        self.strSuburb = decoder.decodeObject(forKey: "strSuburb") as? String ?? ""
        self.strPostCode = decoder.decodeObject(forKey: "strPostCode") as? String ?? ""
        self.strCity = decoder.decodeObject(forKey: "strCity") as? String ?? ""
        self.strCountry = decoder.decodeObject(forKey: "strCountry") as? String ?? ""
        self.strInviteCode = decoder.decodeObject(forKey: "strInviteCode") as? String ?? ""
//        self.isRegisteredForGst = decoder.decodeObject(forKey: "isRegisteredForGst") as? Bool ?? false
        self.isRegisteredForGst = decoder.decodeBool(forKey: "isRegisteredForGst")
        self.strGstnumber = decoder.decodeObject(forKey: "strGstnumber") as? String ?? ""
        self.strGstRegistrationName = decoder.decodeObject(forKey: "strGstRegistrationName") as? String ?? ""
        self.strKinFirstName = decoder.decodeObject(forKey: "strKinFirstName") as? String ?? ""
        self.strKinLastName = decoder.decodeObject(forKey: "strKinLastName") as? String ?? ""
        self.strRelationshipWithKin = decoder.decodeObject(forKey: "strRelationshipWithKin") as? String ?? ""
        self.strKinCountryCode = decoder.decodeObject(forKey: "strKinCountryCode") as? String ?? ""
        self.strKinMobileNumber = decoder.decodeObject(forKey: "strKinMobileNumber") as? String ?? ""
        self.strKinLandlineNumber = decoder.decodeObject(forKey: "strKinLandlineNumber") as? String ?? ""
        
        //bank Details
        self.strBankName = decoder.decodeObject(forKey: "strBankName") as? String ?? ""
        self.strBankBranch = decoder.decodeObject(forKey: "strBankBranch") as? String ?? ""
        self.strAccountHolder = decoder.decodeObject(forKey: "strAccountHolder") as? String ?? ""
        self.strAccountNumber = decoder.decodeObject(forKey: "strAccountNumber") as? String ?? ""
        self.isColllectFromOffice = decoder.decodeBool(forKey: "isColllectFromOffice") //as? Bool ?? false
        
         //Vehicle Details
        
        self.strVehicleImageUrl = decoder.decodeObject(forKey: "strVehicleImageUrl") as? String ?? ""
        self.strVehicleOwnerFullName = decoder.decodeObject(forKey: "strVehicleOwnerFullName") as? String ?? ""
        self.strVehiclePlateNumber = decoder.decodeObject(forKey: "strVehiclePlateNumber") as? String ?? ""
        self.strVehicleMake = decoder.decodeObject(forKey: "strVehicleMake") as? String ?? ""
        self.strVehicleModel = decoder.decodeObject(forKey: "strVehicleModel") as? String ?? ""
        self.strVehicleType = decoder.decodeObject(forKey: "strVehicleType") as? String ?? ""
        self.strVehicleManufactureYear = decoder.decodeObject(forKey: "strVehicleManufactureYear") as? String ?? ""
        self.strVehicleColor = decoder.decodeObject(forKey: "strVehicleColor") as? String ?? ""
        self.strNoOfPassenger = decoder.decodeObject(forKey: "strNoOfPassenger") as? String ?? ""
        
        
        //Driver Certificate Details
        
        
        self.strLicenceNumber = decoder.decodeObject(forKey: "strLicenceNumber") as? String ?? ""
        self.strLicenceExpirationDate = decoder.decodeObject(forKey: "strLicenceExpirationDate") as? String ?? ""
        self.strLicenceFrontImageUrl = decoder.decodeObject(forKey: "strLicenceFrontImageUrl") as? String ?? ""
        self.strLicenceBackImageUrl = decoder.decodeObject(forKey: "strLicenceBackImageUrl") as? String ?? ""
        self.strUniqueIDCard = decoder.decodeObject(forKey: "strUniqueIDCard") as? String ?? ""
        self.strUniquIdExpiryDate = decoder.decodeObject(forKey: "strUniquIdExpiryDate") as? String ?? ""
        self.strUniqueIdFrontImageUrl = decoder.decodeObject(forKey: "strUniqueIdFrontImageUrl") as? String ?? ""
        self.strUniqueIdBackImageUrl = decoder.decodeObject(forKey: "strUniqueIdBackImageUrl") as? String ?? ""
        self.isHoldSPSL = decoder.decodeBool(forKey: "isHoldSPSL") //as? Bool ?? false
        self.strSpslHolderName = decoder.decodeObject(forKey: "strSpslHolderName") as? String ?? ""
        self.strSpslHolderNumber = decoder.decodeObject(forKey: "strSpslHolderNumber") as? String ?? ""
        self.strSpslCertificateImageUrl = decoder.decodeObject(forKey: "strSpslCertificateImageUrl") as? String ?? ""
        self.strEndorsementPassenger = decoder.decodeObject(forKey: "strEndorsementPassenger") as? String ?? ""
        self.strCOFExpiryDate = decoder.decodeObject(forKey: "strCOFExpiryDate") as? String ?? ""
        self.strCofExpiryImageUrl = decoder.decodeObject(forKey: "strCofExpiryImageUrl") as? String ?? ""
        self.strCertificateOfRegistrationExpiryDate = decoder.decodeObject(forKey: "strCertificateOfRegistrationExpiryDate") as? String ?? ""
        self.strCertificateOfRegistrationExpiryImageUrl = decoder.decodeObject(forKey: "strCertificateOfRegistrationExpiryImageUrl") as? String ?? ""
        self.strVehicleRegistrationLabel = decoder.decodeObject(forKey: "strVehicleRegistrationLabel") as? String ?? ""
        self.strVehicleRegistrationImageUrl = decoder.decodeObject(forKey: "strVehicleRegistrationImageUrl") as? String ?? ""
        self.strCameraMakeModel = decoder.decodeObject(forKey: "strCameraMakeModel") as? String ?? ""
        self.strCameraSerialNumber = decoder.decodeObject(forKey: "strCameraSerialNumber") as? String ?? ""
        self.strLatestCameraTestFrom = decoder.decodeObject(forKey: "strLatestCameraTestFrom") as? String ?? ""
        self.strLatestCameraTestImageUrl = decoder.decodeObject(forKey: "strLatestCameraTestImageUrl") as? String ?? ""
        self.strInsurancePolicy = decoder.decodeObject(forKey: "strInsurancePolicy") as? String ?? ""
        self.strInsurancePolicyImageUrl = decoder.decodeObject(forKey: "strInsurancePolicyImageUrl") as? String ?? ""
        self.strSelectImmigrationStatus = decoder.decodeObject(forKey: "strSelectImmigrationStatus") as? String ?? ""
        self.isAirportTamTag = decoder.decodeBool(forKey: "isAirportTamTag") //as? Bool ?? false
        
        
        self.strVisaExpiryDate = decoder.decodeObject(forKey: "strVisaExpiryDate") as? String ?? ""
        self.strWorkVisaUrl = decoder.decodeObject(forKey: "strWorkVisaUrl") as? String ?? ""
        self.IsWorkVisa = decoder.decodeBool(forKey: "IsWorkVisa") // as? Bool ?? false
        
//        var strVisaExpiryDate:  String = ""
//        var strWorkVisaUrl: String = ""
//        var IsWorkVisa: Bool = false
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(strMobileNo, forKey: "strMobileNo")
        coder.encode(strLandLineNumber, forKey: "strLandLineNumber")
        coder.encode(strEmail, forKey: "strEmail")
        coder.encode(strPassword, forKey: "strPassword")
        coder.encode(strCountryCode, forKey: "strCountryCode")
        coder.encode(strConfirmPassword, forKey: "strConfirmPassword")
        coder.encode(nFillPageNumber, forKey: "nFillPageNumber")
        
        
        //Personal Details
        coder.encode(strProfileImageUrl, forKey: "strProfileImageUrl")
        coder.encode(strFirstName, forKey: "strFirstName")
        coder.encode(strLastName, forKey: "strLastName")
        coder.encode(strGender, forKey: "strGender")
        coder.encode(strStreetAddress, forKey: "strStreetAddress")
        coder.encode(strSuburb, forKey: "strSuburb")
        coder.encode(strPostCode, forKey: "strPostCode")
        coder.encode(strCity, forKey: "strCity")
        coder.encode(strCountry, forKey: "strCountry")
        coder.encode(strInviteCode, forKey: "strInviteCode")
        coder.encode(isRegisteredForGst, forKey: "isRegisteredForGst")
    
        coder.encode(strGstnumber, forKey: "strGstnumber")
        coder.encode(strGstRegistrationName, forKey: "strGstRegistrationName")
        coder.encode(strKinFirstName, forKey: "strKinFirstName")
        coder.encode(strKinLastName, forKey: "strKinLastName")
        coder.encode(strRelationshipWithKin, forKey: "strRelationshipWithKin")
        coder.encode(strKinCountryCode, forKey: "strKinCountryCode")
        coder.encode(strKinMobileNumber, forKey: "strKinMobileNumber")
        coder.encode(strKinLandlineNumber, forKey: "strKinLandlineNumber")
      
        
        //Bank Details
        coder.encode(strBankName, forKey: "strBankName")
        coder.encode(strBankBranch, forKey: "strBankBranch")
        coder.encode(strAccountHolder, forKey: "strAccountHolder")
        coder.encode(strAccountNumber, forKey: "strAccountNumber")
        coder.encode(isColllectFromOffice, forKey: "isColllectFromOffice")
        
        
         //Vehicle Details
        
        coder.encode(strVehicleImageUrl, forKey: "strVehicleImageUrl")
        coder.encode(strVehicleOwnerFullName, forKey: "strVehicleOwnerFullName")
        coder.encode(strVehiclePlateNumber, forKey: "strVehiclePlateNumber")
        coder.encode(strVehicleMake, forKey: "strVehicleMake")
        coder.encode(strVehicleModel, forKey: "strVehicleModel")
        coder.encode(strVehicleType, forKey: "strVehicleType")
        coder.encode(strVehicleManufactureYear, forKey: "strVehicleManufactureYear")
        coder.encode(strVehicleColor, forKey: "strVehicleColor")
        coder.encode(strNoOfPassenger, forKey: "strNoOfPassenger")
        
     
 
        //Driver Certificate Details
        
        coder.encode(strLicenceNumber, forKey: "strLicenceNumber")
        coder.encode(strLicenceExpirationDate, forKey: "strLicenceExpirationDate")
        coder.encode(strLicenceFrontImageUrl, forKey: "strLicenceFrontImageUrl")
        coder.encode(strLicenceBackImageUrl, forKey: "strLicenceBackImageUrl")
        coder.encode(strUniqueIDCard, forKey: "strUniqueIDCard")
        coder.encode(strUniquIdExpiryDate, forKey: "strUniquIdExpiryDate")
        coder.encode(strUniqueIdFrontImageUrl, forKey: "strUniqueIdFrontImageUrl")
        coder.encode(strUniqueIdBackImageUrl, forKey: "strUniqueIdBackImageUrl")
        coder.encode(isHoldSPSL, forKey: "isHoldSPSL")
        coder.encode(strSpslHolderName, forKey: "strSpslHolderName")
        coder.encode(strSpslHolderNumber, forKey: "strSpslHolderNumber")
        coder.encode(strSpslCertificateImageUrl, forKey: "strSpslCertificateImageUrl")
        coder.encode(strEndorsementPassenger, forKey: "strEndorsementPassenger")
        coder.encode(strCOFExpiryDate, forKey: "strCOFExpiryDate")
        coder.encode(strCofExpiryImageUrl, forKey: "strCofExpiryImageUrl")
        coder.encode(strCertificateOfRegistrationExpiryDate, forKey: "strCertificateOfRegistrationExpiryDate")
        coder.encode(strCertificateOfRegistrationExpiryImageUrl, forKey: "strCertificateOfRegistrationExpiryImageUrl")
        coder.encode(strVehicleRegistrationLabel, forKey: "strVehicleRegistrationLabel")
        coder.encode(strVehicleRegistrationImageUrl, forKey: "strVehicleRegistrationImageUrl")
        coder.encode(strCameraMakeModel, forKey: "strCameraMakeModel")
        coder.encode(strCameraSerialNumber, forKey: "strCameraSerialNumber")
        coder.encode(strLatestCameraTestFrom, forKey: "strLatestCameraTestFrom")
        coder.encode(strLatestCameraTestImageUrl, forKey: "strLatestCameraTestImageUrl")
        coder.encode(strInsurancePolicy, forKey: "strInsurancePolicy")
        coder.encode(strInsurancePolicyImageUrl, forKey: "strInsurancePolicyImageUrl")
        coder.encode(strSelectImmigrationStatus, forKey: "strSelectImmigrationStatus")
        coder.encode(isAirportTamTag, forKey: "isAirportTamTag")

        
        coder.encode(strVisaExpiryDate, forKey: "strVisaExpiryDate")
        coder.encode(strWorkVisaUrl, forKey: "strWorkVisaUrl")
        coder.encode(IsWorkVisa, forKey: "IsWorkVisa")
             
       
    }
}
