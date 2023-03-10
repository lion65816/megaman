簡易説明

ロックマン6のROMイメージを読み込むことで、マップ・オブジェクトの配置等を編集できます。

[パレット]
3〜5までとは格納方法が異なるため、現時点では編集を行っても保存時には反映されません。
コンボボックスで「パレット定義0,1」を切り替えると、それぞれステージクリア前後のパレットでマップを描画します。


[16x16チップ]
ここで16x16のチップを作成します。
編集したい16x16チップを選択して、8x8のタイルを組み合わせて下さい。
チップの属性・パレットは、ラジオボタンで変更できます。

16x16チップ上を右クリックで、マウスカーソルの位置の8x8タイルを選択できます。


[32x32チップ]
ここで32x32のチップを作成します。
編集したい32x32チップを選択して、16x16のチップを組み合わせて下さい。

・32x32チップリスト上での操作
Ctrl + 右クリック … 32x32チップをコピー
Ctrl + 左クリック … 上の操作でコピーした32x32チップを貼り付け
Shift + 右クリック … マウスカーソルの位置の16x16チップを選択する(単に右クリックだけでも可)
Shift + 左クリック … マウスカーソルの位置の16x16チップを選択チップで書き換え


[マップセット]
ここで一画面分のマップを作成します(3〜5とは異なり、ここでの並びがそのままマップでのステージの並びとなります)。
32x32チップを組み合わせていきます。
編集対象のチップ上で右クリックすると、そのチップが選択チップになります。
また、[32x32チップ]で編集対象のチップを選択しても、そのチップが選択チップになります。
(選択チップが例のごとく潰れて見にくいので、活用して下さい。)

・マップセット表示画面上での操作
Ctrl + 右クリック … マップセット1画面単位でコピー
Ctrl + 左クリック … マップセット1画面単位で貼り付け


[オブジェクト]
敵やアイテム等のオブジェクトの配置・編集を行います。
・ドラッグでオブジェクトの移動を行います。この際Ctrlキーを押しながらだと8ドット、
　Shiftキーを押しながらだと4ドット単位で移動します。

・Shift+Ctrlキーを押しながらオブジェクトをドラッグしても、オブジェクトの座標は変わりません。
　これにより不意のオブジェクトの移動を防ぐことができます。

・オブジェクトをクリックすると、編集対象オブジェクト欄でオブジェクトの種類を変更できます。

・右クリックでポップアップメニューが表示され、オブジェクトの追加・削除等ができます。

・「オブジェクトの番号を自動変更」をチェックで、X座標の小さいオブジェクト順に番号が振られます。
　チェックしておいた方が無難です。

※全ステージオブジェクト総数の1657は、BANK3Aの95D5-9FFFが未使用であると仮定して設定している値です。



「再読み込み」ボタンについて
各項目について、ステージ毎にROMバッファからデータを読み込み直します。
ファイルの保存処理を行うと、ROMバッファ自体が更新されるので注意して下さい。





更新履歴

08/09/25 少し修正・オブジェクト情報表示ポップアップの表示時間を長めに変更 
08/09/21 いろいろ機能追加
08/09/20 とりあえず作成
















作った人：
  ■ 改造ロックマンについて語るスレ ■ / 175
