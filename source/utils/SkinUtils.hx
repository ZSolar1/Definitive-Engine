package utils;

import sys.FileSystem;

class SkinUtils{
    public function getSkinnedAsset(assetName:String, fullAssetPath:String, folder:String, ?subfolder:String){
        for (skin in FileSystem.readDirectory('skins/')){
            try{
                if (FileSystem.exists('skins/$skin/$folder/$subfolder/$assetName')){
                    return 'skins/$skin/$folder/$subfolder/$assetName';
                }else{
                    try{
                        return fullAssetPath;
                    }catch(e){
                        throw 'Asset ID of $fullAssetPath does not exist.';
                    }
                }

            }catch(e){
                if (FileSystem.exists('skins/$skin/$folder/$assetName')){
                    return 'skins/$skin/$folder/$subfolder/$assetName';
                }else{
                    try{
                        return fullAssetPath;
                    }catch(e){
                        throw 'Asset ID of $fullAssetPath does not exist.';
                    }
                }

            }
        }
        return '';
    }
}

class StaticSkinUtils{
    public static function getSkinnedAsset(assetName:String, fullAssetPath:String, folder:String, ?subfolder:String){
        if (FileSystem.exists('skins/')){
        for (skin in FileSystem.readDirectory('skins/')){
            try{
                if (FileSystem.exists('skins/$skin/$folder/$subfolder/$assetName')){
                    return 'skins/$skin/$folder/$subfolder/$assetName';
                }else{
                    try{
                        return fullAssetPath;
                    }catch(e){
                        throw 'Asset ID of $fullAssetPath does not exist.';
                    }
                }

            }catch(e){
                if (FileSystem.exists('skins/$skin/$folder/$assetName')){
                    return 'skins/$skin/$folder/$subfolder/$assetName';
                }else{
                    try{
                        return fullAssetPath;
                    }catch(e){
                        throw 'Asset ID of $fullAssetPath does not exist.';
                    }
                }

            }
        }
    }else{
        try{
            return fullAssetPath;
        }catch(e){
            throw 'Asset ID of $fullAssetPath does not exist.';
        }
    }
    return '';
    }
}