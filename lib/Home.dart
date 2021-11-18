import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //late List<Map<String, dynamic>> _listaTarefas;
  TextEditingController _tarefaController = TextEditingController();
  var _listaTarefas = <dynamic>[];

  Map<String, dynamic> _tarefa(String novaTarefa, bool status) {
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = novaTarefa;
    tarefa["realizada"] = status;
    return tarefa;
  }

  _getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return ("${dir.path}/dados.json");
  }

  _salvarTarefa() async {
    String novaTarefa = _tarefaController.text;
    var tarefa = _tarefa(novaTarefa, true);

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _tarefaController.text = "";
    _salvarArquivo();
  }

  _salvarArquivo() async {
    //_listaTarefas.add(_tarefa("Ir ao mercarodo", false));

    var caminho = await _getPath();
    print(caminho);

    String dados = json.encode(_listaTarefas);
    var file = await File("$caminho").writeAsString(dados);

    //arquivo.
  }

  _lerArquivo() async {
    try {
      var caminho = await _getPath();
      print(caminho);
      //File(caminho).delete();
      File(caminho).readAsString().then((dados) {
        setState(() {
          print(json.decode(dados).runtimeType);
          print(dados);
          _listaTarefas = json.decode(dados);
        });
      });
    } catch (e) {
      return e;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo();
  }

  @override
  Widget build(BuildContext context) {
    //_salvarArquivo();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
          //padding: EdgeInsets.all(15),
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _listaTarefas.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(_listaTarefas[index]["titulo"]),
                        value: _listaTarefas[index]["realizada"],
                        onChanged: (value) {
                          setState(() {
                            _listaTarefas[index]["realizada"] = value;
                          });
                          _salvarArquivo();
                          print("VAlor alterado: ${value.toString()}");
                        });
                    //return ListTile(
                    //  title: Text(_listaTarefas[index]["titulo"]),
                    //);
                  }),
            )
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _tarefaController,
                    decoration:
                        InputDecoration(labelText: "Digite sua tarefa:"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.blue),
                        )),
                    FlatButton(
                        onPressed: () {
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                );
              });
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
