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
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import service.command.task.BuyTaskCommand;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
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
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"),new Rectangle(1,1,62,62));
			panelSkin = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight/2 - panelSkin.height/2;
			
			configTimeContainer();
			configMalMesContainer();
			configFemalMesContainer();
			configButton();
		}
		private function configTimeContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = Configrations.ViewPortWidth/2 - panelwidth*0.9/2;
			container.y = panelSkin.y + panelheight*0.05;
			
			var containerSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerSkin);
			containerSkin.width = panelwidth*0.9;
			containerSkin.height= panelheight*0.2;
			
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(speechSkin);
			speechSkin.width = panelwidth*0.86;
			speechSkin.height = panelheight*0.18;
			speechSkin.x = panelwidth*0.02;
			speechSkin.y = panelheight*0.01;
			
			
			var leftTimeText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.43,panelheight*0.18,LanguageController.getInstance().getString("nextTaskTime")+" ",0x000000,35,true);
			leftTimeText.hAlign = HAlign.RIGHT;
			container.addChild(leftTimeText);
			leftTimeText.x = panelwidth*0.02;
			leftTimeText.y = panelheight*0.01;
			
			
			var time :int = getLeftTime();
			var color :uint = (time >0)?0x00ff00:0xff0000;
			timeText = FieldController.createSingleLineDynamicField(panelwidth*0.43,panelheight*0.18,SystemDate.getTimeLeftString(time),color,35,true);
			timeText.hAlign = HAlign.LEFT;
			container.addChild(timeText);
			timeText.x = panelwidth*0.45;
			timeText.y = panelheight*0.01;
			if(time >0){
				timeText.addEventListener(Event.ENTER_FRAME,onTimeTick);
			}else{
				
			}
		}
		private var timeText:TextField;
		private function onTimeTick(e:Event):void
		{
			var time:int = getLeftTime();
			if(time >0){
				timeText.text = SystemDate.getTimeLeftString(getLeftTime());
			}else{
				
			}
		}
		private function getLeftTime():int
		{
			return Math.max(0,Configrations.ORDER_EXPIRED -( SystemDate.systemTimeS - player.npc_time));
		}
		private function configMalMesContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = Configrations.ViewPortWidth/2 - panelwidth*0.9/2;
			container.y = panelSkin.y + panelheight*0.6;
			
			var containerSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerSkin);
			containerSkin.width = panelwidth*0.9;
			containerSkin.height= panelheight*0.3;
			
			var icon:Image = new Image(Game.assets.getTexture("maleIcon"));
			container.addChild(icon);
			icon.height = container.height *.6;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height -icon.height;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 20, 20)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width
			speechSkin.y = container.height *.1;
			
	
			
			var left:Number = icon.x+icon.width + 30;
			var npcName:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left,40,"Tony :",0x000000,35,true);
			npcName.hAlign = HAlign.LEFT;
			container.addChild(npcName);
			npcName.x = left;
			npcName.y = container.height *.1 + 5;
			
			var npcTalkMes:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left-20*scale,100*scale,LanguageController.getInstance().getString("npctip02"),0x000000,25,true);
			npcTalkMes.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(npcTalkMes);
			npcTalkMes.x = left;
			npcTalkMes.y = npcName.y+npcName.height + 5;
			
			var buyMes:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left-20*scale,30*scale,LanguageController.getInstance().getString("buyTaskTip"),0x000000,25,true);
			container.addChild(buyMes);
			buyMes.x = left ;
			buyMes.y = panelheight*0.27 - buyMes.height;
			
			maleButton = new Button();
			maleButton.label = String(TaskController.instance.getTaskPrice());
			maleButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			maleButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			maleButton.paddingLeft =maleButton.paddingRight =  20;
			maleButton.paddingTop =maleButton.paddingBottom =  5;
			container.addChild(maleButton);
			maleButton.validate();
			maleButton.x = panelwidth*0.9 - maleButton.width;
			maleButton.y =  panelheight*0.3 - maleButton.height-20*scale;
			maleButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
			
			var gemIcon :Image = new Image(Game.assets.getTexture("gemIcon"));
			maleButton.addChild(gemIcon);
			gemIcon.width =gemIcon.height = maleButton.height*1.2;
			gemIcon.x = - gemIcon.width/2;
			gemIcon.y = - maleButton.height*0.1;
			
			
		}
		
		private function configFemalMesContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = Configrations.ViewPortWidth/2 - panelwidth*0.9/2;
			container.y = panelSkin.y + panelheight*0.27;
			
			var containerSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(containerSkin);
			containerSkin.width = panelwidth*0.9;
			containerSkin.height= panelheight*0.3;
			
			var icon:Image = new Image(Game.assets.getTexture("femaleIcon"));
			container.addChild(icon);
			icon.height = container.height *.6;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height -icon.height;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 20, 20)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width
			speechSkin.y = container.height *.1;
			
			
			var left:Number = icon.x+icon.width + 30;
			var npcName:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left,40,"Alice :",0x000000,35,true);
			npcName.hAlign = HAlign.LEFT;
			container.addChild(npcName);
			npcName.x = left;
			npcName.y = container.height *.1 + 5;
			
			var npcTalkMes:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left-20*scale,100,LanguageController.getInstance().getString("npctip01"),0x000000,25,true);
			npcTalkMes.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(npcTalkMes);
			npcTalkMes.x = left;
			npcTalkMes.y = npcName.y+npcName.height + 5;
			
			var buyMes:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.9 - left-20*scale,30*scale,LanguageController.getInstance().getString("buyTaskTip"),0x000000,25,true);
			container.addChild(buyMes);
			buyMes.x = left ;
			buyMes.y = panelheight*0.27 - buyMes.height;
			
			femaleButton = new Button();
			femaleButton.label = String(TaskController.instance.getTaskPrice());
			femaleButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			femaleButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			femaleButton.paddingLeft =femaleButton.paddingRight =  20;
			femaleButton.paddingTop =femaleButton.paddingBottom =  5;
			container.addChild(femaleButton);
			femaleButton.validate();
			femaleButton.x = panelwidth*0.9 - femaleButton.width;
			femaleButton.y =  panelheight*0.3 - femaleButton.height - 20*scale;
			femaleButton.addEventListener(Event.TRIGGERED,onTriggeredFemale);
			var gemIcon :Image = new Image(Game.assets.getTexture("gemIcon"));
			femaleButton.addChild(gemIcon);
			gemIcon.width =gemIcon.height = maleButton.height*1.2;
			gemIcon.x = - gemIcon.width/2;
			gemIcon.y = - maleButton.height*0.1;
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
			leavebutton.y =  panelSkin.y + panelheight*0.92;
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


