package model.entity
{
	import controller.SpecController;
	
	import gameconfig.SystemDate;
	
	import model.gameSpec.CropSpec;

	public class CropItem extends EntityItem
	{
		public function CropItem(data:Object)
		{
			super(data);
			init();
		}
		protected function init():void
		{
			plantTime = SystemDate.systemTimeS;
			checkStep();
		}
		
		override protected function get itemType():String
		{
			return "Crop";
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
			var leftTime:Number = SystemDate.systemTimeS - plantTime;
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
			item_id = null;
			itemspec = null;
		}
		
		public function speed():void
		{
			plantTime -= 30;
		}
		public function plant():void
		{
			item_id = "10001";
			itemspec = SpecController.instance.getItemSpec(item_id,itemType);
			growStep = -1;
			plantTime = SystemDate.systemTimeS;
		}
		private var plantTime:Number = 1382454068;
		public var growStep:int = 0;
		
		public function get remainTime():Number
		{
			return cropItemSpec.totleGrowTime - (SystemDate.systemTimeS - plantTime);
		}
		public function get canHarvest():Boolean
		{
			return (growStep == cropItemSpec.growTimeArr.length);
		}
		public function get hasCrop():Boolean
		{
			return (item_id !=null);
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