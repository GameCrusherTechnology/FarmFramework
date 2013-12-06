package model.player
{
	import controller.FriendInfoController;
	
	import gameconfig.Configrations;
	
	import model.MessageData;
	import model.OwnedItem;
	import model.entity.CropItem;
	import model.task.TaskData;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	
	public class GamePlayer extends EventDispatcher
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
		public var name:String = "happyFarmc";
		public var createtime:Number;
		public var updatetime:Number;
		
		public var coin:int = 500;
		public function addCoin(e:int):void
		{
			coin += e;
			dispatchEvent(new Event(PlayerChangeEvents.COIN_CHANGE));
		}
		
		public var gem:int = 500;
		public function changeGem(change:int):void
		{
			gem+=change;
			dispatchEvent(new Event(PlayerChangeEvents.GEM_CHANGE));
		}
		
		public var exp:int = 500;
		public function addExp(e:int):void
		{
			exp += e;
			dispatchEvent(new Event(PlayerChangeEvents.EXP_CHANGE));
		}
		public function get level():int
		{
			return Configrations.expToGrade(exp);
		}
		
		public var love:int = 500;
		public function addLove(e:int):void
		{
			love += e;
			dispatchEvent(new Event(PlayerChangeEvents.LOVE_CHANGE));
		}
		
		public var title:String;
		// 0 - male 1--female
		public var sex:int=0;
		public function get wholeSceneLength():int
		{
			return Configrations.INIT_Tile + extend;
		}
		
		public var cropItems:Array  ;
		
		public function get user_fields():Object
		{
			return null;
		}
		public function set user_fields(data:Object):void
		{
			var field_obj:Object;
			var cropItem:CropItem;
			cropItems = [];
			for each(field_obj in data){
				cropItem = new CropItem(field_obj);
				cropItems.push(cropItem);
			}
			
		}
		
		//skill
		public var skillTime:Number;
		public var creatOrderTime:Number = 1384332068;
		public var ownedItemVec:Vector.<OwnedItem> = new Vector.<OwnedItem>;
		
		public function set items(data:Object):void
		{
			var obj:Object;
			var ownItem:OwnedItem;
			for each(obj in data){
				ownItem = new OwnedItem(obj.item_id,obj.count);
				ownedItemVec.push(ownItem);
			}
		}
		public function getOwnedItem(itemid:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedItemVec)
			{
				if(ownedItem.itemid == itemid){
					return ownedItem;
				}
			}
			return new OwnedItem(itemid,0);
		}
		//添加 物品
		public function addItem(newItem:OwnedItem):Boolean
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedItemVec)
			{
				if(ownedItem.itemid == newItem.itemid){
					ownedItem.count += newItem.count;
					dispatchEvent(new Event(PlayerChangeEvents.ITEM_CHANGE));
					return true;
				}
			}
			ownedItemVec.push(newItem);
			return true;
		}
		//减少物品
		
		public function deleteItem(newItem:OwnedItem):Boolean
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedItemVec)
			{
				if(ownedItem.itemid == newItem.itemid){
					ownedItem.count -= newItem.count;
					dispatchEvent(new Event(PlayerChangeEvents.ITEM_CHANGE));
					return true;
				}
			}
			return false;
		}
		public function hasItem(id:String):Boolean
		{
			var item:OwnedItem = getOwnedItem(id);
			if(item.count > 0){
				return true;
			}else{
				return false;
			}
		}
		public var order:TaskData;
		//		public var order:TaskData = new TaskData({requstStr:"10001:20|10002:30",rewards:"",creatTime:1382454068});
		
		public function set user_friend(friendstr:String):void
		{
			if(friendstr){
				friends = friendstr.split(",");
				var uid:String;
				for each(uid in friends){
					FriendInfoController.instance.checkUser(uid);
				}
			}
		}
		public var friends:Array = [];
		public function addFriends(uid:String):void
		{
			friends.push(uid);
		}
		private function isFriend(id:String):Boolean
		{
			for each(var uid:String in friends){
				if(uid == id){
					return true;	
				}
			}
			return false;
			
		}
		public var strangers:Vector.<SimplePlayer> =  new Vector.<SimplePlayer>;
		public function addStrangers(arr:Array):void
		{
			var object:Object;
			var lastL:int = strangers.length;
			var simPlayer:SimplePlayer;
			for each(object in arr){
				simPlayer = new SimplePlayer(object);
				var bool:Boolean = isFriend(simPlayer.gameuid);
				if(!bool){
					strangers.push(simPlayer);
				}
			}
			
			if(strangers.length > 5){
				strangers = strangers.splice(strangers.length - 5,5);
			}
			
		}
		
		//任务
		public var npc_order:TaskData;
		public var my_order:TaskData;
		public var npc_time:int;
		public var buy_task_count:int;
		public function set user_task(data:Object):void
		{
			if(data){
				if(data.npc_order){
					npc_order = new TaskData(data.npc_order);
				}
				if(data.my_order){
					my_order = new TaskData(data.my_order);
				}
				if(data.npc_time){
					npc_time = data.npc_time;
				}
				if(data.buy_count){
					buy_task_count = data.buy_count;
				}
			}
		}
		
		//成就
		public var achieve:String;
		public function addAchieveLevel(id:String):int
		{
			if(achieve){
				var index:int = (int(id)-30000);
				return int(achieve.charAt(index));
			}else{
				return 0;
			}
			return 0;
		}
		
		public function getAchieveLevel(id:String):int
		{
			if(achieve){
				var index:int = (int(id)-30000);
				return int(achieve.charAt(index));
			}else{
				return 0;
			}
			return 0;
		}
		private function set user_actions(data:Object):void
		{
			var obj:Object;
			for each(obj in data){
				ownedItemVec.push(new OwnedItem(obj.action_id,obj.count));
			}
		}
		
		//message
		public var user_mes_vec:Vector.<MessageData>=new Vector.<MessageData>;
		private function set user_message(data:Object):void
		{
			var obj:Object;
			var mesd:MessageData;
			for each(obj in data){
				mesd = new MessageData(obj);
				user_mes_vec.push(mesd);
				cur_mes_dataid = Math.max(mesd.data_id,cur_mes_dataid);
			}
		}
		public var cur_mes_dataid:int;
		public function addMessage(data:MessageData):void
		{
			user_mes_vec.push(data);
			cur_mes_dataid = Math.max(data.data_id,cur_mes_dataid);
			dispatchEvent(new Event(PlayerChangeEvents.MESSAGE_CHANGE));
		}
		
		public function delMessage(data:MessageData):void
		{
			var index:int = 0
			for(index;index<user_mes_vec.length;index++){
				if(user_mes_vec[index].data_id == data.data_id && user_mes_vec[index].gameuid == data.gameuid){
					user_mes_vec.splice(index,1);
					dispatchEvent(new Event(PlayerChangeEvents.MESSAGE_CHANGE));
					break;
				}
			}
		}
		
	}
}