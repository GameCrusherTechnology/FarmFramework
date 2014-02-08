package controller
{
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	
	import view.FarmScene;
	import view.entity.AnimalEntity;
	import view.entity.CropEntity;
	import view.entity.GameEntity;
	import view.entity.animal.BeaEntity;
	import view.entity.animal.BirdEntity;

	public class AnimalController
	{
		private var beaRate:Number = 0.2;
		private var birdRate:Number = 0.01;
		private var lastAddTime:int = 0;
		private var creatCD:int = 1;
		private static var _controller:AnimalController;
		private var beaVec:Vector.<BeaEntity>;
		private var birdVec:Vector.<BirdEntity>;
		public static function get instance():AnimalController
		{
			if(!_controller){
				_controller = new AnimalController();
			}
			return _controller;
		}
		public function AnimalController()
		{
			
		}
		public function reset():void
		{
			beaVec = new Vector.<BeaEntity>;
			birdVec = new Vector.<BirdEntity>;
		}
		
		private function addBea():void
		{
			if(player.cropItems.length /2 >beaVec.length){
				var crop :CropEntity = getBeaCrop();
				if(crop){
					var bea:BeaEntity = new BeaEntity(crop);
					scene.addAnimalEntity(bea);
					beaVec.push(bea);
				}
			}
		}
		
		private function addBird():void
		{
			if(birdVec.length <= player.level){
				var bird:BirdEntity = new BirdEntity();
				scene.addAnimalEntity(bird);
				birdVec.push(bird);
			}
		}
		
		public function tick():void
		{
			if(SystemDate.systemTimeS - lastAddTime > creatCD){
				if(scene){
					if(Math.random()>beaRate){
						addBea();
					}
					if(Math.random()>birdRate){
						addBird();
					}
				}
				lastAddTime = SystemDate.systemTimeS ;
			}
		}
		
		
		public function getBeaCrop():CropEntity
		{
			var crop:CropEntity;
			var entity:GameEntity;
			var cropsArr:Array = [];
			for each(entity in scene.entityDic){
				if(entity is CropEntity && (entity as CropEntity).cropItem.growStep > 2){
					cropsArr.push(entity);
				}
			}
			if(cropsArr.length >=1){
				var ran:int = Math.floor(cropsArr.length*Math.random());
				crop = cropsArr[ran];
			}
			
			return crop;
		}
		
		private function get scene():FarmScene
		{
			return GameController.instance.currentFarm;
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
		public function removeAnimal(entity:AnimalEntity):void
		{
			if( entity is BeaEntity && beaVec.indexOf(entity as BeaEntity)>=1){
				beaVec.splice(beaVec.indexOf(entity as BeaEntity),1);
			}
			if(entity is BirdEntity && birdVec.indexOf(entity as BirdEntity)>=1){
				birdVec.splice(birdVec.indexOf(entity as BirdEntity),1);
			}
		}
	}
}