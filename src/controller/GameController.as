package controller
{
	import flash.utils.setTimeout;
	
	import model.player.GamePlayer;
	
	import service.command.LoginCommand;
	import service.command.user.UserVisitFriendCommand;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	import view.FarmScene;
	import view.TweenEffectLayer;
	import view.loading.CloudLoadingScreen;

	public class GameController
	{
		private var gameLayer:Sprite;
		private var sceneLayer:Sprite;
		private var dialogLayer:Sprite;
		private var uiLayer:Sprite;
		public var effectLayer:TweenEffectLayer;
		public var currentPlayer:GamePlayer;
		public var localPlayer:GamePlayer;
		public var selectTool:String;
		public var selectSeed:String;
		public var userID:String = "testplayer1";
		
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
			UpdateController.instance.sendUpdateList();
		}
		
		public function show(layer:Game):void
		{
			gameLayer = layer;
			showLoading();
		}
		public function start():void
		{
			configScene();
			
			uiLayer = new Sprite;
			gameLayer.addChild(uiLayer);
			
			dialogLayer = new Sprite();
			gameLayer.addChild(dialogLayer);
			DialogController.instance.setLayer(dialogLayer);
			
			effectLayer= new TweenEffectLayer();
			gameLayer.addChild(effectLayer);
			
			new LoginCommand(onLogin);
		}
		private function configScene():void
		{
			sceneLayer = new Sprite();
			gameLayer.addChild(sceneLayer);
		}
		
		private function onLogin():void
		{
			LoginFarm();
			TaskController.instance.initTask();
		}
		private function onRefreshFriend():void
		{
			TaskController.instance.initTask();
		}
		public function get layer():Sprite
		{
			return gameLayer;
		}
		public var currentFarm:FarmScene;
		private function LoginFarm():void
		{
			setTimeout(hideLoading,1000);
			if(currentFarm){
				currentFarm.dispose();
				if(currentFarm.parent){
					currentFarm.parent.removeChild(currentFarm);
				}
			}
			currentFarm = new FarmScene();
			sceneLayer.addChild(currentFarm);
			
			UiController.instance.refresh(uiLayer);
			DialogController.instance.destroy();
		}
		
		private var loading:CloudLoadingScreen;
		public function showLoading():void
		{
			if(!loading){
				loading = new CloudLoadingScreen;
			}
			layer.addChild(loading);
		}
		
		public function hideLoading():void
		{
			
			if(loading ){
				var tween:Tween = new Tween(loading,2);
				tween.animate("alpha",0.1);
				tween.onComplete = function () :void{
					if(layer&&layer.parent){
						layer.removeChild(loading);
						layer.alpha = 1;
					}
				}
				Starling.juggler.add(tween);
			}
		}
		
		public function visitFriend(tgameuid:String = null):void
		{
			if(!tgameuid || tgameuid == localPlayer.gameuid){
				new LoginCommand(onLogin);
			}else{
				new UserVisitFriendCommand(tgameuid,onVisitFriend);
			}
		}
		
		private function onVisitFriend():void
		{
			LoginFarm();
		}
		
		public function get isHomeModel():Boolean
		{
			return localPlayer == currentPlayer;
		}
		
	}
}