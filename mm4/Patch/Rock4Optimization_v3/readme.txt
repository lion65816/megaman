====================================================================================================
ロックマン４実行速度最適化及び機能拡張パッチ

・ウェブサイト
　　　　　http://borokobo.web.fc2.com/
　　　　　（Neoぼろくず工房）
　　　　　http://www.geocities.jp/rock5easily/
　　　　　（ロックマン5いじり by Rock5easily）
　　　　　http://www.geocities.jp/borokobo/
　　　　　（Neoぼろくず工房別館）
====================================================================================================
●あいさつ
　本パッチをＤＬしていただき、ありがとうございます。

●免責
　使用は自己責任でお願い致します。

●概容
　ロックマン４も、場所によっては処理落ちが激しいです。
　本パッチは、各所に最適化を施すことで、
　ゲーム全体の処理速度を向上させ、処理落ちを軽減させます。
　一部、ゲームの方の仕様を変更してまで
　処理速度を優先させている点にご注意ください。
　今回も、Rock5easilyさんに協力を仰ぎ、Rock5easilyさんの最適化も導入しました。
　加えて、私とRock5easilyさんの作った、
　色々な機能を追加したり変更するパッチを導入してあります。

　いろいろな変更がありますが、同梱のasmソースとアセンブラを利用すれば、
　各種最適化、及び、各種機能拡張の中から
　好みのものだけを選んで利用できるように作られています。

●ips使用法
　幾つか利用が想定されそうなパターンをアセンブルしてパッチにしました。
　以下のパッチからどれか１つを選んで利用することが出来ます。
　１つだけ、適当なパッチソフトで当ててください。

Rock4Opt_Std.ips
　ロックマン４原作を最適化することを目的としたパッチです。
　拡張機能は一切施されない、ストイックなパッチとなっております。

Rock4Opt_Exp.ips
　上のパッチに加え、改造で使われそうな機能を追加したパッチです。

　それぞれ、どの最適化・機能拡張が当たっているかは、
ips比較.txt
　を御覧ください。

●asmコード使用法
　そんなプリセットなipsだけじゃ満足できない！自分で機能を選びたい！という
　やる気に満ち溢れる方は、asmコードを利用し、
　自分でオプションを調整してアセンブルし、
　自分の好みに合わせ調整することが出来ます。
　手順はそこまで難しくはありません。興味のある方は、srcフォルダの、
調整法.txt
　を御覧ください。

●付録
　私のウェブサイトで、色々な検証Luaが公開されていますが、
　この最適化を当てると正常に動かなくなってしまうものもあります。
　この最適化の後でも正しく動作するように書き換えたものを
　「付録」フォルダにいれてあります。

●不具合・補足など
・基本的にロクにテストしていないのでバグるかもしれません。
・未使用っぽい領域を利用している処理が多数あります。
　改造ロックマンに適用する場合、被らないようにご注意下さい。
　アセンブルオプションを変更してアセンブルすることで、未使用っぽい領域を
　値22にフィルすることも可能です。

●謝辞
　ロックマンと水の接触に関する最適化を、
　MatrixzさんのMega Man Foreverにおいて使われている手法を参考にしており、
　今回、Matrixzさんの許可を得て配布しています。
　そもそも、私は改造ロックマンで処理速度を最適化をするという発想がほぼなく、
　この最適化に気づいたことが、4miを最適化しようというきっかけになりました。
　もし私がこの最適化に気づいていなかったら、
　最終的に4miはラグ地獄改造になってしまったことでしょう。
　いえ、その前にそれに嫌気が差して制作を諦めていたでしょう。
　こういった私の考え方を大きく変化させるきっかけを作った氏に
　この場でお礼を申し上げたいと思います。

　また、前述のとおり、Rock5easilyさんによる最適化及び機能拡張等のパッチを
　許可を得て使わせて頂いております。ありがとうございます。
　特にスクロール速度の向上は、画像の高速転送を伴う改造であり、
　これもまた、4miの各所に大きな影響を与えたコードです。
　さらに今回は、この機能拡張のために、
　幾つか新たにコードを書き下ろして頂き、本当に感謝しております。

●更新履歴
◎v1(2014年2月15日)
　初版

◎v2(2014年4月29日)
　各種最適化以外にも機能追加

◎v3(2016年7月3日)
　トゲのダメージ化を追加

●ソース・利用条件など
　srcフォルダ内に入れてあります。
　改変・利用等はご自由に。全部でも一部でも。
