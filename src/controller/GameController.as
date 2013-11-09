package controller
{
	import model.player.GamePlayer;
	
	import starling.display.Sprite;
	
	import view.FarmScene;
	import view.TweenEffectLayer;
	import view.ui.GameUI;

	public class GameController
	{
		private var gameLayer:Sprite;
		private var sceneLayer:Sprite;
		private var dialogLayer:Sprite;
		private var uiLayer:GameUI;
		public var effectLayer:TweenEffectLayer;
		public var currentPlayer:GamePlayer;
		public var localPlayer:GamePlayer;
		public var selectTool:String;
		public var selectSeed:String;
		public var userID:String;
		
		private static var _controller:GameController;
		public static function get instance():GameController
		{
			if(!_controller){
				_controller = new GameController();
			}
			return _controller;
		}
		public function GameController()
		{
			
		}
		
		public function resetTools():void
		{
			selectSeed = null;
			selectTool = null;
			UiController.instance.hideToolStateButton();
		}
		public function start(layer:Game):void
		{
			gameLayer = layer;
			configScene();
			UiController.instance.setLayer( configUi());
			
			dialogLayer = new Sprite();
			gameLayer.addChild(dialogLayer);
			DialogController.instance.setLayer(dialogLayer);
			
			effectLayer= new TweenEffectLayer();
			gameLayer.addChild(effectLayer);
			
			onLogin();
		}
		private function configScene():void
		{
			sceneLayer = new Sprite();
			gameLayer.addChild(sceneLayer);
		}
		private function configUi():Sprite
		{
			uiLayer = new GameUI();
			gameLayer.addChild(uiLayer);
			return uiLayer;
		}
		private function onLogin():void
		{
			var data:Object ={};
			data["extend"] = 0;
			currentPlayer = new GamePlayer(data);
			LoginFarm();
		}
		
		public var currentFarm:FarmScene;
		private function LoginFarm():void
		{
			currentFarm = new FarmScene();
			sceneLayer.addChild(currentFarm);
			uiLayer.homeUI();
		}
		
		
	}
}