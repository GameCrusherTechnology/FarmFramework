package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
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
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(container);
			container.width = panelwidth*0.9;
			container.height= panelheight*0.4;
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = panelSkin.y + panelheight*0.05;
			
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
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("buy");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			container.addChild(button);
			button.validate();
			button.x = panelwidth*0.9 - button.width;
			button.y =  panelheight*0.4 - button.height;
			button.addEventListener(TouchEvent.TOUCH,onTouchOut);
			
		}
		
		private function configFemalMesContainer():void
		{
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(container);
			container.width = panelwidth*0.9;
			container.height= panelheight*0.4;
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = panelSkin.y + panelheight*0.5;
			
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
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("buy");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			container.addChild(button);
			button.validate();
			button.x = panelwidth*0.9 - button.width;
			button.y =  panelheight*0.4 - button.height;
			button.addEventListener(Event.TRIGGERED,onTouchOut);
			
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
		private function onTouchOut(e:TouchEvent):void
		{
			close();
		}
		private function get task():TaskData
		{
			return GameController.instance.localPlayer.currentTask;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function close():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}


