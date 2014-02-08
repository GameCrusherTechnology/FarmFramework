package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.FriendInfoController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.SimplePlayer;
	
	import service.command.friend.RemoveFriendCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.panel.ConfirmPanel;

	public class FriendItemRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function FriendItemRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var playerData:SimplePlayer;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				
				playerData = FriendInfoController.instance.getUser(String(value));
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				configLayout();
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("talkSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var icon:Image= new Image(Game.assets.getTexture(playerData.headIconName));
			icon.height = renderheight*0.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 40*scale;
			container.addChild(expIcon);
			expIcon.x = iconRight;
			expIcon.y = icon.y ;
			
			var levelText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,40*scale,String(Configrations.expToGrade(playerData.exp)),0x000000,20,true);
			container.addChild(levelText);
			levelText.x = iconRight;
			levelText.y = icon.y ;
			
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth - iconRight,40*scale,playerData.name,0x000000,25);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = iconRight+expIcon.width+10*scale;
			nameText.y = icon.y ;
			
			var achIcon:Image = new Image(Game.assets.getTexture("achieveIcon"));
			achIcon.width = achIcon.height = 40*scale;
			container.addChild(achIcon);
			achIcon.x =  iconRight+expIcon.width+10*scale;
			achIcon.y = nameText.y + nameText.height;
			
			var totalP:int = Configrations.getTotalAchievePoint(playerData.achieve);
			var countText:TextField = FieldController.createSingleLineDynamicField(300,300,"×"+totalP,0x000000,25,true);
			countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			container.addChild(countText);
			countText.x = achIcon.x + achIcon.width + 10*scale;
			countText.y = achIcon.y + achIcon.height/2 - countText.height/2;
			
//			var mes:String;
//			if(playerData.title){
//				var titlesArr:Array = playerData.title.split("|");
//				mes = LanguageController.getInstance().getTitle(titlesArr[0],titlesArr[1]);
//			}else{
//				mes = LanguageController.getInstance().getString("noTitle");
//			}
//			
//			var titleText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,40*scale,mes,0x000000,35,true);
//			titleText.hAlign = HAlign.LEFT;
//			container.addChild(titleText);
//			titleText.x = iconRight;
//			titleText.y = nameText.y + nameText.height ;
			
			var visitButton:Button = new Button();
			visitButton.label = LanguageController.getInstance().getString("visit");
			visitButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			visitButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			visitButton.paddingLeft =visitButton.paddingRight =  20;
			visitButton.paddingTop =visitButton.paddingBottom =  5;
			container.addChild(visitButton);
			visitButton.validate();
			visitButton.x = renderwidth - visitButton.width-10*scale;
			visitButton.y =  renderheight/2;
			visitButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
			
			if(playerData.gameuid !="1" && playerData.gameuid!="2"){
				var removeButton:Button = new Button();
				removeButton.addEventListener(Event.TRIGGERED,onTriggeredRemove);
				removeButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
				removeButton.width = removeButton.height = 30*scale;
				container.addChild(removeButton);
				removeButton.validate();
				removeButton.x = renderwidth - removeButton.width-10*scale;
				removeButton.y =  renderheight*0.05 ;
			}
			
		}
		
		private function onTriggeredRemove(e:Event):void
		{
			DialogController.instance.showPanel(new ConfirmPanel(LanguageController.getInstance().getString("warnintTip04"),function():void{
				new RemoveFriendCommand(playerData.gameuid,onRemoved);
			},function():void{}));
		}
		private function onRemoved():void
		{
			GameController.instance.localPlayer.removeFriend(playerData.gameuid);
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function onTriggeredMale(e:Event):void
		{
			GameController.instance.visitFriend(playerData.gameuid);
		}
		
	}
}