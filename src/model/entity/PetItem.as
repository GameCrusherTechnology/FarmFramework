package model.entity
{
	import flash.text.ReturnKeyLabel;
	
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.PetSpec;

	public class PetItem extends EntityItem
	{
		public function PetItem(data:Object)
		{
			super(data);
		}
		
		public function get moveSpeed():int
		{
			return petSpec.moveSpeed;
		}
		private var _skillLevel:String;
		public function set skillLevel(s:String):void{
			_skillLevel = s;
			
			var skillArr:Array = _skillLevel.split("|");
			for each(var skillStr:String in skillArr){
				if("110002" == skillStr.split(":")[0]){
					if(skillStr.split(":")[1] >=1 ){
						Configrations.AD_BANNER = true;
					}
					break;
				}
			}
		}
		public function get skillLevel():String{
			return _skillLevel;
		}
		
		public function getSkillLevel(skillId:String):int
		{
			if(!skillLevel){
				skillLevel = petSpec.skills;
			}
			var skillArr:Array = skillLevel.split("|");
			for each(var skillStr:String in skillArr){
				if(skillId == skillStr.split(":")[0]){
					return skillStr.split(":")[1];
				}
			}
			return 0;
		}
		
		public function get petSpec():PetSpec
		{
			return itemspec as PetSpec;
		}
		
		public function getActions():Array
		{
			return petSpec.randomActions.split("|");
		}
		public function hasMoreDirection():Boolean
		{
			return item_id == "100000" || item_id == "100001";
		}
		public var refillTime:int;
		
		public function getRefillLookAfterTime():int
		{
			var arr:Array = [35,30,25,20,15,10,8,6,4];
			return arr[getSkillLevel("110003")]*60;
		}
		public function get isHome():Boolean
		{
			return gameuid == GameController.instance.currentPlayer.gameuid;
		}
	}
}