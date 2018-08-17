module ct_files;

import std.file;
import std.json;

struct CTAsset {
  static CTAsset make(string _path, string _type, string _name)() {
    CTAsset res;

    res.type = _type;
    res.name = _name;
    res.text = import(_path);

    return res;
  }

  string type;
  string name;
  string text;
}

immutable CTAsset[] static_assets = () {
  enum jval = parseJSON(import("assets/assets.json"));
  CTAsset[] ctfs;

  static foreach(type; ["textures", "audio"])
  static foreach(n; 0 .. jval[type].array.length) {
    // Additional bracket level to avoid name collision
    {
      enum path = jval[type][n]["path"].str;
      enum name = jval[type][n]["name"].str;
      ctfs ~= CTAsset.make!(path, type, name);
    }
  }

  return ctfs;
}();
