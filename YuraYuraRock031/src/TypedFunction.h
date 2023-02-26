#ifndef TSTRING_HEADER_INCLUDED
#define TSTRING_HEADER_INCLUDED

#include <iostream>
#include <sstream>
#include <string>

#ifdef _UNICODE

#define tstring std::wstring
#define tofstream std::wofstream
#define tistringstream std::wistringstream
#define tostringstream std::wostringstream

#define mbstotcs_s	mbstowcs_s

#else

#define tstring std::string
#define tofstream std::ofstream
#define tistringstream std::istringstream
#define tostringstream std::ostringstream

#define mbstotcs_s(piLen,atcDest,iDestSize,acSrc,iSrcSize)	(memcpy_s(atcDest,iDestSize,acSrc,iSrcSize),(*piLen)=strlen(acSrc)+1,0)

#endif

#endif  /*TSTRING_HEADER_INCLUDED*/