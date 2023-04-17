class Record {
  int _id = -1;
  String _content = '';

  Record.fromData(id, content){
    _id = id;
    _content = content;
  }
  String get content => _content;

  set content(String val){
    _content = val;
  }

  set id(int val){
    _id  = val;
  }
}