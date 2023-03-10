ロックマン３の修正詰め合わせ

・配布元ウェブサイト
　　　　　http://borokobo.web.fc2.com/
　　　　　（Neoぼろくず工房）
　　　　　http://www4.atpages.jp/borokobo/
　　　　　（Neoぼろくず工房別館）

●概容
　ロックマン３のバグや珍妙な仕様を幾つか修正するパッチです。
　以下の修正が含まれます。

（１）ラッシュアダプターの捏造バグ修正
　サブ画面にて、スパークショック・シャドーブレードにカーソルを合わせ右を押すと
　持っていないマリンやジェットを選択でき、うまくやると捏造できてしまうバグ修正。

（２）ワイリーステージ以降のコンティニュー修正
　ワイリーステージ以降、コンティニューシーンのカーソルを
　常時CONTINUEに合った状態にする。

（３）イエローデビルMk-IIの判定修正
　イエローデビルの判定が何もない場所に移動する仕様を修正。

（４）ジャイアントメットールのアイテム修正
　ジャイアントメットールが落としたアイテムがおかしいバグを修正。

（５）フラッシュマンからの連続ダメージ修正
　ドクロフラッシュマンが時を止める時にまれに連続ダメージを喰らうバグを修正。

●使用法
　適当なパッチソフトで当ててください。

●不具合・補足など
・基本的にロクにテストしていないのでバグるかもしれません。
・未使用っぽい領域を利用している処理があります。被らないようにご注意下さい。
・（１）から（５）を部分的に利用したい場合は、
　ソースファイルを利用してどうにかしてください。
・ご自由にお使いください。許可等は全く必要ありませんが、
　ドキュメントに一言添えて頂けるととても嬉しいです。
・ハードマンが地響きを起こした瞬間に倒すと、画面がしばらくずれたままになったり、
　ボスラッシュではゲームが進行しなくなる不具合も修正していたのですが、
　未使用領域が確保できない都合で同封していません。
　興味のある方は、ボスを倒した時の処理に、
　画面のY座標たる<$FAに00を書き込んだり、
　ボスラッシュ時、ロックマンの状態たる<$30が0Fなら00を書き込んだりする
　処理を付加すると良いと思います。

●ソース
　srcフォルダに入れておきました。改変・利用等ご自由に。
　各修正点の、もう少し詳細なメモが書いてあったりもします。
