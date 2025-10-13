
#pragma compress 0
#pragma dynamic	 500000

#define CGEN_MEMORY 120000
#define YSI_NO_HEAP_MALLOC
#define AMX_OLD_CALL

/* Includes */
#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 500

#include <memory>
#include <map-zones>

#include <a_mysql>
#include <a_zones>
#include <streamer>
#include <sscanf2>
#include <gvar>
#include <crashdetect>

#include <YSI\y_timers>      		//by Y_Less from YSI
#include <YSI\y_colours>            //by Y_Less from YSI
#include <YSI\y_ini>				//by Y_Less from YSI
#include <easyDialog>
#include <Pawn.CMD>
#include <FiTimestamp>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <3DTryg>
#include <EVF2>

#include <nex-ac>                   //BY Nexus
#include <nex-ac_id.lang>

#include <strlib>                   //by Slice
#include <sampvoice>
#include <selection>
#include <garageblock>
#include <cb>
#define COLOR_LOGS 0xC6E2FFFF
#include <textdraw-streamer>
#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0
//#include <colandreas>
//#include <progress2>  Arch warning fix// #include <ndialog-pages>

/* Includes
#include <a_samp>
#include <streamer>					//by Incognito
#include <sscanf2>					//by Y_Less fixed by maddinat0r & Emmet_
#include <a_mysql>
#include <map-zones>

#include <crashdetect>				//by Southclaws
#include <gvar>						//by Incognito

#include <Pawn.CMD> 				//
#include <FiTimestamp>

#include <EVF2>
#include <selection>

#include <YSI\y_timers>      		//by Y_Less from YSI
#include <YSI\y_colours>            //by Y_Less from YSI
#include <YSI\y_ini>				//by Y_Less from YSI

#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <3DTryg>

#include <nex-ac>					//
#include <strlib>					//
#include <easyDialog>				//
#include <sampvoice>
#include <garageblock>
#include <cb>						//by Emmet
// #include <Circulo>
// #include <noclass>
#include <textdraw-streamer>		//by Nex*/
#define Anim:: anim_
#define eprop:: eprop_
#define MAX_UICOMPASS_TD	7	//The amount of TD that will be used in Your compass
#define MIN_UICOMPASS_STEP	5	//The minimum step of the compass
#define MAX_UICOMPASS_STEP	15	//The maximum step of the compass
//#define RandomEx(%0,%1) 								random(%1 - %0) + %0
forward CheckVehicleCollisions();
#define MAX_DIST 2.5
#define CHECK_INTERVAL 1000
forward Compass_UpdateTimer(playerid);
//variables
new InRob[MAX_PLAYERS];
new STREAMER_TAG_CP:CarDealerCP;
new EnteredPhoneNumb[MAX_PLAYERS][5];
new PlayerText:JADENCOMPAS[MAX_PLAYERS][11];
new bool:CompassVisible[MAX_PLAYERS];
new CompassTimer[MAX_PLAYERS];
new Float:LastAngle[MAX_PLAYERS];
new takingclothes[MAX_PLAYERS];
new PlayerSpawn[MAX_PLAYERS];
new KalkulatorInput[MAX_PLAYERS][64];
//3d damage
#define COLOR_BAR        0xFF0000FF // First color of 3DText
#define HEALTH_LENGTH    3 // Max langth of damage (100 is 3, 10 is 2, 1 is 1)
#define HEALTH_DRAW      30.0 // Draw distance for the 3DText
#define HEALTH_OFFSET    0.2 // First 3DText offset
#define HEALTH_OFFSETADD 0.01 // Add every update to 3D offser - commant to disable
#define COLOR_DELETE     10 // Color brightnes to delet every update
#define TIME_FIRST       400 // Time from creation to first update
#define TIME_BLOW        66 // Time from update tp update
//new PlayerWhatsappPage[MAX_PLAYERS];
#define NAMETAG_DISTANCE 20
#define index_kotak_whatsapp_chat 0
#define index_whatsapp_chat 0
//new timerperampokan[MAX_PLAYERS];
//new PhonePlayerStatus[MAX_PLAYERS];
//new WhatsAppSent[MAX_PLAYERS][128];
//new PlayerWhatsappPage[MAX_PLAYERS];
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new bool:TempFreeCar[MAX_PLAYERS];
new CountText[5][5] =
{
    "~r~1",
    "~y~2",
    "~y~3",
    "~y~4",
    "~y~5"
};
new AimbotWarnings[MAX_PLAYERS];

new Light_Truck[][2] = {
    {422, 41000}, //bobcat
    {543, 39000}, //sadler
    {478, 40000}, //walton
    {554, 47500}, //yosemite
    {600, 41000} //picador
};

new Heavy_Truck[][2] = {
    {414, 130000}, //mule
    {455, 200000}, //flatbed
    {456, 135000}, //yankee
    {499, 150000} //benson
};

new SUVWagon[][2] = {
    {579, 250000}, //huntley
    {400, 170000}, //landstalker
    {404, 120000}, //perenniel
    {489, 200000},  //Rancher
    {479, 135000}, //regina
    {458, 135000}, //solair
    {418, 120000}, //Moonbeam
    {482, 150000},  //Burrito
    {459, 160000}  //rc van
};

new Motorbike[][2] = {
    {462, 25000}, //Faggio = 1,190.00
    {581, 45000}, //BF-400 = 2,200.00
    {521, 90000}, //FCR-900 = 3,150.00
    {461, 60000}, //PCJ-600 - 2,500.00
    {468, 125000}, //sanchez 1,420.00
    {463, 150000}, //freeway = 1,560.00
    {586, 60000} //wayfarer = 1,380.00
};

new Lowriders[][2] = {
    {536, 85500}, //blade
    {575, 75000},  //broadway
    {534, 85000}, //remington
    {567, 90000}, //savanna
    {412, 75000}, //voodo
    {576, 71000} //tornado
};

new TwoDoor_Compact[][2] = {
    {549, 80000}, //tampa
    {491, 75000}, //virgo
    {480, 250000}, //comet
    {442, 82000}, //romero
    {439, 81000}, //stallion
    {419, 81000}, //esperanto
    {545, 105000}, //hustler
    {602, 200000}, //alpha
    {496, 84000}, //blista compact
    {401, 75000}, //bravura
    {527, 81000}, //cadrona
    {533, 81000}, //feltzer
    {526, 83900}, //fortune
    {410, 81000},  //manana
    {436, 80500}, //previon
    {542, 80000}, //clover
    {475, 85000}, //sabre
    {555, 83000}, //windsor
    {518, 91000}, //buccaner
    {589, 150000},  //club
    {474, 250000}, //hermes
    {517, 82000}, //majestic
    {500, 200000} //mesa
};

new FourDoor_Luxury[][2] = {
    {445, 105000}, //admiral
    {507, 105000}, //elegant
    {492, 105000}, //greenwood
    {585, 105000}, //emperor
    {546, 105000}, //intruder
    {551, 105000}, //merit
    {516, 105000}, //nebula
    {426, 200000}, //premier
    {547, 105000}, //primo
    {405, 105000}, //sentinel
    {580, 105000}, //stafford
    {550, 105000}, //sunrise
    {566, 105000}, //tahoma
    {540, 105000}, //vincent
    {421, 105000}, //washington
    {529, 105000}, //willard
    {561, 250000}, //stratum
    {560, 250000}, //sultan
    {467, 105000}, //oceanic
    {466, 105000} //glendale
};

new PlayerText: HandphoneGameXo[MAX_PLAYERS][64];
enum __serverInfo
{
    cooldownlojas1
}
new GM[__serverInfo];
//telpon
new zahPhonelCall[MAX_PLAYERS][10],
	azahPhonelCall[MAX_PLAYERS][10],
	rrechnungPhoneCall[MAX_PLAYERS],
	ergebPhoneCall[MAX_PLAYERS],
	rechiPhoneCall[MAX_PLAYERS][25];
#define MAX_AREA_WARNINGS 3 // Maksimal pelanggaran sebelum dihukum
new g_WarningCount[MAX_PLAYERS];

#define SLOTHELM 1 //By default uses slot 1, change it if you need slot 1 for other thing.

new JoueurAppuieJump[MAX_PLAYERS];

new bool:g_sBoxDoorOpened,
    STREAMER_TAG_AREA:sBoxDoorSensor,
    STREAMER_TAG_OBJECT:sBoxDoor[2];

new bool:g_PutriDeliDoorOpened,
    STREAMER_TAG_AREA:PutriDeliDoorSensor,
    STREAMER_TAG_OBJECT:PutriDeliDoor[2];

new bool:g_SriMersingFDoorOpened,
    STREAMER_TAG_AREA:SriMersingFDoorSensor,
    bool:g_SriMersingBDoorOpened,
    STREAMER_TAG_AREA:SriMersingBDoorSensor,
    STREAMER_TAG_OBJECT:SriMersingDoor[4];
#define KEY_AIM			(128)

//snow mountain
new snow1[MAX_PLAYERS];
new snow2[MAX_PLAYERS];
new snow3[MAX_PLAYERS];
new snow4[MAX_PLAYERS];
new snow5[MAX_PLAYERS];
new snow6[MAX_PLAYERS];
new snow7[MAX_PLAYERS];
new snow8[MAX_PLAYERS];
new snow9[MAX_PLAYERS];
new snow10[MAX_PLAYERS];

new snowtext1[MAX_PLAYERS];
new snowtext2[MAX_PLAYERS];
new snowtext3[MAX_PLAYERS];
new snowtext4[MAX_PLAYERS];

new entrance[MAX_PLAYERS];

new sp1[MAX_PLAYERS];
new sp2[MAX_PLAYERS];
new sp3[MAX_PLAYERS];
new sp4[MAX_PLAYERS];
new sp5[MAX_PLAYERS];
new sp6[MAX_PLAYERS];
new sp7[MAX_PLAYERS];
new sp8[MAX_PLAYERS];
new sp9[MAX_PLAYERS];
new sp10[MAX_PLAYERS];
new sp11[MAX_PLAYERS];

new rock1[MAX_PLAYERS];
new rock2[MAX_PLAYERS];
new rock3[MAX_PLAYERS];
new rock4[MAX_PLAYERS];
new rock5[MAX_PLAYERS];
new rock6[MAX_PLAYERS];
new rock7[MAX_PLAYERS];
new rock8[MAX_PLAYERS];
new rock9[MAX_PLAYERS];
new rock10[MAX_PLAYERS];
new rock11[MAX_PLAYERS];
new rock12[MAX_PLAYERS];
new rock13[MAX_PLAYERS];
new rock14[MAX_PLAYERS];
new rock15[MAX_PLAYERS];
new rock16[MAX_PLAYERS];
new rock17[MAX_PLAYERS];
new
	bool:IsVehicleShaking[MAX_VEHICLES]
;

new //up_days,
//up_hours,
WorldWeather = 1;
//WorldTime = 7,
new JamFivEm;
new DetikFivEm;

new PlayerText: HandphoneKontak[MAX_PLAYERS][83];
new PlayerText: HandphoneWhatsapp[MAX_PLAYERS][90];
new MySQL:
g_SQL;

enum
{
    NOTIFICATION_ERROR,
    NOTIFICATION_SUKSES,
    NOTIFICATION_WARNING,
    NOTIFICATION_INFO,
    NOTIFICATION_SYNTAX
};

enum
{
    DEFAULT_XP = 5
};

/* Player Enums*/
enum E_PLAYERS
{
    pID,
    pUCP[22],
    pExtraChar,
    pChar,
    pName[MAX_PLAYER_NAME],
    pAdminname[MAX_PLAYER_NAME],
    pIP[16],
    pVerifyCode,
    pPassword[65],
    pSalt[17],
    pAdmin,
    pLevel,
    pLevelUp,
    pVip,
    pVipNameCustom[256],
    pVipTime,
    pRegDate[50],
    pLastLogin[50],
    pLastSpawn,
    pMoney,
    pRedMoney,
    STREAMER_TAG_3D_TEXT_LABEL:pMaskLabel,
    STREAMER_TAG_3D_TEXT_LABEL:pLabelDuty,
    pBankMoney,
    pSaldoGopay,
    pTargetGopay,
    pJumlahGopay,
    pBankRek,
    Smartphone,
    pPhone[32],
    pContact,
    pCall,
    pHours,
    pMinutes,
    pSeconds,
    pPaycheck,
    pSkin,
    pFacSkin,
    pGender,
    pUniform,
    pUsingUniform,
    pAge[50],
    pOrigin[32],
    pTinggiBadan,
    pBeratBadan,
    pInDoor,
    pInHouse,
    pInRusun,
    pInBiz,
    pInFamily,
    Float:
    pPosX,
    Float:
    pPosY,
    Float:
    pPosZ,
    Float:
    pPosA,
    pInt,
    pWorld,
    Float:pHealth,
    Float:pArmour,
    pHunger,
    pThirst,
    pHungerTime,
    pThirstTime,
    pStress,
    pStressTime,
    pInjured,
    pInjuredTime,
    LastDokterLokal,
    pOnDuty,
    pFaction,
    pFactionRank,
    pTazer,
    pTaserGun,
    pLastShot,
    pShotTime,
    pStunned,
    pFamily,
    pFamilyRank,
    pJail,
    pJailTime,
    pJailReason[126],
    pJailBy[MAX_PLAYER_NAME],
    pArrest,
    pArrestTime,
    pWarn,
    pJob,
    pMask,
    pMaskID,
    pMaskOn,
    pHelmet,
    pGuns[13],
    pAmmo[13],
    pWeapon,
    Cache:Cache_ID,
    bool:
    IsLoggedIn,
    LoginAttempts,
    pSpawned,
    pAdminDuty,
    pAdminHide,

    //the star
    pTheStars,
    pTheStarsTime,

    pFreezeTimer,
    pFreeze,
    pSPY,
    pTogPM,
    pTogGlobal,
    pTogWT,
    Text3D:pAdoTag,
    bool:pAdoActive,

    pFlare,
    bool:pFlareActive,
    pFlareIcon[MAX_PLAYERS],

    pTrackCar,
    pTrackHoused,
    pCuffed,
    toySelected,
    bool:PurchasedToy,
    pEditingItem,
    pEditingAmmount,
    pProductModify,
    pCurrSeconds,
    pCurrMinutes,
    pCurrHours,
    pSpec,
    playerSpectated,
    pFriskOffer,
    pDragged,
    pDraggedBy,
    pDragTimer,
    pHelmetOn,
    pSeatBelt,
    pReportTime,
    pAskTime,
    pActivity,
    pActivityStatus,
    pActivityTime,
    Float:
    ActivityTime,
    Float:
    NotifyTime,
    pLoadingBar,
    Float:pLoadingBars,
    pTimerLoading,
    pDiPesawat,
    //Jobs
    pSideJob,
    pSideJobTime,
    pSweeperTime,
    pBusTime,
    pMowerTime,
    pVehicleFaction,
    pMechVeh,
    pMechColor1,
    pMechColor2,
    EditingSAMPAHID,
    EditingPOMID,
    EditingATMID,
    EditingROBERID,
    EditingLADANGID,
    EditingUraniumID,
    EditingDeerID,
    bool:
    pOnBusJob,
    pTransfer,
    pTransferRek,
    pTransferName[128],
    gEditID,
    gEdit,
    pHead,
    pPerut,
    pLHand,
    pRHand,
    pLFoot,
    pRFoot,
    pDutyTimer,
    pPark,
    pACWarns,
    pACTime,
    pJetpack,
    pArmorTime,
    pLastUpdate,
    pBus,
    pSweeper,
    pMower,
    pSpeedTime,
    pLoopAnim,
    SelectBandara,
    SelectPelabuhan,
    SelectRusun,
    SelectRumah,
    SelectLastExit,
    pRobSystem,
    pRobBankArea,
    pHacking,
    pRobBank,
    Float:pValueAction,
    pLockpick,
    pNambangBatu,
    pMainXo,
    pSelectItem,
    pSelectItem2,
	pSelectItem3,
	pSelectItem4,
	pSelectItem5,
	pIsUsingUniform,
	pBetulNama,
    pBetulGender,
	pBetulAge,
	pBetulHeight,
	pBetulWeight,
	pBetulOrigin,
	pBukaWarung,
	pBukaElektronik,
	bool:pIsSmoking,
	bool:pIsSmokeBlowing,
	pSmokedTimes,
	//============[Billiard]============//
	pPoolTable,
	pPlayingPool,
	pPlayerWeapon,
	pAiming,
	EditingkoranID,
	pBetulPw,
    pGiveAmount,
    pListItem,
    pListItemGudang,
    pBagasiTake,
    pVehListItem,
    pStorageGudang,
    pGiveInv,
    pAmountInv,
    pPmin,
    pPsec,
    pBsec,
    pCSmin,
    pCSsec,
    pDipanggilan,
    pTargetAirdrop[10],
    pNamaAirdrop[32],
    pNomorAirdrop[32],
    pNominal,
    pRekening,
    pTargetFamily[10],
    pOnBadai,
    pGSec,
    pDutyPD,
    pDutyPemerintah,
    pDutyEms,
    pDutyBengkel,
    pDutyPedagang,
    pDutyGojek,
    pDutyTrans,
    pDutyKargo,
    pRespawnVehJob,
    pTimerRespawn,
    pTimerSpawnKanabis,
    pEditingPenumpang,
    pSignalTime,
    pEarphone,
    pRadio,
    pAsapRokok,
    pHisapRokok,
    pMancing,
    Float:
    pBeratItem,
    Float:
    pRusunCapacity,
    Float:
    pGudangCapacity,
    pJerigenUse,
    bool:pActionActive,
    pHasGudangID,
    pGudangRentTime,
    pOwnedRusun,
    Ktp,
    LastSpawn,
    Spawned,
    pRobSec,
    pRobMin,
    pPaycheckTime,
    pSimA,
    pSimB,
    pSimC,
    pSimATime,
    pSimBTime,
    pSimCTime,
    pGunLic,
    pGunLicTime,
    pHuntingLic,
    pHuntingLicTime,
    pStorageSelect,
    DownloadWhatsapp,
    DownloadSpotify,
    DownloadGojek,
    DownloadTwitter,
    EngineOn,
    pSpeedLimit,
    GarkotVehList,
    ClickSpawn,
    pInviteRusun,
    pInviteHouse,
    pInviteAccept,
    pKompensasi,
    pGoodMood,
    pOwnedHouse,
    pOpenBackpackTimer,
    bool:pStarterpack,
    pDealerVeh,
    pTempName[MAX_PLAYER_NAME],
    pTempValue,
    pTempVehID,
    pTempVehJobID,
    pTempSQLFactMemberID,
    pTempSQLFactRank,
    pTempSQLFamMemberID,
    pTempSQLFamRank,
    pTempText[320],
    pTempPlayerID,
    pTempCallNumber,
    pSKS,
    pSKSTime,
    pSKSNameDoc[128],
    pSKSRankDoc[128],
    pSKSReason[128],
    pSKCK,
    pSKCKTime,
    pSKCKNamePol[128],
    pSKCKRankPol[128],
    pSKCKReason[128],
    pBPJS,
    pBPJSTime,
    pBPJSLevel[128],
    pSKWB,
    pSKWBTime,
    pCarSeller,
    pCarOffered,
    pCarValue,
    pTogAutoEngine,
    phoneShown,
    pCaller,
    pDurringKarung,
    pTarget,
    pVehAudioPlay,
    hsAudioPlay,
    pHotlineTime,
    pTempValue2,
    pTraceTime,
    TwitterName[128],
    TwitterPassword[128],
    Twitter,
    bool:
    pTurningEngine,
    bool:
    UsingDoor,
    bool:
    CurrentlyReadWA,
    bool:
    CurrentlyReadYellow,
    bool:
    CurrentlyReadTwitter,

    bool:
    EMSDuringReviving,

    pTrashmaster,
    pTrashmasterDelay,
    pLastVehicle,
    pDeliveryTime,
    pForkliftTime,

    /* Dragging */
    pDragOffer,
    pFriendHouseID,

    pFixmeTime,
    pTempOlah,
    pClaimStarterpack,

    bEditID,
    bEdit,

    pEditSlotID,

    /* Taxi Stuffs */
    pTaxiDuty,
    pTaxiOrder,
    pTaxiPlayer,
    pTaxiFee,
    pTaxiRunDistance,
    Float:tPos[3],

    //saving
    aReceivedReports,
    aDutyTimer,
    pFashionItem,

    //notsave
    bool:
    AirdropPermission,
    bool:phoneAirplaneMode,
    bool:phoneDurringConversation,
    bool:phoneIncomingCall,
    phoneCallingWithPlayerID,
    phoneCallingTime,
    phoneCallRingtone[128],

    pFactDutyTimer,
    Float:pMapSettings,
    pMapRender,
    pSuspectTimer,
    bool:
    menuShowed,
    playerClickSpawn,
    pTogSpy,
    OnlineTimer,
    bool:
    ToggleFPS,
    DokterLokalTimer,

    pCheckpoint,
    pXmasTime,
    pTogAC,
    pStyleNotif,

    pShowFooter,
    pFooterTimer,

    //Afk System
    Float:pAFKPos[6],
    pAFK,
    pAFKTime,
    pAFKCode,

    pEditTextObject,
    pHUDMode,
    bool:
    pNameTagShown,
    pMenuType,
    pInWs,
    pTransferWS,
    pMaterial,
    pComponent,
    bool:
    pNtagShown,

    bool:
    pFlashShown,
    bool:
    pFlashOn,
    
   	pUseGarage,
	pGarage[4],
	pGetPARKID,
	pTakeVehicle,
	
	pPage,
	pEditing,
	pEditingStr[64],
	pEditingID,

    pJobVehicle,
    bool:newCitizen,
    newCitizenTimer,
    bool:pProgress
};
new AccountData[MAX_PLAYERS][E_PLAYERS];
#define COLOR_SYNTAX        0x1DF0BB85
//#define PlayerInfo AccountData
enum
{
    DIALOG_MAKE_CHAR,
    DIALOG_CHARLIST,
    DIALOG_VERIFYCODE,
    DIALOG_UNUSED,
    DIALOG_LOGIN,
    DIALOG_REGISTER,
    DIALOG_AGE,
    DIALOG_MY_WS,
    WS_MENU,
    WS_SETNAME, 
    WS_SETEMPLOYEE,  
    WS_SETEMPLOYE,
    WS_COMPONENT,
    WS_COMPONENT2,
    WS_MATERIAL2,
    WS_MATERIAL,
    WS_MONEY,
    WS_WITHDRAWMONEY,
    WS_DEPOSITMONEY,
    WS_SETOWNERCONFIRM,
    DIALOG_ORIGIN,
    DIALOG_TINGGIBADAN,
    DIALOG_BERATBADAN,
    DIALOG_GENDER,
    DIALOG_TOY,
    DIALOG_TOYEDIT,
    DIALOG_TOYEDIT_ANDROID,
    DIALOG_TOYPOSISI,
    DIALOG_TOYPOSISIBUY,
    DIALOG_TOYVIP,
    DIALOG_TOYPOSX,
    DIALOG_TOYPOSY,
    DIALOG_TOYPOSZ,
    DIALOG_TOYPOSRX,
    DIALOG_TOYPOSRY,
    DIALOG_TOYPOSRZ,
    DIALOG_TOYPOSSX,
    DIALOG_TOYPOSSY,
    DIALOG_TOYPOSSZ,
    DIALOG_HELP,
    DIALOG_EDITBONE,
    DIALOG_REPORTS,
    DIALOG_REPORTSREPLY,
    DIALOG_ASKS,
    DIALOG_ASKSREPLY,
    DIALOG_HEALTH,
    DIALOG_TDM,
    DIALOG_DISNAKER,
    DIALOG_MEMBERI,
    DIALOG_SETAMOUNT,
    DIALOG_MODIF,
    DIALOG_MODIF_VELG,
    DIALOG_MODIF_SPOILER,
    DIALOG_MODIF_HOODS,
    DIALOG_MODIF_VENTS,
    DIALOG_MODIF_LIGHTS,
    DIALOG_MODIF_EXHAUSTS,
    DIALOG_MODIF_FRONT_BUMPERS,
    DIALOG_MODIF_REAR_BUMPERS,
    DIALOG_MODIF_ROOFS,
    DIALOG_MODIF_SIDE_SKIRTS,
    DIALOG_MODIF_BULLBARS,
    DIALOG_MODIF_NEON,

    DIALOG_STREAMER_CONFIG,
    DANN_RENTAL,
    DANN_UNRENT,
    DANN_ASURANSI,
    DANN_BUYALATSTEAL,
    DANN_PILIHSPAWN,
    DANN_PICKUPVEH,
    DANN_DYNHELP,

    DIALOG_RUSUN,
    DIALOG_RUSUN_OWNED,
    DIALOG_RUSUN_BRANKAS,
    DIALOG_RUSUN_INVITE,
    DIALOG_RUSUN_INVITECONF,
    DIALOG_RUSUN_BROPTION,
    DIALOG_RUSUN_MENU,
    DIALOG_RUSUNOWNED,
    DIALOG_RUSUNOPENSTORAGE,
    DIALOG_RUSUNITEM,

    DIALOG_RUSUNVAULT_DEPOSIT,
    DIALOG_RUSUNVAULT_WITHDRAW,
    DIALOG_RUSUNVAULT_IN,
    DIALOG_RUSUNVAULT_OUT,

    DIALOG_KAYU_START,
    DIALOG_SUSU_START,
    DIALOG_MINYAK_START,
    DIALOG_AYAM_START,
    DIALOG_MOWER_START,
    DIALOG_STEAL_SHOP,
    DIALOG_IKEA_MENU,
    DIALOG_IKEA_BESI,
    DIALOG_IKEA_BERLIAN,
    DIALOG_IKEA_EMAS,
    DIALOG_IKEA_TEMBAGA,
    DIALOG_IKEA_AYAMKEMAS,
    DIALOG_IKEA_KAYUKEMAS,
    DIALOG_IKEA_GAS,
    DIALOG_IKEA_PAKAIAN,

    DIALOG_FARMER_OLAH,
    DIALOG_LOUNGES_MASAK,
    DIALOG_HUNTING_SELL,
    DIALOG_BAGASISTORAGE,

    DIALOG_GUDANG,
    DIALOG_GUDANGSTOP,
    DIALOG_GUDANGOPTION,
    DIALOG_GUDANGOWNED,
    DIALOG_GUDANGITEM,
    DIALOG_GUDANGDEPOSIT,
    DIALOG_GUDANGWITHDRAW,

    LokasiGps,
    LokasiUmum,
    LokasiPekerjaan,
    LokasiHobi,
    LokasiPertokoan,
    DialogWarung,
    BeliNasduk,
    BeliAqua,
    BeliUmpan,
    DialogGadget,
    DANN_BOOMBOX,
    DANN_BOOMBOX1,
    DialogSpotify,
    DialogSpotify1,
    DialogFish,
    DialogCargo,
    DialogSpawn,
    DialogDropItem,
    DialogTransfer,
    DialogTransfer1,
    DialogBankConfirm,
    DialogElist,
    // -----------
    DialogShowroom,
    DialogAsuransi,
    // -------------
    DialogKontak,
    DialogOpenContact,
    DialogContact,
    DialogTelepon,
    DialogContactMenu,
    DialogContactMenus,
    DialogGarasiKota,
    DialogMyVeh,
    DialogTrackMyVeh,
    DialogBagasi,
    PHONE_WHATSAPP,
    // -----------
    DialogToyEdit,

    DIALOG_CRAFTING,
    DIALOG_CRAFTINGCONF,
    DIALOG_FAMILY_PANEL,
    DIALOG_FAMSTAKE_REDMONEY,
    DIALOG_FAMSTAKE_MONEY,
    DIALOG_FAMGARAGE_OUT,
    DIALOG_BLACKMARKET,

    DIALOG_DEPOSIT_POLICE,
    DIALOG_WITHDRAW_POLICE,

    DIALOG_POLVAULT,
    DIALOG_POLVAULT_DEPOSIT,
    DIALOG_POLVAULT_WITHDRAW,
    DIALOG_POLVAULT_IN,
    DIALOG_POLVAULT_OUT,

    DIALOG_POLICE_PANEL,
    DIALOG_POLICE_BOSDESK,
    DIALOG_POLICESETRANK,
    DIALOG_POLICEKICKMEMBER,
    DIALOG_RANK_SET_POLISI,
    DIALOG_POLICE_INVITE,
    DIALOG_POLICE_GARAGE,
    DIALOG_POLICE_GARAGE_BUY,
    DIALOG_POLICE_GARAGE_DEL,
    DIALOG_POLICE_HELI_GARAGE,
    DIALOG_POLICE_HELI_BUY,
    DIALOG_POLICE_HELI_GARAGE_OUT,
    DIALOG_POLICE_GARAGE_OUT,
    DIALOG_POLICE_IMPOUND,
    DIALOG_POLICE_TAKE_IMPOUND,
    DIALOG_FEDERAL_GARAGE,
    DIALOG_FEDERAL_GARAGE_BUY,
    DIALOG_FEDERAL_GARAGE_OUT,
    DIALOG_PDM,
    DIALOG_PDM_VEHICLE,
    DIALOG_PDM_VEHICLE_IMPOUND,
    DIALOG_PDM_OBJECT,
    DIALOG_ADD_HKRIMINAL,
    DIALOG_REMOVE_HKRIMINAL,

    DIALOG_EMS_PANEL,
    DIALOG_EMS_GARAGE,
    DIALOG_EMS_GARAGE_BUY,
    DIALOG_EMS_GARAGE_TAKEOUT,
    DIALOG_EMS_GARAGE_DELETE,
    DIALOG_EMSBRANKAS,
    DIALOG_EMSBKCONFIRM,
    DIALOG_EMS_BOSDESK,
    DIALOG_EMS_INVITE,
    DIALOG_EMS_LOCKER,
    DIALOG_EMS_CLOTHES,
    DIALOG_EMSSETRANK,
    DIALOG_EMSKICKMEMBER,
    DIALOG_RANK_SET_EMS,
    DIALOG_DEPOSIT_EMS,
    DIALOG_WITHDRAW_EMS,

    DIALOG_EMSVAULT,
    DIALOG_EMSVAULT_DEPOSIT,
    DIALOG_EMSVAULT_WITHDRAW,
    DIALOG_EMSVAULT_IN,
    DIALOG_EMSVAULT_OUT,
    // ------------------ PEMERINTAH
    DIALOG_PEMERINTAH_LOCKER,
    DIALOG_PEMERINTAH_LOCKERMALE,
    DIALOG_PEMERINTAH_LOCKERFEMALE,
    DIALOG_PEMERINTAH_PANEL,
    DIALOG_PEMERINTAH_BOSDESK,
    DIALOG_PEMERSETRANK,
    DIALOG_PEMERKICKMEMBER,
    DIALOG_RANK_SET_PEMERINTAH,
    DIALOG_PEMERINTAH_INVITE,
    DIALOG_PEMERINTAH_DEPOSIT,
    DIALOG_PEMERINTAH_WITHDRAW,
    DIALOG_PEMER_GARAGE,
    DIALOG_PEMER_GARAGE_BUY,
    DIALOG_PEMER_GARAGE_TAKEOUT,
    DIALOG_PEMER_GARAGE_DELETE,

    DIALOG_PEMERVAULT,
    DIALOG_PEMERVAULT_DEPOSIT,
    DIALOG_PEMERVAULT_WITHDRAW,
    DIALOG_PEMERVAULT_IN,
    DIALOG_PEMERVAULT_OUT,

    DIALOG_PEDSETRANK,
    DIALOG_PEDKICKMEMBER,
    DIALOG_RANK_SET_PEDAGANG,
    DIALOG_LOCKERPEDAGANG,
    DIALOG_PEDAGANG_GARAGE,
    DIALOG_PEDAGANG_GARAGE_BUY,
    DIALOG_PEDAGANG_GARAGE_TAKEOUT,
    DIALOG_PEDAGANG_GARAGE_DELETE,

    DIALOG_BENGKEL_PANEL,
    DIALOG_BENGKEL_LOCKER,
    DIALOG_BENGKEL_CLOTHES,
    DIALOG_BENGKEL_GARAGE,
    DIALOG_MODIF_COLOROPTION,
    DIALOG_MODIF_WARNA1,
    DIALOG_MODIF_WARNA2,
    DIALOG_MODIF_PAINTJOB,
    DIALOG_BENGKELBUYVEH,
    DIALOG_BENGKELTAKEVEH,
    DIALOG_BENGKEL_BRANKASOPTION,
    DIALOG_BENGKEL_BRANKASITEM,
    DIALOG_BENGKEL_BRANKASCONF,
    DIALOG_BENGKEL_BRANKASREPAIRKIT,
    DIALOG_BENGKEL_BRANKASTOOLSKIT,
    DIALOG_BENGKEL_BOSDESK,
    DIALOG_BENGKEL_INVITE,
    DIALOG_BENGKELSETRANK,
    DIALOG_BENGKELKICKMEMBER,
    DIALOG_RANK_SET_BENGKEL,
    DIALOG_BENGKELDELCAR,
    DIALOG_DEPOSIT_BENGKEL,
    DIALOG_WITHDRAW_BENGKEL,

    DIALOG_BENGVAULT,
    DIALOG_BENGVAULT_DEPOSIT,
    DIALOG_BENGVAULT_WITHDRAW,
    DIALOG_BENGVAULT_IN,
    DIALOG_BENGVAULT_OUT,

    DIALOG_BOSDESK_GOJEK,
    DIALOG_DEPOSIT_GOJEK,
    DIALOG_WITHDRAW_GOJEK,
    DIALOG_RANK_SET_GOJEK,
    DIALOG_GOJEK_INVITECONF,
    DIALOG_GOJEK_LOCKER,

    DIALOG_GOJEK_GARAGE,
    DIALOG_GOJEK_GARAGE_BUY,
    DIALOG_GOJEK_GARAGE_TAKEOUT,
    DIALOG_GOJEK_GARAGE_DELETE,

    DIALOG_GOJVAULT,
    DIALOG_GOJVAULT_DEPOSIT,
    DIALOG_GOJVAULT_WITHDRAW,
    DIALOG_GOJVAULT_IN,
    DIALOG_GOJVAULT_OUT,

    DIALOG_PAYGOJEK,
    DIALOG_PAYGOJEKAMOUNT,
    DIALOG_TOPUPGOJEK,
    DIALOG_PESANGORIDE,
    DIALOG_PESANGORIDECONF,
    DIALOG_PESANGOCAR,
    DIALOG_PESANGOCARPENUMPANG,
    DIALOG_PESANGOCARCONF,
    DIALOG_GOPAYWITHDRAW,

    DIALOG_GOFOOD_PESAN,
    DIALOG_PESAN_NASIGORENG,
    DIALOG_PESAN_BAKSO,
    DIALOG_PESAN_NASIPECEL,
    DIALOG_PESAN_BUBUR,
    DIALOG_PESAN_SUSU,
    DIALOG_PESAN_ESTEH,
    DIALOG_PESAN_KOPI,
    DIALOG_PESAN_CHOCOMATCH,
    DIALOG_PESAN_NOTES,

    DIALOG_ITEM_PICKUP,

    DIALOG_FAMSVAULT,
    DIALOG_FAMSVAULT_DEPOSIT,
    DIALOG_FAMSVAULT_WITHDRAW,
    DIALOG_FAMSRM_VAULT,
    DIALOG_FAMSRM_DEPOSIT,
    DIALOG_FAMSRM_WITHDRAW,
    DIALOG_FAMSVAULT_IN,
    DIALOG_FAMSVAULT_OUT,
    DIALOG_FAMSBRANKAS,
    DIALOG_FAMS_WEAPON,
    DIALOG_FAMILIESSETRANK,
    DIALOG_FAMILIESKICKMEMBER,
    DIALOG_RANK_SET_FAMILIES,

    DIALOG_VEHICLE_MENU,
    DIALOG_VHOLSTER,
    DIALOG_VHOLSTER_WITHDRAW,

    DIALOG_SPORTSTORE,

    /* Trans Dialog */
    DIALOG_TRANSORDER,
    DIALOG_TRANS_LOCKER,
    DIALOG_TRANS_DESK,
    DIALOG_TRANSSETRANK,
    DIALOG_TRANSKICKMEMBER,
    DIALOG_RANK_SET_TRANS,
    DIALOG_TRANS_INVITECONF,
    DIALOG_DEPOSIT_TRANS,
    DIALOG_WITHDRAW_TRANS,
    DIALOG_TRANS_GARAGE,
    DIALOG_TRANS_GARAGE_TAKEOUT,
    DIALOG_TRANS_GARAGE_BUY,
    DIALOG_TRANS_GARAGE_DELETE,

    DIALOG_TRANSVAULT,
    DIALOG_TRANSVAULT_DEPOSIT,
    DIALOG_TRANSVAULT_WITHDRAW,
    DIALOG_TRANSVAULT_IN,
    DIALOG_TRANSVAULT_OUT,

    /*Bagasi Dialog*/
    DIALOG_BAGASI,
    DIALOG_BAGASI_DEPOSIT,
    DIALOG_BAGASI_IN,
    DIALOG_BAGASI_WITHDRAW,
    DIALOG_BAGASI_OUT,

    /*Event Dialog*/
    DIALOG_EVENT_SETTING,
    DIALOG_EVENT_REDSKIN,
    DIALOG_EVENT_REDWEAP1,
    DIALOG_EVENT_REDWEAP2,
    DIALOG_EVENT_REDWEAP3,

    DIALOG_EVENT_BLUESKIN,
    DIALOG_EVENT_BLUEWEAP1,
    DIALOG_EVENT_BLUEWEAP2,
    DIALOG_EVENT_BLUEWEAP3,

    DIALOG_EVENT_WWID,
    DIALOG_EVENT_INTID,
    DIALOG_EVENT_TIME,
    DIALOG_EVENT_TARGETSCORE,
    DIALOG_EVENT_PARTICIPRIZE,
    DIALOG_EVENT_PRIZE,
    DIALOG_EVENT_HEALTH,
    DIALOG_EVENT_ARMOUR,

    /* Dialog Aridrop */
    DIALOG_AIRDROP,
    DIALOG_AIRDROPDISPLAY,
    DIALOG_AIRDROP_CONF,
    DIALOG_ADD_CONTACT,
    DIALOG_ADD_CONTACTNUMB,
    DIALOG_EDIT_CONTACTNAME,
    DIALOG_EDIT_CONTACTNUMBER,

    /* Dialog Garasi Umum */
    DIALOG_GARKOT_OUT,

    /* Dialog Gudang */
    DIALOG_GUDANG_BUY,
    DIALOG_GUDANG_OPTION,
    DIALOG_GUDANGVAULT,
    DIALOG_GUDANGVAULT_DEPOSIT,
    DIALOG_GUDANGVAULT_WITHDRAW,
    DIALOG_GUDANGVAULT_IN,
    DIALOG_GUDANGVAULT_OUT,

    /* Score Board Admin Menu */
    DIALOG_CLICKPLAYER,
    DIALOG_BANNEDTIME,
    DIALOG_BANNEDREASON,

    /* Dialog Asuransi */
    DIALOG_ASURANSI_LS,
    DIALOG_ASURANSI_LV,

    /* Dialog Fact Garage */
    DIALOG_FACTION_GARAGE_MENU,
    DIALOG_FACTION_GARAGE1,
    DIALOG_FACTION_GARAGE2,
    DIALOG_FACTION_GARAGE3,
    DIALOG_FACTION_GARAGE4,
    DIALOG_FACTION_GARAGE5,
    DIALOG_FACTION_GARAGE6,

    /* Dialog warung */
    DIALOG_WARUNG,
    DIALOG_WARUNG_ELEKTRONIK,
    DIALOG_BUY_NASIUDUK,
    DIALOG_BUY_AIRMINERAL,
    DIALOG_BUY_UMPAN,

    /* Petani Dialog */
    DIALOG_BUY_SEEDS,
    DIALOG_BIBIT_PADI,
    DIALOG_BIBIT_TEBU,
    DIALOG_BIBIT_CABE,

    /* Dialog House Keys */
    DIALOG_HKEYS,
    DIALOG_HKEYS_ADD,
    DIALOG_HKEYS_REMOVE,
    DIALOG_HOUSEGARAGE_OUT,
    DIALOG_HOUSEHELIPAD_OUT,
    DIALOG_HOUSE_BRANKAS,
    DIALOG_HOUSE_INVITE,
    DIALOG_HOUSE_INVITECONF,
    DIALOG_HOUSEVAULT,
    DIALOG_HOUSEVAULT_DEPOSIT,
    DIALOG_HOUSEVAULT_WITHDRAW,
    DIALOG_HOUSEVAULT_IN,
    DIALOG_HOUSEVAULT_OUT,
    DIALOG_WEAPON_CHEST,

    DIALOG_FIXMEACC,
    DIALOG_ADMIN_HELP,
    DIALOG_DYNAMIC_HELP,

    DIALOG_SWEEPER_START,
    DIALOG_DELIVERY_START,
    DIALOG_FORKLIFT_START,
    DIALOG_RECYCLER_START,
    DIALOG_TRASHMASTER_START,
    
    //
    DIALOG_MIXER,
    DIALOG_LIST_XO,
    DIALOG_ID_XO,
    DIALOG_INV_XO,
    DIALOG_UWR_XO,
    DIALOG_MONEY_XO,

    /* Dialog Clothes */
    DIALOG_CLOTHES,
    DIALOG_CLOTHES_DELETE,

    /* Atms Dialog */
    DIALOG_ATM_WITHDRAW,
    DIALOG_ATM_DEPOSIT,
    DIALOG_ATM_TRANSFER,
    DIALOG_ATM_TRANSFER1,

    /* Carsteal Dialog */
    DIALOG_CARSTEAL_SHOP,

    /*Whatsapp Dialog*/
    DIALOG_WHATSAPP_CHAT,
    DIALOG_WHATSAPP_CHAT_EMPTY,
    DIALOG_WHATSAPP_SEND,

    /*Yellow Pages*/
    DIALOG_YELLOW_PAGE,
    DIALOG_YELLOW_PAGE_MENU,
    DIALOG_YELLOW_PAGE_EMPTY,
    DIALOG_YELLOW_PAGE_SEND,
    DIALOG_YELLOW_CALL,

    /*Tweets Dialog*/
    DIALOG_TWITTER_SIGN,
    DIALOG_TWITTER_SIGNPASSWORD,
    DIALOG_TWITTER_LOGIN,
    DIALOG_TWITTER_LOGINPASSWORD,
    DIALOG_TWITTER_POST,
    DIALOG_TWITTER_POST_EMPTY,
    DIALOG_TWITTER_POST_SEND,

    /*Invoice Dialog*/
    DIALOG_INVOICE_NAME,
    DIALOG_INVOICE_COST,
    DIALOG_PAY_INVOICE,

    /*Player dialog*/
    DIALOG_PLAYER_MENU,
    DIALOG_PLAYER_DOKUMENT,

    DIALOG_SELECT_SPAWN,
    DIALOG_SELECT_SPAWNEXPIRED,

    DIALOG_SHOWROOM_MENU,
    DIALOG_SHOWROOM_SELL,
	DIALOG_LOGIN2,
    DIALOG_WEAPONSHOP,
    DIALOG_VIP_NAME,
    DIALOG_SELLFISH_ILEGAL,
    DIALOG_DISPLAYBANNED,
    DIALOG_RADIO_FREQ,
    DIALOG_VOICEMODE,
    DIALOG_VOICEKEYS,
    DIALOG_INVENTORY,
    DIALOG_CHANGE_PASSWORD,
    DIALOG_MYV_MENU,
    DIALOG_VEHICLE_DETAIL,
    DIALOG_UPGRADE,
    DIALOG_MODSHOP,
}
#include <matheval>     //By Sreyas-Sreelal
new AksesorisHat[87] =
{
    18953, 18954, 19554, 18960, 18974, 19067, 19068, 19069, 18891, 18892, 18893, 18894, 18895, 18896, 18897, 18898, 18899, 18900, 18908,
    18940, 18939, 18941, 18942, 18943, 19160, 18636, 18926, 18927, 18928, 18929, 18930, 18931, 18932, 18933, 18934, 18935, 18952, 18976, 18977,
    18979, 19077, 19517, 19161, 19162, 2054, 18961, 18964, 18965, 18966, 19558, 18955, 18956, 18957, 18958, 18959, 18638, 19520, 18947, 18948,
    19064, 19065, 19066, 18975, 19516, 18639, 18645, 18962, 19095, 19096, 19099, 19100, 19487, 19136, 19330, 19331, 19137, 19528, 19093,
    3002, 3000, 3100, 3105, 3104, 3101, 3102, 3103, 3002,
};

new BackpackToys[7] =
{
    11745, 19559, 1550, 3026, 371, 1210, 11738,
};

new GlassesToys[33] =
{
    19138, 19139, 19140, 19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018,
    19019, 19020, 19021, 19022, 19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035,
};

new AksesorisToys[38] =
{
    19515, 19142, 19621, 19623,
    19584, 19591, 19592, 2226, 19878,
    19038, 19036, 19163, 18919, 18912,
    18913, 18914, 18915, 18916, 18917,
    18918, 18911, 18920, 11704, 19037,
    19317, 19318, 336, 339, 325, 19625,
    19801, 19163, 19904, 2226, 2487, 2614,
    11712, 18635,
};

new ClothesSkinMale[177] =
{
    1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 58, 59, 60, 61,
    62, 66, 67, 68, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 86, 94, 95, 96, 97, 98, 100,
    101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116,
    117, 118, 120, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142,
    143, 144, 146, 147, 149, 153, 154, 156, 158, 159, 160, 161, 162, 168, 170, 173, 174,
    175, 176, 177, 179, 180, 182, 183, 184, 185, 186, 187, 200, 202, 203, 204, 206,
    208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 229, 230, 234, 235, 236, 239, 240,
    241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 269,
    270, 271, 272, 273, 289, 290, 291, 292, 293, 296, 297, 299
};

new ClothesSkinFemale[60] =
{
    9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 87,
    88, 89, 90, 91, 93, 129, 130, 131, 138, 139, 140, 145, 148, 151, 152, 157, 169, 178, 191,
    193, 192, 195, 196, 197, 198, 199, 205, 207, 211, 214, 216, 219, 224, 225, 226, 233, 237,
    251
};

stock const Float:
SpawnPelabuhan[][] =
{
    {2744.2397, -2449.5349, 13.6950, 271.9706},
    {2744.3171, -2457.2017, 13.6950, 268.3150},
    {2738.2039, -2454.5254, 13.6950, 269.7540}
};

stock const Float:
SpawnBandara[][] =
{
    {1694.7468, -2332.3428, 13.5469, 0.0377},
    {1698.4928, -2329.6863, 13.5469, 49.2119}
};

stock const Float:
SpawnVenturas[][] =
{
    {1677.6498, 1447.7649, 10.7757, 271.1616},
    {1674.8794, 1444.2119, 10.7890, 270.9187}
};
enum e_vehspec
{
    Model,
    BaggageWeight
};

new VehicleSpec[][e_vehspec] = {
    {400, 25},
    {401, 20},
    {402, 20},
    {404, 25},
    {405, 20},
    {407, 10},
    {409, 20},
    {410, 15},
    {411, 20},
    {412, 15},
    {413, 35},
    {414, 55},
    {415, 20},
    {416, 15},
    {417, 25},
    {418, 15},
    {419, 15},
    {420, 15},
    {421, 15},
    {422, 40},
    {423, 25},
    {424, 25},
    {426, 15},
    {427, 15},
    {428, 15},
    {429, 25},
    {430, 10},
    {434, 25},
    {435, 120},
    {436, 15},
    {438, 15},
    {439, 10},
    {440, 40},
    {442, 10},
    {445, 15},
    {446, 10},
    {450, 120},
    {451, 25},
    {452, 10},
    {453, 15},
    {454, 10},
    {455, 80},
    {456, 80},
    {457, 10},
    {458, 15},
    {459, 30},
    {466, 15},
    {467, 15},
    {470, 25},
    {472, 10},
    {473, 10},
    {474, 10},
    {475, 10},
    {477, 25},
    {478, 35},
    {479, 20},
    {480, 10},
    {482, 30},
    {483, 50},
    {484, 10},
    {485, 15},
    {487, 25},
    {488, 15},
    {489, 25},
    {490, 25},
    {491, 15},
    {492, 15},
    {493, 10},
    {494, 25},
    {495, 55},
    {496, 15},
    {497, 10},
    {498, 45},
    {499, 70},
    {500, 15},
    {502, 25},
    {503, 25},
    {504, 25},
    {505, 25},
    {506, 25},
    {507, 15},
    {508, 100},
    {511, 10},
    {512, 10},
    {513, 10},
    {516, 15},
    {517, 15},
    {518, 15},
    {519, 10},
    {525, 15},
    {526, 10},
    {527, 10},
    {528, 10},
    {529, 10},
    {533, 10},
    {534, 10},
    {535, 25},
    {536, 10},
    {539, 10},
    {540, 10},
    {541, 25},
    {542, 10},
    {543, 35},
    {544, 10},
    {545, 10},
    {546, 10},
    {547, 10},
    {548, 30},
    {549, 10},
    {550, 15},
    {551, 15},
    {552, 10},
    {554, 45},
    {555, 15},
    {558, 25},
    {559, 25},
    {560, 15},
    {561, 15},
    {562, 25},
    {563, 10},
    {565, 25},
    {566, 15},
    {567, 15},
    {568, 15},
    {571, 10},
    {572, 10},
    {573, 100},
    {575, 10},
    {576, 15},
    {578, 80},
    {579, 25},
    {580, 25},
    {582, 25},
    {583, 10},
    {585, 10},
    {587, 25},
    {588, 25},
    {589, 10},
    {591, 120},
    {595, 10},
    {596, 10},
    {597, 10},
    {598, 10},
    {599, 10},
    {600, 30},
    {601, 10},
    {602, 15},
    {603, 25},
    {604, 15},
    {605, 35},
    {609, 45}
};


new Strcmd1[1028];
new Strcmd[1028];
#include "SERVER/anti-cheater/car-troll-1.pwn"
#include "SERVER/anti-cheater/car-shot.pwn"
#include "SERVER/anti-cheater/car-spawn.pwn"
#include "SERVER/anti-cheater/FakeKill.pwn"
#include "SERVER/anti-cheater/Fly-Mode.pwn"
#include "SERVER/anti-cheater/SlideBug.pwn"
#include "SERVER/anti-cheater/ghost-afk.pwn"
#include "SERVER/anti-cheater/no-reload.pwn"
#include "SERVER/anti-cheater/rapid-fire.pwn"
#include "SERVER/utils/utils_defines.pwn"
#include "SERVER/utils/utils_vehiclevars.pwn"
#include "SERVER/utils/utils_enums.pwn"
#include "SERVER/utils/utils_variable.pwn"
#include "SERVER/utils/utils_colours.pwn"
#include "SERVER/utils/utils_textdraws.pwn"
#include "SERVER/voucher/voucher_functions.pwn"

#include "SERVER/systems/Pickup.pwn"
#include "SERVER/systems/JobVehicles.pwn"

/*Clothes System*/
#include "SERVER/toys/toys.pwn"
#include "SERVER/toys/toys_helmet.pwn"
#include "SERVER/clothes/clothes_functions.pwn"

#include "SERVER/fuel_system/fuel_functions.pwn"
#include "SERVER/PlayerStuff/player_slot.pwn"
#include "SERVER/PlayerStuff/asap.pwn"
#include "SERVER/PlayerStuff/BarQte.pwn"
#include "SERVER/PlayerStuff/randomsg.pwn"
#include "SERVER/Gym/gym_functions.pwn"

#include "SERVER/Dynamic/Dynamic_SpeedCam/core.pwn"
#include "SERVER/Dynamic/Dynamic_SpeedCam/funcs.pwn"
#include "SERVER/Dynamic/Dynamic_SpeedCam/cmd.pwn"
#include "SERVER/Dynamic/Dynamic_Button/button_functions.pwn"
#include "SERVER/Dynamic/Dynamic_Actor/ui_dynactor.pwn"
#include "SERVER/Dynamic/Dynamic_Warung/warung_functions.pwn"
#include "SERVER/Dynamic/Dynamic_Pasar/dyn_pasar.pwn"
#include "SERVER/Dynamic/Dynamic_Robbery/robbery_functions.pwn"
#include "SERVER/area/area.pwn"
#include "SERVER/Dynamic/Dynamic_Hunting/hunting_functions.pwn"
#include "SERVER/Dynamic/Dynamic_Ladang/ui_dynkanabis.pwn"
#include "SERVER/Dynamic/Dynamic_Ladang/kanabis_olah.pwn"
#include "SERVER/Dynamic/Dynamic_Object/object_funcs.pwn"
#include "SERVER/Dynamic/Dynamic_Workshop/Workshop.pwn"


#include "SERVER/Dynamic/Dynamic_GarasiKota/Header.pwn"
#include "SERVER/Dynamic/Dynamic_GarasiKota/Function.pwn"
#include "SERVER/Dynamic/Dynamic_GarasiKota/Commands.pwn"


#include "SERVER/Dynamic/Dynamic_Atm/ui_atm.pwn"
#include "SERVER/Dynamic/Dynamic_Garbage/dynamic_garbage.pwn"
#include "SERVER/Dynamic/Dynamic_Door/dynamic_doors.pwn"
#include "SERVER/Dynamic/Dynamic_Gate/dynamic_gatev2.pwn"
#include "SERVER/Dynamic/Dynamic_Gudang/gudang_functions.pwn"
#include "SERVER/Dynamic/Dynamic_Label/label_functions.pwn"

// Map Icon
#include "SERVER/Dynamic/Dynamic_IconMap/Header.pwn"
#include "SERVER/Dynamic/Dynamic_IconMap/Function.pwn"
#include "SERVER/Dynamic/Dynamic_IconMap/Commands.pwn"

#include "SERVER/Dynamic/Dynamic_Machine/dynamic_slot.pwn"
#include "SERVER/Dynamic/Dynamic_ObjectText/objecttext.pwn"
#include "SERVER/Dynamic/Dynamic_Uranium/uranium_funcs.pwn"
#include "SERVER/Dynamic/Dynamic_Billiard/poll.pwn"
// #include "SERVER/Dynamic/Dynamic_FactionStuffs/dynamic_factiongarage.inc"

#include "SERVER/jobs/farmer/petani_functions.pwn"

#include "SERVER/inventory/inventory_functions.pwn"
#include "SERVER/inventory/inventory_cmds.pwn"
#include "SERVER/inventory/inventory_drop.pwn"

#include "SERVER/voice/radiosystem.pwn"

// ------------------------------------------
#include "SERVER/user-interface/ui_emotes.pwn"
#include "SERVER/user-interface/ui_prop.pwn"
#include "SERVER/user-interface/ui_animations.pwn"
#include "SERVER/user-interface/notifikasi/Header.pwn"
#include "SERVER/user-interface/notifikasi/Function.pwn"
#include "SERVER/user-interface/notifikasi/box_func.pwn"
#include "SERVER/user-interface/notifikasi/notif.pwn"
#include "SERVER/user-interface/ui_shortkeys.pwn"
#include "SERVER/user-interface/ui_smoking.pwn"
#include "SERVER/user-interface/ui_announcement.pwn"
#include "SERVER/user-interface/ui_alert.pwn"
#include "SERVER/user-interface/ui_dmadm.pwn"
#include "SERVER/user-interface/ui_playerinfo.pwn"
#include "SERVER/user-interface/ui_koran.pwn"
#include "SERVER/user-interface/ui_locker.pwn"
#include "SERVER/Dynamic/Dynamic_Rusun/rusun_functions.pwn"
#include "SERVER/Dynamic/Dynamic_House/dyn_house.pwn"

#include "SERVER/PlayerStuff/PlayerAFK.pwn"
#include "SERVER/PlayerStuff/IdleAnimation.pwn"
#include "SERVER/PlayerStuff/NameTag.pwn"
#include "SERVER/PlayerStuff/player_login.pwn"
#include "SERVER/PlayerStuff/gamexo.pwn"
#include "SERVER/PlayerStuff/gameslotpoker.pwn"
/*PhoneSystem*/
#include "SERVER/FractionPlayer/FAMILIES/families_functions.pwn"
// #include "SERVER/FractionPlayer/FAMILIES/families_garage.inc"

#include "SERVER/jobs/miner/minerv2_functions.pwn"
#include "SERVER/jobs/lumberjack/lumber_functions.pwn"
#include "SERVER/jobs/bus/bus_funcs.pwn"
#include "SERVER/jobs/chicken factory/butcher_functions.pwn"
#include "SERVER/jobs/milker/milker_functions.pwn"
#include "SERVER/jobs/oilman/oilman_function.pwn"
#include "SERVER/jobs/fisherman/nelayan_funcs.pwn"
#include "SERVER/jobs/delivery/deliveryside_functions.pwn"
#include "SERVER/jobs/mowingjob/mowerside_functions.pwn"
#include "SERVER/jobs/sweeper/sweeper_functions.pwn"
#include "SERVER/jobs/forklift/forkliftside_functions.pwn"
#include "SERVER/jobs/tailor/tailorv2_functions.pwn"
#include "SERVER/jobs/tailor/tailor_forward.pwn"
#include "SERVER/jobs/hauling/kargo_func.pwn"
// #include "SERVER/jobs/RicycleJob/ricycle_functions.inc"
#include "SERVER/jobs/RicycleJob/recycler_functions.pwn"
#include "SERVER/jobs/electrican/electric_funcs.pwn"

#include "SERVER/jobs/mixer/callback.pwn"
// #include "SERVER/jobs/taxi/taxi_functions.inc"

#include "SERVER/Dynamic/Dynamic_Garbage/rongsokan_functions.pwn"
#include "SERVER/PlayerSmartphone/smartphone_contacts.pwn"
#include "SERVER/PlayerSmartphone/phone_funcs.pwn"

#include "SERVER/vehiclemod/modshop.pwn"
#include "SERVER/vehicles/vehicles_functions.pwn"
#include "SERVER/vehicles/vehicles_cmds.pwn"

#include "SERVER/weapons/weapons_functions.pwn"

#include "SERVER/Dynamic/Dynamic_Rental/dyn_rental.pwn"
#include "SERVER/Dynamic/Dynamic_Koran/Dynamic_Koran.pwn"

#include "SERVER/FractionPlayer/stuff_goodside.pwn"

#include "SERVER/toko-olahraga/business_olahraga.pwn"

/* Factions */
#include "SERVER/FractionPlayer/FactionMenu.pwn"
#include "SERVER/FractionPlayer/Pemerintah/pemerintah_functions.pwn"
#include "SERVER/FractionPlayer/Bengkel/bengkel_brankas.pwn"
#include "SERVER/FractionPlayer/Bengkel/bengkel_functions.pwn"
#include "SERVER/FractionPlayer/Pedagang/lounges_brankas.pwn"
#include "SERVER/FractionPlayer/Pedagang/lounges_vars.pwn"
#include "SERVER/FractionPlayer/Pedagang/lounges_functions.pwn"
#include "SERVER/FractionPlayer/EMS/ems_brankas.pwn"
#include "SERVER/FractionPlayer/EMS/ems.pwn"
// #include "SERVER/FractionPlayer/EMS/medic_funcs.pwn"
#include "SERVER/FractionPlayer/Police/sapd_functions.pwn"
// #include "SERVER/FractionPlayer/Police/sapd_taser.pwn"
// #include "SERVER/FractionPlayer/Police/sapd_spike.pwn"
#include "SERVER/FractionPlayer/trans/trans_functions.pwn"
#include "SERVER/FractionPlayer/trans/trans_stuffs.pwn"
// #include "SERVER/FractionPlayer/Gojek/cmds_gojek.pwn"
// #include "SERVER/FractionPlayer/Gojek/gojek_functions.pwn"

#include "SERVER/reports/systems_ask.pwn"
#include "SERVER/reports/systems_reports.pwn"
#include "SERVER/systems/systems_sp.pwn"
#include "SERVER/events/admin_events.inc"
#include "commands/cmds_hooks.pwn"
#include "SERVER/systems/systems_dialogs.pwn"
// #include "SERVER/systems/systems_spawn.inc" Dimatikan sementara
#include "SERVER/systems/systems_functions.pwn"
#include "SERVER/systems/systems_native.pwn"
// #include "SERVER/systems/systems_anticheat.inc"
#include "SERVER/systems/systems_anticheatv2.pwn"
// #include "SERVER/systems/antiremcs_dan.inc"

#include "SERVER/toll/toll_functions.pwn"

// #include "SERVER/PlayerSpawn/spawn_functions.inc" Dimatikan sementara
#include "SERVER/jobs/Disnaker/disnaker_functions.pwn"
#include "SERVER/jobs/porter/porter.pwn"

// #include "commands\boxing_funcs.inc"
#include "commands\management.pwn"
#include "commands\pengurus.pwn"
#include "commands\cmds_faction.pwn"
#include "commands\cmds_player.pwn"
#include "commands\cmds_admin.pwn"
#include "commands\earthquake.pwn"
#include "commands\NoClip.pwn"

#include "SERVER/carsteal/carsteal_functions.pwn"
#include "SERVER/PlayerStuff/player_toystd.pwn"
#include "SERVER/mapping/mapping.pwn"
#include "SERVER/mapping/mapping_server.pwn"
#include "SERVER\rampokwarung\callbacks.pwn"

#include "SERVER/PlayerStuff/notes.pwn"
#include "SERVER/PlayerStuff/Racing.pwn"

// #include "SERVER/events/xmas.inc"
//#include "SERVER/events/events.inc"

#include "SERVER/showroom/showroom_functions.pwn"
#include "SERVER/PlayerStuff/player_actions.pwn"
#include "SERVER/PlayerStuff/player_asuransi.pwn"
#include "SERVER/PlayerStuff/suit.pwn"
#include "SERVER/PlayerStuff/player_fishingactivity.pwn"
#include "SERVER/damages/damagelog_functions.pwn"

#include "SERVER/tags/core.pwn"
#include "SERVER/tags/cmd.pwn"
#include "SERVER/tags/funcs.pwn"
#include "SERVER/tags/impl.pwn"
// #include "commands\DISCORD.pwn"
#include "SERVER/showroom/showroom_functions2.pwn"
#include "SERVER/PlayerCrafting/crafting_functions.inc"
#include "SERVER/PlayerStuff/actionbar.pwn"
#include "SERVER/PlayerStuff/robatm.pwn"
#include "SERVER/PlayerStuff/hacking.pwn"
#include "SERVER/PlayerStuff/carwash.pwn"
// ----------------------------------------
#include "SERVER/streamer/streamer.pwn"
#include "SERVER/invoices/invoices.pwn"
#include "SERVER/blacklist/blacklist_functions.pwn"
#include "SERVER/timers/timer_task.pwn"
// #include "SERVER/timers/timer_ptask_anticheat.inc"
#include "SERVER/timers/timer_ptask_jail.pwn"
#include "SERVER/timers/timer_ptask_update.pwn"
#include "SERVER/playermarker/playermark.pwn"

forward OnGameModeInitEx();
forward OnGameModeExitEx();

main()
{

}

stock DatabaseConnection()
{
    g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
    if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
    {
        print("Croire Roleplay: Connection To MYSQL Failed! Server Shutting Down!");
        SendRconCommand("exit");
    }
    else
    {
        print("Croire Roleplay: Database successfully connected to MySQL.");
    }
    return 1;
}

public OnGameModeInit()
{
    JamFivEm = 7;
    LoadMap();
    DatabaseConnection();
    ShowNameTags(false);
    EnableTirePopping(0);
    CreateTextDraw();
    // StreamerConfig();
    BILLIARDS();
    //SetTimer("Pool_Timer", 21, 1);
    LoadMap2();
    LoadWarungArea();
    LoadArea();
    LoadGangZone();
    LoadServerPickup();
    LoadAreaWarung();
    ManualVehicleEngineAndLights();
    EnableStuntBonusForAll(0);
    AllowInteriorWeapons(1);
    DisableInteriorEnterExits();
    Hack_TextdrawInit();
    CreateLockerRoomTD();
    RobBank_Init();
    //porter
    CreateDynamicPickup(1275, 23, 2386.5820,563.6393,10.3691, 0, 0, -1, 30.00, -1, 0);
    CreateDynamic3DTextLabel("[Y] "WHITE"akses locker porter", COLOR_LOGS, 2386.5820,563.6393,10.3691+0.65, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 10.0, -1, 0);

    Porter_StartArea = CreateDynamicSphere(2388.9077,586.0323,7.9351, 3.25, 0, 0, -1);

    for(new x; x < sizeof(PorterDropCoord); x++)
    {
        CreateDynamic3DTextLabel("[Y] "WHITE"letakkan barang", COLOR_LOGS, PorterDropCoord[x][0], PorterDropCoord[x][1], PorterDropCoord[x][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 10.0, -1, 0);
    }

    Create3DTextLabel("Crashing The Door\nGunakan {FFFF00}'/plantbom' {FFFFFF}untuk memasang bom",COLOR_WHITE, 1435.2909,-980.8229,983.6462, 20, 0, 1);
    LimitPlayerMarkerRadius(15.0);
    		//Carwash Fix by Ary
	entrancegate = CreateDynamicObject(17951,1911.21130371,-1780.68151855,14.15972233,0.00000000,0.00000000,90.00000000);
	exitgate = CreateDynamicObject(17951,1911.21130371,-1771.97814941,14.15972233,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(1250,1908.84997559,-1783.68945312,13.40625000,0.00000000,0.00000000,90.00000000);
	CreateDynamicPickup(1239, 1, 1911.1886,-1784.2952,13.5, -1);
	CreateDynamicMapIcon(1911.1719,-1784.3016,13.3828, 36, -1, -1, -1, -1, 150.0);//Carwash
 	entrancetext = Create3DTextLabel("{FFFFFF}Tidak ada yang menggunakan pencucian mobil sekarang.\n{FF8CC0}Harga: $15.00 cmd: /carwash",-1,1911.1886,-1784.2952,14.5,50,0,1);

    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    new hour;
	gettime(hour);
	SetWorldTime(hour);
//    SetWorldTime(WorldTime);
//    SetWeather(WorldWeather);
    //SetTimer("HideNameTag",500,1);
    SetGameModeText(sprintf("%s", TEXT_GAMEMODE));
    SendRconCommand(sprintf("weburl %s", TEXT_WEBURL));
    SendRconCommand(sprintf("language %s", TEXT_LANGUAGE));
    // SendRconCommand("hostname Croire Roleplay | SA-MP Indonesia");
    SendRconCommand("mapname San Andreas");
    BlockGarages(.text = "Tutup");
//    SetTimer("CheckGhostVehicle", 3000, true); // Cek setiap 3 detik
    /* Load From Database */
    mysql_tquery(g_SQL, "SELECT * FROM `brankas_ems`", "LoadBrankasEms");
    mysql_tquery(g_SQL, "SELECT * FROM `brankas_bengkel`", "LoadBrankasBengkel");
    mysql_tquery(g_SQL, "SELECT * FROM `brankas_lounges`", "LoadBrankasLounges");
    mysql_tquery(g_SQL, "SELECT * FROM `buttons`", "LoadButtons");
    mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors");
    mysql_tquery(g_SQL, "SELECT * FROM `families`", "Families_Load");
    // mysql_tquery(g_SQL, "SELECT * FROM `families_garage`", "LoadFamiliesGarkot");
    mysql_tquery(g_SQL, "SELECT * FROM `house`", "LoadRumah");
    mysql_tquery(g_SQL, "SELECT * FROM `gate`", "LoadGate");
    mysql_tquery(g_SQL, "SELECT * FROM `actors`", "Actor_Load");
    mysql_tquery(g_SQL, "SELECT * FROM `bike_rentals`", "Rental_Load");
    mysql_tquery(g_SQL, "SELECT * FROM `public_garage`", "LoadPublicGarage");
    mysql_tquery(g_SQL, "SELECT * FROM `gudang`", "LoadGudang");
    mysql_tquery(g_SQL, "SELECT * FROM `warung`", "LoadWarung");
    mysql_tquery(g_SQL, "SELECT * FROM `pasar`", "LoadPasar");
    mysql_tquery(g_SQL, "SELECT * FROM `robbery`", "LoadDynamicRobbery");
    mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM");
    mysql_tquery(g_SQL, "SELECT * FROM `trash`", "LoadTrash");
    mysql_tquery(g_SQL, "SELECT * FROM `stuffs`", "LoadBrankasGoodside");
    mysql_tquery(g_SQL, "SELECT * FROM `ladang`", "LoadKanabis");
    mysql_tquery(g_SQL, "SELECT * FROM `icons`", "Icons_Load", "");
    mysql_tquery(g_SQL, "SELECT * FROM `label_fivem`", "LoadLabel");
    mysql_tquery(g_SQL, "SELECT * FROM `dynamic_rusun`", "Rusun_Load");
    mysql_tquery(g_SQL, "SELECT * FROM `hunting`", "LoadDeer");
    mysql_tquery(g_SQL, "SELECT * FROM `weeds`", "Weed_Load");
    mysql_tquery(g_SQL, "SELECT * FROM `voucher`", "LoadVoucher");
    mysql_tquery(g_SQL, "SELECT * FROM `objects`", "LoadDynamicObject");
    mysql_tquery(g_SQL, "SELECT * FROM `slotmachine`", "LoadSlotMachine");
    mysql_tquery(g_SQL, "SELECT * FROM `objecttext`", "ObjectText_Load");
    mysql_tquery(g_SQL, "SELECT * FROM `koran`", "Loadkoran");
    mysql_tquery(g_SQL, "SELECT * FROM `uranium`", "Load_Uranium");
    mysql_tquery(g_SQL, "SELECT * FROM `tags` ORDER BY `tagId` ASC LIMIT "#MAX_DYNAMIC_TAGS";", "Tags_Load");
    
    CarDealerCP = CreateDynamicCP(397.3322,-1329.0055,14.8170, 1.5, 0, 0, -1, 15.0, -1, 0);

    for (new i; i < sizeof(ColorList); i++)
    {
        format(color_string, sizeof(color_string), "%s{%06x}%03d %s", color_string, ColorList[i] >>> 8, i, ((i + 1) % 16 == 0) ? ("\n") : (""));
    }

    for (new i; i < sizeof(FontNames); i++)
    {
        format(object_font, sizeof(object_font), "%s%s\n", object_font, FontNames[i]);
    }
//    new strings[256];
//   	format(strings, sizeof(strings), "[Y]{ffffff}> To use static bicycle.");
//	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 659.7963, -1863.7405, 5.4609, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

//	format(strings, sizeof(strings), "[Y]{ffffff}> Untuk Yoga atau meregangkan tubuh.");
//	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 659.8690,-1869.7894,5.5537, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

//	format(strings, sizeof(strings), "[Y]{ffffff}> Untuk Yoga atau meregangkan tubuh.");
//	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 654.5159,-1869.6046,5.5537, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

//	format(strings, sizeof(strings), "[Y]{ffffff}> Untuk Yoga atau meregangkan tubuh.");
//	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 664.3617,-1865.5663,5.4609, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

    for (new i = 0; i < sizeof(BarrierInfo); i ++)
    {
        new Float:X = BarrierInfo[i][brPos_X],
            Float:Y = BarrierInfo[i][brPos_Y];

        ShiftCords(0, X, Y, BarrierInfo[i][brPos_A] + 90.0, 3.5);
        BarrierInfo[i][brArea] = CreateDynamicSphere(BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z], 5.0);
        CreateDynamicObject(966, BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z], 0.00000000, 0.00000000, BarrierInfo[i][brPos_A]);
        if (!BarrierInfo[i][brOpen])
        {
            gBarrier[i] = CreateDynamicObject(968, BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z] + 0.8, 0.00000000, 90.00000000, BarrierInfo[i][brPos_A] + 180);
            MoveObject(gBarrier[i], BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z] + 0.7, BARRIER_SPEED, 0.0, 0.0, BarrierInfo[i][brPos_A] + 180);
            MoveObject(gBarrier[i], BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z] + 0.75, BARRIER_SPEED, 0.0, 90.0, BarrierInfo[i][brPos_A] + 180);
        }
        else gBarrier[i] = CreateDynamicObject(968, BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z] + 0.8, 0.00000000, 20.00000000, BarrierInfo[i][brPos_A] + 180);
    }
    g_sBoxDoorOpened = false;
    sBoxDoorSensor = CreateDynamicSphere(442.4587,-1807.7310,6.1309, 4.25, 0, 0, -1);
    sBoxDoor[0] = CreateDynamicObject(3089, 442.841583, -1809.264404, 6.447765, 0.000000, 0.000000, 90.000000, 0, 0, -1, 200.0, 200.0); // kanan tutup
    SetDynamicObjectMaterial(sBoxDoor[0], 0, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
    SetDynamicObjectMaterial(sBoxDoor[0], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(sBoxDoor[0], 2, 10765, "airportgnd_sfse", "white", 0x00000000);
    sBoxDoor[1] = CreateDynamicObject(3089, 442.841583, -1806.294311, 6.447765, 0.000000, 0.000000, 270.000000, 0, 0, -1, 200.0, 200.0); // kiri tutup
    SetDynamicObjectMaterial(sBoxDoor[1], 0, 14581, "ab_mafiasuitea", "barbersmir1", 0x00000000);
    SetDynamicObjectMaterial(sBoxDoor[1], 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
    SetDynamicObjectMaterial(sBoxDoor[1], 2, 10765, "airportgnd_sfse", "white", 0x00000000);
    
    g_PutriDeliDoorOpened = false;
    PutriDeliDoorSensor = CreateDynamicSphere(659.8900,-1862.6075,6.5551, 4.25, 0, 0, -1);
    PutriDeliDoor[0] = CreateDynamicObject(1532, 661.260864, -1863.011108, 5.489810, 0.000000, 0.000000, 180.000000, 0, 0, -1, 200.00, 200.00); // kiri closed
    SetDynamicObjectMaterial(PutriDeliDoor[0], 0, 19297, "matlights", "invisible", 0x00000000);
    SetDynamicObjectMaterial(PutriDeliDoor[0], 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
    SetDynamicObjectMaterial(PutriDeliDoor[0], 2, 18996, "mattextures", "sampblack", 0x00000000);
    PutriDeliDoor[1] = CreateDynamicObject(1532, 658.260681, -1863.011108, 5.490809, 0.000000, 0.000000, 720.000000, 0, 0, -1, 200.00, 200.00); // kanana close
    SetDynamicObjectMaterial(PutriDeliDoor[1], 0, 19297, "matlights", "invisible", 0x00000000);
    SetDynamicObjectMaterial(PutriDeliDoor[1], 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
    SetDynamicObjectMaterial(PutriDeliDoor[1], 2, 18996, "mattextures", "sampblack", 0x00000000);

    g_SriMersingFDoorOpened = false;
    SriMersingFDoorSensor = CreateDynamicSphere(-310.8187,1303.3573,54.7098, 4.25, 0, 0, -1);
    SriMersingDoor[0] = CreateDynamicObject(1569, -312.357177, 1302.924804, 53.688583, 0.000000, 0.000082, 0.000000, 0, 0, -1, 200.00, 200.00); // dkanan
    SriMersingDoor[1] = CreateDynamicObject(1569, -309.357238, 1302.944824, 53.688583, 0.000000, -0.000082, 179.999496, 0, 0, -1, 200.00, 200.00); // dkiri

    g_SriMersingBDoorOpened = false;
    SriMersingBDoorSensor = CreateDynamicSphere(-305.6303,1285.0519,54.5486, 4.25, 0, 0, -1);
    SriMersingDoor[2] = CreateDynamicObject(1569, -307.222137, 1285.447509, 53.548583, 0.000000, 0.000000, 0.000000, 0, 0, -1, 200.00, 200.00); // bkanan
    SriMersingDoor[3] = CreateDynamicObject(1569, -304.222167, 1285.466064, 53.548587, 0.000000, 0.000000, 180.000000, 0, 0, -1, 200.00, 200.00); // bkiri

    /* Mprice Stuffs*/
    OldTembagaPrice = TembagaPrice;
    OldBesiPrice = BesiPrice;
    OldEmasPrice = EmasPrice;
    OldBerlianPrice = BerlianPrice;
    OldMaterialPrice = MaterialPrice;
    OldAlumuniumPrice = AlumuniumPrice;
    OldKaretPrice = KaretPrice;
    OldKacaPrice = KacaPrice;
    OldBajaPrice = BajaPrice;
    OldAyamKemasPrice = AyamKemasPrice;
    OldSusuOlahPrice = SusuOlahPrice;
    OldPakaianPrice = PakaianPrice;
    OldKayuKemasPrice = KayuKemasPrice;
    OldGasPrice = GasPrice;

    SetTimer("WeatherRotator", 1800000, true);
    CallLocalFunction("OnGameModeInitEx", "");

    OpenVote = 0;
    VoteYes = 0;
    VoteNo = 0;
    VoteTime = 0;
    VoteText[0] = EOS;
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == RobBank[BankKeypad])
    {
        ShowKey(playerid, "Untuk Melakukan Peretasan", "Y");
    }
    if(areaid == RobBank[BankArea][0])
    {
        ShowKey(playerid, "Untuk Mengambil Emas", "Y");
    }
    if(areaid == RobBank[BankArea][1])
    {
        ShowKey(playerid, "Untuk Mengambil Emas", "Y");
    }
    if(areaid == RobBank[BankArea][2])
    {
        ShowKey(playerid, "Untuk Mengambil Emas", "Y");
    }
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        for (new i = 0; i < sizeof(BarrierInfo); i++)
        {
            if (areaid == BarrierInfo[i][brArea])
            {
                for (new txd = 0; txd < 26; txd++)
                {
                    PlayerTextDrawShow(playerid, Textdraw_Toll[playerid][txd]);
                }
                SelectTextDraw(playerid, X11_LIGHTBLUE);
				PlayStream(playerid, "https://f.top4top.io/m_3355hq5p41.mp3", BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z]);
            }
        }
    }
    if(areaid == sBoxDoorSensor)
	{
		if(!g_sBoxDoorOpened)
		{
			g_sBoxDoorOpened = true;
			MoveDynamicObject(sBoxDoor[0], 442.841583, -1810.735839, 6.447765, 0.6, 0.000000, 0.000000, 90.000000);
			MoveDynamicObject(sBoxDoor[1], 442.841583, -1804.843383, 6.447765, 0.6, 0.000000, 0.000000, 270.000000);
		}
	}
	if(areaid == PutriDeliDoorSensor)
	{
		if(!g_PutriDeliDoorOpened)
		{
			g_PutriDeliDoorOpened = true;
			MoveDynamicObject(PutriDeliDoor[0], 662.661315, -1863.011108, 5.489810, 0.6, 0.000000, 0.000000, 180.000000);
			MoveDynamicObject(PutriDeliDoor[1], 656.860473, -1863.011108, 5.490809, 0.6, 0.000000, 0.000000, 720.000000);
		}
	}

	if(areaid == SriMersingFDoorSensor)
	{
		if(!g_SriMersingFDoorOpened)
		{
			g_SriMersingFDoorOpened = true;
			MoveDynamicObject(SriMersingDoor[0], -313.817260, 1302.924804, 53.688583, 0.6, 0.000000, 0.000082, 0.000000);
			MoveDynamicObject(SriMersingDoor[1], -307.887115, 1302.944824, 53.688583, 0.6, 0.000000, -0.000082, 179.999496);
		}
	}

	if(areaid == SriMersingBDoorSensor)
	{
		if(!g_SriMersingBDoorOpened)
		{
			g_SriMersingBDoorOpened = true;
			MoveDynamicObject(SriMersingDoor[2], -308.702056, 1285.447509, 53.548583, 0.6, 0.000000, 0.000000, 0.000000);
			MoveDynamicObject(SriMersingDoor[3], -302.752136, 1285.466064, 53.548587, 0.6, 0.000000, 0.000000, 180.000000);
		}
	}
    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for (new txd = 0; txd < 26; txd++)
    {
        PlayerTextDrawHide(playerid, Textdraw_Toll[playerid][txd]);
    }
   	if(areaid == sBoxDoorSensor)
	{
		if(g_sBoxDoorOpened)
		{
			g_sBoxDoorOpened = false;
			MoveDynamicObject(sBoxDoor[0], 442.841583, -1809.264404, 6.447765, 0.6, 0.000000, 0.000000, 90.000000);
			MoveDynamicObject(sBoxDoor[1], 442.841583, -1806.294311, 6.447765, 0.6, 0.000000, 0.000000, 270.000000);
		}
	}
 	if(areaid == RobBank[BankKeypad])
    {
        HideShortKey(playerid);
    }
    if(areaid == RobBank[BankArea][0])
    {
        HideShortKey(playerid);
    }
    if(areaid == RobBank[BankArea][1])
    {
        HideShortKey(playerid);
    }
    if(areaid == RobBank[BankArea][2])
    {
        HideShortKey(playerid);
    }
    if(areaid == PutriDeliDoorSensor)
	{
		if(g_PutriDeliDoorOpened)
		{
			g_PutriDeliDoorOpened = false;
			MoveDynamicObject(PutriDeliDoor[0], 661.260864, -1863.011108, 5.489810, 0.6, 0.000000, 0.000000, 180.000000);
			MoveDynamicObject(PutriDeliDoor[1], 658.260681, -1863.011108, 5.490809, 0.6, 0.000000, 0.000000, 720.000000);
		}
	}

	if(areaid == SriMersingFDoorSensor)
	{
		if(g_SriMersingFDoorOpened)
		{
			g_SriMersingFDoorOpened = false;
			MoveDynamicObject(SriMersingDoor[0], -312.357177, 1302.924804, 53.688583, 0.6, 0.000000, 0.000082, 0.000000);
			MoveDynamicObject(SriMersingDoor[1], -309.357238, 1302.944824, 53.688583, 0.6, 0.000000, -0.000082, 179.999496);
		}
	}

	if(areaid == SriMersingBDoorSensor)
	{
		if(g_SriMersingBDoorOpened)
		{
			g_SriMersingBDoorOpened = false;
			MoveDynamicObject(SriMersingDoor[2], -307.222137, 1285.447509, 53.548583, 0.6, 0.000000, 0.000000, 0.000000);
			MoveDynamicObject(SriMersingDoor[3], -304.222167, 1285.466064, 53.548587, 0.6, 0.000000, 0.000000, 180.000000);
		}
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	#if defined DEBUG_MODE
    printf("[debug] OnPlayerInteriorChange(PID : %d New-Int : %d Old-Int : %d)", playerid, newinteriorid, oldinteriorid);
	#endif

    CancelEdit(playerid);

    foreach(new i : Player) if (AccountData[i][pSpec] != INVALID_PLAYER_ID && AccountData[i][pSpec] == playerid)
    {
        SetPlayerInterior(i, GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
    }

    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if (!AccountData[playerid][IsLoggedIn])
    {
        GameTextForPlayer(playerid, "~r~Stay in your world bastard!", 2000, 4);
        SendClientMessageEx(playerid, X11_RED, "[AntiCheat]:"LIGHTGREY" Anda ditendang karena diduga Fake Spawn!");
        KickEx(playerid);
    }
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    if (SQL_IsCharacterLogged(playerid) && AccountData[playerid][pAdmin] > 0)
    {
        if (!IsPlayerConnected(clickedplayerid)) return 0;
        if (clickedplayerid == playerid) return 0;

        new title[127];
        format(title, sizeof(title), ""NEXODUS"Croire Roleplay "WHITE"- %s(%d)", ReturnName(clickedplayerid), clickedplayerid);
        ShowPlayerDialog(playerid, DIALOG_CLICKPLAYER, DIALOG_STYLE_LIST, title,
                         ""NEXODUS"Menu Admin\n\
		\nSpectator Pemain\
		\n"GRAY"Tarik Pemain\
		\nTeleport Ke Pemain\
		\n"GRAY"Banned Pemain\
		\nKick Pemain\
		\n"GRAY"Stats Pemain", "Pilih", "Batal");
        ClickPlayerID[playerid] = clickedplayerid;
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetCameraData(playerid);

    if (!AccountData[playerid][IsLoggedIn])
    {
        new query[268];
        mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `playerucp` WHERE `ucp` = '%s' LIMIT 1", AccountData[playerid][pUCP]);
        mysql_pquery(g_SQL, query, "CheckPlayerUCP", "id", playerid, g_RaceCheck[playerid]);
        SetPlayerColor(playerid, X11_GRAY);
    }
    return 1;
}

public OnGameModeExit()
{
	#if defined DEBUG_MODE
    printf("[debug] OnGameModeExit()");
	#endif

    SaveAll();

    foreach (new playerid : Player)
        TerminateConnection(playerid);

    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVehicleID(i) == GetPlayerVehicleID(usingcarwash))
		{
			DestroyPlayerObject(i, water6);
			DestroyPlayerObject(i, water7);
			DestroyPlayerObject(i, water8);
			DestroyPlayerObject(i, water9);
			DestroyPlayerObject(i, water5);
			DestroyPlayerObject(i, water6);
			DestroyPlayerObject(i, water7);
			TogglePlayerControllable(i, 1);
			SetCameraBehindPlayer(i);
		}
	}
    CallLocalFunction("OnGameModeExitEx", "");
    mysql_close(g_SQL);
    return 1;
}

forward OnPlayerCarJacking(playerid);
public OnPlayerCarJacking(playerid)
{
    new Float:playerPos[3];
    GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
    AccountData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

    SetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2] + 9.0);
    TogglePlayerControllable(playerid, false);
    GameTextForPlayer(playerid, "No Jacking!", 5500, 4);
    SetPlayerVirtualWorld(playerid, (playerid + 1));
    SetTimerEx("OnPlayerCarJackingUpdate", 5500, false, "d", playerid);
    return 1;
}

forward OnPlayerCarJackingUpdate(playerid);
public OnPlayerCarJackingUpdate(playerid)
{
    TogglePlayerControllable(playerid, true);
    SetPlayerVirtualWorld(playerid, AccountData[playerid][pWorld]);
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (!ispassenger)
    {
        new driverid = GetVehicleDriver(vehicleid);
        if (driverid != INVALID_PLAYER_ID && IsPlayerInVehicle(driverid, vehicleid) && !IsVehicleEmpty(vehicleid) && IsPlayerChangeSeat[playerid] == false)
        {
            SetTimerEx("OnPlayerCarJacking", 250, false, "d", playerid);
        }
        new vehicle_near = GetNearestVehicle(playerid);
        if ((vehicle_near = Vehicle_ReturnID(vehicleid)) != RETURN_INVALID_VEHICLE_ID)
        {
            if (PlayerVehicle[vehicle_near][pVehFaction] == FACTION_POLISI)
            {
                if (AccountData[playerid][pFaction] != FACTION_POLISI && AccountData[playerid][pFaction] != FACTION_BENGKEL)
                {
                    RemovePlayerFromVehicle(playerid);
                    new Float:slx, Float:sly, Float:slz;
                    GetPlayerPos(playerid, slx, sly, slz);
                    SetPlayerPos(playerid, slx, sly, slz);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini milik faction Polisi!");
                }
            }
            else if (PlayerVehicle[vehicle_near][pVehFaction] == FACTION_PEMERINTAH)
            {
                if (AccountData[playerid][pFaction] != FACTION_PEMERINTAH && AccountData[playerid][pFaction] != FACTION_BENGKEL)
                {
                    RemovePlayerFromVehicle(playerid);
                    new Float:slx, Float:sly, Float:slz;
                    GetPlayerPos(playerid, slx, sly, slz);
                    SetPlayerPos(playerid, slx, sly, slz);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini milik faction Pemerintah!");
                }
            }
            else if (PlayerVehicle[vehicle_near][pVehFaction] == FACTION_EMS)
            {
                if (AccountData[playerid][pFaction] != FACTION_EMS && AccountData[playerid][pFaction] != FACTION_BENGKEL)
                {
                    RemovePlayerFromVehicle(playerid);
                    new Float:slx, Float:sly, Float:slz;
                    GetPlayerPos(playerid, slx, sly, slz);
                    SetPlayerPos(playerid, slx, sly, slz);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini milik faction EMS!");
                }
            }
            else if (PlayerVehicle[vehicle_near][pVehFaction] == FACTION_TRANS)
            {
                if (AccountData[playerid][pFaction] != FACTION_TRANS && AccountData[playerid][pFaction] != FACTION_BENGKEL && AccountData[playerid][pFaction] != FACTION_POLISI)
                {
                    RemovePlayerFromVehicle(playerid);
                    new Float:slx, Float:sly, Float:slz;
                    GetPlayerPos(playerid, slx, sly, slz);
                    SetPlayerPos(playerid, slx, sly, slz);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini milik faction Transportasi!");
                }
            }
            else if (PlayerVehicle[vehicle_near][pVehFaction] == FACTION_BENGKEL)
            {
                if (AccountData[playerid][pFaction] != FACTION_POLISI && AccountData[playerid][pFaction] != FACTION_BENGKEL)
                {
                    RemovePlayerFromVehicle(playerid);
                    new Float:slx, Float:sly, Float:slz;
                    GetPlayerPos(playerid, slx, sly, slz);
                    SetPlayerPos(playerid, slx, sly, slz);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini milik faction Bengkel!");
                }
            }
            else if (PlayerVehicle[vehicle_near][pVehFaction] == FACTION_PEDAGANG)
            {
                if (AccountData[playerid][pFaction] != FACTION_PEDAGANG && AccountData[playerid][pFaction] != FACTION_BENGKEL)
                {
                    RemovePlayerFromVehicle(playerid);
                    new Float:slx, Float:sly, Float:slz;
                    GetPlayerPos(playerid, slx, sly, slz);
                    SetPlayerPos(playerid, slx, sly, slz);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini milik faction Pedagang!");
                }
            }
        }
    }
    return 1;
}

forward TrackSuspect(suspectid, policeid);
public TrackSuspect(suspectid, policeid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(suspectid, x, y, z);

    SetPlayerRaceCheckpoint(policeid, 1, x, y, z, 0.0, 0.0, 0.0, 5.0);
    Info(policeid, "Tracking Suspect Updated!");
    pMapCP[policeid] = true;
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if (!AccountData[playerid][IsLoggedIn] || !AccountData[playerid][pSpawned])
        return 0;

    if (AccountData[playerid][pAdmin] > 0 && AccountData[playerid][pAdminDuty])
    {
        if (strlen(text) > 64)
        {
            SendNearbyMessage(playerid, 15.0, -1, "Admin "RED"%s"WHITE": (( %.64s...", AccountData[playerid][pAdminname], text);
            SendNearbyMessage(playerid, 15.0, -1, "...%s ))", text[64]);
        }
        else
        {
            SendNearbyMessage(playerid, 15.0, -1, "Admin "RED"%s"WHITE": (( %s ))", AccountData[playerid][pAdminname], text);
        }
    }
    return 0;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result != -1 && !AccountData[playerid][IsLoggedIn])
    {
        SendClientMessage(playerid, -1, ""RED"[AntiCheat]"ARWIN1" Anda ditendang dari server karena menggunakan CMD dalam keadaan tidak login!");
        return KickEx(playerid);
    }

    if (result == -1)
    {
        if (AccountData[playerid][pStyleNotif] == 1) //TD
        {
            ShowTDN(playerid, NOTIFICATION_ERROR, sprintf("Perintah ~y~'/%s'~w~ tidak diketahui, ~y~'/help'~w~ untuk info lanjut!", cmd));
        }
        else
        {
            ShowTDN(playerid, NOTIFICATION_ERROR, sprintf("Perintah "YELLOW"'/%s'"WHITE" tidak diketahui, "YELLOW"'/help'"WHITE" untuk info lanjut!", cmd));
        }
        return 0;
    }
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    return 1;
}

public OnPlayerConnect(playerid)
{
    g_RaceCheck[playerid] ++;
    takingclothes[playerid] = 0;
    AccountData[playerid][pMainXo] = 0;
    AccountData[playerid][pNambangBatu] = 0;
    ResetVariables(playerid);
    AccountData[playerid][pBetulPw] = 0;
    AccountData[playerid][pBetulNama] = 0;
    AccountData[playerid][pBetulAge] = 0;
    AccountData[playerid][pBetulHeight] = 0;
    AccountData[playerid][pBetulWeight] = 0;
    AccountData[playerid][pBetulGender] = 0;
    AccountData[playerid][pBetulAge] = 0;
    AccountData[playerid][pBetulOrigin] = 0;
    CompassVisible[playerid] = true;
    SlotMachineStarted[playerid]=0;
    SlotTimert[playerid]=0;
    SlotRunde[playerid]=0;
    DeletePVar(playerid, "ShowWhatsapp");
	format(AccountData[playerid][pEditingStr], 12, "");
    ReturnIP(playerid);
    rechiPhoneCall[playerid] = "";
	rrechnungPhoneCall[playerid] = 0;
	zahPhonelCall[playerid] = "";
	azahPhonelCall[playerid] = "";
    CreatePlayerTextDraws(playerid);
    JoueurAppuieJump[playerid] = 0;
    g_WarningCount[playerid] = 0;
    AimbotWarnings[playerid] = 0;
    SetPlayerWorldBounds(playerid, 3000.0, -3000.0, 3000.0, -3000.0); // Top, Bottom, Left, Right
    jobs_mixer_create_ptd(playerid);
    Player_ToggleTelportAntiCheat(playerid, false);
    OnLoadMixerProperty(playerid);
    Player_ToggleAntiHealthHack(playerid, false);
    Player_ToggleDisableAntiCheat(playerid, false);
    LoadRemoveBuilding(playerid);
    EnableAntiCheatForPlayer(playerid, 11, true);
    EnableAntiCheatForPlayer(playerid, 19, true);
    EnableAntiCheatForPlayer(playerid, 4, true);
    PlayerSpawn[playerid] = 0;
    CompassVisible[playerid] = false;
    CompassTimer[playerid] = 0;
    LastAngle[playerid] = 0.0;
//    PlayAudioStreamForPlayer(playerid, "https://i.top4top.io/m_3353w2sm71.mp3", 0.0, 0.0, 0.0, 50.0, 0);
    RemoveBuildingForPlayer(playerid, 6295, 154.21094, -1950.1953, 26.40625, 15.0);
    if (g_RestartServer || g_AsuransiTime)
    {
        TextDrawShowForPlayer(playerid, gServerTextdraws[0]);
    }
    if (g_AsuransiTime)
    {
        for (new txd = 0; txd < 11; txd++)
        {
            TextDrawShowForPlayer(playerid, Textdraw_Asuransi[txd]);
        }
    }

    GetPlayerName(playerid, AccountData[playerid][pUCP], MAX_PLAYER_NAME + 1);

    if (AccountData[playerid][pHead] < 0) return AccountData[playerid][pHead] = 20;
    if (AccountData[playerid][pPerut] < 0) return AccountData[playerid][pPerut] = 20;
    if (AccountData[playerid][pRFoot] < 0) return AccountData[playerid][pRFoot] = 20;
    if (AccountData[playerid][pLFoot] < 0) return AccountData[playerid][pLFoot] = 20;
    if (AccountData[playerid][pLHand] < 0) return AccountData[playerid][pLHand] = 20;
    if (AccountData[playerid][pRHand] < 0) return AccountData[playerid][pRHand] = 20;
    //rock textures
    rock1[playerid] = CreatePlayerObject(playerid, 18751, 937.01, -2220.65, -1.94,   0.00, 0.00, 305.44);
   	SetPlayerObjectMaterial(playerid, rock1[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock1[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock1[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock1[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
    rock2[playerid] = CreatePlayerObject(playerid, 18751, 958.02, -2280.09, 7.80,   0.00, 0.00, 305.44);
   	SetPlayerObjectMaterial(playerid, rock2[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock2[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock2[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock2[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock3[playerid] = CreatePlayerObject(playerid, 18751, 766.61, -2239.62, 3.26,   0.00, 0.00, 62.09);
   	SetPlayerObjectMaterial(playerid, rock3[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock3[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock3[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock3[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock4[playerid] = CreatePlayerObject(playerid, 18751, 811.93, -2207.26, 3.86,   0.00, 0.00, 18.43);
	SetPlayerObjectMaterial(playerid, rock4[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock4[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock4[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock4[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock5[playerid] = CreatePlayerObject(playerid, 18751, 721.91, -2236.05, 0.56,   0.00, 0.00, 86.82);
	SetPlayerObjectMaterial(playerid, rock5[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock5[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock5[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock5[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock6[playerid] = CreatePlayerObject(playerid, 18751, 762.61, -2355.29, 0.56,   0.00, 0.00, 114.76);
	SetPlayerObjectMaterial(playerid, rock6[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock6[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock6[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock6[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock7[playerid] = CreatePlayerObject(playerid, 18751, 766.96, -2412.61, 2.22,   0.00, 0.00, 92.01);
	SetPlayerObjectMaterial(playerid, rock7[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock7[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock7[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock7[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock8[playerid] = CreatePlayerObject(playerid, 18751, 792.95, -2455.85, 2.22,   0.00, 0.00, 136.83);
	SetPlayerObjectMaterial(playerid, rock8[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock8[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock8[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock8[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock9[playerid] = CreatePlayerObject(playerid, 18751, 882.50, -2590.48, 3.05,   0.00, 0.00, 136.83);
	SetPlayerObjectMaterial(playerid, rock9[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock9[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock9[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock9[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock10[playerid] = CreatePlayerObject(playerid, 18751, 950.16, -2556.82, 4.92,   0.00, 0.00, 201.12);
	SetPlayerObjectMaterial(playerid, rock10[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock10[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock10[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock10[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock11[playerid] = CreatePlayerObject(playerid, 18751, 1009.88, -2518.76, 2.67,   0.00, 0.00, 221.43);
	SetPlayerObjectMaterial(playerid, rock11[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock11[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock11[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock11[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock12[playerid] = CreatePlayerObject(playerid, 18751, 887.98, -2194.55, 3.32,   0.00, 0.00, 354.66);
   	SetPlayerObjectMaterial(playerid, rock12[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock12[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock12[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock12[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock13[playerid] = CreatePlayerObject(playerid, 18751, 926.42, -2240.99, 6.41,   0.00, 0.00, 305.44);
	SetPlayerObjectMaterial(playerid, rock13[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock13[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock13[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock13[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock14[playerid] = CreatePlayerObject(playerid, 18751, 955.19, -2282.06, 9.15,   0.00, 0.00, 305.44);
   	SetPlayerObjectMaterial(playerid, rock14[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock14[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock14[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock14[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock15[playerid] = CreatePlayerObject(playerid, 18751, 747.97, -2304.88, 0.56,   0.00, 0.00, 89.57);
   	SetPlayerObjectMaterial(playerid, rock15[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock15[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock15[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock15[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock16[playerid] = CreatePlayerObject(playerid, 18751, 704.70, -2269.46, 0.56,   0.00, 0.00, 86.82);
	SetPlayerObjectMaterial(playerid, rock16[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock16[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock16[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock16[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
	rock17[playerid] = CreatePlayerObject(playerid, 18751, 706.46, -2307.04, -6.26,   0.00, 0.00, 93.98);
   	SetPlayerObjectMaterial(playerid, rock17[playerid], 0, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock17[playerid], 1, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock17[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
	SetPlayerObjectMaterial(playerid, rock17[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);
//Shop Texture
	sp1[playerid] = CreatePlayerObject(playerid, 19456, 946.61, -2448.70, 55.33,   0.00, 0.00, 10.64);
	SetPlayerObjectMaterial(playerid, sp1[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp2[playerid] = CreatePlayerObject(playerid, 19456, 941.01, -2454.59, 55.33,   0.00, 0.00, 280.04);
	SetPlayerObjectMaterial(playerid, sp2[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp3[playerid] = CreatePlayerObject(playerid, 19456, 931.57, -2456.26, 55.33,   0.00, 0.00, 280.04);
	SetPlayerObjectMaterial(playerid, sp3[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp4[playerid] = CreatePlayerObject(playerid, 19456, 925.04, -2446.90, 55.33,   0.00, 0.00, 10.02);
	SetPlayerObjectMaterial(playerid, sp4[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp5[playerid] = CreatePlayerObject(playerid, 19456, 940.02, -2439.38, 55.33,   0.00, 0.00, 280.34);
	SetPlayerObjectMaterial(playerid, sp5[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp6[playerid] = CreatePlayerObject(playerid, 19456, 931.98, -2440.83, 55.33,   0.00, 0.00, 280.34);
	SetPlayerObjectMaterial(playerid, sp6[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp7[playerid] = CreatePlayerObject(playerid, 19456, 946.15, -2446.32, 55.33,   0.00, 0.00, 10.64);
	SetPlayerObjectMaterial(playerid, sp7[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp8[playerid] = CreatePlayerObject(playerid, 19456, 926.02, -2452.44, 55.33,   0.00, 0.00, 10.02);
	SetPlayerObjectMaterial(playerid, sp8[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp9[playerid] = CreatePlayerObject(playerid, 19456, 942.84, -2454.26, 55.33,   0.00, 0.00, 280.04);
	SetPlayerObjectMaterial(playerid, sp9[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp10[playerid] = CreatePlayerObject(playerid, 19393, 944.95, -2440.06, 55.33,   0.00, 0.00, 10.23);
	SetPlayerObjectMaterial(playerid, sp10[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
	sp11[playerid] = CreatePlayerObject(playerid, 19393, 925.71, -2441.97, 55.33,   0.00, 0.00, 280.34);
	SetPlayerObjectMaterial(playerid, sp11[playerid], 0, 16070, "des_stownmain1", "des_brick1", 0);
//entrance
    entrance[playerid] = CreatePlayerObject(playerid, 3715, 1027.67, -2328.83, 21.13,   0.00, 0.00, 308.5198);
   	SetPlayerObjectMaterial(playerid, entrance[playerid], 2, 3915, "libertyhi3", "mp_snow", 0);
//text
    snowtext1[playerid] = CreatePlayerObject(playerid, 19481, 925.50, -2448.91, 55.33,   0.00, 0.00, 10.00);
    SetPlayerObjectMaterialText(playerid, snowtext1[playerid], "{BABABA}Welcome", 0, 140,"Arial", 28, 0, 0xFFFF8200, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	snowtext2[playerid] = CreatePlayerObject(playerid, 19481, 932.17, -2440.68, 55.39,   0.00, 0.00, 100.00);
    SetPlayerObjectMaterialText(playerid, snowtext2[playerid], "{BABABA}PUNCAKK!!", 0, 140,"Arial", 28, 0, 0xFFFF8200, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	snowtext3[playerid] = CreatePlayerObject(playerid, 19481, 934.95, -2455.36, 56.48,   0.00, 0.00, 100.00);
    SetPlayerObjectMaterialText(playerid, snowtext3[playerid], "{FFFFFF}GG PAK", 0, 140,"Arial", 28, 0, 0xFFFF8200, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
//entrance text
	snowtext4[playerid] = CreatePlayerObject(playerid, 19481, 1028.35, -2328.57, 21.80,   0.00, 0.00, 38.50);
	SetPlayerObjectMaterialText(playerid, snowtext4[playerid], "{BABABA}GunungSalju", 0, 100,"Arial", 28, 0, 0xFFFF8200, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
//snow mountain textures
    snow1[playerid] = CreatePlayerObject(playerid, 16109, 928.42, -2303.11, 28.88,   0.00, 0.00, 190.79);
	SetPlayerObjectMaterial(playerid, snow1[playerid], 1, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow1[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);
 	snow2[playerid] = CreatePlayerObject(playerid, 16147, 808.61, -2495.53, 21.50,   0.00, 0.00, 190.79);
	SetPlayerObjectMaterial(playerid, snow2[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
    SetPlayerObjectMaterial(playerid, snow2[playerid], 4, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
    SetPlayerObjectMaterial(playerid, snow2[playerid], 5, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
    SetPlayerObjectMaterial(playerid, snow2[playerid], 1, 3915, "libertyhi3", "mp_snow", 0);//rock onside
 	snow3[playerid] = CreatePlayerObject(playerid, 16148, 1007.14, -2442.03, -3.38,   0.00, 0.00, 216.11);
	SetPlayerObjectMaterial(playerid, snow3[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow3[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	SetPlayerObjectMaterial(playerid, snow3[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	snow4[playerid] = CreatePlayerObject(playerid, 16264, 866.61, -2195.44, 16.70,   0.00, 0.00, 190.79);
    SetPlayerObjectMaterial(playerid, snow4[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow4[playerid], 1, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow4[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	snow5[playerid] = CreatePlayerObject(playerid, 16149, 756.42, -2298.31, 20.01,   0.00, 0.00, 190.79);
	SetPlayerObjectMaterial(playerid, snow5[playerid], 2, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow5[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	SetPlayerObjectMaterial(playerid, snow5[playerid], 4, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	snow6[playerid] = CreatePlayerObject(playerid, 16148, 969.96, -2477.20, 31.30,   0.00, 0.00, 190.79);
	SetPlayerObjectMaterial(playerid, snow6[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow6[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	SetPlayerObjectMaterial(playerid, snow6[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	snow7[playerid] = CreatePlayerObject(playerid, 16148, 978.53, -2497.10, 7.30,   0.00, 0.00, 175.75);
	SetPlayerObjectMaterial(playerid, snow7[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow7[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	SetPlayerObjectMaterial(playerid, snow7[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	snow8[playerid] = CreatePlayerObject(playerid, 16148, 996.83, -2479.45, 7.30,   0.00, 0.00, 199.06);
	SetPlayerObjectMaterial(playerid, snow8[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow8[playerid], 2, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
	SetPlayerObjectMaterial(playerid, snow8[playerid], 3, 10166, "p69_rocks", "sfe_rock1",0);//rock onside
    snow9[playerid] = CreatePlayerObject(playerid, 16141, 904.18, -2550.39, -2.48,   0.00, 0.00, 20.92);
	SetPlayerObjectMaterial(playerid, snow9[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow9[playerid], 1, 3915, "libertyhi3", "mp_snow", 0);
    snow10[playerid] = CreatePlayerObject(playerid, 16141, 847.90, -2518.85, -2.69,   0.00, 0.00, 20.92);
	SetPlayerObjectMaterial(playerid, snow10[playerid], 0, 3915, "libertyhi3", "mp_snow", 0);
	SetPlayerObjectMaterial(playerid, snow10[playerid], 1, 3915, "libertyhi3", "mp_snow", 0);

    PantaiArea[playerid] = CreateDynamicRectangle(345.3125, -2094.787811279297, 415.3125, -2007.7878112792969);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    fAutoC[playerid] = 0;
    shotTime[playerid] = 0;
    SlotMachineStarted[playerid]=0;
    AccountData[playerid][pNambangBatu] = 0;
    AccountData[playerid][pMainXo] = 0;
    SlotTimert[playerid]=0;
    AccountData[playerid][pBetulPw] = 0;
    AccountData[playerid][pBetulNama] = 0;
    AccountData[playerid][pBetulAge] = 0;
    AccountData[playerid][pBetulHeight] = 0;
    AccountData[playerid][pBetulWeight] = 0;
    AccountData[playerid][pBetulGender] = 0;
    AccountData[playerid][pBetulAge] = 0;
    AccountData[playerid][pBetulOrigin] = 0;
    SlotRunde[playerid]=0;
    Fishing::ResetPlayer(playerid);
    if(usingcarwash == playerid)
	{
	    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	    usingcarwash = -1;
	    Update3DTextLabelText(entrancetext, -1, "{FFFFFF}Tidak ada yang menggunakan pencucian mobil sekarang.\n{FF8CC0}Harga: $15.00 cmd: /carwash");
	}
    shot[playerid] = 0;
    takingclothes[playerid] = 0;
    AccountData[playerid][pBetulPw] = 0;
    if (IsPlayerInAnyVehicle(playerid))
    {
        RemovePlayerFromVehicle(playerid);
    }
    if(sltX == playerid) MatchInfo[playerid][Fullxo] = 0,MatchInfo[sltX][Fullxo] = 0,MatchInfo[sltO][Fullxo] = 0,xowin(sltO);
	if(sltO == playerid) MatchInfo[playerid][Fullxo] = 0,MatchInfo[sltX][Fullxo] = 0,MatchInfo[sltO][Fullxo] = 0,xowin(sltX);
    if(CompassTimer[playerid])
    {
        KillTimer(CompassTimer[playerid]);
        CompassTimer[playerid] = 0;
    }
    DestroyBlackSmoke(playerid);
    for(new i = 0; i < 11; i++)
    {
        PlayerTextDrawHide(playerid, JADENCOMPAS[playerid][i]);
    }
    KillTimer(AccountData[playerid][DokterLokalTimer]);
    KillTimer(AccountData[playerid][pDutyTimer]);
    RemoveDrag(playerid);
    CheckDrag(playerid);
    Report_Clear(playerid);
    JoueurAppuieJump[playerid] = 0;
    Ask_Clear(playerid);

    g_RaceCheck[playerid] ++;

    if (AccountData[playerid][IsLoggedIn])
    {
        UpdatePlayerData(playerid);
        UnloadPlayerVehicle(playerid);

        if (AccountData[playerid][pJobVehicle] != 0)
        {
            DestroyJobVehicle(playerid);
            AccountData[playerid][pJobVehicle] = 0;
        }
    }

    if (IsValidDynamic3DTextLabel(AccountData[playerid][pAdoTag])) DestroyDynamic3DTextLabel(AccountData[playerid][pAdoTag]);
    if (IsValidDynamic3DTextLabel(AccountData[playerid][pMaskLabel])) DestroyDynamic3DTextLabel(AccountData[playerid][pMaskLabel]);

    if (AccountData[playerid][pAdminDuty] == 1)
        if (IsValidDynamic3DTextLabel(AccountData[playerid][pLabelDuty]))
            DestroyDynamic3DTextLabel(AccountData[playerid][pLabelDuty]);

    new reasontext[526], frmxt[255], Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    switch (reason)
    {
        case 0: format(reasontext, sizeof(reasontext), "Timeout/Crash");
        case 1: format(reasontext, sizeof(reasontext), "Quit");
        case 2: format(reasontext, sizeof(reasontext), "Kicked/Banned");
    }

    if (DestroyDynamic3DTextLabel(labelDisconnect[playerid]))
        labelDisconnect[playerid] = STREAMER_TAG_3D_TEXT_LABEL:
    INVALID_STREAMER_ID;

    format(frmxt, sizeof(frmxt), "Player ["YELLOW"%d"WHITE"]"YELLOW" %s | %s"WHITE" Telah keluar dari server.\nReason: "RED"%s", playerid, AccountData[playerid][pName], AccountData[playerid][pUCP], reasontext);
    labelDisconnect[playerid] = CreateDynamic3DTextLabel(frmxt, -1, pX, pY, pZ, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 15.0, -1, 0);
    labelDisconnectTimer[playerid] = SetTimerEx("DestroyLabelOut", 30000, false, "i", playerid);

    if (AccountData[playerid][phoneDurringConversation])
    {
        CutCallingLine(playerid);
    }
    TerminateConnection(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(PlayerSpawn[playerid] == 1)
	{
	    if (AccountData[playerid][pGender] == 0)
	    {
	        TogglePlayerControllable(playerid, 0);
	        SetPlayerHealth(playerid, 100.0);
	        SetPlayerArmour(playerid, 0.0);
	        SetPlayerCameraPos(playerid, 584.769, -2183.039, 131.617);
	        SetPlayerCameraLookAt(playerid, 582.755, -2178.958, 129.546);
	        InterpolateCameraPos(playerid, 584.769, -2183.039, 131.617, 584.769, -2183.039, 131.617, 20000, CAMERA_MOVE);
	        SetPlayerVirtualWorld(playerid, 3);
	        ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Tanggal Lahir", "Mohon masukkan tanggal lahir sesuai format hh/bb/tttt cth: (25/09/2001)", "Input", "");
	    }
	    else
	    {
	        if (!AccountData[playerid][pSpawned])
	        {
	            AccountData[playerid][pSpawned] = 1;
	            SetCameraBehindPlayer(playerid);
	            Streamer_ToggleIdleUpdate(playerid, true);
	            StopAudioStreamForPlayer(playerid);

	            GivePlayerMoney(playerid, AccountData[playerid][pMoney]);
	            SetPlayerScore(playerid, AccountData[playerid][pLevel]);
	            SetPlayerHealth(playerid, AccountData[playerid][pHealth]);
	            SetPlayerArmour(playerid, AccountData[playerid][pArmour]);
	            SetPlayerInterior(playerid, AccountData[playerid][pInt]);
	            SetPlayerVirtualWorld(playerid, AccountData[playerid][pWorld]);
	            PreloadAnimations(playerid);

	            TogglePlayerControllable(playerid, false);
	            static Float:X, Float:Y, Float:Z;
	            GetPlayerPos(playerid, X, Y, Z);
	            ShowPlayerFooter(playerid, "~y~MEMUAT OBJECT", 7000);
	            AccountData[playerid][pFreeze] = 1;
	            AccountData[playerid][pFreezeTimer] = SetTimerEx("SetPlayerToUnfreeze", 7000, false, "iffff", playerid, X, Y, Z); //defer SetPlayerToUnfreeze[time](playerid);
	            Player_ToggleTelportAntiCheat(playerid, true);

	            SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);

	            SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 0);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
	            SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 0);

	            SendClientMessageEx(playerid, COLOR_RED, "(Server){FFFFFF} Selalu ingat bahwa server ini menggunakan sistem voice only, dilarang keras RP Bisu/Tuli.");
	            SendClientMessageEx(playerid, COLOR_RED, "(Server){FFFFFF} Belajarlah untuk menghargai orang lain, di server ini bukan hanya kamu saja. Ajari mereka apabila salah, tebarkan kebaikan..");
	            SendClientMessageEx(playerid, COLOR_RED, "(Server) Dilarang keras meniup-niup mic!.");
	            if(!AccountData[playerid][pStarterpack])
				{
	                SendClientMessageEx(playerid, COLOR_RED, "(Server) {FFFF00}Anda belum claim starterpack gunakna {FF0000}'/crrp2025' {FFFF00}untuk mengambilnya!.");
	            }

	            if(AccountData[playerid][pLevel] == 1)
				{
	                if(!AccountData[playerid][newCitizen])
					{
	                    AccountData[playerid][newCitizen] = true;
	                    AccountData[playerid][newCitizenTimer] = 3600;
	                    forex(i, 10) PlayerTextDrawShow(playerid, UI_NEWPLAYER[playerid][i]);
	                    new hours, minutes, seconds;
	                    GetElapsedTime(AccountData[playerid][newCitizenTimer], hours, minutes, seconds);
	                    PlayerTextDrawSetString(playerid, UI_NEWPLAYER[playerid][9], sprintf("%02d:%02d", hours, minutes));
	                }

	                if(AccountData[playerid][newCitizen] && AccountData[playerid][newCitizenTimer] > 0)
					{
	                    forex(i, 10) PlayerTextDrawShow(playerid, UI_NEWPLAYER[playerid][i]);
	                    new hours, minutes, seconds;
	                    GetElapsedTime(AccountData[playerid][newCitizenTimer], hours, minutes, seconds);
	                    PlayerTextDrawSetString(playerid, UI_NEWPLAYER[playerid][9], sprintf("%02d:%02d", hours, minutes));
	                }
	            }

	            new vQuery[300];
	            mysql_format(g_SQL, vQuery, sizeof(vQuery), "SELECT * FROM `player_vehicles` WHERE `PVeh_OwnerID` = '%d' ORDER BY `id` ASC", AccountData[playerid][pID]);
	            mysql_tquery(g_SQL, vQuery, "Vehicle_Load", "d", playerid);

	            if (VoucherData[0][voucherExists] && AccountData[playerid][pKompensasi] < 1)
	            {
	                SendClientMessageEx(playerid, -1, "[i] Anda memiliki kompensasi yang belum di claim! gunakan "YELLOW"'/klaimkompensasi'"WHITE" untuk mengambil kompensasi");
	            }
	            if (AccountData[playerid][pDutyPD] || AccountData[playerid][pDutyPemerintah] || AccountData[playerid][pDutyEms]
	                    || AccountData[playerid][pDutyBengkel] || AccountData[playerid][pDutyTrans] || AccountData[playerid][pDutyPedagang])
	            {
	                AccountData[playerid][pDutyTimer] = SetTimerEx("FactDutyHour", 1000, true, "d", playerid);
	            }

	            if(AccountData[playerid][pDutyPD] == 1)
				{
	                AccountData[playerid][pDutyPD] = true;
	            }
	        }

	        if (IsPlayerInEvent(playerid))
	            return 0;

	        Streamer_ToggleIdleUpdate(playerid, true);
	        PreloadAnimations(playerid);
	        if (AccountData[playerid][pUsingUniform])
	        {
	            SetPlayerSkin(playerid, AccountData[playerid][pUniform]);
	        }
	        else
	        {
	            SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
	        }

	        if (AccountData[playerid][pInjured] == 1 && AccountData[playerid][pInjuredTime] != 0)
	        {
	            TogglePlayerControllable(playerid, false);
	            SetPlayerPos(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ]);
	            SetPlayerFacingAngle(playerid, AccountData[playerid][pPosA]);
	            SetPlayerInterior(playerid, AccountData[playerid][pInt]);
	            SetPlayerVirtualWorld(playerid, AccountData[playerid][pWorld]);
	        }

	        if (AccountData[playerid][pAdminDuty] > 0)
	        {
	            SetPlayerColor(playerid, X11_DARKRED);
	        }
	        SetTimerEx("TimersSpawn", 5000, false, "d", playerid);
	    }
	}
    else
    {
        if(PlayerChar[playerid][0][0] != EOS) SetPlayerSkin(playerid, CharSkin[playerid][0]);
		else SetPlayerSkin(playerid, RandomEx(1, 255));
		TogglePlayerSpectating(playerid, false);
	//	InterpolateCameraPos(playerid, 1813.3591, 2089.7769, 35.5225, 1811.0797, 2090.8833, 35.5225, 9000);
		//InterpolateCameraLookAt(playerid, 1816.6748,2086.5896, 35.5225, 1818.3202, 2086.8596, 35.5225, 9000);
		SetPlayerCameraPos(playerid,2402.485351,1596.094604,31.153108);
		SetPlayerCameraLookAt(playerid,2407.114746,1591.432861,30.413135);
		SetPlayerInterior(playerid, -1);
		SetPlayerVirtualWorld(playerid, 1000 + playerid);
		ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
    }
    return 1;
}

forward TimersSpawn(playerid);
public TimersSpawn(playerid)
{
    if (!AccountData[playerid][pSpawned])
        return 0;

    if (AccountData[playerid][pJail] > 0)
    {
        SpawnPlayerInJail(playerid);
    }
    if (AccountData[playerid][pArrestTime] > 0)
    {
        SetPlayerArrest(playerid, AccountData[playerid][pArrest]);
    }

    TogglePlayerControllable(playerid, 1);
    SetPlayerInterior(playerid, AccountData[playerid][pInt]);
    SetPlayerVirtualWorld(playerid, AccountData[playerid][pWorld]);
    AttachPlayerToys(playerid);
    SetWeapons(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if (!AccountData[playerid][pSpawned])
        return 0;

    foreach (new i : Player) if (IsPlayerConnected(i))
        {
            if (AccountData[i][pAdmin] > 0 && AccountData[i][pTheStars] > 0)
            {
                SendDeathMessageToPlayer(i, killerid, playerid, reason);
                return 1;
            }
        }
    new reasontext[596];
    switch (reason)
    {
        case 0: reasontext = "Tangan Kosong";
        case 1: reasontext = "Brass Knuckles";
        case 2: reasontext = "Golf Club";
        case 3: reasontext = "Nite Stick";
        case 4: reasontext = "Knife";
        case 5: reasontext = "Basebal Bat";
        case 6: reasontext = "Shovel";
        case 7: reasontext = "Pool Cue";
        case 8: reasontext = "Katana";
        case 9: reasontext = "Chain Shaw";
        case 14: reasontext = "Cane";
        case 18: reasontext = "Molotov";
        case 22: reasontext = "Colt 45";
        case 23: reasontext = "SLC";
        case 24: reasontext = "Desert Eagle";
        case 25: reasontext = "Shotgun";
        case 26: reasontext = "Sawnoff Shotgun";
        case 27: reasontext = "Combat Shotgun";
        case 28: reasontext = "Micro SMG/Uzi";
        case 29: reasontext = "MP5";
        case 30: reasontext = "AK-47";
        case 31: reasontext = "M4";
        case 32: reasontext = "Tec-9";
        case 33: reasontext = "Coutry Rifle";
        case 38: reasontext = "Mini Gun";
        case 49: reasontext = "Tertabrak Kendaraan";
        case 50: reasontext = "Helicopter Blades";
        case 51: reasontext = "Explode";
        case 53: reasontext = "Drowned";
        case 54: reasontext = "Splat";
   case 255: reasontext = "Suicide";
    }
    if(usingcarwash == playerid)
	{
	    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	    usingcarwash = -1;
	    Update3DTextLabelText(entrancetext, -1, "{FFFFFF}Tidak ada yang menggunakan pencucian mobil sekarang.\n{FF8CC0}Harga: $15.00 cmd: /carwash");
	}
	AccountData[playerid][pNambangBatu] = 0;
	AccountData[playerid][pMainXo] = 0;
    takingclothes[playerid] = 0;
    SlotMachineStarted[playerid]=0;
    SlotTimert[playerid]=0;
    SlotRunde[playerid]=0;
    SetPlayerArmedWeapon(playerid, 0);
    return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    new weaponid = EditingWeapon[playerid];
    if (response)
    {
        if (weaponid)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];

            GetWeaponName(weaponid, weaponname, sizeof(weaponname));

            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;

            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);

            ShowTDN(playerid, NOTIFICATION_SUKSES, sprintf("Berhasil merubah posisi letak %s", weaponname));

            EditingWeapon[playerid] = 0;
            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", AccountData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }

        if (AccountData[playerid][toySelected] != -1)
        {
            new id = AccountData[playerid][toySelected];
            pToys[playerid][id][toy_x] = fOffsetX;
            pToys[playerid][id][toy_y] = fOffsetY;
            pToys[playerid][id][toy_z] = fOffsetZ;
            pToys[playerid][id][toy_rx] = fRotX;
            pToys[playerid][id][toy_ry] = fRotY;
            pToys[playerid][id][toy_rz] = fRotZ;
            pToys[playerid][id][toy_sx] = fScaleX;
            pToys[playerid][id][toy_sy] = fScaleY;
            pToys[playerid][id][toy_sz] = fScaleZ;

            MySQL_SavePlayerToys(playerid);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Berhasil menyimpan kordinat baru.");
            AccountData[playerid][toySelected] = -1;
        }
    }
    else
    {
        if (EditingWeapon[playerid])
        {
            new enum_index = weaponid - 22;
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
            EditingWeapon[playerid] = 0;
        }

        if (AccountData[playerid][toySelected] != -1)
        {
            new id = AccountData[playerid][toySelected];
            SetPlayerAttachedObject(playerid,
                                    id,
                                    modelid,
                                    boneid,
                                    pToys[playerid][id][toy_x],
                                    pToys[playerid][id][toy_y],
                                    pToys[playerid][id][toy_z],
                                    pToys[playerid][id][toy_rx],
                                    pToys[playerid][id][toy_ry],
                                    pToys[playerid][id][toy_rz],
                                    pToys[playerid][id][toy_sx],
                                    pToys[playerid][id][toy_sy],
                                    pToys[playerid][id][toy_sz]);
            AccountData[playerid][toySelected] = -1;
        }
    }
    SetPVarInt(playerid, "UpdatedToy", 1);
    return 1;
}


public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (AccountData[playerid][EditingDeerID] != -1 && Iter_Contains(Hunt, AccountData[playerid][EditingDeerID]))
    {
        if (response == EDIT_RESPONSE_FINAL)
        {
            new etid = AccountData[playerid][EditingDeerID];
            HuntData[etid][DeerPOS][0] = x;
            HuntData[etid][DeerPOS][1] = y;
            HuntData[etid][DeerPOS][2] = z;
            HuntData[etid][DeerROT][0] = rx;
            HuntData[etid][DeerROT][1] = ry;
            HuntData[etid][DeerROT][2] = rz;

            SetDynamicObjectPos(objectid, HuntData[etid][DeerPOS][0], HuntData[etid][DeerPOS][1], HuntData[etid][DeerPOS][2]);
            SetDynamicObjectRot(objectid, HuntData[etid][DeerROT][0], HuntData[etid][DeerROT][1], HuntData[etid][DeerROT][2]);

            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, HuntData[etid][DeerLabel], E_STREAMER_X, HuntData[etid][DeerPOS][0]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, HuntData[etid][DeerLabel], E_STREAMER_Y, HuntData[etid][DeerPOS][1]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, HuntData[etid][DeerLabel], E_STREAMER_Z, HuntData[etid][DeerPOS][2] + 1.1);

            HuntSave(etid);
            AccountData[playerid][EditingDeerID] = -1;
        }
        if (response == EDIT_RESPONSE_CANCEL)
        {
            new etid = AccountData[playerid][EditingDeerID];
            SetDynamicObjectPos(objectid, HuntData[etid][DeerPOS][0], HuntData[etid][DeerPOS][1], HuntData[etid][DeerPOS][2]);
            SetDynamicObjectRot(objectid, HuntData[etid][DeerROT][0], HuntData[etid][DeerROT][1], HuntData[etid][DeerROT][2]);
            AccountData[playerid][EditingDeerID] = -1;
        }
    }
    else if (AccountData[playerid][EditingLADANGID] != -1 && Iter_Contains(Ladang, AccountData[playerid][EditingLADANGID]))
    {
        if (response == EDIT_RESPONSE_FINAL)
        {
            new etid = AccountData[playerid][EditingLADANGID];
            LadangData[etid][kanabisX] = x;
            LadangData[etid][kanabisY] = y;
            LadangData[etid][kanabisZ] = z;
            LadangData[etid][kanabisRX] = rx;
            LadangData[etid][kanabisRY] = ry;
            LadangData[etid][kanabisRZ] = rz;

            SetDynamicObjectPos(objectid, LadangData[etid][kanabisX], LadangData[etid][kanabisY], LadangData[etid][kanabisZ]);
            SetDynamicObjectRot(objectid, LadangData[etid][kanabisRX], LadangData[etid][kanabisRY], LadangData[etid][kanabisRZ]);

            Ladang_Save(etid);
            AccountData[playerid][EditingLADANGID] = -1;
        }

        if (response == EDIT_RESPONSE_CANCEL)
        {
            new etid = AccountData[playerid][EditingLADANGID];
            SetDynamicObjectPos(objectid, LadangData[etid][kanabisX], LadangData[etid][kanabisY], LadangData[etid][kanabisZ]);
            SetDynamicObjectRot(objectid, LadangData[etid][kanabisRX], LadangData[etid][kanabisRY], LadangData[etid][kanabisRZ]);
            AccountData[playerid][EditingLADANGID] = -1;
        }
    }
    else if(AccountData[playerid][EditingkoranID] != -1 && Iter_Contains(KoranZ, AccountData[playerid][EditingkoranID]))
	{
			if(response == EDIT_RESPONSE_FINAL)
		    {
		        new etid = AccountData[playerid][EditingkoranID];
		        Newkoran[etid][koranX] = x;
		        Newkoran[etid][koranY] = y;
		        Newkoran[etid][koranZ] = z;
		        Newkoran[etid][koranRX] = rx;
		        Newkoran[etid][koranRY] = ry;
		        Newkoran[etid][koranRZ] = rz;

		        SetDynamicObjectPos(objectid, Newkoran[etid][koranX], Newkoran[etid][koranY], Newkoran[etid][koranZ]);
		        SetDynamicObjectRot(objectid, Newkoran[etid][koranRX], Newkoran[etid][koranRY], Newkoran[etid][koranRZ]);

				Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Newkoran[etid][koranLabel], E_STREAMER_X, Newkoran[etid][koranX]);
				Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Newkoran[etid][koranLabel], E_STREAMER_Y, Newkoran[etid][koranY]);
				Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Newkoran[etid][koranLabel], E_STREAMER_Z, Newkoran[etid][koranZ] + 0.3);

			    koran_Save(etid);
		        AccountData[playerid][EditingkoranID] = -1;
		    }

		    if(response == EDIT_RESPONSE_CANCEL)
		    {
		        new etid = AccountData[playerid][EditingkoranID];
		        SetDynamicObjectPos(objectid, Newkoran[etid][koranX], Newkoran[etid][koranY], Newkoran[etid][koranZ]);
		        SetDynamicObjectRot(objectid, Newkoran[etid][koranRX], Newkoran[etid][koranRY], Newkoran[etid][koranRZ]);
		        AccountData[playerid][EditingkoranID] = -1;
		    }
	}
    else if (AccountData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, AccountData[playerid][EditingATMID]))
    {
        if (response == EDIT_RESPONSE_FINAL)
        {
            new etid = AccountData[playerid][EditingATMID];
            AtmData[etid][atmX] = x;
            AtmData[etid][atmY] = y;
            AtmData[etid][atmZ] = z;
            AtmData[etid][atmRX] = rx;
            AtmData[etid][atmRY] = ry;
            AtmData[etid][atmRZ] = rz;

            SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
            SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

            Atm_Refresh(etid);
            Atm_Save(etid);
            AccountData[playerid][EditingATMID] = -1;
        }

        if (response == EDIT_RESPONSE_CANCEL)
        {
            new etid = AccountData[playerid][EditingATMID];
            SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
            SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
            AccountData[playerid][EditingATMID] = -1;
        }
    }
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(InRace[playerid] && RaceWith[playerid] != INVALID_PLAYER_ID)
    {
        //RaceIndex[playerid]++;
        Race_ProgressCP(playerid);
    }
    if(jobs::mixer[playerid][mixerDuty][1])
    {
        DisablePlayerCheckpoint(playerid);
        PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENUMPAHKAN...");
		ShowProgressBar(playerid);
        jobs::mixer[playerid][mixerDuty][1] = false;
        jobs::mixer[playerid][mixerTimer] = SetTimerEx("CorLokasi", 1000, true, "i", playerid);
    }
    if(jobs::mixer[playerid][mixerDuty][2])
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            RemovePlayerFromVehicle(playerid);
            DestroyVehicle(GetPlayerVehicleID(playerid));
            GivePlayerMoneyEx(playerid, 150);
            jobs::mixer[playerid][mixerDuty][2] = false;
            jobs::mixer_reset_enum(playerid);
        }

    }
    if (pMapCP[playerid])
    {
        ShowTDN(playerid, NOTIFICATION_INFO, "Anda berhasil sampai ke lokasi tujuan");
        DisablePlayerRaceCheckpoint(playerid);
        pMapCP[playerid] = false;
    }
    if (AccountData[playerid][pTrackCar] == 1)
    {
        ShowTDN(playerid, NOTIFICATION_INFO, "Anda berhasil sampai ke lokasi tujuan");
        AccountData[playerid][pTrackCar] = 0;
        DisablePlayerRaceCheckpoint(playerid);
    }
    if (AccountData[playerid][pTrackHoused] == 1)
    {
        ShowTDN(playerid, NOTIFICATION_INFO, "Anda berhasil sampai ke lokasi tujuan");
        AccountData[playerid][pTrackHoused] = 0;
        DisablePlayerRaceCheckpoint(playerid);
    }
    if (AccountData[playerid][pDiPesawat])
    {
        DisablePlayerCheckpoint(playerid);
        AccountData[playerid][pDiPesawat] = false;
        AccountData[playerid][pPosX] = 1642.7004;
        AccountData[playerid][pPosY] = -2286.5022;
        AccountData[playerid][pPosZ] = -1.1715;
        AccountData[playerid][pPosA] = 271.9941;
        AccountData[playerid][pInDoor] = -1;
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerPositionEx(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ], AccountData[playerid][pPosA], 6000);
    }
    return 1;
}

Dialog:DeathRespawnConf(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;
    if (!IsPlayerInjured(playerid)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak sedang Pingsan!");

    SetPlayerHealthEx(playerid, 100.0);
    AccountData[playerid][pHunger] = 100;
    AccountData[playerid][pThirst] = 100;
    AccountData[playerid][pStress] = 0;
    AccountData[playerid][pInjured] = 0;
    AccountData[playerid][pInjuredTime] = 0;
    Inventory_Clear(playerid);
    ResetPlayerWeaponsEx(playerid);

    ShowTDN(playerid, NOTIFICATION_INFO, "Kamu koma dan dilarikan ke Rumah Sakit");

    SetPlayerPositionEx(playerid, 907.8289, 711.1892, 5010.3184, 358.7794, 5000);
    SetPlayerVirtualWorldEx(playerid, 5);
    SetPlayerInteriorEx(playerid, 5);

    foreach (new pid : Player)
    {
        if (AccountData[pid][pFaction] == FACTION_EMS && AccountData[pid][pDutyEms])
        {
            SendClientMessageEx(pid, -1, ""YELLOW"[Koma]"WHITE_E" %s telah terbangun di ruang koma", ReturnName(playerid));
        }
    }

    AddPMoneyLog(AccountData[playerid][pName], AccountData[playerid][pUCP], "KOMA", 0);
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    /* Senter */
    if (PRESSED(KEY_CTRL_BACK) && AccountData[playerid][pFlashShown] && !IsPlayerInAnyVehicle(playerid))
    {
        switch (AccountData[playerid][pFlashOn])
        {
            case false:
            {
                if (!IsPlayerPlayingAnimation(playerid, "ped", "phone_talk"))
                {
                    ApplyAnimationEx(playerid, "ped", "phone_talk", 1.1, 1, 1, 1, 1, 1, 1);
                }

                AccountData[playerid][pFlashOn] = true;
                SetPlayerAttachedObject(playerid, 5, 19295, 1,  0.068000, 0.606000, 0.000000,  0.000000, -4.500000, 12.299996,  1.000000, 1.000000, 1.020000); // Light Objects
                ShowPlayerFooter(playerid, "~w~Senter ~g~Nyala", 3000);
            }
            case true:
            {
                AccountData[playerid][pFlashOn] = false;
                RemovePlayerAttachedObject(playerid, 5);
                ShowPlayerFooter(playerid, "~w~Senter ~r~Mati", 3000);
            }
        }
    }
    
    if(newkeys & KEY_YES)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(AccountData[playerid][pIsSmoking])
			{
				if(AccountData[playerid][pActivityTime] != 0) return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda sedang melakukan sesuatu, mohon tunggu progress bar selesai!");

				if(pIsVaping[playerid]) //jika vape
				{
					if(AccountData[playerid][pIsSmokeBlowing]) return 1;

					AccountData[playerid][pIsSmokeBlowing] = true;
					AccountData[playerid][pSmokedTimes]++;
					SetTimerEx("StartVape", 2100, false, "i", playerid);
					ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, false, false, false, false, 0, true);
				}
				else
				{
					if(AccountData[playerid][pIsSmokeBlowing]) return 1;

					AccountData[playerid][pIsSmokeBlowing] = true;
					AccountData[playerid][pSmokedTimes]++;
					SetTimerEx("StartVape", 3500, false, "i", playerid);
					ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.1, false, true, true, true, 1, true);
				}
			}
		}
	}
    if(PRESSED(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
        if(IsPlayerInRangeOfPoint(playerid, 10.0, 2523.39990234,-1493.50000000,23.89999962))
		{
		MoveObject(gatest1, 2523.60009766,-1493.50000000,23.89999962, 1.0, 0.00000000,348.00000000,0.00000000);
		SetTimer("Closegatest1", 5000, 1);
		return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 10.0, 2540.10009766,-1459.30004883,24.39999962))
		{
		MoveObject(gatest2, 2540.10009766,-1459.09997559,24.39999962, 1.0, 0.00000000,8.00000000,269.99645996);
		SetTimer("Closegatest2", 5000, 1);
		return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 10.0, 2539.89990234,-1475.59997559,24.39999962))
		{
		MoveObject(gatest3, 2539.89990234,-1475.80004883,24.39999962, 1.0, 0.00000000,345.99987793,269.99981689);
		SetTimer("Closegatest3", 5000, 1);
		return 1;
		}
	}
    if(PRESSED(KEY_YES))
    {
        if(IsPlayerInDynamicArea(playerid, RobBank[BankArea][0]) ||
            IsPlayerInDynamicArea(playerid, RobBank[BankArea][1]) ||
            IsPlayerInDynamicArea(playerid, RobBank[BankArea][2]))
        {
            altForRobBank(playerid);
        }
    }
 	if (PRESSED(KEY_HANDBRAKE))
	{
	    if(AccountData[playerid][pPlayingPool])
		{
            if (GetPlayerWeapon(playerid) != 7)
            {
                return SendClientMessage(playerid, X11_TOMATO, "You don't have a pool cue in your hand.");
            }
            if(AccountData[playerid][pAiming] != 1)
            {
                new Float:poolrot, Float:X, Float:Y, Float:Z, Float:Xa, Float:Ya, Float:Za, Float:x, Float:y;
                PoolInfo[AccountData[playerid][pPoolTable]][bCurrentShooter] = playerid;
                CueTimer[playerid] = SetTimerEx("Pool_Timer", 21, true, "ii", playerid, AccountData[playerid][pPoolTable]);
                GetPlayerPos(playerid, X, Y, Z);
                GetObjectPos(PoolInfo[AccountData[playerid][pPoolTable]][bBalls][0], Xa, Ya, Za);
                AccountData[playerid][pAiming] = 1;
                if(Is2DPointInRangeOfPoint(X, Y, Xa, Ya, 1.5) && Z < 999.5)
                {
                    TogglePlayerControllable(playerid, 0);
                    GetAngleToXY(Xa, Ya, X, Y, poolrot);
                    SetPlayerFacingAngle(playerid, poolrot);
                    CueAimAngle[playerid][0] = poolrot;
                    CueAimAngle[playerid][1] = poolrot;
                    SetPlayerArmedWeapon(playerid, 0);
                    GetXYInFrontOfPos(Xa, Ya, poolrot+180, x, y, 0.085);
                    AimObject[playerid] = CreateObject(3004, x, y, Za, 7.0, 0, poolrot+180);
                    GetXYBehindObjectInAngle(PoolInfo[AccountData[playerid][pPoolTable]][bBalls][0], poolrot, x, y, 0.675);
                    SetPlayerCameraPos(playerid, x, y, Za+0.28);
                    SetPlayerCameraLookAt(playerid, Xa, Ya, Za+0.170);
                    ApplyAnimation(playerid, "POOL", "POOL_Med_Start",50.0,0,0,0,1,1,1);
                    TextDrawShowForPlayer(playerid, PoolTD[0]);
                    TextDrawShowForPlayer(playerid, PoolTD[1]);
                    TextDrawTextSize(PoolTD[2], 501.0, 0.0);
                    TextDrawShowForPlayer(playerid, PoolTD[2]);
                    TextDrawShowForPlayer(playerid, PoolTD[3]);
                    CuePower[playerid] = 1.0;
                    PoolDir[playerid] = 0;
                }
            }
            else
            {
                TogglePlayerControllable(playerid, 1);
                ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0, 1);
                SetCameraBehindPlayer(playerid);
                DestroyObject(AimObject[playerid]);
                TextDrawHideForPlayer(playerid, PoolTD[0]);
                TextDrawHideForPlayer(playerid, PoolTD[1]);
                TextDrawHideForPlayer(playerid, PoolTD[2]);
                TextDrawHideForPlayer(playerid, PoolTD[3]);
                AccountData[playerid][pAiming] = 0;
                PoolInfo[AccountData[playerid][pPoolTable]][bCurrentShooter] = -1;
                KillTimer(CueTimer[playerid]);
            }
		}
	}
  	if(PRESSED(KEY_FIRE))
	{
	    if(AccountData[playerid][pPlayingPool])
		{
            if (GetPlayerWeapon(playerid) != 7)
            {
                return SendClientMessage(playerid, X11_TOMATO, "You don't have a pool cue in your hand.");
            }
            if(AccountData[playerid][pAiming])
            {
                if(AccountData[playerid][pAiming] == 1)
                {
                    AccountData[playerid][pAiming] = 0;
                }
                new Float:speed;
                ApplyAnimation(playerid, "POOL", "POOL_Med_Shot",3.0,0,0,0,0,0,1);
                speed = 0.4 + (CuePower[playerid] * 2.0) / 100.0;
                PHY_SetObjectVelocity(PoolInfo[AccountData[playerid][pPoolTable]][bBalls][0], speed * floatsin(-CueAimAngle[playerid][0], degrees), speed * floatcos(-CueAimAngle[playerid][0], degrees));
                TogglePlayerControllable(playerid, 1);
                PoolInfo[AccountData[playerid][pPoolTable]][bLastShooter] = playerid;
                PoolInfo[AccountData[playerid][pPoolTable]][bCurrentShooter] = -1;
                SetCameraBehindPlayer(playerid);
                ClearAnimations(playerid, 1);
                DestroyObject(AimObject[playerid]);
                TextDrawHideForPlayer(playerid, PoolTD[0]);
                TextDrawHideForPlayer(playerid, PoolTD[1]);
                TextDrawHideForPlayer(playerid, PoolTD[2]);
                TextDrawHideForPlayer(playerid, PoolTD[3]);
                KillTimer(CueTimer[playerid]);
            }
        }
	}
    
    new playerState = GetPlayerState(playerid); // Get the killer's state
    if(playerState == PLAYER_STATE_ONFOOT) // If the killer was in a vehicle
    {
	if (PRESSED( KEY_CROUCH | KEY_AIM ))
	{
	ApplyAnimation(playerid, "PED", "EV_dive", 4.1, 0, 1, 1, 1, 5, 1);
	}
	}

    if (newkeys & KEY_CTRL_BACK)
    {
    	if(showBarGames[playerid])
		{
			StopBar(playerid);
		}
		if(ActionBar[playerid][BarShowt])
        {
            if(ActionBar[playerid][BarPost] >= ActionBar[playerid][BarGreent]-5 && ActionBar[playerid][BarPost] <= ActionBar[playerid][BarGreent]+7)
            {
                SuccesActionBar(playerid);
            }
            else
            {
                FailedActionBar(playerid);
            }
        }
    }
    /* Anti Bike Hopping */
	if(PRESSED(KEY_ACTION))
	{
		static vehicleid;

		if(IsPlayerInAnyVehicle(playerid) && ((vehicleid = GetPlayerVehicleID(playerid)) != INVALID_VEHICLE_ID))
		{
			if(GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 510)
			{
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				SetPlayerPos(playerid, x, y, z);

				ApplyAnimationEx(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
			}
		}
	}


    /* Greenzone */
    if (newkeys & KEY_FIRE && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && AccountData[playerid][newCitizen]) {
        ClearAnimations(playerid, 1);
        SetPlayerArmedWeapon(playerid, 0);
    }
    if (newkeys & KEY_FIRE && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && IsPlayerInDynamicArea(playerid, AreaData[BandaraGreenZone]))
    {
        ClearAnimations(playerid, 1);
        SetPlayerArmedWeapon(playerid, 0);

        SetPVarInt(playerid, "GreenzoneWarning", GetPVarInt(playerid, "GreenzoneWarning") + 1);
        Info(playerid, "Anda tidak dapat memukul / menembak di Area Greenzone. "RED"%d/5"WHITE" anda akan ditendang dari server.", GetPVarInt(playerid, "GreenzoneWarning"));

        if (GetPVarInt(playerid, "GreenzoneWarning") == 5)
        {
            Warning(playerid, "Anda telah ditendang dari server karena mendapatkan "RED"5"WHITE" peringatan Greenzone!");
            DeletePVar(playerid, "GreenzoneWarning");
            KickEx(playerid);
        }
    }
    
    /* Voting Systemm */
    if (newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && !AccountData[playerid][pInjured])
    {
        if (AccountData[playerid][pRFoot] < 50 || AccountData[playerid][pLFoot] < 50)
        {
            ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0);
        }
    }
    /* Job Mixer */
	if(PRESSED(KEY_YES) && IsPlayerInRangeOfPoint(playerid, 2.0, 641.2187,1238.3390,11.6796))
    {
		if(jobs::mixer[playerid][mixerDuty][0]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sudah memulai pekerjaan");
        if(GetPlayerJob(playerid) != JOB_DRIVER_MIXERS) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan pekerja supir mixer");
        jobs::mixer[playerid][mixerVehicle] = CreateVehicle(524, 639.8187,1250.2065,11.6333,306.5278, 5, 5, 60000, false);
		if(IsValidVehicle(jobs::mixer[playerid][mixerVehicle]))
		{
			VehicleCore[jobs::mixer[playerid][mixerVehicle]][vCoreFuel]=MAX_FUEL_FULL;
		    PutPlayerInVehicle(playerid, jobs::mixer[playerid][mixerVehicle], 0);
			jobs::mixer[playerid][mixerDuty][0] = true;
		}
        ShowPlayerFooter(playerid, "~w~~h~Isi kendaraan dengan ~g~beton ~w~di~n~belakang", 3000, 1);
    }
    if(PRESSED(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInRangeOfPoint(playerid, 3.0, 590.0992,1243.8767,11.7188))
    {
        if(GetPlayerJob(playerid) != JOB_DRIVER_MIXERS) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan pekerja supir mixer");
        ShowMixTD(playerid);
    }
    if (newkeys & KEY_YES && OpenVote == 1 && !PlayerVoting[playerid] && !AccountData[playerid][ActivityTime])
    {

        ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda Setuju untuk Voting yang sedang berjalan");

        PlayerVoting[playerid] = true;
        VoteYes += 1;
        SendClientMessageToAllEx(-1, ""YELLOW"VOTE:"WHITE" %s // Yes: "GREEN"%d"WHITE" // No: "RED"%d", VoteText, VoteYes, VoteNo);
        SendClientMessageToAllEx(-1, "~> Gunakan "GREEN"Y"WHITE" untuk Yes & "RED"N"WHITE" untuk Tidak");
    }

    if (newkeys & KEY_NO && OpenVote == 1 && !PlayerVoting[playerid] && !AccountData[playerid][ActivityTime])
    {

        ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda Tidak Setuju untuk Voting yang sedang berjalan");

        PlayerVoting[playerid] = true;
        VoteNo += 1;
        SendClientMessageToAllEx(-1, ""YELLOW"VOTE:"WHITE" %s // Yes: "GREEN"%d"WHITE" // No: "RED"%d", VoteText, VoteYes, VoteNo);
        SendClientMessageToAllEx(-1, "~> Gunakan "GREEN"Y"WHITE" untuk Yes & "RED"N"WHITE" untuk Tidak");
    }

    if (newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED && !AccountData[playerid][pInjured])
    {
        ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0);
    }
    if((newkeys & KEY_JUMP) && !IsPlayerInAnyVehicle(playerid))
    {
        JoueurAppuieJump[playerid] ++;
        SetTimerEx("AppuiePasJump", 4000, false, "i", playerid);

        if(JoueurAppuieJump[playerid] == 3)
        {
            new Float: POS[3];
			GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
			SetPlayerPos(playerid, POS[0], POS[1], POS[2] - 0.2);
			ApplyAnimationEx(playerid, "PED", "FALL_collapse", 4.1, 0, 1, 0, 0, 0, 1); // applies the fallover animation
			PlayerPlayNearbySound(playerid, 1163);
			JoueurAppuieJump[playerid] = 0;
        }
    }
    if (newkeys & KEY_YES && AccountData[playerid][pInjured])
    {
        Dialog_Show(playerid, DeathRespawnConf, DIALOG_STYLE_MSGBOX, ""NEXODUS"Croire Roleplay "WHITE"- Konfirmasi Koma",
                    "Apakah anda benar benar yakin ingin melakukan tindakan ini?\n"RED"NOTE: Tindakan ini dapat menghilangkan semua barang di tas termasuk uang cash", "Iya", "Tidak");
    }
    if (newkeys & KEY_SECONDARY_ATTACK && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        foreach (new famid : Families)
        {
            if (IsPlayerInRangeOfPoint(playerid, 2.5, FamData[famid][famExtPos][0], FamData[famid][famExtPos][1], FamData[famid][famExtPos][2]))
            {
                if (IsDoorMyFamilie(playerid) == AccountData[playerid][pFamily])
                {
                    if (FamData[famid][famIntPos][0] == 0.0 && FamData[famid][famIntPos][1] == 0.0 && FamData[famid][famIntPos][2] == 0.0)
                        return ShowTDN(playerid, NOTIFICATION_ERROR, "Interior ini masih kosong!");

                    if (AccountData[playerid][pFaction] == FACTION_NONE)
                        if (AccountData[playerid][pFamily] == -1)
                            return ShowTDN(playerid, NOTIFICATION_ERROR, "Kamu tidak memiliki Akses untuk masuk kedalam sini!");

                    AccountData[playerid][UsingDoor] = true;
                    Player_ToggleTelportAntiCheat(playerid, false);
                    SetPlayerPositionEx(playerid, FamData[famid][famIntPos][0], FamData[famid][famIntPos][1], FamData[famid][famIntPos][2], FamData[famid][famIntPos][3], 5000);

                    SetPlayerInterior(playerid, FamData[famid][famInterior]);
                    SetPlayerVirtualWorld(playerid, famid);
                    SetCameraBehindPlayer(playerid);
                    SetPlayerWeather(playerid, 0);
                    AccountData[playerid][pInFamily] = famid;
                }
                else ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan bagian dari Families ini!");
            }
            new infamily = AccountData[playerid][pInFamily];
            if (AccountData[playerid][pInFamily] != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, FamData[infamily][famIntPos][0], FamData[infamily][famIntPos][1], FamData[infamily][famIntPos][2]))
            {
                AccountData[playerid][pInFamily] = -1;
                AccountData[playerid][UsingDoor] = true;
                Player_ToggleTelportAntiCheat(playerid, false);
                SetPlayerPositionEx(playerid, FamData[infamily][famExtPos][0], FamData[infamily][famExtPos][1], FamData[infamily][famExtPos][2], FamData[infamily][famExtPos][3], 5000);

                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetCameraBehindPlayer(playerid);
                SetPlayerWeather(playerid, WorldWeather);
                Player_ToggleTelportAntiCheat(playerid, true);
            }
        }
    }
    if ((newkeys & KEY_NO) && aOfferID[playerid] == INVALID_PLAYER_ID)
    {
        if (AccountData[playerid][ActivityTime] != 0) return ShowTDN(playerid, NOTIFICATION_WARNING, "Tidak dapat membuka radial saat actvitity berjalan!");

        ShowPlayerRadialNew(playerid, true);
    }
    if (newkeys & KEY_LOOK_BEHIND)
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) return 0;

        new vehid = GetNearestVehicleToPlayer(playerid, 3.0, false);
        if (vehid == INVALID_VEHICLE_ID) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada kendaraan apapun di sekitar!");

        foreach (new iter : PvtVehicles)
        {
            if (PlayerVehicle[iter][pVehExists])
            {
                if (PlayerVehicle[iter][pVehPhysic] == vehid)
                {
                    if (PlayerVehicle[iter][pVehOwnerID] != AccountData[playerid][pID]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini bukan milik anda!");

                    PlayerPlaySound(playerid, 1147, 0.0, 0.0, 0.0);
                    PlayerVehicle[iter][pVehLocked] = !(PlayerVehicle[iter][pVehLocked]);

                    PlayerPlayNearbySound(playerid, SOUND_LOCK_CAR_DOOR);
                    LockVehicle(PlayerVehicle[iter][pVehPhysic], PlayerVehicle[iter][pVehLocked]);
                    ToggleVehicleLights(PlayerVehicle[iter][pVehPhysic], PlayerVehicle[iter][pVehLocked]);
                    GameTextForPlayer(playerid, sprintf("~w~%s %s", GetVehicleName(PlayerVehicle[iter][pVehPhysic]), PlayerVehicle[iter][pVehLocked] ? ("~r~Locked") : ("~g~Unlocked")), 4000, 4);
                    return 1;
                }
            }
        }

        if (AccountData[playerid][pJobVehicle] != 0)
        {
            if (vehid == JobVehicle[AccountData[playerid][pJobVehicle]][Vehicle])
            {
                PlayerPlaySound(playerid, 1147, 0.0, 0.0, 0.0);
                JobVehicle[AccountData[playerid][pJobVehicle]][Locked] = !(JobVehicle[AccountData[playerid][pJobVehicle]][Locked]);

                PlayerPlayNearbySound(playerid, SOUND_LOCK_CAR_DOOR);
                LockVehicle(JobVehicle[AccountData[playerid][pJobVehicle]][Vehicle], JobVehicle[AccountData[playerid][pJobVehicle]][Locked]);
                ToggleVehicleLights(JobVehicle[AccountData[playerid][pJobVehicle]][Vehicle], JobVehicle[AccountData[playerid][pJobVehicle]][Locked]);
                GameTextForPlayer(playerid, sprintf("~w~%s %s", GetVehicleName(JobVehicle[AccountData[playerid][pJobVehicle]][Vehicle]), JobVehicle[AccountData[playerid][pJobVehicle]][Locked] ? ("~r~Locked") : ("~g~Unlocked")), 4000, 4);
            }
            return 1;
        }

        if (PlayerElectricJob[playerid][ElectricVehicle] == vehid)
        {
            PlayerPlaySound(playerid, 1147, 0.0, 0.0, 0.0);
            PlayerElectricJob[playerid][ElectricLocked] = !(PlayerElectricJob[playerid][ElectricLocked]);

            PlayerPlayNearbySound(playerid, SOUND_LOCK_CAR_DOOR);
            LockVehicle(PlayerElectricJob[playerid][ElectricVehicle], PlayerElectricJob[playerid][ElectricLocked]);
            ToggleVehicleLights(PlayerElectricJob[playerid][ElectricVehicle], PlayerElectricJob[playerid][ElectricLocked]);
            GameTextForPlayer(playerid, sprintf("~w~%s %s", GetVehicleName(PlayerElectricJob[playerid][ElectricVehicle]), PlayerElectricJob[playerid][ElectricLocked] ? ("~r~Locked") : ("~g~Unlocked")), 4000, 4);
            return 1;
        }
    }
    if (newkeys & KEY_CTRL_BACK && IsPlayerInjured(playerid))
    {
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    if (newkeys & KEY_NO && AccountData[playerid][pInjured])
    {
        if (SignalExists[playerid]) return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda sudah mengirim signal, tunggu hingga EMS merespon!");

        GetPlayerPos(playerid, SignalPos[playerid][0], SignalPos[playerid][1], SignalPos[playerid][2]);
        SignalExists[playerid] = true;
        SignalTimer[playerid] = 120;
        ShowTDN(playerid, NOTIFICATION_SUKSES, "Berhasil mengirim sinyal kepada EMS!");
        foreach(new i : Player) if (AccountData[i][pSpawned] && AccountData[i][pFaction] == FACTION_EMS) if (AccountData[i][pDutyEms])
            {
                SendClientMessageEx(i, -1, ""RED"[Emergency Signal]"WHITE" Signal terlah diterima dari daerah "YELLOW"%s", GetLocation(SignalPos[playerid][0], SignalPos[playerid][1], SignalPos[playerid][2]));
                Info(i, "Buka Smartphone ~> GPS ~> Signal Emergency (EMS) jika ingin merespon signal");
            }
    }
    //-----[ Toll System ]-----
    if (newkeys & KEY_CROUCH)
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            // new forcount = MuchNumber(sizeof(BarrierInfo));
            // for(new i = 0; i < forcount;i ++)
            // {
            // 	if(i < sizeof(BarrierInfo))
            // 	{
            // 		if(IsPlayerInRangeOfPoint(playerid,8.0,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]))
            // 		{
            // 			if(BarrierInfo[i][brOrg] == TEAM_NONE)
            // 			{
            // 				if(!BarrierInfo[i][brOpen])
            // 				{
            // 					if(AccountData[playerid][pMoney] < 100 && !IsVehicleFaction(GetPlayerVehicleID(playerid)))
            // 					{
            // 						ShowTDN(playerid, NOTIFICATION_INFO, "Anda membutuhkan "YELLOW"$100"WHITE" untuk membayar Toll");
            // 					}
            // 					else if(IsVehicleFaction(GetPlayerVehicleID(playerid)))
            // 					{
            // 						MoveDynamicObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
            // 						SetTimerEx("BarrierClose",15000,0,"i",i);
            // 						PlayStream(playerid, "https://h.top4top.io/m_3355h5iw11.mp3", BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]);
            // 						BarrierInfo[i][brOpen] = true;
            // 						ShowTDN(playerid, NOTIFICATION_INFO, "Hati hati dijalan, Pintu akan tertutup selama 15 detik");
            // 						if(BarrierInfo[i][brForBarrierID] != -1)
            // 						{
            // 							new barrierid = BarrierInfo[i][brForBarrierID];
            // 							MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[barrierid][brPos_A]+180);
            // 							BarrierInfo[barrierid][brOpen] = true;
            // 						}
            // 					}
            // 					else
            // 					{
            // 						MoveDynamicObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
            // 						SetTimerEx("BarrierClose",15000,0,"i",i);
            // 						PlayStream(playerid, "https://h.top4top.io/m_3355h5iw11.mp3", BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]);
            // 						BarrierInfo[i][brOpen] = true;
            // 						ShowTDN(playerid, NOTIFICATION_INFO, "Hati hati dijalan, Pintu akan tertutup selama 15 detik");
            // 						ShowItemBox(playerid, "Removed $100", "Uang", 1212);
            // 						TakePlayerMoneyEx(playerid, 100);
            // 						if(BarrierInfo[i][brForBarrierID] != -1)
            // 						{
            // 							new barrierid = BarrierInfo[i][brForBarrierID];
            // 							MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[barrierid][brPos_A]+180);
            // 							BarrierInfo[barrierid][brOpen] = true;
            // 						}
            // 					}
            // 				}
            // 			}
            // 			else ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak dapat membuka toll ini!");
            // 			break;
            // 		}
            // 	}
            // }
        }
    }
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if ((oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER) && AccountData[playerid][pTogAutoEngine])
    {
        if (!GetEngineStatus(vehicleid))
        {
            if (IsEngineVehicle(vehicleid) && !IsADealerVehicle(playerid, vehicleid))
            {
                AccountData[playerid][pTurningEngine] = true;
                SetTimerEx("EngineStatus", 2500, false, "id", playerid, vehicleid);
                SendRPMeAboveHead(playerid, "Mencoba menghidupkan mesin kendaraan", X11_PLUM1);
            }
        }
    }
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	    if(IsABike(GetPlayerVehicleID(playerid)))
	    {
			switch(GetPlayerSkin(playerid))
			{
		        #define SPAO{%0,%1,%2,%3,%4,%5} SetPlayerAttachedObject(playerid, SLOTHELM, 18645, 2, (%0), (%1), (%2), (%3), (%4), (%5));
				case 0, 65, 74, 149, 208, 273:  SPAO{0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000}
				case 1..6, 8, 14, 16, 22, 27, 29, 33, 41..49, 82..84, 86, 87, 119, 289: SPAO{0.070000, 0.000000, 0.000000, 88.000000, 77.000000, 0.000000}
				case 7, 10: SPAO{0.090000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
				case 9: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
				case 11..13: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
				case 15: SPAO{0.059999, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
				case 17..21: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 23..26, 28, 30..32, 34..39, 57, 58, 98, 99, 104..118, 120..131: SPAO{0.079999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 40: SPAO{0.050000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 50, 100..103, 148, 150..189, 222: SPAO{0.070000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 51..54: SPAO{0.100000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 55, 56, 63, 64, 66..73, 75, 76, 78..81, 133..143, 147, 190..207, 209..219, 221, 247..272, 274..288, 290..293: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 59..62: SPAO{0.079999, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 77: SPAO{0.059999, 0.019999, 0.000000, 87.000000, 82.000000, 0.000000}
				case 85, 88, 89: SPAO{0.070000, 0.039999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 90..97: SPAO{0.050000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 132: SPAO{0.000000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 144..146: SPAO{0.090000, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
				case 220: SPAO{0.029999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 223, 246: SPAO{0.070000, 0.050000, 0.000000, 88.000000, 82.000000, 0.000000}
				case 224..245: SPAO{0.070000, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 294: SPAO{0.070000, 0.019999, 0.000000, 91.000000, 84.000000, 0.000000}
				case 295: SPAO{0.050000, 0.019998, 0.000000, 86.000000, 82.000000, 0.000000}
				case 296..298: SPAO{0.064999, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
				case 299: SPAO{0.064998, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		    }
		}
	}
	else
	{
		RemovePlayerAttachedObject(playerid, SLOTHELM);
	}

    if (newstate == PLAYER_STATE_WASTED && AccountData[playerid][pJail] < 1)
    {
        if (IsPlayerInEvent(playerid))
            return 1;

        SetPlayerArmedWeapon(playerid, 0);
        ResetPlayer(playerid);

        if (!AccountData[playerid][pInjured] && !IsPlayerInEvent(playerid))
        {
            AccountData[playerid][pInjured] = 1;
            AccountData[playerid][pInjuredTime] = 1800;

            AccountData[playerid][pInt] = GetPlayerInterior(playerid);
            AccountData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, AccountData[playerid][pPosA]);
        }
    }
    //Spec Player
    if (newstate == PLAYER_STATE_ONFOOT)
    {
        if (AccountData[playerid][playerSpectated] != 0)
        {
            foreach (new ii : Player)
            {
                if (AccountData[ii][pSpec] == playerid)
                {
                    PlayerSpectatePlayer(ii, playerid);
                    SendClientMessageEx(ii, -1, ""YELLOW"SPEC:"WHITE" %s(%d) sekarang berjalan kaki.", AccountData[playerid][pName], playerid);
                }
            }
        }
    }
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if(!CompassVisible[playerid])
        {
            CompassVisible[playerid] = true;
	        GetPlayerFacingAngle(playerid, LastAngle[playerid]);
	        for(new i = 0; i < 11; i++)
	        {
	            PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
	        }
	        for(new i = 0; i < 12; i++)
            {
                PlayerTextDrawHide(playerid, LogoCroire[playerid][i]);
            }
	        CompassTimer[playerid] = SetTimerEx("Compass_UpdateTimer", 50, true, "i", playerid);
        }
    }
    if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
    {
        if(CompassVisible[playerid])
        {
            CompassVisible[playerid] = false;
            for(new i = 0; i < 11; i++)
            {
                PlayerTextDrawHide(playerid, JADENCOMPAS[playerid][i]);
            }
            for(new i = 0; i < 12; i++)
            {
                PlayerTextDrawShow(playerid, LogoCroire[playerid][i]);
            }
            if(CompassTimer[playerid])
            {
                KillTimer(CompassTimer[playerid]);
                CompassTimer[playerid] = 0;
            }
        }
    }
    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if (AccountData[playerid][pInjured] == 1)
        {
            //RemoveFromVehicle(playerid);
            RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 99999);
        }
        foreach (new ii : Player) if (AccountData[ii][pSpec] == playerid)
        {
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
    }

    new vehicle_index = -1;
    if ((vehicle_index = Vehicle_ReturnID(vehicleid)) != -1)
    {
        if ((newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) && PlayerVehicle[vehicle_index][vehAudio])
        {
            PlayVehicleAudio(playerid, vehicle_index);
        }
    }

    if ((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && AccountData[playerid][pVehAudioPlay])
    {
        StopAudioStreamForPlayer(playerid);
        AccountData[playerid][pVehAudioPlay] = 0;
    }
    if (oldstate == PLAYER_STATE_DRIVER)
    {
        if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);/*RemoveFromVehicle(playerid);*/

        tHBEDITZY(playerid, true);
        //forex(i, 45) PlayerTextDrawShow(playerid, HbeStuffs[playerid][i]);
        for(new i = 0; i < 65; i++)
		{
			PlayerTextDrawHide(playerid, speedoBaru[playerid][i]);
		}
    }
    else if (newstate == PLAYER_STATE_DRIVER)
    {
        static pviterid = -1;

        if ((pviterid = Vehicle_Nearest2(playerid)) != -1)
        {
            if (IsABike(PlayerVehicle[pviterid][pVehPhysic]) || GetVehicleModel(PlayerVehicle[pviterid][pVehPhysic]) == 424)
            {
                if (PlayerVehicle[pviterid][pVehLocked])
                {
                    RemovePlayerFromVehicle(playerid);
                    ClearAnimations(playerid, 1);
                    ShowTDN(playerid, NOTIFICATION_ERROR, "Kendaraan ini terkunci!");
                    return 1;
                }
            }
        }
        if (!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
        tHBEDITZY(playerid, false);
        //forex(i, 45) PlayerTextDrawHide(playerid, HbeStuffs[playerid][i]);
        for(new i = 0; i < 65; i++)
		{
			PlayerTextDrawShow(playerid, speedoBaru[playerid][i]);
		}
        new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;

        if (AccountData[playerid][playerSpectated] != 0)
        {
            foreach (new ii : Player)
            {
                if (AccountData[ii][pSpec] == playerid)
                {
                    PlayerSpectateVehicle(ii, vehicleid);
                    SendClientMessageEx(ii, -1, ""YELLOW"SPEC:"WHITE" %s(%d) sekarang mengendarai %s(%d).", AccountData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
                }
            }
        }
        SetPVarInt(playerid, "LastVehicleID", vehicleid);
    }
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    switch (weaponid)
    {
        case 0..18, 39..54:
            return 1;   //invalid weapons
    }
    if(hittype == BULLET_HIT_TYPE_PLAYER && IsPlayerConnected(hitid) && !IsPlayerNPC(hitid))
    {
                new Float:Shot[3], Float:Hit[3];
                GetPlayerLastShotVectors(playerid, Shot[0], Shot[1], Shot[2], Hit[0], Hit[1], Hit[2]);

                new playersurf = GetPlayerSurfingVehicleID(playerid);
                new hitsurf = GetPlayerSurfingVehicleID(hitid);
                new Float:targetpackets = NetStats_PacketLossPercent(hitid);
                new Float:playerpackets = NetStats_PacketLossPercent(playerid);

                if(~(playersurf) && ~(hitsurf) && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(hitid))
                {
                        if(!IsPlayerAimingAtPlayer(playerid, hitid) && !IsPlayerInRangeOfPoint(hitid, 5.0, Hit[0], Hit[1], Hit[2]))
                        {
                                new string[128], issuer[24];
                                GetPlayerName(playerid, issuer, 24);
                                AimbotWarnings[playerid] ++;

                                format(string, sizeof(string), "{FFFFFF}Player %s warning of aimbot or lag [Target PL: %f | Shooter PL:%f]!", issuer, targetpackets, playerpackets);

                                for(new p; p < MAX_PLAYERS;p++)
                                    if(IsPlayerConnected(p) && AccountData[p][pAdmin])
                                         SendClientMessage(p, -1, string);

                                if(AimbotWarnings[playerid] > 10)
                                {
                                        if(targetpackets < 1.2 && playerpackets < 1.2) return Kick(playerid);
                                        else
                                        {
                                                format(string, sizeof(string), "{FFFFFF}Player %s is probably using aimbot [Target PL: %f | Shooter PL:%f]!", issuer, targetpackets, playerpackets);
                                                for(new p; p < MAX_PLAYERS;p++) if(IsPlayerConnected(p) && AccountData[p][pAdmin]) SendClientMessage(p, -1, string);
                                        }
                                }
                                return 0;
                        }
                        else return 1;
                }
                else return 1;
	}

    if (1 <= weaponid <= 46 && AccountData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
    {
        AccountData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
        if (AccountData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !AccountData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
        {
            AccountData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
        }
    }

    if(AccountData[playerid][newCitizen]) {
        SetPlayerArmedWeapon(playerid, 0);
    }

    if (PlayerHasTazer(playerid) && AccountData[playerid][pFaction] == FACTION_POLISI)
    {
        SetPlayerArmedWeapon(playerid, 0);
        PlayerPlayNearbySound(playerid, 6003);
    }
    /*foreach(new i : Player)
	{
		if(GetPlayerFaction(i) != FACTION_POLISI)
		{
 			new atext[20];
			if(AccountData[playerid][pGender] == 1) atext = "Male";
			else atext = "Female";
            new Float:fXs;
			new Float:fYs;
			new Float:fZs;
			GetPlayerPos(playerid, fXs, fYs, fZs);
			PlayerTextDrawSetString(i, ShotsTD[playerid][19], sprintf("Gender: %s", atext));
			PlayerTextDrawSetString(i, ShotsTD[playerid][21], sprintf("Weapon: %s", GetWeaponNames(weaponid)));
        	PlayerTextDrawSetString(i, ShotsTD[playerid][16], sprintf("Location: %s", GetLocationTD(Float:fXs, Float:fYs, Float:fZs)));
		    for(new igh; igh < 23; igh++)
			{
				PlayerTextDrawShow(i, ShotsTD[playerid][igh]);
			}

	        SetTimerEx("HideShotTD", 5000, false, "i", playerid);
		}
	}*/
    return 1;
}

stock GivePlayerHealth(playerid, Float:Health)
{
    new Float:health;
    GetPlayerHealth(playerid, health);
    SetPlayerHealth(playerid, health + Health);
}

/*public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
new Float: vehicleHealth,
        playerVehicleId = GetPlayerVehicleID(playerid);

    new Float:health = GetPlayerHealth(playerid, health);
    GetVehicleHealth(playerVehicleId, vehicleHealth);
    if(AccountData[playerid][pSeatBelt] == 0 || AccountData[playerid][pHelmetOn] == 0)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		AccountData[playerid][pLFoot] -= csakit;
    		AccountData[playerid][pLHand] -= bsakit;
    		AccountData[playerid][pRFoot] -= csakit;
    		AccountData[playerid][pRHand] -= bsakit;
    		AccountData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{,
        bool:pProgress
    		new asakit = RandomEx(0, 2);
    		new bsakit = RandomEx(0, 2);
    		new csakit = RandomEx(0, 2);
    		new dsakit = RandomEx(0, 2);
    		AccountData[playerid][pLFoot] -= dsakit;
    		AccountData[playerid][pLHand] -= bsakit;
    		AccountData[playerid][pRFoot] -= csakit;
    		AccountData[playerid][pRHand] -= dsakit;
    		AccountData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -2);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 3);
    		new bsakit = RandomEx(0, 3);
    		new csakit = RandomEx(0, 3);
    		new dsakit = RandomEx(0, 3);
    		AccountData[playerid][pLFoot] -= csakit;
    		AccountData[playerid][pLHand] -= csakit;
    		AccountData[playerid][pRFoot] -= dsakit;
    		AccountData[playerid][pRHand] -= bsakit;
    		AccountData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -5);
    		return 1;
    	}
    	return 1;
    }
    if(AccountData[playerid][pSeatBelt] == 1 || AccountData[playerid][pHelmetOn] == 1)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		AccountData[playerid][pLFoot] -= csakit;
    		AccountData[playerid][pLHand] -= bsakit;
    		AccountData[playerid][pRFoot] -= csakit;
    		AccountData[playerid][pRHand] -= bsakit;
    		AccountData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		AccountData[playerid][pLFoot] -= dsakit;
    		AccountData[playerid][pLHand] -= bsakit;
    		AccountData[playerid][pRFoot] -= csakit;
    		AccountData[playerid][pRHand] -= dsakit;
    		AccountData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		AccountData[playerid][pLFoot] -= csakit;
    		AccountData[playerid][pLHand] -= csakit;
    		AccountData[playerid][pRFoot] -= dsakit;
    		AccountData[playerid][pRHand] -= bsakit;
    		AccountData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -3);
    		return 1;
    	}
    }
    return 1;
}*/

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(damagedid)) return 1;
    if(GetPlayerInterior(playerid) != GetPlayerInterior(damagedid) || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(damagedid))

    if (damagedid != INVALID_PLAYER_ID && weaponid == WEAPON_CHAINSAW)
    {
        TogglePlayerControllable(playerid, 0);
        SetPlayerArmedWeapon(playerid, 0);
        TogglePlayerControllable(playerid, 1);
        SetCameraBehindPlayer(playerid);

        SetPVarInt(playerid, "ChainsawWarning", GetPVarInt(playerid, "ChainsawWarning") + 1);

        if (GetPVarInt(playerid, "ChainsawWarning") == 3)
        {
            SendClientMessageToAllEx(X11_RED, "[AntiCheat]:"YELLOW" %s(%d)"LIGHTGREY" telah ditendang dari server karena Abusing Chainsaw!", ReturnName(playerid), playerid);
            DeletePVar(playerid, "ChainsawWarning");
            KickEx(playerid);
        }
    }
    else if (damagedid != INVALID_PLAYER_ID)
    {
        AccountData[damagedid][pLastShot] = playerid;
        AccountData[damagedid][pShotTime] = gettime();
        if (AccountData[playerid][pFaction] == FACTION_POLISI && PlayerHasTazer(playerid) && !AccountData[damagedid][pStunned])
        {
            if (GetPlayerState(damagedid) != PLAYER_STATE_ONFOOT)
                return ShowTDN(playerid, NOTIFICATION_ERROR, "Pemain tersebut harus keadaan onfoot untuk dilumpuhkan!");

            if (GetPlayerDistanceFromPlayer(playerid, damagedid) > 5.0)
                return ShowTDN(playerid, NOTIFICATION_ERROR, "Kamu harus lebih dekat untuk melumpuhkan pemain tersebut!");

            AccountData[damagedid][pStunned] = 10;
            TogglePlayerControllable(damagedid, 0);

            ApplyAnimation(damagedid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
            ShowTDN(damagedid, NOTIFICATION_WARNING, "Kamu terkena stun gun / taser!");
        }
    }
    new Float:ax, Float:ay, Float:az;
    GetPlayerPos(playerid, ax, ay, az);

    new Float:dx, Float:dy, Float:dz;
    GetPlayerPos(damagedid, dx, dy, dz);

    new Float:dist = GetDistanceBetweenPoints(ax, ay, az, dx, dy, dz);

    // Batas jarak yang dianggap mencurigakan (misalnya > 60 meter)
    if(dist > 60.0)
    {
        new string[128];
        format(string, sizeof(string), "[ANTICHEAT] %s (ID:%d) menyerang dari jarak jauh (%.2fm)! Mungkin menggunakan Wall Hack!", GetPlayerNameEx(playerid), playerid, dist);
        SendClientMessageToAll(0xFF9900FF, string);

        // Bisa juga Freeze / Ban / Kick
        // FreezePlayer(attackerid); atau Kick(attackerid);
    }
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new Float: health;
    GetPlayerHealth(playerid, health);
    new Text3D:bar3D, damageStr[HEALTH_LENGTH];
    valstr(damageStr, floatround(amount));
    bar3D = Create3DTextLabel(damageStr, COLOR_BAR, 0.0, 0.0, 0.0, HEALTH_DRAW, 0);
    Attach3DTextLabelToPlayer(bar3D, playerid, 0.0, 0.0, HEALTH_OFFSET);
    SetTimerEx("UpdateDamageBar", TIME_FIRST, 0, "iiffii", playerid, _:bar3D, amount, HEALTH_OFFSET, 16, COLOR_BAR);
    if (!IsPlayerInEvent(playerid))
    {
        new sakit = RandomEx(1, 4);
        new asakit = RandomEx(1, 5);
        new bsakit = RandomEx(1, 7);
        new csakit = RandomEx(1, 4);
        if (issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
        {
            AccountData[playerid][pHead] -= 20;
        }
        if (issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 3)
        {
            AccountData[playerid][pPerut] -= sakit;
        }
        if (issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 6)
        {
            AccountData[playerid][pRHand] -= bsakit;
        }
        if (issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 5)
        {
            AccountData[playerid][pLHand] -= asakit;
        }
        if (issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 8)
        {
            AccountData[playerid][pRFoot] -= csakit;
        }
        if (issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 7)
        {
            AccountData[playerid][pLFoot] -= bsakit;
        }
    }
    if (issuerid != INVALID_PLAYER_ID && bodypart == 3 && weaponid >= 22 && weaponid <= 45)
    {
        static Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        foreach (new i : Player) if (IsPlayerConnected(i)) if (SQL_IsCharacterLogged(i))
                {
                    if (AccountData[i][pFaction] == FACTION_POLISI && AccountData[i][pDutyPD])
                    {
                        SendClientMessageEx(i, X11_ORANGE1, "[WAR ALERT]"WHITE" Terdeteksi penembakan di daerah %s.", GetLocation(x, y, z));
                        new atext[20];
						if(AccountData[issuerid][pGender] == 1) atext = "Male";
						else atext = "Female";
						PlayerTextDrawSetString(i, ShotsTD[playerid][19], sprintf("Gender: %s", atext));
						PlayerTextDrawSetString(i, ShotsTD[playerid][21], sprintf("Weapon: %s", GetWeaponNames(weaponid)));
			        	PlayerTextDrawSetString(i, ShotsTD[playerid][16], sprintf("Location: %s", GetLocation(x, y, z)));
					    for(new igh; igh < 23; igh++)
						{
							PlayerTextDrawShow(i, ShotsTD[i][igh]);
						}

				        SetTimerEx("HideShotTD", 5000, false, "i", i);
                    }
                }
    }
    
    return 1;
}

public OnPlayerUpdate(playerid)
{
    if (!AccountData[playerid][pSpawned])
        return 0;

    static s_Keys, s_UpDown, s_LeftRight;
    GetPlayerKeys(playerid, s_Keys, s_UpDown, s_LeftRight);

    if (AccountData[playerid][pFreeze] && (s_Keys || s_UpDown || s_LeftRight))
        return 0;
    
    CheckPlayerInSpike(playerid);
    return 1;
}

task VehicleUpdate[30000]()
{
    for (new i = 1; i != MAX_VEHICLES; i ++) if (IsEngineVehicle(i) && GetEngineStatus(i))
        {
            if (GetFuel(i) > 0)
            {
                VehicleCore[i][vCoreFuel] --;
                if (GetFuel(i) <= 0)
                {
                    SwitchVehicleEngine(i, false);
                    VehicleCore[i][vCoreFuel] = 0;
                }
            }
        }
    return 1;
}

timer Vehicle_UpdatePosition[2000](vehicleid)
{
    new Float:x,
        Float:y,
        Float:z,
        Float:a;

    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);

    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, a);
    return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    new vehicle_index; // Index = Vehicle id ingame, vehicleid = Index DB
    vehicle_index = Vehicle_ReturnID(vehicleid);
    if (vehicle_index != -1)
    {
        new panels, doors, lights, tires;
        GetVehicleDamageStatus(PlayerVehicle[vehicle_index][pVehPhysic], panels, doors, lights, tires);
        if (PlayerVehicle[vehicle_index][pVehBodyUpgrade] == 3 && PlayerVehicle[vehicle_index][pVehBodyRepair] > 0)
        {
            panels = doors = lights = tires = 0;
            UpdateVehicleDamageStatus(PlayerVehicle[vehicle_index][pVehPhysic], panels, doors, lights, tires);
            PlayerVehicle[vehicle_index][pVehBodyRepair] -= 50.0;
        }
        else if (PlayerVehicle[vehicle_index][pVehBodyRepair] <= 0)
        {
            PlayerVehicle[vehicle_index][pVehBodyRepair] = 0;
        }
    }
    if(GetPlayerJob(playerid) == JOB_DRIVER_MIXERS)
	{
		if(jobs::mixer[playerid][mixerSlump] > 0 && IsValidVehicle(vehicleid))
		{
			new rand = RandomEx(2,4);
			jobs::mixer[playerid][mixerSlump]-=rand;

			new Float: progressvalue;
			progressvalue = jobs::mixer[playerid][mixerSlump]*61/100;
			PlayerTextDrawTextSize(playerid, jobs::PBMixer[playerid], progressvalue, 13.0);
			PlayerTextDrawShow(playerid, jobs::PBMixer[playerid]);
		}
	}
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    new Float:vhealth;

    AntiCheatGetVehicleHealth(vehicleid, vhealth);
    SetVehicleHealth(vehicleid, vhealth);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    defer Vehicle_UpdatePosition(vehicleid);

    for (new vid = 1; vid < sizeof(JobVehicle); vid ++) if (JobVehicle[vid][Vehicle] != INVALID_VEHICLE_ID)
        {
            if (vehicleid == JobVehicle[vid][Vehicle])
            {
                foreach (new i : Player)
                {
                    if (AccountData[i][pJobVehicle] == JobVehicle[vid][Vehicle])
                    {
                        if (AccountData[i][pJobVehicle] != 0)
                        {
                            DestroyJobVehicle(i);
                            AccountData[i][pJobVehicle] = 0;
                            break;
                        }
                    }
                }
            }
        }

    foreach(new i : PvtVehicles) if (vehicleid == PlayerVehicle[i][pVehPhysic] && IsValidVehicle(PlayerVehicle[i][pVehPhysic]))
    {
        if (PlayerVehicle[i][pVehRental] == -1)
        {
            PlayerVehicle[i][pVehInsuranced] = true;

            foreach(new pid : Player) if (PlayerVehicle[i][pVehOwnerID] == AccountData[pid][pID])
            {
                Syntax(pid, "Kendaraan anda rusak dan sudah dikirimkan ke Asuransi!");
            }

            for (new slot = 0; slot < MAX_VEHICLE_OBJECT; slot ++) if (VehicleObjects[i][slot][vehObjectExists])
                {
                    if (VehicleObjects[i][slot][vehObject] != INVALID_STREAMER_ID)
                        DestroyDynamicObject(VehicleObjects[i][slot][vehObject]);

                    VehicleObjects[i][slot][vehObject] = INVALID_STREAMER_ID;
                }

            if (IsValidVehicle(PlayerVehicle[i][pVehPhysic]))
                DestroyVehicle(PlayerVehicle[i][pVehPhysic]);

            PlayerVehicle[i][pVehPhysic] = INVALID_VEHICLE_ID;
        }
        else
        {
            PlayerVehicle[i][pVehRental] = -1;
            PlayerVehicle[i][pVehRentTime] = 0;
            PlayerVehicle[i][pVehExists] = false;

            foreach(new pid : Player) if (PlayerVehicle[i][pVehOwnerID] == AccountData[pid][pID])
            {
                Info(pid, "Kendaaraanmu rental anda telah hancur. Anda dikenakan denda sebesar "GREEN"%s!", FormatMoney(PlayerVehicle[i][pVehPrice] / 2));
                TakePlayerMoneyEx(pid, (PlayerVehicle[i][pVehPrice] / 2));
            }

            if (IsValidVehicle(PlayerVehicle[i][pVehPhysic]))
            {
                DestroyVehicle(PlayerVehicle[i][pVehPhysic]);
                PlayerVehicle[i][pVehPhysic] = INVALID_VEHICLE_ID;
            }

            new cQuery[200];
            mysql_format(g_SQL, cQuery, sizeof(cQuery), "DELETE FROM `player_vehicles` WHERE `id` = '%d'", PlayerVehicle[i][pVehID]);
            mysql_tquery(g_SQL, cQuery);

            Vehicle_ResetVariable(i);
            Iter_SafeRemove(PvtVehicles, i, i);
        }
    }

    //ini untuk menghapus kendaraan yang dispawn oleh admin
    if (VehicleCore[vehicleid][vehAdmin])
    {
        DestroyVehicle(VehicleCore[vehicleid][vehAdminPhysic]);
        VehicleCore[vehicleid][vehAdminPhysic] = INVALID_VEHICLE_ID;
        VehicleCore[vehicleid][vehAdmin] = false;
    }
    return 1;
}

public OnVehicleSirenStateChange(playerid, vehicleid, newstate)
{
    if (newstate)
    {
        SwitchVehicleLight(vehicleid, true);
        vehicleid = GetPlayerVehicleID(playerid);

        foreach (new i : PvtVehicles)
        {
            if (vehicleid == PlayerVehicle[i][pVehPhysic])
            {
                if (PlayerVehicle[i][pVehFaction] != FACTION_POLISI && PlayerVehicle[i][pVehFaction] != FACTION_EMS)
                    return 0;

                gToggleELM[vehicleid] = true;
                gELMTimer[vehicleid] = SetTimerEx("ToggleELM", 80, true, "d", vehicleid);
            }
        }
    }
    else
    {
        static panels, doors, lights, tires;

        gToggleELM[vehicleid] = false;
        KillTimer(gELMTimer[vehicleid]);

        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
    }
    return 1;
}

hook OnVehicleCreated(vehicleid)
{
    TrunkVehEntered[vehicleid] = INVALID_PLAYER_ID;
    return 1;
}

hook OnVehicleDestroyed(vehicleid)
{
    new index = -1;
    //new playerid = GetVehicleDriver(vehicleid);
    if ((index = Vehicle_GetID(vehicleid)) != -1)
    {
        if (PlayerVehicle[index][vehSirenOn])
        {
            PlayerVehicle[index][vehSirenOn] = false;
            if (IsValidDynamicObject(PlayerVehicle[index][vehSirenObject]))
            {
                DestroyDynamicObject(PlayerVehicle[index][vehSirenObject]);
                PlayerVehicle[index][vehSirenObject] = INVALID_STREAMER_ID;
            }
        }

        if (IsBagasiOpened[PlayerVehicle[index][pVehPhysic]])
        {
            IsBagasiOpened[PlayerVehicle[index][pVehPhysic]] = false;
        }

        if (TrunkVehEntered[PlayerVehicle[index][pVehPhysic]] != INVALID_PLAYER_ID)
        {
            new Float:x, Float:y, Float:z;
            GetVehicleBoot(vehicleid, x, y, z);
            PlayerSpectateVehicle(TrunkVehEntered[PlayerVehicle[index][pVehPhysic]], INVALID_VEHICLE_ID);

            SetSpawnInfo(TrunkVehEntered[PlayerVehicle[index][pVehPhysic]], 0, AccountData[TrunkVehEntered[PlayerVehicle[index][pVehPhysic]]][pSkin], x, y, z, 0.0, 0, 0, 0, 0, 0, 0);
            TogglePlayerSpectating(TrunkVehEntered[PlayerVehicle[index][pVehPhysic]], false);
            SetPVarInt(TrunkVehEntered[PlayerVehicle[index][pVehPhysic]], "PlayerInTrunk", 0);
            AccountData[TrunkVehEntered[PlayerVehicle[index][pVehPhysic]]][pTempVehID] = INVALID_VEHICLE_ID;
            TrunkVehEntered[PlayerVehicle[index][pVehPhysic]] = INVALID_PLAYER_ID;
        }

        for (new slot = 0; slot < MAX_VEHICLE_OBJECT; slot ++) if (VehicleObjects[index][slot][vehObjectExists])
            {
                if (VehicleObjects[index][slot][vehObject] != INVALID_STREAMER_ID)
                    DestroyDynamicObject(VehicleObjects[index][slot][vehObject]);

                VehicleObjects[index][slot][vehObject] = INVALID_STREAMER_ID;
            }

        PlayerVehicle[index][pVehPhysic] = INVALID_VEHICLE_ID;
    }
    /*if(jobs::mixer[playerid][mixerDuty][0] && IsValidVehicle(jobs::mixer[playerid][mixerVehicle]))
	{
		for(new i; i<3; i++)
        {
            TextDrawHideForPlayer(playerid, jobs::GBMixer[i]);
        }
        PlayerTextDrawHide(playerid, jobs::PBMixer[playerid]);
		jobs::mixer_reset_enum(playerid);
		DisablePlayerRaceCheckpoint(playerid);
		ShowTDN(playerid, NOTIFICATION_WARNING, "Anda gagal mengirimkan beton karena kendaraan anda hancur!");
	}*/
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if (AccountData[playerid][pTogAutoEngine] && !IsABicycle(vehicleid))
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            if (GetEngineStatus(vehicleid))
            {
                AccountData[playerid][pTempVehID] = vehicleid;
                SetTimerEx("EngineTurnOff", 1500, false, "dd", playerid, vehicleid);
            }
        }
    }
    
    return 1;
}

forward EngineTurnOff(playerid, vehicleid);
public EngineTurnOff(playerid, vehicleid)
{
    if (AccountData[playerid][pTempVehID] == vehicleid)
    {
        SwitchVehicleEngine(vehicleid, false);
        SendRPMeAboveHead(playerid, "Mesin mati", X11_LIGHTGREEN);

        AccountData[playerid][pTempVehID] = INVALID_VEHICLE_ID;
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if ((AccountData[playerid][pAdmin] >= 1 || AccountData[playerid][pTheStars] >= 1) && AccountData[playerid][pAdminDuty] == 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            SetVehiclePos(vehicleid, fX, fY, fZ + 10);
        }
        else
        {
            SetPlayerPosFindZ(playerid, fX, fY, 999.0);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
        }
    }

    if (AccountData[playerid][pAdmin] >= 1 || AccountData[playerid][pTheStars] >= 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            SetPVarFloat(playerid, "tpX", fX);
            SetPVarFloat(playerid, "tpY", fY);
            SetPVarFloat(playerid, "tpZ", fZ + 5.0);
        }
        else
        {
            SetPVarFloat(playerid, "tpX", fX);
            SetPVarFloat(playerid, "tpY", fY);
            SetPVarFloat(playerid, "tpZ", fZ);
        }
    }
    return 1;
}

Dialog:DOKUMENT_MENU(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return ShowTDN(playerid, NOTIFICATION_INFO, "Anda telah membatalkan pilihan");
    }

    switch (listitem)
    {
        case 1: // lihat ktp
        {
            if (!AccountData[playerid][Ktp]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki KTP!");
            ShowKTPTD(playerid);
        }
        case 2: // Tunjukan KTP
        {
            if (!AccountData[playerid][Ktp]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki KTP!");
            foreach(new i : Player) if (IsPlayerConnected(i)) if (i != playerid)
                {
                    if (IsPlayerNearPlayer(playerid, i, 3.0))
                    {
                        ShowMyKTPTD(playerid, i);
                    }
                }
        }
        case 3: // Lihat SIM
        {
            DisplayLicensi(playerid, playerid);
        }
        case 4: // Tunjukan SIM
        {
            foreach(new i : Player) if (IsPlayerConnected(i)) if (i != playerid)
                {
                    if (IsPlayerNearPlayer(playerid, i, 3.0))
                    {
                        DisplayLicensi(i, playerid);
                    }
                }
        }
        case 5: // Lihat SKWB
        {
            if (!AccountData[playerid][pSKWB]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki SKWB!");

            DisplaySKWB(playerid, playerid);
        }
        case 6: // tunjukan SKWB
        {
            if (!AccountData[playerid][pSKWB]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki SKWB!");

            foreach (new i : Player) if (IsPlayerConnected(i))
                {
                    if (IsPlayerNearPlayer(playerid, i, 3.0))
                    {
                        DisplaySKWB(playerid, i);
                    }
                }
        }

        case 8: //lihat bpjs
        {
            if (!AccountData[playerid][pBPJS]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki BPJS/Expired!");
            DisplayBPJS(playerid, playerid);
        }
        case 9: //tunjukan bpjs
        {
            if (!AccountData[playerid][pBPJS]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki BPJS/Expired!");
            foreach(new i : Player) if (IsPlayerConnected(i)) if (i != playerid)
            {
                if (IsPlayerNearPlayer(playerid, i, 3.0))
                {
                    DisplayBPJS(i, playerid);
                }
            }
        }
        case 10: //lihat skck
        {
            if (!AccountData[playerid][pSKCK]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki SKCK/Expired!");
            DisplaySKCK(playerid, playerid);
        }
        case 11: //tunjuk skck
        {
            if (!AccountData[playerid][pSKCK]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki SKCK/Expired!");
            foreach(new i : Player) if (IsPlayerConnected(i)) if (i != playerid)
                {
                    if (IsPlayerNearPlayer(playerid, i, 3.0))
                    {
                        DisplaySKCK(i, playerid);
                    }
                }
        }
        case 12: //lihat sks
        {
            if (!AccountData[playerid][pSKS]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki Surat Keterangan Sehat/Expired!");
            DisplaySKS(playerid, playerid);
        }
        case 13: //tunjuk sks
        {
            if (!AccountData[playerid][pSKS]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki Surat Keterangan Sehat/Expired!");
            foreach(new i : Player) if (IsPlayerConnected(i)) if (i != playerid)
                {
                    if (IsPlayerNearPlayer(playerid, i, 3.0))
                    {
                        DisplaySKS(i, playerid);
                    }
                }
        }
    }
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == LockerRoomTD[1])
	{
		switch(AccountData[playerid][pJob])
		{
			case JOB_PORTER:
			{
				if(AccountData[playerid][pGender] == 1)
				{
					AccountData[playerid][pUniform] = 16;
				}
				else
				{
					AccountData[playerid][pUniform] = 65;
				}
				AccountData[playerid][pIsUsingUniform] = true;
			}
		}
		SetPlayerSkin(playerid, AccountData[playerid][pUniform]);
		HideLockerTD(playerid);
	}
	else if(clickedid == LockerRoomTD[2])
	{
		AccountData[playerid][pIsUsingUniform] = false;
		SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
		HideLockerTD(playerid);
	}

    if(clickedid == KoranTD[28])
	{
	   	for(new i = 0; i < 29; i++)
		{
			TextDrawHideForPlayer(playerid, KoranTD[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == ClothesSelect[55]) // Batal
    {
        ShowTDN(playerid, NOTIFICATION_INFO, "Anda membatalkan pilihan");
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable(playerid, 1);
        if (AccountData[playerid][pUsingUniform])
		{
  			SetPlayerSkin(playerid, AccountData[playerid][pUniform]);
  		}
    	else
     	{
      		SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
      	}
      	BuyClothes[playerid] = 0;
      	BuyTopi[playerid] = 0;
      	BuyGlasses[playerid] = 0;
      	BuyTAksesoris[playerid] = 0;
      	BuyBackpack[playerid] = 0;
      	CSelect[playerid] = 0;
       	SelectAccTopi[playerid] = 0;
       	SelectAccGlasses[playerid] = 0;
       	SelectAccAksesoris[playerid] = 0;
       	SelectAccBackpack[playerid] = 0;
        AttachPlayerToys(playerid);
        RemovePlayerAttachedObject(playerid, 9);
        for(new txd = 0; txd < 84; txd++)
		{
			TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
		}
		for(new txd = 0; txd < 20; txd++)
		{
			PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
		}
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        CancelSelectTextDraw(playerid);
    }
    if(clickedid == ClothesSelect[53]) // camera
    {
        if(takingclothes[playerid] == 0)
		{
		    static Float:X, Float:Y, Float:Z, Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			SetPlayerCameraPos(playerid, X, Y + 2.5, Z - 0.25);
			SetPlayerCameraLookAt(playerid, X, Y - 1.0, Z + 0.15);
			SetPlayerFacingAngle(playerid, 357.9849);
			takingclothes[playerid] = 1;
			return 1;
		}
	    if(takingclothes[playerid] == 1)
		{
			new Float:x, Float:y, Float:z, Float:angle;
		    GetPlayerPos(playerid, x, y, z);
		    GetPlayerFacingAngle(playerid, angle);

		    new Float:camX = x + 5.0 * floatsin(-angle, degrees);
		    new Float:camY = y + 5.0 * floatcos(-angle, degrees);
		    new Float:camZ = z + 0.5;

		    SetPlayerCameraPos(playerid, camX, camY, camZ);
		    SetPlayerCameraLookAt(playerid, x, y, z);

		    takingclothes[playerid] = 0;
		    return 1;
		}
    }
    if(clickedid == ClothesSelect[54]) // Beli Clothes
    {
        for(new txd = 0; txd < 8; txd++)
		{
			PlayerTextDrawShow(playerid, ConfirmBuyTD[playerid][txd]);
		}
		SelectTextDraw(playerid, COLOR_LOGS);
        /*if (BuyClothes[playerid] == 1)
        {
            new price = 200;

            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang tidak cukup! (Price: $200)");
            TakePlayerMoneyEx(playerid, price);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli baju seharga ~g~$200");

            AccountData[playerid][pSkin] = GetPlayerSkin(playerid);
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
            CancelSelectTextDraw(playerid);
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
        }

        if (BuyTopi[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 0;

            new price = 80;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $80)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = AksesorisHat[SelectAccTopi[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Topi seharga ~g~$80");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyGlasses[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 1;

            new price = 50;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $50)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = GlassesToys[SelectAccGlasses[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Kacamata seharga ~g~$50");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyTAksesoris[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 2;

            new price = 100;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $100)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = AksesorisToys[SelectAccAksesoris[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Aksesoris seharga ~g~$100");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyBackpack[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 3;

            new price = 100;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: 100)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = BackpackToys[SelectAccBackpack[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Tas seharga ~g~$100");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }*/
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
    }
	if(clickedid == ClothesSelect[33])//prev pakaian male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
		    CSelect[playerid] --;
	    	BuyClothes[playerid] = 1;
	    	BuyTopi[playerid] = 0;
	    	BuyGlasses[playerid] = 0;
	    	BuyTAksesoris[playerid] = 0;
	    	BuyBackpack[playerid] = 0;
	 		if(CSelect[playerid] <= -1) CSelect[playerid] = (AccountData[playerid][pGender] == 1 ? sizeof ClothesSkinMale  : sizeof ClothesSkinFemale) - 1;
	       	SetPlayerSkin(playerid, ClothesSkinMale[CSelect[playerid]]);
			static minsty[128];
	  		format(minsty, sizeof minsty, "%02d/%d", CSelect[playerid] + 1, ((AccountData[playerid][pGender] == 1) ? sizeof(ClothesSkinMale) : sizeof(ClothesSkinFemale)));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][1], minsty);
	    	static minstys[128];
	  		format(minstys, sizeof minstys, "%02d", CSelect[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][0], minstys);
    	}
	}
	if(clickedid == ClothesSelect[34])//next pakaian male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
		 	CSelect[playerid] ++;
		 	BuyClothes[playerid] = 1;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		 	if(AccountData[playerid][pGender] == 1 && CSelect[playerid] >= sizeof ClothesSkinMale) CSelect[playerid] = 0;
	       	SetPlayerSkin(playerid, ClothesSkinMale[CSelect[playerid]]);
			static minsty[128];
	  		format(minsty, sizeof minsty, "%02d/%d", CSelect[playerid] + 1, ((AccountData[playerid][pGender] == 1) ? sizeof(ClothesSkinMale) : sizeof(ClothesSkinFemale)));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][1], minsty);
	    	static minstys[128];
	  		format(minstys, sizeof minstys, "%02d", CSelect[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][0], minstys);
		}
	}
	if(clickedid == ClothesSelect[35])//prev pakaian female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
	 		CSelect[playerid] --;
	 		BuyClothes[playerid] = 1;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
	 		if(CSelect[playerid] <= -1) CSelect[playerid] = (AccountData[playerid][pGender] == 1 ? sizeof ClothesSkinMale  : sizeof ClothesSkinFemale) - 1;
	       	SetPlayerSkin(playerid, ClothesSkinFemale[CSelect[playerid]]);
			static minsty[128];
	  		format(minsty, sizeof minsty, "%02d/%d", CSelect[playerid] + 1, ((AccountData[playerid][pGender] == 1) ? sizeof(ClothesSkinMale) : sizeof(ClothesSkinFemale)));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][2], minsty);
	    	static minstys[128];
	  		format(minstys, sizeof minstys, "%02d", CSelect[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][11], minstys);
    	}
	}
	if(clickedid == ClothesSelect[36])//next pakaian female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
	 		CSelect[playerid] ++;
	 		BuyClothes[playerid] = 1;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
	 		if(AccountData[playerid][pGender] == 2 && CSelect[playerid] >= sizeof ClothesSkinFemale) CSelect[playerid] = 0;
	       	SetPlayerSkin(playerid, ClothesSkinFemale[CSelect[playerid]]);
			static minsty[128];
	  		format(minsty, sizeof minsty, "%02d/%d", CSelect[playerid] + 1, ((AccountData[playerid][pGender] == 1) ? sizeof(ClothesSkinMale) : sizeof(ClothesSkinFemale)));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][2], minsty);
	    	static minstys[128];
	  		format(minstys, sizeof minstys, "%02d", CSelect[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][11], minstys);
    	}
	}
	if(clickedid == ClothesSelect[37])//prev topi/helm male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
	 		SelectAccTopi[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 1;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccTopi[playerid] <= -1) SelectAccTopi[playerid] = sizeof (AksesorisHat) - 1;
			SetPlayerAttachedObject(playerid, 9, AksesorisHat[SelectAccTopi[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccTopi[playerid] + 1, sizeof(AksesorisHat));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][3], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccTopi[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][12], minstys);
    	}
	}
	if(clickedid == ClothesSelect[38])//next topi/helm male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
			SelectAccTopi[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 1;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccTopi[playerid] >= sizeof AksesorisHat) SelectAccTopi[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, AksesorisHat[SelectAccTopi[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccTopi[playerid] + 1, sizeof(AksesorisHat));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][3], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccTopi[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][12], minstys);
    	}
	}
	if(clickedid == ClothesSelect[39])//prev topi/helm female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
	 		SelectAccTopi[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 1;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccTopi[playerid] <= -1) SelectAccTopi[playerid] = sizeof (AksesorisHat) - 1;
			SetPlayerAttachedObject(playerid, 9, AksesorisHat[SelectAccTopi[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccTopi[playerid] + 1, sizeof(AksesorisHat));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][4], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccTopi[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][13], minstys);
    	}
	}
	if(clickedid == ClothesSelect[40])//next topi/helm female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
			SelectAccTopi[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 1;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccTopi[playerid] >= sizeof AksesorisHat) SelectAccTopi[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, AksesorisHat[SelectAccTopi[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccTopi[playerid] + 1, sizeof(AksesorisHat));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][4], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccTopi[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][13], minstys);
    	}
	}
	if(clickedid == ClothesSelect[41])//prev kacamata male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
	 		SelectAccGlasses[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 1;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
	   		if(SelectAccGlasses[playerid] <= -1) SelectAccGlasses[playerid] = sizeof (GlassesToys) - 1;
			SetPlayerAttachedObject(playerid, 9, GlassesToys[SelectAccGlasses[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccGlasses[playerid] + 1, sizeof(GlassesToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][5], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccGlasses[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][14], minstys);
    	}
	}
	if(clickedid == ClothesSelect[42])//next kacamata male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
			SelectAccGlasses[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 1;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccGlasses[playerid] >= sizeof GlassesToys) SelectAccGlasses[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, GlassesToys[SelectAccGlasses[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccGlasses[playerid] + 1, sizeof(GlassesToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][5], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccGlasses[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][14], minstys);
    	}
	}
	if(clickedid == ClothesSelect[43])//prev kacamata female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
	 		SelectAccGlasses[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 1;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccGlasses[playerid] <= -1) SelectAccGlasses[playerid] = sizeof (GlassesToys) - 1;
			SetPlayerAttachedObject(playerid, 9, GlassesToys[SelectAccGlasses[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccGlasses[playerid] + 1, sizeof(GlassesToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][6], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccGlasses[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][15], minstys);
    	}
	}
	if(clickedid == ClothesSelect[44])//next kacamata female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
			SelectAccGlasses[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 1;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccGlasses[playerid] >= sizeof GlassesToys) SelectAccGlasses[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, GlassesToys[SelectAccGlasses[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccGlasses[playerid] + 1, sizeof(GlassesToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][6], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccGlasses[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][15], minstys);
    	}
	}
	if(clickedid == ClothesSelect[45])//prev aksesoris male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
	 		SelectAccAksesoris[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 1;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccAksesoris[playerid] <= -1) SelectAccAksesoris[playerid] = sizeof (AksesorisToys) - 1;
			SetPlayerAttachedObject(playerid, 9, AksesorisToys[SelectAccAksesoris[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccAksesoris[playerid] + 1, sizeof(AksesorisToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][7], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccAksesoris[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][16], minstys);
    	}
	}
	if(clickedid == ClothesSelect[46])//next aksesoris male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
			SelectAccAksesoris[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 1;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccAksesoris[playerid] >= sizeof AksesorisToys) SelectAccAksesoris[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, AksesorisToys[SelectAccAksesoris[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccAksesoris[playerid] + 1, sizeof(AksesorisToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][7], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccAksesoris[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][16], minstys);
    	}
	}
	if(clickedid == ClothesSelect[47])//prev aksesoris female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
	 		SelectAccAksesoris[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 1;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccAksesoris[playerid] <= -1) SelectAccAksesoris[playerid] = sizeof (AksesorisToys) - 1;
			SetPlayerAttachedObject(playerid, 9, AksesorisToys[SelectAccAksesoris[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccAksesoris[playerid] + 1, sizeof(AksesorisToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][8], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccAksesoris[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][17], minstys);
    	}
	}
	if(clickedid == ClothesSelect[48])//next aksesoris female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
			SelectAccAksesoris[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 1;
		   	BuyBackpack[playerid] = 0;
		   	if(SelectAccAksesoris[playerid] >= sizeof AksesorisToys) SelectAccAksesoris[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, AksesorisToys[SelectAccAksesoris[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccAksesoris[playerid] + 1, sizeof(AksesorisToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][8], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccAksesoris[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][17], minstys);
    	}
	}
	if(clickedid == ClothesSelect[49])//prev tas male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
	 		SelectAccBackpack[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 1;
		   	if(SelectAccBackpack[playerid] <= -1) SelectAccBackpack[playerid] = sizeof (BackpackToys) - 1;
			SetPlayerAttachedObject(playerid, 9, BackpackToys[SelectAccBackpack[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccBackpack[playerid] + 1, sizeof(BackpackToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][9], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccBackpack[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][18], minstys);
    	}
	}
	if(clickedid == ClothesSelect[50])//next tas male
	{
	    if(AccountData[playerid][pGender] == 1)
		{
			SelectAccBackpack[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 1;
		   	if(SelectAccBackpack[playerid] >= sizeof BackpackToys) SelectAccBackpack[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, BackpackToys[SelectAccBackpack[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccBackpack[playerid] + 1, sizeof(BackpackToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][9], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccBackpack[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][18], minstys);
    	}
	}
	if(clickedid == ClothesSelect[51])//prev tas female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
	 		SelectAccBackpack[playerid] --;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 1;
		   	if(SelectAccBackpack[playerid] <= -1) SelectAccBackpack[playerid] = sizeof (BackpackToys) - 1;
			SetPlayerAttachedObject(playerid, 9, BackpackToys[SelectAccBackpack[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccBackpack[playerid] + 1, sizeof(BackpackToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][10], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccBackpack[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][19], minstys);
    	}
	}
	if(clickedid == ClothesSelect[52])//next tas female
	{
	    if(AccountData[playerid][pGender] == 2)
		{
			SelectAccBackpack[playerid] ++;
	     	BuyClothes[playerid] = 0;
	  		BuyTopi[playerid] = 0;
		   	BuyGlasses[playerid] = 0;
		   	BuyTAksesoris[playerid] = 0;
		   	BuyBackpack[playerid] = 1;
		   	if(SelectAccBackpack[playerid] >= sizeof BackpackToys) SelectAccBackpack[playerid] = 0;
			SetPlayerAttachedObject(playerid, 9, BackpackToys[SelectAccBackpack[playerid]], 2, 0.269, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000);
	  		static minsty[128];
	    	format(minsty, sizeof minsty, "%02d/%d", SelectAccBackpack[playerid] + 1, sizeof(BackpackToys));
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][10], minsty);
	    	static minstys[128];
	    	format(minstys, sizeof minstys, "%02d", SelectAccBackpack[playerid] + 1);
	    	PlayerTextDrawSetString(playerid, ClothesPlayerSelect[playerid][19], minstys);
    	}
	}
	for(new i = 0; i<77; i++)
    {
        if(clickedid == Select_Hack[i])
        {
            if(HackingData[HackWave] == 1)
            {
                if(HackingData[HackLett][0] == HackingData[HackSelect][i])
                {
                    TextDrawBoxColor(Random_Hack[0], 9109759);
                    TextDrawShowForPlayer(playerid, Random_Hack[0]);
                    Hack_Selector();
                }
                else
                {
                    SendClientMessage(playerid, -1, "Kamu telah gagal melakukan peretasan");
                    Hack_Hide(playerid);
                }
            }
            else if(HackingData[HackWave] == 2)
            {
                if(HackingData[HackLett][1] == HackingData[HackSelect][i])
                {
                    TextDrawBoxColor(Random_Hack[1], 9109759);
                    TextDrawShowForPlayer(playerid, Random_Hack[1]);
                    Hack_Selector();
                }
                else
                {
                    SendClientMessage(playerid, -1, "Kamu telah gagal melakukan peretasan");
                    Hack_Hide(playerid);
                }
            }
            else if(HackingData[HackWave] == 3)
            {
                if(HackingData[HackLett][2] == HackingData[HackSelect][i])
                {
                    TextDrawBoxColor(Random_Hack[2], 9109759);
                    TextDrawShowForPlayer(playerid, Random_Hack[2]);
                    Hack_Selector();
                }
                else
                {
                    SendClientMessage(playerid, -1, "Kamu telah gagal melakukan peretasan");
                    Hack_Hide(playerid);
                }
            }
            else if(HackingData[HackWave] == 4)
            {
                if(HackingData[HackLett][3] == HackingData[HackSelect][i])
                {
                    SendClientMessage(playerid, -1, "Sukses Kamu telah berhasil meretas sistem");
                    TextDrawBoxColor(Random_Hack[3], 9109759);
                    TextDrawShowForPlayer(playerid, Random_Hack[3]);

                    if(AccountData[playerid][pRobBankArea] == 3)
                    {
                        DestroyDynamicArea(RobBank[BankKeypad]);
                        DestroyDynamicArea(RobBank[BankDetect]);

                        for(new idx = 0; idx<5; idx++)
                            DestroyDynamicObject(RobBank[BankLaser][idx]);
                    }
                    TogglePlayerControllable(playerid, true);
                    AccountData[playerid][pHacking] = 0;
                    Hack_Hide(playerid);
                }
                else
                {
                    SendClientMessage(playerid, -1, "Kamu telah gagal melakukan peretasan");
                    Hack_Hide(playerid);
                }
            }
        }
    }

    return 1;
}

public ClickDynamicPlayerTextdraw(playerid, PlayerText: playertextid)
{
    if(playertextid == Fishing::Player[playerid][Fishing::gui_2][7])
    {
        if(Fishing::isActiveProgress2(playerid))
		{
            // PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/1243849565988323400/1246796058592280576/spinning-reel-27903_mp3cut.net.mp3?ex=665db0d0&is=665c5f50&hm=a2b19846afde0c2a52e8b566e1dd44269cf1b9be65caf71d20cb7ddbf46d746c&");
            Fishing::Player[playerid][Fishing::currentProgress2] += 7;
            if (Fishing::Player[playerid][Fishing::currentProgress2] >= 100)
			{
                Fishing::Player[playerid][Fishing::currentProgress2] = 100;
            }
        }
    }
    if(playertextid == NambangBatuTD[playerid][2])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][2]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
    	else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][3])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][3]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][4])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][4]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][5])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][5]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][6])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][6]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][7])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][7]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][8])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][8]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][9])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][9]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][10])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][10]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
            for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == NambangBatuTD[playerid][11])
    {
        PlayerTextDrawHide(playerid, NambangBatuTD[playerid][11]);
        AccountData[playerid][pNambangBatu] += 1;
        if(AccountData[playerid][pNambangBatu] == 10)
        {
           for(new x = 0; x < 23; x++)
            {
                if(IsPlayerInDynamicArea(playerid, PlayerMinerVars[playerid][MinerStoneArea][x]))
                {
	           // AccountData[playerid][pNambangBatu] = 0;
	           	AccountData[playerid][ActivityTime] = 1;
	            ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
	            SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.028, -0.127, 0.021, 95.800, 94.400, -85.000, 1.000, 1.000, 1.000);
	            for(new txd = 0; txd < 12; txd++)
				{
					PlayerTextDrawHide(playerid, NambangBatuTD[playerid][txd]);
				}
				CancelSelectTextDraw(playerid);
	            pTimerMining[playerid] = SetTimerEx("MinerStoneTake", 1000, true, "dd", playerid, x);
	            PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "MENAMBANG");
	            ShowProgressBar(playerid);
	            }
            }
        }
        else
        {
	        new randbatu=random(10);
	   		switch(randbatu)
	    	{
				case 0:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][2]);
				}
				case 1:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][3]);
				}
				case 2:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][4]);
				}
				case 3:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][5]);
				}
				case 4:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][6]);
				}
				case 5:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][7]);
				}
				case 6:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][8]);
				}
				case 7:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][9]);
				}
				case 8:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][10]);
				}
				case 9:
				{
					PlayerTextDrawShow(playerid, NambangBatuTD[playerid][11]);
				}
			}
		}
    }
    if(playertextid == ConfirmBuyTD[playerid][3]) // Beli Clothes
    {
        if (BuyClothes[playerid] == 1)
        {
            new price = 200;

            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang tidak cukup! (Price: $200)");
            TakePlayerMoneyEx(playerid, price);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli baju seharga ~g~$200");

            AccountData[playerid][pSkin] = GetPlayerSkin(playerid);
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
            CancelSelectTextDraw(playerid);
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
        }

        if (BuyTopi[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 0;

            new price = 80;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $80)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = AksesorisHat[SelectAccTopi[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Topi seharga ~g~$80");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyGlasses[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 1;

            new price = 50;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $50)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = GlassesToys[SelectAccGlasses[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Kacamata seharga ~g~$50");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyTAksesoris[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 2;

            new price = 100;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $100)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = AksesorisToys[SelectAccAksesoris[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Aksesoris seharga ~g~$100");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyBackpack[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 3;

            new price = 100;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: 100)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = BackpackToys[SelectAccBackpack[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Tas seharga ~g~$100");
            for(new txd = 0; txd < 84; txd++)
			{
				TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
			}
			for(new txd = 0; txd < 20; txd++)
			{
				PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
			}
            BuyClothes[playerid] = 0;
	      	BuyTopi[playerid] = 0;
	      	BuyGlasses[playerid] = 0;
	      	BuyTAksesoris[playerid] = 0;
	      	BuyBackpack[playerid] = 0;
	      	CSelect[playerid] = 0;
	       	SelectAccTopi[playerid] = 0;
	       	SelectAccGlasses[playerid] = 0;
	       	SelectAccAksesoris[playerid] = 0;
	       	SelectAccBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }
        for(new txd = 0; txd < 8; txd++)
		{
			PlayerTextDrawHide(playerid, ConfirmBuyTD[playerid][txd]);
		}
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
    }
    if(playertextid == ConfirmBuyTD[playerid][4]) // cancel Clothes
    {
        ShowTDN(playerid, NOTIFICATION_INFO, "Anda membatalkan pilihan");
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable(playerid, 1);
        if (AccountData[playerid][pUsingUniform])
		{
  			SetPlayerSkin(playerid, AccountData[playerid][pUniform]);
  		}
    	else
     	{
      		SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
      	}
      	BuyClothes[playerid] = 0;
      	BuyTopi[playerid] = 0;
      	BuyGlasses[playerid] = 0;
      	BuyTAksesoris[playerid] = 0;
      	BuyBackpack[playerid] = 0;
      	CSelect[playerid] = 0;
       	SelectAccTopi[playerid] = 0;
       	SelectAccGlasses[playerid] = 0;
       	SelectAccAksesoris[playerid] = 0;
       	SelectAccBackpack[playerid] = 0;
        AttachPlayerToys(playerid);
        RemovePlayerAttachedObject(playerid, 9);
        for(new txd = 0; txd < 84; txd++)
		{
			TextDrawHideForPlayer(playerid, ClothesSelect[txd]);
		}
		for(new txd = 0; txd < 20; txd++)
		{
			PlayerTextDrawHide(playerid, ClothesPlayerSelect[playerid][txd]);
		}
		for(new txd = 0; txd < 8; txd++)
		{
			PlayerTextDrawHide(playerid, ConfirmBuyTD[playerid][txd]);
		}
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        CancelSelectTextDraw(playerid);
    }
    for(new i = 0; i < 25; i++)
    {
        if(playertextid == Rob_Code[playerid][i])
          {
            new color = Color[playerid][i];
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            if(color != COLOR_GREEN)
            {
               if(TtlError[playerid] >= 1)
                {
                     SendClientMessageEx(playerid, COLOR_WHITE, ""RED_E"[INFO] : "WHITE_E"You made 2 mistakes, you failed to hack the ATM");
                     HideCodeTd(playerid);
                     CancelSelectTextDraw(playerid);
                     Inrobbingcode[playerid] = 0;
                     TtlError[playerid] = 0;
                     TtlInfo[playerid] = 0;
                     return 1;
                }
                else
				{
                   TtlError[playerid] += 1;
                   PlayerTextDrawColor(playerid, Rob_Code[playerid][i], COLOR_RED);
                   PlayerTextDrawShow(playerid, Rob_Code[playerid][i]);
             	}
			}
			else
			{
				if(TtlInfo[playerid] >= 4)
				{
					new id = -1;
					id = NearestAtm(playerid);
					Info(playerid, "you have successfully hacked the ATM");
					SendClientMessageEx(playerid, COLOR_WHITE, ""GREEN_E"WARNING : "WHITE_E"The police are on their way to your location, move away immediately!");
					SendClientMessageToAllEx(COLOR_BLUE, "[ALARM KOTA]"WHITE_E" Telah Terjadi Pembobolan Atm di [Location: %s, ATMID: %d]", GetLocation(x, y, z), id);
					SendClientMessageToAllEx(COLOR_BLUE, "[Warning]{FFFFFF} Warga Harap Menjauh Di Area Tersebut.!");
					SendAdminMessage(COLOR_RED, "* %s Has Robbery Atm Pliss Admin Spec", AccountData[playerid][pName]);
					HideCodeTd(playerid);
					Inrobbingcode[playerid] = 0;
					TtlError[playerid] = 0;
					TtlInfo[playerid] = 0;
					CancelSelectTextDraw(playerid);
					AccountData[playerid][pActivity] = SetTimerEx("Robberr", 10000, false, "i", playerid);
					AccountData[playerid][pRobSystem] = 1;
					//PlayerTextDrawSetString(playerid, Nama_Progressbar[playerid], "Robbing...");
					//ShowProgressBar(playerid);
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
					//ApplyAnimation(playerid,"SWORD", "sword_4", 4.0, 1, 0, 0, 0, 0, 1);
					InRob[playerid] = 1;
					return 1;
				}
				else
				{
					PlayerTextDrawColor(playerid, Rob_Code[playerid][i], COLOR_GREEN);
					PlayerTextDrawShow(playerid, Rob_Code[playerid][i]);
					TtlInfo[playerid] += 1;
				}
			}
        }
    }

    if(playertextid == ENTERKODERAMPOK[playerid][26])
    {
        forex(i, 28)
        {
            PlayerTextDrawHide(playerid, ENTERKODERAMPOK[playerid][i]);
            CancelSelectTextDraw(playerid);
        }
    }
   	if(playertextid == ENTERKODERAMPOK[playerid][11])
    {
        if(AccountData[playerid][ActivityTime] == 1) return Error(playerid, "You are still in activity progress");
		new numbs = strval(EnteredPhoneNumb[playerid]);
        new ytta;
        ytta = GetPVarInt(playerid, "Koderampok");

        if(strlen(EnteredPhoneNumb[playerid]) < 1) return 1;
        if(numbs == ytta)
        {
            if(GM[cooldownlojas1] == 0)
            {
                PlayerTextDrawShow(playerid, PERAMPOKANTD[playerid][0]);
                PlayerTextDrawShow(playerid, PERAMPOKANTD[playerid][1]);
                PlayerTextDrawShow(playerid, PERAMPOKANTD[playerid][2]);
                timerperampokan[playerid] = 300;
                DeletePVar(playerid, "Koderampok");
                TogglePlayerControllable(playerid, 0);
                forex(i, 28)
                {
                    PlayerTextDrawHide(playerid, ENTERKODERAMPOK[playerid][i]);
                    CancelSelectTextDraw(playerid);
                }
                foreach(new i : Player)
                {
                    if(AccountData[i][pFaction] == 1)
                    {
                        //if(AccountData[i][pFactionDuty])
                        {
                            new Float:x, Float:y, Float:z;
                            GetPlayerPos(playerid, x, y, z);
                            SendClientMessageEx(i, COLOR_BLUE, "[POLICE ALERT]:{FFFFFF} There have been shop robberies in the area %s", GetLocation(x, y, z));
                        }
                    }
                }
                EnteredPhoneNumb[playerid][0] = 0;
                EnteredPhoneNumb[playerid][1] = 0;
                EnteredPhoneNumb[playerid][2] = 0;
                EnteredPhoneNumb[playerid][3] = 0;
                EnteredPhoneNumb[playerid][4] = 0;
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 1);
                Info(playerid, "You've broken into space");
            }
            else
            {
                Error(playerid, "This shop was just robbed");
            }
        }
        else
        {
            forex(i, 28)
            {
                PlayerTextDrawHide(playerid, ENTERKODERAMPOK[playerid][i]);
                CancelSelectTextDraw(playerid);
            }
            Info(playerid, "The code you entered is wrong");
            EnteredPhoneNumb[playerid][0] = 0;
            EnteredPhoneNumb[playerid][1] = 0;
            EnteredPhoneNumb[playerid][2] = 0;
            EnteredPhoneNumb[playerid][3] = 0;
            EnteredPhoneNumb[playerid][4] = 0;
        }

        PlayerPlaySound(playerid, 1137, 0, 0, 0);
    	PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][12])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "6");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][13])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "9");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][10])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "8");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][9])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "5");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][8])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "0");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][7])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "7");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][6])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "4");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][5])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "3");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][4])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "2");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }
	if(playertextid == ENTERKODERAMPOK[playerid][3])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "1");
		PlayerTextDrawSetString(playerid, ENTERKODERAMPOK[playerid][25], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == notesbook[playerid][Note::p_td][50])
	{
        if(notesbook[playerid][Note::ReadMode]) return 0;
        Dialog_Show(playerid, DialogNoteCreate, DIALOG_STYLE_INPUT, ""NEXODUS""SERVER_NAME""WHITE" - Note", "{FFFFFF}Please enter the text you want to create", "Submit", "Cancel");
    }
	if(playertextid == scmiw_notes[playerid][Note::p_td][7])
	{
        shownotesmenu(playerid, false);
        ShowPlayerNote(playerid, true);
        SelectTextDraw(playerid, 1);
	}
	if(playertextid == notesbook[playerid][Note::p_td][46])
	{
        ShowPlayerNote(playerid, false);
	}
	if(playertextid == RegisterPixel[playerid][26])
    {
        if(AccountData[playerid][pBetulNama] == 0) return Error(playerid, "Anda belum memasukkan nama karakter");
	    if(AccountData[playerid][pBetulAge] == 0) return Error(playerid, "Anda belum memasukkan tanggal lahir");
	    if(AccountData[playerid][pBetulHeight] == 0) return Error(playerid, "Anda belum memasukkan tinggi badan");
	    if(AccountData[playerid][pBetulWeight] == 0) return Error(playerid, "Anda belum memasukkan berat badan");
	    if(AccountData[playerid][pBetulGender] == 0) return Error(playerid, "Anda belum memilih jenis kelamin");
	    if(AccountData[playerid][pBetulAge] == 0) return Error(playerid, "Anda belum memasukkan tanggal lahir");
        if(AccountData[playerid][pBetulOrigin] == 0) return Error(playerid, "Anda belum memasukkan negara anda");
        forex(i, 55)
        {
            PlayerTextDrawHide(playerid, RegisterPixel[playerid][i]);
        }
        CancelSelectTextDraw(playerid);
		ShowTDN(playerid, NOTIFICATION_SUKSES, "Pembuatan karakter berhasil!");
		SetPlayerCameraPos(playerid, 534.065, -2102.218, 98.480);
		SetPlayerCameraLookAt(playerid, 531.651, -2098.260, 96.606);
		SetSpawnInfo(playerid, NO_TEAM, AccountData[playerid][pSkin], 1694.7468, -2332.3428, 13.5469, 0.0377, 0, 0, 0, 0, 0, 0);
		Login::Screen_Show(playerid, 1);

		new characterQuery[178];
		if(GetPVarInt(playerid, "CreateName") && GetPVarInt(playerid, "CreateOrigin") && GetPVarInt(playerid, "CreateAge") && GetPVarInt(playerid, "CreateHeight") && GetPVarInt(playerid, "CreateWeight"))
		{
			mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "INSERT INTO `player_characters` (`Char_Name`, `Char_UCP`, `Char_RegisterDate`) VALUES ('%s', '%s', CURRENT_TIMESTAMP())", AccountData[playerid][pTempName], AccountData[playerid][pUCP]);
			mysql_tquery(g_SQL, characterQuery, "OnPlayerRegister", "d", playerid);
			SetPlayerName(playerid, AccountData[playerid][pTempName]);
		}
    }
    if(playertextid == RegisterPixel[playerid][27])
    {
        /*forex(i, 55)
        {
            PlayerTextDrawHide(playerid, RegisterPixel[playerid][i]);
        }*/
        //ShowCharacterList(playerid);
    }
    if(playertextid == RegisterPixel[playerid][17])
    {
        PlayerTextDrawHide(playerid, RegisterPixel[playerid][17]);
        PlayerTextDrawColor(playerid, RegisterPixel[playerid][17], 461004191);
        PlayerTextDrawShow(playerid, RegisterPixel[playerid][17]);
        PlayerTextDrawHide(playerid, RegisterPixel[playerid][18]);
        PlayerTextDrawColor(playerid, RegisterPixel[playerid][18], -125);
        PlayerTextDrawShow(playerid, RegisterPixel[playerid][18]);
        AccountData[playerid][pGender] = 1;
		AccountData[playerid][pSkin] = 59;
	    AccountData[playerid][pBetulGender] = 1;
    }
    if(playertextid == RegisterPixel[playerid][18])
    {
        PlayerTextDrawHide(playerid, RegisterPixel[playerid][17]);
        PlayerTextDrawColor(playerid, RegisterPixel[playerid][17], -125);
        PlayerTextDrawShow(playerid, RegisterPixel[playerid][17]);
        PlayerTextDrawHide(playerid, RegisterPixel[playerid][18]);
        PlayerTextDrawColor(playerid, RegisterPixel[playerid][18], 461004191);
        PlayerTextDrawShow(playerid, RegisterPixel[playerid][18]);
        AccountData[playerid][pGender] = 2;
		AccountData[playerid][pSkin] = 193;
	    AccountData[playerid][pBetulGender] = 1;
    }
    if(playertextid == RegisterPixel[playerid][21])
    {
        ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, ""NEXODUS"Croire"WHITE"- Pembuatan Karakter",
		""WHITE"Selamat Datang di "NEXODUS"Croire\n"WHITE"Sebelum bermain anda harus membuat karakter terlebih dahulu\
		\nMasukkan nama karakter hanya dengan nama orang Indonesia\nCth: Dudung_Sutarman, Aldy_Firmansyah", "Input", "");
    }
    if(playertextid == RegisterPixel[playerid][25])//tanggal lahir
	{
	    ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Tanggal Lahir", "Mohon masukkan tanggal lahir sesuai format hh/bb/tttt cth: (25/09/2001)", "Input", "");
	}
	if(playertextid == RegisterPixel[playerid][22])//tinggi
	{
	    ShowPlayerDialog(playerid, DIALOG_TINGGIBADAN, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE" - Tinggi Badan (cm)", "Mohon masukkan tinggi badan (cm) karakter!\nPerhatian: Format hanya berupa angka satuan cm (cth: 163).", "Input", "");
	}
	if(playertextid == RegisterPixel[playerid][23])//berat
	{
	    ShowPlayerDialog(playerid, DIALOG_BERATBADAN, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE" - Berat Badan (kg)", "Mohon masukkan berat badan (kg) karakter!\nPerhatian: Format hanya berupa angka satuan kg (cth: 75).", "Input", "");
	}
	if(playertextid == RegisterPixel[playerid][24])//negara
	{
	   	ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Negara Kelahiran", "Mohon masukkan kembali negara asal kelahiran karakter.\nPerhatian: Masukkan nama negara yang valid (cth: Indonesia).", "Input", "");
	}
/*
    if(playertextid == RegisterTD[playerid][12])//daftar select
	{
	    if(AccountData[playerid][pBetulNama] == 0) return Error(playerid, "Anda belum memasukkan nama karakter");
	    if(AccountData[playerid][pBetulAge] == 0) return Error(playerid, "Anda belum memasukkan tanggal lahir");
	    if(AccountData[playerid][pBetulHeight] == 0) return Error(playerid, "Anda belum memasukkan tinggi badan");
	    if(AccountData[playerid][pBetulWeight] == 0) return Error(playerid, "Anda belum memasukkan berat badan");
	    if(AccountData[playerid][pBetulGender] == 0) return Error(playerid, "Anda belum memilih jenis kelamin");
	    if(AccountData[playerid][pBetulAge] == 0) return Error(playerid, "Anda belum memasukkan tanggal lahir");
        if(AccountData[playerid][pBetulOrigin] == 0) return Error(playerid, "Anda belum memasukkan negara anda");

	    AccountData[playerid][pSkin] = (AccountData[playerid][pGender]) ? (193) : (59);
		ShowTDN(playerid, NOTIFICATION_SUKSES, "Pembuatan karakter berhasil!");
		SetPlayerCameraPos(playerid, 534.065, -2102.218, 98.480);
		SetPlayerCameraLookAt(playerid, 531.651, -2098.260, 96.606);
		SetSpawnInfo(playerid, NO_TEAM, AccountData[playerid][pSkin], 1694.7468, -2332.3428, 13.5469, 0.0377, 0, 0, 0, 0, 0, 0);
		Login::Screen_Show(playerid, 1);

		new characterQuery[178];
		if(GetPVarInt(playerid, "CreateName") && GetPVarInt(playerid, "CreateOrigin") && GetPVarInt(playerid, "CreateAge") && GetPVarInt(playerid, "CreateHeight") && GetPVarInt(playerid, "CreateWeight"))
		{
			mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "INSERT INTO `player_characters` (`Char_Name`, `Char_UCP`, `Char_RegisterDate`) VALUES ('%s', '%s', CURRENT_TIMESTAMP())", AccountData[playerid][pTempName], AccountData[playerid][pUCP]);
			mysql_tquery(g_SQL, characterQuery, "OnPlayerRegister", "d", playerid);
			SetPlayerName(playerid, AccountData[playerid][pTempName]);
		}
	}
	if(playertextid == RegisterTD[playerid][20])//male
	{
	    PlayerTextDrawHide(playerid, RegisterTD[playerid][20]);
	    PlayerTextDrawColor(playerid, RegisterTD[playerid][20], COLOR_BLUE);
	    PlayerTextDrawShow(playerid, RegisterTD[playerid][20]);
	    PlayerTextDrawHide(playerid, RegisterTD[playerid][22]);
	    PlayerTextDrawColor(playerid, RegisterTD[playerid][22], -1);
	    PlayerTextDrawShow(playerid, RegisterTD[playerid][22]);
	    AccountData[playerid][pGender] = 1;
	    AccountData[playerid][pBetulGender] = 1;
	}
	if(playertextid == RegisterTD[playerid][22])//female
	{
	    PlayerTextDrawHide(playerid, RegisterTD[playerid][22]);
	    PlayerTextDrawColor(playerid, RegisterTD[playerid][22], COLOR_BLUE);
	    PlayerTextDrawShow(playerid, RegisterTD[playerid][22]);
	    PlayerTextDrawHide(playerid, RegisterTD[playerid][20]);
	    PlayerTextDrawColor(playerid, RegisterTD[playerid][20], -1);
	    PlayerTextDrawShow(playerid, RegisterTD[playerid][20]);
	    AccountData[playerid][pGender] = 2;
	    AccountData[playerid][pBetulGender] = 1;
	}
	if(playertextid == RegisterTD[playerid][24])//nama
	{
	    ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, ""NEXODUS"Croire"WHITE"- Pembuatan Karakter",
		""WHITE"Selamat Datang di "NEXODUS"Croire\n"WHITE"Sebelum bermain anda harus membuat karakter terlebih dahulu\
		\nMasukkan nama karakter hanya dengan nama orang Indonesia\nCth: Dudung_Sutarman, Aldy_Firmansyah", "Input", "");
	}
	if(playertextid == RegisterTD[playerid][25])//tanggal lahir
	{
	    ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Tanggal Lahir", "Mohon masukkan tanggal lahir sesuai format hh/bb/tttt cth: (25/09/2001)", "Input", "");
	}
	if(playertextid == RegisterTD[playerid][26])//negara
	{
	    ShowPlayerDialog(playerid, DIALOG_ORIGIN, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Negara Kelahiran", "Mohon masukkan kembali negara asal kelahiran karakter.\nPerhatian: Masukkan nama negara yang valid (cth: Indonesia).", "Input", "");
	}
	if(playertextid == RegisterTD[playerid][27])//tinggi
	{
	    ShowPlayerDialog(playerid, DIALOG_BERATBADAN, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE" - Berat Badan (kg)", "Mohon masukkan berat badan (kg) karakter!\nPerhatian: Format hanya berupa angka satuan kg (cth: 75).", "Input", "");
	}
	if(playertextid == RegisterTD[playerid][28])//berat badan
	{
	    ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Jenis Kelamin", ""WHITE"Laki-Laki\n"GRAY"Perempuan", "Pilih", "");
	}*/
    if(playertextid == LoginTD[playerid][2])//quit
	{
        forex(is, 30)
		{
            PlayerTextDrawHide(playerid, LoginTD[playerid][is]);
        }
        Kick(playerid);
	}
	if(playertextid == LoginTD[playerid][5])//login
	{
	    if(AccountData[playerid][pBetulPw] == 0) return Error(playerid, "Isi Password Anda Terlebih Dahulu!!");
	    forex(is, 30)
		{
            PlayerTextDrawHide(playerid, LoginTD[playerid][is]);
        }
        CheckCharacters(playerid);
		DeletePVar(playerid, "UCPBlacklist");
	}
	if(playertextid == LoginTD[playerid][23])//password
	{
	    new frmxtdialog[128];
	    format(frmxtdialog, sizeof(frmxtdialog), ""WHITE"Selamat datang di "NEXODUS"Croire Roleplay\n"WHITE"UCP Ini telah terdaftar!\nNama UCP: "LIGHTGREEN"%s\
		\n"WHITE"Version: "NEXODUS"CRRP 2025\n"YELLOW"(Silahkan masukkan kata sandi anda dengan benar untuk login):", AccountData[playerid][pUCP]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN2, DIALOG_STYLE_PASSWORD, "UCP - Login", frmxtdialog, "Input", "Keluar");
	}
    if(playertextid == EmoteMenu[playerid][4])
	{
	    new i;
	    forex(is, 18)
		{
            PlayerTextDrawHide(playerid, EmoteMenu[playerid][is]);
        }
        for(i = 0; i < 35; i++) {
            if(i < 19 || i > 28) {
                //new totalAnimDetails = sizeof(Anim::g_AnimDetails);
                PlayerTextDrawShow(playerid, emoteList[playerid][i]);
                PlayerTextDrawSetString(playerid, emoteList[playerid][6], va_return("%d / 18", animPage[playerid]));
            } else {
                if(i - 19 < 10) {
                    PlayerTextDrawSetString(playerid, emoteList[playerid][i], Anim::g_AnimDetails[i - 19][Anim::e_AnimationName]);
                    PlayerTextDrawShow(playerid, emoteList[playerid][i]);
                }
            }
        }
        animPage[playerid] = 1;
        SelectTextDraw(playerid, -1);
	}
	if(playertextid == EmoteMenu[playerid][5])
	{
	    forex(i, 18)
		{
            PlayerTextDrawHide(playerid, EmoteMenu[playerid][i]);
        }
	    callcmd::epropmenu(playerid, "");
	}
	if(playertextid == EmoteMenu[playerid][6])//share animasi
	{
	}
	if(playertextid == EmoteMenu[playerid][7])
	{
	    forex(i, 18)
		{
            PlayerTextDrawHide(playerid, EmoteMenu[playerid][i]);
        }
        animPage[playerid] = 1;
        CancelSelectTextDraw(playerid);
	}
	if(playertextid == HandphonePoker[playerid][13])//card slot
    {
   		if(SlotTimert[playerid]>0)
   		{
   			SendClientMessage(playerid,-1,"Anda Sedang Bermain Harap Tunggu Hingga Selesai");
    	}
    	else
    	{
	    	for(new i = 0; i < 41; i++) PlayerTextDrawHide(playerid, HandphonePoker[playerid][i]);
	      	for(new i; i < 61; i++) PlayerTextDrawShow(playerid, HandphoneMenuGame[playerid][i]);
	      	SlotMachineStarted[playerid]=0;
	      	SlotTimert[playerid]=0;
	      	SlotRunde[playerid]=0;
    	}
    }
    if(playertextid == HandphonePoker[playerid][39])//card slot
    {
        	if(SlotTimert[playerid]>0)
       		{
        		SendClientMessage(playerid,-1,"Harap tunggu hingga babak ini selesai!");
         	}
          	else
           	{
           	    SlotMachineStarted[playerid]=1;
           	    GivePlayerMoneyEx(playerid, -500);
            	SlotTimert[playerid]=SetTimerEx("SlotRoll",500,1,"i",playerid);
             	PlayerTextDrawHide(playerid,HandphonePoker[playerid][34]);
           	}
    }
	if(playertextid == HandphoneGameXoWin[playerid][13])
	{
	    for(new i=0; i < 33; i++)
	    {
	    	PlayerTextDrawHide(playerid,HandphoneGameXoWin[playerid][i]);
	    }
	    for(new i; i < 61; i++) PlayerTextDrawShow(playerid, HandphoneMenuGame[playerid][i]);
	}
	if(playertextid == HandphoneGameXoLose[playerid][13])
	{
	    for(new i=0; i < 33; i++)
	    {
	    	PlayerTextDrawHide(playerid,HandphoneGameXoLose[playerid][i]);
	    }
	    for(new i; i < 61; i++) PlayerTextDrawShow(playerid, HandphoneMenuGame[playerid][i]);
	}
	if(playertextid == HandphoneGameXoDraw[playerid][13])
	{
	    for(new i=0; i < 33; i++)
	    {
	    	PlayerTextDrawHide(playerid,HandphoneGameXoDraw[playerid][i]);
	    }
	    for(new i; i < 61; i++) PlayerTextDrawShow(playerid, HandphoneMenuGame[playerid][i]);
	}
    if(playertextid == HandphoneGameXo[playerid][50])
	{
	 	cmdplay(playerid,1);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][51])
	{
	 	cmdplay(playerid,2);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][52])
	{
	 	cmdplay(playerid,3);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][53])
	{
	 	cmdplay(playerid,4);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][54])
	{
	 	cmdplay(playerid,5);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][55])
	{
	 	cmdplay(playerid,6);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][56])
	{
	 	cmdplay(playerid,7);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][57])
	{
	 	cmdplay(playerid,8);
	 	return 1;
	}
	if(playertextid == HandphoneGameXo[playerid][58])
	{
	 	cmdplay(playerid,9);
	 	return 1;
	}
    if(playertextid == Character_Select[playerid][4]) //SPAWN
    {
        SpawnChar(playerid, 0);
    }
    if(playertextid == Character_Select[playerid][6]) //SPAWN
    {
        SpawnChar(playerid, 1);
    }
    if(playertextid == Character_Select[playerid][35]) //SPAWN
    {
        SpawnChar(playerid, 2);
    }
    if(playertextid == Character_Select[playerid][3]) // KIRI
    {
        if(PlayerChar[playerid][0][0] != EOS) SetPlayerSkin(playerid, CharSkin[playerid][0]);
        else SetPlayerSkin(playerid, RandomEx(1, 255));
        ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
    }
    if(playertextid == Character_Select[playerid][34]) // KANAN
    {
        if(PlayerChar[playerid][2][0] != EOS) SetPlayerSkin(playerid, CharSkin[playerid][2]);
        else SetPlayerSkin(playerid, RandomEx(1, 255));
        ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
    }
    if(playertextid == Character_Select[playerid][5]) // KANAN
    {
        if(PlayerChar[playerid][1][0] != EOS) SetPlayerSkin(playerid, CharSkin[playerid][1]);
        else SetPlayerSkin(playerid, RandomEx(1, 255));
        ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
    }
    if(playertextid == emoteList[playerid][29])
	{
        // TODO: Next page anim
        if (animPage[playerid] < 18)
		{
            animPage[playerid]++;
            SyncAnimPages(playerid);
            new animDetailStr[128];
            for (new i = 0; i < 10; i++)
			{
                new index = (animPage[playerid] * 10) + i - 10;
                if (index < 0 || index >= sizeof(Anim::g_AnimDetails)) continue;
                format(animDetailStr, sizeof(animDetailStr), "%s", Anim::g_AnimDetails[index][Anim::e_AnimationName]);
                PlayerTextDrawSetString(playerid, emoteList[playerid][19 + i], animDetailStr);
                PlayerTextDrawShow(playerid, emoteList[playerid][19 + i]);
                PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
            }
        }
    }
    if(playertextid == emoteList[playerid][30])
	{
        // TODO: Prev page anim
        if (animPage[playerid] > 1)
		{
            animPage[playerid]--;
            SyncAnimPages(playerid);
            new animDetailStr[128];
            for (new i = 0; i < 10; i++)
			{
                new index = (animPage[playerid] * 10) + i - 10;
                if (index < 0 || index >= sizeof(Anim::g_AnimDetails)) continue;
                format(animDetailStr, sizeof(animDetailStr), "%s", Anim::g_AnimDetails[index][Anim::e_AnimationName]);
                PlayerTextDrawSetString(playerid, emoteList[playerid][19 + i], animDetailStr);
                PlayerTextDrawShow(playerid, emoteList[playerid][19 + i]);
            }
        }
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == emoteList[playerid][34])
	{ // Close Animation Page
        forex(i, 35)
		{
            PlayerTextDrawHide(playerid, emoteList[playerid][i]);
        }
        animPage[playerid] = 1;
        //CancelSelectTextDraw(playerid);
        forex(i, 18)
		{
            PlayerTextDrawShow(playerid, EmoteMenu[playerid][i]);
        }
    }
    for(new i = 0; i < 10; i++)
	{
        if(playertextid == emoteList[playerid][i + 8])
		{
            new ePage = i + ((animPage[playerid]-1) * 10);
            ApplyAnimation(playerid, Anim::g_AnimDetails[ePage][Anim::e_AnimLib], Anim::g_AnimDetails[ePage][Anim::e_AnimName], Anim::g_AnimDetails[ePage][Anim::e_AnimDelta], Anim::g_AnimDetails[ePage][Anim::e_AnimLoop], Anim::g_AnimDetails[ePage][Anim::e_AnimLX], Anim::g_AnimDetails[ePage][Anim::e_AnimLY], Anim::g_AnimDetails[ePage][Anim::e_AnimFreeze], Anim::g_AnimDetails[ePage][Anim::e_AnimTime]);
            return 1;
        }
    }
    if(playertextid == EpropList1[playerid][8])//
	{
        ApplyAnimation(playerid, "KISSING", "gift_give", 5.33, 0, 0, 0, 0, 0, 1);
		SetPlayerAttachedObject(playerid, 9, 325, 6, _, _, _, _, _, _, 1.0, 1.0, 1.0);
    }
    if(playertextid == EpropList1[playerid][9])//
	{
 		ApplyAnimation(playerid, "ped","Jetpack_Idle", 4.1, false, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 11245, 5, -0.097999, 0.039000, 0.091999, 1.500000, 103.000022, -2.900001, 0.384999, 0.204000, 0.276000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][10])//
	{
        ApplyAnimation(playerid, "ped","Jetpack_Idle", 4.1, false, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 19610, 5, 0.051999, 0.028999, -0.020000, -84.299865, -0.799999, 10.899998, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][11])//udah
	{
        ApplyAnimation(playerid, "ped","Jetpack_Idle", 4.1, false, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 19878, 5, 0.016000, 0.028000, 0.456000, 0.400000, 91.400108, -1.100000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][12])//
	{
        ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 10.00, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 336, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][13])//
	{
        ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 6.67, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 334, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][14])//
	{
        ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 10.00, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid,  9, 334, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][15])//udah
	{
        ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 6.67, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 336, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][16])//
	{
		ApplyAnimation(playerid,"PAULNMAC", "WANK_LOOP", 4.0, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 322, 5, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList1[playerid][17])//
	{
		ApplyAnimation(playerid, "PAULNMAC", "WANK_LOOP", 4.0, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 321, 5, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    
    if(playertextid == EpropList2[playerid][8])//udah
	{
       	ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 6.67, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid,  9, 19317, 1, -0.145000, 0.356999, 0.211999, -9.399999, 25.299961, 154.199905, 1.000000, 1.051999, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][9])//udah
	{
        ApplyAnimation(playerid, "CAMERA", "camcrch_idleloop", 2.0, true, false, false, false, 0);
		SetPlayerAttachedObject(playerid, 9, 11738, 1, -0.522999, 0.668999, 0.550999, 74.799995, 76.100028, -21.699998, 1.473999, 1.431999, 1.212000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][10])//udah
	{
        ApplyAnimation(playerid, "BSKTBALL","BBALL_walk", 1.07, true, true, true, true, 0);
		SetPlayerAttachedObject(playerid, 9, 2114, 6, 0.300000, 0.000000, 0.039999, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][11])//udah
	{
		ApplyAnimation(playerid, "BSKTBALL","BBALL_run", 0.90, true, true, true, true, 0);
		SetPlayerAttachedObject(playerid,  9, 2114, 6, 0.300000, 0.000000, 0.039999, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][12])//udah
	{
		ApplyAnimation(playerid, "BSKTBALL","BBALL_idleloop", 0.67, true, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 2114, 6, 0.300000, 0.000000, 0.039999, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][13])//udah
	{
        ApplyAnimation(playerid, "ped","Jetpack_Idle", 4.1, false, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 642, 5, -0.279000, 0.126000, -0.356999, 19.699987, -134.099990, 1.599998, 0.368000, 0.371000, 0.470999, 0xFF3A3B3C, 0xFF3A3B3C);
    }
    if(playertextid == EpropList2[playerid][14])//udah
	{
        ApplyAnimation(playerid, "CAMERA", "picstnd_take", 1.0, true, false, false, false, 0);
		SetPlayerAttachedObject(playerid, 9, 19623, 6, 0.152000, 0.068999, 0.037999, 3.899933, -0.499996, 91.399879, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][15])//udah
	{
		ApplyAnimation(playerid, "CAMERA", "piccrch_take", 1.0, true, false, false, false, 0);
		SetPlayerAttachedObject(playerid, 9, 19623, 6, 0.074999, 0.112999, 0.079999, 0.000000, 0.000000, 96.599990, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][16])//udah
	{
	    ApplyAnimation(playerid, "ped", "SEAT_down", 4.1, false, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 2121, 1, -0.324999, 0.050000, -0.015000, -128.700027, 94.600151, -55.500225, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList2[playerid][17])//udah
	{
		ApplyAnimation(playerid, "ped", "SEAT_down", 4.1, false, false, false, true, 0);
		SetPlayerAttachedObject(playerid, 9, 1369, 1, -0.207000, 0.101999, -0.010000, -88.599967, 100.600143, -94.200103, 1.000000, 1.000000, 1.000000, 0, 0);
    }
    if(playertextid == EpropList3[playerid][8])//udah
	{
       	SetPlayerAttachedObject(playerid, 9, 2322, 1, 0.298, 0.405, 0.0, 0.0, 92.2, 178.9, 1.0, 1.0, 1.0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    }
    if(playertextid == EpropList3[playerid][9])//udah
	{
  		ApplyAnimationEx(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0, 1);
  		SetPlayerAttachedObject(playerid, 9, 19307, 5,  0.067000, 0.046999, 0.021000,  -4.299974, 169.900070, 163.699966,  1.000000, 1.000000, 1.000000); // Bendera2
    }
    if(playertextid == EpropList3[playerid][10])//udah
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject(playerid, 9, 2814, 1, 0.095, 0.312, 0.0, -89.7, 56.5, 5.4, 1.0, 1.0, 1.0);
    }
    if(playertextid == EpropList3[playerid][11])//udah
	{
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        SetPlayerAttachedObject(playerid, 9, 2654, 6,  -0.018999, 0.143999, -0.186999,  -106.299964, -2.699998, -11.199999,  1.000000, 0.703000, 0.858000);
    }
    if(playertextid == EpropList3[playerid][12])//udah
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        SetPlayerAttachedObject(playerid, 9, 19636, 1, 0.0, 0.484, 0.0, 0.0, 94.6, 89.6, 1.0, 1.0, 1.0);
    }
    if(playertextid == EpropList3[playerid][13])//
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject(playerid, 9, 2912, 1, 0.181, 0.253, -0.067, -82.3, 1.0, 6.0, 0.51, 0.575, 0.483);
    }
    if(playertextid == EpropList3[playerid][14])//
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject(playerid, 9, 1080, 1, 0.165, 0.436, -0.026, 0.00, 0.00, 86.9, 0.853, 0.478, 0.541);
    }
    if(playertextid == EpropList3[playerid][15])//udah
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        SetPlayerAttachedObject(playerid, 9, 1150, 6,  0.057999, 0.100999, 0.934000,  0.000000, -88.199981, 0.000000,  1.000000, 1.000000, 1.000000); // Bumper
    }
    if(playertextid == EpropList3[playerid][16])//udah
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        SetPlayerAttachedObject(playerid, 9, 1010, 1, -0.065, 0.405, 0.003, 0.0, 92.0, 0.0, 1.0, 1.0, 1.0);
    }
    if(playertextid == EpropList3[playerid][17])//udah
	{
	    ApplyAnimation(playerid, "ped","Jetpack_Idle", 4.1, false, false, false, true, 0);
	    SetPlayerAttachedObject(playerid, 9, 19317, 1, -0.214, 0.383, 0.142, -14.200, 17.900, 158.400, 1.000, 1.000, 1.000);
    }
    if(playertextid == EpropList1[playerid][29])//next
	{
	    forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList1[playerid][i]);
        }
        forex(i, 35)
		{
            PlayerTextDrawShow(playerid, EpropList2[playerid][i]);
        }
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == EpropList1[playerid][30])//prev
	{
	    forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList1[playerid][i]);
        }
	    forex(i, 18)
		{
            PlayerTextDrawShow(playerid, EmoteMenu[playerid][i]);
        }
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == EpropList1[playerid][34])
	{ // Close Animation Page
        forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList1[playerid][i]);
        }
        CancelSelectTextDraw(playerid);
    }
    if(playertextid == EpropList2[playerid][29])//next
	{
	    forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList2[playerid][i]);
        }
        forex(i, 35)
		{
            PlayerTextDrawShow(playerid, EpropList3[playerid][i]);
        }
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == EpropList2[playerid][30])//prev
	{
	    forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList2[playerid][i]);
        }
        forex(i, 35)
		{
            PlayerTextDrawShow(playerid, EpropList1[playerid][i]);
        }
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == EpropList2[playerid][34])
	{ // Close Animation Page
        forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList2[playerid][i]);
        }
        CancelSelectTextDraw(playerid);
    }
    if(playertextid == EpropList3[playerid][29])//next
	{
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == EpropList3[playerid][30])//prev
	{
	    forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList3[playerid][i]);
        }
        forex(i, 35)
		{
            PlayerTextDrawShow(playerid, EpropList2[playerid][i]);
        }
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if(playertextid == EpropList3[playerid][34])
	{ // Close Animation Page
        forex(i, 35)
		{
            PlayerTextDrawHide(playerid, EpropList3[playerid][i]);
        }
        CancelSelectTextDraw(playerid);
    }
    if(playertextid == JoinJobTD[playerid][7])
	{
	    forex(i, 69)
     	{
      		PlayerTextDrawHide(playerid, JoinJobTD[playerid][i]);
        	CancelSelectTextDraw(playerid);
      	}
	}
	if(playertextid == JoinJobTD[playerid][8])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_MINER;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Penambang!");
       	MinerJobStuffs(playerid);
       	NotifJobs(playerid,"Penambang");
	}
	if(playertextid == JoinJobTD[playerid][9])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_BUTCHER;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Tukang Ayam!");
       	LoadVarsButcher(playerid);
       	NotifJobs(playerid,"Tukang Ayam");
	}
	if(playertextid == JoinJobTD[playerid][10])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_BUS;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Supir Bus!");
       	LoadVarsBus(playerid);
       	NotifJobs(playerid,"Driver Bus");
	}
	if(playertextid == JoinJobTD[playerid][11])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_MILKER;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Pemerah Susu!");
       	LoadVarsMilker(playerid);
       	NotifJobs(playerid,"Pemeras Susu");
	}
	if(playertextid == JoinJobTD[playerid][12])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_OILMAN;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Tukang Minyak!");
       	LoadVarsOilman(playerid);
       	NotifJobs(playerid,"Minyak");
	}
	if(playertextid == JoinJobTD[playerid][13])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_TAILOR;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Tukang Jahit!");
       	LoadVarsTailor(playerid);
       	NotifJobs(playerid,"Penjahit");
	}
	if(playertextid == JoinJobTD[playerid][14])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_FARMER;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Petani!");
       	LoadVarsFarmer(playerid);
       	NotifJobs(playerid,"Petani");
	}
	if(playertextid == JoinJobTD[playerid][15])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_LUMBERJACK;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Tukang Kayu!");
       	LoadVarsLumber(playerid);
       	NotifJobs(playerid,"Tukang Kayu");
	}
	if(playertextid == JoinJobTD[playerid][16])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_RECYCLER;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Recycler!");
       	LoadVarsDaur(playerid);
       	NotifJobs(playerid,"Recycler");
	}
	if(playertextid == JoinJobTD[playerid][17])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_NONE;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil menjadi seorang Pengangguran!");
      	NotifJobs(playerid,"Pengangguran");
	}
	if(playertextid == JoinJobTD[playerid][53])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_FISHERMAN;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Nelayan!");
       	LoadVarsFisherman(playerid);
       	NotifJobs(playerid,"Nelayan");
	}
	if(playertextid == JoinJobTD[playerid][54])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_KARGO;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan Kargo!");
       	LoadVarsKargo(playerid);
       	NotifJobs(playerid,"Kargo");
	}
	if(playertextid == JoinJobTD[playerid][61])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_DRIVER_MIXERS;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Driver Mixer!");
      	NotifJobs(playerid,"Driver Mixer");
	}
	if(playertextid == JoinJobTD[playerid][65])
	{
	    UnloadVarsPlayerJob(playerid);
     	AccountData[playerid][pJob] = JOB_PORTER;
      	ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda berhasil mengambil pekerjaan menjadi seorang Porter!");
      	NotifJobs(playerid,"Porter");
	}
    if(playertextid == jobs::Pmixer[playerid][5])
	{
		jobs::mixer_select_case(playerid, 1);
	}
	if(playertextid == jobs::Pmixer[playerid][6])
	{
		jobs::mixer_select_case(playerid, 2);
	}
	if(playertextid == jobs::Pmixer[playerid][7])
	{
		jobs::mixer_select_case(playerid, 3);
	}
	if(playertextid == jobs::Pmixer[playerid][8])
	{
		jobs::mixer_select_case(playerid, 4);
	}
	if(playertextid == jobs::Pmixer[playerid][9])
	{
		jobs::mixer_select_case(playerid, 5);
	}
	if(playertextid == jobs::Pmixer[playerid][10])//confirm
	{
		jobs::mixer_confirm(playerid);
	}
	if(playertextid == HandphoneMenuApk[playerid][19])
    {
		Toggle_PhoneTD(playerid, true, "info");
    }
    if(playertextid == HandphoneMenuApk[playerid][79])
    {
		Toggle_PhoneTD(playerid, true, "game");
    }
    if(playertextid == HandphoneMenuGame[playerid][31])//tictactoe
    {
        if(MatchInfo[playerid][Fullxo] == 1) return SendClientMessage(playerid,COLOR_RED,"Error: Match is Already Stared");
		xocash = 0;
	//	MatchInfo[Fullxo] = 1;
		Moneylist(playerid);
    }
    if(playertextid == HandphoneMenuGame[playerid][38])//card slot
    {
        for(new i; i < 61; i++) PlayerTextDrawHide(playerid, HandphoneMenuGame[playerid][i]);
        for(new i = 0; i < 41; i++) PlayerTextDrawShow(playerid, HandphonePoker[playerid][i]);
    }
    if(playertextid == HandphoneMenuGame[playerid][43])//planewar
    {
    }
    if(playertextid == HandphoneMenuGame[playerid][47])//kalkulator
    {
        for(new i; i < 61; i++) PlayerTextDrawHide(playerid, HandphoneMenuGame[playerid][i]);
        for(new i = 0; i < 72; i++) PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][i]);
    }
    if(playertextid == HandphoneMenuGame[playerid][51])//trading
    {
    }
    if(playertextid == HandphoneKalkulator[playerid][13])//
    {
   		for(new i = 0; i < 72; i++) PlayerTextDrawHide(playerid, HandphoneKalkulator[playerid][i]);
    	for(new i; i < 61; i++) PlayerTextDrawShow(playerid, HandphoneMenuGame[playerid][i]);
    }
    if(playertextid == HandphoneKalkulator[playerid][27])//<
    {
   		format(KalkulatorInput[playerid], 12, "");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][27])//<
    {
   		format(KalkulatorInput[playerid], 12, "");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][28])//+/-
    {
   		strcat(KalkulatorInput[playerid], "+/-");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][29])//%
    {
   		strcat(KalkulatorInput[playerid], "%");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][30])//bagi
    {
   		strcat(KalkulatorInput[playerid], "/");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][31])//
    {
   		strcat(KalkulatorInput[playerid], "7");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][32])//
    {
   		strcat(KalkulatorInput[playerid], "8");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][33])//
    {
   		strcat(KalkulatorInput[playerid], "9");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][34])//
    {
   		strcat(KalkulatorInput[playerid], "x");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][35])//
    {
   		strcat(KalkulatorInput[playerid], "4");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][36])//
    {
   		strcat(KalkulatorInput[playerid], "5");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][37])//
    {
   		strcat(KalkulatorInput[playerid], "6");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][38])//-
    {
   		strcat(KalkulatorInput[playerid], "-");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][39])//+
    {
   		strcat(KalkulatorInput[playerid], "+");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][40])//=
    {
   		strreplace(KalkulatorInput[playerid], "x", "*");
        new Float:result = MathEval(KalkulatorInput[playerid]);
        new str[218];
        if (result == FloatNaN)
        {
            PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], "Malformed Input");
        }
        else
        {
            format(str, sizeof(str), "%.1f", result);
            strreplace(KalkulatorInput[playerid], "*", "x");
            PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], str);
            PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
        }
    }
    if(playertextid == HandphoneKalkulator[playerid][41])//
    {
   		strcat(KalkulatorInput[playerid], "1");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][42])//
    {
   		strcat(KalkulatorInput[playerid], "2");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][43])//
    {
   		strcat(KalkulatorInput[playerid], "3");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][45])//
    {
   		strcat(KalkulatorInput[playerid], ".");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneKalkulator[playerid][47])//
    {
   		strcat(KalkulatorInput[playerid], "0");
        if(strlen(KalkulatorInput[playerid]) >= 18) return Error(playerid, "Teks sudah maksimal");
        PlayerTextDrawSetString(playerid, HandphoneKalkulator[playerid][71], KalkulatorInput[playerid]);
        PlayerTextDrawShow(playerid, HandphoneKalkulator[playerid][71]);
    }
    if(playertextid == HandphoneAirdrop[playerid][27])//permisson
    {
        PlayerTextDrawHide(playerid, HandphoneAirdrop[playerid][30]);
        switch(AccountData[playerid][AirdropPermission])
        {
        	case false: AccountData[playerid][AirdropPermission] = true;
         	case true: AccountData[playerid][AirdropPermission] = false;
        }
		PlayerTextDrawSetString(playerid, HandphoneAirdrop[playerid][30], sprintf("~w~%s",AccountData[playerid][AirdropPermission] ? "~w~Yes" : "~w~No"));
		PlayerTextDrawShow(playerid, HandphoneAirdrop[playerid][30]);
    }
    if(playertextid == HandphoneAirdrop[playerid][28])//airdrop
    {
        			if(!AccountData[playerid][AirdropPermission])
                        return ShowTDN(playerid, NOTIFICATION_WARNING, "Izinkan terlebih dahulu Permission Share Contact!");

                    new frmxt[255], count = 0;

                    foreach(new i : Player) if (i != playerid) if (IsPlayerNearPlayer(playerid, i, 2.0) && AccountData[i][AirdropPermission])
                    {
                        format(frmxt, sizeof(frmxt), "%sPlayer ID: %d\n", frmxt, i);
                        NearestPlayer[playerid][count++] = i;
                    }

                    if(count == 0)
                    {
                        PlayerPlaySound(playerid, 5206, 0.0, 0.0, 0.0);
                        return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""NEXODUS"Croire Roleplay "WHITE"- Airdrop",
                        "Tidak ada player yang dekat dengan anda!", "Tutup", "");
                    }

                    ShowPlayerDialog(playerid, DIALOG_AIRDROP, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Airdrop", frmxt, "Pilih", "Batal");
    }
    if(playertextid == HandphoneMenuApk[playerid][73])
    {
        Toggle_PhoneTD(playerid, true, "garasi");
    }

    if(playertextid == HandphoneMenuApk[playerid][29])
    {
        Toggle_PhoneTD(playerid, true, "kontak");
    }
    if(playertextid == HandphoneTelponAngka[playerid][28])//1
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "1");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "1");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "1");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "1");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][29])//2
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "2");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "2");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "2");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "2");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][30])//3
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "3");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "3");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "3");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "3");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][31])//4
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "4");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "4");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "4");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "4");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][32])//5
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "5");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "5");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "5");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "5");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][33])//6
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "6");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "6");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "6");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "6");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][34])//7
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "7");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "7");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "7");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "7");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][35])//8
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "8");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "8");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "8");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "8");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][36])//9
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "9");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "9");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "9");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "9");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][37])//0
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "#");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "#");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "#");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "#");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][38])//#
    {
        if(rrechnungPhoneCall[playerid] == 0)
	    {
			strcat(zahPhonelCall[playerid], "0");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "0");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
		else
		{
            strcat(azahPhonelCall[playerid], "0");
			PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
			strcat(rechiPhoneCall[playerid], "0");
			PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], rechiPhoneCall[playerid]);
		}
    }
    if(playertextid == HandphoneTelponAngka[playerid][39])//<
    {
        PlayerTextDrawSetString(playerid,HandphoneTelponAngka[playerid][41], "");
		PlayerTextDrawShow(playerid, HandphoneTelponAngka[playerid][41]);
		rechiPhoneCall[playerid] = "";
		rrechnungPhoneCall[playerid] = 0;
		zahPhonelCall[playerid] = "";
		azahPhonelCall[playerid] = "";
    }
    if(playertextid == HandphoneTelponAngka[playerid][40])//c
    {
        rrechnungPhoneCall[playerid] = 1;
		if(rrechnungPhoneCall[playerid] >= 1)
		{
			if(rrechnungPhoneCall[playerid] == 1)
			{
				ergebPhoneCall[playerid] = strval(zahPhonelCall[playerid]);
    			new targetnumberownerid = GetNumberOwner(zahPhonelCall[playerid]);
       			if(!IsPlayerConnected(targetnumberownerid) || targetnumberownerid == INVALID_PLAYER_ID) return ShowTDN(playerid, NOTIFICATION_ERROR, "Mohon maaf nomor tersebut sedang tidak aktif!");
          		if(!strcmp(AccountData[playerid][pPhone], zahPhonelCall[playerid], false)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat menghubungi diri sendiri!");
            	OnOutcomingCall(playerid, zahPhonelCall[playerid]);
				//callcmd::call(playerid, zahPhonelCall[playerid]);
			}
		}
    }
    if(playertextid == HandphoneMenuApk[playerid][24])
    {
        Toggle_PhoneTD(playerid, true, "trans");
    }
    if(playertextid == HandphoneMenuApk[playerid][25])
    {
        Toggle_PhoneTD(playerid, true, "airdrop");
    }
    if(playertextid == HandphoneTrans[playerid][33])
    {
        if(AccountData[playerid][phoneAirplaneMode]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Smartphone anda sedang Mode Pesawat!");
        if(AccountData[playerid][pTaxiPlayer] != INVALID_PLAYER_ID) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang menjadi penumpang di Trans!");

        ShowPlayerDialog(playerid, DIALOG_TRANSORDER, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Pesan Transportasi",
        "Hai, kamu ingin memesan Trans, mau kemana hari ini?", "Input", "Batal");
    }
    // bank
    if(playertextid == HandphoneMenuApk[playerid][20])
    {
        Toggle_PhoneTD(playerid, true, "bank");
    }

    // spotify
    if(playertextid == HandphoneMenuApk[playerid][21])
    {
        Toggle_PhoneTD(playerid, true, "spotify");
    }

    // yellow
    if(playertextid == HandphoneMenuApk[playerid][23])
    {
        Toggle_PhoneTD(playerid, true, "yellow");
    }

    // Twitter
    if(playertextid == HandphoneMenuApk[playerid][22])
    {
        Toggle_PhoneTD(playerid, true, "twitter");
    }
    if(playertextid == HandphoneGps[playerid][28])//lokasi umum
    {
        			new minsty[4096];
                    format(minsty, sizeof(minsty), "Nama\tLokasi\tJarak\
                    \nBalai Kota Croire\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Mabes Kepolisian Croire\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nRumah Sakit Pillbox\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Bengkel Kota Croire\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nLounge Croire\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Wedding Croire\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nMarketplace Croire\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Dealer Croire\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nCarnaval Croire\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Gudang 1\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nGudang 2\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Gudang 3\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nToko Olahraga\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Motel Croire\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nAsuransi Croire LS\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Asuransi Croire LV\t"GRAY"%s\t"YELLOW"%.2f m\
                    \n"GRAY"Pulau\t"GRAY"%s\t"YELLOW"%.2f m\
                    \n"GRAY"Drag Race\t"GRAY"%s\t"YELLOW"%.2f m\
                    ",
                    GetLocation(1480.7584, -1738.7942, 13.5469), GetPlayerDistanceFromPoint(playerid, 1480.7584, -1738.7942, 13.5469), //BalaiKota
                    GetLocation(1808.0857, -1772.9553, 13.5990), GetPlayerDistanceFromPoint(playerid, 1808.0857, -1772.9553, 13.5990), //Kanpol
                    GetLocation(1309.9310,-1380.4731,13.6265), GetPlayerDistanceFromPoint(playerid, 1309.9310,-1380.4731,13.6265), //EMS
                    GetLocation(1339.3677, 725.6096, 10.8203), GetPlayerDistanceFromPoint(playerid, 1339.3677, 725.6096, 10.8203), //Bengkel
                    GetLocation(543.9780, -1794.9819, 6.0188), GetPlayerDistanceFromPoint(playerid, 543.9780, -1794.9819, 6.0188), //Pedagang
                    GetLocation(-2536.2944, -281.2034, 37.4442), GetPlayerDistanceFromPoint(playerid, -2536.2944, -281.2034, 37.4442), //Wedding
                    GetLocation(2698.7671, -2451.8760, 13.6643), GetPlayerDistanceFromPoint(playerid, 2698.7671, -2451.8760, 13.6643), //pasar
                    GetLocation(1052.7136, -937.0538, 42.7113), GetPlayerDistanceFromPoint(playerid, 1052.7136, -937.0538, 42.7113), //Dealer
                    GetLocation(370.1793, -2035.8577, 7.6719), GetPlayerDistanceFromPoint(playerid, 370.1793, -2035.8577, 7.6719), //carnaval
                    GetLocation(-65.5184,-1120.9523,1.0781), GetPlayerDistanceFromPoint(playerid, -65.5184,-1120.9523,1.0781), //Gudang 1
                    GetLocation(-135.2708, 1116.9998, 20.1966), GetPlayerDistanceFromPoint(playerid, -135.2708, 1116.9998, 20.1966), //Gudang 2
                    GetLocation(1865.5657, -1792.6924, 13.5469), GetPlayerDistanceFromPoint(playerid, 1865.5657, -1792.6924, 13.5469), //Gudang 3
                    GetLocation(1386.1796, 292.9582, 19.5469), GetPlayerDistanceFromPoint(playerid, 1386.1796, 292.9582, 19.5469), //TokoOlahraga
                    GetLocation(944.1133, -1708.3372, 13.5546), GetPlayerDistanceFromPoint(playerid, 944.1133, -1708.3372, 13.5546), //MOtel
                    GetLocation(1838.2612, -1398.4840, 13.5625), GetPlayerDistanceFromPoint(playerid, 1838.2612, -1398.4840, 13.5625), //AsuransiLS
                    GetLocation(40.9869, 1211.4176, 19.0493), GetPlayerDistanceFromPoint(playerid, 40.9869, 1211.4176, 19.0493), //AsuransiLV
                    GetLocation(-2608.0696, -2323.1155, 11.2235), GetPlayerDistanceFromPoint(playerid, -2608.0696, -2323.1155, 11.2235), //Pulau
                    GetLocation(2832.8967, 1903.7570, 10.8203), GetPlayerDistanceFromPoint(playerid, 2832.8967, 1903.7570, 10.8203)); //drag race
                    ShowPlayerDialog(playerid, LokasiUmum, DIALOG_STYLE_TABLIST_HEADERS, ""NEXODUS"Croire Roleplay "WHITE"- GPS", minsty, "Pilih", "Batal");
    }
    if(playertextid == HandphoneGps[playerid][29])//lokasi garkot
    {
        			new id = GarkotNearby(playerid);
                    if(id == -1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada Garasi Umum terdekat dari posisi anda!");

                    SetPlayerRaceCheckpoint(playerid, 1, PublicGarage[id][pgPOS][0], PublicGarage[id][pgPOS][1], PublicGarage[id][pgPOS][2], PublicGarage[id][pgPOS][0], PublicGarage[id][pgPOS][1], PublicGarage[id][pgPOS][2], 5.0);
                    pMapCP[playerid] = true;
                    Info(playerid, "Silahkan ikuti tanda blip yang sudah ditandai pada map anda");
    }
    if(playertextid == HandphoneGps[playerid][30])//lokasi sampah
    {
        			new id = NearbyTrash(playerid);
                    if(id == -1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada Tong Sampah terdekat dari posisi anda!");

                    SetPlayerRaceCheckpoint(playerid, 1, TrashData[id][trashPos][0], TrashData[id][trashPos][1], TrashData[id][trashPos][2], 0.0, 0.0, 0.0 ,5.0);
                    pMapCP[playerid] = true;
                    Info(playerid, "Silahkan ikuti tanda blip yang sudah ditandai pada map anda");
    }
    if(playertextid == HandphoneGps[playerid][31])//lokasi pekerjaan
    {
        			new minsty[4012];
                    format(minsty, sizeof(minsty), "Pekerjaan\tNama\tLokasi\tJarak\
                    \n"GRAY"Electrican Job\t"GRAY"( Multiplayer Job )\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nSupir Bus\tTerminal Croire\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Tukang Ayam #1\t"GRAY"Kandang Ayam Croire\t%s\t"YELLOW"%.2f m\
                    \nTukang Ayam #2\tKantor Ayam Croire\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Petani #1\t"GRAY"Pembelian Bibit\t%s\t"YELLOW"%.2f m\
                    \nPetani #2\tLadang Tanaman\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Petani #3\t"GRAY"Olah Tanaman\t%s\t"YELLOW"%.2f m\
                    \nTukang Kayu\tHutan Kayu\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Kargo\t"GRAY"Pengambilan Truck Kargo\t%s\t"YELLOW"%.2f m\
                    \nPemerah Sapi\tLokasi Pemerahan\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Penambang #1\t"GRAY"Pertambangan Croire\t%s\t"YELLOW"%.2f m\
                    \nPenambang #2\tPencucian Batu\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Penambang #3\t"GRAY"Peleburan Batu\t%s\t"YELLOW"%.2f m\
                    \nPenjahit #1\tKantor Penjahit\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Penjahit #2\t"GRAY"Penjualan Pakaian\t%s\t"YELLOW"%.2f m\
                    \nRecycler #1\tTempat Penyortiran\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Recycler #2\t"GRAY"Tempat Daur Ulang\t%s\t"YELLOW"%.2f m\
                    \nTukang Minyak #1\tAmbil Minyak\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Tukang Minyak #2\t"GRAY"Refined Minyak\t%s\t"YELLOW"%.2f m\
                    \nTukang Minyak #3\tMixxing Minyak\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Tukang Minyak #4\t"GRAY"Penjualan Gas\t%s\t"YELLOW"%.2f m\
                    \nNelayan #1\tRental Perahu\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Nelayan #2\t"GRAY"Penangkapan Ikan\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nDriver Mixer\t"GRAY"Mulai Bekerja\t"GRAY"%s\t"YELLOW"%.2f m\
                    \nTrashmaster (TUTUP)\tSidejob\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Mower\t"GRAY"Sidejob\t%s\t"YELLOW"%.2f m\
                    \nSweeper\tSidejob\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Delivery\t"GRAY"Sidejob\t%s\t"YELLOW"%.2f m\
                    \nForklift\tSidejob\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Porter\t"GRAY"Porter barang\t%s\t"YELLOW"%.2f m\
                    ",
                    GetLocation(-2521.1821, -621.8853, 132.7418), GetPlayerDistanceFromPoint(playerid, -2521.1821, -621.8853, 132.7418),
                    GetLocation(96.0680,-272.6256,1.5781), GetPlayerDistanceFromPoint(playerid, 96.0680,-272.6256,1.5781),
                    GetLocation(1546.5872,28.7098,24.1406), GetPlayerDistanceFromPoint(playerid, 1546.5872,28.7098,24.1406),
                    GetLocation(167.7695 ,-52.3998, 1.5869), GetPlayerDistanceFromPoint(playerid, 167.7695 ,-52.3998, 1.5869),
                    GetLocation(-547.7806, -185.1288, 78.4063), GetPlayerDistanceFromPoint(playerid, -547.7806, -185.1288, 78.4063),
                    GetLocation(-376.1269, -1439.9231, 25.7266), GetPlayerDistanceFromPoint(playerid, -376.1269, -1439.9231, 25.7266),
                    GetLocation(3.9224, 66.8390, 3.1172), GetPlayerDistanceFromPoint(playerid, 3.9224, 66.8390, 3.1172),
                    GetLocation(-1989.8452, -2436.0818, 30.6250), GetPlayerDistanceFromPoint(playerid, -1989.8452, -2436.0818, 30.6250),
                    GetLocation(-1704.2260, 49.6503, 3.5495), GetPlayerDistanceFromPoint(playerid, -1704.2260, 49.6503, 3.5495),
                    GetLocation(306.8608,1141.2626,8.5859), GetPlayerDistanceFromPoint(playerid, 306.8608,1141.2626,8.5859),
                    GetLocation(686.9853,895.7302,-39.5328), GetPlayerDistanceFromPoint(playerid, 686.9853,895.7302,-39.5328),
                    GetLocation(1392.2047, -317.5911, 3.1937), GetPlayerDistanceFromPoint(playerid, 1392.2047, -317.5911, 3.1937),
                    GetLocation(1030.5327, -335.3852, 73.9922), GetPlayerDistanceFromPoint(playerid, 1030.5327, -335.3852, 73.9922),
                    GetLocation(1760.1749, -1583.7728, 13.5363), GetPlayerDistanceFromPoint(playerid, 1760.1749, -1583.7728, 13.5363),
                    GetLocation(2724.0186, -2439.6694, 17.1501), GetPlayerDistanceFromPoint(playerid, 2724.0186, -2439.6694, 17.1501),
                    GetLocation(2297.9268, 2764.1992, 10.8203), GetPlayerDistanceFromPoint(playerid, 2297.9268, 2764.1992, 10.8203),
                    GetLocation(-31.6359, 1386.9554, 9.1719), GetPlayerDistanceFromPoint(playerid, -31.6359, 1386.9554, 9.1719),
                    GetLocation(471.9127, 1299.1512, 9.7176), GetPlayerDistanceFromPoint(playerid, 471.9127, 1299.1512, 9.7176),
                    GetLocation(497.5595, 1518.7350, 1.0000), GetPlayerDistanceFromPoint(playerid, 497.5595, 1518.7350, 1.0000),
                    GetLocation(652.9443, 1232.3210, 11.5778), GetPlayerDistanceFromPoint(playerid, 652.9443, 1232.3210, 11.5778),
                    GetLocation(2721.5564, -2452.1064 ,17.1401), GetPlayerDistanceFromPoint(playerid, 2721.5564, -2452.1064 ,17.1401),
                    GetLocation(111.3999, -1895.6553, 2.9408), GetPlayerDistanceFromPoint(playerid, 111.3999, -1895.6553, 2.9408),
                    GetLocation(352.4596, -2669.7722, -0.0401), GetPlayerDistanceFromPoint(playerid, 352.4596, -2669.7722, -0.0401),
                    GetLocation(641.2187,1238.3390,11.6796), GetPlayerDistanceFromPoint(playerid, 641.2187,1238.3390,11.6796),
                    GetLocation(1037.3827, -305.1682, 74.0922), GetPlayerDistanceFromPoint(playerid, 1037.3827, -305.1682, 74.0922),
                    GetLocation(2118.1814, -1188.9286, 23.9358), GetPlayerDistanceFromPoint(playerid, 2118.1814, -1188.9286, 23.9358),
                    GetLocation(604.9979, -1508.6365, 14.9549), GetPlayerDistanceFromPoint(playerid, 604.9979, -1508.6365, 14.9549),
                    GetLocation(1001.3441, -1445.8391, 13.5469), GetPlayerDistanceFromPoint(playerid, 1001.3441, -1445.8391, 13.5469),
                    GetLocation(-1723.7289, -63.5671, 3.5547), GetPlayerDistanceFromPoint(playerid, -1723.7289, -63.5671, 3.5547),
                    GetLocation(2386.5820,563.6393,10.3691), GetPlayerDistanceFromPoint(playerid, 2386.5820,563.6393,10.3691));
                    ShowPlayerDialog(playerid, LokasiPekerjaan, DIALOG_STYLE_TABLIST_HEADERS, ""NEXODUS"Croire Roleplay "WHITE"- GPS", minsty, "Pilih", "Batal");
    }
    if(playertextid == HandphoneGps[playerid][32])//lokasi Hobi
    {
        			new minsty[1218];
                    format(minsty, sizeof(minsty), "Hobi\tNama\tLokasi\tJarak\
                    \nMemancing #1\tSpot Pemancingan\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Memancing #2\t"GRAY"Penjualan Ikan\t%s\t"YELLOW"%.2f m\
                    \nBerburu #1\tSpot Perburuan\t%s\t"YELLOW"%.2f m\
                    \n"GRAY"Berburu #2\t"GRAY"Penjualan Hasil Buruan\t%s\t"YELLOW"%.2f m\
                    ",
                    GetLocation(383.1566,-2075.2007,7.8359), GetPlayerDistanceFromPoint(playerid, 383.1566,-2075.2007,7.8359),
                    GetLocation(1052.0156,-345.4073,73.9922), GetPlayerDistanceFromPoint(playerid, 1052.0156,-345.4073,73.9922),
                    GetLocation(-387.3126,-2259.8279,45.5646), GetPlayerDistanceFromPoint(playerid, -387.3126,-2259.8279,45.5646),
                    GetLocation(-1693.3431,-88.9088,3.5654), GetPlayerDistanceFromPoint(playerid, -1693.3431,-88.9088,3.5654));
                    ShowPlayerDialog(playerid, LokasiHobi, DIALOG_STYLE_TABLIST_HEADERS, ""NEXODUS"Croire Roleplay "WHITE"- GPS", minsty, "Pilih", "Batal");
    }
    if(playertextid == HandphoneGps[playerid][33])//lokasi Warung
    {
        			new id = WarungNearby(playerid);
                    if(id == -1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada Warung terdekat dari posisi anda!");

                    SetPlayerRaceCheckpoint(playerid, 1, WarungData[id][warungPOS][0], WarungData[id][warungPOS][1], WarungData[id][warungPOS][2], WarungData[id][warungPOS][0], WarungData[id][warungPOS][1], WarungData[id][warungPOS][2], 5.0);
                    pMapCP[playerid] = true;
                    Info(playerid, "Silahkan ikuti tanda blip yang sudah ditandai pada map anda");
    }
    if(playertextid == HandphoneGps[playerid][34])//lokasi Pom
    {
        			new id = GasFuelNearby(playerid);
                    if(id == -1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada Pom Bensin terdekat dari posisi anda!");

                    SetPlayerRaceCheckpoint(playerid, 1, PomNearest[id][0], PomNearest[id][1], PomNearest[id][2], PomNearest[id][0], PomNearest[id][1], PomNearest[id][2], 5.0);
                    pMapCP[playerid] = true;
                    Info(playerid, "Silahkan ikuti tanda blip yang sudah ditandai pada map anda");
    }
    if(playertextid == HandphoneGps[playerid][35])//lokasi toko
    {
        			ShowPlayerDialog(playerid, LokasiPertokoan, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- GPS",
                    "Toko Pakaian Terdekat\
                    \n"GRAY"Toko Elektronik Terdekat", "Pilih", "Batal");
    }
    if(playertextid == HandphoneGps[playerid][36])//lokasi atm
    {
        			new id = NearestAtm(playerid);
                    if(id == -1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada ATM terdekat dari posisi anda!");

                    SetPlayerRaceCheckpoint(playerid, 1, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 5.0);
                    pMapCP[playerid] = true;
                    Info(playerid, "Silahkan ikuti tanda blip yang sudah ditandai pada map anda");
    }
    if(playertextid == HandphoneGps[playerid][37])//lokasi Modshop
    {
        			SetPlayerRaceCheckpoint(playerid, 1, 1101.4049, -1233.4498, 15.8203, 1101.4049, -1233.4498, 15.8203, 5.0);
                    pMapCP[playerid] = true;
                    Info(playerid, "Silahkan ikuti tanda blip yang sudah ditandai pada map anda");
    }
    if(playertextid == HandphoneGps[playerid][48])//disable cekpoint
    {
        			DisablePlayerRaceCheckpoint(playerid);
                    ShowTDN(playerid, NOTIFICATION_SUKSES, "Berhasil menghapus Checkpoint");
                    pMapCP[playerid] = false;
    }
    if(playertextid == HandphoneGps[playerid][49])//disable shareloc
    {
        			if(!IsValidDynamicMapIcon(SharelocSender[playerid]))
                    {
                        return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada yang mengirimkan anda share lokasi!");
                    }
                    else
                    {
                        ShowTDN(playerid, NOTIFICATION_SUKSES, "Berhasil menghapus Shareloc!");

                        DestroyDynamicMapIcon(SharelocSender[playerid]);
                        SharelocSender[playerid] = INVALID_STREAMER_ID;
                        SharelocTimer[playerid] = 0;
                    }
    }
    if(playertextid == HandphoneSetting[playerid][13] || playertextid ==  HandphoneTrans[playerid][13] || playertextid ==  HandphoneGps[playerid][13] || playertextid ==  HandphoneAirdrop[playerid][13] || playertextid == HandphoneSpotify[playerid][13] \
    || playertextid == HandphoneMbanking[playerid][13] || playertextid == HandphoneMenuGame[playerid][13] ||  playertextid ==  HandphoneTelponAngka[playerid][13] || playertextid == HandphoneMenuVehicle[playerid][13] \
     ||  playertextid == HandphoneWhatsapp[playerid][13] || playertextid == HandphoneKontak[playerid][13] || playertextid == HandphoneAds[playerid][13] || playertextid == HandphoneTwitter[playerid][13])
    {
        Toggle_PhoneTD(playerid, true, "aplikasi");
    }
    if(playertextid == HandphoneMenuApk[playerid][13])
    {
        Toggle_PhoneTD(playerid, false);
        CancelSelectTextDraw(playerid);
        ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
        RemovePlayerAttachedObject(playerid, 9);
        AccountData[playerid][phoneShown] = false;
        SendRPMeAboveHead(playerid, "Menutup HP Miliknya.", X11_PLUM1);
    }

    if(playertextid == HandphoneMenuApk[playerid][26])//telepon
    {
        Toggle_PhoneTD(playerid, true, "telpon");
        //ShowPlayerDialog(playerid, DialogTelepon, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Telepon", "Mohon masukan nomor telepon yang ingin anda hubungi:", "Telfon", "Batal");
    }
    if(playertextid == HandphoneMenuApk[playerid][27])//whatsapp
    {
        Toggle_PhoneTD(playerid, true, "whatsapp");
    }
    if(playertextid == HandphoneMenuApk[playerid][28])
    {
        if(BusIndex[playerid] != 0) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang bekerja sebagai supir bus!");
        if(DurringSweeping[playerid]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang bekerja sebagai pembersih jalan!");
        if(PlayerKargoVars[playerid][KargoStarted]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang bekerja sebagai Supir Kargo!");

        if(AccountData[playerid][pFaction] == FACTION_EMS && AccountData[playerid][pDutyEms]) {
            Dialog_Show(playerid, GpsMenu, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Menu Gps",
            "Lokasi GPS\n"GRAY"Signal Emergency (EMS)", "Pilih", "Batal");
        }
		else
		{
		    Toggle_PhoneTD(playerid, true, "gps");
            /*ShowPlayerDialog(playerid, LokasiGps, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Lokasi",
            "Lokasi Umum\
            \n"GRAY"Lokasi Pekerjaan\
            \nLokasi Hobi\
            \n"GRAY"Lokasi Pertokoan\
            \nATM Terdekat\
            \n"GRAY"Garasi Umum Terdekat\
            \nTong Sampah Terdekat\
            \n"GRAY"Warung Terdekat\
            \nPom Bensin Terdekat\
            \n"GRAY"Bengkel Modshop\
            \nRumah Saya\
            \n"RED"(Disable Checkpoint)\
            \n"RED"(Disable Shareloc)", "Pilih", "Batal");*/
        }
    }

	if(playertextid == HandphoneMbanking[playerid][39])
    {
		ShowPlayerDialog(playerid, DialogTransfer, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Transfer",
        "Mohon masukkan nomor rekening yang ingin anda transfer:", "Submit", "Batal");
    }
    if(playertextid == HandphoneMbanking[playerid][40])//delay
    {
		new shstr[255];
		format(shstr, sizeof(shstr), "Kegiatan\tWaktu (Menit)\
		\nMower Sidejob\t%d\
		\n"GRAY"Delivery Sidejob\t"GRAY"%d\
		\nSweeper Sidejob\t%d\
		\n"GRAY"Forklift Sidejob\t"GRAY"%d\
		\nTrashmaster Sidejob\t%d",
		AccountData[playerid][pMowerTime]/60,
		AccountData[playerid][pDeliveryTime]/60,
		AccountData[playerid][pSweeperTime]/60,
		AccountData[playerid][pForkliftTime]/60,
		AccountData[playerid][pTrashmasterDelay]/60);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, ""NEXODUS"Croire Roleplay "WHITE"- Waktu Delay", shstr, "Tutup", "");
    }
    if(playertextid == HandphoneMbanking[playerid][44])//invoice
    {
		ShowPlayerInvoice(playerid);
    }
	//kontak
    new page = PlayerContactPage[playerid];
    new start_index2 = page * 7;
	new end_index = start_index2 + 7;

	for (new i = start_index2; i < end_index && i < MAX_CONTACTS; i ++) if (ContactData[playerid][i][contactExists] && ContactData[playerid][i][contactOwnerID] == AccountData[playerid][pID])
    {
        if(playertextid == HandphoneKontak[playerid][index_kotak_kontak + (i - start_index2)])
        {
            if(ContactData[playerid][i][contactExists])
            {
                AccountData[playerid][pContact] = i;

                ShowPlayerDialog(playerid, DialogContactMenu, DIALOG_STYLE_LIST, sprintf(""NEXODUS"Croire Roleplay"WHITE" - %s", ContactData[playerid][AccountData[playerid][pContact]][contactName]),
                "Panggil\
                \n"GRAY"Shareloc\
                \nEdit Nama Kontak\
                \n"GRAY"Edit Nomor Kontak\
                \nBlokir/Buka Blokir Kontak\
                \n"GRAY"Hapus Kontak", "Pilih", "Batal");
            }
        }
    }
    for (new i = start_index2; i < end_index && i < MAX_CONTACTS; i ++) if (ContactData[playerid][i][contactExists] && ContactData[playerid][i][contactOwnerID] == AccountData[playerid][pID])
    {
        if(playertextid == HandphoneWhatsapp[playerid][index_kotak_whatsapp + (i - start_index2)])
        {
            if(ContactData[playerid][i][contactExists])
            {
                    AccountData[playerid][pContact] = i;
                    new cidt = AccountData[playerid][pContact];
            		new ownernumber = GetNumberOwner(ContactData[playerid][cidt][contactNumber]);
                	if(AccountData[playerid][phoneAirplaneMode])
                        return ShowTDN(playerid, NOTIFICATION_ERROR, "Smartphone sedang dalam Mode Pesawat!");

                    if(!IsPlayerConnected(ownernumber)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Mohon maaf nomor tersebut tidak aktif di kota!");
                    if(CheckNumberBlocked(playerid, AccountData[ownernumber][pPhone])) return ShowTDN(playerid, NOTIFICATION_ERROR, "Nomor tersebut anda blokir, buka terlebih dahulu!");

                    new query[525], harlem[128];
                    mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `whatsapp_chats` WHERE `ID`=%d ORDER BY `chatTimestamp` ASC LIMIT 30", AccountData[playerid][pMaskID]+AccountData[ownernumber][pMaskID]);
                    mysql_query(g_SQL, query);
                    if(cache_num_rows())
                    {
                        if(cache_num_rows() >= 30)
                        {
                            mysql_format(g_SQL, harlem, sizeof(harlem), "DELETE FROM `whatsapp_chats` WHERE `ID`=%d", AccountData[playerid][pMaskID]+AccountData[ownernumber][pMaskID]);
                            mysql_tquery(g_SQL, harlem);
                        }

                        new list[2500], date[64], issuer[24], watext[128];

                        ContactData[playerid][cidt][contactUnread] = 0;
                        mysql_format(g_SQL, query, sizeof(query), "UPDATE `contacts` SET `contactUnread`= 0 WHERE `contactID`=%d", ContactData[playerid][cidt][contactID]);
                        mysql_tquery(g_SQL, query);

                        format(list, sizeof(list), "Tanggal\tPengirim\tPesan\n");
                        for(new iv; iv < cache_num_rows(); ++iv)
                        {
                            cache_get_value_name(iv, "chatTimestamp", date);
                            cache_get_value_name(iv, "chatSender", issuer);
                            cache_get_value_name(iv, "chatMessage", watext);

                            format(list, sizeof(list), "%s%s\t%s\t%s\n", list, date, issuer, watext);
                        }
                        new title[100];
                        format(title, sizeof(title), "WhatsApp Chat - %s", ContactData[playerid][cidt][contactName]);
                        ShowPlayerDialog(playerid, DIALOG_WHATSAPP_CHAT, DIALOG_STYLE_TABLIST_HEADERS, title, list, "Kirim", "Kembali");
                    }
                    else
                    {
                        new list[208], title[102];
                        format(list, sizeof(list), "Tanggal\tPengirim\tPesan\n");
                        format(list, sizeof(list), "%sPesan dan panggilan terenkripsi secara end-to-end.", list);
                        format(title, sizeof(title), "WhatsApp Chat - %s", ContactData[playerid][cidt][contactName]);
                        ShowPlayerDialog(playerid, DIALOG_WHATSAPP_CHAT_EMPTY, DIALOG_STYLE_TABLIST_HEADERS, title, list, "Kirim", "Kembali");
                    }
                    AccountData[playerid][CurrentlyReadWA] = true;
            }
        }
    }
    // Twitter

    if(playertextid == HandphoneTwitter[playerid][60])
    {
        TweetPage[playerid] -= 1;
        ShowPlayerTwitterPage(playerid);
    }
    if(playertextid == HandphoneTwitter[playerid][59])
    {
        TweetPage[playerid] += 1;
        ShowPlayerTwitterPage(playerid);
    }
    if(playertextid == HandphoneTwitter[playerid][29])
    {
        ShowPlayerDialog(playerid, DIALOG_TWITTER_POST_SEND, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "GRAY"- Kirim Tweet", "Masukkan Tweet yang ingin anda buat dibawah sini:", "Kirim", "Kembali");
    }
    if(playertextid == HandphoneAds[playerid][60])
    {
        YellowPage[playerid] -= 1;
        ShowPlayerYellowsPage(playerid);
    }
    if(playertextid == HandphoneAds[playerid][59])
    {
        YellowPage[playerid] += 1;
        ShowPlayerYellowsPage(playerid);
    }

    if(playertextid == HandphoneAds[playerid][29])
    {
        ShowPlayerDialog(playerid, DIALOG_YELLOW_PAGE_MENU, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Yellow Pages",
        "Melihat antrian iklan\nKirim iklan baru", "Pilih", "Batal");    }
    // Phone
    if(playertextid == HandphoneKontak[playerid][40])
    {
        PlayerContactPage[playerid] --;
        ShowContactList(playerid);
    }

    if(playertextid == HandphoneKontak[playerid][39])
    {
        new next_page = PlayerContactPage[playerid] + 1;
        new start_index = next_page * 7;
        if(ContactData[playerid][start_index][contactExists])
        {
            PlayerContactPage[playerid] ++;
            ShowContactList(playerid);
        }
        else
        {
            PlayerContactPage[playerid] = PlayerContactPage[playerid];
            ShowContactList(playerid);
            Error(playerid, "Anda tidak memiliki kontak lagi di halaman selanjutnya!");
        }
    }
    if(playertextid == HandphoneWhatsapp[playerid][40])
    {
        PlayerContactPage[playerid] --;
        ShowWhatsappList(playerid);
    }

    if(playertextid == HandphoneWhatsapp[playerid][39])
    {
        new next_page = PlayerContactPage[playerid] + 1;
        new start_index = next_page * 7;
        if(ContactData[playerid][start_index][contactExists])
        {
            PlayerContactPage[playerid] ++;
            ShowWhatsappList(playerid);
        }
        else
        {
            PlayerContactPage[playerid] = PlayerContactPage[playerid];
            ShowWhatsappList(playerid);
            Error(playerid, "Anda tidak memiliki konta/pesan lagi di halaman selanjutnya!");
        }
    }

    if(playertextid == HandphoneKontak[playerid][29])
    {
        ShowPlayerDialog(playerid, DIALOG_ADD_CONTACT, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Tambah Kontak",
                    "Mohon masukkan nama kontak yang akan disimpan dibawah ini:", "Set", "Batal");
    }

    if(playertextid == HandphoneLockScreen[playerid][13])
    {
        Toggle_PhoneTD(playerid, true, "aplikasi");
    }

    if(playertextid == HandphoneSetting[playerid][27])
    {
		static minsty[200];
  		format(minsty, sizeof(minsty), "Aevhone X25 Milik: %s\
    	\nNomor Telepon: %s\
     	\nNama Series Model: X25\
      	\nNomor Serial: VR81AXS23S33\nIMEI (slot 1): 7182991211\nIMEI (slot 2): 9928192882", ReturnName(playerid), AccountData[playerid][pPhone]);
       	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""NEXODUS"Croire Roleplay "WHITE"- Tentang Ponsel", minsty, "Tutup", "");
    }
    if(playertextid == HandphoneSetting[playerid][28])
    {
		Dialog_Show(playerid, PhoneRingtone, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Ubah Nada Dering",
  		"Mohon masukkan link mp3 yang sudah anda upload dimanapun itu untuk dijadikan sebagai nada dering saat ada panggilan masuk\
    	\nNOTE: Tidak dapat memasukkan link langsung dari YouTube!", "Submit", "Batal");
    }
    if(playertextid == HandphoneSetting[playerid][29])
    {
		AccountData[playerid][phoneCallRingtone][0] = EOS;
  		ShowTDN(playerid, NOTIFICATION_SUKSES, "Berhasil menghapus nada dering!");
    }
    if(playertextid == HandphoneSetting[playerid][30])
    {
		switch(AccountData[playerid][phoneAirplaneMode])
  		{
    		case false:
      		{
        		AccountData[playerid][phoneAirplaneMode] = true;
          		ShowTDN(playerid, NOTIFICATION_INFO, "Anda mengaktifkan Mode Pesawat");
        	}
         	case true:
          	{
           		AccountData[playerid][phoneAirplaneMode] = false;
             	ShowTDN(playerid, NOTIFICATION_INFO, "Anda menonaktifkan Mode Pesawat");
           	}
    	}
    }
    if(playertextid == HandphoneSpotify[playerid][32])//play
    {
    }
    if(playertextid == HandphoneSpotify[playerid][36])//boombox
    {
		if(!AccountData[playerid][pVip]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan pengguna VIP!");

        if(GetPVarType(playerid, "PlacedBB"))
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
			{
				ShowPlayerDialog(playerid, DANN_BOOMBOX, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Boombox", "Matikan Boombox\nPutar Musik", "Select", "Cancel");
			}
			else
			{
	   			return ShowTDN(playerid, NOTIFICATION_ERROR, "~g~[!]~w~: Kamu tidak berada didekat boombox mu!");
			}
	    }
	    else
	    {
	    	ShowTDN(playerid, NOTIFICATION_ERROR, "Kamu tidak menaruh boombox sebelumnya!");
		}
    }
    if(playertextid == HandphoneSpotify[playerid][37])//erapohone
    {
		if(AccountData[playerid][pEarphone] != 1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki Earphone!");

        ShowPlayerDialog(playerid, DialogSpotify, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Spotify", "Matikan Musik\nPutar Musik", "Select", "Cancel");
    }
    if(playertextid == RedButtonincomingCall[playerid])
    {
        foreach(new i : Player) if(IsPlayerConnected(i) && AccountData[i][phoneCallingWithPlayerID] == playerid)
        {
            new phoneCallFromID = i;
            ApplyAnimation(phoneCallFromID, "ped", "phone_out", 4.0, 0, 0, 0, 0, 0, 1);
            RemovePlayerAttachedObject(phoneCallFromID, 9);

            ApplyAnimation(playerid, "ped", "phone_out", 4.0, 0, 0, 0, 0, 0, 1);
            RemovePlayerAttachedObject(playerid, 9);

            if(AccountData[playerid][phoneShown]) {
                AccountData[playerid][phoneShown] = false;
            }

            if(AccountData[phoneCallFromID][phoneShown]) {
                AccountData[phoneCallFromID][phoneShown] = false;
            }

            HideAllSmartphone(playerid), HideAllSmartphone(phoneCallFromID);
            Toggle_CallTD(playerid, false), Toggle_CallTD(phoneCallFromID, false);
            CancelSelectTextDraw(playerid), CancelSelectTextDraw(phoneCallFromID);
            PlayerTextDrawHide(playerid, RedButtonincomingCall[playerid]);
            PlayerTextDrawHide(playerid, GreenButtonincomingCall[playerid]);
            PlayerTextDrawHide(phoneCallFromID, RedButtonoutComingCall[playerid]);
            PlayerTextDrawHide(playerid, GreenCButtonincomingCall[playerid]);
            PlayerTextDrawHide(playerid, RedCButtonincomingCall[playerid]);
            PlayerTextDrawShow(playerid, RedCButtonoutComingCall[playerid]);
            StopAudioStreamForPlayer(playerid);

            AccountData[playerid][phoneCallingTime] = 0;
            AccountData[playerid][phoneCallingWithPlayerID] = INVALID_PLAYER_ID;
            AccountData[playerid][phoneIncomingCall] = false;
            AccountData[playerid][phoneIncomingCall] = false;

            AccountData[phoneCallFromID][phoneCallingTime] = 0;
            AccountData[phoneCallFromID][phoneCallingWithPlayerID] = INVALID_PLAYER_ID;
            AccountData[phoneCallFromID][phoneIncomingCall] = false;
            AccountData[phoneCallFromID][phoneIncomingCall] = false;
        }
    }

    if(playertextid == GreenButtonincomingCall[playerid])
    {
        if(AccountData[playerid][phoneDurringConversation]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang dalam percakapan!");
        if(AccountData[playerid][pInjured]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang pingsan tidak dapat mengangkat panggilan!");
        foreach(new i : Player) if (IsPlayerConnected(i) && AccountData[i][phoneCallingWithPlayerID] == playerid)
        {
            new callingWithPlayerID = i;
            AccountData[playerid][phoneDurringConversation] = true;
            AccountData[playerid][phoneIncomingCall] = false;
            AccountData[playerid][phoneCallingTime] = 0;
            AccountData[playerid][phoneCallingWithPlayerID] = callingWithPlayerID;

            AccountData[callingWithPlayerID][phoneDurringConversation] = true;
            AccountData[callingWithPlayerID][phoneIncomingCall] = false;
            AccountData[callingWithPlayerID][phoneCallingTime] = 0;
            AccountData[callingWithPlayerID][phoneCallingWithPlayerID] = playerid;

            ApplyAnimationEx(playerid, "ped", "phone_talk", 3.1, 0, 1, 0, 1, 1, 1);
            SetPlayerAttachedObject(playerid, 9, 18870, 6,  0.099000, 0.009999, 0.000000,  78.200027, 179.000061, -1.500000,  1.000000, 1.000000, 1.000000); // 276

            ApplyAnimationEx(callingWithPlayerID, "ped", "phone_talk", 3.1, 0, 1, 0, 1, 1, 1);
            SetPlayerAttachedObject(callingWithPlayerID, 9, 18870, 6,  0.099000, 0.009999, 0.000000,  78.200027, 179.000061, -1.500000,  1.000000, 1.000000, 1.000000); // 276

            static contnstr[25];
            format(contnstr, sizeof(contnstr), "%s", AccountData[callingWithPlayerID][pPhone]);
            for(new cid; cid < MAX_CONTACTS; ++cid)
            {
                if(ContactData[playerid][cid][contactExists])
                {
                    if(!strcmp(ContactData[playerid][cid][contactNumber], AccountData[callingWithPlayerID][pPhone], false))
                    {
                        format(contnstr, sizeof(contnstr), "%s", ContactData[playerid][cid][contactName]);
                    }
                }
            }
            PlayerTextDrawSetString(playerid, ContactNameTD[playerid], contnstr);
            StopAudioStreamForPlayer(playerid);

            HideAllSmartphone(playerid), HideAllSmartphone(callingWithPlayerID);
            PlayerTextDrawHide(playerid, GreenButtonincomingCall[playerid]);
            PlayerTextDrawHide(playerid, RedButtonincomingCall[playerid]);
            PlayerTextDrawShow(playerid, RedButtonoutComingCall[playerid]);
            PlayerTextDrawHide(playerid, GreenCButtonincomingCall[playerid]);
            PlayerTextDrawHide(playerid, RedCButtonincomingCall[playerid]);
            PlayerTextDrawShow(playerid, RedCButtonoutComingCall[playerid]);
            Toggle_CallTD(playerid, true), Toggle_CallTD(callingWithPlayerID, true);
            CancelSelectTextDraw(playerid), CancelSelectTextDraw(callingWithPlayerID);
            CallRemoteFunction("ConnectPlayerCalling", "dd", playerid, callingWithPlayerID);
        }
    }

    if(playertextid == RedButtonoutComingCall[playerid])
    {
        new callDurringWithPlayerID = AccountData[playerid][phoneCallingWithPlayerID];
        if(!AccountData[playerid][phoneIncomingCall] && callDurringWithPlayerID != INVALID_PLAYER_ID)
        {
            if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
            {
                ClearAnimations(playerid, 1);
                ApplyAnimation(playerid, "ped", "phone_out", 4.0, 0, 0, 0, 0, 0, 1);
            }

            if(!IsPlayerInAnyVehicle(callDurringWithPlayerID) && GetPlayerState(callDurringWithPlayerID) == PLAYER_STATE_ONFOOT)
            {
                ClearAnimations(callDurringWithPlayerID, 1);
                ApplyAnimation(callDurringWithPlayerID, "ped", "phone_out", 4.0, 0, 0, 0, 0, 0, 1);
            }
            RemovePlayerAttachedObject(playerid, 9);
            RemovePlayerAttachedObject(callDurringWithPlayerID, 9);
            CallRemoteFunction("DisconnectPlayerCalling", "dd", playerid, callDurringWithPlayerID);

            if(AccountData[playerid][phoneShown]) {
                AccountData[playerid][phoneShown] = false;
            }

            if(AccountData[callDurringWithPlayerID][phoneShown]) {
                AccountData[callDurringWithPlayerID][phoneShown] = false;
            }

            HideAllSmartphone(playerid), HideAllSmartphone(callDurringWithPlayerID);
            Toggle_CallTD(playerid, false), Toggle_CallTD(callDurringWithPlayerID, false);
            PlayerTextDrawHide(playerid, RedButtonoutComingCall[playerid]),
			PlayerTextDrawHide(callDurringWithPlayerID, RedButtonoutComingCall[callDurringWithPlayerID]);
            PlayerTextDrawHide(callDurringWithPlayerID, RedButtonincomingCall[callDurringWithPlayerID]),
			PlayerTextDrawHide(callDurringWithPlayerID, GreenButtonincomingCall[callDurringWithPlayerID]);
			PlayerTextDrawHide(playerid, RedCButtonoutComingCall[playerid]),
			PlayerTextDrawHide(callDurringWithPlayerID, RedCButtonoutComingCall[callDurringWithPlayerID]);
            PlayerTextDrawHide(callDurringWithPlayerID, RedCButtonincomingCall[callDurringWithPlayerID]),
			PlayerTextDrawHide(callDurringWithPlayerID, GreenCButtonincomingCall[callDurringWithPlayerID]);
            CancelSelectTextDraw(playerid), CancelSelectTextDraw(callDurringWithPlayerID);
            StopAudioStreamForPlayer(callDurringWithPlayerID);
            AccountData[playerid][phoneCallingWithPlayerID] = INVALID_PLAYER_ID;
            AccountData[playerid][phoneDurringConversation] = false;
            AccountData[playerid][phoneIncomingCall] = false;
            AccountData[playerid][phoneCallingTime] = 0;

            AccountData[callDurringWithPlayerID][phoneCallingWithPlayerID] = INVALID_PLAYER_ID;
            AccountData[callDurringWithPlayerID][phoneDurringConversation] = false;
            AccountData[callDurringWithPlayerID][phoneIncomingCall] = false;
            AccountData[callDurringWithPlayerID][phoneCallingTime] = 0;
            Info(playerid, "Telepon terputus...");
            Info(callDurringWithPlayerID, "Telepon terputus...");
        }
        else
        {
            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
            RemovePlayerAttachedObject(playerid, 9);

            if(AccountData[playerid][phoneShown]) {
                AccountData[playerid][phoneShown] = false;
            }
            PlayerTextDrawHide(playerid, RedButtonoutComingCall[playerid]);
            PlayerTextDrawHide(playerid, RedCButtonoutComingCall[playerid]);
            HideAllSmartphone(playerid);
            Toggle_CallTD(playerid, false);
            CancelSelectTextDraw(playerid);
            AccountData[playerid][phoneCallingWithPlayerID] = INVALID_PLAYER_ID;
            AccountData[playerid][phoneDurringConversation] = false;
            AccountData[playerid][phoneIncomingCall] = false;
            AccountData[playerid][phoneCallingTime] = 0;
            Info(playerid, "Nomor tersebut berada di panggilan lain/tidak aktif...");
        }
    }
    if(playertextid == Garage_TD[playerid][29])
	{
		foreach(new gkid : PublicGarage) if(IsPlayerInRangeOfPoint(playerid, 3.5, PublicGarage[gkid][pgPOS][0], PublicGarage[gkid][pgPOS][1], PublicGarage[gkid][pgPOS][2]))
		{
			new i = AccountData[playerid][pTakeVehicle];

			if(PlayerVehicle[i][pVehParked] != -1)
			{
				GetVehicles(playerid, i, PublicGarage[gkid][pgSpawnPOS][0], PublicGarage[gkid][pgSpawnPOS][1], PublicGarage[gkid][pgSpawnPOS][2], PublicGarage[gkid][pgSpawnPOS][3]);
				SetTimerEx("ForcedPlayerHopInVehicle", 1500, false, "idd", playerid, PlayerVehicle[i][pVehPhysic], 0);
				forex(a, 31)
				{
					PlayerTextDrawHide(playerid, Garage_TD[playerid][a]);
				}
				CancelSelectTextDraw(playerid);
			}
		}
	}
	if(playertextid == Garage_TD[playerid][5])
	{
		AccountData[playerid][pUseGarage] = 0;
		forex(a, 31)
		{
			PlayerTextDrawHide(playerid, Garage_TD[playerid][a]);
		}
		CancelSelectTextDraw(playerid);
	}

	if(playertextid == Garage_TD[playerid][8])
	{
		new vehid = AccountData[playerid][pGarage][0];
		AccountData[playerid][pTakeVehicle] = vehid;

		GarageString(playerid, vehid);
	}

	if(playertextid == Garage_TD[playerid][12])
	{
		new vehid = AccountData[playerid][pGarage][1];
		AccountData[playerid][pTakeVehicle] = vehid;

		GarageString(playerid, vehid);
	}

	if(playertextid == Garage_TD[playerid][16])
	{
		new vehid = AccountData[playerid][pGarage][2];
		AccountData[playerid][pTakeVehicle] = vehid;

		GarageString(playerid, vehid);
	}

	if(playertextid == Garage_TD[playerid][20])
	{
		new vehid = AccountData[playerid][pGarage][3];
		AccountData[playerid][pTakeVehicle] = vehid;

		GarageString(playerid, vehid);
	}
    //===================================================================================

    if(playertextid == FlistDuty[playerid][14]) // CLOSE flist
	{
		PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
		ShowPlayerFactionList(playerid, false);
	}
	if(playertextid == Radial_New[playerid][3]) // CLOSE
	{
		PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
		ShowPlayerRadialNew(playerid, false);
	}
    if (playertextid == Radial_New[playerid][4]) // Inventory
    {
        PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
        ShowPlayerRadialNew(playerid, false);

        if (AccountData[playerid][ActivityTime] != 0)
        {
            CancelSelectTextDraw(playerid);
            return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda sedang melakukan sesuatu, tunggu sampai progress selesai!");
        }

        ShowInventory(playerid);
        PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    }
    if (playertextid == Radial_New[playerid][5]) // Phone
    {
        PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
        ShowPlayerRadialNew(playerid, false);
        ShowingSmartphone(playerid);
    }
    if (playertextid == Radial_New[playerid][6]) // dokumen
    {
        PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
        ShowPlayerRadialNew(playerid, false);
        Dialog_Show(playerid, DOKUMENT_MENU, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Dokument",
        ""YELLOW"Identitas:\
		\n\n> Lihat KTP\
		\n"GRAY"> Tunjukan KTP\
		\n> Lihat SIM\
		\n"GRAY"> Tunjukan SIM\
		\n> Lihat SKWB\
		\n"GRAY"> Tunjukan SKWB\
		\n\n"YELLOW"Dokument:\
		\n\n> Lihat BPJS\
		\n"GRAY"> Perlihatkan BPJS\
		\n> Lihat SKCK\
		\n"GRAY"> Perlihatkan SKCK\
		\n> Lihat SKS\
		\n"GRAY"> Perlihatkan SKS", "Pilih", "Batal");
    }
    if (playertextid == Radial_New[playerid][7]) // toys
    {
        PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPlayerRadialNew(playerid, false);
    	callcmd::fashion(playerid);
    	CancelSelectTextDraw(playerid);
    }
	if(playertextid == Radial_New[playerid][2]) // vehicle
	{
		PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
		ShowPlayerRadialNew(playerid, false);
		new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
		if(vehid == INVALID_VEHICLE_ID) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada kendaraan apapun di sekitar!"), CancelSelectTextDraw(playerid);
		
		static string[178];
		NearestVehicleID[playerid] = vehid;
        format(string, sizeof(string), 
        "Mesin"\
        "\n"GRAY"Kunci\
		\nLampu\
		\n"GRAY"Hood buka/tutup\
		\nTrunk buka/tutup\
		\n"GRAY"Bagasi\
		\nHolster\
		\n"GRAY"Masuk ke dalam bagasi");
		
		ShowPlayerDialog(playerid, DIALOG_VEHICLE_MENU, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Vehicle Menu",
		string, "Pilih", "Batal");
	}
/*
	if(playertextid == Radial_New[playerid][2]) // general
	{
		PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
		ShowPlayerRadialNew(playerid, false);
		new lstr[128];
		strcat(lstr, ""WHITE"Inventory\n");
		strcat(lstr, ""GREY"Dokumen\n");
		strcat(lstr, ""WHITE"Phone\n");
		strcat(lstr, ""GREY"Invoice\n");
		strcat(lstr, ""WHITE"Fashion\n");
		Dialog_Show(playerid, RadialGeneral, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- General Menu", lstr, "Pilih", "Batal");
	}

    if (playertextid == RadialTD2[4]) // Invoice
    {
        PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
        ShowPlayerRadial2(playerid, false);
        ShowPlayerInvoice(playerid);
    }
*/
	if (playertextid == Radial_New[playerid][8]) // action
	{
		/*new frmtx[300], count = 0;

		foreach(new i : Player) if (i != playerid) if (IsPlayerNearPlayer(playerid, i, 2.5))
		{
			format(frmtx, sizeof(frmtx), "%sPlayer ID: %d\n", frmtx, i);
			NearestPlayer[playerid][count++] = i;
		}
			
		if (AccountData[playerid][pFaction] == FACTION_NONE && AccountData[playerid][pFamily] == -1)
		{
			Dialog_Show(playerid, PANEL_NONE, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Menu Warga", "Drag/Undrag Person", "Pilih", "Batal");
			ShowPlayerRadialNew(playerid, false);
		}
		else if (AccountData[playerid][pFaction] == FACTION_TRANS && AccountData[playerid][pFamily] == -1)
		{
			Dialog_Show(playerid, PANEL_NONE, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Menu Warga", "Drag/Undrag Person", "Pilih", "Batal");
			ShowPlayerRadialNew(playerid, false);
		}
		else
		{
			if (count > 0)
			{
				Dialog_Show(playerid, DialogKantongPanel, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE" - Faction Panel", frmtx, "Pilih", "Batal");
			}
			else ShowTDN(playerid, NOTIFICATION_WARNING, "Tidak ada orang disekitar anda!");
			
			return ShowPlayerRadialNew(playerid, false);
		}
		
		if (AccountData[playerid][pFamily] > -1 && AccountData[playerid][pFamilyRank] > 1)
		{
			if (count > 0)
			{
				Dialog_Show(playerid, FamiliesKantongList, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE" - Faction Panel (Gang)", frmtx, "Pilih", "Batal");
			}
			else ShowTDN(playerid, NOTIFICATION_WARNING, "Tidak ada orang disekitar anda!");
			return ShowPlayerRadialNew(playerid, false);
		}*/
		PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
        ShowPlayerRadialNew(playerid, false);
        CancelSelectTextDraw(playerid);
		Dialog_Show(playerid, A_ACTION_LIST, DIALOG_STYLE_LIST, ""LB_E""SERVER_NAME""WHITE_E" - Action Menu", "{FFFFFF}Emote Menu\n{BABABA}Action Panel", "Pilih", "Batal");
	}

    if(playertextid == CroireSpawn[playerid][28])
	{ //last spawn
        if(gettime() < AccountData[playerid][LastSpawn]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tunggu beberapa saat untuk last spawn!");
        if(AccountData[playerid][pPosX] == 0.0 && AccountData[playerid][pPosY] == 0.0 && AccountData[playerid][pPosZ] == 0.0) return ShowTDN(playerid, NOTIFICATION_ERROR, "Pilih tempat spawn lainnya!");
        forex(i, 42) PlayerTextDrawHide(playerid, CroireSpawn[playerid][i]);
        CancelSelectTextDraw(playerid);
		AccountData[playerid][pPosX] = AccountData[playerid][pPosX];
		AccountData[playerid][pPosY] = AccountData[playerid][pPosY];
		AccountData[playerid][pPosZ] = AccountData[playerid][pPosZ];
		AccountData[playerid][pPosA] = AccountData[playerid][pPosA];
        SetPlayerInteriorEx(playerid, AccountData[playerid][pInt]);
        SetPlayerVirtualWorldEx(playerid, AccountData[playerid][pWorld]);
        AccountData[playerid][playerClickSpawn] = 1;
        SetPlayerPositionEx(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ], AccountData[playerid][pPosA], 6000);
    }
    if (playertextid == CroireSpawn[playerid][24])  // House Spawn
    {
        forex(i, 42) PlayerTextDrawHide(playerid, CroireSpawn[playerid][i]);
        CancelSelectTextDraw(playerid);

        new bool:foundHouse = false;
        AccountData[playerid][playerClickSpawn] = 1;
        for(new hid; hid < MAX_RUMAH; hid++) if (HouseData[hid][hsOwnerID] == AccountData[playerid][pID]) 
        {
            foundHouse = true;

            SetPlayerInteriorEx(playerid, 0);
            SetPlayerVirtualWorldEx(playerid, 0); 
            SetPlayerPositionEx(playerid, 
                HouseData[hid][hsExtPos][0], 
                HouseData[hid][hsExtPos][1], 
                HouseData[hid][hsExtPos][2], 
                HouseData[hid][hsExtPos][3], 
                6000
            );
            break;
        }

        if (!foundHouse) 
        {
            ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak memiliki rumah untuk spawn!");
            return 1;
        }
    }


    if(playertextid == CroireSpawn[playerid][23]) {  //carnival
        forex(i, 42) PlayerTextDrawHide(playerid, CroireSpawn[playerid][i]);
        CancelSelectTextDraw(playerid);

		AccountData[playerid][pPosX] = 376.8560;
		AccountData[playerid][pPosY] = -2023.7041;
		AccountData[playerid][pPosZ] = 7.8301;
		AccountData[playerid][pPosA] = 0.0;
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        AccountData[playerid][playerClickSpawn] = 1;
        SetPlayerPositionEx(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ], AccountData[playerid][pPosA], 6000);        
    
    }

    if(playertextid == CroireSpawn[playerid][22]) { //bandara
    
        forex(i, 42) PlayerTextDrawHide(playerid, CroireSpawn[playerid][i]);
        CancelSelectTextDraw(playerid);

		AccountData[playerid][pPosX] = 1651.8059;
		AccountData[playerid][pPosY] = -2286.4407;
		AccountData[playerid][pPosZ] = -1.1715;
		AccountData[playerid][pPosA] = 0.0;
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        AccountData[playerid][playerClickSpawn] = 1;
        SetPlayerPositionEx(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ], AccountData[playerid][pPosA], 6000);        
    
    }

    if(playertextid == CroireSpawn[playerid][25]) { //instansi
    
        return ShowTDN(playerid, NOTIFICATION_ERROR, "instansi Sedang dalam pengembangan!");
    }
    if(playertextid == CroireSpawn[playerid][27]) { //instansi

        return ShowTDN(playerid, NOTIFICATION_ERROR, "property Sedang dalam pengembangan!");
    }
    if(playertextid == CroireSpawn[playerid][26]) { //motel
    
        forex(i, 42) PlayerTextDrawHide(playerid, CroireSpawn[playerid][i]);
        CancelSelectTextDraw(playerid);

		AccountData[playerid][pPosX] = 910.2739;
		AccountData[playerid][pPosY] = -1728.4115;
		AccountData[playerid][pPosZ] = 13.5469;
		AccountData[playerid][pPosA] = 0.0;
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        AccountData[playerid][playerClickSpawn] = 1;
        SetPlayerPositionEx(playerid, AccountData[playerid][pPosX], AccountData[playerid][pPosY], AccountData[playerid][pPosZ], AccountData[playerid][pPosA], 6000);        
    
    }
    // Panel sistem
    /*if(playertextid ==  SmartphonePanel[playerid])// smartphone
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	return ShowingSmartphone(playerid);
    }
    if(playertextid == IdentPanel[playerid])// Identitas
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	ShowPlayerDialog(playerid, DIALOG_PLAYER_MENU, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Identitas",
    	"Lihat KTP\
    	\n"GRAY"Tunjukan KTP\
    	\nLihat SIM\
    	\n"GRAY"Tunjukan SIM\
    	\nTunjukan SKWB", "Pilih", "Batal");
    	CancelSelectTextDraw(playerid);
    }
    if(playertextid == VehiclePanel[playerid])
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
    	if(vehid == INVALID_VEHICLE_ID) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak ada kendaraan apapun di sekitar!"), CancelSelectTextDraw(playerid);

    	static string[178];
    	NearestVehicleID[playerid] = vehid;
    	format(string, sizeof(string), "Kunci\
    	\n"GRAY"Lampu\
    	\nHood buka/tutup\
    	\n"GRAY"Trunk buka/tutup\
    	\nBagasi\
    	\n"GRAY"Holster\
    	\nMasuk ke dalam bagasi");

    	ShowPlayerDialog(playerid, DIALOG_VEHICLE_MENU, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Vehicle Menu",
    	string, "Pilih", "Batal");
    	CancelSelectTextDraw(playerid);
    }
    if(playertextid == InvoicesPanel[playerid])// Invoice
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	ShowPlayerInvoice(playerid);
    	return CancelSelectTextDraw(playerid);
    }
    if(playertextid == DocumentPanel[playerid])// Dokumen
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	ShowPlayerDialog(playerid, DIALOG_PLAYER_DOKUMENT, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Dokumen Pribadi",
    	"Lihat BPJS\
    	\n"GRAY"Perlihatkan BPJS\
    	\nLihat SKCK\
    	\n"GRAY"Perlihatkan SKCK\
    	\nLihat SKS\
    	\n"GRAY"Perlihatkan SKS", "Pilih", "Batal");
    	return CancelSelectTextDraw(playerid);
    }
    if(playertextid == FashionPanel[playerid])// Pakaian
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	callcmd::fashion(playerid);
    	CancelSelectTextDraw(playerid);
    }
    if(playertextid == InventoryPanel[playerid])// Inventory
    {
    	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);

    	if(AccountData[playerid][ActivityTime] != 0)
    	{
    		CancelSelectTextDraw(playerid);
    		return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda sedang melakukan sesuatu, tunggu sampai progress selesai!");
    	}

    	Inventory_Show(playerid);
    	PlayerPlaySound(playerid, 1039, 0.0, 0.0, 0.0);
    	return 1;
    }
    if(playertextid == ClosePanel[playerid])// Close Panel
    {
    	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
    	ShowPanel(playerid, false);
    	CancelSelectTextDraw(playerid);
    }*/
    if (playertextid == Textdraw_Toll[playerid][19])
    {
        new forcount = MuchNumber(sizeof(BarrierInfo));
        for (new i = 0; i < forcount; i ++)
        {
            if (i < sizeof(BarrierInfo))
            {
                if (IsPlayerInRangeOfPoint(playerid, 5.0, BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z]))
                {
                    if (BarrierInfo[i][brOrg] == TEAM_NONE)
                    {
                        if (!BarrierInfo[i][brOpen])
                        {
                            if (AccountData[playerid][pMoney] < 100 && !IsVehicleFaction(GetPlayerVehicleID(playerid)))
                            {
                                ShowTDN(playerid, NOTIFICATION_INFO, "Anda membutuhkan "YELLOW"$100"WHITE" untuk membayar Toll");
                            }
                            else if (IsVehicleFaction(GetPlayerVehicleID(playerid)))
                            {
                                MoveDynamicObject(gBarrier[i], BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z] + 0.7, BARRIER_SPEED, 0.0, 0.0, BarrierInfo[i][brPos_A] + 180);
                                SetTimerEx("BarrierClose", 15000, 0, "i", i);
                                BarrierInfo[i][brOpen] = true;
                                ShowTDN(playerid, NOTIFICATION_INFO, "Hati hati dijalan, Pintu akan tertutup selama 15 detik");
                                if (BarrierInfo[i][brForBarrierID] != -1)
                                {
                                    new barrierid = BarrierInfo[i][brForBarrierID];
                                    MoveDynamicObject(gBarrier[barrierid], BarrierInfo[barrierid][brPos_X], BarrierInfo[barrierid][brPos_Y], BarrierInfo[barrierid][brPos_Z] + 0.7, BARRIER_SPEED, 0.0, 0.0, BarrierInfo[barrierid][brPos_A] + 180);
                                    BarrierInfo[barrierid][brOpen] = true;
                                }
                            }
                            else
                            {
                                MoveDynamicObject(gBarrier[i], BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z] + 0.7, BARRIER_SPEED, 0.0, 0.0, BarrierInfo[i][brPos_A] + 180);
                                SetTimerEx("BarrierClose", 15000, 0, "i", i);
                                BarrierInfo[i][brOpen] = true;
                                ShowTDN(playerid, NOTIFICATION_INFO, "Hati hati dijalan, Pintu akan tertutup selama 15 detik");
                                ShowItemBox(playerid, "Removed $100", "Uang", 1212);
                                TakePlayerMoneyEx(playerid, 100);
                                if (BarrierInfo[i][brForBarrierID] != -1)
                                {
                                    new barrierid = BarrierInfo[i][brForBarrierID];
                                    MoveDynamicObject(gBarrier[barrierid], BarrierInfo[barrierid][brPos_X], BarrierInfo[barrierid][brPos_Y], BarrierInfo[barrierid][brPos_Z] + 0.7, BARRIER_SPEED, 0.0, 0.0, BarrierInfo[barrierid][brPos_A] + 180);
                                    BarrierInfo[barrierid][brOpen] = true;
                                }
                            }
                        }
                    }
                    else ShowTDN(playerid, NOTIFICATION_ERROR, "Anda tidak dapat membuka toll ini!");
                    break;
                }
            }
        }

        for (new txd = 0; txd < 26; txd++)
        {
            PlayerTextDrawHide(playerid, Textdraw_Toll[playerid][txd]);
        }

        CancelSelectTextDraw(playerid);
    }
    /* Clothes Sistem */
    /*if (playertextid == P_MENUCLOTHES[playerid][6]) // Pakaian
    {
        static Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerCameraPos(playerid, x + 0.2, y + 1.4, z + 0.8);
        SetPlayerCameraLookAt(playerid, x, y - 1.0, z + 0.2);
        for (new pdip; pdip < 12; pdip++)
        {
            PlayerTextDrawHide(playerid, P_MENUCLOTHES[playerid][pdip]);
        }

        for (new txd; txd < 16; txd++)
        {
            PlayerTextDrawShow(playerid, P_CLOTHESSELECT[playerid][txd]);
        }
        BuyClothes[playerid] = 1;
        CSelect[playerid] = 0;

        SetPlayerSkin(playerid, (AccountData[playerid][pGender] == 1) ? ClothesSkinMale[CSelect[playerid]] : ClothesSkinFemale[CSelect[playerid]]);

        static minsty[128];
        format(minsty, sizeof minsty, "%02d/%d", CSelect[playerid] + 1, ((AccountData[playerid][pGender] == 1) ? sizeof(ClothesSkinMale) : sizeof(ClothesSkinFemale)));
        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][15], minsty);

        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][8], "PAKAIAN");
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        SelectTextDraw(playerid, 0x72D172FF);
    }
    if (playertextid == P_MENUCLOTHES[playerid][7]) // Topi Dan Helmet
    {
        static Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerCameraPos(playerid, x + 0.2, y + 1.4, z + 1.0);
        SetPlayerCameraLookAt(playerid, x, y - 1.0, z + 0.5);

        for (new txid; txid < 12; txid++)
        {
            PlayerTextDrawHide(playerid, P_MENUCLOTHES[playerid][txid]);
        }

        for (new txd; txd < 16; txd++)
        {
            PlayerTextDrawShow(playerid, P_CLOTHESSELECT[playerid][txd]);
        }
        BuyTopi[playerid] = 1;
        SelectAcc[playerid] = 0;

        RemovePlayerAttachedObject(playerid, 0);
        SetPlayerAttachedObject(playerid, 9, AksesorisHat[SelectAcc[playerid]], 2, 0.356, 0.005, -0.004, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

        static minsty[128];
        format(minsty, sizeof minsty, "%02d/%d", SelectAcc[playerid] + 1, sizeof(AksesorisHat));
        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][15], minsty);

        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][8], "TOPI/HELM");
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        SelectTextDraw(playerid, 0x72D172FF);
    }
    if (playertextid == P_MENUCLOTHES[playerid][8]) // Kacamata Toys
    {
        static Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerCameraPos(playerid, x + 0.2, y + 1.4, z + 1.0);
        SetPlayerCameraLookAt(playerid, x, y - 1.0, z + 0.5);

        for (new txid; txid < 12; txid++)
        {
            PlayerTextDrawHide(playerid, P_MENUCLOTHES[playerid][txid]);
        }

        for (new txd; txd < 16; txd++)
        {
            PlayerTextDrawShow(playerid, P_CLOTHESSELECT[playerid][txd]);
        }
        BuyGlasses[playerid] = 1;
        SelectAcc[playerid] = 0;

        RemovePlayerAttachedObject(playerid, 1);
        SetPlayerAttachedObject(playerid, 9, GlassesToys[SelectAcc[playerid]], 2, 0.35, 0.24, -0.19, 0.0, 90.5, 86.0, 1.0, 1.0, 1.0);

        static minsty[128];
        format(minsty, sizeof minsty, "%02d/%d", SelectAcc[playerid] + 1, sizeof(GlassesToys));
        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][15], minsty);

        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][8], "KACAMATA");
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        SelectTextDraw(playerid, COLOR_GREY);
    }
    if (playertextid == P_MENUCLOTHES[playerid][9]) // Aksesoris
    {
        static Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerCameraPos(playerid, x + 0.2, y + 1.6, z + 0.5);
        SetPlayerCameraLookAt(playerid, x, y - 1.0, z);

        for (new pdip; pdip < 12; pdip++)
        {
            PlayerTextDrawHide(playerid, P_MENUCLOTHES[playerid][pdip]);
        }

        for (new txd; txd < 16; txd++)
        {
            PlayerTextDrawShow(playerid, P_CLOTHESSELECT[playerid][txd]);
        }
        BuyTAksesoris[playerid] = 1;
        SelectAcc[playerid] = 0;

        RemovePlayerAttachedObject(playerid, 2);
        SetPlayerAttachedObject(playerid, 9, AksesorisToys[SelectAcc[playerid]], 2, -0.392, 0.362, 0.000, 0.000, 0.000, 0.0000, 1.000, 1.000, 1.000);

        static minsty[128];
        format(minsty, sizeof minsty, "%02d/%d", SelectAcc[playerid] + 1, sizeof(AksesorisToys));
        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][15], minsty);

        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][8], "AKSESORIS");
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        SelectTextDraw(playerid, 0x72D172FF);
    }
    if (playertextid == P_MENUCLOTHES[playerid][10]) // Tas / Backpack
    {
        static Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerCameraPos(playerid, x + 0.2, y + 1.6, z + 0.5);
        SetPlayerCameraLookAt(playerid, x, y - 1.0, z);

        for (new pdip; pdip < 12; pdip++)
        {
            PlayerTextDrawHide(playerid, P_MENUCLOTHES[playerid][pdip]);
        }

        for (new txd; txd < 16; txd++)
        {
            PlayerTextDrawShow(playerid, P_CLOTHESSELECT[playerid][txd]);
        }
        BuyBackpack[playerid] = 1;
        SelectAcc[playerid] = 0;

        RemovePlayerAttachedObject(playerid, 3);
        SetPlayerAttachedObject(playerid, 9, BackpackToys[SelectAcc[playerid]], 2, -0.392, 0.362, 0.000, 0.000, 0.000, 0.0000, 1.000, 1.000, 1.000);

        static minsty[128];
        format(minsty, sizeof minsty, "%02d/%d", SelectAcc[playerid] + 1, sizeof(BackpackToys));
        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][15], minsty);

        PlayerTextDrawSetString(playerid, P_CLOTHESSELECT[playerid][8], "TAS/KOPER");
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        SelectTextDraw(playerid, 0x72D172FF);
    }
    if (playertextid == P_MENUCLOTHES[playerid][11]) // Batal
    {
        ShowTDN(playerid, NOTIFICATION_INFO, "Anda membatalkan pilihan");
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable(playerid, 1);
        for (new txd; txd < 12; txd ++)
        {
            PlayerTextDrawHide(playerid, P_MENUCLOTHES[playerid][txd]);
        }
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
        CancelSelectTextDraw(playerid);
    }
    if (playertextid == P_CLOTHESSELECT[playerid][14]) // Kembali
    {
        if (BuyClothes[playerid] == 1)
        {
            for (new txd; txd < 16; txd ++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            SetPlayerCameraFacingStore(playerid);
            BuyClothes[playerid] = 0;
            CSelect[playerid] = 0;
            if (AccountData[playerid][pUsingUniform])
            {
                SetPlayerSkin(playerid, AccountData[playerid][pUniform]);
            }
            else
            {
                SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
            }
        }

        if (BuyTopi[playerid] == 1)
        {
            for (new txd; txd < 16; txd ++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            SetPlayerCameraFacingStore(playerid);
            BuyTopi[playerid] = 0;
            SelectAcc[playerid] = 0;
            AttachPlayerToys(playerid);
            RemovePlayerAttachedObject(playerid, 9);
        }

        if (BuyGlasses[playerid] == 1)
        {
            for (new txd; txd < 16; txd ++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            SetPlayerCameraFacingStore(playerid);
            BuyGlasses[playerid] = 0;
            SelectAcc[playerid] = 0;
            AttachPlayerToys(playerid);
            RemovePlayerAttachedObject(playerid, 9);
        }

        if (BuyTAksesoris[playerid] == 1)
        {
            for (new txd; txd < 16; txd ++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            SetPlayerCameraFacingStore(playerid);
            BuyTAksesoris[playerid] = 0;
            SelectAcc[playerid] = 0;
            AttachPlayerToys(playerid);
            RemovePlayerAttachedObject(playerid, 9);
        }

        if (BuyBackpack[playerid] == 1)
        {
            for (new txd; txd < 16; txd ++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            SetPlayerCameraFacingStore(playerid);
            BuyBackpack[playerid] = 0;
            SelectAcc[playerid] = 0;
            AttachPlayerToys(playerid);
            RemovePlayerAttachedObject(playerid, 9);
        }
    }
    if (playertextid == P_CLOTHESSELECT[playerid][13]) // Beli Clothes
    {
        if (BuyClothes[playerid] == 1)
        {
            new price = 200;

            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang tidak cukup! (Price: $200)");
            TakePlayerMoneyEx(playerid, price);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli baju seharga ~g~$200");

            AccountData[playerid][pSkin] = GetPlayerSkin(playerid);
            for (new tx; tx < 16; tx++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][tx]);
            }
            BuyClothes[playerid] = 0;
            SetPlayerSkin(playerid, AccountData[playerid][pSkin]);
            CancelSelectTextDraw(playerid);
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
        }

        if (BuyTopi[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 0;

            new price = 80;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $80)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = AksesorisHat[SelectAcc[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Topi seharga ~g~$80");
            for (new txd; txd < 16; txd++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            BuyTopi[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyGlasses[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 1;

            new price = 50;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $50)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = GlassesToys[SelectAcc[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Kacamata seharga ~g~$50");
            for (new txd; txd < 16; txd++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            BuyGlasses[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyTAksesoris[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 2;

            new price = 100;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: $100)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = AksesorisToys[SelectAcc[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Aksesoris seharga ~g~$100");
            for (new txd; txd < 16; txd++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            BuyTAksesoris[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }

        if (BuyBackpack[playerid] == 1)
        {
            AccountData[playerid][toySelected] = 3;

            new price = 100;
            if (AccountData[playerid][pMoney] < price) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang kamu tidak cukup! (Price: 100)");
            TakePlayerMoneyEx(playerid, price);
            pToys[playerid][AccountData[playerid][toySelected]][toy_model] = BackpackToys[SelectAcc[playerid]];
            pToys[playerid][AccountData[playerid][toySelected]][toy_status] = 1;
            pToys[playerid][AccountData[playerid][toySelected]][toy_x] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_y] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_z] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rx] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_ry] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_rz] = 0.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sx] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sy] = 1.0;
            pToys[playerid][AccountData[playerid][toySelected]][toy_sz] = 1.0;

            ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE"- Ubah Tulang(Bone)",
                             "Spine\
			\n"GRAY"Head\
			\nLeft Upper Arm\
			\n"GRAY"Right Upper Arm\
			\nLeft Hand\
			\n"GRAY"Right Hand\
			\nLeft Thigh\
			\n"GRAY"Right Thigh\
			\nLeft Foot\
			\n"GRAY"Right Foot\
			\nRight Calf\
			\n"GRAY"Left Calf\
			\nLeft Forearm\
			\n"GRAY"Right Forearm\
			\nLeft Clavicle\
			\n"GRAY"Right Clavicle\
			\nNeck\
			\n"GRAY"Jaw", "Select", "Cancel");

            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            ShowTDN(playerid, NOTIFICATION_SUKSES, "Anda membeli Tas seharga ~g~$100");
            for (new txd; txd < 16; txd++)
            {
                PlayerTextDrawHide(playerid, P_CLOTHESSELECT[playerid][txd]);
            }
            BuyBackpack[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            CancelSelectTextDraw(playerid);
        }
        PlayerPlaySound(playerid, 1053, 0, 0, 0);
    }
	*/
    //inventory click new 
    for(new i = 0; i < MAX_INVENTORY; i++)
	{
        // if(playertextid == BOXINV2[playerid][i])
        // {/*
        //     if(LootingOpen[playerid])
        //     {
        //         new otherid = AccountData[playerid][pTarget];
        //         if(InventoryData[otherid][i][invExists])
        //         {
        //             AccountData[playerid][pSelectItem3] = i;
        //             new name[48];
        //             new model = InventoryData[otherid][AccountData[playerid][pSelectItem3]][invModel];
        //             new quantity = InventoryData[otherid][AccountData[playerid][pSelectItem3]][invQuantity];
        //             strunpack(name, InventoryData[otherid][AccountData[playerid][pSelectItem3]][invItem]);        
        //             Inventory_Remove(otherid, name, quantity);
        //             Inventory_Add(playerid, name, model, quantity);
        //             Inventory_Close(playerid);
        //             ShowLooting(playerid, otherid);
        //             SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s loots %s defeated body, searching through their belongings for anything value.", GetName(playerid), GetName(otherid));
        //         }
        //     }*/
        // }
		if (playertextid == Inv_Textdraw[playerid][box_index + i])
        {
            if (InventoryData[playerid][i][invExists]) 
            {
                if (AccountData[playerid][pSelectItem] == -1)
                {
                    // Memilih item pertama
                    AccountData[playerid][pSelectItem] = i;
                }
                else
                {
                    AccountData[playerid][pSelectItem2] = i;

                    new item1Quantity = InventoryData[playerid][AccountData[playerid][pSelectItem]][invQuantity];
                    new item1Model = InventoryData[playerid][AccountData[playerid][pSelectItem]][invModel];
                    new item2Quantity = InventoryData[playerid][AccountData[playerid][pSelectItem2]][invQuantity];
                    new item2Model = InventoryData[playerid][AccountData[playerid][pSelectItem2]][invModel];

                    new item1Name[48], item2Name[48];
                    strunpack(item1Name, InventoryData[playerid][AccountData[playerid][pSelectItem]][invItem]);
                    strunpack(item2Name, InventoryData[playerid][AccountData[playerid][pSelectItem2]][invItem]);

                    Inventory_RemoveID(playerid, item1Name, AccountData[playerid][pSelectItem]);
                    Inventory_RemoveID(playerid, item2Name, AccountData[playerid][pSelectItem2]);

                    Inventory_AddID(playerid, item2Name, item2Model, item2Quantity, AccountData[playerid][pSelectItem]);
                    Inventory_AddID(playerid, item1Name, item1Model, item1Quantity, i);

                    AccountData[playerid][pSelectItem] = -1;
                    AccountData[playerid][pSelectItem2] = -1;

                    Inventory_Close(playerid);
                    ShowInventory(playerid);
                }
            }
            else 
            {
                if (AccountData[playerid][pSelectItem] != -1)
                {
                    new itemQuantity = InventoryData[playerid][AccountData[playerid][pSelectItem]][invQuantity];
                    new itemModel = InventoryData[playerid][AccountData[playerid][pSelectItem]][invModel];
                    new itemName[48];

                    strunpack(itemName, InventoryData[playerid][AccountData[playerid][pSelectItem]][invItem]);

                    Inventory_RemoveID(playerid, itemName, AccountData[playerid][pSelectItem]);

                    Inventory_AddID(playerid, itemName, itemModel, itemQuantity, i);

                    AccountData[playerid][pSelectItem] = -1;

                    Inventory_Close(playerid);
                    ShowInventory(playerid);
                }
            }
        }
	}
    if (playertextid == Inv_Textdraw[playerid][17])
    {
		new id = AccountData[playerid][pSelectItem];
		if(id == -1)
		{
			Info(playerid, "Pilih barang terlebih dahulu");
		}
        else
        {
            Dialog_Show(playerid, DIALOG_INVAMOUNT, DIALOG_STYLE_INPUT, "Inventory Set Amount", "Mohon maukkan berapa jumlah item yang akan diberikan:", 
			"Set", "Batal");
        }  
    }
    if (playertextid == Inv_Textdraw[playerid][18])//give
    {
        if(AccountData[playerid][pSelectItem] == -1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda belum memilih barang!");
		if(AccountData[playerid][pGiveAmount] == 0) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda belum input jumlah yang akan diberikan!");

		new frmxt[355], string[512];
		strunpack(string, InventoryData[playerid][AccountData[playerid][pSelectItem]][invItem]);

		if(!strcmp(string, "Sampah Makanan"))
			return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat memberikan sampah kepada orang lain!");

		if(!strcmp(string, "Boombox"))
			return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat memberikan Boombox kepada orang lain!");

		new count = 0;
		foreach(new i : Player) if(i != playerid) if(IsPlayerNearPlayer(playerid, i, 2.5))
		{
			format(frmxt, sizeof(frmxt), "%sPlayer ID: %d\n", frmxt, i);
			NearestPlayer[playerid][count++] = i;
		}

		if(count == 0)
		{
			PlayerPlaySound(playerid, 5206, 0.0, 0.0, 0.0);
			Inventory_Close(playerid);
			return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""NEXODUS"Croire Roleplay "WHITE"- Give Item",
			"Tidak ada player yang dekat dengan anda!", "Tutup", "");
		}

		Dialog_Show(playerid, DIALOG_GIVEITEM, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Give Item", frmxt, "Pilih", "Close");
    }
    if (playertextid == Inv_Textdraw[playerid][19])//drop
    {
        if(IsPlayerInAnyVehicle(playerid)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak Bisa Membuka Menu Ini Jika Didalam kendaraan");
        if(AccountData[playerid][pBukaWarung] == 1) return Error(playerid, "Tidak Bisa Membuka Menu Ini Jika Sedang Belanja Di warung");
        if(AccountData[playerid][pBukaElektronik] == 1) return Error(playerid, "Tidak Bisa Membuka Menu Ini Jika Sedang Belanja Di Elektronik");
        OpenDropItemTD(playerid);
    }
    /*for(new i = 0; i < 9; i++)
    {
        if (playertextid == Inv_Textdraw[playerid][index_dbox + i])
        {
            if(IsPlayerInAnyVehicle(playerid)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak Bisa Jika Didalam kendaraan");
            new id = Item_Nearest(playerid);

            if(index_dbox + i != -1)
            {
            	if(id != -1)
	            {
                    	if(GetTotalWeightFloat(playerid) >= 150) return ShowTDN(playerid, NOTIFICATION_ERROR, "Inventory anda telah penuh!");
	                    if(Inventory_Items(playerid) >= MAX_INVENTORY) return ShowTDN(playerid, NOTIFICATION_ERROR, "Slot Inventory anda telah penuh!");

	                    if(PickupItem(playerid, id))
	                    {
	                        SendRPMeAboveHead(playerid, "Mengutip sesuatu dari tanah", X11_PLUM1);
	                        ApplyAnimation(playerid, "CARRY", "liftup", 3.1, 0, 0, 0, 0, 0, 1);
	                    }
	                    else ShowTDN(playerid, NOTIFICATION_ERROR, "Inventory anda telah penuh!");

	            }
	            else
	            {
	                	new itemid = AccountData[playerid][pSelectItem];
	                    new string[64],
	                    bnk = InventoryData[playerid][itemid][invQuantity],
	                    model = InventoryData[playerid][AccountData[playerid][pSelectItem]][invModel],
	                    giveAmount = AccountData[playerid][pGiveAmount];
						strunpack(string, InventoryData[playerid][itemid][invItem]);

	                    if(itemid != -1)
	                    {
	                        if (IsPlayerInAnyVehicle(playerid) || !AccountData[playerid][pSpawned])
	                        {
	                            return Error(playerid, "Kamu tidak dapat menjatuhkan item sekarang.");
	                        }

	                        if (giveAmount > bnk || giveAmount < 1)
	                        {
	                            return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah item yang anda masukan tidak cukup sesuai item anda.");
	                        }
	                        new trash_nearest = TrashNearest(playerid);
							if(trash_nearest != -1)
							{
								Inventory_Remove(playerid, string, giveAmount);
								Inventory_Close(playerid);
								AccountData[playerid][pSelectItem] = -1;
								ShowItemBox(playerid, sprintf("Removed %dx", giveAmount), string, model);
								ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
								SendRPMeAboveHead(playerid, sprintf("Membuang %d %s miliknya ke tong sampah", giveAmount, string), X11_PLUM1);
							}
							else
							{
								ShowItemBox(playerid, sprintf("Removed %dx", giveAmount), string, model);
							    DropPlayerItem(playerid, string, giveAmount);
							    Inventory_Remove(playerid, string, giveAmount);
								AccountData[playerid][pSelectItem] = -1;
								Inventory_Close(playerid);
								//Inventory_Close(playerid);
	                        }
	                    }
	                }
            }
            break;
        }
    }*/
    for(new i = 0; i < 9; i++)
    {
        if (playertextid == Inv_Textdraw[playerid][index_dbox + i])
        {
            if(IsPlayerInAnyVehicle(playerid)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak Bisa Jika Didalam kendaraan");
            new id = Item_Nearest(playerid);

            if(index_dbox + i != -1)
            {
            	if(id != -1)
	            {
                    	if(GetTotalWeightFloat(playerid) >= 150) return ShowTDN(playerid, NOTIFICATION_ERROR, "Inventory anda telah penuh!");
	                    if(Inventory_Items(playerid) >= MAX_INVENTORY) return ShowTDN(playerid, NOTIFICATION_ERROR, "Slot Inventory anda telah penuh!");

	                    if(PickupItem(playerid, id))
	                    {
	                        SendRPMeAboveHead(playerid, "Mengutip sesuatu dari tanah", X11_PLUM1);
	                        ApplyAnimation(playerid, "CARRY", "liftup", 3.1, 0, 0, 0, 0, 0, 1);
	                    }
	                    else ShowTDN(playerid, NOTIFICATION_ERROR, "Inventory anda telah penuh!");

	            }
	            else
	            {
            		if(AccountData[playerid][pSelectItem] < 0) return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda belum memilih barang!");
					if(AccountData[playerid][pGiveAmount] == 0) return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda belum menentukan jumlah barang!");
					if(AccountData[playerid][ActivityTime] != 0) return ShowTDN(playerid, NOTIFICATION_WARNING, "Anda sedang melakukan sesuatu, tunggu hingga progress selesai!");

					new itemid = AccountData[playerid][pSelectItem],
						amount = AccountData[playerid][pGiveAmount],
						model = InventoryData[playerid][AccountData[playerid][pSelectItem]][invModel],
						string[ 256 ];

					strunpack(string, InventoryData[playerid][itemid][invItem]);

					new trash_nearest = TrashNearest(playerid);
					if(trash_nearest != -1)
					{
						if(amount < 1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah tidak valid!");
						if(amount > InventoryData[playerid][AccountData[playerid][pSelectItem]][invQuantity]) return ShowTDN(playerid, NOTIFICATION_ERROR, sprintf("Anda tidak memiliki %s sebanyak itu!", string));
						Inventory_Remove(playerid, string, amount);
						Inventory_Close(playerid);
						ShowItemBox(playerid, sprintf("Removed %dx", amount), string, model);
						ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);

						SendRPMeAboveHead(playerid, sprintf("Membuang %d %s miliknya ke tong sampah", amount, string), X11_PLUM1);
					}
					else if(IsPeleburanArea(playerid))
					{
						if(AccountData[playerid][pFaction] != FACTION_POLISI) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan anggota kepolisian!");
						if(AccountData[playerid][pInjured]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sedang pingsan!");
						if(amount < 1 || amount > InventoryData[playerid][AccountData[playerid][pSelectItem]][invQuantity]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah tidak valid!");

						Inventory_Remove(playerid, string, amount);
						Inventory_Close(playerid);
						ShowItemBox(playerid, sprintf("Removed %dx", amount), string, model);
						ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);

						SendRPMeAboveHead(playerid, sprintf("Melempar %d %s ke tempat peleburan", amount, string), X11_PLUM1);
					}
					else
					{
						if(!strcmp(string, "Sampah Makanan"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang sampah sembarangan!");
							return 1;
						}
						else if(!strcmp(string, "Hiu"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Penyu"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Kayu"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Kayu Potongan"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Ayam Hidup"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Ayam Potongan"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Bulu"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Boxmats"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Pancingan"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Umpan"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Batu Kotor"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Batu Bersih"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Petrol"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Pure Oil"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Uang Merah"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
                        else if(!strcmp(string, "Smartphone"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
					 	else if(!strcmp(string, "Boombox"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Penyu"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						else if(!strcmp(string, "Vape"))
						{
							ShowTDN(playerid, NOTIFICATION_ERROR, "Tidak dapat membuang item ini!");
							return 1;
						}
						if(amount < 1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah input tidak valid!");
						if(amount > InventoryData[playerid][itemid][invQuantity]) return ShowTDN(playerid, NOTIFICATION_ERROR, sprintf("Anda tidak memiliki %s sebanyak itu!", string));

						if(!strcmp(string, "Radio", true))
						{
							if(ToggleRadio[playerid] || RadioMicOn[playerid])
							{
								ToggleRadio[playerid] = false;
								RadioMicOn[playerid] = false;
								CallRemoteFunction("UpdatePlayerVoiceMicToggle", "dd", playerid, false);
								CallRemoteFunction("UpdatePlayerVoiceRadioToggle", "dd", playerid, false);
								CallRemoteFunction("AssignFreqToFSVoice", "ddd", playerid, true, 0);
							//	PlayerTextDrawSetString(playerid, ATRP_RadioTD[playerid][7], "0");
							}
						}
						DropPlayerItem(playerid, itemid, amount);
					}
	                }
            }
            break;
        }
    }
    /*for(new i = 0; i < 9; i++)
    {
        if (playertextid == Inv_Textdraw[playerid][index_dbox + i])
        {
            new id = Item_Nearest(playerid);
            
            if(id != -1)
            {
                    if(GetTotalWeightFloat(playerid) >= 150) return ShowTDN(playerid, NOTIFICATION_ERROR, "Inventory anda telah penuh!");
                    if(Inventory_Items(playerid) >= MAX_INVENTORY) return ShowTDN(playerid, NOTIFICATION_ERROR, "Slot Inventory anda telah penuh!");
                    
                    if(PickupItem(playerid, id))
                    {
                        SendRPMeAboveHead(playerid, "Mengutip sesuatu dari tanah", X11_PLUM1);
                        ApplyAnimation(playerid, "CARRY", "liftup", 3.1, 0, 0, 0, 0, 0, 1);
                    }
                    else ShowTDN(playerid, NOTIFICATION_ERROR, "Inventory anda telah penuh!");
            }
            else
            {
                    new itemid = AccountData[playerid][pSelectItem];

                    if(itemid != -1)
                    {
                        new string[64],
	                    bnk = InventoryData[playerid][itemid][invQuantity],
	                    model = InventoryData[playerid][AccountData[playerid][pSelectItem]][invModel],
	                    giveAmount = AccountData[playerid][pGiveAmount];
	                    
                        strunpack(string, InventoryData[playerid][itemid][invItem]);

                        if (IsPlayerInAnyVehicle(playerid) || !AccountData[playerid][pSpawned])
                        {
                            return Error(playerid, "Kamu tidak dapat menjatuhkan item sekarang.");
                        }

                        if (giveAmount > bnk || giveAmount < 1)
                        {
                            return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah item yang anda masukan tidak cukup sesuai item anda.");
                        }
                        new trash_nearest = TrashNearest(playerid);
						if(trash_nearest != -1)
						{
							Inventory_Remove(playerid, string, giveAmount);
							Inventory_Close(playerid);
							ShowItemBox(playerid, sprintf("Removed %dx", giveAmount), string, model);
							ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
							SendRPMeAboveHead(playerid, sprintf("Membuang %d %s miliknya ke tong sampah", giveAmount, string), X11_PLUM1);
						}
						else
						{
                        	DropPlayerItem(playerid, itemid, giveAmount);
                        }
                        AccountData[playerid][pSelectItem] = -1;
                    }
            }
            break;
        }
    }*/
    /*for(new i = 0; i < 9; i++)
    {
        if (playertextid == Inv_Textdraw[playerid][index_dbox + i])
        {
            new itemid = AccountData[playerid][pSelectItem];

            if (itemid != -1)
            {
                new string[64],
                    bnk = InventoryData[playerid][itemid][invQuantity],
                    model = InventoryData[playerid][AccountData[playerid][pSelectItem]][invModel],
                    giveAmount = AccountData[playerid][pGiveAmount];

                strunpack(string, InventoryData[playerid][itemid][invItem]);

                if (IsPlayerInAnyVehicle(playerid) || !AccountData[playerid][pSpawned])
                {
                    return Error(playerid, "Kamu tidak dapat menjatuhkan item sekarang.");
                }

                if (giveAmount > bnk || giveAmount < 1)
                {
                    return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah item yang anda masukan tidak cukup sesuai item anda.");
                }
                new trash_nearest = TrashNearest(playerid);
				if(trash_nearest != -1)
				{
					Inventory_Remove(playerid, string, giveAmount);
					Inventory_Close(playerid);
					ShowItemBox(playerid, sprintf("Removed %dx", giveAmount), string, model);
					ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
					SendRPMeAboveHead(playerid, sprintf("Membuang %d %s miliknya ke tong sampah", giveAmount, string), X11_PLUM1);
				}
				else
				{
                	DropPlayerItem(playerid, itemid, giveAmount);
                }
                AccountData[playerid][pSelectItem] = -1;
            }
		}
	}*/
    // if (playertextid == Inv_Textdraw[playerid][137]) 
    // {
    //     new
    //         itemid = AccountData[playerid][pSelectItem],
    //         string[64],
    //         bnk = InventoryData[playerid][itemid][invQuantity], 
    //         giveAmount = AccountData[playerid][pGiveAmount]; 

    //     strunpack(string, InventoryData[playerid][itemid][invItem]);     

    //     if (IsPlayerInAnyVehicle(playerid) || !AccountData[playerid][pSpawned]) 
    //     {
    //         return Error(playerid, "Kamu tidak dapat menjatuhkan item sekarang.");
    //     }

    //     if (giveAmount > bnk || giveAmount < 1) 
    //     {
    //         return ShowTDN(playerid, NOTIFICATION_ERROR, "Jumlah item yang anda masukan tidak cukup sesuai item anda.");
    //     }

    //     DropPlayerItem(playerid, itemid, giveAmount);
    // }

    if (playertextid == Inv_Textdraw[playerid][20])
    {
        Inventory_Close(playerid);
    }
    if (playertextid == Inv_Textdraw[playerid][21])
    {
        new id = AccountData[playerid][pSelectItem];

        if (id == -1) 
        {
            ShowTDN(playerid, NOTIFICATION_ERROR, "Anda belum memilih item");
        } 
        else 
        {
            new string[64];
            strunpack(string, InventoryData[playerid][id][invItem]);

            if (!PlayerHasItem(playerid, string)) {
                ShowTDN(playerid, NOTIFICATION_ERROR, "Item ini tidak ada di dalam inventory anda");
                ShowInventory(playerid);
            } 
            else 
            {
                //if (ItemCantUse(string)) return ShowTDN(playerid, NOTIFICATION_ERROR, "Item tersebut tidak bisa digunakan!");
                    //OnPlayerUseItem(playerid, id, string);
                    CallLocalFunction("OnPlayerUseItem", "ids", playerid, id, string);

            }
        }
    } 
    if(playertextid == KerjaInfo[playerid][23]) // MEMULAI BEKERJA
	{
		if(ToggleElectric == 1)
		{
			ShowTDN(playerid, NOTIFICATION_ERROR, "Job Electric sedang dimatikan karena alasan tertentu.");
			return 1;
		}

		Dialog_Show(playerid, ElectricanMenu, DIALOG_STYLE_LIST, ""NEXODUS"Croire"WHITE"- Electrican Job",
		"Membuat group baru\n\
		Undang ke dalam group\n\
		Keluarkan dari group\n\
		Join Group\n\
		Mulai Pekerjaan\n\
		Berhenti pekerjaan", "Pilih", "Batal");

		HideElectricianJobTD(playerid);
		return 1;
	}
	else if(playertextid == KerjaInfo[playerid][24]) // MENUTUP
	{
		HideElectricianJobTD(playerid);
		return 1;
	}
	//=================[ SUSUSAPI ]====================
	if(playertextid == SusuInfo[playerid][23]) // MEMULAI KERJA
	{

		ShowPlayerDialog(playerid, DIALOG_SUSU_START, DIALOG_STYLE_LIST, ""NEXODUS"Croire"WHITE"- Susu Job",
		"Mulai Perah susu\nSelesaikan Pekerjaan", "Pilih", "Batal");

		HideSusuJobTD(playerid);
		return 1;
	}
	else if(playertextid == SusuInfo[playerid][24]) // MENUTUP
	{
		HideSusuJobTD(playerid);
		return 1;
	}
    if (playertextid == ElektronikTD[playerid][5])
    {
        if(AccountData[playerid][pMoney] < 1800) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 1800);
        Inventory_Add(playerid, "Smartphone", 18870);
        Inventory_Update(playerid);
        ShowItemBox(playerid, "Received 1x", "Smartphone", 18870);
    }
    if (playertextid == ElektronikTD[playerid][6])
    {
        if(AccountData[playerid][pVip] < 1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan pengguna VIP!");
        if(AccountData[playerid][pMoney] < 500) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        if(PlayerHasItem(playerid, "Boombox")) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sudah memiliki boombox!");
        TakePlayerMoneyEx(playerid, 500);
        Inventory_Update(playerid);
        Inventory_Add(playerid, "Boombox", 2103);
        ShowItemBox(playerid, "Received 1x", "Boombox", 2103);
    }
    if (playertextid == ElektronikTD[playerid][7])
    {
        if(AccountData[playerid][pMoney] < 950) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 950);
        Inventory_Add(playerid, "Radio", 19942);
        Inventory_Update(playerid);
        ShowItemBox(playerid, "Received 1x", "Radio", 19942);
        ShowTDN(playerid, NOTIFICATION_SUKSES, "Pembelian berhasil");
    }
    if (playertextid == ElektronikTD[playerid][8])
    {
        if(AccountData[playerid][pEarphone]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sudah memiliki earphone!");
        if(AccountData[playerid][pMoney] < 300) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 300);
        AccountData[playerid][pEarphone] = 1;
        Inventory_Update(playerid);
        ShowTDN(playerid, NOTIFICATION_SUKSES, "Pembelian berhasil");
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "UPDATE `player_characters` SET `Char_Earphone`=1 WHERE `pID`=%d", AccountData[playerid][pID]);
        mysql_tquery(g_SQL, query);
    }
    if (playertextid == WarungBiasaTD[playerid][12])
    {
        ShowPlayerDialog(playerid, DIALOG_BUY_NASIUDUK, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Warung",
		"Anda akan membeli nasi uduk seharga "GREEN"$250/pcs\n"YELLOW"(Masukkan berapa banyak yang ingin anda beli):", "Beli", "Batal");
    }
    if (playertextid == WarungBiasaTD[playerid][13])
    {
        ShowPlayerDialog(playerid, DIALOG_BUY_AIRMINERAL, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Warung",
		"Anda akan membeli air mineral seharga "GREEN"$200/pcs\n"YELLOW"(Masukkan berapa banyak yang ingin anda beli):", "Beli", "Batal");
    }
    if (playertextid == WarungBiasaTD[playerid][14])
    {
       	if(AccountData[playerid][pMoney] < 150) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
       	TakePlayerMoneyEx(playerid, 150);
       	Inventory_Update(playerid);
		Inventory_Add(playerid, "Rokok", 19896, 12);
  		ShowItemBox(playerid, "Received 12x", "Rokok", 19896);
  		Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][15])
    {
        if(AccountData[playerid][pMoney] < 150) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 150);
		Inventory_Add(playerid, "Korek Api", 19998);
		ShowItemBox(playerid, "Received 1x", "Korek Api", 19998);
		Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][16])
    {
        if(AccountData[playerid][pMoney] < 1000) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 1000);
		Inventory_Add(playerid, "Senter", 18641);
		ShowItemBox(playerid, "Received 1x", "Senter", 18641);
		Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][17])
    {
        if(AccountData[playerid][pMoney] < 80) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 80);
        Inventory_Add(playerid, "Pancingan", 18632);
        ShowItemBox(playerid, "Received 1x", "Pancingan", 18632);
        Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][18])
    {
        ShowPlayerDialog(playerid, DIALOG_BUY_UMPAN, DIALOG_STYLE_INPUT, ""NEXODUS"Croire Roleplay "WHITE"- Warung",
			"Anda akan membeli umpan seharga "GREEN"$18/umpan\n"YELLOW"(Masukkan berapa banyak yang ingin anda beli)", "Beli", "Batal");
    }
    if (playertextid == WarungBiasaTD[playerid][19])
    {
        if(AccountData[playerid][pMoney] < 650) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 650);
        Inventory_Add(playerid, "Masker", 19036);
        ShowItemBox(playerid, "Received 1x", "Masker", 19036);
        Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][20])
    {
        if(AccountData[playerid][pVip] < 1) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda bukan pengguna VIP!");
        if(PlayerHasItem(playerid, "Vape")) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sudah memiliki Vape!");
        if(AccountData[playerid][pMoney] < 650) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 650);
        Inventory_Add(playerid, "Vape", 19823);
        ShowItemBox(playerid, "Received 1x", "Vape", 19823);
        Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][21])
    {
        if(AccountData[playerid][pMoney] < 10000) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 10000);
		Inventory_Add(playerid, "Pilox", 365);
  		ShowItemBox(playerid, "Received 1x", "Pilox", 365);
  		Inventory_Update(playerid);
    }
    if (playertextid == WarungBiasaTD[playerid][22])
    {
        if(AccountData[playerid][pHelmet]) return ShowTDN(playerid, NOTIFICATION_ERROR, "Anda sudah memiliki helm!");
        if(AccountData[playerid][pMoney] < 150) return ShowTDN(playerid, NOTIFICATION_ERROR, "Uang anda tidak mencukupi!");
        TakePlayerMoneyEx(playerid, 150);
        AccountData[playerid][pHelmet] = 1;
        ShowTDN(playerid, NOTIFICATION_SUKSES, "Pembelian berhasil");
        Inventory_Update(playerid);
    }
    return 1;
}

Dialog:DIALOG_INVAMOUNT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if (strval(inputtext) > 20)
			return Error(playerid, "Can't give more than 20");
		AccountData[playerid][pGiveAmount] = strval(inputtext);
		new str[125];
		format(str, sizeof(str), "%d", strval(inputtext));
		PlayerTextDrawSetString(playerid, Inv_Textdraw[playerid][22], str);
	}
    return 1;
}

Dialog:DIALOG_GIVEITEM(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		new userid = GetPlayerListitemValue(playerid, listitem);

		if (userid == INVALID_PLAYER_ID)
		    return Error(playerid, "Invalid player specified");

		if (!IsPlayerNearPlayer(playerid, userid, 5.0))
			return Error(playerid, "You are not near that player");

		if (userid == playerid)
			return Error(playerid, "You can't give items to yourself");

		new value = AccountData[playerid][pGiveAmount];
  		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], InventoryData[playerid][AccountData[playerid][pSelectItem]][invItem], true)){
			Inventory_Remove(playerid, g_aInventoryItems[i][e_InventoryItem], value);
		    Inventory_Add(userid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], value);
		}
    }
    return 1;
}

RemovePlayerWeapon(playerid, weaponid)
{
    // Reset the player's weapons.
    ResetPlayerWeapons(playerid);
    // Set the armed slot to zero.
    SetPlayerArmedWeapon(playerid, 0);
    // Set the weapon in the slot to zero.
    AccountData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
    AccountData[playerid][pACTime] = gettime() + 2;
    // Set the player's weapons.
    SetWeapons(playerid);
    return 1;
}

SetCameraData(playerid)
{
    switch (random(2))
    {
        case 0: //customer parking ganton
        {
            SetPlayerCameraPos(playerid, 902.991, -901.185, 94.368);
            SetPlayerCameraLookAt(playerid, 898.424, -899.630, 93.054);
            InterpolateCameraPos(playerid, 902.991, -901.185, 94.368, 852.659, -880.944, 88.302, 30000, CAMERA_MOVE);
        }
        case 1: // vinewood
        {
            SetPlayerCameraPos(playerid, 485.642, -2111.710, 68.742);
            SetPlayerCameraLookAt(playerid, 483.018, -2107.744, 67.201);
            InterpolateCameraPos(playerid, 485.642, -2111.710, 68.742, 470.870, -2081.438, 61.609, 25000, CAMERA_MOVE);
        }
    }
    return 1;
}
CMD:pos(playerid, params[])
{
	//if(GetPlayerAdminEx(playerid) == 0) return 1;

	new Float: x, Float: y, Float: z;

	if(sscanf(params, "P<,>fff", x, y, z))
		return Info(playerid, "Gunakan: /pos [x y z]");

	//sscanf(params, "P<,>{fff}dd", interior, virtual_world);

	return SetPlayerPos(playerid, x, y, z);
}
CMD:posintvir(playerid, params[])
{
	//if(GetPlayerAdminEx(playerid) == 0) return 1;

	new Float: x, Float: y, Float: z,interior,virtualworld;

	if(sscanf(params, "P<,>fffdd", x, y, z,interior,virtualworld))
		return Info(playerid, "Gunakan: /posintvir [x, y, z, int, vir]");

	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid,interior);
	SetPlayerVirtualWorld(playerid,virtualworld);
	return 1;
}
CMD:savekor(playerid, params[])
{
        new str[256];
        new Float:Pos[MAX_PLAYERS][4];
		new PosSelected[MAX_PLAYERS];
		#define zlta    0xFFFF00AA
        GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
        GetPlayerFacingAngle(playerid,Pos[playerid][3]);
        PosSelected[playerid] = 1;
        format(str,256,"Coordinates succesfully defined: %.4f,%.4f,%.4f,%.4f",Pos[playerid][0],Pos[playerid][1],Pos[playerid][2],Pos[playerid][3]);
        SendClientMessage(playerid,zlta,str);
        new File:fhandle;
        fhandle = fopen("coordinates.txt",io_append);
        fwrite(fhandle,str);
        fclose(fhandle);
        SendClientMessage(playerid,zlta,"Your coordinates has been saved in the file 'coordinates.txt' in your scriptfiles");
        PosSelected[playerid] = 0;
        return 1;
}
CMD:kickveh(playerid, params[])
{
	new
		vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false)
	;

	if(vehicleid == INVALID_VEHICLE_ID)
		return Error(playerid, "you are'nt near any vehicle!");

	if(IsVehicleShaking[vehicleid])
		return Error(playerid, "that vehicle is already kicked!");

    SendCustomMessage(playerid, "KICK-VEH", "you has kick vehicle");

    IsVehicleShaking[vehicleid] = true;
    ShakeVehicle(vehicleid, 0);

    ApplyAnimation(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);

	return 1;
}


forward ShakeVehicle(vehicleid, steps);
public ShakeVehicle(vehicleid, steps)
{
	if(steps >= 6)
	{
		IsVehicleShaking[vehicleid] = false;
		return 1;
	}

	new
		Float:X,
		Float:Y,
		Float:Z,
		Float:A
	;

	GetVehiclePos(vehicleid, X, Y, Z);
	GetVehicleZAngle(vehicleid, A);

	new
		Float:offset = (steps % 2 == 0) ? 2.0 : -2.0
	;

	SetVehicleZAngle(vehicleid, A + offset);

	SetTimerEx("ShakeVehicle", 230, false, "ii", vehicleid, steps + 1);

	return 1;
}
public Compass_UpdateTimer(playerid)
{
    if(CompassVisible[playerid])
    {
        new Float:angle;
        if(IsPlayerInAnyVehicle(playerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            GetVehicleZAngle(vehicleid, angle);
        }
        else
        {
            GetPlayerFacingAngle(playerid, angle);
        }

        // Smooth angle transition
        if(angle != LastAngle[playerid])
        {
            new Float:diff = angle - LastAngle[playerid];
            if(diff > 180.0) diff -= 360.0;
            else if(diff < -180.0) diff += 360.0;

            // Interpolate angle for smoother transition
            LastAngle[playerid] += diff * 0.2;
            if(LastAngle[playerid] >= 360.0) LastAngle[playerid] -= 360.0;
            else if(LastAngle[playerid] < 0.0) LastAngle[playerid] += 360.0;

            // Show all TextDraws first
            for(new i = 0; i < 11; i++)
            {
                PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }

            // Update compass direction based on interpolated angle
            if(LastAngle[playerid] >= 337.5 || LastAngle[playerid] < 22.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "NW");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "315");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "330");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "N");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "30");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "45");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "NE");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 22.5 && LastAngle[playerid] < 67.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "N");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "345");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "0");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "NE");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "60");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "75");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "E");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 67.5 && LastAngle[playerid] < 112.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "NE");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "15");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "30");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "E");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "90");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "105");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "SE");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 112.5 && LastAngle[playerid] < 157.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "E");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "75");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "90");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "SE");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "120");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "135");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "S");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 157.5 && LastAngle[playerid] < 202.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "SE");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "105");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "120");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "S");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "150");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "165");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "SW");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 202.5 && LastAngle[playerid] < 247.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "S");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "135");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "150");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "SW");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "180");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "195");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "W");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 247.5 && LastAngle[playerid] < 292.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "SW");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "165");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "180");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "W");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "210");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "225");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "NW");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
            else if(LastAngle[playerid] >= 292.5 && LastAngle[playerid] < 337.5)
            {
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][2], "W");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][3], "195");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][4], "210");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][5], "NW");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][6], "240");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][7], "255");
                PlayerTextDrawSetString(playerid, JADENCOMPAS[playerid][8], "N");
                for(new i = 2; i <= 8; i++) PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
            }
        }
    }
    return 1;
}

CMD:compass(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
   	{
    if(CompassVisible[playerid])
    {
        CompassVisible[playerid] = false;
        for(new i = 0; i < 11; i++)
        {
            PlayerTextDrawHide(playerid, JADENCOMPAS[playerid][i]);
        }
        if(CompassTimer[playerid])
        {
            KillTimer(CompassTimer[playerid]);
            CompassTimer[playerid] = 0;
        }
        SendClientMessage(playerid, -1, "Compass: "WHITE"Disabled");
    }
    else
    {
        CompassVisible[playerid] = true;
        GetPlayerFacingAngle(playerid, LastAngle[playerid]);
        for(new i = 0; i < 11; i++)
        {
            PlayerTextDrawShow(playerid, JADENCOMPAS[playerid][i]);
        }
        CompassTimer[playerid] = SetTimerEx("Compass_UpdateTimer", 50, true, "i", playerid);
        SendClientMessage(playerid, -1, "Compass: "WHITE"Enabled");
    }
    }
    return 1;
}
CMD:cursor(playerid, params[])
{
	if(isnull(params))
		return Info(playerid, "/cursor ~y~'show/hide'");

	if(!strcmp(params, "show", true))
	{
		SelectTextDraw(playerid, COLOR_GREY);
	}
	else if(!strcmp(params, "hide", true))
	{
		CancelSelectTextDraw(playerid);
	}
	return 1;
}
stock NotifJobs(playerid, message[])
{
	for(new i; i < 6; i++)
	{
		PlayerTextDrawShow(playerid, InfoJoinJobs[playerid][i]);
	}
	PlayerTextDrawSetString(playerid, InfoJoinJobs[playerid][5], message);
	SetTimerEx("HideNotif", 4000, false, "i", playerid);
	return 1;
}

forward HideNotif(playerid);
public HideNotif(playerid)
{
	for(new i; i < 6; i++)
	{
		PlayerTextDrawHide(playerid, InfoJoinJobs[playerid][i]);
	}
}

CMD:elists(playerid, const params[])
{
    Dialog_Show(playerid, ListEmotes, DIALOG_STYLE_LIST, "Daftar Emote", ""SBLUE_E"Emotes\n"GREY_E"Emotes Property\n"SBLUE_E"", "Pilih", "Batal");
    return 1;
}

Dialog:ListEmotes(playerid, response, listitem, inputext[])
{
    if(!response) return 1;

    switch(listitem)
    {
        case 0:
        {
            new str[1500];
            for(new index = 0; index < sizeof(Anim::g_AnimDetails); index ++)
            {
                strcat(str, va_return("%s\n", Anim::g_AnimDetails[index][Anim::e_AnimationName]));
            }
            Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Emotes", str, "Pilih", "Batal");
        }
        case 1:
        {
            new str[1500];
            for(new index = 0; index < sizeof(g_AnimPropDetails); index ++)
            {
                strcat(str, va_return("%s\n", g_AnimPropDetails[index][e_AnimationPropName]));
            }
            Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Emotes Property", str, "Pilih", "Batal");
        }
    }
    return 1;
}

/*CMD:dice(playerid, params[])
{
    if(PlayerInfo[playerid][pLevel] < 2) return SCM(playerid, COLOR_GREY, "Tersedia dari level 2!");

	if(AccountData[playerid][pInDoor] != 16 && AccountData[playerid][pInDoor] != 17 && AccountData[playerid][pInDoor] != 18 && AccountData[playerid][pInDoor] != 19) return Error(playerid, "Anda hanya dapat menggunakan dadu di setiap Casino!");

	extract params -> new to_player, money; else return SCM(playerid, 0xCECECEFF, "Gunakan: /dice [id pemain] [jumlahnya]");

	if(!IsPlayerConnected(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Tidak ada pemain seperti itu");

	if(!ProxDetectorS(5.0, playerid, to_player))
		return SendClientMessage(playerid, 0x999999FF, "Pemainnya terlalu jauh");

    if(AccountData[to_player][pLevel] < 2) return SCM(playerid, COLOR_GREY, "Pemain ini kurang dari level 2!");

	if(!(1000 <= money <= 100000))
		return SendClientMessage(playerid, 0x999999FF, "Jumlahnya tidak boleh kurang dari 1000 dan lebih dari $100000");

	if(AccountData[playerid][pCash] < money)
		return SendClientMessage(playerid, 0x999999FF, "Anda tidak punya uang sebanyak itu");

	if(AccountData[to_player][pCash] < money)
		return SendClientMessage(playerid, 0x999999FF, "Pemain tidak memiliki uang sebanyak itu");

	if(GetPlayerOfferInfo(to_player, O_INCOMING_PLAYER) != INVALID_PLAYER_ID) return SCM(playerid, COLOR_GREY, "Pemain sudah memiliki permintaan pertukaran masuk!");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_DICE, money);

	SCMF(playerid, 0x6BB3FFAA, "Anda menyarankan %s bermain dadu denganmu. Tawaran: $%i", GetPlayerNameEx(to_player), money);
	SCMF(to_player, 0x6BB3FFAA, "%s mengundang Anda untuk bermain dadu. Tawaran: $%i", GetPlayerNameEx(playerid), money);

    return SCM(to_player, -1, "Untuk menyetujui, (/accept) atau untuk penolakan(/cancel)");
}
*/
forward CheckGhostVehicle();
public CheckGhostVehicle()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerInAnyVehicle(i)) continue;

        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(GetPlayerVehicleID(i), vx, vy, vz);

        for(new j = 0; j < MAX_PLAYERS; j++)
        {
            if(i == j || !IsPlayerConnected(j) || IsPlayerInAnyVehicle(j)) continue;

            new Float:px, Float:py, Float:pz;
            GetPlayerPos(j, px, py, pz);

            new Float:dist = GetDistanceBetweenPoints(vx, vy, vz, px, py, pz);

            if(dist < MAX_DIST)
            {
                // Beri peringatan bahwa mungkin ada ghost vehicle
                new string[128];
                format(string, sizeof(string), "[ANTICHEAT] %s (ID:%d) diduga menggunakan Ghost Vehicle!", GetPlayerNameEx(i), i);
                SendClientMessageToAll(0xFF0000FF, string);

                // Bisa tambahkan tindakan (Kick / Ban / Freeze)
                // Kick(i);
            }
        }
    }
    return 1;
}
GetPlayerNameEx(playerid)
{
    static name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
forward AppuieJump(playerid);
public AppuieJump(playerid)
{
    JoueurAppuieJump[playerid] = 0;
    ClearAnimations(playerid);
    return 1;
}
forward AppuiePasJump(playerid);
public AppuiePasJump(playerid)
{
    JoueurAppuieJump[playerid] = 0;
    return 1;
}
Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ, Float:ObjX, Float:ObjY, Float:ObjZ, Float:FrX, Float:FrY, Float:FrZ)
{
        new Float:TGTDistance;

        TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));

        new Float:tmpX, Float:tmpY, Float:tmpZ;

        tmpX = FrX * TGTDistance + CamX;
        tmpY = FrY * TGTDistance + CamY;
        tmpZ = FrZ * TGTDistance + CamZ;

        return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}

Float:GetPointAngleToPoint(Float:x2, Float:y2, Float:X, Float:Y)
{

  new Float:DX, Float:DY;
  new Float:angle;

  DX = floatabs(floatsub(x2,X));
  DY = floatabs(floatsub(y2,Y));

  if (DY == 0.0 || DX == 0.0)
  {
    if(DY == 0 && DX > 0) angle = 0.0;
    else if(DY == 0 && DX < 0) angle = 180.0;
    else if(DY > 0 && DX == 0) angle = 90.0;
    else if(DY < 0 && DX == 0) angle = 270.0;
    else if(DY == 0 && DX == 0) angle = 0.0;
  }
  else
  {
    angle = atan(DX/DY);

    if(X > x2 && Y <= y2) angle += 90.0;
    else if(X <= x2 && Y < y2) angle = floatsub(90.0, angle);
    else if(X < x2 && Y >= y2) angle -= 90.0;
    else if(X >= x2 && Y > y2) angle = floatsub(270.0, angle);
  }
  return floatadd(angle, 90.0);
}
IsPlayerAimingAts(playerid, Float:x, Float:y, Float:z, Float:radius)
{
        new Float:camera_x,Float:camera_y,Float:camera_z,Float:vector_x,Float:vector_y,Float:vector_z;
        GetPlayerCameraPos(playerid, camera_x, camera_y, camera_z);
        GetPlayerCameraFrontVector(playerid, vector_x, vector_y, vector_z);

        new Float:vertical, Float:horizontal;

        switch (GetPlayerWeapon(playerid))
        {
                        case 34,35,36: {
                        if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, vector_x, vector_y, vector_z) < radius) return true;
                        return false;
                        }
                        case 30,31: {vertical = 4.0; horizontal = -1.6;}
                        case 33: {vertical = 2.7; horizontal = -1.0;}
                        default: {vertical = 6.0; horizontal = -2.2;}
        }

        new Float:angle = GetPointAngleToPoint(0, 0, floatsqroot(vector_x*vector_x+vector_y*vector_y), vector_z) - 270.0;
        new Float:resize_x, Float:resize_y, Float:resize_z = floatsin(angle+vertical, degrees);
        GetXYInFrontOfPoint(resize_x, resize_y, GetPointAngleToPoint(0, 0, vector_x, vector_y)+horizontal, floatcos(angle+vertical, degrees));

        if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, resize_x, resize_y, resize_z) < radius) return true;
        return false;
}

stock IsPlayerAimingAtPlayer(playerid, target)
{
        new Float:x, Float:y, Float:z;
        GetPlayerPos(target, x, y, z);
        if (IsPlayerAimingAts(playerid, x, y, z-0.75, 0.25)) return true;
        if (IsPlayerAimingAts(playerid, x, y, z-0.25, 0.25)) return true;
        if (IsPlayerAimingAts(playerid, x, y, z+0.25, 0.25)) return true;
        if (IsPlayerAimingAts(playerid, x, y, z+0.75, 0.25)) return true;
        return false;
}

GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:distance)
{
        x += (distance * floatsin(-angle, degrees));
        y += (distance * floatcos(-angle, degrees));
}

/*CMD:anims(playerid, params[])
{
	new
	animlib[32], animname[32],
	iAnimIndex;

	if(sscanf(params, "d", iAnimIndex))
	    return SyntaxMsg(playerid, "/anims [index]");

	if(iAnimIndex < 1 || iAnimIndex > 1812)
		return InfoMsg(playerid, "Animation Index: {FFFFFF}(Index 1-1812)");
	else
	{
		GetAnimationName(iAnimIndex, animlib, 32, animname, 32);
		PlayAnimation(playerid, animlib, animname);
	}
	return 1;
}*/
CMD:ShowContactList(playerid)
{
	new page = PlayerContactPage[playerid];

	new sha[1046], shstr[1046];
	new count = 0;

	new start_index = page * 15;
	new end_index = start_index + 15;

	strcat(sha, "Nama\tNomor\tStatus\tBlokir\n");
	for (new i = start_index; i < end_index && i < MAX_CONTACTS; i ++) if (ContactData[playerid][i][contactExists] && ContactData[playerid][i][contactOwnerID] == AccountData[playerid][pID])
	{
		new numberowner = GetNumberOwner(ContactData[playerid][i][contactNumber]);
		if(!ContactData[playerid][i][contactUnread])
		{
			format(shstr, sizeof(shstr), "%s\t%s\t%s\t%s\n",
				ContactData[playerid][i][contactName],
				ContactData[playerid][i][contactNumber],
				IsPlayerConnected(numberowner) ? ""LIGHTGREEN"(Online)" : ""ORANGE"(Offline)",
				(ContactData[playerid][i][contactBlocked] == 1) ? ""RED"Diblokir" : ""LIGHTGREEN"-");

			strcat(sha, shstr);
		}
		else
		{
			format(shstr, sizeof(shstr), "%s\t%s\t%s "LIGHTGREY"[%d belum dibaca]\t%s\n",
				ContactData[playerid][i][contactName],
				ContactData[playerid][i][contactNumber],
				IsPlayerConnected(numberowner) ? ""LIGHTGREEN"(Online)" : ""ORANGE"(Offline)",
				ContactData[playerid][i][contactUnread],
				(ContactData[playerid][i][contactBlocked] == 1) ? ""RED"Diblokir" : ""LIGHTGREEN"-");

			strcat(sha, shstr);
		}
		ListedContacts[playerid][count ++] = i;
	}

	if(count)
	{
		if(count == 15)  strcat(sha, ""LIGHTGREEN">> Halaman Selanjutnya\t\n");
		if(page != 0) strcat(sha, ""RED"<< Halaman Sebelumnya\t\n");
		ShowPlayerDialog(playerid, DialogContact, DIALOG_STYLE_TABLIST_HEADERS, sprintf(""NEXODUS"Croire Roleplay "WHITE"- Daftar Kontak (%d/100)", CountPlayerContact(playerid)), sha, "Pilih", "Batal");
		return 1;
	}
	else ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, sprintf(""NEXODUS"Croire Roleplay "WHITE"- Daftar Kontak (%d/100)", CountPlayerContact(playerid)), "Anda tidak memiliki kontak tersimpan!", "Tutup", ""), PlayerContactPage[playerid] = 0;
	return 1;
}

Dialog:A_ACTION_LIST(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			for(new ids = 0; ids < 18; ids++)
	    	{
	        	PlayerTextDrawShow(playerid, EmoteMenu[playerid][ids]);
			}
			SelectTextDraw(playerid, COLOR_LOGS);
		}
		if(listitem == 1)
		{
			new frmtx[300], count = 0;

			foreach(new i : Player) if (i != playerid) if (IsPlayerNearPlayer(playerid, i, 2.5))
			{
				format(frmtx, sizeof(frmtx), "%sPlayer ID: %d\n", frmtx, i);
				NearestPlayer[playerid][count++] = i;
			}

			if (AccountData[playerid][pFaction] == FACTION_NONE && AccountData[playerid][pFamily] == -1)
			{
				Dialog_Show(playerid, PANEL_NONE, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Menu Warga", "Drag/Undrag Person", "Pilih", "Batal");
				ShowPlayerRadialNew(playerid, false);
			}
			else if (AccountData[playerid][pFaction] == FACTION_TRANS && AccountData[playerid][pFamily] == -1)
			{
				Dialog_Show(playerid, PANEL_NONE, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay "WHITE"- Menu Warga", "Drag/Undrag Person", "Pilih", "Batal");
				ShowPlayerRadialNew(playerid, false);
			}
			else
			{
				if (count > 0)
				{
					Dialog_Show(playerid, DialogKantongPanel, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE" - Faction Panel", frmtx, "Pilih", "Batal");
				}
				else ShowTDN(playerid, NOTIFICATION_WARNING, "Tidak ada orang disekitar anda!");

				return ShowPlayerRadialNew(playerid, false);
			}

			if (AccountData[playerid][pFamily] > -1 && AccountData[playerid][pFamilyRank] > 1)
			{
				if (count > 0)
				{
					Dialog_Show(playerid, FamiliesKantongList, DIALOG_STYLE_LIST, ""NEXODUS"Croire Roleplay"WHITE" - Faction Panel (Gang)", frmtx, "Pilih", "Batal");
				}
				else ShowTDN(playerid, NOTIFICATION_WARNING, "Tidak ada orang disekitar anda!");
				return ShowPlayerRadialNew(playerid, false);
			}
		}
	}
	return 1;
}
stock tHBEDITZY(playerid, bool:opsi){
	new Float:health;
	new Float:armour;
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);

	PlayerTextDrawTextSize(playerid, HBEDITZY[playerid][1], 14.500000, health * (-18.000000/100));
	PlayerTextDrawTextSize(playerid, HBEDITZY[playerid][4], 14.500000, armour * (-18.000000/100));
	PlayerTextDrawTextSize(playerid, HBEDITZY[playerid][7], 14.500000, AccountData[playerid][pHunger] * (-18.000000/100));
	PlayerTextDrawTextSize(playerid, HBEDITZY[playerid][10], 14.500000, AccountData[playerid][pThirst] * (-18.000000/100));
	PlayerTextDrawTextSize(playerid, HBEDITZY[playerid][13], 14.500000, AccountData[playerid][pStress] * (-18.000000/100));
	if(opsi){
		for(new i; i < 43; i++){
			PlayerTextDrawShow(playerid, HBEDITZY[playerid][i]);
		}
	}else{
		for(new i; i < 43; i++){
			PlayerTextDrawHide(playerid, HBEDITZY[playerid][i]);
		}
	}
	return 1;
}
function Robberr(playerid)
{
	//InfoTD_MSG(playerid, 8000, "Robbing done!");
	Info(playerid, "Robbing done!");
	TogglePlayerControllable(playerid, 1);
	KillTimer(AccountData[playerid][pActivity]);
	//AccountData[playerid][pEnergy] -= 15;
	AccountData[playerid][pRobSystem] = 0;
	AccountData[playerid][pActivityTime] = 0;
	AccountData[playerid][pRedMoney] += 50;
	ShowItemBox(playerid, "Addx$50", "RedMoney", 1580);
	SendFactionMessage(1, 0xFFD7004A, "[ATM] Terpantau ada seseorang sedang Membobol Atm");
	ClearAnimations(playerid);
	InRob[playerid] = 0;
	//GiveMoneyRob(playerid, 1, 5121);
	SetPVarInt(playerid, "Robb", gettime() + 3600);
	return 1;
}

forward UpdateDamageBar(playerid, Text3D:bar3D, Float:amount, Float:offset, updated, color);
public UpdateDamageBar(playerid, Text3D:bar3D, Float:amount, Float:offset, updated, color) {
    if(!updated--) {
        Delete3DTextLabel(bar3D);
        return 1;
	}
    new damageStr[HEALTH_LENGTH];
    valstr(damageStr, floatround(amount));
    offset += HEALTH_OFFSETADD;
    color -= COLOR_DELETE;
    Update3DTextLabelText(bar3D, color, damageStr);
    #if defined HEALTH_OFFSETADD
        Attach3DTextLabelToPlayer(bar3D, playerid, 0.0, 0.0, offset);
    #endif
    SetTimerEx("UpdateDamageBar", TIME_BLOW, 0, "iiffii", playerid, _:bar3D, amount, offset, updated, color);
    return 1;
}
