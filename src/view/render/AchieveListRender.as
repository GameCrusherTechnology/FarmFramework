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
	
	import model.OwnedItem;
	import model.gameSpec.AchieveItemSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import service.command.user.GetAchieveReward;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.component.progressbar.GreenProgressBar;
	
	public class AchieveListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var achieveid:String;
		public function AchieveListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var spec:ItemSpec;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				achieveid = value.item_id;
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
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			var achieveSpec :AchieveItemSpec = SpecController.instance.getItemSpec(achieveid) as AchieveItemSpec;
			
			var iconId:String ;
			if(achieveSpec.type == "Crop"|| achieveSpec.type == "Tree"){
				iconId = String(int(achieveid)-20000);
			}else if(achieveSpec.type == "Animal"){
				iconId = String(int(achieveid)+ 45000);
			}
			spec = SpecController.instance.getItemSpec(iconId);
			
			var toolSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			toolSkin.width = toolSkin.height = renderheight*0.8;
			toolSkin.x = 10*scale;
			toolSkin.y = renderheight*0.1;
			container.addChild(toolSkin);
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name +"Icon"));
			icon.width = icon.height = renderheight*0.6;
			icon.x = toolSkin.x + renderheight*0.1;
			icon.y = renderheight*0.2;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth/2,renderheight/2,spec.cname,0xffffff,35,true);
			container.addChild(nameText);
			nameText.x = iconRight;
			nameText.y = 0 ;
			
			var ownedItem:OwnedItem = player.getOwnedItem(achieveid);
			var acheveLevels :Array = achieveSpec.levels.split("|");
			var achiveRewards:Array = achieveSpec.rewards.split("|");
			var index :int = 0;
			var starIcon:Image;
			var rectRight:Number = nameText.x+nameText.width;
			
			var curLevel:int = player.getAchieveLevel(achieveid);
			while(index <curLevel){
				index++;
				starIcon = new Image(Game.assets.getTexture("expIcon"));
				starIcon.width = starIcon.height = 30*scale;
				container.addChild(starIcon);
				starIcon.x = rectRight;
				starIcon.y = nameText.y + nameText.height/2 - starIcon.height/2;
				rectRight += (starIcon.width +5*scale);
			}
			
			var progress:GreenProgressBar = new GreenProgressBar(renderwidth/2, renderheight/3,3,0xFFFF33,0x33FF33);
			container.addChild(progress);
			progress.x = iconRight;
			progress.y = renderheight/2;
			
			if(curLevel >= acheveLevels.length){
				progress.comment = "Max "+ ownedItem.count;
				progress.progress = 1;
			}else{
				var needcount:int  = int(acheveLevels[curLevel]);
				progress.comment = ownedItem.count+"/"+needcount;
				progress.progress= ownedItem.count/needcount;
				var rewardCount:String = achiveRewards[curLevel];
				var rewardButton:Button = new Button();
				var gemicon:Image = new Image(Game.assets.getTexture("gemIcon"));
				gemicon.width = gemicon.height = 30*scale;
				rewardButton.defaultIcon = gemicon;
				rewardButton.label = "×"+rewardCount;
				rewardButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				rewardButton.paddingLeft =rewardButton.paddingRight =  20;
				rewardButton.paddingTop =rewardButton.paddingBottom =  5;
				container.addChild(rewardButton);
				rewardButton.validate();
				rewardButton.x = renderwidth - rewardButton.width-10*scale;
				rewardButton.y =  renderheight/2;
				if(needcount <=ownedItem.count){
					rewardButton.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
					rewardButton.addEventListener(Event.TRIGGERED,onTriggeredMale);
				}else{
					rewardButton.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin"));
				}
			}
		}
		private var isCommanding:Boolean;
		private function onTriggeredMale(e:Event):void
		{
			if(!isCommanding){
				isCommanding = true;
				new GetAchieveReward(achieveid,onGetSuccess);
			}
		}
		private function onGetSuccess():void
		{
			isCommanding = false;
			PlatForm.submitAchieve(spec.name,player.getAchieveLevel(achieveid));
			data = data;
			
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}


