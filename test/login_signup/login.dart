import 'package:book_store/login_signup/login.dart';
import 'package:test/test.dart';
void main(){
  
  test("To check increment",(){
   var count=Login();
    count.increment();
    expect(count.x,1);
  });
  
}