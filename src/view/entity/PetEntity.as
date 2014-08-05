package view.entity
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import controller.GameController;
	import controller.SpecController;
	import controller.UiController;
	
	import gameconfig.SystemDate;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.PetItem;
	import model.gameSpec.ItemSpec;
	
	import service.command.pet.PetLookAfterCommand;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.TouchPhase;

	public class PetEntity extends GameEntity
	{
		
		private var curAction:String;
		private const PATROL:String = "patrol";
		private const SEARCH:String = "search";
		private const DEFENCE:String = "defence";
		private const TAKEAWALK:String = "takeawalk";
		private const LOOKAFTER:String = "lookafter";
		public function PetEntity(pItem:PetItem)
		{
			super(pItem);
			
		}
		
		override protected function creatSurface():void
		{
			refresh();
		}
		private var curTile:Tile;
		override public function configPosition():void
		{
			var pos:Point
			if(petItem.isHome){
				curTile = Map.intance.getRandom();
				pos = Map.intance.iosToScene(curTile.x,curTile.y);
			}else{
				pos = Map.intance.getBottomPoint();
				curTile = Map.intance.sceneToCurIso(pos);
			}
			x = pos.x;
			y = pos.y;
			
		}
		override protected function update():void
		{
			refresh();
		}
		
		// 搜索
		public function petSearch():void
		{
			Starling.juggler.removeTweens(this);
			playAnimation("Search");
			setTimeout(petTakeAWalk,5000);
			curAction =SEARCH;
		}
		
		//防卫
		public function petDefence(p:Point):void
		{
			Starling.juggler.removeTweens(this);
			move(p,onDefenceGet);
			curAction =DEFENCE;
		}
		private function onDefenceGet():void
		{
			
		}
		
		//被咬
		public function playBeBite():void
		{
			showHungry();
			Starling.juggler.remove(moveTween);
			
		}
		//照顾动物
		private var lookAfterPoints:Array= [];
		private var lookAfterIndex:int;
		public function lookAfterAnimal():void
		{
			var entityDic:Vector.<GameEntity> = scene.entityDic;
			var entity:GameEntity
			if(GameController.instance.isHomeModel &&((SystemDate.systemTimeS - petItem.refillTime) > petItem.getRefillLookAfterTime())){
				var animals:Array = [];
				var animal:AnimalEntity;
				for each(entity in entityDic){
					if(entity is AnimalEntity && (entity as AnimalEntity).animalItem.isGrowing){
						animals.push(entity);
					}
				}
				if(animals.length>=1){
					animal = animals[int(Math.random()*animals.length)];
					move(new Point(animal.x,animal.y),function():void{
						onReachAniaml();
						new PetLookAfterCommand(petItem.item_id,animal.animalItem.data_id,function(result:Object=null):void{
							if(result){
								petItem.refillTime = SystemDate.systemTimeS;
								animal.animalItem.speed();
							}else{
								petItem.refillTime = SystemDate.systemTimeS;
							}
							
							curAction = null;
						});
					});
					curAction =LOOKAFTER;
					return;
				}
			}
				
			if(lookAfterPoints.length == 0 || lookAfterIndex >=3){
				var ranchs:Array = [] ;
				for each(entity in entityDic){
					if(entity is RanchEntity || entity is HouseEntity){
						ranchs.push(entity);
					}
				}
				var ranch:GameEntity;
				if(ranchs.length>=1){
					ranch = ranchs[int(Math.random()*ranchs.length)];
				}
				if(ranch){
					lookAfterPoints = ranch.item.rectPos;
				}
				lookAfterIndex=0;
			}
			if(lookAfterPoints.length>=1){
				move(lookAfterPoints[lookAfterIndex],onGetRanch);
				lookAfterIndex++;
			}
			curAction =LOOKAFTER;
		}
		private function onGetRanch():void
		{
			playRandomAction();
			setTimeout(lookAfterAnimal,5000);
		}
		private function onReachAniaml():void
		{
			
		}
		//自由
		public function petTakeAWalk():void
		{
			move(Map.intance.iosToScene(Math.random()*player.wholeSceneLength,Math.random()*player.wholeSceneLength),onWalkGet);
			curAction =TAKEAWALK;
		}
		private function onWalkGet():void
		{
			playRandomAction();
			setTimeout(petTakeAWalk,10000);
		}
		
		//巡查
		private var patrolPoints:Array = [];
		private var patrolIndex:int = 0;
		public function playPatrol():void
		{
			if(patrolPoints.length ==0){
				patrolPoints = Map.intance.rectPoints;
			}
			move(patrolPoints[patrolIndex],onPatrolGet);
			patrolIndex++;
			if(patrolIndex>= patrolPoints.length){
				patrolIndex = 0;
			}
			curAction =PATROL;
		}
		private function onPatrolGet():void
		{
			playRandomAction();
			setTimeout(playPatrol,10000);
		}
		
		//s随即动作
		private function playRandomAction():void
		{
			var actions:Array = petItem.getActions();
			playAnimation(actions[int(actions.length*Math.random())]);
		}
		
		private var lastSortTime:int = 0;
		override protected function refresh():void
		{
			if(curTile){
				var tile:Tile = Map.intance.sceneToCurIso(new Point(x,y));
				if(tile && tile != curTile){
					if(getTimer() - lastSortTime >1000){
						scene.sortEntityLayerByMove(this);
						lastSortTime = getTimer();
					}
					curTile = tile;
				}
				
				if(!curAction){
					playInitAction();
				}
			}
		}
		private function playInitAction():void
		{
			switch(petItem.petSpec.item_id)
			{
				case "100000":
				{
					petTakeAWalk();
					break;
				}
					
				case "100001":
				{
					playPatrol();
					break;
				}
					
				case "100002":
				{
					lookAfterAnimal();
					break;
				}
					
				default:
				{
					petTakeAWalk();
					break;
				}
			}
		}
		
		private function move(p:Point,onReachedFunc:Function):void
		{
			var direction:String = getMoveDirection(p);
			
//			trace("direction : "+direction + "scale "+scale);
			playAnimation( direction);
			
			if(moveTween){
				Starling.juggler.remove(moveTween);
			}
			moveTween = new Tween(this,getMoveTime(p));
			moveTween.moveTo(p.x,p.y);
			iswalking = true;
			moveTween.onComplete = function():void{
				iswalking = false;
				onReachedFunc();
			};
			Starling.juggler.add(moveTween);
		}
		
		private function getMoveDirection(p:Point):String
		{
			var direction:String;
			var pn:Number = 20;
			var scale:Number;
			if(petItem.hasMoreDirection()){
				if(p.y >(y+pn)){
					if(p.x>(x+pn)){
						direction = "LDown";
						scale = -1;
					}else if(Math.abs(p.x - x)<=pn){
						direction="Down";
						scale = 1;
					}else{
						direction="LDown";
						scale = 1;
					}
				}else if(Math.abs(p.y - y)<= pn){
					if(p.x>(x+pn)){
						direction = "Left";
						scale = -1;
					}else if(Math.abs(p.x - x)<=pn){
						if(p.x > x){
							direction = "Left";
							scale = -1;
						}else{
							direction = "Left";
							scale = 1;
						}
					}else{
						direction="LDown";
						scale = 1;
					}
				}else{
					if(p.x>(x+pn)){
						direction = "LUp";
						scale = -1;
					}else if(Math.abs(p.x - x)<=pn){
						direction="Up";
						scale = 1;
					}else{
						direction="LUp";
						scale = 1;
					}
				}
			}else{
				if(p.y>y){
					if(p.x>x){
						direction = "LDown";
						scale = -1;
					}else{
						direction="LDown";
						scale = 1;
					}
				}else{
					if(p.x>x){
						direction = "LUp";
						scale = -1;
					}else{
						direction="LUp";
						scale = 1;
					}
				}
			}
			this.scaleX = scale;
			return direction;
		}
		private var iswalking:Boolean =false;
		private function getMoveTime(targetP:Point):Number
		{
			var l:Number =  Point.distance(targetP,new Point(x,y));
			return l/petItem.moveSpeed;
		}
		private var moveTween:Tween;
		private var curAnimotion:String;
		private function playAnimation(_motion:String):void
		{
			if(curAnimotion!= _motion){
				curAnimotion = _motion;
				if(surface && surface.parent){
					surface.parent.removeChild(surface);
				}
				surface = new MovieClip(Game.assets.getTextures(petItem.name+"/"+petItem.name+_motion));
				addChild(surface);
				surface.x = - surface.width/2;
				surface.y = - surface.height;
				Starling.juggler.add(surface);
			}
		}
		
		override public function get sceneIndex():Number
		{
			if(curTile){
				return (curTile.x+1/2+curTile.y+1/2)* 1000 + curTile.x;
			}else{
				return 10000000;
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
					
					var spec:ItemSpec = SpecController.instance.getItemSpec(petItem.animalSpec.produce);
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
		
		override public function doTouchEvent(type:String):void
		{
			var tool:String = GameController.instance.selectTool;
			if(type == TouchPhase.BEGAN ){
				if(GameController.instance.isHomeModel){
					if(tool == null){
						UiController.instance.showUiTools(UiController.TOOL_PET_INFO,this);
					}
				}else{
					
				}
			}
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
		public function get petItem():PetItem
		{
			return item as PetItem;
		}
		
	}
}