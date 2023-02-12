import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts' , style: TextStyle(color :Colors.blue,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios,color: Colors.deepPurple,),
      ),
      body:  Padding(
        padding:  EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.all(10.sp),
              width: 357.w,height: 80.h,
             decoration: BoxDecoration(
               border: Border.all(color: Colors.grey),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r)
              ),
                child:

                Row(
                  children: [

                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.person,color: Colors.deepPurple,size: 30,),
                    ),
                    SizedBox(width: 12.w,),

                    Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                         Text('Name',style: TextStyle(color: Colors.deepPurple,fontSize: 18),),
                         Text('Account Name',style: TextStyle(color: Colors.black,fontSize: 12),),
                      ],

                    )
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
