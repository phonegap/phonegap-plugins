// QR_Encode.cpp : CQR_Encode クラス インプリメンテーション ファイル
// Date 2006/05/17	Ver. 1.22	Psytec Inc.

#include "QR_Encode.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// QRコードバージョン(型番)情報
static QR_VERSIONINFO QR_VersonInfo[] = {{0}, // (ダミー:Ver.0)
										 { 1, // Ver.1
										    26,   19,   16,   13,    9,
										   0,   0,   0,   0,   0,   0,   0,
										   1,  26,  19,
										   1,  26,  16,
										   1,  26,  13,
										   1,  26,   9,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0},
										 { 2, // Ver.2
										    44,   34,   28,   22,   16,
										   1,  18,   0,   0,   0,   0,   0,
										   1,  44,  34,
										   1,  44,  28,
										   1,  44,  22,
										   1,  44,  16,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0},
										 { 3, // Ver.3
										    70,   55,   44,   34,   26,
										   1,  22,   0,   0,   0,   0,   0,
										   1,  70,  55,
										   1,  70,  44,
										   2,  35,  17,
										   2,  35,  13,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0},
										 { 4, // Ver.4
										   100,   80,   64,   48,   36,
										   1,  26,   0,   0,   0,   0,   0,
										   1, 100,  80,
										   2,  50,  32,
										   2,  50,  24,
										   4,  25,   9,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0},
										 { 5, // Ver.5
										   134,  108,   86,   62,   46,
										   1,  30,   0,   0,   0,   0,   0,
										   1, 134, 108,
										   2,  67,  43,
										   2,  33,  15,
										   2,  33,  11,
										   0,   0,   0,
										   0,   0,   0,
										   2,  34,  16,
										   2,  34,  12},
										 { 6, // Ver.6
										   172,  136,  108,   76,   60,
										   1,  34,   0,   0,   0,   0,   0,
										   2,  86,  68,
										   4,  43,  27,
										   4,  43,  19,
										   4,  43,  15,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0,
										   0,   0,   0},
										 { 7, // Ver.7
										   196,  156,  124,   88,   66,
										   2,  22,  38,   0,   0,   0,   0,
										   2,  98,  78,
										   4,  49,  31,
										   2,  32,  14,
										   4,  39,  13,
										   0,   0,   0,
										   0,   0,   0,
										   4,  33,  15,
										   1,  40,  14},
										 { 8, // Ver.8
										   242,  194,  154,  110,   86,
										   2,  24,  42,   0,   0,   0,   0,
										   2, 121,  97,
										   2,  60,  38,
										   4,  40,  18,
										   4,  40,  14,
										   0,   0,   0,
										   2,  61,  39,
										   2,  41,  19,
										   2,  41,  15},
										 { 9, // Ver.9
										   292,  232,  182,  132,  100,
										   2,  26,  46,   0,   0,   0,   0,
										   2, 146, 116,
										   3,  58,  36,
										   4,  36,  16,
										   4,  36,  12,
										   0,   0,   0,
										   2,  59,  37,
										   4,  37,  17,
										   4,  37,  13},
										 {10, // Ver.10
										   346,  274,  216,  154,  122,
										   2,  28,  50,   0,   0,   0,   0,
										   2,  86,  68,
										   4,  69,  43,
										   6,  43,  19,
										   6,  43,  15,
										   2,  87,  69,
										   1,  70,  44,
										   2,  44,  20,
										   2,  44,  16},
										 {11, // Ver.11
										   404,  324,  254,  180,  140,
										   2,  30,  54,   0,   0,   0,   0,
										   4, 101,  81,
										   1,  80,  50,
										   4,  50,  22,
										   3,  36,  12,
										   0,   0,   0,
										   4,  81,  51,
										   4,  51,  23,
										   8,  37,  13},
										 {12, // Ver.12
										   466,  370,  290,  206,  158,
										   2,  32,  58,   0,   0,   0,   0,
										   2, 116,  92,
										   6,  58,  36,
										   4,  46,  20,
										   7,  42,  14,
										   2, 117,  93,
										   2,  59,  37,
										   6,  47,  21,
										   4,  43,  15},
										 {13, // Ver.13
										   532,  428,  334,  244,  180,
										   2,  34,  62,   0,   0,   0,   0,
										   4, 133, 107,
										   8,  59,  37,
										   8,  44,  20,
										  12,  33,  11,
										   0,   0,   0,
										   1,  60,  38,
										   4,  45,  21,
										   4,  34,  12},
										 {14, // Ver.14
										   581,  461,  365,  261,  197,
										   3,  26,  46,  66,   0,   0,   0,
										   3, 145, 115,
										   4,  64,  40,
										  11,  36,  16,
										  11,  36,  12,
										   1, 146, 116,
										   5,  65,  41,
										   5,  37,  17,
										   5,  37,  13},
										 {15, // Ver.15
										   655,  523,  415,  295,  223,
										   3,  26,  48,  70,   0,   0,   0,
										   5, 109,  87,
										   5,  65,  41,
										   5,  54,  24,
										  11,  36,  12,
										   1, 110,  88,
										   5,  66,  42,
										   7,  55,  25,
										   7,  37,  13},
										 {16, // Ver.16
										   733,  589,  453,  325,  253,
										   3,  26,  50,  74,   0,   0,   0,
										   5, 122,  98,
										   7,  73,  45,
										  15,  43,  19,
										   3,  45,  15,
										   1, 123,  99,
										   3,  74,  46,
										   2,  44,  20,
										  13,  46,  16},
										 {17, // Ver.17
										   815,  647,  507,  367,  283,
										   3,  30,  54,  78,   0,   0,   0,
										   1, 135, 107,
										  10,  74,  46,
										   1,  50,  22,
										   2,  42,  14,
										   5, 136, 108,
										   1,  75,  47,
										  15,  51,  23,
										  17,  43,  15},
										 {18, // Ver.18
										   901,  721,  563,  397,  313,
										   3,  30,  56,  82,   0,   0,   0,
										   5, 150, 120,
										   9,  69,  43,
										  17,  50,  22,
										   2,  42,  14,
										   1, 151, 121,
										   4,  70,  44,
										   1,  51,  23,
										  19,  43,  15},
										 {19, // Ver.19
										   991,  795,  627,  445,  341,
										   3,  30,  58,  86,   0,   0,   0,
										   3, 141, 113,
										   3,  70,  44,
										  17,  47,  21,
										   9,  39,  13,
										   4, 142, 114,
										  11,  71,  45,
										   4,  48,  22,
										  16,  40,  14},
										 {20, // Ver.20
										  1085,  861,  669,  485,  385,
										   3,  34,  62,  90,   0,   0,   0,
										   3, 135, 107,
										   3,  67,  41,
										  15,  54,  24,
										  15,  43,  15,
										   5, 136, 108,
										  13,  68,  42,
										   5,  55,  25,
										  10,  44,  16},
										 {21, // Ver.21
										  1156,  932,  714,  512,  406,
										   4,  28,  50,  72,  94,   0,   0,
										   4, 144, 116,
										  17,  68,  42,
										  17,  50,  22,
										  19,  46,  16,
										   4, 145, 117,
										   0,   0,   0,
										   6,  51,  23,
										   6,  47,  17},
										 {22, // Ver.22
										  1258, 1006,  782,  568,  442,
										   4,  26,  50,  74,  98,   0,   0,
										   2, 139, 111,
										  17,  74,  46,
										   7,  54,  24,
										  34,  37,  13,
										   7, 140, 112,
										   0,   0,   0,
										  16,  55,  25,
										   0,   0,   0},
										 {23, // Ver.23
										  1364, 1094,  860,  614,  464,
										   4,  30,  54,  78, 102,   0,   0,
										   4, 151, 121,
										   4,  75,  47,
										  11,  54,  24,
										  16,  45,  15,
										   5, 152, 122,
										  14,  76,  48,
										  14,  55,  25,
										  14,  46,  16},
										 {24, // Ver.24
										  1474, 1174,  914,  664,  514,
										   4,  28,  54,  80, 106,   0,   0,
										   6, 147, 117,
										   6,  73,  45,
										  11,  54,  24,
										  30,  46,  16,
										   4, 148, 118,
										  14,  74,  46,
										  16,  55,  25,
										   2,  47,  17},
										 {25, // Ver.25
										  1588, 1276, 1000,  718,  538,
										   4,  32,  58,  84, 110,   0,   0,
										   8, 132, 106,
										   8,  75,  47,
										   7,  54,  24,
										  22,  45,  15,
										   4, 133, 107,
										  13,  76,  48,
										  22,  55,  25,
										  13,  46,  16},
										 {26, // Ver.26
										  1706, 1370, 1062,  754,  596,
										   4,  30,  58,  86, 114,   0,   0,
										  10, 142, 114,
										  19,  74,  46,
										  28,  50,  22,
										  33,  46,  16,
										   2, 143, 115,
										   4,  75,  47,
										   6,  51,  23,
										   4,  47,  17},
										 {27, // Ver.27
										  1828, 1468, 1128,  808,  628,
										   4,  34,  62,  90, 118,   0,   0,
										   8, 152, 122,
										  22,  73,  45,
										   8,  53,  23,
										  12,  45,  15,
										   4, 153, 123,
										   3,  74,  46,
										  26,  54,  24,
										  28,  46,  16},
										 {28, // Ver.28
										  1921, 1531, 1193,  871,  661,
										   5,  26,  50,  74,  98, 122,   0,
										   3, 147, 117,
										   3,  73,  45,
										   4,  54,  24,
										  11,  45,  15,
										  10, 148, 118,
										  23,  74,  46,
										  31,  55,  25,
										  31,  46,  16},
										 {29, // Ver.29
										  2051, 1631, 1267,  911,  701,
										   5,  30,  54,  78, 102, 126,   0,
										   7, 146, 116,
										  21,  73,  45,
										   1,  53,  23,
										  19,  45,  15,
										   7, 147, 117,
										   7,  74,  46,
										  37,  54,  24,
										  26,  46,  16},
										 {30, // Ver.30
										  2185, 1735, 1373,  985,  745,
										   5,  26,  52,  78, 104, 130,   0,
										   5, 145, 115,
										  19,  75,  47,
										  15,  54,  24,
										  23,  45,  15,
										  10, 146, 116,
										  10,  76,  48,
										  25,  55,  25,
										  25,  46,  16},
										 {31, // Ver.31
										  2323, 1843, 1455, 1033,  793,
										   5,  30,  56,  82, 108, 134,   0,
										  13, 145, 115,
										   2,  74,  46,
										  42,  54,  24,
										  23,  45,  15,
										   3, 146, 116,
										  29,  75,  47,
										   1,  55,  25,
										  28,  46,  16},
										 {32, // Ver.32
										  2465, 1955, 1541, 1115,  845,
										   5,  34,  60,  86, 112, 138,   0,
										  17, 145, 115,
										  10,  74,  46,
										  10,  54,  24,
										  19,  45,  15,
										   0,   0,   0,
										  23,  75,  47,
										  35,  55,  25,
										  35,  46,  16},
										 {33, // Ver.33
										  2611, 2071, 1631, 1171,  901,
										   5,  30,  58,  86, 114, 142,   0,
										  17, 145, 115,
										  14,  74,  46,
										  29,  54,  24,
										  11,  45,  15,
										   1, 146, 116,
										  21,  75,  47,
										  19,  55,  25,
										  46,  46,  16},
										 {34, // Ver.34
										  2761, 2191, 1725, 1231,  961,
										   5,  34,  62,  90, 118, 146,   0,
										  13, 145, 115,
										  14,  74,  46,
										  44,  54,  24,
										  59,  46,  16,
										   6, 146, 116,
										  23,  75,  47,
										   7,  55,  25,
										   1,  47,  17},
										 {35, // Ver.35
										  2876, 2306, 1812, 1286,  986,
										   6,  30,  54,  78, 102, 126, 150,
										  12, 151, 121,
										  12,  75,  47,
										  39,  54,  24,
										  22,  45,  15,
										   7, 152, 122,
										  26,  76,  48,
										  14,  55,  25,
										  41,  46,  16},
										 {36, // Ver.36
										  3034, 2434, 1914, 1354, 1054,
										   6,  24,  50,  76, 102, 128, 154,
										   6, 151, 121,
										   6,  75,  47,
										  46,  54,  24,
										   2,  45,  15,
										  14, 152, 122,
										  34,  76,  48,
										  10,  55,  25,
										  64,  46,  16},
										 {37, // Ver.37
										  3196, 2566, 1992, 1426, 1096,
										   6,  28,  54,  80, 106, 132, 158,
										  17, 152, 122,
										  29,  74,  46,
										  49,  54,  24,
										  24,  45,  15,
										   4, 153, 123,
										  14,  75,  47,
										  10,  55,  25,
										  46,  46,  16},
										 {38, // Ver.38
										  3362, 2702, 2102, 1502, 1142,
										   6,  32,  58,  84, 110, 136, 162,
										   4, 152, 122,
										  13,  74,  46,
										  48,  54,  24,
										  42,  45,  15,
										  18, 153, 123,
										  32,  75,  47,
										  14,  55,  25,
										  32,  46,  16},
										 {39, // Ver.39
										  3532, 2812, 2216, 1582, 1222,
										   6,  26,  54,  82, 110, 138, 166,
										  20, 147, 117,
										  40,  75,  47,
										  43,  54,  24,
										  10,  45,  15,
										   4, 148, 118,
										   7,  76,  48,
										  22,  55,  25,
										  67,  46,  16},
										 {40, // Ver.40
										  3706, 2956, 2334, 1666, 1276,
										   6,  30,  58,  86, 114, 142, 170,
										  19, 148, 118,
										  18,  75,  47,
										  34,  54,  24,
										  20,  45,  15,
										   6, 149, 119,
										  31,  76,  48,
										  34,  55,  25,
										  61,  46,  16}
										};


/////////////////////////////////////////////////////////////////////////////
// GF(2^8)α指数→整数変換テーブル
static BYTE byExpToInt[] = {  1,   2,   4,   8,  16,  32,  64, 128,  29,  58, 116, 232, 205, 135,  19,  38,
							 76, 152,  45,  90, 180, 117, 234, 201, 143,   3,   6,  12,  24,  48,  96, 192,
							157,  39,  78, 156,  37,  74, 148,  53, 106, 212, 181, 119, 238, 193, 159,  35,
							 70, 140,   5,  10,  20,  40,  80, 160,  93, 186, 105, 210, 185, 111, 222, 161,
							 95, 190,  97, 194, 153,  47,  94, 188, 101, 202, 137,  15,  30,  60, 120, 240,
							253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163,  91, 182, 113, 226,
							217, 175,  67, 134,  17,  34,  68, 136,  13,  26,  52, 104, 208, 189, 103, 206,
							129,  31,  62, 124, 248, 237, 199, 147,  59, 118, 236, 197, 151,  51, 102, 204,
							133,  23,  46,  92, 184, 109, 218, 169,  79, 158,  33,  66, 132,  21,  42,  84,
							168,  77, 154,  41,  82, 164,  85, 170,  73, 146,  57, 114, 228, 213, 183, 115,
							230, 209, 191,  99, 198, 145,  63, 126, 252, 229, 215, 179, 123, 246, 241, 255,
							227, 219, 171,  75, 150,  49,  98, 196, 149,  55, 110, 220, 165,  87, 174,  65,
							130,  25,  50, 100, 200, 141,   7,  14,  28,  56, 112, 224, 221, 167,  83, 166,
							 81, 162,  89, 178, 121, 242, 249, 239, 195, 155,  43,  86, 172,  69, 138,   9,
							 18,  36,  72, 144,  61, 122, 244, 245, 247, 243, 251, 235, 203, 139,  11,  22,
							 44,  88, 176, 125, 250, 233, 207, 131,  27,  54, 108, 216, 173,  71, 142,   1};


/////////////////////////////////////////////////////////////////////////////
// GF(2^8)α整数→指数変換テーブル
static BYTE byIntToExp[] = {  0,   0,   1,  25,   2,  50,  26, 198,   3, 223,  51, 238,  27, 104, 199,  75,
							  4, 100, 224,  14,  52, 141, 239, 129,  28, 193, 105, 248, 200,   8,  76, 113,
							  5, 138, 101,  47, 225,  36,  15,  33,  53, 147, 142, 218, 240,  18, 130,  69,
							 29, 181, 194, 125, 106,  39, 249, 185, 201, 154,   9, 120,  77, 228, 114, 166,
							  6, 191, 139,  98, 102, 221,  48, 253, 226, 152,  37, 179,  16, 145,  34, 136,
							 54, 208, 148, 206, 143, 150, 219, 189, 241, 210,  19,  92, 131,  56,  70,  64,
							 30,  66, 182, 163, 195,  72, 126, 110, 107,  58,  40,  84, 250, 133, 186,  61,
							202,  94, 155, 159,  10,  21, 121,  43,  78, 212, 229, 172, 115, 243, 167,  87,
							  7, 112, 192, 247, 140, 128,  99,  13, 103,  74, 222, 237,  49, 197, 254,  24,
							227, 165, 153, 119,  38, 184, 180, 124,  17,  68, 146, 217,  35,  32, 137,  46,
							 55,  63, 209,  91, 149, 188, 207, 205, 144, 135, 151, 178, 220, 252, 190,  97,
							242,  86, 211, 171,  20,  42,  93, 158, 132,  60,  57,  83,  71, 109,  65, 162,
							 31,  45,  67, 216, 183, 123, 164, 118, 196,  23,  73, 236, 127,  12, 111, 246,
							108, 161,  59,  82,  41, 157,  85, 170, 251,  96, 134, 177, 187, 204,  62,  90,
							203,  89,  95, 176, 156, 169, 160,  81,  11, 245,  22, 235, 122, 117,  44, 215,
							 79, 174, 213, 233, 230, 231, 173, 232, 116, 214, 244, 234, 168,  80,  88, 175};


/////////////////////////////////////////////////////////////////////////////
// 誤り訂正生成多項式α係数
static BYTE byRSExp7[]  = {87, 229, 146, 149, 238, 102,  21};
static BYTE byRSExp10[] = {251,  67,  46,  61, 118,  70,  64,  94,  32,  45};
static BYTE byRSExp13[] = { 74, 152, 176, 100,  86, 100, 106, 104, 130, 218, 206, 140,  78};
static BYTE byRSExp15[] = {  8, 183,  61,  91, 202,  37,  51,  58,  58, 237, 140, 124,   5,  99, 105};
static BYTE byRSExp16[] = {120, 104, 107, 109, 102, 161,  76,   3,  91, 191, 147, 169, 182, 194, 225, 120};
static BYTE byRSExp17[] = { 43, 139, 206,  78,  43, 239, 123, 206, 214, 147,  24,  99, 150,  39, 243, 163, 136};
static BYTE byRSExp18[] = {215, 234, 158,  94, 184,  97, 118, 170,  79, 187, 152, 148, 252, 179,   5,  98,  96, 153};
static BYTE byRSExp20[] = { 17,  60,  79,  50,  61, 163,  26, 187, 202, 180, 221, 225,  83, 239, 156, 164, 212, 212, 188, 190};
static BYTE byRSExp22[] = {210, 171, 247, 242,  93, 230,  14, 109, 221,  53, 200,  74,   8, 172,  98,  80, 219, 134, 160, 105,
						   165, 231};
static BYTE byRSExp24[] = {229, 121, 135,  48, 211, 117, 251, 126, 159, 180, 169, 152, 192, 226, 228, 218, 111,   0, 117, 232,
						    87,  96, 227,  21};
static BYTE byRSExp26[] = {173, 125, 158,   2, 103, 182, 118,  17, 145, 201, 111,  28, 165,  53, 161,  21, 245, 142,  13, 102,
						    48, 227, 153, 145, 218,  70};
static BYTE byRSExp28[] = {168, 223, 200, 104, 224, 234, 108, 180, 110, 190, 195, 147, 205,  27, 232, 201,  21,  43, 245,  87,
						    42, 195, 212, 119, 242,  37,   9, 123};
static BYTE byRSExp30[] = { 41, 173, 145, 152, 216,  31, 179, 182,  50,  48, 110,  86, 239,  96, 222, 125,  42, 173, 226, 193,
						   224, 130, 156,  37, 251, 216, 238,  40, 192, 180};
static BYTE byRSExp32[] = { 10,   6, 106, 190, 249, 167,   4,  67, 209, 138, 138,  32, 242, 123,  89,  27, 120, 185,  80, 156,
						    38,  69, 171,  60,  28, 222,  80,  52, 254, 185, 220, 241};
static BYTE byRSExp34[] = {111,  77, 146,  94,  26,  21, 108,  19, 105,  94, 113, 193,  86, 140, 163, 125,  58, 158, 229, 239,
						   218, 103,  56,  70, 114,  61, 183, 129, 167,  13,  98,  62, 129,  51};
static BYTE byRSExp36[] = {200, 183,  98,  16, 172,  31, 246, 234,  60, 152, 115,   0, 167, 152, 113, 248, 238, 107,  18,  63,
						   218,  37,  87, 210, 105, 177, 120,  74, 121, 196, 117, 251, 113, 233,  30, 120};
static BYTE byRSExp38[] = {159,  34,  38, 228, 230,  59, 243,  95,  49, 218, 176, 164,  20,  65,  45, 111,  39,  81,  49, 118,
						   113, 222, 193, 250, 242, 168, 217,  41, 164, 247, 177,  30, 238,  18, 120, 153,  60, 193};
static BYTE byRSExp40[] = { 59, 116,  79, 161, 252,  98, 128, 205, 128, 161, 247,  57, 163,  56, 235, 106,  53,  26, 187, 174,
						   226, 104, 170,   7, 175,  35, 181, 114,  88,  41,  47, 163, 125, 134,  72,  20, 232,  53,  35,  15};
static BYTE byRSExp42[] = {250, 103, 221, 230,  25,  18, 137, 231,   0,   3,  58, 242, 221, 191, 110,  84, 230,   8, 188, 106,
						    96, 147,  15, 131, 139,  34, 101, 223,  39, 101, 213, 199, 237, 254, 201, 123, 171, 162, 194, 117,
						    50,  96};
static BYTE byRSExp44[] = {190,   7,  61, 121,  71, 246,  69,  55, 168, 188,  89, 243, 191,  25,  72, 123,   9, 145,  14, 247,
						     1, 238,  44,  78, 143,  62, 224, 126, 118, 114,  68, 163,  52, 194, 217, 147, 204, 169,  37, 130,
						   113, 102,  73, 181};
static BYTE byRSExp46[] = {112,  94,  88, 112, 253, 224, 202, 115, 187,  99,  89,   5,  54, 113, 129,  44,  58,  16, 135, 216,
						   169, 211,  36,   1,   4,  96,  60, 241,  73, 104, 234,   8, 249, 245, 119, 174,  52,  25, 157, 224,
						    43, 202, 223,  19,  82,  15};
static BYTE byRSExp48[] = {228,  25, 196, 130, 211, 146,  60,  24, 251,  90,  39, 102, 240,  61, 178,  63,  46, 123, 115,  18,
						   221, 111, 135, 160, 182, 205, 107, 206,  95, 150, 120, 184,  91,  21, 247, 156, 140, 238, 191,  11,
						    94, 227,  84,  50, 163,  39,  34, 108};
static BYTE byRSExp50[] = {232, 125, 157, 161, 164,   9, 118,  46, 209,  99, 203, 193,  35,   3, 209, 111, 195, 242, 203, 225,
						    46,  13,  32, 160, 126, 209, 130, 160, 242, 215, 242,  75,  77,  42, 189,  32, 113,  65, 124,  69,
						   228, 114, 235, 175, 124, 170, 215, 232, 133, 205};
static BYTE byRSExp52[] = {116,  50,  86, 186,  50, 220, 251,  89, 192,  46,  86, 127, 124,  19, 184, 233, 151, 215,  22,  14,
						    59, 145,  37, 242, 203, 134, 254,  89, 190,  94,  59,  65, 124, 113, 100, 233, 235, 121,  22,  76,
						    86,  97,  39, 242, 200, 220, 101,  33, 239, 254, 116,  51};
static BYTE byRSExp54[] = {183,  26, 201,  87, 210, 221, 113,  21,  46,  65,  45,  50, 238, 184, 249, 225, 102,  58, 209, 218,
						   109, 165,  26,  95, 184, 192,  52, 245,  35, 254, 238, 175, 172,  79, 123,  25, 122,  43, 120, 108,
						   215,  80, 128, 201, 235,   8, 153,  59, 101,  31, 198,  76,  31, 156};
static BYTE byRSExp56[] = {106, 120, 107, 157, 164, 216, 112, 116,   2,  91, 248, 163,  36, 201, 202, 229,   6, 144, 254, 155,
						   135, 208, 170, 209,  12, 139, 127, 142, 182, 249, 177, 174, 190,  28,  10,  85, 239, 184, 101, 124,
						   152, 206,  96,  23, 163,  61,  27, 196, 247, 151, 154, 202, 207,  20,  61,  10};
static BYTE byRSExp58[] = { 82, 116,  26, 247,  66,  27,  62, 107, 252, 182, 200, 185, 235,  55, 251, 242, 210, 144, 154, 237,
						   176, 141, 192, 248, 152, 249, 206,  85, 253, 142,  65, 165, 125,  23,  24,  30, 122, 240, 214,   6,
						   129, 218,  29, 145, 127, 134, 206, 245, 117,  29,  41,  63, 159, 142, 233, 125, 148, 123};
static BYTE byRSExp60[] = {107, 140,  26,  12,   9, 141, 243, 197, 226, 197, 219,  45, 211, 101, 219, 120,  28, 181, 127,   6,
						   100, 247,   2, 205, 198,  57, 115, 219, 101, 109, 160,  82,  37,  38, 238,  49, 160, 209, 121,  86,
						    11, 124,  30, 181,  84,  25, 194,  87,  65, 102, 190, 220,  70,  27, 209,  16,  89,   7,  33, 240};
static BYTE byRSExp62[] = { 65, 202, 113,  98,  71, 223, 248, 118, 214,  94,   0, 122,  37,  23,   2, 228,  58, 121,   7, 105,
						   135,  78, 243, 118,  70,  76, 223,  89,  72,  50,  70, 111, 194,  17, 212, 126, 181,  35, 221, 117,
						   235,  11, 229, 149, 147, 123, 213,  40, 115,   6, 200, 100,  26, 246, 182, 218, 127, 215,  36, 186,
						   110, 106};
static BYTE byRSExp64[] = { 45,  51, 175,   9,   7, 158, 159,  49,  68, 119,  92, 123, 177, 204, 187, 254, 200,  78, 141, 149,
						   119,  26, 127,  53, 160,  93, 199, 212,  29,  24, 145, 156, 208, 150, 218, 209,   4, 216,  91,  47,
						   184, 146,  47, 140, 195, 195, 125, 242, 238,  63,  99, 108, 140, 230, 242,  31, 204,  11, 178, 243,
						   217, 156, 213, 231};
static BYTE byRSExp66[] = {  5, 118, 222, 180, 136, 136, 162,  51,  46, 117,  13, 215,  81,  17, 139, 247, 197, 171,  95, 173,
						    65, 137, 178,  68, 111,  95, 101,  41,  72, 214, 169, 197,  95,   7,  44, 154,  77, 111, 236,  40,
						   121, 143,  63,  87,  80, 253, 240, 126, 217,  77,  34, 232, 106,  50, 168,  82,  76, 146,  67, 106,
						   171,  25, 132,  93,  45, 105};
static BYTE byRSExp68[] = {247, 159, 223,  33, 224,  93,  77,  70,  90, 160,  32, 254,  43, 150,  84, 101, 190, 205, 133,  52,
						    60, 202, 165, 220, 203, 151,  93,  84,  15,  84, 253, 173, 160,  89, 227,  52, 199,  97,  95, 231,
						    52, 177,  41, 125, 137, 241, 166, 225, 118,   2,  54,  32,  82, 215, 175, 198,  43, 238, 235,  27,
						   101, 184, 127,   3,   5,   8, 163, 238};

static LPBYTE  byRSExp[] = {NULL,      NULL,      NULL,      NULL,      NULL,      NULL,      NULL,      byRSExp7,  NULL,      NULL,
							byRSExp10, NULL,      NULL,      byRSExp13, NULL,      byRSExp15, byRSExp16, byRSExp17, byRSExp18, NULL,
							byRSExp20, NULL,      byRSExp22, NULL,      byRSExp24, NULL,      byRSExp26, NULL,      byRSExp28, NULL,
							byRSExp30, NULL,      byRSExp32, NULL,      byRSExp34, NULL,      byRSExp36, NULL,      byRSExp38, NULL,
							byRSExp40, NULL,      byRSExp42, NULL,      byRSExp44, NULL,      byRSExp46, NULL,      byRSExp48, NULL,
							byRSExp50, NULL,      byRSExp52, NULL,      byRSExp54, NULL,      byRSExp56, NULL,      byRSExp58, NULL,
							byRSExp60, NULL,      byRSExp62, NULL,      byRSExp64, NULL,      byRSExp66, NULL,      byRSExp68};

// 文字数インジケータビット長(バージョングループ別, {S, M, L})
static int nIndicatorLenNumeral[]  = {10, 12, 14};
static int nIndicatorLenAlphabet[] = { 9, 11, 13};
static int nIndicatorLen8Bit[]	   = { 8, 16, 16};
static int nIndicatorLenKanji[]	   = { 8, 10, 12};


/////////////////////////////////////////////////////////////////////////////
// QR_Encode クラスの構築/消滅

CQR_Encode::CQR_Encode()
{
}

CQR_Encode::~CQR_Encode()
{
}

int min(int a, int b) {
    if (a<=b) {
        return a;
    }
    else {
        return b;
    }
}

/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::EncodeData
// 用  途：データエンコード
// 引  数：誤り訂正レベル、型番(0=自動)、型番自動拡張フラグ、マスキング番号(-1=自動)、エンコードデータ、エンコードデータ長
// 戻り値：エンコード成功時=true、データなし、または容量オーバー時=false

bool CQR_Encode::EncodeData(int nLevel, int nVersion, bool bAutoExtent, int nMaskingNo, LPCSTR lpsSource, int ncSource)
{
	int i, j;

	m_nLevel = nLevel;
	m_nMaskingNo = nMaskingNo;

	// データ長が指定されていない場合は lstrlen によって取得
	int ncLength = ncSource > 0 ? ncSource : strlen(lpsSource);

	if (ncLength == 0)
		return false; // データなし

	// バージョン(型番)チェック
	int nEncodeVersion = GetEncodeVersion(nVersion, lpsSource, ncLength);

	if (nEncodeVersion == 0)
		return false; // 容量オーバー

	if (nVersion == 0)
	{
		// 型番自動
		m_nVersion = nEncodeVersion;
	}
	else
	{
		if (nEncodeVersion <= nVersion)
		{
			m_nVersion = nVersion;
		}
		else
		{
			if (bAutoExtent)
				m_nVersion = nEncodeVersion; // バージョン(型番)自動拡張
			else
				return false; // 容量オーバー
		}
	}

	// ターミネータコード"0000"付加
	int ncDataCodeWord = QR_VersonInfo[m_nVersion].ncDataCodeWord[nLevel];

	int ncTerminater = min(4, (ncDataCodeWord * 8) - m_ncDataCodeWordBit);

	if (ncTerminater > 0)
		m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 0, ncTerminater);

	// パディングコード"11101100, 00010001"付加
	BYTE byPaddingCode = 0xec;

	for (i = (m_ncDataCodeWordBit + 7) / 8; i < ncDataCodeWord; ++i)
	{
		m_byDataCodeWord[i] = byPaddingCode;

		byPaddingCode = (BYTE)(byPaddingCode == 0xec ? 0x11 : 0xec);
	}

	// 総コードワード算出エリアクリア
	m_ncAllCodeWord = QR_VersonInfo[m_nVersion].ncAllCodeWord;
	ZeroMemory(m_byAllCodeWord, m_ncAllCodeWord);

	int nDataCwIndex = 0; // データコードワード処理位置

	// データブロック分割数
	int ncBlock1 = QR_VersonInfo[m_nVersion].RS_BlockInfo1[nLevel].ncRSBlock;
	int ncBlock2 = QR_VersonInfo[m_nVersion].RS_BlockInfo2[nLevel].ncRSBlock;
	int ncBlockSum = ncBlock1 + ncBlock2;

	int nBlockNo = 0; // 処理中ブロック番号

	// ブロック別データコードワード数
	int ncDataCw1 = QR_VersonInfo[m_nVersion].RS_BlockInfo1[nLevel].ncDataCodeWord;
	int ncDataCw2 = QR_VersonInfo[m_nVersion].RS_BlockInfo2[nLevel].ncDataCodeWord;

	// データコードワードインターリーブ配置
	for (i = 0; i < ncBlock1; ++i)
	{
		for (j = 0; j < ncDataCw1; ++j)
		{
			m_byAllCodeWord[(ncBlockSum * j) + nBlockNo] = m_byDataCodeWord[nDataCwIndex++];
		}

		++nBlockNo;
	}

	for (i = 0; i < ncBlock2; ++i)
	{
		for (j = 0; j < ncDataCw2; ++j)
		{
			if (j < ncDataCw1)
			{
				m_byAllCodeWord[(ncBlockSum * j) + nBlockNo] = m_byDataCodeWord[nDataCwIndex++];
			}
			else
			{
				// ２種目ブロック端数分配置
				m_byAllCodeWord[(ncBlockSum * ncDataCw1) + i]  = m_byDataCodeWord[nDataCwIndex++];
			}	
		}

		++nBlockNo;
	}

	// ブロック別ＲＳコードワード数(※現状では同数)
	int ncRSCw1 = QR_VersonInfo[m_nVersion].RS_BlockInfo1[nLevel].ncAllCodeWord - ncDataCw1;
	int ncRSCw2 = QR_VersonInfo[m_nVersion].RS_BlockInfo2[nLevel].ncAllCodeWord - ncDataCw2;

	/////////////////////////////////////////////////////////////////////////
	// ＲＳコードワード算出

	nDataCwIndex = 0;
	nBlockNo = 0;

	for (i = 0; i < ncBlock1; ++i)
	{
		ZeroMemory(m_byRSWork, sizeof(m_byRSWork));

		memmove(m_byRSWork, m_byDataCodeWord + nDataCwIndex, ncDataCw1);

		GetRSCodeWord(m_byRSWork, ncDataCw1, ncRSCw1);

		// ＲＳコードワード配置
		for (j = 0; j < ncRSCw1; ++j)
		{
			m_byAllCodeWord[ncDataCodeWord + (ncBlockSum * j) + nBlockNo] = m_byRSWork[j];
		}

		nDataCwIndex += ncDataCw1;
		++nBlockNo;
	}

	for (i = 0; i < ncBlock2; ++i)
	{
		ZeroMemory(m_byRSWork, sizeof(m_byRSWork));

		memmove(m_byRSWork, m_byDataCodeWord + nDataCwIndex, ncDataCw2);

		GetRSCodeWord(m_byRSWork, ncDataCw2, ncRSCw2);

		// ＲＳコードワード配置
		for (j = 0; j < ncRSCw2; ++j)
		{
			m_byAllCodeWord[ncDataCodeWord + (ncBlockSum * j) + nBlockNo] = m_byRSWork[j];
		}

		nDataCwIndex += ncDataCw2;
		++nBlockNo;
	}

	m_nSymbleSize = m_nVersion * 4 + 17;

	// モジュール配置
	FormatModule();

	return true;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::GetEncodeVersion
// 用  途：エンコード時バージョン(型番)取得
// 引  数：調査開始バージョン、エンコードデータ、エンコードデータ長
// 戻り値：バージョン番号（容量オーバー時=0）

int CQR_Encode::GetEncodeVersion(int nVersion, LPCSTR lpsSource, int ncLength)
{
	int nVerGroup = nVersion >= 27 ? QR_VRESION_L : (nVersion >= 10 ? QR_VRESION_M : QR_VRESION_S);
	int i, j;

	for (i = nVerGroup; i <= QR_VRESION_L; ++i)
	{
		if (EncodeSourceData(lpsSource, ncLength, i))
		{
			if (i == QR_VRESION_S)
			{
				for (j = 1; j <= 9; ++j)
				{
					if ((m_ncDataCodeWordBit + 7) / 8 <= QR_VersonInfo[j].ncDataCodeWord[m_nLevel])
						return j;
				}
			}
			else if (i == QR_VRESION_M)
			{
				for (j = 10; j <= 26; ++j)
				{
					if ((m_ncDataCodeWordBit + 7) / 8 <= QR_VersonInfo[j].ncDataCodeWord[m_nLevel])
						return j;
				}
			}
			else if (i == QR_VRESION_L)
			{
				for (j = 27; j <= 40; ++j)
				{
					if ((m_ncDataCodeWordBit + 7) / 8 <= QR_VersonInfo[j].ncDataCodeWord[m_nLevel])
						return j;
				}
			}
		}
	}

	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::EncodeSourceData
// 用  途：入力データエンコード
// 引  数：入力データ、入力データ長、バージョン(型番)グループ
// 戻り値：エンコード成功時=true

bool CQR_Encode::EncodeSourceData(LPCSTR lpsSource, int ncLength, int nVerGroup)
{
	ZeroMemory(m_nBlockLength, sizeof(m_nBlockLength));

	int i, j;

	// どのモードが何文字(バイト)継続しているかを調査
	for (m_ncDataBlock = i = 0; i < ncLength; ++i)
	{
		BYTE byMode;

		if (i < ncLength - 1 && IsKanjiData(lpsSource[i], lpsSource[i + 1]))
			byMode = QR_MODE_KANJI;
		else if (IsNumeralData(lpsSource[i]))
			byMode = QR_MODE_NUMERAL;
		else if (IsAlphabetData(lpsSource[i]))
			byMode = QR_MODE_ALPHABET;
		else
			byMode = QR_MODE_8BIT;

		if (i == 0)
			m_byBlockMode[0] = byMode;

		if (m_byBlockMode[m_ncDataBlock] != byMode)
			m_byBlockMode[++m_ncDataBlock] = byMode;

		++m_nBlockLength[m_ncDataBlock];

		if (byMode == QR_MODE_KANJI)
		{
			// 漢字は文字数ではなく	数で記録
			++m_nBlockLength[m_ncDataBlock];
			++i;
		}
	}

	++m_ncDataBlock;

	/////////////////////////////////////////////////////////////////////////
	// 隣接する英数字モードブロックと数字モードブロックの並びをを条件により結合

	int ncSrcBits, ncDstBits; // 元のビット長と単一の英数字モードブロック化した場合のビット長

	int nBlock = 0;

	while (nBlock < m_ncDataBlock - 1)
	{
		int ncJoinFront, ncJoinBehind; // 前後８ビットバイトモードブロックと結合した場合のビット長
		int nJoinPosition = 0; // ８ビットバイトモードブロックとの結合：-1=前と結合、0=結合しない、1=後ろと結合

		// 「数字－英数字」または「英数字－数字」の並び
		if ((m_byBlockMode[nBlock] == QR_MODE_NUMERAL  && m_byBlockMode[nBlock + 1] == QR_MODE_ALPHABET) ||
			(m_byBlockMode[nBlock] == QR_MODE_ALPHABET && m_byBlockMode[nBlock + 1] == QR_MODE_NUMERAL))
		{
			// 元のビット長と単一の英数字モードブロック化した場合のビット長を比較
			ncSrcBits = GetBitLength(m_byBlockMode[nBlock], m_nBlockLength[nBlock], nVerGroup) +
						GetBitLength(m_byBlockMode[nBlock + 1], m_nBlockLength[nBlock + 1], nVerGroup);

			ncDstBits = GetBitLength(QR_MODE_ALPHABET, m_nBlockLength[nBlock] + m_nBlockLength[nBlock + 1], nVerGroup);

			if (ncSrcBits > ncDstBits)
			{
				// 前後に８ビットバイトモードブロックがある場合、それらとの結合が有利かどうかをチェック
				if (nBlock >= 1 && m_byBlockMode[nBlock - 1] == QR_MODE_8BIT)
				{
					// 前に８ビットバイトモードブロックあり
					ncJoinFront = GetBitLength(QR_MODE_8BIT, m_nBlockLength[nBlock - 1] + m_nBlockLength[nBlock], nVerGroup) +
								  GetBitLength(m_byBlockMode[nBlock + 1], m_nBlockLength[nBlock + 1], nVerGroup);

					if (ncJoinFront > ncDstBits + GetBitLength(QR_MODE_8BIT, m_nBlockLength[nBlock - 1], nVerGroup))
						ncJoinFront = 0; // ８ビットバイトモードブロックとは結合しない
				}
				else
					ncJoinFront = 0;

				if (nBlock < m_ncDataBlock - 2 && m_byBlockMode[nBlock + 2] == QR_MODE_8BIT)
				{
					// 後ろに８ビットバイトモードブロックあり
					ncJoinBehind = GetBitLength(m_byBlockMode[nBlock], m_nBlockLength[nBlock], nVerGroup) +
								   GetBitLength(QR_MODE_8BIT, m_nBlockLength[nBlock + 1] + m_nBlockLength[nBlock + 2], nVerGroup);

					if (ncJoinBehind > ncDstBits + GetBitLength(QR_MODE_8BIT, m_nBlockLength[nBlock + 2], nVerGroup))
						ncJoinBehind = 0; // ８ビットバイトモードブロックとは結合しない
				}
				else
					ncJoinBehind = 0;

				if (ncJoinFront != 0 && ncJoinBehind != 0)
				{
					// 前後両方に８ビットバイトモードブロックがある場合はデータ長が短くなる方を優先
					nJoinPosition = (ncJoinFront < ncJoinBehind) ? -1 : 1;
				}
				else
				{
					nJoinPosition = (ncJoinFront != 0) ? -1 : ((ncJoinBehind != 0) ? 1 : 0);
				}

				if (nJoinPosition != 0)
				{
					// ８ビットバイトモードブロックとの結合
					if (nJoinPosition == -1)
					{
						m_nBlockLength[nBlock - 1] += m_nBlockLength[nBlock];

						// 後続をシフト
						for (i = nBlock; i < m_ncDataBlock - 1; ++i)
						{
							m_byBlockMode[i]  = m_byBlockMode[i + 1];
							m_nBlockLength[i] = m_nBlockLength[i + 1];
						}
					}
					else
					{
						m_byBlockMode[nBlock + 1] = QR_MODE_8BIT;
						m_nBlockLength[nBlock + 1] += m_nBlockLength[nBlock + 2];

						// 後続をシフト
						for (i = nBlock + 2; i < m_ncDataBlock - 1; ++i)
						{
							m_byBlockMode[i]  = m_byBlockMode[i + 1];
							m_nBlockLength[i] = m_nBlockLength[i + 1];
						}
					}

					--m_ncDataBlock;
				}
				else
				{
					// 英数字と数字の並びを単一の英数字モードブロックに統合

					if (nBlock < m_ncDataBlock - 2 && m_byBlockMode[nBlock + 2] == QR_MODE_ALPHABET)
					{
						// 結合しようとするブロックの後ろに続く英数字モードブロックを結合
						m_nBlockLength[nBlock + 1] += m_nBlockLength[nBlock + 2];

						// 後続をシフト
						for (i = nBlock + 2; i < m_ncDataBlock - 1; ++i)
						{
							m_byBlockMode[i]  = m_byBlockMode[i + 1];
							m_nBlockLength[i] = m_nBlockLength[i + 1];
						}

						--m_ncDataBlock;
					}

					m_byBlockMode[nBlock] = QR_MODE_ALPHABET;
					m_nBlockLength[nBlock] += m_nBlockLength[nBlock + 1];

					// 後続をシフト
					for (i = nBlock + 1; i < m_ncDataBlock - 1; ++i)
					{
						m_byBlockMode[i]  = m_byBlockMode[i + 1];
						m_nBlockLength[i] = m_nBlockLength[i + 1];
					}

					--m_ncDataBlock;

					if (nBlock >= 1 && m_byBlockMode[nBlock - 1] == QR_MODE_ALPHABET)
					{
						// 結合したブロックの前の英数字モードブロックを結合
						m_nBlockLength[nBlock - 1] += m_nBlockLength[nBlock];

						// 後続をシフト
						for (i = nBlock; i < m_ncDataBlock - 1; ++i)
						{
							m_byBlockMode[i]  = m_byBlockMode[i + 1];
							m_nBlockLength[i] = m_nBlockLength[i + 1];
						}

						--m_ncDataBlock;
					}
				}

				continue; // 現在位置のブロックを再調査
			}
		}

		++nBlock; // 次ブロックを調査
	}

	/////////////////////////////////////////////////////////////////////////
	// 連続する短いモードブロックを８ビットバイトモードブロック化

	nBlock = 0;

	while (nBlock < m_ncDataBlock - 1)
	{
		ncSrcBits = GetBitLength(m_byBlockMode[nBlock], m_nBlockLength[nBlock], nVerGroup)
					+ GetBitLength(m_byBlockMode[nBlock + 1], m_nBlockLength[nBlock + 1], nVerGroup);

		ncDstBits = GetBitLength(QR_MODE_8BIT, m_nBlockLength[nBlock] + m_nBlockLength[nBlock + 1], nVerGroup);

		// 前に８ビットバイトモードブロックがある場合、重複するインジケータ分を減算
		if (nBlock >= 1 && m_byBlockMode[nBlock - 1] == QR_MODE_8BIT)
			ncDstBits -= (4 + nIndicatorLen8Bit[nVerGroup]);

		// 後ろに８ビットバイトモードブロックがある場合、重複するインジケータ分を減算
		if (nBlock < m_ncDataBlock - 2 && m_byBlockMode[nBlock + 2] == QR_MODE_8BIT)
			ncDstBits -= (4 + nIndicatorLen8Bit[nVerGroup]);

		if (ncSrcBits > ncDstBits)
		{
			if (nBlock >= 1 && m_byBlockMode[nBlock - 1] == QR_MODE_8BIT)
			{
				// 結合するブロックの前にある８ビットバイトモードブロックを結合
				m_nBlockLength[nBlock - 1] += m_nBlockLength[nBlock];

				// 後続をシフト
				for (i = nBlock; i < m_ncDataBlock - 1; ++i)
				{
					m_byBlockMode[i]  = m_byBlockMode[i + 1];
					m_nBlockLength[i] = m_nBlockLength[i + 1];
				}

				--m_ncDataBlock;
				--nBlock;
			}

			if (nBlock < m_ncDataBlock - 2 && m_byBlockMode[nBlock + 2] == QR_MODE_8BIT)
			{
				// 結合するブロックの後ろにある８ビットバイトモードブロックを結合
				m_nBlockLength[nBlock + 1] += m_nBlockLength[nBlock + 2];

				// 後続をシフト
				for (i = nBlock + 2; i < m_ncDataBlock - 1; ++i)
				{
					m_byBlockMode[i]  = m_byBlockMode[i + 1];
					m_nBlockLength[i] = m_nBlockLength[i + 1];
				}

				--m_ncDataBlock;
			}

			m_byBlockMode[nBlock] = QR_MODE_8BIT;
			m_nBlockLength[nBlock] += m_nBlockLength[nBlock + 1];

			// 後続をシフト
			for (i = nBlock + 1; i < m_ncDataBlock - 1; ++i)
			{
				m_byBlockMode[i]  = m_byBlockMode[i + 1];
				m_nBlockLength[i] = m_nBlockLength[i + 1];
			}

			--m_ncDataBlock;

			// 結合したブロックの前から再調査
			if (nBlock >= 1)
				--nBlock;

			continue;
		}

		++nBlock; // 次ブロックを調査
	}

	/////////////////////////////////////////////////////////////////////////
	// ビット配列化
	int ncComplete = 0; // 処理済データカウンタ
	WORD wBinCode;

	m_ncDataCodeWordBit = 0; // ビット単位処理カウンタ

	ZeroMemory(m_byDataCodeWord, MAX_DATACODEWORD);

	for (i = 0; i < m_ncDataBlock && m_ncDataCodeWordBit != -1; ++i)
	{
		if (m_byBlockMode[i] == QR_MODE_NUMERAL)
		{
			/////////////////////////////////////////////////////////////////
			// 数字モード

			// インジケータ(0001b)
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 1, 4); 

			// 文字数セット
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)m_nBlockLength[i], nIndicatorLenNumeral[nVerGroup]);

			// ビット列保存
			for (j = 0; j < m_nBlockLength[i]; j += 3)
			{
				if (j < m_nBlockLength[i] - 2)
				{
					wBinCode = (WORD)(((lpsSource[ncComplete + j]	  - '0') * 100) +
									  ((lpsSource[ncComplete + j + 1] - '0') * 10) +
									   (lpsSource[ncComplete + j + 2] - '0'));

					m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, wBinCode, 10);
				}
				else if (j == m_nBlockLength[i] - 2)
				{
					// 端数２バイト
					wBinCode = (WORD)(((lpsSource[ncComplete + j] - '0') * 10) +
									   (lpsSource[ncComplete + j + 1] - '0'));

					m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, wBinCode, 7);
				}
				else if (j == m_nBlockLength[i] - 1)
				{
					// 端数１バイト
					wBinCode = (WORD)(lpsSource[ncComplete + j] - '0');

					m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, wBinCode, 4);
				}
			}

			ncComplete += m_nBlockLength[i];
		}

		else if (m_byBlockMode[i] == QR_MODE_ALPHABET)
		{
			/////////////////////////////////////////////////////////////////
			// 英数字モード

			// モードインジケータ(0010b)
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 2, 4);

			// 文字数セット
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)m_nBlockLength[i], nIndicatorLenAlphabet[nVerGroup]);

			// ビット列保存
			for (j = 0; j < m_nBlockLength[i]; j += 2)
			{
				if (j < m_nBlockLength[i] - 1)
				{
					wBinCode = (WORD)((AlphabetToBinaly(lpsSource[ncComplete + j]) * 45) +
									   AlphabetToBinaly(lpsSource[ncComplete + j + 1]));

					m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, wBinCode, 11);
				}
				else
				{
					// 端数１バイト
					wBinCode = (WORD)AlphabetToBinaly(lpsSource[ncComplete + j]);

					m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, wBinCode, 6);
				}
			}

			ncComplete += m_nBlockLength[i];
		}

		else if (m_byBlockMode[i] == QR_MODE_8BIT)
		{
			/////////////////////////////////////////////////////////////////
			// ８ビットバイトモード

			// モードインジケータ(0100b)
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 4, 4);

			// 文字数セット
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)m_nBlockLength[i], nIndicatorLen8Bit[nVerGroup]);

			// ビット列保存
			for (j = 0; j < m_nBlockLength[i]; ++j)
			{
				m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)lpsSource[ncComplete + j], 8);
			}

			ncComplete += m_nBlockLength[i];
		}
		else // m_byBlockMode[i] == QR_MODE_KANJI
		{
			/////////////////////////////////////////////////////////////////
			// 漢字モード

			// モードインジケータ(1000b)
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 8, 4);

			// 文字数セット
			m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)(m_nBlockLength[i] / 2), nIndicatorLenKanji[nVerGroup]);

			// 漢字モードでビット列保存
			for (j = 0; j < m_nBlockLength[i] / 2; ++j)
			{
				WORD wBinCode = KanjiToBinaly((WORD)(((BYTE)lpsSource[ncComplete + (j * 2)] << 8) + (BYTE)lpsSource[ncComplete + (j * 2) + 1]));

				m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, wBinCode, 13);
			}

			ncComplete += m_nBlockLength[i];
		}
	}

	return (m_ncDataCodeWordBit != -1);
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::GetBitLength
// 用  途：ビット長取得
// 引  数：データモード種別、データ長、バージョン(型番)グループ
// 戻り値：データビット長
// 備  考：漢字モードでのデータ長引数は文字数ではなくバイト数

int CQR_Encode::GetBitLength(BYTE nMode, int ncData, int nVerGroup)
{
	int ncBits = 0;

	switch (nMode)
	{
	case QR_MODE_NUMERAL:
		ncBits = 4 + nIndicatorLenNumeral[nVerGroup] + (10 * (ncData / 3));
		switch (ncData % 3)
		{
		case 1:
			ncBits += 4;
			break;
		case 2:
			ncBits += 7;
			break;
		default: // case 0:
			break;
		}

		break;

	case QR_MODE_ALPHABET:
		ncBits = 4 + nIndicatorLenAlphabet[nVerGroup] + (11 * (ncData / 2)) + (6 * (ncData % 2));
		break;

	case QR_MODE_8BIT:
		ncBits = 4 + nIndicatorLen8Bit[nVerGroup] + (8 * ncData);
		break;

	default: // case QR_MODE_KANJI:
		ncBits = 4 + nIndicatorLenKanji[nVerGroup] + (13 * (ncData / 2));
		break;
	}

	return ncBits;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetBitStream
// 用  途：ビットセット
// 引  数：挿入位置、ビット配列データ、データビット長(最大16)
// 戻り値：次回挿入位置(バッファオーバー時=-1)
// 備  考：m_byDataCodeWord に結果をセット(要ゼロ初期化)

int CQR_Encode::SetBitStream(int nIndex, WORD wData, int ncData)
{
	int i;

	if (nIndex == -1 || nIndex + ncData > MAX_DATACODEWORD * 8)
		return -1;

	for (i = 0; i < ncData; ++i)
	{
		if (wData & (1 << (ncData - i - 1)))
		{
			m_byDataCodeWord[(nIndex + i) / 8] |= 1 << (7 - ((nIndex + i) % 8));
		}
	}

	return nIndex + ncData;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::IsNumeralData
// 用  途：数字モード該当チェック
// 引  数：調査文字
// 戻り値：該当時=true

bool CQR_Encode::IsNumeralData(unsigned char c)
{
	if (c >= '0' && c <= '9')
		return true;

	return false;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::IsAlphabetData
// 用  途：英数字モード該当チェック
// 引  数：調査文字
// 戻り値：該当時=true

bool CQR_Encode::IsAlphabetData(unsigned char c)
{
	if (c >= '0' && c <= '9')
		return true;

	if (c >= 'A' && c <= 'Z')
		return true;

	if (c == ' ' || c == '$' || c == '%' || c == '*' || c == '+' || c == '-' || c == '.' || c == '/' || c == ':')
		return true;

	return false;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::IsKanjiData
// 用  途：漢字モード該当チェック
// 引  数：調査文字（16ビット文字）
// 戻り値：該当時=true
// 備  考：EBBFh 以降の S-JIS は対象外

bool CQR_Encode::IsKanjiData(unsigned char c1, unsigned char c2)
{
	if (((c1 >= 0x81 && c1 <= 0x9f) || (c1 >= 0xe0 && c1 <= 0xeb)) && (c2 >= 0x40))
	{
		if ((c1 == 0x9f && c2 > 0xfc) || (c1 == 0xeb && c2 > 0xbf))
			return false;

		return true;
	}

	return false;
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::AlphabetToBinaly
// 用  途：英数字モード文字のバイナリ化
// 引  数：対象文字
// 戻り値：バイナリ値

BYTE CQR_Encode::AlphabetToBinaly(unsigned char c)
{
	if (c >= '0' && c <= '9') return (unsigned char)(c - '0');

	if (c >= 'A' && c <= 'Z') return (unsigned char)(c - 'A' + 10);

	if (c == ' ') return 36;

	if (c == '$') return 37;

	if (c == '%') return 38;

	if (c == '*') return 39;

	if (c == '+') return 40;

	if (c == '-') return 41;

	if (c == '.') return 42;

	if (c == '/') return 43;

	return 44; // c == ':'
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::KanjiToBinaly
// 用  途：漢字モード文字のバイナリ化
// 引  数：対象文字
// 戻り値：バイナリ値

WORD CQR_Encode::KanjiToBinaly(WORD wc)
{
	if (wc >= 0x8140 && wc <= 0x9ffc)
		wc -= 0x8140;
	else // (wc >= 0xe040 && wc <= 0xebbf)
		wc -= 0xc140;

	return (WORD)(((wc >> 8) * 0xc0) + (wc & 0x00ff));
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::GetRSCodeWord
// 用  途：ＲＳ誤り訂正コードワード取得
// 引  数：データコードワードアドレス、データコードワード長、ＲＳコードワード長
// 備  考：総コードワード分のエリアを確保してから呼び出し

void CQR_Encode::GetRSCodeWord(LPBYTE lpbyRSWork, int ncDataCodeWord, int ncRSCodeWord)
{
	int i, j;

	for (i = 0; i < ncDataCodeWord ; ++i)
	{
		if (lpbyRSWork[0] != 0)
		{
			BYTE nExpFirst = byIntToExp[lpbyRSWork[0]]; // 初項係数より乗数算出

			for (j = 0; j < ncRSCodeWord; ++j)
			{
				// 各項乗数に初項乗数を加算（% 255 → α^255 = 1）
				BYTE nExpElement = (BYTE)(((int)(byRSExp[ncRSCodeWord][j] + nExpFirst)) % 255);

				// 排他論理和による剰余算出
				lpbyRSWork[j] = (BYTE)(lpbyRSWork[j + 1] ^ byExpToInt[nExpElement]);
			}

			// 残り桁をシフト
			for (j = ncRSCodeWord; j < ncDataCodeWord + ncRSCodeWord - 1; ++j)
				lpbyRSWork[j] = lpbyRSWork[j + 1];
		}
		else
		{
			// 残り桁をシフト
			for (j = 0; j < ncDataCodeWord + ncRSCodeWord - 1; ++j)
				lpbyRSWork[j] = lpbyRSWork[j + 1];
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::FormatModule
// 用  途：モジュールへのデータ配置
// 戻り値：一辺のモジュール数

void CQR_Encode::FormatModule()
{
	int i, j;

	ZeroMemory(m_byModuleData, sizeof(m_byModuleData));

	// 機能モジュール配置
	SetFunctionModule();

	// データパターン配置
	SetCodeWordPattern();

	if (m_nMaskingNo == -1)
	{
		// 最適マスキングパターン選択
		m_nMaskingNo = 0;

		SetMaskingPattern(m_nMaskingNo); // マスキング
		SetFormatInfoPattern(m_nMaskingNo); // フォーマット情報パターン配置

		int nMinPenalty = CountPenalty();

		for (i = 1; i <= 7; ++i)
		{
			SetMaskingPattern(i); // マスキング
			SetFormatInfoPattern(i); // フォーマット情報パターン配置

			int nPenalty = CountPenalty();

			if (nPenalty < nMinPenalty)
			{
				nMinPenalty = nPenalty;
				m_nMaskingNo = i;
			}
		}
	}

	SetMaskingPattern(m_nMaskingNo); // マスキング
	SetFormatInfoPattern(m_nMaskingNo); // フォーマット情報パターン配置

	// モジュールパターンをブール値に変換
	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize; ++j)
		{
			m_byModuleData[i][j] = (BYTE)((m_byModuleData[i][j] & 0x11) != 0);
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetFunctionModule
// 用  途：機能モジュール配置
// 備  考：フォーマット情報は機能モジュール登録のみ(実データは空白)

void CQR_Encode::SetFunctionModule()
{
	int i, j;

	// 位置検出パターン
	SetFinderPattern(0, 0);
	SetFinderPattern(m_nSymbleSize - 7, 0);
	SetFinderPattern(0, m_nSymbleSize - 7);

	// 位置検出パターンセパレータ
	for (i = 0; i < 8; ++i)
	{
		m_byModuleData[i][7] = m_byModuleData[7][i] = '\x20';
		m_byModuleData[m_nSymbleSize - 8][i] = m_byModuleData[m_nSymbleSize - 8 + i][7] = '\x20';
		m_byModuleData[i][m_nSymbleSize - 8] = m_byModuleData[7][m_nSymbleSize - 8 + i] = '\x20';
	}

	// フォーマット情報記述位置を機能モジュール部として登録
	for (i = 0; i < 9; ++i)
	{
		m_byModuleData[i][8] = m_byModuleData[8][i] = '\x20';
	}

	for (i = 0; i < 8; ++i)
	{
		m_byModuleData[m_nSymbleSize - 8 + i][8] = m_byModuleData[8][m_nSymbleSize - 8 + i] = '\x20';
	}

	// バージョン情報パターン
	SetVersionPattern();

	// 位置合わせパターン
	for (i = 0; i < QR_VersonInfo[m_nVersion].ncAlignPoint; ++i)
	{
		SetAlignmentPattern(QR_VersonInfo[m_nVersion].nAlignPoint[i], 6);
		SetAlignmentPattern(6, QR_VersonInfo[m_nVersion].nAlignPoint[i]);

		for (j = 0; j < QR_VersonInfo[m_nVersion].ncAlignPoint; ++j)
		{
			SetAlignmentPattern(QR_VersonInfo[m_nVersion].nAlignPoint[i], QR_VersonInfo[m_nVersion].nAlignPoint[j]);
		}
	}

	// タイミングパターン
	for (i = 8; i <= m_nSymbleSize - 9; ++i)
	{
		m_byModuleData[i][6] = (i % 2) == 0 ? '\x30' : '\x20';
		m_byModuleData[6][i] = (i % 2) == 0 ? '\x30' : '\x20';
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetFinderPattern
// 用  途：位置検出パターン配置
// 引  数：配置左上座標

void CQR_Encode::SetFinderPattern(int x, int y)
{
	static BYTE byPattern[] = {0x7f,  // 1111111b
							   0x41,  // 1000001b
							   0x5d,  // 1011101b
							   0x5d,  // 1011101b
							   0x5d,  // 1011101b
							   0x41,  // 1000001b
							   0x7f}; // 1111111b
	int i, j;

	for (i = 0; i < 7; ++i)
	{
		for (j = 0; j < 7; ++j)
		{
			m_byModuleData[x + j][y + i] = (byPattern[i] & (1 << (6 - j))) ? '\x30' : '\x20'; 
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetAlignmentPattern
// 用  途：位置合わせパターン配置
// 引  数：配置中央座標

void CQR_Encode::SetAlignmentPattern(int x, int y)
{
	static BYTE byPattern[] = {0x1f,  // 11111b
							   0x11,  // 10001b
							   0x15,  // 10101b
							   0x11,  // 10001b
							   0x1f}; // 11111b
	int i, j;

	if (m_byModuleData[x][y] & 0x20)
		return; // 機能モジュールと重複するため除外

	x -= 2; y -= 2; // 左上隅座標に変換

	for (i = 0; i < 5; ++i)
	{
		for (j = 0; j < 5; ++j)
		{
			m_byModuleData[x + j][y + i] = (byPattern[i] & (1 << (4 - j))) ? '\x30' : '\x20'; 
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetVersionPattern
// 用  途：バージョン(型番)情報パターン配置
// 備  考：拡張ＢＣＨ(18,6)符号を誤り訂正として使用

void CQR_Encode::SetVersionPattern()
{
	int i, j;

	if (m_nVersion <= 6)
		return;

	int nVerData = m_nVersion << 12;

	// 剰余ビット算出
	for (i = 0; i < 6; ++i)
	{
		if (nVerData & (1 << (17 - i)))
		{
			nVerData ^= (0x1f25 << (5 - i));
		}
	}

	nVerData += m_nVersion << 12;

	for (i = 0; i < 6; ++i)
	{
		for (j = 0; j < 3; ++j)
		{
			m_byModuleData[m_nSymbleSize - 11 + j][i] = m_byModuleData[i][m_nSymbleSize - 11 + j] =
			(nVerData & (1 << (i * 3 + j))) ? '\x30' : '\x20';
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetCodeWordPattern
// 用  途：データパターン配置

void CQR_Encode::SetCodeWordPattern()
{
	int x = m_nSymbleSize;
	int y = m_nSymbleSize - 1;

	int nCoef_x = 1; // ｘ軸配置向き
	int nCoef_y = 1; // ｙ軸配置向き

	int i, j;

	for (i = 0; i < m_ncAllCodeWord; ++i)
	{
		for (j = 0; j < 8; ++j)
		{
			do
			{
				x += nCoef_x;
				nCoef_x *= -1;

				if (nCoef_x < 0)
				{
					y += nCoef_y;

					if (y < 0 || y == m_nSymbleSize)
					{
						y = (y < 0) ? 0 : m_nSymbleSize - 1;
						nCoef_y *= -1;

						x -= 2;

						if (x == 6) // タイミングパターン
							--x;
					}
				}
			}
			while (m_byModuleData[x][y] & 0x20); // 機能モジュールを除外

			m_byModuleData[x][y] = (m_byAllCodeWord[i] & (1 << (7 - j))) ? '\x02' : '\x00';
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetMaskingPattern
// 用  途：マスキングパターン配置
// 引  数：マスキングパターン番号

void CQR_Encode::SetMaskingPattern(int nPatternNo)
{
	int i, j;

	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize; ++j)
		{
			if (! (m_byModuleData[j][i] & 0x20)) // 機能モジュールを除外
			{
				bool bMask;

				switch (nPatternNo)
				{
				case 0:
					bMask = ((i + j) % 2 == 0);
					break;

				case 1:
					bMask = (i % 2 == 0);
					break;

				case 2:
					bMask = (j % 3 == 0);
					break;

				case 3:
					bMask = ((i + j) % 3 == 0);
					break;

				case 4:
					bMask = (((i / 2) + (j / 3)) % 2 == 0);
					break;

				case 5:
					bMask = (((i * j) % 2) + ((i * j) % 3) == 0);
					break;

				case 6:
					bMask = ((((i * j) % 2) + ((i * j) % 3)) % 2 == 0);
					break;

				default: // case 7:
					bMask = ((((i * j) % 3) + ((i + j) % 2)) % 2 == 0);
					break;
				}

				m_byModuleData[j][i] = (BYTE)((m_byModuleData[j][i] & 0xfe) | (((m_byModuleData[j][i] & 0x02) > 1) ^ bMask));
			}
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::SetFormatInfoPattern
// 用  途：フォーマット情報配置
// 引  数：マスキングパターン番号

void CQR_Encode::SetFormatInfoPattern(int nPatternNo)
{
	int nFormatInfo;
	int i;

	switch (m_nLevel)
	{
	case QR_LEVEL_M:
		nFormatInfo = 0x00; // 00nnnb
		break;

	case QR_LEVEL_L:
		nFormatInfo = 0x08; // 01nnnb
		break;

	case QR_LEVEL_Q:
		nFormatInfo = 0x18; // 11nnnb
		break;

	default: // case QR_LEVEL_H:
		nFormatInfo = 0x10; // 10nnnb
		break;
	}

	nFormatInfo += nPatternNo;

	int nFormatData = nFormatInfo << 10;

	// 剰余ビット算出
	for (i = 0; i < 5; ++i)
	{
		if (nFormatData & (1 << (14 - i)))
		{
			nFormatData ^= (0x0537 << (4 - i)); // 10100110111b
		}
	}

	nFormatData += nFormatInfo << 10;

	// マスキング
	nFormatData ^= 0x5412; // 101010000010010b

	// 左上位置検出パターン周り配置
	for (i = 0; i <= 5; ++i)
		m_byModuleData[8][i] = (nFormatData & (1 << i)) ? '\x30' : '\x20';

	m_byModuleData[8][7] = (nFormatData & (1 << 6)) ? '\x30' : '\x20';
	m_byModuleData[8][8] = (nFormatData & (1 << 7)) ? '\x30' : '\x20';
	m_byModuleData[7][8] = (nFormatData & (1 << 8)) ? '\x30' : '\x20';

	for (i = 9; i <= 14; ++i)
		m_byModuleData[14 - i][8] = (nFormatData & (1 << i)) ? '\x30' : '\x20';

	// 右上位置検出パターン下配置
	for (i = 0; i <= 7; ++i)
		m_byModuleData[m_nSymbleSize - 1 - i][8] = (nFormatData & (1 << i)) ? '\x30' : '\x20';

	// 左下位置検出パターン右配置
	m_byModuleData[8][m_nSymbleSize - 8] = '\x30'; // 固定暗モジュール

	for (i = 8; i <= 14; ++i)
		m_byModuleData[8][m_nSymbleSize - 15 + i] = (nFormatData & (1 << i)) ? '\x30' : '\x20';
}


/////////////////////////////////////////////////////////////////////////////
// CQR_Encode::CountPenalty
// 用  途：マスク後ペナルティスコア算出

int CQR_Encode::CountPenalty()
{
	int nPenalty = 0;
	int i, j, k;

	// 同色の列の隣接モジュール
	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize - 4; ++j)
		{
			int nCount = 1;

			for (k = j + 1; k < m_nSymbleSize; k++)
			{
				if (((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i][k] & 0x11) == 0))
					++nCount;
				else
					break;
			}

			if (nCount >= 5)
			{
				nPenalty += 3 + (nCount - 5);
			}

			j = k - 1;
		}
	}

	// 同色の行の隣接モジュール
	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize - 4; ++j)
		{
			int nCount = 1;

			for (k = j + 1; k < m_nSymbleSize; k++)
			{
				if (((m_byModuleData[j][i] & 0x11) == 0) == ((m_byModuleData[k][i] & 0x11) == 0))
					++nCount;
				else
					break;
			}

			if (nCount >= 5)
			{
				nPenalty += 3 + (nCount - 5);
			}

			j = k - 1;
		}
	}

	// 同色のモジュールブロック（２×２）
	for (i = 0; i < m_nSymbleSize - 1; ++i)
	{
		for (j = 0; j < m_nSymbleSize - 1; ++j)
		{
			if ((((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i + 1][j]		& 0x11) == 0)) &&
				(((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i]	[j + 1] & 0x11) == 0)) &&
				(((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i + 1][j + 1] & 0x11) == 0)))
			{
				nPenalty += 3;
			}
		}
	}

	// 同一列における 1:1:3:1:1 比率（暗:明:暗:明:暗）のパターン
	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize - 6; ++j)
		{
			if (((j == 0) ||				 (! (m_byModuleData[i][j - 1] & 0x11))) && // 明 または シンボル外
											 (   m_byModuleData[i][j]     & 0x11)   && // 暗 - 1
											 (! (m_byModuleData[i][j + 1] & 0x11))  && // 明 - 1
											 (   m_byModuleData[i][j + 2] & 0x11)   && // 暗 ┐
											 (   m_byModuleData[i][j + 3] & 0x11)   && // 暗 │3
											 (   m_byModuleData[i][j + 4] & 0x11)   && // 暗 ┘
											 (! (m_byModuleData[i][j + 5] & 0x11))  && // 明 - 1
											 (   m_byModuleData[i][j + 6] & 0x11)   && // 暗 - 1
				((j == m_nSymbleSize - 7) || (! (m_byModuleData[i][j + 7] & 0x11))))   // 明 または シンボル外
			{
				// 前または後に4以上の明パターン
				if (((j < 2 || ! (m_byModuleData[i][j - 2] & 0x11)) && 
					 (j < 3 || ! (m_byModuleData[i][j - 3] & 0x11)) &&
					 (j < 4 || ! (m_byModuleData[i][j - 4] & 0x11))) ||
					((j >= m_nSymbleSize - 8  || ! (m_byModuleData[i][j + 8]  & 0x11)) &&
					 (j >= m_nSymbleSize - 9  || ! (m_byModuleData[i][j + 9]  & 0x11)) &&
					 (j >= m_nSymbleSize - 10 || ! (m_byModuleData[i][j + 10] & 0x11))))
				{
					nPenalty += 40;
				}
			}
		}
	}

	// 同一行における 1:1:3:1:1 比率（暗:明:暗:明:暗）のパターン
	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize - 6; ++j)
		{
			if (((j == 0) ||				 (! (m_byModuleData[j - 1][i] & 0x11))) && // 明 または シンボル外
											 (   m_byModuleData[j]    [i] & 0x11)   && // 暗 - 1
											 (! (m_byModuleData[j + 1][i] & 0x11))  && // 明 - 1
											 (   m_byModuleData[j + 2][i] & 0x11)   && // 暗 ┐
											 (   m_byModuleData[j + 3][i] & 0x11)   && // 暗 │3
											 (   m_byModuleData[j + 4][i] & 0x11)   && // 暗 ┘
											 (! (m_byModuleData[j + 5][i] & 0x11))  && // 明 - 1
											 (   m_byModuleData[j + 6][i] & 0x11)   && // 暗 - 1
				((j == m_nSymbleSize - 7) || (! (m_byModuleData[j + 7][i] & 0x11))))   // 明 または シンボル外
			{
				// 前または後に4以上の明パターン
				if (((j < 2 || ! (m_byModuleData[j - 2][i] & 0x11)) && 
					 (j < 3 || ! (m_byModuleData[j - 3][i] & 0x11)) &&
					 (j < 4 || ! (m_byModuleData[j - 4][i] & 0x11))) ||
					((j >= m_nSymbleSize - 8  || ! (m_byModuleData[j + 8][i]  & 0x11)) &&
					 (j >= m_nSymbleSize - 9  || ! (m_byModuleData[j + 9][i]  & 0x11)) &&
					 (j >= m_nSymbleSize - 10 || ! (m_byModuleData[j + 10][i] & 0x11))))
				{
					nPenalty += 40;
				}
			}
		}
	}

	// 全体に対する暗モジュールの占める割合
	int nCount = 0;

	for (i = 0; i < m_nSymbleSize; ++i)
	{
		for (j = 0; j < m_nSymbleSize; ++j)
		{
			if (! (m_byModuleData[i][j] & 0x11))
			{
				++nCount;
			}
		}
	}

	nPenalty += (abs(50 - ((nCount * 100) / (m_nSymbleSize * m_nSymbleSize))) / 5) * 10;

	return nPenalty;
}
