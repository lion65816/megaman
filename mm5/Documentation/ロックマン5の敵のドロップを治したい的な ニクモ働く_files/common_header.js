function renderCmnHeader ( textColor, bgColor, logoImg) {
  var common_header_pr_html_left  = '<scr' + 'ipt type="text/javascript" src="https://js.gsspcln.jp/t/236/761/a1236761.js"></script>';
  var common_header_pr_html_right = '<scr' + 'ipt type="text/javascript" src="https://js.gsspcln.jp/t/076/865/a1076865.js"></script>'; // ad tags Size: 300x20 ZoneId:1076865
  document.write(''
  + '<link rel="stylesheet" href="https://blog.seesaa.jp/css/common-header.css" type="text/css" />'
  + '<style type="text/css">'
  + '  #common-header a.seesaa-adLink,'
  + '  #common-header a.adTitle{'
  + '    color: ' + textColor + ';'
  + '  }'
  + '  #common-header .bgcolor{'
  + '    background: ' + bgColor + ';'
  + '  }'
  + '</style>'
  + '<div id="common-header">'
  + '  <div class="wrap bgcolor">'
  + '    <div class="leftbox">'
  + '      <div class="logo">'
  + '        <a href="https://blog.seesaa.jp"><img src="https://blog.seesaa.jp/img/common_header/logo/' + logoImg + '" alt="Seesaaブログ" border="0" /></a>'
  + '      </div>'
  + '      <div class="prbox bgcolor">'
  + '        <div class="pr1 bgcolor" id="common-header-ads">' + common_header_pr_html_left + '</div>'
  + '        <div class="pr2 bgcolor">' + common_header_pr_html_right + '</div>'
  + '        <div class="both"></div>'
  + '      </div>'
  + '      <div class="both"></div>'
  + '  </div>'
  + '  <div class="rightbox bgcolor">'
  + '    <div id="sbContainer" class="seesaaSearchBox"></div>'
  + '    <script type="text/javascript"><!--\n'
  + '      var seesaa_sb_keywords =  ["ダイエット","アフィリエイト","引越し見積もり","アパート探し","新入学","春休み","地震対策","地震予知","iPhoneアプリ","海外旅行","旅行","ペット用品","置き換えダイエット","AKB48","メタボ","自動車免許","FX","コスプレ","iPhone5","マンション投資"];'
  + '      var seesaa_sb_blog_url = "https://blog.seesaa.jp"; '
  + '      var seesaa_sb_tag_url  = "https://blog.seesaa.jp/tag"; '
  + '    //--></script>'
  + '    <script type="text/javascript" src="https://blog.seesaa.jp/js/common_header_sb.js" charset="Shift_JIS"></script>'		 
  + '  </div>'
  + '  <div class="both"></div>'
  + '  </div>'
  + '</div>'
  + '');
}
