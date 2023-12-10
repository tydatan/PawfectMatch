import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawfectmatch/blocs/swipe/swipe_bloc.dart';
import 'package:pawfectmatch/models/models.dart';
import 'package:pawfectmatch/widgets/choice_button.dart';

class DogsScreen extends StatelessWidget {
  static const String routeName = '/dogs';

  static Route route({required Dog dog}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => DogsScreen(dog: dog),
    );
  }

  final Dog dog;

  const DogsScreen({
    required this.dog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.9,
            child: Stack(
              children: [
                Hero(
                  tag: 'dog_image',
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: NetworkImage(dog.profilePicture),
                          fit: BoxFit.cover
                          ), 
                        ),
                      ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 60,
                    ),
                    child: BlocBuilder<SwipeBloc, SwipeState>(
                      builder: (context, state) {
                        if (state is SwipeLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is SwipeLoaded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<SwipeBloc>()..add(SwipeLeft(dogs: state.dogs[0]));
                                  Navigator.pop(context);
                                  print('Swiped Left');
                                },
                                child: ChoiceButton(
                                  width: 70,
                                  height: 70,
                                  size: 30,
                                  color: Colors.redAccent, 
                                  icon: Icons.clear_rounded
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.read<SwipeBloc>()..add(SwipeRight(dogs: state.dogs[0]));
                                  Navigator.pop(context);
                                  print('Swiped Right');
                                },
                                child: ChoiceButton(
                                  width: 70,
                                  height: 70,
                                  size: 30,
                                  color: Colors.greenAccent, 
                                  icon: Icons.favorite
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text('Something went wrong.');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                Text('${dog.name}, ${dog.calculateAge()}', 
                style:TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                      ),
                    ),
                Text('location', 
                style:TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal, 
                      color: Colors.black
                      ),
                    ),
                SizedBox(height: 15,),
                Text('Bio', 
                style:TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                      ),
                    ),
                Text('${dog.bio}', 
                style:TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal, 
                      color: Colors.black
                      ),
                    ),
                SizedBox(height: 10,),
                Text('Breed', 
                style:TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(
                        top:5.0,
                        right: 5.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(colors: [
                          Colors.blueGrey,
                          Colors.black,
                        ])),
                      child:Text('${dog.breed}',
                      style:TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal, 
                      color: Colors.white)
                    )
                ),
                SizedBox(height: 10,),
                Text('Vaccination Status', 
                style:TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(
                        top:5.0,
                        right: 5.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(colors: [
                          Colors.blueGrey,
                          Colors.black,
                        ])),
                      child:Text(
                      dog.isVaccinated ? 'Complete' : 'Incomplete',
                      style:TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal, 
                      color: Colors.white)
                    )
                ),
                SizedBox(height: 15,),
                Text('Medical Info', 
                style:TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                      ),
                    ),
                Text('Med ID: ${dog.medID}', 
                style:TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal, 
                      color: Colors.black
                      ),
                    ),
              ]
              ),
            )
        ],
      ),
    );
  }
}