String handleHtmlCode(htmlCode, command, index){
  String twoSpcail = htmlCode.split('ImZGtf mpg5gc')[index + 1];//ToChange
  String three = twoSpcail.split('WsMG1c nnK0zc')[1];
  String four = three.split('title="')[1];
  if (command == 'name'){
    return four.split('">')[0].toLowerCase();
  }
  else {
    return twoSpcail.split('href="/store/apps/details?id=')[1].split('"')[0];
  }
}