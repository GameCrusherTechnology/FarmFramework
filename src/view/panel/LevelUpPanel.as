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
	
	import model.gameSpec.CropSpec;
	import model.gameSpec.ExtendSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class LevelUpPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		public function LevelUpPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.6;
			panelheight = panelwidth*0.6;
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("SuperPanelSkin"),new Rectangle(10,10,480,280)));
			addChild(skin);
			skin.width = panelwidth;
			skin.height = panelheight;
			skin.x = Configrations.ViewPortWidth*0.5 - panelwidth/2;
			skin.y = Configrations.ViewPortHeight*0.5 - panelheight/2;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,LanguageController.getInstance().getString("congratulation")+ " !!!",0x000000,40,true);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			skin.addChild(titleText);
			titleText.x = 0;
			titleText.y = 10*scale;
			
			var levelUpIcon:Image = new Image(Game.assets.getTexture("StarsIcon"));
			levelUpIcon.height = 80*scale;
			levelUpIcon.scaleX = levelUpIcon.scaleY;
			skin.addChild(levelUpIcon);
			levelUpIcon.x = skin.width/2 - levelUpIcon.width - 10*scale;
			levelUpIcon.y = titleText.y + titleText.height + 10*scale;
			
			var levelText:TextField = FieldController.createSingleLineDynamicField(panelwidth,levelUpIcon.height,LanguageController.getInstance().getString("level") +":"+ player.level,0x000000,40,true);
			levelText.autoSize = TextFieldAutoSize.HORIZONTAL;
			skin.addChild(levelText);
			levelText.x = skin.width/2 + 10*scale;
			levelText.y = levelUpIcon.y;
			
			var lockText:TextField = FieldController.createSingleLineDynamicField(panelwidth,200,LanguageController.getInstance().getString("unlock") +":" ,0x000000,30,true);
			lockText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			skin.addChild(lockText);
			lockText.y = levelUpIcon.y + levelUpIcon.height + 10*scale;
			
			var lockContainer:Sprite = configLockContainer();
			skin.addChild(lockContainer);
			lockContainer.x = panelwidth*0.5 - lockContainer.width/2;
			lockContainer.y = lockText.y + lockText.height + 10*scale;
			
			lockText.x = lockContainer.x;
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  10;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth*0.5 - button.width/2;
			button.y = skin.y +skin.height - button.height -10*scale;
			button.addEventListener(Event.TRIGGERED,onTriggered);
			
			
		}
		
		private function configLockContainer():Sprite
		{
			var container:Sprite = new Sprite;
			var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(10,10,44,44)));
			container.addChild(skin);
			
			var itemArr:Array = [];
			var itemSpec:ItemSpec;
			itemSpec = findLevelCrop();
			if(itemSpec){
				itemArr.push(itemSpec);
			}
			
			itemSpec = findExtend();
			if(itemSpec){
				itemArr.push(itemSpec);
			}
			
			var itemc:Sprite;
			var leftPoint:Number = 0;
			var lContainer:Sprite = new Sprite;
			for each(itemSpec in itemArr){
				itemc = configItem(itemSpec);
				lContainer.addChild(itemc);
				itemc.x = leftPoint;
				leftPoint  += (itemc.width+10*scale);
			}
			container.addChild(lContainer);
			skin.width = lContainer.width + 40*scale;
			lContainer.x = skin.width/2 - lContainer.width/2;
			lContainer.y = 10*scale;
			
			skin.height = lContainer.height + 20*scale;
			return container;
		}
		private function configItem(itemSpec:ItemSpec):Sprite
		{
			var itemContainer:Sprite = new Sprite;
			var icon:Image;
			if(itemSpec is CropSpec){
				icon = new Image(Game.assets.getTexture(itemSpec.name+"Icon"))
			}else if(itemSpec is ExtendSpec){
				var type:int = int(int(itemSpec.item_id)/1000);
				if(type == 40){
					icon = new Image(Game.assets.getTexture("extendIcon"));
				}else if(type == 41){
					icon = new Image(Game.assets.getTexture("plowIcon"));
				}else{
					icon = new Image(Game.assets.getTexture("BagIcon"));
				}
			}
			icon.width = icon.height = 60*scale;
			itemContainer.addChild(icon);
			return itemContainer;
		}
		private function findLevelCrop():ItemSpec
		{
			var cropSpecArr:Object = SpecController.instance.getGroup("Crop");
			var spec:CropSpec ;
			var level:int = player.level;
			for each(spec in cropSpecArr){
				if(spec.level==level){
					return spec;
				}
			}
			return null;
		}
		
		private function findExtend():ItemSpec
		{
			var extendSpecArr:Object = SpecController.instance.getGroup("Extend");
			var spec:ExtendSpec ;
			var level:int = player.level;
			for each(spec in extendSpecArr){
				if(spec.level==level){
					return spec;
				}
			}
			return null;
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		
		private function onTriggered(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
				dispose();
			}
		}
	}
}