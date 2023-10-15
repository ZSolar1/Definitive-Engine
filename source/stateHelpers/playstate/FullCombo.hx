package stateHelpers.playstate;

class FullCombo{
    public var id:Int = 0;
    public var str:String = '';
    public function new(id:Int = 0){
        this.id = id;
        updateString();
    }
    public function changeFC(amt:Int){
        var oldID:Int = id;
        id += amt;
        if (id > 4 || id < 0){
            id = oldID;
        }
        updateString();
    }
    public function setFC(id:Int){
        this.id = id;
        updateString();
    }
    function updateString(){
        if (id == 0){
            str = 'SFC';
        }
        if (id == 1){
            str = 'GFC';
        }
        if (id == 2){
            str = 'FC';
        }
        if (id == 3){
            str = 'SDCB';
        }
        if (id == 4){
            str = 'Clear';
        }
        if (id > 4 || id < 0){
            str = 'N/A';
        }
    }
}