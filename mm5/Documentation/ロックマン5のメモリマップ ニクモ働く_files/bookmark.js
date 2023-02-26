

  var delm = ',';
  var bookmark_services = seesaa_bookmark_services.split(delm);
  var bs_hash = {};
  for( var bs_num in  bookmark_services ) {
      bs_hash[bookmark_services[bs_num]] = true;
  }
  var service_url;
  var alt_str;
  var article_subject = encodeURIComponent(seesaa_article_subject);
  var evernote_content;

  var escMap = {
      '&' : '&amp;',
      '<' : '&lt;',
      '>' : '&gt;',
      '"' : '&quot;',
      "'" : '&#39;'
  };
  var escapeHTML = function (string) {
           return string.replace(/[&<>"']/g, function(match) { return escMap[match]; });
  };

  document.write('<div class="bookmark">');
  document.write('<style type="text/css">.bookmark a{padding-left:2px;}</style>');  

  (function(){
    var order_bookmark_service = [
      'yahoo' ,
      'livedoor' ,
      'evernote' ,
      'iza' ,
      'infoseek' ,
      'newsing' ,
      'buzzurl' ,
      'choix' ,
      'reddit' ,
      'blinklist' ,
      'digg' ,
      'twitthis' ,
      'diigo'
    ];
  
    var current_bs_name;
    var order_bookmark_service_flg = 0;
    for(var order_cnt = 0, len = order_bookmark_service.length; order_cnt < len; order_cnt++ ) {
        current_bs_name = order_bookmark_service[order_cnt];
        if (!bs_hash[current_bs_name]) continue;
        service_url = '';
        var img_url;
      switch( current_bs_name ) {
        case 'hatena': 
          service_url = 'http://b.hatena.ne.jp/append?' + seesaa_article_page_url;
  	img_url = seesaa_blog_url + '/img/bookmark/hatena_ico.gif';
  	alt_str = 'このエントリをはてなブックマークする';
        order_bookmark_service_flg = 1;
  	break;
        case 'yahoo': 
  	service_url = 'javascript:window.location=\'http://bookmarks.yahoo.co.jp/action/bookmark?t=' + article_subject + '&u=' + seesaa_article_page_url + '&r=my&fr=ybm_netallica\'';
  	img_url = seesaa_blog_url + '/img/bookmark/yahoo_ico.gif';
  	alt_str = 'Yahoo!ブックマーク';
        order_bookmark_service_flg = 1;
  	break;
        case 'livedoor': 
          service_url = 'http://clip.livedoor.com/clip/add?link=' + seesaa_article_page_url;
  	img_url = seesaa_blog_url + '/img/bookmark/livedoor_ico.gif';
  	alt_str = 'このエントリをLivedoorクリップに追加';
        order_bookmark_service_flg = 1;
  	break;
        case 'evernote':
  			    if ( location.href.match(/\/article\/[0-9]+\.html/) ) { // exclude from seesaa/bl#1123
  				var _g = function ( root, tag, classname) {
  				    var list = root.getElementsByTagName(tag);
  				    for ( var i = 0; i<list.length; i++ ) {
  					if ( list[i].className == classname ) {
  					    return list[i];
  					    continue;
  					}
  				    }
  				};
  				var blogbody = _g(document, 'div', 'blogbody');
  				if ( blogbody ) {
  				    evernote_content = _g(blogbody, 'div', 'text');
  				}
  				
  				document.write('<scr' + 'ipt type="text/javascript" src="http://static.evernote.com/noteit.js"></scr' + 'ipt><a href="#" onclick="Evernote.doClip({ content : (evernote_content ? evernote_content : document.getElementById(\'content\')), contentId: \'' + seesaa_article_page_url + '\' }); return false;"><img src="http://static.evernote.com/site-mem-16.png" border="0" alt="Clip to Evernote" /></a>');
  			    }
          order_bookmark_service_flg = 1;
          break;
        case 'iza':
          service_url = 'http://www.iza.ne.jp/bookmark/add/regist/back/' + seesaa_article_page_url;
  	img_url = seesaa_blog_url + '/img/bookmark/iza_ico.gif';
  	alt_str = "イザ！ブックマーク";
        order_bookmark_service_flg = 1;
  	break;
        case 'infoseek':
  	service_url = 'http://hotnews.infoseek.co.jp/pickup/add/?article_url=' + encodeURIComponent(seesaa_article_page_url);
  	img_url = 'http://image.infoseek.rakuten.co.jp/content/hotnews/pickup_btn.gif';
  	alt_str = 'この記事をみんなのニュースに投稿する';
        order_bookmark_service_flg = 1;
    break;
        case 'newsing': 
          service_url = 'javascript:window.location=\'http://newsing.jp/add?url=' + seesaa_article_page_url + '\'';
  	img_url = seesaa_blog_url + '/img/bookmark/newsing_ico.gif';
  	alt_str = 'Newsing It!';
        order_bookmark_service_flg = 1;
  	break;
        case 'buzzurl': 
          service_url = 'http://buzzurl.jp/entry/' + seesaa_article_page_url;
  	img_url = seesaa_blog_url + '/img/bookmark/buzzurl_ico.gif';
  	alt_str = "Buzzurlにブックマーク";
        order_bookmark_service_flg = 1;
  	break;
        case 'choix':
          service_url = 'http://www.choix.jp/bloglink/' + seesaa_article_page_url;
  	img_url = seesaa_blog_url + '/img/bookmark/choix_ico.gif';
  	alt_str = 'choix';
        order_bookmark_service_flg = 1;
  	break;
        case 'reddit':
  	service_url = 'http://reddit.com/submit?url=' + seesaa_article_page_url + '&title=' + article_subject;
  	img_url = seesaa_blog_url + '/img/bookmark/reddit_ico.gif';
  	alt_str = 'reddit';
        order_bookmark_service_flg = 1;
  	break;
        case 'blinklist': 
  	service_url = 'http://www.blinklist.com/index.php?Action=Blink/addblink.php&Url=' + seesaa_article_page_url + '&Title=' + article_subject;
  	img_url = seesaa_blog_url + '/img/bookmark/blinklist_ico.gif';
  	alt_str = 'blinklist';
        order_bookmark_service_flg = 1;
  	break;
        case 'digg': 
  	service_url = 'http://digg.com/submit?phase=2&url=' + seesaa_article_page_url + '&title=' + article_subject;
  	img_url = seesaa_blog_url + '/img/bookmark/digg_ico.gif';
  	alt_str = 'Digg';
        order_bookmark_service_flg = 1;
  	break;
        case 'twitthis':
  	service_url = 'http://twitthis.com/twit?url=' + seesaa_article_page_url + '&title=' + article_subject;
  	img_url = seesaa_blog_url + '/img/bookmark/twitthis_ico.gif';
  	alt_str = 'Twit This';
        order_bookmark_service_flg = 1;
  	break;
        case 'diigo':
  	service_url = 'http://www.diigo.com/post?url=' + encodeURIComponent(seesaa_article_page_url) + '&title=' + article_subject;
  	img_url = 'http://www.diigo.com/images/ii_blue.gif';
  	alt_str = 'Add to diigo';
        order_bookmark_service_flg = 1;
        break;
        case 'bluedot':
  //	service_url = 'http://bluedot.us/Authoring.aspx?u=' + seesaa_article_page_url + '&t=' + article_subject;
  //	img_url = seesaa_blog_url + '/img/bookmark/bluedot_ico.gif';
  //	alt_str = 'Dot This!';
  //    order_bookmark_service_flg = 1;
  	break;
      }
      if (service_url) {
  	document.write('<a href="' +  escapeHTML(service_url) + '" target="_blank"><img src=' + escapeHTML(img_url) + ' alt="' + escapeHTML(alt_str) + '" title="' + escapeHTML(alt_str) + '" border="0" hspace="1" /></a>');
      }
    }
    if ( order_bookmark_service_flg ){ document.write('<BR>'); }
  })();

  (function(){
    var order_sns_service = [
      'hatena' ,
      'biz-iq' ,
      'mixicheck' ,
      'twitter' ,
      'facebook' ,
      'mixiiine2'
    ];
  
    var current_bs_name;
    var order_sns_service_flg = 0;
    for(var order_cnt = 0, len = order_sns_service.length; order_cnt < len; order_cnt++ ) {
        current_bs_name = order_sns_service[order_cnt];
        if (!bs_hash[current_bs_name]) continue;
        service_url = '';
        var img_url;
      switch( current_bs_name ) {
        case 'hatena': 
          document.write('<a href="http://b.hatena.ne.jp/entry/' + seesaa_article_page_url + '" class="hatena-bookmark-button" data-hatena-bookmark-title="' + seesaa_article_subject + '" data-hatena-bookmark-layout="standard" title="このエントリーをはてなブックマークに追加"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>');
          order_sns_service_flg = 1;
        	break;
        case 'twitter': 
          document.write('<a href="https://twitter.com/share" class="twitter-share-button" data-url="' + seesaa_article_page_url + '" data-lang="ja" data-text="' + seesaa_article_subject + '">ツイート</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script><style type="text/css">iframe.twitter-share-button { width: 110px!important;padding-left:2px;}</style>');
          order_sns_service_flg = 1;
  	      break;
        case 'facebook':
           document.write('<style>.fb-like iframe{height:22px ! important;}</style><div id="fb-root" style="display:inline;padding-left:2px;"></div><script>(function(d, s, id) { var js, fjs = d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js = d.createElement(s); js.id = id; js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&appId=216026118496977&version=v2.6"; fjs.parentNode.insertBefore(js, fjs); }(document, \'script\', \'facebook-jssdk\'));</script><div class="fb-like" layout="button_count" data-href="' + encodeURIComponent(seesaa_article_page_url) + '" data-send="false" data-width="50" data-show-faces="false" style="display:inline;"></div>');
          order_sns_service_flg = 1;
          break;
        case 'biz-iq':
          document.write('<scr' + 'ipt src="https://static.biz-iq.jp/js/connect.js' + '"></scr' + 'ipt>');
          order_sns_service_flg = 1;
          break;
        case 'mixicheck':
          document.write('<style>.mixi-check-button img { border:0;}</style><a href="http://mixi.jp/share.pl" style="border: none" class="mixi-check-button" data-key="42f1153a1bd496f989d5d8a812cb75ffb2e91bb0" data-button="button-1" data-url="' + seesaa_article_page_url + '">mixi check</a><scr' + 'ipt type="text/javascript" src="http://static.mixi.jp/js/share.js"></scr' + 'ipt>');
          order_sns_service_flg = 1;
          break;
        case 'mixiiine2':
          document.write('<div data-plugins-type="mixi-favorite" data-service-key="42f1153a1bd496f989d5d8a812cb75ffb2e91bb0" data-href="' + seesaa_article_page_url + '" data-size="medium" data-width="70" data-show-count="true" data-show-comment="true" style="padding-left:2px;"></div>');
          (function(d) { var s = d.createElement('script');s.type = 'text/javascript';s.async = true;s.src = '//static.mixi.jp/js/plugins.js#lang=ja';d.getElementsByTagName('head')[0].appendChild(s);})(document);
          order_sns_service_flg = 1;
          break;

      }
      if (service_url) {
  	document.write('<a href="' +  escapeHTML(service_url) + '" target="_blank"><img src=' + escapeHTML(img_url) + ' alt="' + escapeHTML(alt_str) + '" title="' + escapeHTML(alt_str) + '" border="0" hspace="1" /></a>');
      }
    }
    if ( order_sns_service_flg ){ document.write('<BR>'); }
  })();

  (function(){
    var order_sns_img_service = [
      'mixiiine1'
    ];
  
    var current_bs_name;
    var order_sns_img_service_flg = 0;
    for(var order_cnt = 0, len = order_sns_img_service.length; order_cnt < len; order_cnt++ ) {
        current_bs_name = order_sns_img_service[order_cnt];
        if (!bs_hash[current_bs_name]) continue;
        service_url = '';
        var img_url;
      switch( current_bs_name ) {
        case 'mixiiine1':
          document.write('<div data-plugins-type="mixi-favorite" data-service-key="42f1153a1bd496f989d5d8a812cb75ffb2e91bb0" data-href="' + seesaa_article_page_url + '" data-size="medium" data-width="70" data-show-count="true" data-show-comment="true" data-show-faces="true"></div>');
          (function(d) { var s = d.createElement('script');s.type = 'text/javascript';s.async = true;s.src = '//static.mixi.jp/js/plugins.js#lang=ja';d.getElementsByTagName('head')[0].appendChild(s);})(document);
  			      //        document.write('<iframe src="http://plugins.mixi.jp/favorite.pl?href=' + encodeURIComponent(seesaa_article_page_url) + '&service_key=42f1153a1bd496f989d5d8a812cb75ffb2e91bb0&show_faces=true" scrolling="no" frameborder="0" allowTransparency="true" style="border:0; overflow:hidden; width:300px; height:80px;"></iframe>');
          order_sns_img_service_flg = 1;
          break;
      }
      if (service_url) {
  	document.write('<a href="' +  escapeHTML(service_url) + '" target="_blank"><img src=' + escapeHTML(img_url) + ' alt="' + escapeHTML(alt_str) + '" title="' + escapeHTML(alt_str) + '" border="0" hspace="1" /></a>');
      }
    }
  })();

  document.write('</div>');
