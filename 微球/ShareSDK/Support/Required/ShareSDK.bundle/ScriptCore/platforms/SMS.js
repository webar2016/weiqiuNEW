var $pluginID = "com.mob.sharesdk.SMS";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([1-9a-zA-Z]|1\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('9 A={"B":"covert_url"};7 a(8){6.S=8;6.h={"w":1,"x":1}}a.b.8=7(){f 6.S};a.b.q=7(){f"短信"};a.b.cacheDomain=7(){f"SSDK-Platform-"+6.8()};a.b.M=7(){5(6.h["x"]!=1&&6.h["x"][A.B]!=1){f 6.h["x"][A.B]}k 5(6.h["w"]!=1&&6.h["w"][A.B]!=1){f 6.h["w"][A.B]}f $2.4.M()};a.b.localAppInfo=7(E){5(T.N==0){f 6.h["w"]}k{6.h["w"]=E}};a.b.serverAppInfo=7(E){5(T.N==0){f 6.h["x"]}k{6.h["x"]=E}};a.b.saveConfig=7(){};a.b.isSupportAuth=7(){f false};a.b.authorize=7(F,settings){9 c={"l":$2.4.r.C,"m":"平台［"+6.q()+"］不支持授权功能!"};$2.native.ssdk_authStateChanged(F,$2.4.n.o,c)};a.b.cancelAuthorize=7(3){};a.b.getUserInfo=7(query,3){9 c={"l":$2.4.r.C,"m":"平台［"+6.q()+"］不支持获取用户信息功能!"};5(3!=1){3($2.4.n.o,c)}};a.b.addFriend=7(F,user,3){9 c={"l":$2.4.r.C,"m":"平台["+6.q()+"]不支持添加好友方法!"};5(3!=1){3($2.4.n.o,c)}};a.b.getFriends=7(cursor,size,3){9 c={"l":$2.4.r.C,"m":"平台["+6.q()+"]不支持获取好友列表方法!"};5(3!=1){3($2.4.n.o,c)}};a.b.share=7(F,g,3){9 p=1;9 y=1;9 d=1;9 G=1;9 e=1;9 H=1;9 i=6;9 I=g!=1?g["@I"]:1;9 J={"@I":I};9 8=$2.4.s(6.8(),g,"8");5(8==1){8=$2.4.t.U}5(8==$2.4.t.U){8=6.V(g)}5(8!=$2.4.t.W&&8!=$2.4.t.O){9 c={"l":$2.4.r.UnsupportContentType,"m":"不支持的分享类型["+8+"]"};5(3!=1){3($2.4.n.o,c,1,J)}f}$2.P.isPluginRegisted("com.2.sharesdk.connector.sms",7(j){5(j.D){p=$2.4.s(i.8(),g,"p");G=$2.4.s(i.8(),g,"G");e=$2.4.s(i.8(),g,"e");H=$2.4.s(i.8(),g,"H");5(8==$2.4.t.O){y=$2.4.s(i.8(),g,"d");5(X.b.Y.Z(y)===\'[10 11]\'){5(e==1){e=[]}d=y}}i.12([p],7(j){p=j.D[0];i.K(e,d,0,7(e){$2.P.ssdk_smsShare(8,p,G,e,H,7(j){9 L=j.L;9 z=1;switch(L){13 $2.4.n.Success:{z={};z["p"]=p;5(y!=1){z["d"]=y}14}13 $2.4.n.o:z={"l":j["l"],"m":j["m"]};14}5(3!=1){3(L,z,1,J)}})})})}k{9 c={"l":$2.4.r.APIRequestFail,"m":"平台["+i.q()+"]需要依靠15.16进行分享，请先导入15.16后再试!"};5(3!=1){3($2.4.n.o,c,1,J)}}})};a.b.callApi=7(u,method,params,headers,3){9 c={"l":$2.4.r.C,"m":"平台［"+6.q()+"］不支持获取用户信息功能!"};5(3!=1){3($2.4.n.o,c)}};a.b.createUserByRawData=7(rawData){f 1};a.b.V=7(g){9 8=$2.4.t.W;9 d=$2.4.s(6.8(),g,"d");5(X.b.Y.Z(d)===\'[10 11]\'){8=$2.4.t.O}f 8};a.b.K=7(e,d,v,3){5(d==1){5(3!=1){3(e)}f}9 i=6;5(v<d.N){9 Q=d[v];5(Q!=1){6.17(Q,7(u){e.push(u);v++;i.K(e,d,v,3)})}k{v++;6.K(e,d,v,3)}}k{5(3!=1){3(e)}}};a.b.17=7(u,3){5(!/^(file\\:\\/)?\\//.test(u)){$2.P.downloadFile(u,7(j){5(j.D!=1){5(3!=1){3(j.D)}}k{5(3!=1){3(1)}}})}k{5(3!=1){3(u)}}};a.b.12=7(R,3){5(6.M()){$2.4.convertUrl(6.8(),1,R,3)}k{5(3){3({"D":R})}}};$2.4.registerPlatformClass($2.4.platformType.a,a);',[],70,'|null|mob|callback|shareSDK|if|this|function|type|var|SMS|prototype|error|images|attachments|return|parameters|_appInfo|self|data|else|error_code|error_message|responseState|Fail|text|name|errorCode|getShareParam|contentType|url|index|local|server|origImgs|resultData|SMSInfoKeys|ConvertUrl|UnsupportFeature|result|value|sessionId|title|recipients|flags|userData|_dealImages|state|convertUrlEnabled|length|Image|ext|imageUrl|contents|_type|arguments|Auto|_getShareType|Text|Object|toString|apply|object|Array|_convertUrl|case|break|ShareSDKConnector|framework|_getImagePath'.split('|'),0,{}))