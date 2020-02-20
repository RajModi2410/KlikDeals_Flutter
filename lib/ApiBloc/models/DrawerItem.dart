class DrawerItem {
    final String imagePath;
    final String title;
    bool isSelected = false;
    String selecteImage;

  DrawerItem(this.imagePath, this.title, {String selecteImage}){
  this.selecteImage= selecteImage!=null? selecteImage: this.imagePath;
  }
}