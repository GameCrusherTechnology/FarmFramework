package model.entity
{
	import controller.SpecController;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.gameSpec.CropSpec;

	public class CropItem extends EntityItem
	{
		public function CropItem(data:Object)
		{
			super(data);
			init();
		}
		public var output:int;
		protected function init():void
		{
			if(hasCrop){
				checkStep();
			}
		}
		
		override public function get itemType():String
		{
			return "Crop";
		}
		public function get exp():int
		{
			if(cropItemSpec){
				return cropItemSpec.exp;
			}else{
				return 0;
			}
		}
		override public function update():Boolean
		{
			if(hasCrop && (growStep== -1 || growStep <  (cropItemSpec.growTimeArr.length))){
				if(checkStep()){
					return true;
				}
			}
			return false;
		}
		private function checkStep():Boolean
		{
			var leftTime:Number = SystemDate.systemTimeS - plant_time;
			var index:int = 0;
			while (index < cropItemSpec.growTimeArr.length){
				if(leftTime < cropItemSpec.growTimeArr[index]*60){
					break;
				}else{
					leftTime -= cropItemSpec.growTimeArr[index]*60;
				}
				index ++;
			}
			if(growStep != index){
				growStep = index;
				return true;
			}
			return false;
			
		}
		public function harvest():void
		{
			player.addItem(new OwnedItem(item_id,getOutput()));
			item_id = null;
			itemspec = null;
		}
		private function getOutput():int
		{
			return 2;
		}
		public function speed():void
		{
			plant_time -= Configrations.SPEED_TIME;
		}
		public function plant(id:String):void
		{
			player.deleteItem(new OwnedItem(id,1));
			item_id = id;
			itemspec = SpecController.instance.getItemSpec(item_id);
			growStep = -1;
			plant_time = SystemDate.systemTimeS;
		}
		public var plant_time:Number = 1382454068;
		public var growStep:int = 0;
		
		public function get remainTime():Number
		{
			return cropItemSpec.totleGrowTime - (SystemDate.systemTimeS - plant_time);
		}
		public function get canHarvest():Boolean
		{
			return (growStep == cropItemSpec.growTimeArr.length);
		}
		public function get hasCrop():Boolean
		{
			return (item_id !=null && int(item_id) !=0);
		}
		protected function get cropItemSpec():CropSpec
		{
			return itemspec as CropSpec;
		}
		public function get canSpeed():Boolean
		{
			return (hasCrop && !canHarvest);
		}
		override public function get bound_x():int
		{
			return 2;
		}
		
		override public function get bound_y():int
		{
			return 2;
		}
	}
}