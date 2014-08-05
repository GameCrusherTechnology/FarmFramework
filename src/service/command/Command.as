package service.command
{
	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import view.panel.ConfirmPanel;
	import view.panel.WarnnigTipPanel;



	public class Command extends EventDispatcher
	{	
		public static const LOGIN:String  = "user/UserLoginCommand";
		public static const BUYITEM:String  = "shop/BuyItem";
		public static const BUYANIMAL:String  = "shop/BuyAnimalCommand";
		public static const CHANGENAME:String  = "user/ChangeName";
		public static const CHANGESEX:String  = "user/ChangeSex";
		public static const VISITFRIEND:String = "user/UserVisitCommand";
		public static const GETACHIEVE:String = "user/GetAchieveReward";
		public static const LEAVEMESSAGE:String = "user/LeaveMessage";
		public static const UserSkill:String = "user/UserSkillCommand";
		public static const BuySkillCD:String = "user/BuySkillCommand";
		public static const UpgradeSkill:String = "user/UpgradeUserSkill";
		public static const SELLITEM:String = "user/UserSellItem";
		public static const CREATPERSON:String = "user/CreatPerson";
		//scene
		public static const UPDATEFAME:String  = "scene/SceneDataUpdate";
		public static const EXTENDFARM:String = "scene/ExtendFarm";
		public static const EXTENDFARMLAND:String = "scene/ExtendFarmLand";
		public static const SEARCHING:String = "scene/SearchingCommand";
		public static const CREATWEED:String = "scene/CreatweedCommand";
		public static const CREATRANCH:String = "scene/CreatRanchCommand";
		//friend
		public static const REFRESH_FRIENDS:String = "friend/RefreshFriends";
		public static const GETSTRANGERS:String = "friend/GetStrangers";
		public static const GETUSERINFO:String = "friend/GetFriendsInfo";
		public static const ACCEPTFRIEND:String = "friend/AcceptFriend";
		public static const REMOVEFRIEND:String = "friend/RemoveFriend";
		public static const INVITEFRIEND:String = "friend/InviteFriend";
		public static const HELPFRIEND:String = "friend/HelpFriend";
		//pet
		public static const CREATPET:String = "pet/CreatPet";
		public static const UPGRADEPETSKILL:String = "pet/UpgradePetSkill";
		public static const PETLOOKAFTER:String = "pet/PetLookAfter";
		//task
		public static const CREAT_TASK:String = "task/CreatTask";
		public static const FINISH_TASK:String = "task/FinishTask";
		public static const BUY_TASK:String = "task/BuyNpcTask";
		public static const FINISH_MYORDER:String = "task/FinishMyOrder";
		
		//factory
		public static const ADD_FORMULA:String = "factory/AddFormula";
		public static const HARVEST_FORMULA:String = "factory/HarvestFormulas";
		public static const EXPAND_FACTORY_TILE:String = "factory/ExpandFactory";
		public static const UNLOCK_FORMULA:String = "factory/OpenFormula";
		//pay
		public static const GOOGLEPAY:String = "pay/GooglePayForGems";
		public static const BUYCOINS:String = "pay/BuyCoin";
		public static const APPLEPAY:String = "pay/ApplePayForGems";
		
		public static const UPDATEACTIONS:String = "action/UpdateStaticsAction";
		public static const ACTIVATE:String = "action/ActivateAction";
		public static function get gateway():String
		{
			var url:String = Configrations.GATEWAY;
			return url;
		}

		[Encrypt(key="PElRjzY_IOhkwb8L")]
		public static function get key():String
		{
			return "Are you going to hack?";
		}
		static public function execute(cmd:String,callback:Function,p:Object=null):void
		{
			var params:Object = p;
			if(!params){
				params = new Object;
			}
			params["commandName"] = cmd;
			params["uid"] = GameController.instance.userID;
			if(GameController.instance.localPlayer){
				params["gameuid"] = GameController.instance.localPlayer.gameuid;
			}
			RemotingOperation.TIMEOUT = 30000;
			var operation:RemotingOperation = new RemotingOperation(gateway,callback,callback);
			operation.method = cmd;
			operation.params = params;
			
			operation.commit();
		}
		
		//后台返回解析方法
		static public function StringAnaly(array:Array,string:String):void
		{
			if(string)
			{
				var array1:Array= new Array();
	            array1 = string.split(",");
	            for(var i : int =0;i<array1.length;i++) 
                {   
           	        var array2:Array = new Array();
           	       	var st :String ;
           	      	st = String(array1[i]);
           	      	if(st){
           	      		array2 = st.split(":"); 
           	      		array[i] = [array2[0],array2[1]];   
                  	 }
                }
            }
		}

		/**
		 * 检查接口调用是否成功，若不成功则显示错误信息
		 */
		static public function isSuccess(obj:Object):Boolean
		{
			var bool:Boolean=checkSuccess(obj,true);
			return bool;
		}
		
		private static var _restartCount:int = 0;
		/**
		 * 只检查，不打印
		 */
		static private function checkSuccess(obj:Object,bSetAcivity:Boolean=false):Boolean
		{
			try{
				if(obj && obj.__code == 0){
					return true;
				}else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("systemTip02")));
					if(_restartCount <=1){
						GameController.instance.start();
						_restartCount++;
					}else{
						DialogController.instance.showPanel(new ConfirmPanel(LanguageController.getInstance().getString("systemTip01"),function():void{
							NativeApplication.nativeApplication.exit();
						},function():void{},false));
					}
				}
			}catch(e:Error){
				trace("command error");
			}
			return false;
		}
		
		static public function errorRefreh():void
		{
			
		}
		static public function timeOutHandler(code:String="",message:String=""):void
		{
		}
		
		
	}
}
