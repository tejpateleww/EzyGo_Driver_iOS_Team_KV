//
//  File.swift
//  SwiftDEMO_Palak
//
//  Created by MAYUR on 17/01/18.
//  Copyright © 2018 MAYUR. All rights reserved.
//

import Foundation
import UIKit


struct StroryBords {
    static let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
    static let registrationStoryBoard = UIStoryboard.init(name: "Registration", bundle: nil)
}
let helpLineNumber = "1234567890"
let currencySign = "$"
let Appdelegate = UIApplication.shared.delegate as! AppDelegate
let strAppName : String = "Ezygo-DRIVER"

//let navController = NavigationRootViewController()
//let loaderGIF = ActivityGIFIndicatorViewController()


let RingToneSound : String = "EzyGo"
let kCurrencyForMeter = "$"

let kAdMobBannerViewHeight : CGFloat = 44
let KadUnitID : String = "ca-app-pub-3940256099942544/2934735716"
let KGADInterstitial : String = "ca-app-pub-3940256099942544/4411468910"
let KtestDevices : String = "2077ef9a63d2b398840261c8221a0c9b"

let kHtmlReplaceString   :   String  =   "<[^>]+>"
let currency : String = "$"

let kGoogle_Client_ID : String = "1052191415198-8uegn0efcr41f0njmaoilub6k50n35dd.apps.googleusercontent.com"
let kGoogleAPIKEY : String = "AIzaSyCtqQ0n_JgAUVydSwu3frORFsYH3C0nmMg"
let kGoogleReservationKey : String = ""
let kDeviceType : String = "1"

let kCustomerCareNumber : String = "8338375893"

let kFutureBooking : String = "FutureBooking"
let kPendingJob : String = "PendingJob"
let kPastJob : String = "PastJob"

let kPassengerType : String = "Passenger"
let kDriverType : String = "Driver"

let kAcceptTripStatus : String = "accepted"
let kPendingTripStatus : String = "pending"
let kTravellingTripStatus : String = "traveling"

let SCREEN_WIDTH = UIScreen.screenWidth
let SCREEN_HEIGHT = UIScreen.screenHeight

let SCREEN_MAX_LENGTH = max(UIScreen.screenWidth, UIScreen.screenHeight)
let SCREEN_MIN_LENGTH = min(UIScreen.screenWidth, UIScreen.screenHeight)

let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6_7 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P_7P = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812.0
let IS_IPAD_PRO = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1366.0


let ThemeNaviBlueColor : UIColor = UIColor.color(string: "01021a")
let ThemeNaviBlackLikeClearColor : UIColor = UIColor.color(string: "060609")
let ThemeTextFieldLineColor : UIColor = UIColor.color(string: "929495")
let ThemeRedColor : UIColor = UIColor.color(string: "d21f25")
let ThemeTextFieldBGGColor : UIColor = UIColor.color(string: "FFFFFF").withAlphaComponent(0.1)
let ThemeGreenColor : UIColor = UIColor.color(string: "2e9c61")
let ThemeLightGrayColor : UIColor = UIColor.color(string: "363b3f")
let ThemeEmptyGrayColor : UIColor = UIColor.color(string: "767879")
let ThemeGrayColor : UIColor = UIColor.color(string: "f0f0f0")
let ThemeStatusBarColor : UIColor = UIColor.color(string: "cccccc")
let ThemeYellowColor : UIColor = UIColor.color(string: "EC7E29")

let ThemeWalletYellowColor : UIColor = UIColor.color(string: "ed7a05")
let ThemeWalletBlueColor : UIColor = UIColor.color(string: "1d9fdd")
let ThemeWalletGreenColor : UIColor = UIColor.color(string: "1bcb83")


let ThemeDarkBlueColor : UIColor = UIColor.color(string: "010214")
let ThemeWhiteColor : UIColor = UIColor.color(string: "FFFFFF")
let ThemeClearColor : UIColor = UIColor.clear

let navigationBar_Height_IphoneX_ = 84

let kBack_Icon : String = "iconBack"
let kSearch_Icon : String = "iconSearch"
let kMap_Icon : String = "iconMap"

let kSave_Icon : String = "iconSave"
let kMenu_Icon : String = "iconMenu"
let kCallHelp_Icon : String = "iconCall"
let kRight_icon : String = "right_start_icon"
let kPlus_icon : String = "iconPlus"
let kNav_BG_Icon : String = "navi_bar_bg"
let kNav_Icon : String = "navi_icon"
let kBackButton: String = "iconBack"
let icon_Check : String = "check_icon"
let icon_Uncheck : String = "uncheck_icon"

//let kHelpDocuments : String = "Help Document"
//let kPaymentOption : String = "Payment Options"

let kTermConditions : String = "Term & Conditions"
let kFeedback : String = "Feedback"
let kReceipts : String = "Receipts"
let kMyBooking : String = "My Booking"
let kMyJobs : String = "My Jobs"
let kMyDashboard : String = "My Dashboard"



let imagePlaceHolderUser : String = "imgPlaceHolderUser"
let imagePlaceHolderLEAF : String = "iconLogoRound"


let iconEmptySearch : String = "iconEmptySearch"
let iconEmptyStore : String = "iconEmptyStore"
let iconEmptyNews : String = "iconEmptyNews"
let iconEmptyNoInternet : String = "iconEmptyNoInternet"
let iconEmptyProduct : String = "iconEmptyProduct"
let iconEmptyShopgban : String = "iconEmptyShoGBAN"


let CustomeFontOpenSansLightItalic : String = "OpenSansLight-Italic"
let CustomeFontOpenSansBold : String = "OpenSans-Bold"
let CustomeFontOpenSansSemiboldItalic : String = "OpenSans-SemiboldItalic"
let CustomeFontOpenSansCondensedLight : String = "OpenSans-CondensedLight"
let CustomeFontOpenSansExtraboldItalic : String = "OpenSans-ExtraboldItalic"
let CustomeFontOpenSansBoldItalic : String = "OpenSans-BoldItalic"
let CustomeFontOpenSansCondensedLightItalic : String = "OpenSans-CondensedLightItalic"
let CustomeFontOpenSansLight : String = "OpenSans-Light"
let CustomeFontOpenSansSemibold : String = "OpenSans-Semibold"
let CustomeFontOpenSansREgular : String = "OpenSans"
let CustomeFontOpenSansItalic : String = "OpenSans-Italic"
let CustomeFontOpenSansExtrabold : String = "OpenSans-Extrabold"


let kHOME : String = "Home"
let kMyProfile : String = "My Profile"
let kBankDetails : String = "Payment Method From Ezygo"
let kTripHistory : String = "My Jobs"
let kTripReceipts : String = "Trip Receipts/Invoices"
let kEzygoInvoices : String = "Ezygo Invoices"
let kWallet : String = "Wallet"
let kMyRating : String = "My Ratings"
let kLogRecord : String = "Log Record"
let kInviteDriver : String = "Invite Driver"
let kVehicleOption: String = "Vehicle Option"
let kDocuments: String = "Documents"
let kSettings : String = "Settings"
let kDriverPortal : String = "Driver Portal"
let kSignout : String = "Logout"


let kBookLaterPushNotification : String = "BookLaterDriverNotify"
let kBookNowPushNotification : String = "BookNowRequest"


let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String


let CLIENT_ID : String = "787787696945-nllfi2i6j9ts7m28immgteuo897u9vrl.apps.googleusercontent.com"
let REVERSED_CLIENT_ID : String = "com.googleusercontent.apps.787787696945-nllfi2i6j9ts7m28immgteuo897u9vrl"


//SEGUE
let kSegueLoginRegister : String = "segueLoginRegister"


let kLoginData : String = "LoginData"
let kIsLogin : String = "isLogin"
let kIsCurrentBookingFirstTime : String = "iscalledCurrentBooking"
let kYoutube : String = "youtube"
let kVimeo : String = "vimeo"
let kMP4 : String = "video"


let message_UnknownError : String = "Oops, something went wrong. Please try again later."
let message_NoDataNews : String = "Sorry,we can't find any media"
let message_NoDataStore : String = "No dispensaries within 20 miles of your location"
let message_NoDataProduct : String = "Sorry,we can't find any product"
let message_ComingSoon : String = "Coming Soon....!"
let message_NoInternetConnection : String = "No internet available"//"You do not seem to have a strong Internet connection. Kindly move to a WiFi or stronger cellular signal."

//Change
let NotificationTrackRunningTrip = NSNotification.Name("NotificationTrackRunningTrip")


//SideMenu Option
let kPaymentOption : String = "Payment Option"
//let kWallet : String = "My Wallet"
let kDriverNews : String = "Driver News"
let kInviteDrivers : String = "Invite Drivers"
let kChangePassword : String = "Change Password"
//let kSettings : String = "Settings"
let kMeter : String = "Meter"
let kTripToDstination : String = "Trip To Destination"
let kShareRide: String = "Share Ride"
let kLogout : String = "Log Out"

//SideMenu Option Icon
let kiconPaymentOption : String = "iconPayment"
let kiconWallet : String = "iconWallet"
let kiconDriverNews : String = "iconNews"
let kiconInviteDrivers : String = "iconInvite"
let kiconChangePassword : String = "iconChangePassword"
let kiconSettings : String = "iconSettings"
let kiconMeter : String = "iconMeter"
let kiconTripToDstination : String = "iconMeter"
let kiconLogout : String = "iconSignOut"
