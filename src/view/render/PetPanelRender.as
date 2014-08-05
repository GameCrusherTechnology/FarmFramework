package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.OwnedItem;
	import model.entity.PetItem;
	import model.gameSpec.PetSpec;
	import model.player.GamePlayer;
	
	import service.command.pet.CreatPetCommand;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.entity.GameEntity;
	import view.entity.PetEntity;
	import view.panel.BuyItemPanel;

	public class PetPanelRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function PetPanelRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var petEntity:PetEntity;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				petSpec =(value as PetSpec);
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				configLayout();
			}
		}
		
		private var renderW:Number ;
		private var renderH:Number;
		private var pscale:Number;
		
		private var petSpec:PetSpec;
		private function configLayout():void
		{
			renderW = width;
			renderH = height;
			pscale = Configrations.ViewScale;
			
			var entityDic:Vector.<GameEntity> = GameController.instance.currentFarm.entityDic;
			for each(var entity:GameEntity in entityDic){
				if(entity is PetEntity && entity.item.item_id == petSpec.item_id){
					petEntity = entity as PetEntity;
					break;
				}
			}
			container = new Sprite();
			addChild(container);
			
			configImageContainer();
			configSkill();
			configBuyButton();
		}
		
		private function configImageContainer():void
		{
			var containerskin:Sprite =  new Sprite();
			container.addChild(containerskin);
			
			containerskin.x  = renderW*0.05;
			containerskin.y  = renderH*0.05;
			
			var shape:Shape = new Shape();
			containerskin.addChild(shape);
			shape.graphics.beginTextureFill(Game.assets.getTexture("bgCell"));
			shape.graphics.drawRect(0,0,renderW*0.9,renderH*0.92);
			
			var fieldText:TextField = FieldController.createSingleLineDynamicField(renderW*0.9 ,100,petSpec.cname,0x000000,40,true);
			fieldText.autoSize = TextFieldAutoSize.VERTICAL;
			containerskin.addChild(fieldText);
			fieldText.x = 0;
			fieldText.y = 5*scale;
			
			var mc:MovieClip = new MovieClip(Game.assets.getTextures(petSpec.name+"/"+petSpec.name+"LDown"));
			containerskin.addChild(mc);
			Starling.juggler.add(mc);
			mc.x = renderW*0.15 - mc.width/2;
			mc.y = renderH*0.3- mc.height;
			
			var mc1:MovieClip = new MovieClip(Game.assets.getTextures(petSpec.name+"/"+petSpec.name+"Eat"));
			containerskin.addChild(mc1);
			Starling.juggler.add(mc1);
			mc1.x = renderW*0.45 - mc1.width/2;
			mc1.y = renderH*0.3- mc1.height;
			
			var mc2:MovieClip = new MovieClip(Game.assets.getTextures(petSpec.name+"/"+petSpec.name+"Stand"));
			containerskin.addChild(mc2);
			Starling.juggler.add(mc2);
			mc2.x = renderW*0.75 - mc2.width/2;
			mc2.y = renderH*0.3- mc2.height;
			
			
//			var mc:MovieClip = new MovieClip(Game.assets.getTextures(petSpec.name+"/"+petSpec.name+"Left"));
//			containerskin.addChild(mc);
//			Starling.juggler.add(mc);
//			
//			var mcW:Number = Math.min(renderW*0.4,mc.width*3);
//			var mcH:Number = Math.min(renderH*0.4,mc.height*3);
//			shape.graphics.beginTextureFill(Game.assets.getTexture("bgCell"));
//			shape.graphics.drawRect(renderW*0.2-mcW/2,renderH*0.2-mcH/2,mcW,mcH);
//			
//			mc.x = renderW*0.2 - mc.width/2;
//			mc.y = renderH*0.2- mc.height/2;
		}
		
		
		private var skillList:List;
		private function configSkill():void
		{
			const listLayout1:TiledRowsLayout = new TiledRowsLayout();
			listLayout1.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout1.useSquareTiles = false;
			listLayout1.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout1.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout1.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.manageVisibility = true;
			listLayout1.horizontalGap = renderW*0.02;
			
			skillList = new List();
			skillList.layout = listLayout1;
			var listC:ListCollection = getPanelCollection();
			skillList.dataProvider = listC;
			skillList.width = renderW;
			skillList.height = renderH *0.6;
			if(listC.length ==1){
				skillrenderwidth = renderW/3*2;
			}else{
				skillrenderwidth = renderW/3;
			}
			skillList.itemRendererFactory = panelListItemRendererFactory;
			container.addChild(skillList);
			skillList.y = renderH *0.35;
			skillList.validate();
		}
			
		private function configBuyButton():void
		{
			if(!player.hasPet(petSpec.item_id)){
				
				var buyButton:Button = new Button();
				buyButton.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
				buyButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				var icon:Image = new Image(Game.assets.getTexture("DogFoodIcon"));
				icon.width = icon.height = 50*pscale;
				buyButton.defaultIcon = icon;
				buyButton.label = "×" + petSpec.petCost;
				buyButton.paddingLeft = buyButton.paddingRight = 10*scale;
				buyButton.paddingTop = buyButton.paddingBottom = 5*scale;
				container.addChild(buyButton);
				buyButton.validate();
				buyButton.x = renderW*0.5 - buyButton.width/2;
				buyButton.y = renderH  - buyButton.height;
				buyButton.addEventListener(Event.TRIGGERED,onBuyTrigger);
				var text:TextField = FieldController.createSingleLineDynamicField(renderW,buyButton.height,LanguageController.getInstance().getString("buy")+" "+LanguageController.getInstance().getString("cost")+":",0x000000,40,true);
				text.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(text);
				text.x = buyButton.x - text.width-5*scale;
				text.y = buyButton.y;
			}
		}
		
		private function onBuyTrigger(e:Event):void
		{
			var item:OwnedItem = player.getOwnedItem("20002");
			if(item.count >= petSpec.petCost){
				new CreatPetCommand(petSpec.item_id,onCreatPetSuc);
			}else{
				DialogController.instance.showPanel(new BuyItemPanel("20002"));
			}
		}
		private function onCreatPetSuc(data:Object):void
		{
			if(data){
				var item:PetItem = new PetItem(data);
				GameController.instance.currentFarm.addPetEntity(item);
				player.addPet(item);
				player.deleteItem(new OwnedItem("20002",petSpec.petCost));
				DialogController.instance.destroy();
			}
		}
		private function getPanelCollection():ListCollection
		{
			var group:Array = petSpec.skills.split("|");
			var list:Array= [];
			for each(var str:String in group)
			{
				list.push({skill_id:str.split(":")[0],entity:petEntity});
			}
			return new ListCollection(list);
		}
		private function panellist_scrollHandler(e:Event):void
		{
			
		}
		protected function panelListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new PetSkillRender();
			renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			renderer.width = skillrenderwidth;
			renderer.height = renderH/2;
			return renderer;
		}
		private var skillrenderwidth:Number;
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}