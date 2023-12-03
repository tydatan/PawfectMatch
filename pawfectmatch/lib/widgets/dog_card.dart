import 'package:flutter/material.dart';

import '../models/dog_model.dart';

class DogCard extends StatelessWidget{
  final Dog dog;

  const DogCard({Key? key,
  required this.dog,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10, left:20, right: 20, bottom: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height/1.4,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(dog.imageUrl)
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 8,
                offset: Offset(3,3),
                )
              ]
              ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(colors: [
                Color.fromARGB(200, 0, 0, 0),
                Color.fromARGB(0, 0, 0, 0)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              )
              ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dog.name}, ${dog.age}', 
                      style: TextStyle(
                                fontSize: 35.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, 
                                color: Colors.white
                              ),
                            ),
                          ],),
              )
        ],)
      ),
    );
  }
}