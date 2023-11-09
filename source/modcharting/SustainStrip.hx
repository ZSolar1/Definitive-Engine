package modcharting;

import statehelpers.playstate.Note;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import openfl.geom.Vector3D; 
import flixel.FlxStrip;

class SustainStrip extends FlxStrip
{
    private static var noteUV:Array<Float> = [
        0,0, //top left
        1,0, //top right 
        0,1, //bottom left
        1,1, //bottom right 
    ];
    private static var noteIndices:Array<Int> = [
        0,1,2,1,3,2
        //makes 4 triangles
    ];

    private var daNote:Note;

    public var subdivides:Int = 2;

    override public function new(daNote:Note, subdivides:Int = 1)
    {
        this.daNote = daNote;
        this.subdivides = subdivides;
        if (this.subdivides == 0){
            noteUV = [
                0,0, //top left
                1,0, //top right 
                0,1, //bottom left
                1,1, //bottom right 
            ];
            noteIndices = [
                0,1,2,1,3,2
                //makes 4 triangles
            ];
        }
        if (this.subdivides == 1){
            noteUV = [
                0,0, //top left
                1,0, //top right
                0,0.5, //half left
                1,0.5, //half right    
                0,1, //bottom left
                1,1, //bottom right 
            ];
            noteIndices = [
                0,1,2,1,3,2, 2,3,4,3,4,5
                //makes 4 triangles
            ];
        }
        daNote.alpha = 1;
        super(0,0);
        loadGraphic(daNote.updateFramePixels());
        shader = daNote.shader;
        for (uv in noteUV)
        {
            uvtData.push(uv);
            vertices.push(0);
        }
        for (ind in noteIndices)
            indices.push(ind);
    }

    public function constructVertices(noteData:NotePositionData, thisNotePos:Vector3D, nextHalfNotePos:NotePositionData, nextNotePos:NotePositionData, flipGraphic:Bool, reverseClip:Bool)
    {
        
        var yOffset = 2; //fix small gaps
        if (reverseClip)
            yOffset = -yOffset;

        var verts:Array<Float> = [];
        
        if (flipGraphic)
        {
            if (subdivides == 0){
            verts.push(nextNotePos.x);
            verts.push(nextNotePos.y+yOffset); //slight offset to fix small gaps
            verts.push(nextNotePos.x+(daNote.frameWidth*(1/-nextNotePos.z)*noteData.scaleX));
            verts.push(nextNotePos.y+yOffset);

            verts.push(thisNotePos.x);
            verts.push(thisNotePos.y);
            verts.push(thisNotePos.x+(daNote.frameWidth*(1/-thisNotePos.z)*nextNotePos.scaleX));
            verts.push(thisNotePos.y);
            }
            if (subdivides == 1){
                verts.push(nextNotePos.x);
                verts.push(nextNotePos.y+yOffset); //slight offset to fix small gaps
                verts.push(nextNotePos.x+(daNote.frameWidth*(1/-nextNotePos.z)*noteData.scaleX));
                verts.push(nextNotePos.y+yOffset);

                verts.push(nextHalfNotePos.x);
                verts.push(nextHalfNotePos.y);
                verts.push(nextHalfNotePos.x+(daNote.frameWidth*(1/-nextHalfNotePos.z)*noteData.scaleX));
                verts.push(nextHalfNotePos.y);
    
                verts.push(thisNotePos.x);
                verts.push(thisNotePos.y);
                verts.push(thisNotePos.x+(daNote.frameWidth*(1/-thisNotePos.z)*nextNotePos.scaleX));
                verts.push(thisNotePos.y);
                
            }
        }
        else
        {
            if (subdivides == 0){
            verts.push(thisNotePos.x);//0
            verts.push(thisNotePos.y);//1
            verts.push(thisNotePos.x+(daNote.frameWidth*(1/-thisNotePos.z)*noteData.scaleX));//2
            verts.push(thisNotePos.y);//3

            verts.push(nextNotePos.x);//8
            verts.push(nextNotePos.y+yOffset); //slight offset to fix small gaps | 9
            verts.push(nextNotePos.x+(daNote.frameWidth*(1/-nextNotePos.z)*nextNotePos.scaleX));//10
            verts.push(nextNotePos.y+yOffset);//11
            }
            if (subdivides == 1){
                verts.push(thisNotePos.x);//0
                verts.push(thisNotePos.y);//1
                verts.push(thisNotePos.x+(daNote.frameWidth*(1/-thisNotePos.z)*noteData.scaleX));//2
                verts.push(thisNotePos.y);//3

                verts.push(nextHalfNotePos.x);
                verts.push(nextHalfNotePos.y);
                verts.push(nextHalfNotePos.x+(daNote.frameWidth*(1/-nextHalfNotePos.z)*noteData.scaleX));
                verts.push(nextHalfNotePos.y);
    
                verts.push(nextNotePos.x);//8
                verts.push(nextNotePos.y+yOffset); //slight offset to fix small gaps | 9
                verts.push(nextNotePos.x+(daNote.frameWidth*(1/-nextNotePos.z)*nextNotePos.scaleX));//10
                verts.push(nextNotePos.y+yOffset);//11
            }
        }
        vertices = new DrawData(12, true, verts);
    }
}