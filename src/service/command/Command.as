package service.command
{
	import flash.events.EventDispatcher;
	
	import controller.GameController;
	
	import gameconfig.Configrations;



	public class Command extends EventDispatcher
	{	
		public static const LOGIN:String  = "user/UserLoginCommand";
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
           	      	st = array1[i] as String;
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
		
		/**
		 * 只检查，不打印
		 */
		static private function checkSuccess(obj:Object,bSetAcivity:Boolean=false):Boolean
		{
			try{
				if(obj.status == 1){
					return true;
				}
			}catch(e:Error){
				
			}
			return false;
		}
		
		
		static public function timeOutHandler(code:String="",message:String=""):void
		{
		}
		
		
	}
}
