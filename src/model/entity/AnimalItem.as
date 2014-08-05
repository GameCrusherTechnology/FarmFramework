package model.entity
{
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.gameSpec.AnimalItemSpec;

	public class AnimalItem extends EntityItem
	{
		public function AnimalItem(data:Object)
		{
			super(data);
		}
		
		override public function get cname():String
		{
			return itemspec? itemspec.cname : LanguageController.getInstance().getString("field");
		}
		
		override public function get itemType():String
		{
			return "Animal";
		}
		
		public var house_id:Number;
		public var feedTime:Number = 0;
		public function get canHarvest():Boolean
		{
			if(feedTime>0 && (SystemDate.systemTimeS - feedTime)>=lifeCycle){
				return true;
			}else{
				return false;
			}
		}
		public function get canFeed():Boolean
		{
			if(feedTime==0){
				return true;
			}else{
				return false;
			}
		}
		public function get isGrowing():Boolean
		{
			if(feedTime>0 && (SystemDate.systemTimeS - feedTime)<lifeCycle){
				return true;
			}else{
				return false;
			}
		}
		public function getLeftTime():Number
		{
			if(feedTime>0){
				return lifeCycle - (SystemDate.systemTimeS - feedTime);
			}else{
				return -1;
			}
		}
		public function harvest():void
		{
			feedTime = 0;
		}
		public function feed():void
		{
			feedTime = SystemDate.systemTimeS;
		}
		public function speed():void
		{
			feedTime = SystemDate.systemTimeS - lifeCycle;
		}
		private function get lifeCycle():Number
		{
			return (itemspec as AnimalItemSpec).life*60;
		}
		override public function get bound_x():int
		{
			return 0;
		}
		
		override public function get bound_y():int
		{
			return 0;
		}
		
	}
}


