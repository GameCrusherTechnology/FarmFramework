package controller
{
	import gameconfig.Configrations;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import view.component.UIButton.ToolStateButton;
	import view.entity.GameEntity;
	import view.ui.EditToolsUI;
	import view.ui.FarmToolUI;

	public class UiController
	{
		public static const TOOL_HARVEST:String = "harvest";
		public static const TOOL_SEED:String = "seed";
		public static const TOOL_SPEED:String = "speed";
		public static const TOOL_ADDFEILD:String = "addFeild";
		public static const TOOL_MOVE:String = "move";
		public static const TOOL_SELL:String = "sell";
		public static const TOOL_CANCEL:String = "cancel";
		private static var _controller:UiController;
		private var _layer:Sprite;
		public static function get instance():UiController
		{
			if(!_controller){
				_controller = new UiController();
			}
			return _controller;
		}
		public function UiController()
		{
		}
		
		private var _editToolsUI:EditToolsUI;
		public function showEditUiTools(open:Boolean=false):void
		{
			if(!_editToolsUI){
				_editToolsUI = new EditToolsUI();
			}
			if(!_editToolsUI.parent){
				_layer.addChild(_editToolsUI);
			}
			_editToolsUI.show(open);
			_editToolsUI.x = Configrations.ViewPortWidth;
			_editToolsUI.y = Configrations.ViewPortHeight - _editToolsUI.height;
			
			var tween:Tween = new Tween(_editToolsUI, 0.5);
			tween.moveTo(Configrations.ViewPortWidth- _editToolsUI.width, Configrations.ViewPortHeight - _editToolsUI.height);                 
			Starling.juggler.add(tween);
		}
		public function hideEditUiTools():void
		{
			if(_editToolsUI && _editToolsUI.parent){
				_editToolsUI.parent.removeChild(_editToolsUI);
			}
		}
		
		private var _toolStateButton:ToolStateButton;
		public function showToolStateButton(type:String,texture:Texture):void
		{
			if(!_toolStateButton){
				_toolStateButton = new ToolStateButton();
			}
			if(!_toolStateButton.parent){
				_layer.addChild(_toolStateButton);
			}
			_toolStateButton.show(type,texture);
			_toolStateButton.x = Configrations.ViewPortWidth - _toolStateButton.width - 10;
			_toolStateButton.y = Configrations.ViewPortHeight/2;
			_toolStateButton.alpha = 0.5;
			var tween:Tween = new Tween(_toolStateButton, 0.5);
			tween.animate("alpha",1);
			Starling.juggler.add(tween);
		}
		public function showToolStateEffect():void
		{
			if(_toolStateButton){
				_toolStateButton.playEffect();
			}
		}
		public function hideToolStateButton():void
		{
			if(_toolStateButton && _toolStateButton.parent){
				_toolStateButton.parent.removeChild(_toolStateButton);
			}
		}
		
		
		private var _toolsUI:FarmToolUI;
		public function showUiTools(type:String,entity:GameEntity=null):void
		{
			if(!_toolsUI){
				_toolsUI = new FarmToolUI();
			}
			if(!_toolsUI.parent){
				_layer.addChild(_toolsUI);
			}
			_toolsUI.show(type,entity);
			_toolsUI.x = Configrations.ViewPortWidth/2- _toolsUI.width/2;
			_toolsUI.y = Configrations.ViewPortHeight;
			
			var tween:Tween = new Tween(_toolsUI, 0.5);
			tween.moveTo(Configrations.ViewPortWidth/2- _toolsUI.width/2, Configrations.ViewPortHeight - _toolsUI.height -10);                 
			Starling.juggler.add(tween);
		}
		public function hideUiTools():void
		{
			if(_toolsUI && _toolsUI.parent){
				_toolsUI.parent.removeChild(_toolsUI);
			}
		}
		public function setLayer(_la:Sprite):void
		{
			_layer = _la;
		}
	}
}