import 'package:book_store/login_signup/login.dart';
import 'package:test/test.dart';
void main(){
  
  test("To check increment",(){
    count=LoginSignUp();
    count.increment();
    expect(count.x,1);
  });
  
}