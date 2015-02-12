package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.system.*;
	import flash.net.*;
	import flash.text.*;

	public class Proxy extends MovieClip {
		public function Proxy():void {
			Security.allowDomain("*");
			root.loaderInfo.sharedEvents.addEventListener('api',apiHandler);
			root.loaderInfo.sharedEvents.addEventListener('api_remove',removeHandler);
		}
		override public function set width(v:Number):void {
		}
		override public function set height(v:Number):void {
		}
		public function removeHandler(e):void {
			
		}
		private function apiHandler(e):void {
			var apikey:Object = e.data;
			if (! apikey) {
				return;
			}
			var api:Object = apikey.api;
			
			if (!api.hasOwnProperty("addProxy")) {
				var tf:TextField = new TextField();
				tf.autoSize = "left";
				tf.defaultTextFormat = new TextFormat(null, 18, 0xfff000, true);
				tf.htmlText = '<a href="http://cmp.cenfun.com/download/cmp4">当前版本CMP4不支持此插件，请点击下载并升级到最新版</a>';
				addChild(tf);
				return;
			}
			/*
			var youku:Youku = new Youku(api);
			api.addProxy("youku", youku.callback);
			var sina:Sina = new Sina(api);
			api.addProxy("sina", sina.callback);
			*/
			var xiami:XiaMi = new XiaMi(api);
			api.addProxy("xiami", xiami.callback);
			
		}
		
	}
	
}
