package view.render
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.gameSpec.AchieveItemSpec;
	import model.gameSpec.CropSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	import view.component.progressbar.GreenProgressBar;
	
	public class AchieveListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var itemid:String;
		public function AchieveListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				itemid = value.name;
				if(!container){
					configLayout();
				}
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			var spec:CropSpec = SpecController.instance.getItemSpec(itemid) as CropSpec;
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name +"Icon"));
			icon.width = icon.height = renderheight*0.8;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,30*scale,spec.name,0x000000,25,true);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = iconRight;
			nameText.y = icon.y ;
			
			var achieveId:String = String(int(itemid)+20000);
			var ownedItem:OwnedItem = player.getOwnedItem(achieveId);
			//test
			ownedItem.count += Math.floor(Math.random()*1500);
			var achieveSpec:AchieveItemSpec = SpecController.instance.getItemSpec(achieveId) as AchieveItemSpec;
			var acheveLevels :Array = achieveSpec.levels.split("|");
			var index :int = 0;
			var needcount:int ;
			var starIcon:Image;
			var rectRight:Number = renderwidth - 10*scale;
			while(index <acheveLevels.length){
				needcount += int(acheveLevels[index]);
				if(needcount <=ownedItem.count){
					index++;
					starIcon = new Image(Game.assets.getTexture("expIcon"));
					starIcon.width = starIcon.height = 30*scale;
					container.addChild(starIcon);
					starIcon.x = rectRight - starIcon.width;
					starIcon.y = nameText.y;
					
					rectRight -= (starIcon.width +5*scale);
				}else{
					
					break;
				}
			}
			var progress:GreenProgressBar = new GreenProgressBar(renderwidth/2, renderheight/3,3,0xFFFF33,0x33FF33);
			container.addChild(progress);
			progress.x = iconRight;
			progress.y = renderheight/2;
			progress.comment = ownedItem.count+"/"+needcount;
			
			var rewardButton:Button = new Button();
			rewardButton.label = LanguageController.getInstance().getString("getReward");
			rewardButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			rewardButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			rewardButton.paddingLeft =rewardButton.paddingRight =  20;
			rewardButton.paddingTop =rewardButton.paddingBottom =  5;
			container.addChild(rewardButton);
			rewardButton.validate();
			rewardButton.x = renderwidth - rewardButton.width-10*scale;
			rewardButton.y =  renderheight/2;
			rewardButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
		}
		private function onTriggeredMale(e:Event):void
		{
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}


