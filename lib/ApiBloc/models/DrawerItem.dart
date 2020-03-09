class DrawerItem {
    final String imagePath;
    final String title;
    bool isSelected = false;
    String selectedImage;

  DrawerItem(this.imagePath, this.title, {String selectedImage}){
  this.selectedImage= selectedImage!=null? selectedImage: this.imagePath;
  }
}