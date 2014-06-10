package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.SpecController;
	
	import gameconfig.Configrations;
	
	import model.OwnedItem;
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.AnimalItem;
	import model.entity.EntityItem;
	import model.gameSpec.ItemSpec;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class AnimalEntity extends GameEntity
	{
		private var houseEntity:RanchEntity;
		public function AnimalEntity(item:AnimalItem,_houseEntity:RanchEntity)
		{
			houseEntity = _houseEntity;
			houseEntity.addAnimal(this);
			super(item);
		}
		override protected function creatSurface():void
		{
			refresh();
		}
		override public function configPosition():void
		{
			var rX:Number;
			var rY:Number;
			var p:Point;
			if(houseEntity.animalPosArr){
				var lengh:int = houseEntity.animalPosArr.length;
				if(lengh>=1){
					p = houseEntity.animalPosArr.splice(int(Math.random()*lengh),1)[0];
				}
			}
			if(!p){
				var houseItem:EntityItem = houseEntity.item;
				var toptile:Tile = houseItem.tile;
				rX = toptile.x+1 + Math.random()*(houseItem.bound_x-2);
				rY = toptile.y+1 + Math.random()*(houseItem.bound_y-2);
			}else{
				rX = p.x;
				rY = p.y;
			}
			var pos:Point = Map.intance.iosToScene(rX,rY);
			x = pos.x;
			y = pos.y;
			
		}
		override protected function update():void
		{
			if(GameController.instance.isHomeModel ){
				if(curAnimotion == "Eat"||curAnimotion == "Stand"){
					if(animalItem.canHarvest){
						refresh();
					}else if((!hungryTip) && animalItem.canFeed){
						showHungry();
					}
				}else{
					if((!produceTip) && animalItem.canHarvest){
						showProduce();
					}
				}
			}
		}
		override protected function refresh():void
		{
			if(animalItem.canHarvest){
				if(!curAnimotion != "Produce"){
					playAnimation("Produce");
				}
				showProduce();
			}else{
				removeProduceTip();
				playAnimation(Math.random()>0.7?"Eat":"Stand");
			}
			if(animalItem.canFeed){
				showHungry();
			}else{
				removeHungryTip();
			}
		}
		
		public function harvest():void
		{
			animalItem.harvest();
			refresh();
			showHarvestAnimation();
			player.addExp(animalItem.animalSpec.exp);
			GameController.instance.localPlayer.addItem(new OwnedItem(Configrations.getAchieveId(animalItem.animalSpec.item_id,"harvestAnimal"),1));
			player.addItem(new OwnedItem(animalItem.animalSpec.produce,animalItem.animalSpec.pCount));
		}
		public function feed():void
		{
			animalItem.feed();
			refresh();
			showFeedAnimation();
			player.deleteItem(new OwnedItem(animalItem.animalSpec.feedId,1));
		}
		private function showHarvestAnimation():void
		{
			var texture:Texture;
			var count:int;
			var proSpec:ItemSpec = SpecController.instance.getItemSpec(animalItem.animalSpec.produce);
			texture = Game.assets.getTexture(proSpec.name+"Icon");
			count = animalItem.animalSpec.pCount;
			var index:int = 0;
			var stagePoint:Point ;
			while(index <count){
				stagePoint = scene.localToGlobal(new Point(x + Math.random()*50-25,y + Math.random()*50-25));
				stageEffectLayer.addTweenCrop(new Image(texture),stagePoint,0.1*index);
				
				index++;
			}
			stageEffectLayer.showExpAddEffect(animalItem.animalSpec.exp,scene.localToGlobal(new Point(x ,y -surface.height - 30)));
		}
		private function showFeedAnimation():void
		{
			var texture:Texture;
			var proSpec:ItemSpec = SpecController.instance.getItemSpec(animalItem.animalSpec.feedId);
			texture = Game.assets.getTexture(proSpec.name+"Icon");
			stageEffectLayer.showFeedEffect(new Image(texture),scene.localToGlobal(new Point(x ,y -surface.height - 30)));
		}
		
		override public function get sceneIndex():Number
		{
			return houseEntity.sceneIndex + (y-houseEntity.y)/100;
		}
		
		private var curAnimotion:String;
		private function playAnimation(_motion:String):void
		{
			if(curAnimotion!= _motion){
				curAnimotion = _motion;
				if(surface && surface.parent){
					surface.parent.removeChild(surface);
				}
				surface = new MovieClip(Game.assets.getTextures(animalItem.name+"/"+animalItem.name+_motion));
				addChild(surface);
				surface.x = - surface.width/2;
				surface.y = - surface.height;
				Starling.juggler.add(surface);
			}
		}
		
		private var hungryTip:Image;
		private function showHungry():void
		{
			if(GameController.instance.isHomeModel && scene && x>0 && y>0){
				if(!hungryTip){
					hungryTip = new Image(Game.assets.getTexture("AngryIcon"));
				}
				scene.effectLayer.addChild(hungryTip);
				hungryTip.x = x - surface.width/2-hungryTip.width/2;
				hungryTip.y = y - surface.height - hungryTip.height - 10;
			}
		}
		
		private var produceTip:Sprite;
		private function showProduce():void
		{
			if(GameController.instance.isHomeModel &&scene && x>0 && y>0){
				if(!produceTip){
					produceTip = new Sprite;
					var skin:Image = new Image(Game.assets.getTexture("toolBackSkin"));
					skin.width = 40;
					skin.height = 50;
					produceTip.addChild(skin);
					
					var spec:ItemSpec = SpecController.instance.getItemSpec(animalItem.animalSpec.produce);
					var icon:Image =  new Image(Game.assets.getTexture(spec.name + "Icon"));
					icon.width = 30;
					icon.height = 30;
					produceTip.addChild(icon);
					icon.x = 5;
					icon.y = 5;
				}
				scene.effectLayer.addChild(produceTip);
				produceTip.x = x - surface.width/2-produceTip.width/2;
				produceTip.y = y - surface.height - produceTip.height - 10;
			}
		}
		
		public function intoMove():void
		{
			visible = false;
			removeHungryTip();
			removeProduceTip();
		}
		public function outMove():void
		{
			configPosition();
			visible = true;
			refresh();
		}
		private function removeHungryTip():void
		{
			if(hungryTip && hungryTip.parent){
				hungryTip.parent.removeChild(hungryTip);
			}
		}
		private function removeProduceTip():void
		{
			if(produceTip && produceTip.parent){
				produceTip.parent.removeChild(produceTip);
			}
		}
		public function get animalItem():AnimalItem
		{
			return item as AnimalItem;
		}
		
	}
}