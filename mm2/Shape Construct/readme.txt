ロックマン2 形定義を自動構成するツール
	
	●概要
		ロックマンのスプライトデータの定義はとても面倒くさいです。
		これは、形定義データを256個のファイルにして、編集しやすくするものです。
		
	●Rock2ShapeConstruct.exe
		Rock2ShapeConstruct.exeはコマンドライン上で実行することで、
		ロックマン2の形定義を操作することができます。
		
		>Rock2ShapeConstruct <nesファイル> <-r か -w>
		-r ロックマン2から形定義を抽出し、ファイルにまとめる
		　00〜FEまで抽出します(形FFは抽出しません)。
		　make.batはrockman2.nesから抽出するバッチファイルです。
		
		-w ファイルに保存された形定義をロックマン2へ書き込む
		　00〜FFまで書き込みます。
		　形FFは自分でshape_FF.binを作成してください。
		　write.batはrockman2.nesへ書き込むバッチファイルです。
		
		バッチファイルを編集して、任意のnesファイルを指定することができます。
		パス等の設定はaddresses.iniで設定します。なくても動きます。
		[addresses]	ヘッダなしのアドレスです。
			shapeH:	形定義テーブルのアドレス上位
			shapeL:	形定義テーブルのアドレス下位
			shapeBank:	形定義があるバンク(8k単位)
			writeTo:	形定義をnesファイルに書き込む最初のアドレス
		[path]
			writeTo:	形定義の保存フォルダ名
		
	●OpenShapeData.exe
		OpenShapeData.exeはRock2ShapeConstruct.exeで生成したファイルを
		楽に開けるようにします。
		
		下のテキストボックスに形定義データのフォルダを指定し形番号を選んで開きます。
		
		設定はpaths.iniで設定します。
		[paths]
			shapePath:	形定義の保存フォルダ名
			exePath:	形定義を開くソフトのパス
		
		内部では、
		<作業フォルダ>\exePath shapePath\shape_**.bin (**は形番号)
		というコマンドを実行しているので、対応したソフトが必要になります。
		初期設定では、OpenShapeData.exeと同じフォルダにDDS2さんのStirlingを置くことで
		動くようになっています。
		
	●使い方
		1.make.batで形定義を抽出する
		2.OpenShapeData.exeを使って形定義を開き、編集する(もちろん、直接開いてもOK)
		3.write.batで形定義を書き込み
		
	●注意事項
		・形定義の容量が大きすぎると2C000〜に書き込まれてしまうので、
		　書き込みをしたらnesファイルの2C000〜を見て空き領域を確認してください。
		
		・形定義を抽出する際、データが順番通りに並んでいないと抽出に失敗します。
		　形00が一番小さいアドレスに、形FFが一番大きいアドレスにあるようにしてください。
		
		・メインバンクに形定義を書き込むことはできません。
		
	●免責
		これを使ったことで生じる損害について、暇人自治区は一切の責任を取らないものとします。
		また、プログラムのバグについて、修正する義務を負わないものとします。
		
2015 暇人自治区
http://himaq.blog.fc2.com/