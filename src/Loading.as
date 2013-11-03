package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class Loading extends Sprite
	{
		private static var frames:uint;
		private var percentTotal:Number;
		private var text:TextField;
		private var timer:Timer;
		public function Loading()
		{
			addEventListener(Event.ADDED_TO_STAGE,addPreloader);
		}
		public function addPreloader(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,addPreloader);
			//进度条显示
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		private function onEnterFrame(e:Event):void{
		}
		
	}
}