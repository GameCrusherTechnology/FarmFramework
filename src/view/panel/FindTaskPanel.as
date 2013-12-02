package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.TaskController;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import service.command.task.BuyTaskCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class FindTaskPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var panelSkin:Scale9Image;
		private var leavebutton:Button;
		private var isTaskFinished:Boolean = true;
		private var maleButton:Button;
		private var femaleButton:Button;
		public function FindTaskPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(Configrations.ViewPortWidth*0.86,2000);
			panelheight = Math.min(Configrations.ViewPortHeight*0.9,1500);
			scale = Configrations.ViewScale;
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"),new Rectangle(1,1,62,62));
			panelSkin = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight/2 - panelSkin.height/2;
			
			configMalMesContainer();
			configFemalMesContainer();
			configButton();
		}
		private function configMalMesContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = Configrations.ViewPortWidth/2 - panelwidth*0.9/2;
			container.y = panelSkin.y + panelheight*0.5;
			
			var containerSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerSkin);
			containerSkin.width = panelwidth*0.9;
			containerSkin.height= panelheight*0.4;
			
			var icon:Image = new Image(Game.assets.getTexture("maleIcon"));
			container.addChild(icon);
			icon.height = container.height *.6;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height *.1;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 20, 20)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width
			speechSkin.y = container.height *.1;
			
			var npcNameText:TextField = FieldController.createSingleLineDynamicField(icon.width,40,LanguageController.getInstance().getString("technician"),0x000000,25,true);
			container.addChild(npcNameText);
			npcNameText.x = icon.x;
			npcNameText.y = icon.y + icon.height +5;
			
			var left:Number = icon.x+icon.width + 30;
			var npcName:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left,40,"lilei :",0x000000,35,true);
			npcName.hAlign = HAlign.LEFT;
			container.addChild(npcName);
			npcName.x = left;
			npcName.y = container.height *.1 + 5;
			
			var npcTalkMes:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left,100,"xxxxxxxxxxxxxxxxxxxxxxxx",0x000000,25,true);
			npcTalkMes.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(npcTalkMes);
			npcTalkMes.x = left;
			npcTalkMes.y = npcName.y+npcName.height + 5;
			
			maleButton = new Button();
			maleButton.label = LanguageController.getInstance().getString("buy");
			maleButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			maleButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			maleButton.paddingLeft =maleButton.paddingRight =  20;
			maleButton.paddingTop =maleButton.paddingBottom =  5;
			container.addChild(maleButton);
			maleButton.validate();
			maleButton.x = panelwidth*0.9 - maleButton.width;
			maleButton.y =  panelheight*0.4 - maleButton.height;
			maleButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
			
		}
		
		private function configFemalMesContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = Configrations.ViewPortWidth/2 - panelwidth*0.9/2;
			container.y = panelSkin.y + panelheight*0.05;
			
			var containerSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerSkin);
			containerSkin.width = panelwidth*0.9;
			containerSkin.height= panelheight*0.4;
			
			var icon:Image = new Image(Game.assets.getTexture("femaleIcon"));
			container.addChild(icon);
			icon.height = container.height *.6;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height *.1;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 20, 20)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width
			speechSkin.y = container.height *.1;
			
			var npcNameText:TextField = FieldController.createSingleLineDynamicField(icon.width,40,LanguageController.getInstance().getString("shopkeeper"),0x000000,25,true);
			container.addChild(npcNameText);
			npcNameText.x = icon.x;
			npcNameText.y = icon.y + icon.height +5;
			
			var left:Number = icon.x+icon.width + 30;
			var npcName:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left,40,"hanmeimei :",0x000000,35,true);
			npcName.hAlign = HAlign.LEFT;
			container.addChild(npcName);
			npcName.x = left;
			npcName.y = container.height *.1 + 5;
			
			var npcTalkMes:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left,100,"xxxxxxxxxxxxxxxxxxxxxxxx",0x000000,25,true);
			npcTalkMes.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(npcTalkMes);
			npcTalkMes.x = left;
			npcTalkMes.y = npcName.y+npcName.height + 5;
			
			femaleButton = new Button();
			femaleButton.label = LanguageController.getInstance().getString("buy");
			femaleButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			femaleButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			femaleButton.paddingLeft =femaleButton.paddingRight =  20;
			femaleButton.paddingTop =femaleButton.paddingBottom =  5;
			container.addChild(femaleButton);
			femaleButton.validate();
			femaleButton.x = panelwidth*0.9 - femaleButton.width;
			femaleButton.y =  panelheight*0.4 - femaleButton.height;
			femaleButton.addEventListener(Event.TRIGGERED,onTriggeredFemale);
			
		}
		
		private function configButton():void
		{
			leavebutton = new Button();
			leavebutton.label = LanguageController.getInstance().getString("leave");
			leavebutton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			leavebutton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			leavebutton.paddingLeft =leavebutton.paddingRight =  20;
			leavebutton.paddingTop =leavebutton.paddingBottom =  5;
			addChild(leavebutton);
			leavebutton.validate();
			leavebutton.x = Configrations.ViewPortWidth/2 - leavebutton.width/2;
			leavebutton.y =  panelSkin.y + panelheight*0.9;
			leavebutton.addEventListener(Event.TRIGGERED,onTriggered);
		}
		
		
		private function onTriggered(e:Event):void
		{
			close();
		}
		private function onTriggeredMale(e:Event):void
		{
			new BuyTaskCommand(TaskController.instance.creatNpcTask(Configrations.NPC_MALE),onBuyTask);
		}
		private function onTriggeredFemale(e:Event):void
		{
			new BuyTaskCommand(TaskController.instance.creatNpcTask(Configrations.NPC_FEMALE),onBuyTask);
		}
		private function onBuyTask():void
		{
			if(GameController.instance.isHomeModel){
				UiController.instance.showTaskButton();
			}
			close();
		}
		private function get task():TaskData
		{
			return GameController.instance.localPlayer.npc_order;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function close():void
		{
			maleButton.removeEventListener(Event.TRIGGERED,onTriggeredFemale);
			femaleButton.removeEventListener(Event.TRIGGERED,onTriggeredFemale);
			leavebutton.removeEventListener(Event.TRIGGERED,onTriggered);
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}


