package controller
{
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import view.component.UIButton.CommunicationButton;
	import view.component.UIButton.FriendButton;
	import view.component.UIButton.HelpButton;
	import view.component.UIButton.HomeButton;
	import view.component.UIButton.InviteButton;
	import view.component.UIButton.MenuButton;
	import view.component.UIButton.SkillButton;
	import view.component.UIButton.TaskButton;
	import view.component.UIButton.ToolStateButton;
	import view.component.UIButton.TreasureActivityButton;
	import view.component.progressbar.CoinProgressBar;
	import view.component.progressbar.ExpProgressBar;
	import view.component.progressbar.GemProgressBar;
	import view.component.progressbar.LoveProgressBar;
	import view.entity.GameEntity;
	import view.ui.EditToolsUI;
	import view.ui.FarmToolUI;
	import view.ui.FriendsList;

	public class UiController
	{
		public static const TOOL_HARVEST:String = "harvest";
		public static const TOOL_SEED:String = "seed";
		public static const TOOL_SPEED:String = "speed";
		public static const TOOL_ADDFEILD:String = "addFeild";
		public static const TOOL_MOVE:String = "move";
		public static const TOOL_EXTEND:String = "extend";
//		public static const TOOL_SELL:String = "sell";
		public static const TOOL_CANCEL:String = "cancel";
		public static const TOOL_SCOOP:String = "scoop";
		public static const TOOL_EXCAVATE:String = "excavate";
		public static const TOOL_RANCH_INFO:String = "ranchinfo";
		public static const TOOL_HARVEST_ANIMAL:String = "harvestanimal";
		public static const TOOL_FEED_ANIMAL:String = "feedanimal";
		private static var _controller:UiController;
		private var _layer:Sprite;
		private var taskButton:TaskButton;
		private var communicationButton:CommunicationButton;
		private var expBar:ExpProgressBar;
		private var coinBar:CoinProgressBar;
		private var gemBar:GemProgressBar;
		private var loveBar:LoveProgressBar;
		private var farmNameText:TextField;
		private var menuButton:MenuButton;
		private var scale:Number  = Configrations.ViewScale;;
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
		
		public function refresh(layer:Sprite):void
		{
			_layer = layer;
			
			configNameText();
			configExpBar();
			configCoinBar();
			configGemBar();
			configLoveBar();
			configIcons();
			if(GameController.instance.isHomeModel){
				showEditUiTools(false);
				showTaskButton();
				hideFriendList();
				hideHomeButton();
				showSkillButton();
				hideHelpBut();
				hideInviteBut();
				showFriendButton();
				showTreasureActivity();
			}else{
				hideEditUiTools();
				hideTaskButton();
				showHomeButton();
				showFriendList();
				hideSkillButton();
				showHelpBut();
				if(GameController.instance.localPlayer.isFriend(currentplayer.gameuid)){
					hideInviteBut();
				}else{
					showInviteBut();
				}
				hideFriendButton();
				hideTreasureActivity();
			}
			showCommunicationButton();
			hideToolStateButton();
			hideUiTools();
			
		}
		public function showCommunicationButton():void
		{
			if(!communicationButton){
				communicationButton = new CommunicationButton();
			}
			if(!communicationButton.parent){
				_layer.addChild(communicationButton);
			}
			communicationButton.x = 10;
			if(GameController.instance.isHomeModel){
				communicationButton.y = friendBut.y - communicationButton.height - 20*scale;
			}else{
				communicationButton.y = menuButton.y - communicationButton.height - 20*scale;
			}
		}
		private var skillBut:SkillButton;
		public function showSkillButton():void
		{
			if(!skillBut){
				skillBut = new SkillButton();
			}
			if(!skillBut.parent){
				_layer.addChild(skillBut);
			}
			skillBut.x = Configrations.ViewPortWidth - 70*scale;
			skillBut.y = _editToolsUI.y - skillBut.height - 10*scale;
		}
		public function hideSkillButton():void
		{
			if(skillBut && skillBut.parent){
				skillBut.parent.removeChild(skillBut);
			}
		}
		
		private var activityBut:TreasureActivityButton;
		private function showTreasureActivity():void
		{
			if(Configrations.treasuresActivity &&　Configrations.treasuresActivity){
				var activityTime:Number = Configrations.treasuresActivity.time;
				if(activityTime && (activityTime<SystemDate.systemTimeS)){
					
				}else{
					if(!activityBut){
						activityBut = new TreasureActivityButton();
					}
					if(!activityBut.parent){
						_layer.addChild(activityBut);
					}
					activityBut.x = 10;
					activityBut.y = taskButton.y + taskButton.height + 20*scale;
				}
			}
		}
		public function removeActivityBut():void
		{
			hideTreasureActivity();
		}
		private function hideTreasureActivity():void
		{
			if(activityBut && activityBut.parent){
				activityBut.parent.removeChild(activityBut);
			}
		}
		
		private var friendBut:FriendButton;
		public function showFriendButton():void
		{
			if(!friendBut){
				friendBut = new FriendButton();
			}
			if(!friendBut.parent){
				_layer.addChild(friendBut);
			}
			friendBut.x = 10;
			friendBut.y = menuButton.y - friendBut.height - 20*scale;
		}
		public function hideFriendButton():void
		{
			if(friendBut && friendBut.parent){
				friendBut.parent.removeChild(friendBut);
			}
		}
		
		public function showTaskButton():void
		{
			if(!taskButton){
				taskButton = new TaskButton();
			}
			if(!taskButton.parent){
				_layer.addChild(taskButton);
			}
			taskButton.refresh();
			taskButton.x = 10;
			taskButton.y = loveBar.y + loveBar.height + 10*scale;
		}
		
		public function hideTaskButton():void
		{
			if(taskButton && taskButton.parent){
				taskButton.parent.removeChild(taskButton);
			}
		}
		
		private var _editToolsUI:EditToolsUI;
		public function showEditUiTools(open:Boolean=false):void
		{
			hideUiTools();
			if(!_editToolsUI){
				_editToolsUI = new EditToolsUI();
			}
			if(!_editToolsUI.parent){
				_layer.addChild(_editToolsUI);
			}
			_editToolsUI.show(open);
			_editToolsUI.x = Configrations.ViewPortWidth- _editToolsUI.width;
			_editToolsUI.y = Configrations.ViewPortHeight - _editToolsUI.height;
			
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
			hideToolStateButton();
			_toolStateButton = new ToolStateButton();
			_layer.addChild(_toolStateButton);
			_toolStateButton.show(type,texture);
			_toolStateButton.x = Configrations.ViewPortWidth  - 10;
			_toolStateButton.y = Configrations.ViewPortHeight/2;
			_toolStateButton.alpha = 0.5;
			var tween:Tween = new Tween(_toolStateButton, 0.5);
			tween.animate("alpha",1);
			tween.onComplete = function():void{
				if(_toolStateButton){
					_toolStateButton.hideTip();
				}
			};
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
			if(_toolStateButton){
				_toolStateButton.destroy();
				_toolStateButton = null;
			}
		}
		
		
		private var _toolsUI:FarmToolUI;
		public function showUiTools(type:String,entity:GameEntity=null):void
		{
			hideFriendList();
			showEditUiTools();
			if(!_toolsUI){
				_toolsUI = new FarmToolUI();
			}
			if(!_toolsUI.parent){
				_layer.addChild(_toolsUI);
			}
			_toolsUI.show(type,entity);
			_toolsUI.x = Configrations.ViewPortWidth/2;
			_toolsUI.y = Configrations.ViewPortHeight +_toolsUI.height;
			
			var tween:Tween = new Tween(_toolsUI, 0.5);
			tween.moveTo(Configrations.ViewPortWidth/2, Configrations.ViewPortHeight -10*scale);                 
			Starling.juggler.add(tween);
		}
		public function hideUiTools():void
		{
			if(_toolsUI && _toolsUI.parent){
				_toolsUI.parent.removeChild(_toolsUI);
			}
		}
		
		private var _inviteBut:InviteButton;
		public function showInviteBut():void
		{
			if(!_inviteBut){
				_inviteBut = new InviteButton();
			}
			
			_layer.addChild(_inviteBut);
			
			_inviteBut.x = Configrations.ViewPortWidth - 70*scale;
			_inviteBut.y = Configrations.ViewPortHeight- _inviteBut.height -10 ;
		}
		public function hideInviteBut():void
		{
			if(_inviteBut && _inviteBut.parent){
				_inviteBut.parent.removeChild(_inviteBut);
			}
		}
		
		private var _helpBut:HelpButton;
		public function showHelpBut():void
		{
			if(!_helpBut){
				_helpBut = new HelpButton();
			}
			
			_layer.addChild(_helpBut);
			
			_helpBut.x = Configrations.ViewPortWidth - 70*scale;
			_helpBut.y = Configrations.ViewPortHeight/2;
		}
		public function hideHelpBut():void
		{
			if(_helpBut && _helpBut.parent){
				_helpBut.parent.removeChild(_helpBut);
			}
		}
		
		private var _friendList:FriendsList;
		public function resetFriendsBut():void{
			if(_friendList && _friendList.parent){
				hideFriendList();
			}else{
				showFriendList();
			}
		}
		public function showFriendList():void
		{
			hideUiTools();
			if(!_friendList){
				_friendList = new FriendsList();
			}
			_friendList.show(Configrations.ViewPortWidth -  (90*scale));
			
			if(!_friendList.parent){
				_friendList.x = 90*scale;
				_friendList.y = Configrations.ViewPortHeight +_friendList.height;
				_layer.addChild(_friendList);
				var tween:Tween = new Tween(_friendList, 0.5);
				tween.moveTo(90*scale, Configrations.ViewPortHeight -10*scale);                 
				Starling.juggler.add(tween);
			}
		}
		public function hideFriendList():void
		{
			if(_friendList && _friendList.parent){
				_friendList.parent.removeChild(_friendList);
			}
		}
		
		private var homeButton:HomeButton;
		public function showHomeButton():void
		{
			if(!homeButton){
				homeButton = new HomeButton();
			}
			if(!homeButton.parent){
				_layer.addChild(homeButton);
			}
			homeButton.x = 10;
			homeButton.y = Configrations.ViewPortHeight - homeButton.height -10 ;
			
		}
		public function hideHomeButton():void
		{
			if(homeButton && homeButton.parent){
				homeButton.parent.removeChild(homeButton);
			}
		}
		
		public function configNameText():void
		{
			if(!farmNameText){
				farmNameText = FieldController.createNoFontField(Configrations.ViewPortWidth *0.2,30*scale,currentplayer.name,0x000000,18);
				_layer.addChild(farmNameText);
				farmNameText.x = 0;
				farmNameText.y = 0;
			}else{
				farmNameText.text = currentplayer.name;
			}
		}
		private function configIcons():void
		{
			if(!menuButton){
				menuButton = new MenuButton();
				menuButton.x = 10;
				menuButton.y = Configrations.ViewPortHeight - menuButton.height -10 ;
			}
			
			if(!GameController.instance.isHomeModel){
				if(menuButton.parent){
					_layer.removeChild(menuButton);
				}
			}else{
				_layer.addChild(menuButton);
			}
		}
		
		public function configExpBar():void
		{
			if(!expBar){
				expBar = new ExpProgressBar();
				_layer.addChild(expBar);
				expBar.x = 30*scale;
				expBar.y = farmNameText.y + farmNameText.height + 5*scale;
			}else{
				expBar.refresh();
			}
			if(!GameController.instance.isHomeModel){
				if(expBar.parent){
					_layer.removeChild(expBar);
				}
			}else{
				_layer.addChild(expBar);
			}
		}
		public function configCoinBar():void
		{
			if(!coinBar){
				coinBar = new CoinProgressBar(Configrations.ViewPortWidth*.2, 30*Configrations.ViewScale);
				coinBar.x = Configrations.ViewPortWidth - coinBar.width;
				coinBar.y = expBar.y;
			}else{
				coinBar.refresh();
			}
			if(!GameController.instance.isHomeModel){
				if(coinBar.parent){
					_layer.removeChild(coinBar);
				}
			}else{
				_layer.addChild(coinBar);
			}
		}
		public function configGemBar():void
		{
			if(!gemBar){
				gemBar = new GemProgressBar();
				_layer.addChild(gemBar);
				gemBar.x = Configrations.ViewPortWidth - gemBar.width;
				gemBar.y = coinBar.y + coinBar.height;
			}else{
				gemBar.refresh();
			}
			
			if(!GameController.instance.isHomeModel){
				if(gemBar.parent){
					_layer.removeChild(gemBar);
				}
			}else{
				_layer.addChild(gemBar);
			}
		}
		public function configLoveBar():void
		{
			if(!loveBar){
				loveBar = new LoveProgressBar(Configrations.ViewPortWidth*.12, 30*Configrations.ViewScale);
				_layer.addChild(loveBar);
				loveBar.x = 30*scale;
				loveBar.y = expBar.y + expBar.height;
			}else{
				loveBar.refresh();
			}
			
			if(!GameController.instance.isHomeModel){
				if(loveBar.parent){
					_layer.removeChild(loveBar);
				}
			}else{
				_layer.addChild(loveBar);
			}
			
		}
		private function destroy():void
		{
			var displayObj:DisplayObject;
			while(_layer.numChildren>0){
				displayObj = _layer.getChildAt(0);
				displayObj.dispose();
				_layer.removeChild(displayObj);
			}
		}
		public function get UILayer():Sprite
		{
			return _layer;
		}
		private function get currentplayer():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}