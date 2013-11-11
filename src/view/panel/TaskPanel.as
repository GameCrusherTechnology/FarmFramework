package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.gameSpec.CropSpec;
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class TaskPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var panelSkin:Scale9Image;
		private var button:Button;
		private var isTaskFinished:Boolean = true;
		public function TaskPanel()
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
			
			configMesContainer();
			configRequestContainer();
			configButton();
		}
		private function configMesContainer():void
		{
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(container);
			container.width = panelwidth*0.9;
			container.height= panelheight*0.2;
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = panelSkin.y + panelheight*0.05;
			
			var icon:Image = new Image(Game.assets.getTexture("maleIcon"));
			container.addChild(icon);
			icon.height = container.height *.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height *.1;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 20, 20)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width
			speechSkin.y = container.height *.1;
			
		}
		private function configRequestContainer():void
		{
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(container);
			container.width = panelwidth*0.9;
			container.height= panelheight*0.6;
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = panelSkin.y + panelheight*0.3;
			
			
			var str:String = LanguageController.getInstance().getString("task")+" "+LanguageController.getInstance().getString("request")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(container.width*0.8,panelheight*0.08,str,0x000000,35,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			container.addChild(textRequest);
			textRequest.x = container.width*0.1;
			
			
			var container1:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(container1);
			container1.width = panelwidth*0.8;
			container1.height= panelheight*0.45;
			container1.x = panelwidth *0.05;
			container1.y = panelheight*0.1;
			
			var requstArr:Array = ["10001:20","10002:20","10003:0"];
			var requeststr:String;
			var deep:Number = panelheight*0.01;
			for each(requeststr in requstArr)
			{
				var itemId:String = requeststr.split(":")[0];
				var count:int = requeststr.split(":")[1];
				var render:Sprite = creatRequstRender(itemId,count);
				container1.addChild(render);
				render.y = deep;
				deep+= panelheight*0.11;
			}
		}
		private function configButton():void
		{
			button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  panelSkin.y + panelheight*0.9;
			button.addEventListener(Event.TRIGGERED,onTriggered);
		}
		
		private function creatRequstRender(itemid:String,count:int):Sprite
		{
			var container:Sprite = new Sprite;
			var spec:CropSpec = SpecController.instance.getItemSpec(itemid,"Crop") as CropSpec;
			var icon:Image = new Image(Game.assets.getTexture(spec.name+"Icon"));
			container.addChild(icon);
			icon.width = icon.height = panelheight*0.1;
			icon.x = panelwidth*0.1;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.1,spec.name,0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.CENTER;
			container.addChild(nameText);
			nameText.x = icon.x + icon.width;
			
			
			var ownitem:OwnedItem = player.getOwnedItem(itemid);
			var bool:Boolean = (ownitem.count>=count) ;
			var color :uint = bool?0x00ff00:0xff0000;
			
			var ownText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.1,String(ownitem.count),color,35,true);
			ownText.autoSize = TextFieldAutoSize.HORIZONTAL;
			ownText.hAlign = HAlign.LEFT;
			ownText.vAlign = VAlign.CENTER;
			container.addChild(ownText);
			ownText.x = panelwidth*0.5;
			
			var requestText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.1," /"+String(count),0x000000,35,true);
			requestText.hAlign = HAlign.LEFT;
			requestText.vAlign = VAlign.CENTER;
			container.addChild(requestText);
			requestText.x = ownText.x +ownText.width;
			
			if(bool){
				var okIcon:Image = new Image(Game.assets.getTexture("okIcon"));
				container.addChild(okIcon);
				okIcon.width = okIcon.height = panelheight*0.08;
				okIcon.x  =  panelwidth*0.8 - okIcon.width;
			}
			
			isTaskFinished = (isTaskFinished && bool);
			
			return container;
		}
		
		private function onTriggered(e:Event):void
		{
			close();
		}
		private function onTouchOut():void
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