//
//  WebserviceMethods.swift
//  PickNGo-Driver
//
//  Created by Excellent Webworld on 17/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit

let baseURL = WebserviceURLs.kBaseURL
let otpURL = WebserviceURLs.kOTPForDriverRegister
let VehicalModelList = WebserviceURLs.kVehicalModelList
let DriverLogin = WebserviceURLs.kDriverLogin
let Registration =  WebserviceURLs.kDriverRegister
let Company = WebserviceURLs.kCompany
let UpdateBankInfo = WebserviceURLs.KUpdateBankInfo
let UpdateVehicleInfo = WebserviceURLs.kUpdateVehicleInfo
let UpdateDocument = WebserviceURLs.kUpdateDocument
let changeDuty = WebserviceURLs.kDriverChangeDutyStatusOrShiftDutyStatus
let forgotPassword = WebserviceURLs.kForgotPassword
let SubmitCompleteBooking = WebserviceURLs.kSubmitCompleteBooking
let changePassword = WebserviceURLs.kChangePassword
let signOut = WebserviceURLs.kLogout
let SubmitCompleteAdvancedBooking = WebserviceURLs.kSubmitCompleteAdvancedBooking
let SubmitBookNowByDispatchJob = WebserviceURLs.kSubmitBookNowByDispatchJob
let SubmitBookLaterByDispatchJob = WebserviceURLs.kSubmitBookLaterByDispatchJob
let GetDriverProfile = WebserviceURLs.kGetDriverProfile
let GetDistanceFromBackend = WebserviceURLs.kGetDistaceFromBackend

let UpdateDriverBasicInfo = WebserviceURLs.KUpdateDriverBasicInfo

let AcceptDispatchJobRequest = WebserviceURLs.kAcceptDispatchJobRequest

let MyDispatchJob = WebserviceURLs.kMyDispatchJob
let FutureBooking = WebserviceURLs.kFutureBooking
let BookingHistory = WebserviceURLs.kBookingHistory
let PendingJobs = WebserviceURLs.kPendingJobs
let LogRecordHistory = WebserviceURLs.kLogRecordHistory
let CurrentBooking = WebserviceURLs.kCurrentBooking

let AddNewCard = WebserviceURLs.kAddNewCard
let CardListing = WebserviceURLs.kCards
let AddMoneyToWallet = WebserviceURLs.kAddMoney
let TransactionHistory = WebserviceURLs.kTransactionHistory

let sendMoney = WebserviceURLs.kSendMoney
let QRCodeDetails = WebserviceURLs.kQRCodeDetails

let RemoveCard = WebserviceURLs.kRemoveCard
let Tickpay = WebserviceURLs.kTickpay
let GetTickpayRate = WebserviceURLs.kGetTickpayRate
let TickpayInvoice = WebserviceURLs.kTickpayInvoice

let GoogleNewsURL = WebserviceURLs.kNEWSUrl + WebserviceURLs.kNEWSApiKey
let GiveRating = WebserviceURLs.kReviewRating
let WeeklyEarnings = WebserviceURLs.kWeeklyEarnings

let TransferMoneyToBank = WebserviceURLs.kTransferMoneyToBank

let AppSetting = WebserviceURLs.kInit

let estimateFare = WebserviceURLs.kGetEstimateFare

let getTaxiModelPricing = WebserviceURLs.kGetTaxiModelPricing
let getFareEstimateKm = WebserviceURLs.kGetFareEstimateWithKM
let cancelTrip = WebserviceURLs.kCancelTrip

let ManageTripToDestination = WebserviceURLs.kManageTripToDestination
let ManageShareRideFlag = WebserviceURLs.kManageShareRideFlag

let shareRide = WebserviceURLs.kShareRide

let TrackRunningTrip = WebserviceURLs.kTrackRunningTrip

let PrivateMeterBooking = WebserviceURLs.kPrivateMeterBooking
let FeedbackList = WebserviceURLs.kFeedbackList
let ContactUsList = WebserviceURLs.kContactUs
let CashPaymentService = WebserviceURLs.kCashPaymentService

let UploadDocs = WebserviceURLs.kDocsUpload

let VehicleType = WebserviceURLs.kVehicleModel

let EditDocs = WebserviceURLs.kDocsEdit

let UpdateAllDocuments = WebserviceURLs.kUpdateAllDocs

let TripFareInformation =  WebserviceURLs.kTripFareInfo
let pastBooking = WebserviceURLs.kPastJobs
//-------------------------------------------------------------
// MARK: - Webservice For Registration
//-------------------------------------------------------------

//func webserviceForRegistrationForDriver(_ dictParams: AnyObject, image1: UIImage, image2: UIImage, image3: UIImage, image4: UIImage, image5: UIImage, image6: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
//{
//    let url = Registration
//    sendImage(dictParams as! [String : AnyObject], image1: image1, image2: image2, image3: image3, image4: image4, image5: image5, image6: image6, nsURL: url, completion: completion)
//
//}

func webserviceForRegistrationForDriver(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Registration
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For OTP For Driver Register
//-------------------------------------------------------------

func webserviceForOTPDriverRegister(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = otpURL
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Manage Trip to Destination
//-------------------------------------------------------------

func webserviceForManageTripToDestination(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ManageTripToDestination
    postData(dictParams, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Vehical Model List
//-------------------------------------------------------------

func webserviceForVehicalModelList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VehicalModelList
    getData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Driver Login
//-------------------------------------------------------------

func webserviceForDriverLogin(dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = DriverLogin
    postData(dictParams, nsURL: url, completion: completion)
}

//------------------------------------------------------------------------
// MARK: - Webservice For Driver Change Duty Status Or Shift Duty Status
//------------------------------------------------------------------------

func webserviceForDriverChangeDutyStatusOrShiftDutyStatus(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = changeDuty
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Change Password
//-------------------------------------------------------------

func webserviceForChangePassword(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = changePassword
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Profile
//-------------------------------------------------------------

//func webserviceForUpdateDriverProfile(_ dictParams: AnyObject, image: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
//{
//    let url = UpdateDriverBasicInfo
//
//    DeiverInfo(dictParams as! [String : AnyObject], image1: image, nsURL: url, completion: completion)
//}

func webserviceForUpdateDriverProfile(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateDriverBasicInfo
     postData(dictParams, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Forgot Password
//-------------------------------------------------------------

func webserviceForForgotPassword(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = forgotPassword
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Driver Profile Bank Account Details
//-------------------------------------------------------------

func webserviceForUpdateDriverProfileBankAccountDetails(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateBankInfo
    postData(dictParams, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Driver Profile Update Vehicle Info Details
//-------------------------------------------------------------

func webserviceForUpdateDriverProfileUpdateVehicleInfoDetails(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateVehicleInfo
    postData(dictParams, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Driver Profile Update Document Details
//-------------------------------------------------------------

func webserviceForUpdateDocumentDetails(_ dictParams: AnyObject, image: UIImage, imageParamName: String, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateDocument
    sendUpdateDriverDocument(dictParams as! [String : AnyObject], image: image, imageParamName: imageParamName, nsURL: url, completion: completion)
    
}


//-------------------------------------------------------------
// MARK: - Webservice For Completed Trip Successfully
//-------------------------------------------------------------

func webserviceForCompletedTripSuccessfully(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SubmitCompleteBooking
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Sign Out
//-------------------------------------------------------------

func webserviceForSignOut(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = signOut + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Completed Advance Trip Successfully
//-------------------------------------------------------------

func webserviceForCompletedAdvanceTripSuccessfully(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SubmitCompleteAdvancedBooking
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Submit Book Now By Dispatch Job
//-------------------------------------------------------------

func webserviceForSubmitBookNowByDispatchJob(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SubmitBookNowByDispatchJob
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Submit Book Later By Dispatch Job
//-------------------------------------------------------------

func webserviceForSubmitBookLaterByDispatchJob(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = SubmitBookLaterByDispatchJob
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Accept dispatch job request
//-------------------------------------------------------------

func webserviceForFutureAcceptDispatchJobRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AcceptDispatchJobRequest + (dictParams as! String)
    getDataOfHistory("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Company List
//-------------------------------------------------------------

func webserviceForCompanyList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Company
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Booking History
//-------------------------------------------------------------

func webserviceForBookingHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    //    let url = "\(BookingHistory)/\(dictParams)"
    let url = BookingHistory
    postData(dictParams as AnyObject, nsURL: url, completion: completion)
    //    getData(dictParams as AnyObject, nsURL: url, completion: completion)
}

//func webserviceForBookingHistry(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
//{
//
//    let url = BookingHistory + (dictParams as! String)
//    getDataOfHistory("" as AnyObject, nsURL: url, completion: completion)
//
//}

//-------------------------------------------------------------
// MARK: - Webservice For Pending Jobs
//-------------------------------------------------------------
func webserviceForPendingJobs(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    
    let url = PendingJobs + (dictParams as! String)
    getDataOfHistory("" as AnyObject, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Log Record  History
//-------------------------------------------------------------

func webserviceForLogRecordHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    
    let url = LogRecordHistory + (dictParams as! String)
    getDataOfHistory("" as AnyObject, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Future Booking
//-------------------------------------------------------------

func webserviceForFutureBooking(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    
    let url = FutureBooking + (dictParams as! String)
    getDataOfHistory("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For My Dispatch Jobs List
//-------------------------------------------------------------

func webserviceForMyDispatchJobsList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = MyDispatchJob + (dictParams as! String)
    getDataOfHistory("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get driver profile
//-------------------------------------------------------------

func webserviceForGetDriverProfile(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetDriverProfile + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - Webservice For Get Distace from Backend
//-------------------------------------------------------------

func webserviceForGetdistanceFromBackend(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url =  "http://54.206.55.185/web/Drvier_Api/FindDistance"//GetDistanceFromBackend
    postData(dictParams, nsURL: url, completion: completion)
    
    //    let url = GetDistanceFromBackend + (dictParams as! String)
    //    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Current Booking
//-------------------------------------------------------------

func webserviceForCurrentBooking(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CurrentBooking + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Add New Card in Wallet
//-------------------------------------------------------------

func webserviceForAddNewCardInWallet(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AddNewCard
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Card Listing in Wallet
//-------------------------------------------------------------

func webserviceForCardListingInWallet(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CardListing + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Add Money in Wallet
//-------------------------------------------------------------

func webserviceForAddMoneyInWallet(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AddMoneyToWallet
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Transaction History in Wallet
//-------------------------------------------------------------

func webserviceForTransactionHistoryInWallet(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TransactionHistory + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Send Money in Wallet
//-------------------------------------------------------------

func webserviceForASendMoneyInWallet(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = sendMoney
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For QR Code Details
//-------------------------------------------------------------

func webserviceForQRCodeDetails(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = QRCodeDetails
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Remove Card
//-------------------------------------------------------------

func webserviceForRemoveCardFromWallet(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = RemoveCard + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For TiCKPay
//-------------------------------------------------------------

func webserviceForTickPay(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Tickpay
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Google News
//-------------------------------------------------------------

func webserviceForGoogleNews(_ dictParams: AnyObject, completion: @escaping(_ result: NSDictionary, _ success: Bool) -> Void)
{
    let url = GoogleNewsURL + (dictParams as! String)
    getDataGoogle("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For TiCKPay Get Rate
//-------------------------------------------------------------

func webserviceForGetTickpayRate(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetTickpayRate + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For TiCKPay SendInvoice
//-------------------------------------------------------------

func webserviceForSendInvoice(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TickpayInvoice
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Weekly earnings
//-------------------------------------------------------------

func webserviceForWeeklyEarnings(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = WeeklyEarnings + (dictParams as! String)
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Transfer Money to Bank
//-------------------------------------------------------------

func webserviceForTransferMoneyToBank(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TransferMoneyToBank
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For App Setting
//-------------------------------------------------------------

func webserviceForAppSetting(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = AppSetting + "\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Rating
//-------------------------------------------------------------

func webserviceForGiveRating(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GiveRating
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get EstimateFare For Dispatch Jobs
//-------------------------------------------------------------

func webserviceForGetEstimateFareForDispatchJobs(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = estimateFare
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Get Taxi Model Pricing
//-------------------------------------------------------------

func webserviceForGetTaxiModelPricing(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = getTaxiModelPricing
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Get Fare with KM
//-------------------------------------------------------------
//
func webserviceForGetFareWithKm(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = getFareEstimateKm
    postData(dictParams, nsURL: url, completion: completion)
    
    //    getData("" as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Private Meter Booking
//-------------------------------------------------------------
//
func webserviceForPrivateMeterBooking(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = PrivateMeterBooking
    postData(dictParams, nsURL: url, completion: completion)
    
    //    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Cancel Trip
//-------------------------------------------------------------

func webserviceForCancelTrip(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = cancelTrip
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Manage Share Ride Flag
//-------------------------------------------------------------

func webserviceForManageShareRideFlag(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ManageShareRideFlag + "\(dictParams)"
    getData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Share Ride Listing
//-------------------------------------------------------------

func webserviceForShareRideListing(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = shareRide + "\(dictParams)"
    getData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Track Running Trip
//-------------------------------------------------------------

func webserviceForTrackRunningTrip(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TrackRunningTrip + "\(dictParams)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For My Rating List
//-------------------------------------------------------------

func webserviceForGetMyFeedbackList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = FeedbackList + "\(dictParams as! String)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Contact Us API
//-------------------------------------------------------------
func webserviceForContactUs(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ContactUsList
    postData(dictParams, nsURL: url, completion: completion)
}

//func webserviceForSignOut(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
//{
//    let url = signOut + (dictParams as! String)
//    getData("" as AnyObject, nsURL: url, completion: completion)
//}


//-------------------------------------------------------------
// MARK: - Webservice For Paid Cash Payment API
//-------------------------------------------------------------

func webserviceForPaidCashPayment(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CashPaymentService
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Update Profile
//-------------------------------------------------------------
func webserviceForUploadImage(_ dictParams: AnyObject, image: UIImage, imageParamName: String, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UploadDocs
    sendUpdateDriverDocument(dictParams as! [String : AnyObject], image: image, imageParamName: imageParamName, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Get Vehicle Type List
//-------------------------------------------------------------

func webserviceForGetVehicleTypeList(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VehicleType + "\(dictParams as! String)"
    getData("" as AnyObject, nsURL: url, completion: completion)
}

//--------------------------------------------------------------
// MARK: - Webservice For Update Docs
//--------------------------------------------------------------

func webserviceForEditDocumentImage(_ dictParams: AnyObject, image: UIImage, imageParamName: String, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = EditDocs
    sendUpdateDriverDocument(dictParams as! [String : AnyObject], image: image, imageParamName: imageParamName, nsURL: url, completion: completion)
    
}


//-------------------------------------------------------------
// MARK: - Webservice For Paid Cash Payment API
//-------------------------------------------------------------

func webserviceUpdateAllDocuments(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateAllDocuments
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Paid Cash Payment API
//-------------------------------------------------------------

func webserviceForTripFareInformation(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = TripFareInformation
    postData(dictParams, nsURL: url, completion: completion)
}


//-------------------------------------------------------------
// MARK: - Webservice For Past Booking
//-------------------------------------------------------------

func webserviceForPastBooking(_ dictParams: AnyObject, isLoading: Bool,completion: @escaping( _ result: AnyObject, _ success: Bool) -> Void)
{
    let url = pastBooking + (dictParams as! String)
    getDataWithOrWithoutLoading( dictParams: "" as AnyObject, nsURL: url, isLoading: isLoading, completion: completion)
}