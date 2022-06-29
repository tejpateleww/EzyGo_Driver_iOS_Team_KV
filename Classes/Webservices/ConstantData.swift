//
//  ConstantData.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 17/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation

let App_Delegate = UIApplication.shared.delegate as! AppDelegate

struct WebserviceURLs {
//    Api url : https://ezygo.co.nz/web/
//    Socket url : https://ezygo.co.nz:8080/
    
    
    static let kBaseURL                                 = "https://ezygo.co.nz/web/Drvier_Api/" // "http://13.237.0.107/web/Drvier_Api/"//"https://pickngolk.info/web/Drvier_Api/" // "http://54.169.67.226/web/Drvier_Api/" //
    static let kImageBaseURL                            = "https://ezygo.co.nz/web/" // "http://54.169.67.226/web/" //
    static let kOTPForDriverRegister                    = "OtpForRegister"  
    static let kVehicalModelList                        = "TaxiModel/"
    static let kDriverRegister                          = "Register"
    static let kDriverLogin                             = "Login"
    static let kDriverChangeDutyStatusOrShiftDutyStatus = "ChangeDriverShiftStatus/"
    static let kChangePassword                          = "ChangePassword"
    static let kUpdateProfile                           = "UpdateProfile"
    static let kForgotPassword                          = "ForgotPassword"
    static let kCompany                                 = "Company"
    static let KUpdateDriverBasicInfo                   = "UpdateDriverBasicInfo"
    static let KUpdateBankInfo                          = "UpdateBankInfo"
    static let kUpdateVehicleInfo                       = "UpdateVehicleInfo"
    static let kUpdateDocument                          = "UpdateDocs"
    static let kSubmitCompleteBooking                   = "SubmitCompleteBooking"

    static let kBookingHistory                          = "TripReceipt"  //"BookingHistory/"
    static let kPendingJobs                             = "PendingJobs/"
    static let kLogRecordHistory                        = "DriverLogRecord/" //"PrivateMeterBookingHistory/"
    static let kDispatchJob                             = "DispatchJob/"
    static let kAcceptDispatchJobRequest                = "AcceptDispatchJobRequest/"
    static let kLogout                                  = "Logout/"
    static let kSubmitCompleteAdvancedBooking           = "SubmitCompleteAdvancedBooking"
    static let kSubmitBookNowByDispatchJob              = "SubmitBookNowByDispatchJob"
    static let kSubmitBookLaterByDispatchJob            = "SubmitBookLaterByDispatchJob"
    static let kFutureBooking                           = "FutureBooking/"
    static let kMyDispatchJob                           = "MyDispatchJob/"
    static let kGetDriverProfile                        = "GetDriverProfile/"
    static let kGetDistaceFromBackend                   = "FindDistance/"
    static let kCurrentBooking                          = "CurrentBooking/"
    static let kAddNewCard                              = "AddNewCard"
    static let kCards                                   = "Cards/"
    static let kAddMoney                                = "AddMoney"
    static let kTransactionHistory                      = "TransactionHistory/"
    static let kSendMoney                               = "SendMoney"
    static let kQRCodeDetails                           = "QRCodeDetails"
    static let kRemoveCard                              = "RemoveCard/"
    static let kTickpay                                 = "Tickpay"
    static let kGetTickpayRate                          = "GetTickpayRate"
    static let kTickpayInvoice                          = "TickpayInvoice"
    static let kNEWSUrl                                 = "https://newsapi.org/v2/top-headlines?sources=google-news&apiKey="
    static let kNEWSApiKey                              = "90727bb768584fd7b64b66c9190921e0"
    static let kReviewRating                            = "ReviewRating"
    static let kWeeklyEarnings                          = "WeeklyEaringIOS/"
    static let kTransferMoneyToBank                     = "TransferToBank"
    static let kInit                                    = "Init/"
    static let kGetEstimateFare                         = "GetEstimateFare"
    static let kGetTaxiModelPricing                     = "TaxiModelForPricing"
    static let kGetFareEstimateWithKM                   = "GetEstimateFareWithKM"
    static let kCancelTrip                              = "CancelTrip"
    static let kManageTripToDestination                 = "ManageTripToDestination"
    static let kManageShareRideFlag                     = "ManageShareRideFlag/"
    static let kShareRide                               = "ShareRide/"
    static let kTrackRunningTrip                        = "TrackRunningTrip/"
    static let kPrivateMeterBooking                     = "PrivateMeterBooking"
    static let kFeedbackList                            = "FeedbackList/"
    static let kContactUs                               = "ContactUs"
    static let kCashPaymentService                      = "PaidByCash"
    static let kDocsUpload                              = "UploadDocs"
    static let kVehicleModel                            = "TaxiModel/"
    static let kDocsEdit                                = "UploadDocsEdit"
    static let kUpdateAllDocs                           = "UpdateAllDocuments"
    static let kTripFareInfo                            = "TripFareInformation"
    static let kPastJobs                                = "PastJobs/"
}

struct passengerData {
    static let kPassengerMobileNunber = "PassengerMobileNunber"
}


struct OTPEmail
{
    static let kEmail = "Email"
}

struct OTPCodeStruct
{
    static let kOTPCode = "OTPCode"
    static let kCompanyList = "company"
}


struct savedDataForRegistration
{
    static let kKeyEmail                             = "Email"
    static let kKeyOTP                               = "OTP"
    static let kKeyAllUserDetails                    = "CompleteUserDetails"
    static let kModelDetails                         = "CompleteModelDetails"
    static let kPageNumber                           = "PageNumber"
}

struct profileKeys
{
    static let kDriverId = "DriverId"
    static let kCarModel = "CarModel"
    static let kCarCompany = "CarCompany"
    static let kCompanyID = "CompanyId"
    
}

struct RegistrationProfileKeys {
    static let kKeyEmail = "email"
    static let kKeyFullName = "fullName"
    static let kKeyDOB = "DOB"
    static let kKeyMobileNumber = "mobileNumber"
    static let kKeyPassword = "password"
    static let kKeyAddress = "address"
    static let kKeyPostCode = "postCode"
    static let kKeyState = "state"
    static let kKeyCountry = "country"
    static let kKeyInviteCode = "inviteCode"
}

struct driverProfileKeys
{
    static let kKeyDriverProfile = "driverProfile"
    static let kKeyIsDriverLoggedIN = "isDriverLoggedIN"
    static let kKeyShowTickPayRegistrationScreen = "showTickPayRegistrationKey"

}

struct RegistrationFinalKeys
{
    
    
    static let kEmail = "Email"                          // Done
    
    static let kCompanyID = "CompanyId" // Done
    // ------------------------------------------------------------
    
    static let kMobileNo = "MobileNo"// Done
    static let kFullname = "Fullname"// Done
    static let kGender = "Gender"// Done
    static let kPassword = "Password"// Done
    static let kAddress = "Address"// Done
    
     static let kSuburb = "Suburb"// Done
    
    
    static let kCity = "City"// Done
    static let kState = "State"// Done
    static let kCountry = "Country"// Done
    static let kZipcode = "Zipcode"
    static let kDriverImage = "DriverImage" //Done
    static let kDriverLicence = "DriverLicence" //Done
    static let kAccreditationCertificate = "AccreditationCertificate" //Done
    static let kDriverLicenceExpiryDate = "DriverLicenseExpire" //Done
    static let kAccreditationCertificateExpiryDate = "AccreditationCertificateExpire" //Done
    static let kbankHolderName = "AccountHolderName"
    static let kBankName = "BankName"// Done
    static let kBankAccountNo = "BankAcNo"// Done
    static let kABN = "ABN"// Done
    static let kBSB = "BSB"// Done
    static let kServiceDescription = "Description"
    static let kVehicleRegistrationNo = "VehicleRegistrationNo" //Done
    static let kVehicleColor = "VehicleColor" //Done
    static let kVehicleClass = "VehicleClass" //Done
    static let kCarRegistrationCertificate = "CarRegistrationCertificate" //Done
    static let kVehicleInsuranceCertificate = "VehicleInsuranceCertificate" //Done
    static let kCarRegistrationExpiryDate = "RegistrationCertificateExpire" //Done
    static let kVehicleInsuranceCertificateExpiryDate = "VehicleInsuranceCertificateExpire" //Done
    static let kVehicleImage = "VehicleImage" //Done
    static let kCompanyModel = "CompanyModel" //Done
    static let kReferralCode = "ReferralCode" //Done
    static let kLat = "Lat"//Done
    static let kLng = "Lng"//Done
}


struct socketApiKeys {
    
    static let kSocketBaseURL =  "https://ezygo.co.nz:8080/"
    
    static let kUpdateDriverLocation = "UpdateDriverLatLong"
    static let kReceiveBookingRequest = "AriveBookingRequest"
    static let kRejectBookingRequest = "ForwardBookingRequestToAnother"
    static let kAcceptBookingRequest = "AcceptBookingRequest"
    
    static let kLat = "Lat"
    static let kLong = "Long"
    static let kBookingId = "BookingId"
    
    static let kAdvanceBookingID = "BookingId"
    
    static let kGetBookingDetailsAfterBookingRequestAccepted = "BookingInfo"
    static let kPickupPassengerByDriver = "PickupPassenger"
    
    static let kStartHoldTrip = "StartHoldTrip"
    static let kEndHoldTrip = "EndHoldTrip"
    static let kSendDriverLocationRequestByPassenger = "DriverLocation"
    static let kDriverCancelTripNotification = "DriverCancelTripNotification"
    
    static let kAriveAdvancedBookingRequest = "AriveAdvancedBookingRequest"
    static let kForwardAdvancedBookingRequestToAnother = "ForwardAdvancedBookingRequestToAnother"
    static let kAcceptAdvancedBookingRequest = "AcceptAdvancedBookingRequest"
    static let kAdvancedBookingPickupPassenger = "AdvancedBookingPickupPassenger"
    static let kAdvancedBookingStartHoldTrip = "AdvancedBookingStartHoldTrip"
    static let kAdvancedBookingEndHoldTrip = "AdvancedBookingEndHoldTrip"
    static let kAdvancedBookingCompleteTrip = "AdvancedBookingCompleteTrip"
    static let kAdvancedBookingDriverCancelTripNotification = "AdvancedBookingDriverCancelTripNotification"
    static let kAdvancedBookingInfo = "AdvancedBookingInfo"
    static let kAdvancedBookingPickupPassengerNotification = "AdvancedBookingPickupPassengerNotification"
    
    static let kBookLaterDriverNotify = "BookLaterDriverNotify"
    static let kReceiveMoneyNotify = "ReceiveMoneyNotify"
    
    static let kStartTripTimeError = "StartTripTimeError"
    
    static let kDriverArrivedAtPickupLocation = "DriverArrivedAtPickupLocation"
    static let kArrivedAtPickupLocation = "ArrivedAtPickupLocation"
    
    static let kAdvanceBookingDriverArrivedAtPickupLocation = "AdvanceBookingDriverArrivedAtPickupLocation"   //"AdvanceBookingArrivedAtPickupLocation"
    static let kAdvanceBookingArrivedAtPickupLocation = "AdvanceBookingArrivedAtPickupLocation"
}

struct nsNotificationKeys
{
    
    static let kBookingTypeBookNow = "BookingTypeBookNow"
    static let kBookingTypeBookLater = "BookingTypeBookLater"
}

struct tripStatus
{
    static let kisTripContinue = "isTripContinue"
    static let kisRequestAccepted = "isRequestAccepted"
}

struct holdTripStatus
{
    static let kIsTripisHolding = "IsTripisHolding"
    
}

struct meterStatus {
    static let kIsMeterOnHolding = "meterOnHold"
    static let kIsMeterStart = "meterOnStart"
    static let kIsMeterStop = "meterOnStop"
}
struct appName {
    static let kAPPName = "Ezygo-DRIVER"
    static let kAPPUrl = ""
    
}
struct walletAddCards
{
    // DriverId,CardNo,Cvv,Expiry,Alias (CarNo : 4444555511115555,Expiry:09/20)
    static let kCardNo = "CardNo"
    static let kCVV = "Cvv"
    static let kExpiry = "Expiry"
    static let kAlias = "Alias"

}

struct walletAddMoney
{
    // DriverId,Amount,CardId
    static let kAmount = "Amount"
    static let kCardId = "CardId"
}

struct  walletSendMoney
{
    // QRCode,SenderId,Amount
    
    static let kQRCode = "QRCode"
    static let kAmount = "Amount"
    static let kSenderId = "SenderId"
}






