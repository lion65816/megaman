--Rockman2 MMC5化パッチ

ロックマン2をMMC5化するパッチを作りました。
これによりMMC5の機能を使ったり、容量を1MBまで使用することが出来るようになります。

ただし、いろいろな問題点はあります。
問題点は後ほど



--必要な物
当たり前ですが
ロックマン2（日本版）（赤いカセットのやつね）、
またnesファイルのヘッダーが付いたイメージであること、
ROMイメージが壊れていない事。

IPSパッチを当てるソフト、
また場合によってはNES Extend Patch Tool

NES Extend Patch Toolについてはこちら
わいわいの巣
http://www.geocities.jp/yy_6502/
NesExtendPatchTool.zipでもNesExtendPatchTool3.zipでもどちらでも可です


--内容物
ips/rm2mmc5.ips
rom拡張を"せずに"ロックマン2をMMC5化するパッチです

nespフォルダ以下はRM2_MMC5.nesp以外はデータファイルです。
nespファイルと違うフォルダに出したりしないでください

nesp/RM2_MMC5.nesp
スクリプトファイル
NES Extend Patch Toolをダウンロードして、IPSパッチのようにロックマン2に当ててください
ロックマン2を1MBまで拡張し、MMC5化します。


--概要
ロックマン2はMMC1っていうマッパーが使われています
それをMMC5というマッパーに変更しました
MMC5にするとプログラム領域の容量を1MBまで多くしたり
いろんな機能が追加出来るようになります。
ただし、本来MMC5はロックマン2に乗せることはプログラムをMMC5に対応させたところで不可能とおもいます


--問題点
ロックマン2はVRAMが使用されていますが、
現実に存在しているMMC5が使われたゲームでVRAMを使われたゲームが存在しません
（仕様的に対応してるかは不明らしい）
ゆえに、一部のエミュですでに動かなかったりします（VirtuaNESで動作しないのを確認）
また、将来的に動かなくなる可能性もあります。
更に、PRG-ROMの大きさが1MBのゲームが無いのでそういう意味でもROM焼きが出来無い可能性があります
（MMC5の実カセットの容量って同じ？全部1MB+1MBの容量があったりする？その辺あんまり詳しくない）
（ちなみに一番容量大きいゲームは多分メタルスレイダーグローリーのPRG＋CHRあわせて1MBだと思う）

一部を除いたエミュで動けば良い、どうしてもMMC5の機能を使いたいって人向けのものになります

拡張だけなら倍のりりか氏のMMC6パッチで512KBまで増やせば不自由無いぐらい色々出来ると思いますし・・・
まあタブーに触れては居ますね。多分。


--MMC5の主な機能
ラスタースクロール出来たり（MMC3(6)より簡単？そもそもIRQ詳しくないからよくわからんですけど）
SRAM使えたり、
拡張音源が使えたり、
通常背景は16*16でパレット割り当てしてるところを8*8でパレット割り当て出来るようにしたり、
マッパーの機能で掛け算出来たり（？）
後他にもよくわからない機能が・・・　横方向にもラスタースクロール的なのが出来るっぽい？
機能は本当に豊富です。MMC5で発売されてるゲームで全て使われてるか謎なくらいに。



--補足
上でいろいろな機能を書いてはいますが、
実際に今回のパッチを当てるだけだとSRAM使えるようにしているぐらいで他の機能は基本的に使っていません
使用するなら各自自分でプログラムを作る必要があります。
幸い、ロックマン2はメインバンクにそれなりの空き領域があるので・・・
また、SRAMは使用していますが、バックアップ機能は"ONにしていない"ので必要があればヘッダを弄ってください

初期設定はメインバンク（最終バンクの）F29A〜F2D0あたりで行なっているので
SRAM要らんとか有りましたら各自設定しなおしてください
バンク切り替え設定のみFFE4あたり、で2000hバイトごとに切る設定にしてあります
また、このパッチはその辺の空き領域を使っております。

汎用バンク切り替えルーチン(C000)は前半2つのバンクを切り替えるルーチンですので、
必要があれば一つずつバンクを切り替えるルーチンを作っておくのは便利かもしれません
後ロングジャンプルーチンとかも必要かも？



--参考資料
Neoぼろくず工房
http://borokobo.web.fc2.com/index.html
ワイリー謹製トゲの味→ロックマン４　防水加工って大事

りりか氏のMMC6化パッチ
リンクURLは今は（？）

Nesdev Wiki
http://wiki.nesdev.com/
NES reference guide→Mapper→MMC1、MMC3、MMC5、MMC6


以上

2012年8月22日
作者：に

二次配布等は多分著作権とか問題ない物とおもいますしご自由にどうぞ
ただし内容物は変えないでください