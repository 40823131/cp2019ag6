int i;
int start=1;
int end=10;
int sum;
  
void main() {
  sum = 0;
  for ( i = start; i <= end; i++) {
    //print('目前累加值為 $i');
    sum += i;
  }
  print("從 $start 累加至 $end 總數為 $sum");
}