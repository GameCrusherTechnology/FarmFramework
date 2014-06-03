package controller
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	import view.panel.FactoryPanel;

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
		private var _factoryPanel:FactoryPanel;
		public function get factoryPanel():FactoryPanel
		{
			if(!_factoryPanel){
				_factoryPanel = new FactoryPanel();
			}
			return _factoryPanel;
		}
		
		public function showFacPanel(item_id:String = null):void
		{
			if(!_factoryPanel){
				_factoryPanel = new FactoryPanel();
			}else{
				_factoryPanel.refresh();
			}
			showPanel(_factoryPanel);
			if(item_id){
				_factoryPanel.showItem(item_id);
			}
		}
		public function showPanel(panel:Sprite,exclusive:Boolean=false):void
		{
			if(GameController.instance.isHomeModel){
				UpdateController.instance.sendUpdateList();
			}
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
		public function get hasPanel():Boolean
		{
			return layer && (layer.numChildren >=1) ;
		}
	}
}