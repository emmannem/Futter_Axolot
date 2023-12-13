import 'package:flutter/material.dart';
import 'package:ui_one/features/auth/presentation/pages/model_page.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home";
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0; // Índice actual para la barra de navegación

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6739FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(currentIndex), // Contenido de la página
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(0xFF6739FF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Cuenta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Acerca de ',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index; // Cambia el índice al tocar un botón
          });
        },
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Hola , Selecciona alguno de Nuestros Servicios',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridViewButtons(),
            ),
          ],
        );
      // return GridViewButtons(); // Muestra la cuadrícula de botones
      // case 1:
      //   return Center(child: Text('Contenido del Formulario 2'));
      // case 2:
      //   return Center(child: Text('Contenido del Historial'));
      default:
        return const SizedBox.shrink();
    }
  }
}

class GridViewButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      children: <Widget>[
        CustomButton(
          icon: Icons.medical_services,
          label: 'Medical Insurance Premium Prediction',
          data: ModelPage.id,
        ),
        CustomButton(
            icon: Icons.emoji_emotions,
            label: 'Deep Learning',
            data: ModelPage.id),
        CustomButton(
          icon: Icons.history,
          label: 'Historial',
          data: HomeScreen.id,
        ),
        // CustomButton(icon: Icons.settings, label: 'Botón 4'),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String data;

  CustomButton({required this.icon, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Realiza una acción cuando se toca el botón
        print('Botón $label presionado');
        Navigator.pushNamed(context, data);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(45.0),
            decoration: BoxDecoration(
              color: Color(0xFF6739FF),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          Text(label),
        ],
      ),
    );
  }
}
