{ config, options, lib, diskoLib, parent, device, ... }:
{
  options = {
    type = lib.mkOption {
      type = lib.types.enum [ "image" ];
      internal = true;
      description = "Type";
    };
    device = lib.mkOption {
      type = lib.types.str;
      default = device;
      description = "Device to use";
    };
    imageFile = lib.mkOption {
      type = diskoLib.optionTypes.absolute-pathname;
      default = null;
      description = "Path to the file which contains the image file to copy to the device";
      example = "/tmp/disk.img";
    };
    _parent = lib.mkOption {
      internal = true;
      default = parent;
    };
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      type = lib.types.functionTo diskoLib.jsonType;
      default = _dev: { };
      description = "Metadata";
    };
    _create = diskoLib.mkCreateOption {
      inherit config options;
      default = ''
        # overwrite the device only if it appears to be empty
        if ! (blkid '${config.device}' -o export | grep -q '^TYPE='); then
          cp "${config.imageFile}" "${config.device}"
        fi
      '';
    };
    _mount = diskoLib.mkMountOption {
      inherit config options;
      default = { };
    };
    _config = lib.mkOption {
      internal = true;
      readOnly = true;
      default = [ ];
      description = "NixOS configuration";
    };
    _pkgs = lib.mkOption {
      internal = true;
      readOnly = true;
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = _pkgs: [];
      description = "Packages";
    };
  };
}
