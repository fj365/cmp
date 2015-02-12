package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.system.*;
	import flash.net.*;
	import flash.text.*;

	public class XiaMi extends Object {
		public var api:Object;
		private var dataurl:String = "http://www.xiami.com/song/playlist/id/";
		private var phpurl:String = "http://web.tuifeiapi.com/tuifei.php?url=";
		public function XiaMi(_api:Object):void {
			api = _api;
		}
		public function callback(id:String, ...rest):void {
			if (!id) {
				api.sendEvent("model_error", "没有代理函数的参数值");
				return;
			}
			api.sendState("connecting");
			load(id);
		}
		private function load(id:String):void {
			var url:String;
			var proxy:String = api.config.proxy_handler;
			if(proxy){
				url = proxy + dataurl + id;		
			}else{
				url = phpurl + dataurl + id;
			}
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.addEventListener(Event.COMPLETE, onLoaded);
			var req:URLRequest = new URLRequest(url);
			try {
				loader.load(req);
			} catch (e:Error) {
				onError();
			}
		}
		private function onError(e:Event = null):void {
			api.sendEvent("model_error", "加载音乐配置失败");
		}
		private function onProgress(e:ProgressEvent):void {
			
		}
		private function onLoaded(e:Event):void {
			System.useCodePage = false;
			var str:String = e.target.data.toString();
			System.useCodePage = true;
			str = str.replace("xmlns", "noxmlns");
			try {
				var xml:XML = new XML(str);
			} catch(e:Error) {
				onError();
				return;
			}
			parse(xml);
		}
		private function parse(xml:XML):void {
			var loc:String = xml..location;
			var src:String;
			if (loc) {
				src = getLocation(loc);
			} else {
				api.sendEvent("model_error", "无法获取地址数据");
				return;
			}
			if (src) {
				api.item.src = phpurl + src;
				api.item.url = phpurl + src;
				api.item.image = phpurl + (xml..pic);
				api.item.lrc = phpurl + (xml..lyric);
				api.item.bg_video = "{src:" + phpurl + (xml..album_pic) + ", scalemode:1}";
				api.sendEvent("model_change", "1");
				return;
			}
			api.sendEvent("model_error", "无法获取播放地址");
		}
		public function getLocation(code:String):String {
			var len:Number = Number(code.charAt(0));
			var str:String = code.substring(1);
			var mod:int = Math.floor(str.length / len);
			var num:int = str.length % len;
			var arr:Array = [];
			var i:int = 0;
			while (i < num) {
				if (arr[i] == undefined) {
					arr[i] = "";
				}
				arr[i] = str.substr(((mod + 1) * i),(mod + 1));
				i ++;
			}
			i = num;
			while (i < len) {
				arr[i] = str.substr(((mod * (i - num)) + ((mod + 1) * num)), mod);
				i ++;
			}
			var s:String = "";
			i = 0;
			while (i < arr[0].length) {
				var j:int = 0;
				while ((j < arr.length)) {
					s = (s + arr[j].charAt(i));
					j ++;
				}
				i ++;
			}
			s = unescape(s);
			var v:String = "";
			i = 0;
			while (i < s.length) {
				if (s.charAt(i) == "^") {
					v = (v + "0");
				} else {
					v = (v + s.charAt(i));
				}
				i++;
			}
			v = v.replace("+", " ");
			return v;
		}
		
	}
	
}
