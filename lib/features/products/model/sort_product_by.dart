import 'package:grocerymart/generated/l10n.dart';

enum SortProductBy
{
  newest('new'),
  oldest('old'),
  highToLow ('high-to-low'),
  lowToHigh('low-to-high');

 final String value ;

 const SortProductBy(this.value);


 String getMessage(){
   switch(this) {
     case SortProductBy.newest:
       return S.current.newest;

     case SortProductBy.oldest:
      return S.current.oldest;

     case SortProductBy.highToLow:
       return S.current.highToLow;

     case SortProductBy.lowToHigh:
       return S.current.lowToHigh;

   }


   }
}