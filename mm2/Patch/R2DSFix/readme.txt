ロックマン２ディレイスクロール簡易修正パッチ
配布元ＨＰ：http://sldnoonmoon.hp.infoseek.co.jp/
　　　　　（Neoぼろくず工房）

●概要
　ロックマン２には、処理落ちが起こると、
　低確率で、本来スクロールできない方向にスクロールしてしまい、
　（大抵の場合は）嵌って行動不可能になる不具合があります。
　その不具合を修正してみようというパッチです。

●パッチ説明・使い方
　R2DSFix.ips
　のパッチを当てると、たぶん修正されます。

　凝った事はしていないパッチなので、
　ロックマン２の大抵のハックロムに当てられるのではないでしょうか……
　もし、ご自分で制作されるハックロムに利用したい場合は、
　ご自由にご利用ください。

●不具合・補足など
・基本的にロクにテストしていないのでバグるかもしれません。
・このパッチは
　「バンク切り替え中にNMIが起きたことにより、
　　先送りにされたＢＧＭ処理がx,yレジスタを破壊する」
　というバグに対し、
　「ＢＧＭ処理を先送りにせずに諦めれば良い」
　という消極的な方法で対応しています。
・そのため、ディレイスクロールが起こる条件下において、
　ＢＧＭのスピードが低下します。
・ですが、頻度がかなり低いため、
　よほど耳の良い方でなければ、
　言われても気づかないレベルなのではないでしょうか……
　少なくとも私にはそう思います。
・ちなみに、私の４改造(Ver100827現在)でも
　同様に、ＢＧＭ処理を諦めて対応しています。
　４には、そこにはバグはないので、x,yレジスタは破壊されないのですが、
　キャリーフラグをどうしても壊したくないという事情があります。
（バンク切り替えルーチンを利用しても、
　その前後でキャリーフラグは保持されると思って
　コーディングをしてきたため、
　後になってまずいことに気づき、慌てて対応した形です）


　もしバグったら、ウェブサイトのほうに
　報告していただけると対処できるかもしれません。

●ソース
	;僅か１バイトの修正ですｗ
	.bank $1E
	.org $C01F
	bit <$01
