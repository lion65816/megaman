#ifndef MYTIMER_HEADER_INCLUDED
#define MYTIMER_HEADER_INCLUDED

/*
	��ɃQ�[���p�̂��߂ɍ�����^�C�}�[���[�`���B



//���b�Z�[�W���[�v�̕ς��ɁA���̃��[�v���g��
//Func()�́A���Ԋu�ŌĂяo�������֐�

MyTimerObj mto(60);
	for(;;)
	{
		Func();
		if(mto.Wait(&msg))break;
	}
*/

/*
�@�����������Ƃ��ɂ́A�����o�ϐ��͍ŏ���M�����悤�I�Ƃ��l���Ă��݂����O�O
�@�t�Ɍ��Â炭�ˁH

�@����͒u���Ă����āA���̃^�C�}�[�́A
�@�g����Ȃ�AQueryPerformanceCounter���A�g���Ȃ��Ȃ�timeGetTime���g���܂��B
�@���x���i�Ⴂ�Ȃ�ł����c�c�ł��A�O�҂��g���Ȃ����Ƃ��Ă���̂��Ȃ��B
*/

class MyTimerObj
{
private:
	TIMECAPS MAtc;
	bool MisTGT;
	union
	{
		struct
		{
			DWORD Mstarttime;
			DWORD Mendtime;
			DWORD Msecondstarttime;
			DWORD Mfixwaittime;
			DWORD Mfixhztime;
			DWORD Mgiveuptime;
			DWORD Mframeskipreqtime;
			DWORD Mprocessstart;
		}SforTGT;
		struct
		{
			LARGE_INTEGER Mstarttime;
			LARGE_INTEGER Mendtime;
			LARGE_INTEGER Msecondstarttime;
			LARGE_INTEGER Mfreq;
			INT32 Mcountperframe;
			INT32 Mgiveuptime;
			INT32 Mframeskipreqtime;
			LARGE_INTEGER Mprocessstart;
		}SforPC;
	}MUtimervalue;
	int MFPScounter;
	int MFPS;
	int MNOsleep;
	int Mpressure;
	bool Mframeskiprequired ;
public:
	MyTimerObj(int ifps=60);
	~MyTimerObj();
	void SetFPS(int ifps=60);
	bool Wait(MSG *iptrmsg);

	//�����e�o�r��Ԃ�
	int GetFPS(){return MFPS;}

	//�E�F�C�g�̊ԂɁA����ASleep(1)��������Ԃ��B�����قǗ]�T���Ă��ƁB
	int GetNofSleep(){return MNOsleep;}

	//�f�o�b�O���̂݁BFunc()�������������ׂ�Ԃ��H����A�v���b�V���[����Ȃ�����c�c���Ęb������
	int GetPressure(){return Mpressure;}

	//���̂��A�Ȃ񂩎��Ԃɕϊ��������̂�Ԃ��H
	int GetProcessTime(){if(MisTGT)return Mpressure*1000*10;return (int)(Mpressure * 1000 * 10 / MUtimervalue.SforPC.Mfreq.QuadPart);}

	//�H���Ɏg���̂��A�E�F�C�g�̍Ō�̎��Ԃ�Ԃ��H
	DWORD GetEndTime(){if(MisTGT)return MUtimervalue.SforTGT.Mendtime;return MUtimervalue.SforPC.Mendtime.LowPart;}

	//����Ȃ�̐��x�ŏ������Ԃ𑪒肷��̂Ɏg���B
	//�P��O�ɁA���̊֐����Ăяo���Ă���̎��Ԍo�߂�b�P�ʂŕԂ��B
	double ProcessTimeCount();
	
	//�t���[���X�L�b�v���]�܂�Ă��邩��Ԃ�
	bool FrameSkipIsRequired(){return Mframeskiprequired ; }
};


#endif /*MYTIMER_HEADER_INCLUDED*/