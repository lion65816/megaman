●ファイル説明
　・rockman2.asm
　　メインのアセンブリファイル
　・mylib.asm
　　よく使うマクロなど
　・srcフォルダの中
　　実質のメイン
　・LOGO.ips
　　タイトル画面のロゴは面倒だったので、
　　最後にこれを当てればロゴがつくようにしてあります。
　・do.bat
　　アセンブルのバッチ

●アセンブルに必要なもの
　・NESASM.EXE
　　調べれば見つかります。
　・rockman2.prg
　　ロックマン２のイメージの先頭の10hバイトを切り取り、
　　262,144バイトにしたもの。

●アセンブル方法
　必要なもの（２つ）を、rockman2.asmのフォルダに居れ、
　コマンドプロンプト上で、
　そのフォルダをカレントディレクトリにして、
nesasm.exe rockman2.asm
　でいけます。たぶん。
　何言ってんだかよくわからんという方は、
　適当にフォルダにファイルをぶち込んだ後
do.bat
　を叩いてください。

●流用など
　ご自由にどうぞです……が、
　まぁ、同梱ドキュメントにその旨を書いていただいたり、
　あるいは、私に連絡をくださると
　私のテンションが上がります。
