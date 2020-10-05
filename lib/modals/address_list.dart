
class AddressList{
  final int id;
  final String userName;
  final String deliveryAddress;
  final String address;

  AddressList({this.id,this.userName,this.deliveryAddress,this.address});

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' : id,
      'UserName' : userName,
      'DeliveryAddress' : deliveryAddress,
      'Address' : address
    };
    return map;

  }


}