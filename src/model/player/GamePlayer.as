package model.player
{
	import gameconfig.Configrations;
	
	import model.entity.CropItem;

	public class GamePlayer
	{
		public function GamePlayer(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GamePlayer: GamePlayer["+str+"]="+data[str]);
				}
			}
		}
		public var gameuid:String;
		public var extend:int;
		public var farmName:String = "happyFarmc";
		
		public var gems:int = 500;
		// 0 - male 1--female
		public var sex:int=0;
		public function get wholeSceneLength():int
		{
			return Configrations.INIT_Tile + extend;
		}
		
		public var cropItems:Array =[new CropItem({item_id:10001,ios_x:0,ios_y:0}),
				new CropItem({item_id:10002,ios_x:2,ios_y:2}),
				new CropItem({item_id:10003,ios_x:2,ios_y:4})
		];
		public function set cropdata(data:Object):void
		{
			cropItems = [];
			var item:CropItem;
			for each(var obj:Object in data){
				item = new CropItem(obj);
				cropItems.push(item);
			}
		}
	}
}