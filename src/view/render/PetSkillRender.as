package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.gameSpec.PetSkillSpec;
	import model.player.GamePlayer;
	
	import service.command.pet.UpgradePetSkill;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.entity.PetEntity;
	import view.panel.BuyItemPanel;
	
	public class PetSkillRender extends DefaultListItemRenderer
	{
		private var pscale:Number;
		public function PetSkillRender()
		{
			super();
		}
		
		private var container:Sprite;
		private var petEntity:PetEntity;
		private var item_id:String;
		private var skillSpec:PetSkillSpec;
		private var renderW:Number ;
		private var renderH:Number;
		private var cost:int = 0;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				item_id =(value["skill_id"]);
				petEntity=value["entity"];
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
			renderW = width;
			renderH = height;
			pscale = Configrations.ViewScale;
			
			skillSpec = SpecController.instance.getItemSpec(item_id) as PetSkillSpec;
			
			container = new Sprite();
			addChild(container);
			
			var curLevel:int = 0;
			if(petEntity){
				curLevel = petEntity.petItem.getSkillLevel(item_id);
			}
			
			var fieldIcon:Image = new Image(Game.assets.getTexture(skillSpec.name + "Icon"));
			container.addChild(fieldIcon);
			fieldIcon.height = fieldIcon.width = 80*pscale;
			fieldIcon.x = renderW*0.25 - fieldIcon.width/2;
			fieldIcon.y =  10*pscale;
			
			var fieldText:TextField = FieldController.createSingleLineDynamicField(renderW*0.5 ,fieldIcon.height,LanguageController.getInstance().getString("level")+":"+curLevel,0x000000,30,true);
			container.addChild(fieldText);
			fieldText.x = renderW*0.5 ;
			fieldText.y = 10*pscale;
			
			
			var mesText:TextField = FieldController.createSingleLineDynamicField(renderW*0.8 ,renderH,LanguageController.getInstance().getString(skillSpec.name+"Detail") ,0x000000,25,true);
			mesText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(mesText);
			mesText.y = fieldIcon.y +fieldIcon.height+10*pscale ;
			mesText.x = renderW*0.1;
			
			if(petEntity){
				if(curLevel < skillSpec.maxLevel){
					var buyButton:Button = new Button();
					buyButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
					buyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 25, 0x000000);
					var icon:Image = new Image(Game.assets.getTexture("DogFoodIcon"));
					icon.width = icon.height = 40*pscale;
					buyButton.defaultIcon = icon;
					cost = skillSpec.upgradecost*(curLevel+1);
					buyButton.label = "×" + cost;
					buyButton.paddingLeft = buyButton.paddingRight = 10*pscale;
					buyButton.paddingTop = buyButton.paddingBottom = 5*pscale;
					container.addChild(buyButton);
					buyButton.validate();
					buyButton.x = renderW*0.5 - buyButton.width/2;
					buyButton.y = renderH  - buyButton.height;
					buyButton.addEventListener(Event.TRIGGERED,onBuyTrigger);
					
					var upgradeText:TextField = FieldController.createSingleLineDynamicField(200 ,buyButton.height,LanguageController.getInstance().getString("upgrade") ,0x000000,25,true);
					upgradeText.autoSize = TextFieldAutoSize.HORIZONTAL;
					container.addChild(upgradeText);
					upgradeText.y = buyButton.y ;
					upgradeText.x = buyButton.x - upgradeText.width;
					
				}
			}
			
		}
		private function refresh():void
		{
			if(container){
				container.dispose();
				if(container.parent){
					container.parent.removeChild(container);
				}
			}
			configLayout();
		}
		private function onBuyTrigger(e:Event):void
		{
			if(cost>0){
				var item:OwnedItem = player.getOwnedItem("20002");
				if(item.count >= cost){
					new UpgradePetSkill(petEntity.petItem.item_id,item_id,onUpgradePetSkill);
				}else{
					DialogController.instance.showPanel(new BuyItemPanel("20002"));
				}
			}
		}
		
		private function onUpgradePetSkill(skill:String):void
		{
			if(skill){
				player.deleteItem(new OwnedItem("20002",cost));
				petEntity.petItem.skillLevel = skill;
				refresh();
				if(item_id == "110002"){
					Configrations.AD_BANNER = true;
				}
			}
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}
