package
{
	import service.command.payment.VertifyGooglePayCommand;

	public class PlatForm
	{
		public function PlatForm()
		{
			
		}
		public static function FormBuyGems(id:String):void
		{
			var sData:String = JSON.stringify({
				'nonce':-4845357686530827055,
				'orders':[{
					'notificationId':'-64415316843466545457',
					'orderId':'129997631690547057581.13241776548960951',
					'packageName':'air.Farmland.andriod',
					'productId':'sunny_farm.littlefarmgem',
					'purchaseTime':1392002287294,
					'purchaseState':0,
					'purchaseToken':'anvtjlveifgtpmxvncnxjeua'
				}]
			},["nonce","orders","notificationId","orderId","packageName","productId","purchaseTime","purchaseState","purchaseToken"]);
			var object:Object = {
									'signedData':sData,
									'startId':3,
									'signature':'MlaguT03ZwiL0xRNfPwTb9ifhgp3VyMOBjk+9OK55algYgLIaf4PvTnt4HLsTqK8BiZIYhinZb4DWluI5M+9g2joOEg4j2gx9CkaVEzJ4QKMteJG7WN2nJaVLAbaFjP9cELAE34bjPihfRdRGUhcH3O5GiSUN/gwsZzQG9mZsq6ntKsBAuARAjeOTJcr9KLcQRKXhJQQRf0uvLoW2km724aNG+6ZAk9CqbQG2e9+ko3El2r6nUdslFF7eqDE1a8f6HxQKzWTauCwoMTIhgb52RP882l7e85a6HuFAbBHQcKOezTMEFE/7jvCvviONuuDPz0yXhjD5rGqtmM5rmeSIw=='
								};
			var signedData:String = JSON.stringify(object);
//			var receipt_obj:Object = JSON.parse( signedData);
			
			new VertifyGooglePayCommand({'receipt':object,"receiptStr":signedData,"buytype":"localTest"},function():void{},function():void
			{
				//											InAppPurchase.getInstance().removePurchaseFromQueue(lastProId,_verifyPayStr);
				//											_verifyPayStr = null;
			});
			
		}
		//score
		public static function submitScore(score:int):void
		{
			trace("no score");
		}
		
		//achieve
		
		public static function submitAchieve(achieve:String,process:int):void
		{
			trace("no achieve");
		}
		
	}	
}