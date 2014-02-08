package controller
{
	import flash.desktop.NativeApplication;
	import flash.utils.setTimeout;
	
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import service.command.LoginCommand;
	import service.command.user.UserVisitFriendCommand;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	import view.FarmScene;
	import view.TweenEffectLayer;
	import view.loading.CloudLoadingScreen;
	import view.panel.ConfirmPanel;

	public class GameController
	{
		private var gameLayer:Sprite;
		private var sceneLayer:Sprite;
		private var dialogLayer:Sprite;
		private var uiLayer:Sprite;
		public var effectLayer:TweenEffectLayer;
		public var _curPlayer:GamePlayer;
		
		public var localPlayer:GamePlayer;
		public var selectTool:String;
		public var selectSeed:String;
		public var isNewer:Boolean = false;
		public var userID:String = "super_man_01";
		
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
		public function get currentPlayer():GamePlayer{
			return isHomeModel?localPlayer:_curPlayer;
		}
		public function tick():void
		{
			AnimalController.instance.tick();
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
			configScene();
			
			uiLayer = new Sprite;
			gameLayer.addChild(uiLayer);
			
			dialogLayer = new Sprite();
			gameLayer.addChild(dialogLayer);
			DialogController.instance.setLayer(dialogLayer);
			
			effectLayer= new TweenEffectLayer();
			gameLayer.addChild(effectLayer);
			showLoading();
		}
		public function start():void
		{
			VoiceController.instance.init();
			
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
		public function LoginFarm():void
		{
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
			AnimalController.instance.reset();
			UpdateController.instance.checkMes();
			if(isNewer){
				TutorialController.instance.beginTutorial();
				isNewer =false;
			}
			setTimeout(hideLoading,1000);
		}
		
		private var loading:CloudLoadingScreen;
		public function showLoading():void
		{
			if(!loading){
				loading = new CloudLoadingScreen;
			}
			dialogLayer.addChild(loading);
		}
		
		public function hideLoading():void
		{
			if(loading ){
				var tween:Tween = new Tween(loading,2);
				tween.animate("alpha",0.1);
				tween.onComplete = function () :void{
					if(loading&&loading.parent){
						loading.parent.removeChild(loading);
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
		public function onKeyCancel():void
		{
			if(DialogController.instance.hasPanel){
				DialogController.instance.destroy();
			}else{
				DialogController.instance.showPanel(new ConfirmPanel(LanguageController.getInstance().getString("warnintLeave"),function():void{
					NativeApplication.nativeApplication.exit();
				},
					function():void{}));
			}
		}
		private function onVisitFriend():void
		{
			LoginFarm();
		}
		
		public function get isHomeModel():Boolean
		{
			return localPlayer == _curPlayer;
		}
		
	}
}