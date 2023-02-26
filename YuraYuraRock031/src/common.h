#include <windows.h>
#include <tchar.h>
#include <assert.h>
#include <stdio.h>
#include <math.h>
#include <locale.h>

#ifdef _ORE_SENYOU
//私はいくつかのソースをライブラリ化しているので……
#ifdef     _DEBUG

#ifdef         _UNICODE
#pragma comment(lib,"glw_d.lib")
#else          /*_UNICODE*/
#pragma comment(lib,"gl_d.lib")
#endif         /*_UNICODE*/

#else      /*_DEBUG*/

#ifdef         _UNICODE
#pragma comment(lib,"glw.lib")
#else          /*_UNICODE*/
#pragma comment(lib,"gl.lib")
#endif         /*_UNICODE*/

#endif     /*_DEBUG*/

#endif /*_ORE_SENYOU*/

#include "nnsys.h"
#include "mydibobj3.h"
#include "task0810.h"
#include "TaskGUI1206/TaskGUI1206.h"
#include "myeinput.h"
#include "keycode.h"
#include "mymemorymanage.h"
#include "TaskClasses.h"
#include "global.h"
#include "RockStage.h"

//アプリケーションのウインドウへのドロップを許可するときはコメントアウトを外す
#define	MY_DROP_ACCEPT
#define	WINDOW_RESIZABLE //ウインドウサイズを変更可能にする
#define	WINDOW_MINIMIZABLE //ウインドウを最小化可能かどうか
//２重起動を（簡易）抑制するときはコメントアウト
#define	ENABLE_MULTIPLE_RUN
