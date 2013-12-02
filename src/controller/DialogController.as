package controller
{
	import gameconfig.Configrations;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class DialogController
	{
		private static var _controller:DialogController;
		private var layer:Sprite;
		public static function get instance():DialogController
		{
			if(!_controller){
				_controller = new DialogController();
			}
			return _controller;
		}
		public function DialogController()
		{
			
		}
		
		public function showPanel(panel:Sprite,exclusive:Boolean=false):void
		{
			trace("showPanel");
			if(exclusive){
				destroy();
			}
			layer.addChild(panel);
		}
		public function destroy():void
		{
			var displayObj:DisplayObject;
			while(layer.numChildren>0){
				displayObj = layer.getChildAt(0);
				layer.removeChild(displayObj);
			}
		}
		public function setLayer(_la:Sprite):void
		{
			layer = _la;
		}
	}
}