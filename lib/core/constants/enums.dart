enum SortTypeEnum { byModifiedDate, byTitle, byFavorite }

enum HiveBoxEnum {
  musicPlayer("music_player"),
  tracksList("tracks_list_directory_box");

  final String value;
  const HiveBoxEnum(this.value);
}
