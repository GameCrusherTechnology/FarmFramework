package model.player
{
	import controller.FriendInfoController;
	import controller.GameController;
	import controller.SpecController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import model.MessageData;
	import model.OwnedItem;
	import model.SkillData;
	import model.entity.AnimalItem;
	import model.entity.CropItem;
	import model.entity.EntityItem;
	import model.entity.PetItem;
	import model.gameSpec.AchieveItemSpec;
	import model.gameSpec.FormulaItemSpec;
	import model.gameSpec.ItemSpec;
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
		public function refresh(data:Object):void
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
		public var crop_extend:int;
		public var name:String = "happyFarmc";
		public var createtime:Number;
		public var updatetime:Number;
		
		public var coin:int = 500;
		public function addCoin(e:int):void
		{
			coin += e;
			UiController.instance.configCoinBar();
		}
		
		public var gem:int = 500;
		public function changeGem(change:int):void
		{
			gem+=change;
			UiController.instance.configGemBar();
		}
		
		public var exp:int = 500;
		public function addExp(e:int):void
		{
			var lastLevel:int = level;
			exp += e;
			if(GameController.instance.isHomeModel){
				var newlevel:int = level;
				if(newlevel > lastLevel){
					GameController.instance.levelUp();
				}
			}
			UiController.instance.configExpBar();
		}
		public function get level():int
		{
			return Configrations.expToGrade(exp);
		}
		
		public var love:int = 500;
		public function addLove(e:int):void
		{
			love += e;
			UiController.instance.configLoveBar();
		}
		
		public var title:String;
		// 0 - male 1--female
		public var sex:int=0;
		
		public var lastHelpedTime:int;
		public function get wholeSceneLength():int
		{
			return Configrations.INIT_Tile + extend*2;
		}
		
		public function get wholeFarmLand():int
		{
			return crop_extend *2 + 6;
		}
		
		public function get leftFarmLand():int
		{
			return (wholeFarmLand - cropItems.length);
		}
		
		public var cropItems:Array=[] ;
		
		public function addCropItem(cropItem:CropItem):void
		{
			cropItems.push(cropItem);
			dispatchEvent(new Event(PlayerChangeEvents.CROP_CHANGE));
		}
		public function removeEntityItem(item:EntityItem):void
		{
			var index:int=0;
			if(item is CropItem){
				for(index;index<cropItems.length;index++){
					if(cropItems[index].data_id == item.data_id){
						cropItems.splice(index,1);
						break;
					}
				}
			}else{
				for(index;index<decorationItems.length;index++){
					if(decorationItems[index].data_id == item.data_id){
						decorationItems.splice(index,1);
						break;
					}
				}
			}
		}
		
		public function set user_fields(data:Object):void
		{
			var field_obj:Object;
			var cropItem:CropItem;
			for each(field_obj in data){
				cropItem = new CropItem(field_obj);
				cropItems.push(cropItem);
			}
		}
		
		//deco
		public var decorationItems:Array = [];
		private function set user_deco(data:Object):void
		{
			var deco_obj:Object;
			var decoItem:EntityItem;
			for each(deco_obj in data){
				decoItem = new EntityItem(deco_obj);
				decorationItems.push(decoItem);
			}
		}
		public function addDecoration(item:EntityItem):void
		{
			decorationItems.push(item);
		}
		//animal
		public var animalItems:Array = [];
		
		public function addAnimal(item:AnimalItem):void
		{
			animalItems.push(item);
		}
		private function set user_animal(data:Object):void
		{
			var animal_obj:Object;
			var animalItem:AnimalItem;
			for each(animal_obj in data){
				animalItem = new AnimalItem(animal_obj);
				animalItems.push(animalItem);
			}
		}
		
		//pet
		public var petItems:Array=[];
		public function hasPet(itemid:String):Boolean
		{
			var petItem:PetItem;
			for each(petItem in petItems){
				if(itemid == petItem.item_id){
					return true;
				}
			}
			return false;
		}
		public function addPet(item:PetItem):void
		{
			petItems.push(item);
		}
		private function set user_pet(data:Object):void
		{
			var pet_obj:Object;
			var prtItem:PetItem;
			for each(pet_obj in data){
				prtItem = new PetItem(pet_obj);
				petItems.push(prtItem);
			}
		}
		
		public var userRanchItems:Array=[];
		private function set user_ranch(data:Object):void
		{
			var ranch_obj:Object;
			var entityItem:EntityItem;
			for each(ranch_obj in data){
				entityItem = new EntityItem(ranch_obj);
				userRanchItems.push(entityItem);
			}
		}
		
		public function addRanch(item:EntityItem):void
		{
			userRanchItems.push(item);
		}
		//skill
		public var skill_time:int;
		public var skillData:SkillData = new SkillData();
		public function get skillLevel():int
		{
			return skillData.skillLevel;
		}
		private function set skill(str:String):void
		{
			if(!str || str == "" ){
				str = "2|5";
			}
			skillData = new SkillData(str);
		}
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
//		public var order:TaskData;
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
		public function isFriend(id:String):Boolean
		{
			if(id == "1" ||id == "2"){
				return true;
			}
			for each(var uid:String in friends){
				if(uid == id){
					return true;	
				}
			}
			return false;
		}
		public function removeFriend(id:String):void
		{
			if(id == "1" ||id == "2"){
			}else if(friends.indexOf(id) >= 0){
				friends = friends.splice(friends.indexOf(id),1);
			}
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
				FriendInfoController.instance.addNewUser(simPlayer);
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
		
		public function getAchieveLevel(id:String):int
		{
			if(achieve){
				var achieveSpec:AchieveItemSpec = SpecController.instance.getItemSpec(id) as AchieveItemSpec;
				var index:int ;
				var achieveArr:Array = achieve.split("|");
				if(achieveSpec.type == "Crop"){
					index = (int(id)-30000);
					return int(achieveArr[0].charAt(index));
				}else if(achieveSpec.type == "Tree"){
					index = (int(id)-34000);
					if(achieveArr[1]){
						return int(achieveArr[1].charAt(index));
					}
				}else if(achieveSpec.type == "Animal"){
					index = (int(id)-35000);
					if(achieveArr[2]){
						return int(achieveArr[2].charAt(index));
					}
				}
				
			}else{
				return 0;
			}
			return 0;
		}
		
		
		private var actionVec:Vector.<OwnedItem> = new Vector.<OwnedItem>;
		
		public function getActionItem(itemid:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in actionVec)
			{
				if(ownedItem.itemid == itemid){
					return ownedItem;
				}
			}
			return new OwnedItem(itemid,0);
		}
		private function set user_actions(data:Object):void
		{
			var obj:Object;
			for each(obj in data){
				actionVec.push(new OwnedItem(obj.action_id,obj.count));
			}
		}
		
		public function addAction(actionId:String,count:int=1):Boolean
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in actionVec)
			{
				if(ownedItem.itemid == actionId){
					ownedItem.count += count;
					return true;
				}
			}
			ownedItemVec.push(new OwnedItem(actionId,count));
			return true;
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
		
		public function getSimplePlayer():SimplePlayer
		{
			return new SimplePlayer({"gameuid":gameuid,"sex":sex,"exp":exp,"achieve":achieve,"name":name,"title":title});
		}
		
		//factory
		
		public var workTime:int;
		public var workTimeIndex:int;
		public var factory_expand:int;
		public var formulas:String = "70001:70003:70005";
		public var ownedFormulas:String = "0";
		public var factory_speedUp:String;
		public function set user_factory(obj:Object):void
		{
			if(obj){
				workTime = obj.workTime;
				factory_expand = obj.expand;
				formulas = obj.formulas;
				factory_speedUp = obj.speedUp;
				workTimeIndex = obj.workTimeIndex;
				ownedFormulas = obj.other;
			}
		}
		public function addWorkingFormula(id:String):void
		{
			if(formulas){
				formulas = formulas+":"+id;
			}else{
				formulas = id;
			}
		}
		public function removeWorkingFormula(index:int):void
		{
			var arr:Array = formulas.split(":");
			arr.splice(index,1);
			formulas = arr.join(":");
		}
		public function isFinishFormula(itemSpec:FormulaItemSpec):Boolean
		{
			var requestS:String = itemSpec.material;
			var requestArr:Array = requestS.split("|");
			var reqSpec:ItemSpec;
			var requestId:String ;
			var requestNum:int ;
			var ownedItem:OwnedItem;
			for each(var str:String in requestArr){
				requestId = str.split(":")[0];
				requestNum = str.split(":")[1];
				ownedItem = getOwnedItem(requestId);
				if(ownedItem.count < requestNum){
					return false;
				}
			}
			return true;
		}
	}
}